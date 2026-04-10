codeunit 96801 "Gen Journal Import Mgt."
{
    procedure ImportFromExcel(var GenJnlLine: Record "Gen. Journal Line")
    var
        TempExcelBuffer: Record "Excel Buffer" temporary;
        TempBlob: Codeunit "Temp Blob";
        UploadInStream: InStream;
        ExcelInStream: InStream;
        OutStr: OutStream;
        FileName: Text;
        SheetName: Text;
        LastRowNo: Integer;
        PreviewRec: Record "FRE Import Preview v2" temporary;
        HasErrors: Boolean;
        JournalTemplateName: Code[10];
        JournalBatchName: Code[10];
        PreviewLoadMgt: Codeunit "Preview Load Mgt.";
    begin
        ResolveGenJournalContext(GenJnlLine, JournalTemplateName, JournalBatchName);

        UploadIntoStream(
            'Seleccione un fichero Excel',
            '',
            'Excel files (*.xlsx)|*.xlsx',
            FileName,
            UploadInStream);

        TempBlob.CreateOutStream(OutStr);
        CopyStream(OutStr, UploadInStream);

        TempBlob.CreateInStream(ExcelInStream);
        SheetName := TempExcelBuffer.SelectSheetsNameStream(ExcelInStream);

        if SheetName = '' then
            Error('No se ha seleccionado ninguna hoja.');

        TempBlob.CreateInStream(ExcelInStream);
        TempExcelBuffer.OpenBookStream(ExcelInStream, SheetName);
        TempExcelBuffer.ReadSheet();

        ValidateHeaders(TempExcelBuffer);

        LastRowNo := GetLastRowNo(TempExcelBuffer);

        if LastRowNo < 2 then
            Error('El fichero Excel no contiene líneas para importar.');

        BuildPreview(TempExcelBuffer, PreviewRec, HasErrors);
        Commit();

        if not ReviewPreviewForGenJournal(PreviewRec) then
            exit;

        ImportPreviewToGenJournal(PreviewRec, JournalTemplateName, JournalBatchName);

        if Confirm('¿Desea abrir el diario cargado?', false) then
            PreviewLoadMgt.OpenImportedJournal('GEN', JournalTemplateName, JournalBatchName);

        Message('Importación completada correctamente.');
    end;



    local procedure ValidateLine(var GenJnlLine: Record "Gen. Journal Line")
    begin
        GenJnlLine.TestField("Posting Date");
        GenJnlLine.TestField("Document No.");
        GenJnlLine.TestField("Account No.");

        if GenJnlLine."FRE Integration" then begin
            if (GenJnlLine."FRE Fixed Real Estate No." = '') and (GenJnlLine."FRE FA No." = '') then
                Error(FixedAssetOrRealEstateRequiredErr);

            GenJnlLine.TestField("Entry Category");
            GenJnlLine.TestField("Row No.");
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

        if Buffer."FRE Integration" and (Buffer."FRE Fixed Real Estate No." = '') then begin
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
                    Error(ThereAreLinesWithErrorErr);

                GenJnlLine.Init();

                GenJnlLine."Posting Date" := TempBuffer."Posting Date";
                GenJnlLine."Document No." := TempBuffer."Document No.";
                GenJnlLine."Account No." := TempBuffer."Account No.";
                GenJnlLine.Description := TempBuffer.Description;
                GenJnlLine.Amount := TempBuffer.Amount;

                // FRE
                if TempBuffer."FRE Integration" then begin
                    GenJnlLine."FRE Integration" := true;
                    GenJnlLine."FRE Fixed Real Estate No." := TempBuffer."FRE Fixed Real Estate No.";
                end;

                GenJnlLine.Insert(true);

            until TempBuffer.Next() = 0;
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
            GenJnlLine."FRE Fixed Real Estate No." := GetText(ExcelBuffer, RowNo, 11);
            GenJnlLine."FRE FA No." := GetText(ExcelBuffer, RowNo, 12);
            GenJnlLine."FRE Entry Category" := GetFRECategory(GetText(ExcelBuffer, RowNo, 13));
            GenJnlLine."FRE Row No." := GetText(ExcelBuffer, RowNo, 14);
        end;

        ValidateLine(GenJnlLine);

        GenJnlLine.Insert(true);
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

        Error(InvalidFRECategoryErr, Value);
    end;

    local procedure CheckJournalContext(var GenJnlLine: Record "Gen. Journal Line")
    var
        FREExcelTemplateSetup: Record "FRE Excel Template Setup";
        JournalTemplateName: Code[10];
        JournalBatchName: Code[10];
    begin
        JournalTemplateName := GenJnlLine.GetRangeMax("Journal Template Name");
        JournalBatchName := GenJnlLine.GetRangeMax("Journal Batch Name");

        if FREExcelTemplateSetup.Get('SETUP') then begin
            if (JournalTemplateName = '') and (FREExcelTemplateSetup."Default Gen. Journal Template" <> '') then
                JournalTemplateName := FREExcelTemplateSetup."Default Gen. Journal Template";

            if (JournalBatchName = '') and (FREExcelTemplateSetup."Default Gen. Journal Batch" <> '') then
                JournalBatchName := FREExcelTemplateSetup."Default Gen. Journal Batch";
        end;

        if JournalTemplateName = '' then
            Error(GenTemplateRequiredErr);

        if JournalBatchName = '' then
            Error(GenBatchRequiredErr);

        // GenJnlLine.SetRange("Journal Template Name", JournalTemplateName);
        // GenJnlLine.SetRange("Journal Batch Name", JournalBatchName);

        // GenJnlLine.TestField("Account Type");
        // GenJnlLine.TestField("Account No.");
    end;
        
    local procedure ValidateHeaders(var TempExcelBuffer: Record "Excel Buffer" temporary)
    begin
        CheckHeaderCell(TempExcelBuffer, 1, 1, 'Date');
        CheckHeaderCell(TempExcelBuffer, 1, 2, 'Document Type');
        CheckHeaderCell(TempExcelBuffer, 1, 3, 'Document No.');
        CheckHeaderCell(TempExcelBuffer, 1, 4, 'Line Type');
        CheckHeaderCell(TempExcelBuffer, 1, 5, 'Fixed Real Estate Description');
        CheckHeaderCell(TempExcelBuffer, 1, 6, 'Description');
        CheckHeaderCell(TempExcelBuffer, 1, 7, 'Description Row No.');
        CheckHeaderCell(TempExcelBuffer, 1, 8, 'Amount');
    end;

   local procedure CheckHeaderCell(var TempExcelBuffer: Record "Excel Buffer" temporary; RowNo: Integer; ColNo: Integer; ExpectedText: Text)
    var
        CurrentValue: Text;
    begin
        CurrentValue := GetCellValue(TempExcelBuffer, RowNo, ColNo);
        if CurrentValue <> ExpectedText then
            Error(
                'Cabecera incorrecta en columna %1. Esperado: %2. Actual: %3',
                ColNo,
                ExpectedText,
                CurrentValue);
    end;

    local procedure GetCellValue(var TempExcelBuffer: Record "Excel Buffer" temporary; RowNo: Integer; ColNo: Integer): Text
    begin
        TempExcelBuffer.Reset();
        TempExcelBuffer.SetRange("Row No.", RowNo);
        TempExcelBuffer.SetRange("Column No.", ColNo);

        if TempExcelBuffer.FindFirst() then
            exit(TempExcelBuffer."Cell Value as Text");

        exit('');
    end;
    
    local procedure GetLastRowNo(var TempExcelBuffer: Record "Excel Buffer" temporary): Integer
    begin
        TempExcelBuffer.Reset();

        if TempExcelBuffer.FindLast() then
            exit(TempExcelBuffer."Row No.");

        exit(0);
    end;

    local procedure BuildPreview(var TempExcelBuffer: Record "Excel Buffer" temporary; var PreviewRec: Record "FRE Import Preview v2" temporary; var HasErrors: Boolean)
    var
        AssetSuggestionMgt: Codeunit "FRE Asset Suggestion Mgt.";
        RowNo: Integer;
        LastRowNo: Integer;
        ErrorText: Text[250];
    begin
        HasErrors := false;
        PreviewRec.Reset();
        PreviewRec.DeleteAll();

        LastRowNo := GetLastRowNo(TempExcelBuffer);

        for RowNo := 2 to LastRowNo do begin
            if IsRowEmpty(TempExcelBuffer, RowNo) then
                continue;

            ErrorText := ValidateRow(TempExcelBuffer, RowNo);
            if ErrorText <> '' then
                HasErrors := true;

            FillPreviewRecord(PreviewRec, TempExcelBuffer, RowNo, ErrorText);
            if PreviewRec."Fixed Real Estate No." <> '' then           
                AssetSuggestionMgt.LearnFromPreview(PreviewRec)
            else
                AssetSuggestionMgt.SuggestFixedRealEstate(PreviewRec);
            PreviewRec.Modify();
        end;
    end;
local procedure FillPreviewRecord(var PreviewRec: Record "FRE Import Preview v2" temporary; var TempExcelBuffer: Record "Excel Buffer" temporary; RowNo: Integer; ErrorText: Text[250])
    var
        REFincomeExpensesTemplate: Record "REF Income & Expense Template";
        TempDate: Date;
        TempDecimal: Decimal;
        RowDescription: Text[100];
        FixedRealEstateDescription :  Text[100];
    begin
        PreviewRec.Init();
        PreviewRec."Excel Row No." := RowNo;

        if Evaluate(TempDate, GetCellValue(TempExcelBuffer, RowNo, 1)) then
            PreviewRec.Date := TempDate;

        PreviewRec."Document No." := CopyStr(GetCellValue(TempExcelBuffer, RowNo, 3), 1, MaxStrLen(PreviewRec."Document No."));
        
        FixedRealEstateDescription := CopyStr(GetCellValue(TempExcelBuffer, RowNo, 5), 1, 100);
        PreviewRec."Fixed Real Estate No." := ResolveFixedRealEstateNoByDescription(FixedRealEstateDescription);
        PreviewRec."Fixed Real Estate Description" := FixedRealEstateDescription;

        PreviewRec.Description := CopyStr(GetCellValue(TempExcelBuffer, RowNo, 6), 1, MaxStrLen(PreviewRec.Description));

        RowDescription := CopyStr(GetCellValue(TempExcelBuffer, RowNo, 7), 1, 100);
        PreviewRec."Description Row No. Text" := RowDescription;
        PreviewRec."Row No." := ResolveRowNoByDescription(RowDescription);

        // asignar Entry categoria
        if PreviewRec."Row No." <>'' then begin
            REFincomeExpensesTemplate.reset;
            REFincomeExpensesTemplate.setrange("Row No.",PreviewRec."Row No.");
            if REFincomeExpensesTemplate.FindFirst() then 
                PreviewRec."Entry Category" := REFincomeExpensesTemplate."Entry Category";
        end;

        // Ya no viene Source Type ni Source No.
        // PreviewRec."Source Type" := '';
        // PreviewRec."Source No." := '';

        if Evaluate(TempDecimal, GetCellValue(TempExcelBuffer, RowNo, 8)) then begin
            PreviewRec.Amount := TempDecimal;
            PreviewRec."Amount Including VAT" := TempDecimal;
        end;

        PreviewRec.Error := ErrorText;
        PreviewRec.Insert();
    end;

    local procedure ResolveCustomerNoByName(CustomerName: Text[100]): Code[20]
    var
        Customer: Record Customer;
    begin
        if CustomerName = '' then
            exit('');

        Customer.Reset();
        Customer.SetRange(Name, CustomerName);
        if Customer.FindFirst() then
            exit(Customer."No.");

        exit('');
    end;

    local procedure ResolveFixedRealEstateNoByDescription(FREDescription: Text[100]): Code[20]
    var
        FixedRealEstate: Record "Fixed Real Estate";
    begin
        if FREDescription = '' then
            exit('');

        FixedRealEstate.Reset();
        FixedRealEstate.SetRange(Description, FREDescription);

        if not FixedRealEstate.FindFirst() then
            exit('');

        if FixedRealEstate.Count > 1 then
            exit('');

        exit(FixedRealEstate."No.");
    end;

    local procedure ResolveRowNoByDescription(RowDescription: Text[100]): Code[10]
    var
        REFIncomeExpenseTemplate: Record "REF Income & Expense Template";
    begin
        if RowDescription = '' then
            exit('');

        REFIncomeExpenseTemplate.Reset();
        REFIncomeExpenseTemplate.SetRange(Description, RowDescription);

        if not REFIncomeExpenseTemplate.FindFirst() then
            exit('');

        if REFIncomeExpenseTemplate.Count > 1 then
            exit('');

        exit(REFIncomeExpenseTemplate."Row No.");
    end;

    local procedure InsertPreviewLines(var GenJnlLine: Record "Gen. Journal Line"; var PreviewRec: Record "FRE Import Preview v2")
    var
        NewLine: Record "Gen. Journal Line";
        NextLineNo: Integer;
        AssetSuggestionMgt: Codeunit "FRE Asset Suggestion Mgt.";
        SelectedFRENo: Code[20];
    begin
        NextLineNo := GetNextLineNo(GenJnlLine."Journal Template Name", GenJnlLine."Journal Batch Name");

        PreviewRec.Reset();
        PreviewRec.SetRange(Error, '');

        if PreviewRec.FindSet() then
            repeat
                Clear(NewLine);
                NewLine.Init();

                NewLine."Journal Template Name" := GenJnlLine."Journal Template Name";
                NewLine."Journal Batch Name" := GenJnlLine."Journal Batch Name";
                NewLine."Line No." := NextLineNo;

                NewLine.Validate("Account Type", GenJnlLine."Account Type");
                NewLine.Validate("Account No.", GenJnlLine."Account No.");

                if GenJnlLine."Bal. Account No." <> '' then begin
                    NewLine.Validate("Bal. Account Type", GenJnlLine."Bal. Account Type");
                    NewLine.Validate("Bal. Account No.", GenJnlLine."Bal. Account No.");
                end;

                NewLine.Validate("Posting Date", PreviewRec.Date);
                NewLine.Validate("Document No.", PreviewRec."Document No.");

                SelectedFRENo := PreviewRec."Fixed Real Estate No.";
                if (SelectedFRENo = '') and PreviewRec."Accept Suggestion" then
                    SelectedFRENo := PreviewRec."Suggested FRE No.";

                NewLine.Validate("FRE Integration", true);

                if SelectedFRENo <> '' then
                    NewLine.Validate("FRE Fixed Real Estate No.", SelectedFRENo);

                if GenJnlLine."FRE FA No." <> '' then
                    NewLine.Validate("FRE FA No.", GenJnlLine."FRE FA No.");

                NewLine."FRE Source Type" := GenJnlLine."FRE Source Type";
                NewLine."FRE Source No." := GenJnlLine."FRE Source No.";

                if PreviewRec.Description <> '' then
                    NewLine.Validate(Description, PreviewRec.Description);

                if PreviewRec."Row No." <> '' then begin
                    NewLine.Validate("Row No.", PreviewRec."Row No.");
                    NewLine.Validate("Entry Category", PreviewRec."Entry Category");
                    NewLine.Validate("FRE Row No.", PreviewRec."Row No.");
                    NewLine.Validate("FRE Entry Category", PreviewRec."Entry Category");
                end;

                if PreviewRec."Description Row No. Text" <> '' then
                    NewLine.Validate("Description Row No.", PreviewRec."Description Row No. Text");
                
                NewLine.Validate(Amount, PreviewRec.Amount);

                NewLine.Insert(true);

                // Aprendizaje histórico
                AssetSuggestionMgt.LearnFromPreview(PreviewRec);

                NextLineNo += 10000;
            until PreviewRec.Next() = 0;
    end;
    
    local procedure IsRowEmpty(var TempExcelBuffer: Record "Excel Buffer" temporary; RowNo: Integer): Boolean
    begin
        exit(
            (GetCellValue(TempExcelBuffer, RowNo, 1) = '') and
            (GetCellValue(TempExcelBuffer, RowNo, 2) = '') and
            (GetCellValue(TempExcelBuffer, RowNo, 3) = '') and
            (GetCellValue(TempExcelBuffer, RowNo, 4) = '') and
            (GetCellValue(TempExcelBuffer, RowNo, 5) = '') and
            (GetCellValue(TempExcelBuffer, RowNo, 6) = '') and
            (GetCellValue(TempExcelBuffer, RowNo, 7) = '') and
            (GetCellValue(TempExcelBuffer, RowNo, 8) = ''));
    end;

    local procedure GetNextLineNo(JournalTemplateName: Code[10]; JournalBatchName: Code[10]): Integer
    var
        GenJnlLine2: Record "Gen. Journal Line";
    begin
        GenJnlLine2.SetRange("Journal Template Name", JournalTemplateName);
        GenJnlLine2.SetRange("Journal Batch Name", JournalBatchName);

        if GenJnlLine2.FindLast() then
            exit(GenJnlLine2."Line No." + 10000);

        exit(10000);
    end;

    local procedure ValidateRow(var TempExcelBuffer: Record "Excel Buffer" temporary; RowNo: Integer): Text[250]
    var
        ErrorText: Text[250];
        CellValue: Text;
        TempDate: Date;
        TempDecimal: Decimal;
        GenJnlDocType: Enum "Gen. Journal Document Type";
        FRELineType: Enum "FRE Line Type";
        ResolvedFRENo: Code[20];
        ResolvedRowNo: Code[10];
    begin
        // Date
        CellValue := GetCellValue(TempExcelBuffer, RowNo, 1);
        if CellValue = '' then
            AppendError(ErrorText, 'Date es obligatorio.')
        else
            if not Evaluate(TempDate, CellValue) then
                AppendError(ErrorText, StrSubstNo('Date no es válido: %1.', CellValue));

        // Document Type (opcional)
        // CellValue := GetCellValue(TempExcelBuffer, RowNo, 2);
        // if CellValue <> '' then
        //     if not Evaluate(GenJnlDocType, CellValue) then
        //         AppendError(ErrorText, StrSubstNo('Document Type no es válido: %1.', CellValue));

        // Document No.
        CellValue := GetCellValue(TempExcelBuffer, RowNo, 3);
        if CellValue = '' then
            AppendError(ErrorText, 'Document No. es obligatorio.');

        // Line Type
        // CellValue := GetCellValue(TempExcelBuffer, RowNo, 4);
        // if CellValue = '' then
        //    AppendError(ErrorText, 'Line Type es obligatorio.')
        // else
        //     if not ResolveLineType(CellValue, FRELineType) then
        //         AppendError(ErrorText, StrSubstNo('Line Type no es válido: %1.', CellValue));

        // Fixed Real Estate Description
        CellValue := GetCellValue(TempExcelBuffer, RowNo, 5);
        if CellValue = '' then
            AppendError(ErrorText, 'Fixed Real Estate Description es obligatorio.')
        else begin
            ResolvedFRENo := ResolveFixedRealEstateNoByDescription(CopyStr(CellValue, 1, 100));
            if ResolvedFRENo = '' then
                if HasMultipleFixedRealEstatesByDescription(CopyStr(CellValue, 1, 100)) then
                    AppendError(ErrorText, StrSubstNo('Existen varios activos inmobiliarios con la descripción: %1.', CellValue))
                else
                    AppendError(ErrorText, StrSubstNo('No se encuentra el activo para la descripción: %1.', CellValue));
        end;

        // Description
        CellValue := GetCellValue(TempExcelBuffer, RowNo, 6);
        if CellValue = '' then
            AppendError(ErrorText, 'Description es obligatorio.');

        // Description Row No. (opcional pero recomendable)
        CellValue := GetCellValue(TempExcelBuffer, RowNo, 7);
        if CellValue <> '' then begin
            ResolvedRowNo := ResolveRowNoByDescription(CopyStr(CellValue, 1, 100));
            if ResolvedRowNo = '' then
                if HasMultipleRowsByDescription(CopyStr(CellValue, 1, 100)) then
                    AppendError(ErrorText, StrSubstNo('Existen varias filas para la descripción: %1.', CellValue))
                else
                    AppendError(ErrorText, StrSubstNo('No se encuentra la fila para la descripción: %1.', CellValue));
        end;

        // Amount
        CellValue := GetCellValue(TempExcelBuffer, RowNo, 8);
        if CellValue = '' then
            AppendError(ErrorText, 'Amount es obligatorio.')
        else begin
            if not Evaluate(TempDecimal, CellValue) then
                AppendError(ErrorText, StrSubstNo('Amount no es válido: %1.', CellValue))
            else
                if TempDecimal = 0 then
                    AppendError(ErrorText, 'Amount no puede ser 0.');
        end;

        exit(ErrorText);
    end;

    local procedure AppendError(var ErrorText: Text[250]; NewError: Text)
    begin
        if ErrorText = '' then
            ErrorText := CopyStr(NewError, 1, MaxStrLen(ErrorText))
        else
            ErrorText := CopyStr(ErrorText + ' ' + NewError, 1, MaxStrLen(ErrorText));
    end;

    local procedure HasMultipleFixedRealEstatesByDescription(FREDescription: Text[100]): Boolean
    var
        FixedRealEstate: Record "Fixed Real Estate";
    begin
        if FREDescription = '' then
            exit(false);

        FixedRealEstate.SetRange(Description, FREDescription);
        exit(FixedRealEstate.Count > 1);
    end;

    local procedure HasMultipleRowsByDescription(RowDescription: Text[100]): Boolean
    var
        REFIncomeExpenseTemplate: Record "REF Income & Expense Template";
    begin
        if RowDescription = '' then
            exit(false);

        REFIncomeExpenseTemplate.SetRange(Description, RowDescription);
        exit(REFIncomeExpenseTemplate.Count > 1);
    end;

    procedure BankStatementImportFromExcel(var GenJnlLine: Record "Gen. Journal Line"; var FREBankStatement: Record "FRE Bank Statement")
    begin
        if FREBankStatement."SharePoint URL" = '' then
            Error(BankStatementUrlMissingErr);

        ImportBankStatementFromUrlWithStatement(GenJnlLine, FREBankStatement."SharePoint URL", FREBankStatement);
    end;

    procedure BankStatementImportFromExcelDirect(var GenJnlLine: Record "Gen. Journal Line"; var FREBankStatement: Record "FRE Bank Statement")
    begin
        if FREBankStatement."SharePoint URL" = '' then
            Error(BankStatementUrlMissingErr);

        ImportBankStatementFromUrlWithStatementDirect(GenJnlLine, FREBankStatement."SharePoint URL", FREBankStatement);
    end;

    procedure ImportBankStatementFromStatement(var GenJnlLine: Record "Gen. Journal Line"; var FREBankStatement: Record "FRE Bank Statement")
    begin
        BankStatementImportFromExcel(GenJnlLine, FREBankStatement);
    end;

    procedure ImportBankStatementFromUrl(var GenJnlLine: Record "Gen. Journal Line"; FileUrl: Text)
    var
        TempExcelBuffer: Record "Excel Buffer" temporary;
        TempBlob: Codeunit "Temp Blob";
        ExcelInStream: InStream;
        SheetName: Text;
        LastRowNo: Integer;
        PreviewRec: Record "FRE Import Preview v2" temporary;
        HasErrors: Boolean;
        JournalTemplateName: Code[10];
        JournalBatchName: Code[10];
        PreviewLoadMgt: Codeunit "Preview Load Mgt.";
    begin
        ResolveGenJournalContext(GenJnlLine, JournalTemplateName, JournalBatchName);

        if FileUrl = '' then
            Error(BankStatementUrlRequiredErr);

        LoadBankStatementToTempBlob(FileUrl, TempBlob);

        TempBlob.CreateInStream(ExcelInStream);

        SheetName := TempExcelBuffer.SelectSheetsNameStream(ExcelInStream);
        if SheetName = '' then
            Error(NoSheetSelectedErr);

        TempBlob.CreateInStream(ExcelInStream);
        TempExcelBuffer.OpenBookStream(ExcelInStream, SheetName);
        TempExcelBuffer.ReadSheet();

        ValidateHeaders(TempExcelBuffer);

        LastRowNo := GetLastRowNo(TempExcelBuffer);
        if LastRowNo < 2 then
            Error(NoLinesToImportErr);

        BuildPreview(TempExcelBuffer, PreviewRec, HasErrors);
        Commit();

        if not ReviewPreviewForGenJournal(PreviewRec) then
            exit;

        ImportPreviewToGenJournal(PreviewRec, JournalTemplateName, JournalBatchName);

        if Confirm(OpenImportedJournalQst, false) then
            PreviewLoadMgt.OpenImportedJournal('GEN', JournalTemplateName, JournalBatchName);

        Message('Importación del extracto bancario completada correctamente.');
    end;

    local procedure ImportBankStatementFromUrlWithStatement(var GenJnlLine: Record "Gen. Journal Line"; FileUrl: Text; var FREBankStatement: Record "FRE Bank Statement")
    var
        TempExcelBuffer: Record "Excel Buffer" temporary;
        TempBlob: Codeunit "Temp Blob";
        ExcelInStream: InStream;
        SheetName: Text;
        LastRowNo: Integer;
        PreviewRec: Record "FRE Import Preview v2" temporary;
        HasErrors: Boolean;
        JournalTemplateName: Code[10];
        JournalBatchName: Code[10];
        PreviewLoadMgt: Codeunit "Preview Load Mgt.";
    begin
        ResolveGenJournalContext(GenJnlLine, JournalTemplateName, JournalBatchName);

        if FileUrl = '' then
            Error(BankStatementUrlRequiredErr);

        LoadBankStatementToTempBlob(FileUrl, TempBlob);

        TempBlob.CreateInStream(ExcelInStream);

        SheetName := TempExcelBuffer.SelectSheetsNameStream(ExcelInStream);
        if SheetName = '' then
            Error(NoSheetSelectedErr);

        TempBlob.CreateInStream(ExcelInStream);
        TempExcelBuffer.OpenBookStream(ExcelInStream, SheetName);
        TempExcelBuffer.ReadSheet();

        ValidateHeaders(TempExcelBuffer);

        LastRowNo := GetLastRowNo(TempExcelBuffer);
        if LastRowNo < 2 then
            Error(NoLinesToImportErr);

        BuildPreview(TempExcelBuffer, PreviewRec, HasErrors);
        Commit();

        if not ReviewPreviewForGenJournal(PreviewRec) then
            exit;

        ImportPreviewToGenJournalFromBankStatement(PreviewRec, JournalTemplateName, JournalBatchName, FREBankStatement);

        if Confirm(OpenImportedJournalQst, false) then
            PreviewLoadMgt.OpenImportedJournal('GEN', JournalTemplateName, JournalBatchName);

        FREBankStatement.Imported := true;
        FREBankStatement.Status := FREBankStatement.Status::Imported;
        FREBankStatement.Modify();

        Message('Importación del extracto bancario completada correctamente.');
    end;

    local procedure ImportBankStatementFromUrlWithStatementDirect(var GenJnlLine: Record "Gen. Journal Line"; FileUrl: Text; var FREBankStatement: Record "FRE Bank Statement")
    var
        TempExcelBuffer: Record "Excel Buffer" temporary;
        TempBlob: Codeunit "Temp Blob";
        ExcelInStream: InStream;
        SheetName: Text;
        LastRowNo: Integer;
        PreviewRec: Record "FRE Import Preview v2" temporary;
        HasErrors: Boolean;
        PreviewLoadMgt: Codeunit "Preview Load Mgt.";
    begin
        CheckJournalContext(GenJnlLine);

        if FileUrl = '' then
            Error(BankStatementUrlRequiredErr);

        LoadBankStatementToTempBlob(FileUrl, TempBlob);

        TempBlob.CreateInStream(ExcelInStream);
        SheetName := TempExcelBuffer.SelectSheetsNameStream(ExcelInStream);
        if SheetName = '' then
            Error(NoSheetSelectedErr);

        TempBlob.CreateInStream(ExcelInStream);
        TempExcelBuffer.OpenBookStream(ExcelInStream, SheetName);
        TempExcelBuffer.ReadSheet();

        ValidateHeaders(TempExcelBuffer);

        LastRowNo := GetLastRowNo(TempExcelBuffer);
        if LastRowNo < 2 then
            Error(NoLinesToImportErr);

        BuildPreview(TempExcelBuffer, PreviewRec, HasErrors);
        Commit();

        ImportPreviewToGenJournalFromBankStatement(PreviewRec, GenJnlLine.GetRangeMax("Journal Template Name"), GenJnlLine.GetRangeMax("Journal Batch Name"), FREBankStatement);

        if Confirm(OpenImportedJournalQst, false) then
            PreviewLoadMgt.OpenImportedJournal('GEN', GenJnlLine.GetRangeMax("Journal Template Name"), GenJnlLine.GetRangeMax("Journal Batch Name"));

        FREBankStatement.Imported := true;
        FREBankStatement.Status := FREBankStatement.Status::Imported;
        FREBankStatement.Modify();

        Message('Importación del extracto bancario completada correctamente.');
    end;

    local procedure LoadBankStatementToTempBlob(FileUrl: Text; var TempBlob: Codeunit "Temp Blob")
    begin
        if IsHttpAddress(FileUrl) then begin
            LoadBankStatementFromHttpToTempBlob(FileUrl, TempBlob);
            exit;
        end;

        UploadBankStatementToTempBlob(FileUrl, TempBlob);
    end;

    local procedure IsHttpAddress(FileUrl: Text): Boolean
    var
        LowerUrl: Text;
    begin
        LowerUrl := LowerCase(FileUrl);
        exit((StrPos(LowerUrl, 'http://') = 1) or (StrPos(LowerUrl, 'https://') = 1));
    end;

    local procedure LoadBankStatementFromHttpToTempBlob(FileUrl: Text; var TempBlob: Codeunit "Temp Blob")
    var
        ResponseMessage: HttpResponseMessage;
        Content: HttpContent;
        SourceInStream: InStream;
        TargetOutStream: OutStream;
        Client: HttpClient;
    begin
        if not Client.Get(FileUrl, ResponseMessage) then
            Error(BankStatementConnectErr);

        if not ResponseMessage.IsSuccessStatusCode() then
            Error(BankStatementDownloadErr, ResponseMessage.HttpStatusCode());

        Content := ResponseMessage.Content();
        Content.ReadAs(SourceInStream);

        TempBlob.CreateOutStream(TargetOutStream);
        CopyStream(TargetOutStream, SourceInStream);
    end;

    local procedure UploadBankStatementToTempBlob(FileUrl: Text; var TempBlob: Codeunit "Temp Blob")
    var
        UploadInStream: InStream;
        TargetOutStream: OutStream;
        SelectedFileName: Text;
    begin
        UploadIntoStream(
            'Seleccione el fichero Excel del extracto bancario',
            '',
            'Excel files (*.xlsx)|*.xlsx',
            SelectedFileName,
            UploadInStream);

        if SelectedFileName = '' then
            Error(NoFileSelectedErr);

        TempBlob.CreateOutStream(TargetOutStream);
        CopyStream(TargetOutStream, UploadInStream);
    end;

    procedure ImportBankStatementFromExcel(var GenJnlLine: Record "Gen. Journal Line")
    var
        TempExcelBuffer: Record "Excel Buffer" temporary;
        TempBlob: Codeunit "Temp Blob";
        UploadInStream: InStream;
        ExcelInStream: InStream;
        OutStr: OutStream;
        FileName: Text;
        SheetName: Text;
        LastRowNo: Integer;
        PreviewRec: Record "FRE Import Preview v2" temporary;
        HasErrors: Boolean;
        JournalTemplateName: Code[10];
        JournalBatchName: Code[10];
        PreviewLoadMgt: Codeunit "Preview Load Mgt.";
    begin
        ResolveGenJournalContext(GenJnlLine, JournalTemplateName, JournalBatchName);

        UploadIntoStream(
            'Seleccione un fichero Excel de extracto bancario',
            '',
            'Excel files (*.xlsx)|*.xlsx',
            FileName,
            UploadInStream);

        TempBlob.CreateOutStream(OutStr);
        CopyStream(OutStr, UploadInStream);

        TempBlob.CreateInStream(ExcelInStream);
        SheetName := TempExcelBuffer.SelectSheetsNameStream(ExcelInStream);

        if SheetName = '' then
            Error(NoSheetSelectedErr);

        TempBlob.CreateInStream(ExcelInStream);
        TempExcelBuffer.OpenBookStream(ExcelInStream, SheetName);
        TempExcelBuffer.ReadSheet();

        ValidateHeaders(TempExcelBuffer);

        LastRowNo := GetLastRowNo(TempExcelBuffer);

        if LastRowNo < 2 then
            Error(NoLinesToImportErr);

        BuildPreview(TempExcelBuffer, PreviewRec, HasErrors);
        Commit();

        if not ReviewPreviewForGenJournal(PreviewRec) then
            exit;

        ImportPreviewToGenJournal(PreviewRec, JournalTemplateName, JournalBatchName);

        if Confirm(OpenImportedJournalQst, false) then
            PreviewLoadMgt.OpenImportedJournal('GEN', JournalTemplateName, JournalBatchName);

        Message('Importación del extracto bancario completada correctamente.');
    end;

    local procedure InsertPreviewLinesFromBankStatement(var GenJnlLine: Record "Gen. Journal Line"; var PreviewRec: Record "FRE Import Preview v2"; FREBankStatement: Record "FRE Bank Statement")
    var
        NewLine: Record "Gen. Journal Line";
        NextLineNo: Integer;
        AssetSuggestionMgt: Codeunit "FRE Asset Suggestion Mgt.";
        SelectedFRENo: Code[20];
    begin
        NextLineNo := GetNextLineNo(GenJnlLine."Journal Template Name", GenJnlLine."Journal Batch Name");

        PreviewRec.Reset();
        PreviewRec.SetRange(Error, '');

        if PreviewRec.FindSet() then
            repeat
                Clear(NewLine);
                NewLine.Init();

                NewLine."Journal Template Name" := GenJnlLine."Journal Template Name";
                NewLine."Journal Batch Name" := GenJnlLine."Journal Batch Name";
                NewLine."Line No." := NextLineNo;

                if FREBankStatement."Bank Account No." <> '' then begin
                    NewLine.Validate("Account Type", NewLine."Account Type"::"Bank Account");
                    NewLine.Validate("Account No.", FREBankStatement."Bank Account No.");
                end else begin
                    NewLine.Validate("Account Type", GenJnlLine."Account Type");
                    NewLine.Validate("Account No.", GenJnlLine."Account No.");
                end;

                if FREBankStatement."Bal. Account No." <> '' then begin
                    NewLine.Validate("Bal. Account Type", NewLine."Bal. Account Type"::"G/L Account");
                    NewLine.Validate("Bal. Account No.", FREBankStatement."Bal. Account No.");
                end else
                    if GenJnlLine."Bal. Account No." <> '' then begin
                        NewLine.Validate("Bal. Account Type", GenJnlLine."Bal. Account Type");
                        NewLine.Validate("Bal. Account No.", GenJnlLine."Bal. Account No.");
                    end;

                NewLine.Validate("Posting Date", PreviewRec.Date);
                NewLine.Validate("Document No.", PreviewRec."Document No.");

                SelectedFRENo := PreviewRec."Fixed Real Estate No.";
                if (SelectedFRENo = '') and PreviewRec."Accept Suggestion" then
                    SelectedFRENo := PreviewRec."Suggested FRE No.";

                NewLine.Validate("FRE Integration", true);

                if SelectedFRENo <> '' then
                    NewLine.Validate("FRE Fixed Real Estate No.", SelectedFRENo);

                if GenJnlLine."FRE FA No." <> '' then
                    NewLine.Validate("FRE FA No.", GenJnlLine."FRE FA No.");

                NewLine."FRE Source Type" := GenJnlLine."FRE Source Type";
                NewLine."FRE Source No." := GenJnlLine."FRE Source No.";

                if PreviewRec.Description <> '' then
                    NewLine.Validate(Description, PreviewRec.Description);

                if PreviewRec."Row No." <> '' then begin
                    NewLine.Validate("Row No.", PreviewRec."Row No.");
                    NewLine.Validate("Entry Category", PreviewRec."Entry Category");
                    NewLine.Validate("FRE Row No.", PreviewRec."Row No.");
                    NewLine.Validate("FRE Entry Category", PreviewRec."Entry Category");
                end;

                if PreviewRec."Description Row No. Text" <> '' then
                    NewLine.Validate("Description Row No.", PreviewRec."Description Row No. Text");

                if FREBankStatement."Bank Account No." <> '' then begin
                    NewLine.Validate("Source Type", NewLine."Source Type"::"Bank Account");
                    NewLine.Validate("Source No.", FREBankStatement."Bank Account No.");
                end;

                NewLine.Validate(Amount, PreviewRec.Amount);

                NewLine.Insert(true);

                AssetSuggestionMgt.LearnFromPreview(PreviewRec);

                NextLineNo += 10000;
            until PreviewRec.Next() = 0;
    end;

    procedure ImportPreviewToGenJournal(var PreviewRec: Record "FRE Import Preview v2" temporary; JournalTemplateName: Code[10]; JournalBatchName: Code[10])
    var
        GenJournalBatch: Record "Gen. Journal Batch";
        GenJnlLine: Record "Gen. Journal Line";
    begin
        GenJournalBatch.Get(JournalTemplateName, JournalBatchName);
        GenJnlLine.SetRange("Journal Template Name", JournalTemplateName);
        GenJnlLine.SetRange("Journal Batch Name", JournalBatchName);
        GenJnlLine."Journal Template Name" := JournalTemplateName;
        GenJnlLine."Journal Batch Name" := JournalBatchName;
        InsertPreviewLines(GenJnlLine, PreviewRec);
    end;

    procedure ImportPreviewToGenJournalFromBankStatement(var PreviewRec: Record "FRE Import Preview v2" temporary; JournalTemplateName: Code[10]; JournalBatchName: Code[10]; FREBankStatement: Record "FRE Bank Statement")
    var
        GenJournalBatch: Record "Gen. Journal Batch";
        GenJnlLine: Record "Gen. Journal Line";
    begin
        GenJournalBatch.Get(JournalTemplateName, JournalBatchName);
        GenJnlLine.SetRange("Journal Template Name", JournalTemplateName);
        GenJnlLine.SetRange("Journal Batch Name", JournalBatchName);
        GenJnlLine."Journal Template Name" := JournalTemplateName;
        GenJnlLine."Journal Batch Name" := JournalBatchName;
        InsertPreviewLinesFromBankStatement(GenJnlLine, PreviewRec, FREBankStatement);
    end;

    local procedure SelectPreviewDestination(var PreviewRec: Record "FRE Import Preview v2" temporary; var TargetCode: Text[10]; var JournalTemplateName: Code[10]; var JournalBatchName: Code[10]): Boolean
    var
        FREImportPreviewPage: Page "FRE Import Preview v2";
    begin
        Clear(FREImportPreviewPage);
        FREImportPreviewPage.LoadPreview(PreviewRec);
        FREImportPreviewPage.RunModal();
        FREImportPreviewPage.SavePreview(PreviewRec);
        TargetCode := FREImportPreviewPage.GetSelectedImportTarget();
        JournalTemplateName := FREImportPreviewPage.GetDestinationTemplateName();
        JournalBatchName := FREImportPreviewPage.GetDestinationBatchName();
        exit(TargetCode <> '');
    end;

    local procedure ReviewPreviewForGenJournal(var PreviewRec: Record "FRE Import Preview v2" temporary): Boolean
    var
        FREImportPreviewPage: Page "FRE Import Preview v2";
    begin
        Clear(FREImportPreviewPage);
        FREImportPreviewPage.SetFixedGenJournalContext();
        FREImportPreviewPage.LoadPreview(PreviewRec);
        if FREImportPreviewPage.RunModal() = Action::Cancel then
            exit(false);

        FREImportPreviewPage.SavePreview(PreviewRec);
        exit(true);
    end;

    local procedure ResolveGenJournalContext(var GenJnlLine: Record "Gen. Journal Line"; var JournalTemplateName: Code[10]; var JournalBatchName: Code[10])
    var
        FREExcelTemplateSetup: Record "FRE Excel Template Setup";
    begin
        JournalTemplateName := GenJnlLine.GetRangeMax("Journal Template Name");
        JournalBatchName := GenJnlLine.GetRangeMax("Journal Batch Name");

        if FREExcelTemplateSetup.Get('SETUP') then begin
            if (JournalTemplateName = '') and (FREExcelTemplateSetup."Default Gen. Journal Template" <> '') then
                JournalTemplateName := FREExcelTemplateSetup."Default Gen. Journal Template";

            if (JournalBatchName = '') and (FREExcelTemplateSetup."Default Gen. Journal Batch" <> '') then
                JournalBatchName := FREExcelTemplateSetup."Default Gen. Journal Batch";
        end;

        if JournalTemplateName = '' then
            Error(GenTemplateRequiredErr);

        if JournalBatchName = '' then
            Error(GenBatchRequiredErr);
    end;

    var
        NoSheetSelectedErr: Label 'No se ha seleccionado ninguna hoja.';
        NoLinesToImportErr: Label 'El fichero Excel no contiene líneas para importar.';
        OpenImportedJournalQst: Label '¿Desea abrir el diario cargado?';
        FixedAssetOrRealEstateRequiredErr: Label 'Debe informar inmueble o activo fijo';
        ThereAreLinesWithErrorErr: Label 'Hay líneas con error';
        InvalidFRECategoryErr: Label 'Categoría FRE no válida: %1';
        GenTemplateRequiredErr: Label 'Debe informar la plantilla del diario o configurarla por defecto en "FRE Excel Template Setup".';
        GenBatchRequiredErr: Label 'Debe informar el lote del diario o configurarlo por defecto en "FRE Excel Template Setup".';
        BankStatementUrlMissingErr: Label 'El extracto no tiene URL de SharePoint.';
        BankStatementUrlRequiredErr: Label 'La URL o ruta del extracto bancario es obligatoria.';
        BankStatementConnectErr: Label 'No se ha podido conectar con la URL del extracto.';
        BankStatementDownloadErr: Label 'Error al descargar el extracto. Código HTTP: %1';
        NoFileSelectedErr: Label 'No se ha seleccionado ningún fichero.';

}
