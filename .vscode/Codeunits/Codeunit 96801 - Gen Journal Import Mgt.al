codeunit 96801 "Gen Journal Import Mgt."
{
    procedure ImportFromExcel()
    var
        ExcelBuffer: Record "Excel Buffer" temporary;
        InStr: InStream;
        FileName: Text;
    begin
        UploadIntoStream('Seleccionar Excel', '', '', FileName, InStr);

        ExcelBuffer.OpenBookStream(InStr, '');
        ExcelBuffer.ReadSheet();

        ProcessLines(ExcelBuffer);

        Message('Importación completada');
    end;

    local procedure ProcessLines(var ExcelBuffer: Record "Excel Buffer")
    var
        RowNo: Integer;
    begin
        RowNo := 2;

        while ExcelBuffer.Get(RowNo, 1) do begin
            InsertLine(ExcelBuffer, RowNo);
            RowNo += 1;
        end;
    end;

    local procedure InsertLine(var ExcelBuffer: Record "Excel Buffer"; RowNo: Integer)
    var
        GenJnlLine: Record "Gen. Journal Line";
    begin
        GenJnlLine.Init();

        // CONTABLE
        GenJnlLine."Posting Date" := GetDate(ExcelBuffer, RowNo, 1);
        GenJnlLine."Document No." := GetText(ExcelBuffer, RowNo, 3);
        GenJnlLine."Account No." := GetText(ExcelBuffer, RowNo, 5);
        GenJnlLine.Description := GetText(ExcelBuffer, RowNo, 8);
        GenJnlLine.Amount := GetDecimal(ExcelBuffer, RowNo, 9);

        // FRE
        if GetBoolean(ExcelBuffer, RowNo, 10) then begin
            GenJnlLine."FRE Integration" := true;
            GenJnlLine."FRE Real Estate No." := GetText(ExcelBuffer, RowNo, 11);
            GenJnlLine."FRE FA No." := GetText(ExcelBuffer, RowNo, 12);
            GenJnlLine."FRE Entry Category" := GetFRECategory(GetText(ExcelBuffer, RowNo, 13));
            GenJnlLine."FRE Row No." := GetText(ExcelBuffer, RowNo, 14);
        end;

        ValidateLine(GenJnlLine);

        GenJnlLine.Insert(true);
    end;

    local procedure ValidateLine(var GenJnlLine: Record "Gen. Journal Line")
    begin
        GenJnlLine.TestField("Posting Date");
        GenJnlLine.TestField("Document No.");
        GenJnlLine.TestField("Account No.");

        if GenJnlLine."FRE Integration" then begin
            if (GenJnlLine."FRE Real Estate No." = '') and (GenJnlLine."FRE FA No." = '') then
                Error('Debe informar inmueble o activo fijo');

            GenJnlLine.TestField("FRE Entry Category");
            GenJnlLine.TestField("FRE Row No.");
        end;
    end;

    local procedure ValidatePreviewLine(var Buffer: Record "Gen Journal Import Buffer")
    begin
        Buffer.Status := Buffer.Status::OK;

        if Buffer."Posting Date" = 0D then begin
            Buffer.Status := Buffer.Status::Error;
            Buffer.Message := 'Falta fecha';
        end;

        if Buffer."Account No." = '' then begin
            Buffer.Status := Buffer.Status::Error;
            Buffer.Message := 'Falta cuenta';
        end;

        if Buffer."FRE Integration" and (Buffer."FRE Real Estate No." = '') then begin
            Buffer.Status := Buffer.Status::Warning;
            Buffer.Message := 'Falta inmueble (se intentará derivar)';
        end;
    end;

    procedure CommitImport(var TempBuffer: Record "Gen Journal Import Buffer")
    var
        GenJnlLine: Record "Gen. Journal Line";
    begin
        if TempBuffer.FindSet() then
            repeat
                if TempBuffer.Status = TempBuffer.Status::Error then
                    Error('Hay líneas con error');

                GenJnlLine.Init();

                GenJnlLine."Posting Date" := TempBuffer."Posting Date";
                GenJnlLine."Document No." := TempBuffer."Document No.";
                GenJnlLine."Account No." := TempBuffer."Account No.";
                GenJnlLine.Description := TempBuffer.Description;
                GenJnlLine.Amount := TempBuffer.Amount;

                // FRE
                if TempBuffer."FRE Integration" then begin
                    GenJnlLine."FRE Integration" := true;
                    GenJnlLine."FRE Real Estate No." := TempBuffer."FRE Real Estate No.";
                end;

                GenJnlLine.Insert(true);

            until TempBuffer.Next() = 0;
    end;

    local procedure GetText(var ExcelBuffer: Record "Excel Buffer" temporary; RowNo: Integer; ColumnNo: Integer): Text
    begin
        if ExcelBuffer.Get(RowNo, ColumnNo) then
            exit(ExcelBuffer."Cell Value as Text");

        exit('');
    end;

    local procedure GetDate(var ExcelBuffer: Record "Excel Buffer" temporary; RowNo: Integer; ColumnNo: Integer): Date
    var
        CellValue: Text;
        ResultDate: Date;
    begin
        CellValue := GetText(ExcelBuffer, RowNo, ColumnNo);

        if CellValue = '' then
            exit(0D);

        Evaluate(ResultDate, CellValue);
        exit(ResultDate);
    end;

    local procedure GetDecimal(var ExcelBuffer: Record "Excel Buffer" temporary; RowNo: Integer; ColumnNo: Integer): Decimal
    var
        CellValue: Text;
        ResultDecimal: Decimal;
    begin
        CellValue := GetText(ExcelBuffer, RowNo, ColumnNo);

        if CellValue = '' then
            exit(0);

        Evaluate(ResultDecimal, CellValue);
        exit(ResultDecimal);
    end;

    local procedure GetBoolean(var ExcelBuffer: Record "Excel Buffer" temporary; RowNo: Integer; ColumnNo: Integer): Boolean
    var
        CellValue: Text;
    begin
        CellValue := UpperCase(DelChr(GetText(ExcelBuffer, RowNo, ColumnNo), '=', ' '));

        exit(
            (CellValue = 'TRUE') or
            (CellValue = 'YES') or
            (CellValue = 'SI') or
            (CellValue = 'SÍ') or
            (CellValue = '1'));
    end;

    local procedure GetFRECategory(Value: Text): Enum "FRE Entry Category"
    var
        CleanValue: Text;
    begin
        CleanValue := UpperCase(DelChr(Value, '=', ' '));

        case CleanValue of
            '', 'UNDEFINED', 'NO DEFINIDO':
                exit(Enum::"FRE Entry Category"::Undefined);

            'RENT', 'ALQUILER':
                exit(Enum::"FRE Entry Category"::Rent);

            'DEPOSIT', 'DEPOSITO', 'DEPÓSITO', 'FIANZA':
                exit(Enum::"FRE Entry Category"::Deposit);

            'COMMUNITY FEES', 'COMMUNITYFEES', 'GASTOS COMUNIDAD', 'COMUNIDAD':
                exit(Enum::"FRE Entry Category"::CommunityFees);

            'INSURANCE', 'SEGURO':
                exit(Enum::"FRE Entry Category"::Insurance);

            'TAX', 'IMPUESTO', 'IMPUESTOS':
                exit(Enum::"FRE Entry Category"::Tax);

            'MAINTENANCE', 'MANTENIMIENTO':
                exit(Enum::"FRE Entry Category"::Maintenance);

            'SUPPLIES', 'SUMINISTROS':
                exit(Enum::"FRE Entry Category"::Supplies);

            'REPAIR', 'REPARACION', 'REPARACIÓN':
                exit(Enum::"FRE Entry Category"::Repair);

            'OTHER INCOME', 'OTHERINCOME', 'OTROS INGRESOS':
                exit(Enum::"FRE Entry Category"::OtherIncome);

            'OTHER EXPENSE', 'OTHEREXPENSE', 'OTROS GASTOS':
                exit(Enum::"FRE Entry Category"::OtherExpense);

            'COLLECTION', 'COBRO', 'COBROS':
                exit(Enum::"FRE Entry Category"::Collection);

            'PAYMENT', 'PAGO', 'PAGOS':
                exit(Enum::"FRE Entry Category"::Payment);
        end;

        Error('Categoría FRE no válida: %1', Value);
    end;

}