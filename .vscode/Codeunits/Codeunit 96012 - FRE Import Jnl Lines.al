codeunit 96012 "FRE Import Jnl. Lines"
{
    procedure DownloadTemplate()
    var
        TemplateSetup: Record "FRE Excel Template Setup";
        InStr: InStream;
        DownloadFileName: Text;
    begin
        TemplateSetup.Get('SETUP');
        TemplateSetup.CalcFields("Journal Template File");

        if not TemplateSetup."Journal Template File".HasValue then
            Error(NoTemplateUploadedErr);

        TemplateSetup."Journal Template File".CreateInStream(InStr);

        DownloadFileName := 'FRE_Journal_Template.xlsx';
        DownloadFromStream(InStr, '', '', '', DownloadFileName);
    end;

    procedure ImportFromExcel(var FREJnlLine: Record "FRE Jnl. Line")
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
        TargetCode: Text[10];
        JournalTemplateName: Code[10];
        JournalBatchName: Code[10];
        PreviewLoadMgt: Codeunit "Preview Load Mgt.";
    begin
        CheckJournalContext(FREJnlLine);

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
            Error(NoSheetSelectedErr);

        TempBlob.CreateInStream(ExcelInStream);
        TempExcelBuffer.OpenBookStream(ExcelInStream, SheetName);
        TempExcelBuffer.ReadSheet();

        ValidateHeaders(TempExcelBuffer);

        LastRowNo := GetLastRowNo(TempExcelBuffer);

        if LastRowNo < 2 then
            Error(NoLinesToImportErr);

        BuildPreview(TempExcelBuffer, PreviewRec, HasErrors);
        commit;

        if not SelectPreviewDestination(PreviewRec, TargetCode, JournalTemplateName, JournalBatchName) then
            exit;

        // if HasErrors then
        //     Error('No se puede importar porque existen errores en el fichero.');

        if TargetCode = 'FRE' then
            ImportPreviewToFREJournal(PreviewRec, JournalTemplateName, JournalBatchName)
        else
            PreviewLoadMgt.ImportPreviewToGenJournal(PreviewRec, JournalTemplateName, JournalBatchName);

        if Confirm(OpenImportedJournalQst, false) then
            PreviewLoadMgt.OpenImportedJournal(TargetCode, JournalTemplateName, JournalBatchName);

        Message('Importación completada correctamente.');
    end;

    procedure DownloadStoredTemplateForTest()
    var
        TemplateSetup: Record "FRE Excel Template Setup";
        InStr: InStream;
    begin
        TemplateSetup.Get('SETUP');
        TemplateSetup.CalcFields("Journal Template File");

        if not TemplateSetup."Journal Template File".HasValue then
            Error(NoTemplateUploadedErr);

        TemplateSetup."Journal Template File".CreateInStream(InStr);

        DownloadFromStream(InStr, '', '', '', TemplateSetup."Template File Name");
    end;

    procedure TestOpenStoredTemplate()
    var
        ExcelBuffer: Record "Excel Buffer" temporary;
        TemplateSetup: Record "FRE Excel Template Setup";
        BlobInStr: InStream;
        TempBlob: Codeunit "Temp Blob";
        TempOutStr: OutStream;
        TempInStr: InStream;
    begin
        TemplateSetup.Get('SETUP');
        TemplateSetup.CalcFields("Journal Template File");

        TemplateSetup."Journal Template File".CreateInStream(BlobInStr);

        TempBlob.CreateOutStream(TempOutStr);
        CopyStream(TempOutStr, BlobInStr);

        TempBlob.CreateInStream(TempInStr);

        ExcelBuffer.OpenBookStream(TempInStr, 'Fixed Real Estate');

        Message('La plantilla se ha abierto correctamente.');
    end;


    local procedure LoadBaseTemplateToTempBlob(var TempBlob: Codeunit "Temp Blob")
    var
        TemplateSetup: Record "FRE Excel Template Setup";
        BlobInStr: InStream;
        TempOutStr: OutStream;
    begin
        if not TemplateSetup.Get('SETUP') then
            Error(ExcelTemplateSetupMissingErr);

        TemplateSetup.CalcFields("Journal Template File");

        if not TemplateSetup."Journal Template File".HasValue then
            Error(NoExcelTemplateConfiguredErr);

        TemplateSetup."Journal Template File".CreateInStream(BlobInStr);

        TempBlob.CreateOutStream(TempOutStr);
        CopyStream(TempOutStr, BlobInStr);
    end;


    local procedure FillFixedRealEstateSheet(var ExcelBuffer: Record "Excel Buffer" temporary)
    var
        FixedRealEstate: Record "Fixed Real Estate";
    begin
        ExcelBuffer.SelectOrAddSheet('Fixed Real Estate');

        ExcelBuffer.NewRow();
        ExcelBuffer.AddColumn('No.', false, '', true, false, false, '', ExcelBuffer."Cell Type"::Text);
        ExcelBuffer.AddColumn('Description', false, '', true, false, false, '', ExcelBuffer."Cell Type"::Text);

        if FixedRealEstate.FindSet() then
            repeat
                ExcelBuffer.NewRow();
                ExcelBuffer.AddColumn(FixedRealEstate."No.", false, '', false, false, false, '', ExcelBuffer."Cell Type"::Text);
                ExcelBuffer.AddColumn(FixedRealEstate.Description, false, '', false, false, false, '', ExcelBuffer."Cell Type"::Text);
            until FixedRealEstate.Next() = 0;

        ExcelBuffer.WriteSheet('Fixed Real Estate', CompanyName, UserId);
    end;


    local procedure FillSourceTypesSheet(var ExcelBuffer: Record "Excel Buffer" temporary)
    begin
        ExcelBuffer.SelectOrAddSheet('Source Types');

        ExcelBuffer.NewRow();
        ExcelBuffer.AddColumn('Source Type', false, '', true, false, false, '', ExcelBuffer."Cell Type"::Text);

        AddSingleValueRow(ExcelBuffer, 'Customer');
        AddSingleValueRow(ExcelBuffer, 'Vendor');
        AddSingleValueRow(ExcelBuffer, 'Bank Account');
        AddSingleValueRow(ExcelBuffer, 'Fixed Asset');
        AddSingleValueRow(ExcelBuffer, 'Real Estate Asset');
        AddSingleValueRow(ExcelBuffer, 'Employee');

        ExcelBuffer.WriteSheet('Source Types', CompanyName, UserId);
    end;


    local procedure FillLineTypesSheet(var ExcelBuffer: Record "Excel Buffer" temporary)
    begin
        ExcelBuffer.SelectOrAddSheet('Line Types');

        ExcelBuffer.NewRow();
        ExcelBuffer.AddColumn('Line Type', false, '', true, false, false, '', ExcelBuffer."Cell Type"::Text);

        AddSingleValueRow(ExcelBuffer, 'Income');
        AddSingleValueRow(ExcelBuffer, 'Expense');
        AddSingleValueRow(ExcelBuffer, 'Collection');
        AddSingleValueRow(ExcelBuffer, 'Payment');
        AddSingleValueRow(ExcelBuffer, 'Adjustment');

        ExcelBuffer.WriteSheet('Line Types', CompanyName, UserId);
    end;


    local procedure FillHelpSheet(var ExcelBuffer: Record "Excel Buffer" temporary)
    begin
        ExcelBuffer.SelectOrAddSheet('Help');

        ExcelBuffer.NewRow();
        ExcelBuffer.AddColumn('FRE Journal Import Template', false, '', true, false, false, '', ExcelBuffer."Cell Type"::Text);

        ExcelBuffer.NewRow();
        ExcelBuffer.AddColumn('1. Fill the sheet "Journal Lines" with the journal entries.', false, '', false, false, false, '', ExcelBuffer."Cell Type"::Text);

        ExcelBuffer.NewRow();
        ExcelBuffer.AddColumn('2. Use valid values from the helper sheets.', false, '', false, false, false, '', ExcelBuffer."Cell Type"::Text);

        ExcelBuffer.NewRow();
        ExcelBuffer.AddColumn('3. Do not modify the header row.', false, '', false, false, false, '', ExcelBuffer."Cell Type"::Text);

        ExcelBuffer.NewRow();
        ExcelBuffer.AddColumn('4. Mandatory columns: Date, Document No., Line Type, Fixed Real Estate No., Amount.', false, '', false, false, false, '', ExcelBuffer."Cell Type"::Text);

        ExcelBuffer.WriteSheet('Help', CompanyName, UserId);
    end;


    local procedure AddSingleValueRow(var ExcelBuffer: Record "Excel Buffer" temporary; ValueText: Text)
    begin
        ExcelBuffer.NewRow();
        ExcelBuffer.AddColumn(ValueText, false, '', false, false, false, '', ExcelBuffer."Cell Type"::Text);
    end;


   
    local procedure CheckJournalContext(var FREJnlLine: Record "FRE Jnl. Line")
    var
        FREExcelTemplateSetup: Record "FRE Excel Template Setup";
        JournalTemplateName: Code[10];
        JournalBatchName: Code[10];
    begin
        JournalTemplateName := FREJnlLine.GetRangeMax("Journal Template Name");
        JournalBatchName := FREJnlLine.GetRangeMax("Journal Batch Name");

        if FREExcelTemplateSetup.Get('SETUP') then begin
            if (JournalTemplateName = '') and (FREExcelTemplateSetup."Default FRE Journal Template" <> '') then
                JournalTemplateName := FREExcelTemplateSetup."Default FRE Journal Template";

            if (JournalBatchName = '') and (FREExcelTemplateSetup."Default FRE Journal Batch" <> '') then
                JournalBatchName := FREExcelTemplateSetup."Default FRE Journal Batch";
        end;

        if JournalTemplateName = '' then
            Error(FRETemplateRequiredErr);

        if JournalBatchName = '' then
            Error(FREBatchRequiredErr);

    end;
    

    local procedure GetLastRowNo(var TempExcelBuffer: Record "Excel Buffer" temporary): Integer
    begin
        TempExcelBuffer.Reset();

        if TempExcelBuffer.FindLast() then
            exit(TempExcelBuffer."Row No.");

        exit(0);
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


    local procedure GetNextLineNo(JournalTemplateName: Code[10]; JournalBatchName: Code[10]): Integer
    var
        FREJnlLine2: Record "FRE Jnl. Line";
    begin
        FREJnlLine2.SetRange("Journal Template Name", JournalTemplateName);
        FREJnlLine2.SetRange("Journal Batch Name", JournalBatchName);

        if FREJnlLine2.FindLast() then
            exit(FREJnlLine2."Line No." + 10000);

        exit(10000);
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

    local procedure InsertPreviewLines(var FREJnlLine: Record "FRE Jnl. Line"; var PreviewRec: Record "FRE Import Preview v2")
    var
        NewLine: Record "FRE Jnl. Line";
        NextLineNo: Integer;
        FRELineType: Enum "FRE Line Type";
        GenJnlDocType: Enum "Gen. Journal Document Type";
        AssetSuggestionMgt: Codeunit "FRE Asset Suggestion Mgt.";
    begin
        NextLineNo := GetNextLineNo(FREJnlLine."Journal Template Name", FREJnlLine."Journal Batch Name");

        PreviewRec.Reset();
        PreviewRec.SetRange(Error, '');

        if PreviewRec.FindSet() then
            repeat
                Clear(NewLine);
                NewLine.Init();

                NewLine."Journal Template Name" := FREJnlLine."Journal Template Name";
                NewLine."Journal Batch Name" := FREJnlLine."Journal Batch Name";
                NewLine."Line No." := NextLineNo;

                NewLine.Validate(Date, PreviewRec.Date);

                // if PreviewRec."Document Type" <> '' then begin
                //     Evaluate(GenJnlDocType, PreviewRec."Document Type");
                //     NewLine.Validate("Document Type", GenJnlDocType);
                // end;

                NewLine.Validate("Document No.", PreviewRec."Document No.");

                NewLine."Line Type" := NewLine."Line Type" :: Invoice;

                if PreviewRec."Fixed Real Estate No." <> '' then
                    NewLine.Validate("Fixed Real Estate No.", PreviewRec."Fixed Real Estate No.");

               // Aplicar sugerencia de inmueble si el usuario la ha aceptado
                if (PreviewRec."Fixed Real Estate No." = '') and PreviewRec."Accept Suggestion" then
                    PreviewRec."Fixed Real Estate No." := PreviewRec."Suggested FRE No.";

                if PreviewRec.Description <> '' then
                    NewLine.Validate(Description, PreviewRec.Description);

                if PreviewRec."Row No." <> '' then begin
                    NewLine.Validate("Row No.", PreviewRec."Row No.");
                    NewLine.Validate("Entry Category", PreviewRec."Entry Category");
                end;
                if PreviewRec."Description Row No. Text" <> '' then
                    NewLine.Validate("Description Row No.", PreviewRec."Description Row No. Text");
                
                NewLine.Amount := PreviewRec.Amount;
                NewLine."Amount Including VAT" := PreviewRec."Amount Including VAT";

                NewLine.Insert(true);

                // Aprendizaje histórico
                AssetSuggestionMgt.LearnFromPreview(PreviewRec);

                NextLineNo += 10000;
            until PreviewRec.Next() = 0;
    end;

    local procedure InsertPreviewLinesFromBankStatement(var FREJnlLine: Record "FRE Jnl. Line"; var PreviewRec: Record "FRE Import Preview v2"; FREBankStatement: Record "FRE Bank Statement")
    var
        NewLine: Record "FRE Jnl. Line";
        NextLineNo: Integer;
        AssetSuggestionMgt: Codeunit "FRE Asset Suggestion Mgt.";
    begin
        NextLineNo := GetNextLineNo(FREJnlLine."Journal Template Name", FREJnlLine."Journal Batch Name");

        PreviewRec.Reset();
        PreviewRec.SetRange(Error, '');

        if PreviewRec.FindSet() then
            repeat
                Clear(NewLine);
                NewLine.Init();

                NewLine."Journal Template Name" := FREJnlLine."Journal Template Name";
                NewLine."Journal Batch Name" := FREJnlLine."Journal Batch Name";
                NewLine."Line No." := NextLineNo;

                NewLine.Validate(Date, PreviewRec.Date);
                NewLine.Validate("Document No.", PreviewRec."Document No.");
                NewLine."Line Type" := NewLine."Line Type"::Invoice;

                if PreviewRec."Fixed Real Estate No." <> '' then
                    NewLine.Validate("Fixed Real Estate No.", PreviewRec."Fixed Real Estate No.");

                if (PreviewRec."Fixed Real Estate No." = '') and PreviewRec."Accept Suggestion" then
                    PreviewRec."Fixed Real Estate No." := PreviewRec."Suggested FRE No.";

                if PreviewRec.Description <> '' then
                    NewLine.Validate(Description, PreviewRec.Description);

                if PreviewRec."Row No." <> '' then begin
                    NewLine.Validate("Row No.", PreviewRec."Row No.");
                    NewLine.Validate("Entry Category", PreviewRec."Entry Category");
                end;
                if PreviewRec."Description Row No. Text" <> '' then
                    NewLine.Validate("Description Row No.", PreviewRec."Description Row No. Text");

                if FREBankStatement."Bank Account No." <> '' then begin
                    NewLine.Validate("Source Type", NewLine."Source Type"::"Bank Account");
                    NewLine.Validate("Source No.", FREBankStatement."Bank Account No.");
                end;

                NewLine.Amount := PreviewRec.Amount;
                NewLine."Amount Including VAT" := PreviewRec."Amount Including VAT";

                NewLine.Insert(true);

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
            Error(MultipleFREDescriptionErr, FREDescription);

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
            Error(MultipleRowDescriptionErr, RowDescription);

        exit(REFIncomeExpenseTemplate."Row No.");
    end;

    local procedure ResolveLineType(LineTypeTxt: Text[50]; var LineType: Enum "FRE Line Type"): Boolean
    begin
        case UpperCase(DelChr(LineTypeTxt, '<>', ' ')) of
            'PRESUPUESTO':
                begin
                    LineType := LineType::Budget;
                    exit(true);
                end;
            'REALIZADO':
                begin
                    LineType := LineType::Invoice;
                    exit(true);
                end;
            'AMBOSPRESUPUESTOYREALIZADO':
                begin
                    LineType := LineType::"Both Budget and Invoice";
                    exit(true);
                end;
        end;

        exit(false);
    end;

    procedure ValidatePreview (var PreviewRec: Record "FRE Import Preview v2" temporary): Text[250]
    var
        AssetSuggestionMgt: Codeunit "FRE Asset Suggestion Mgt.";
        ErrorText: Text[250];
        CellValue: Text;
        TempDate: Date;
        TempDecimal: Decimal;
        GenJnlDocType: Enum "Gen. Journal Document Type";
        FRELineType: Enum "FRE Line Type";
        ResolvedFRENo: Code[20];
        ResolvedRowNo: Code[10];
    begin
        PreviewRec.Error := '';
        // Date
        if PreviewRec.Date = 0D then
            AppendError(ErrorText, 'Date es obligatorio.');

        // Line Type
        // if PreviewRec."Line Type Text" = '' then
        //     AppendError(ErrorText, 'Line Type es obligatorio.');

        // Fixed Real Estate Description
        IF PreviewRec."Fixed Real Estate Description" = '' then
            AppendError(ErrorText, 'Fixed Real Estate Description es obligatorio.');
        
        // Description
        IF PreviewRec.Description = '' then
            AppendError(ErrorText, 'Description es obligatorio.');

        // Description Row No. (opcional pero recomendable)
        IF PreviewRec."Description Row No. Text" = '' then
            AppendError(ErrorText, StrSubstNo('No se encuentra la fila para la descripción: %1.', CellValue));

        // Amount
        if PreviewRec.Amount = 0 then
            AppendError(ErrorText, 'Amount es obligatorio.');

        PreviewRec.Error := ErrorText;
        
        AssetSuggestionMgt.SuggestFixedRealEstate(PreviewRec);
        exit(ErrorText);
    end;

    procedure BankStatementImportFromExcel(var FREJnlLine: Record "FRE Jnl. Line"; var FREBankStatement: Record "FRE Bank Statement")
    begin
        if FREBankStatement."SharePoint URL" = '' then
            Error(BankStatementUrlMissingErr);

        ImportBankStatementFromUrlWithStatement(FREJnlLine, FREBankStatement."SharePoint URL", FREBankStatement);
    end;

    procedure BankStatementImportFromExcelDirect(var FREJnlLine: Record "FRE Jnl. Line"; var FREBankStatement: Record "FRE Bank Statement")
    begin
        if FREBankStatement."SharePoint URL" = '' then
            Error(BankStatementUrlMissingErr);

        ImportBankStatementFromUrlWithStatementDirect(FREJnlLine, FREBankStatement."SharePoint URL", FREBankStatement);
    end;

    procedure ImportBankStatementFromStatement(var FREJnlLine: Record "FRE Jnl. Line"; var FREBankStatement: Record "FRE Bank Statement")
    begin
        BankStatementImportFromExcel(FREJnlLine, FREBankStatement);
    end;

    procedure ImportBankStatementFromUrl(var FREJnlLine: Record "FRE Jnl. Line"; FileUrl: Text)
    var
        TempExcelBuffer: Record "Excel Buffer" temporary;
        TempBlob: Codeunit "Temp Blob";
        ExcelInStream: InStream;
        SheetName: Text;
        LastRowNo: Integer;
        PreviewRec: Record "FRE Import Preview v2" temporary;
        HasErrors: Boolean;
        TargetCode: Text[10];
        JournalTemplateName: Code[10];
        JournalBatchName: Code[10];
        PreviewLoadMgt: Codeunit "Preview Load Mgt.";
    begin
        CheckJournalContext(FREJnlLine);

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

        if not SelectPreviewDestination(PreviewRec, TargetCode, JournalTemplateName, JournalBatchName) then
            exit;

        if TargetCode = 'FRE' then
            ImportPreviewToFREJournal(PreviewRec, JournalTemplateName, JournalBatchName)
        else
            PreviewLoadMgt.ImportPreviewToGenJournal(PreviewRec, JournalTemplateName, JournalBatchName);

        if Confirm(OpenImportedJournalQst, false) then
            PreviewLoadMgt.OpenImportedJournal(TargetCode, JournalTemplateName, JournalBatchName);

        Message('Importación del extracto bancario completada correctamente.');
    end;

    local procedure ImportBankStatementFromUrlWithStatement(var FREJnlLine: Record "FRE Jnl. Line"; FileUrl: Text; var FREBankStatement: Record "FRE Bank Statement")
    var
        TempExcelBuffer: Record "Excel Buffer" temporary;
        TempBlob: Codeunit "Temp Blob";
        ExcelInStream: InStream;
        SheetName: Text;
        LastRowNo: Integer;
        PreviewRec: Record "FRE Import Preview v2" temporary;
        HasErrors: Boolean;
        TargetCode: Text[10];
        JournalTemplateName: Code[10];
        JournalBatchName: Code[10];
        PreviewLoadMgt: Codeunit "Preview Load Mgt.";
    begin
        CheckJournalContext(FREJnlLine);

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

        if not SelectPreviewDestination(PreviewRec, TargetCode, JournalTemplateName, JournalBatchName) then
            exit;

        if TargetCode = 'FRE' then
            ImportPreviewToFREJournalFromBankStatement(PreviewRec, JournalTemplateName, JournalBatchName, FREBankStatement)
        else
            PreviewLoadMgt.ImportPreviewToGenJournalFromBankStatement(PreviewRec, JournalTemplateName, JournalBatchName, FREBankStatement);

        if Confirm(OpenImportedJournalQst, false) then
            PreviewLoadMgt.OpenImportedJournal(TargetCode, JournalTemplateName, JournalBatchName);

        FREBankStatement.Imported := true;
        FREBankStatement.Status := FREBankStatement.Status::Imported;
        FREBankStatement.Modify();

        Message('Importación del extracto bancario completada correctamente.');
    end;

    local procedure ImportBankStatementFromUrlWithStatementDirect(var FREJnlLine: Record "FRE Jnl. Line"; FileUrl: Text; var FREBankStatement: Record "FRE Bank Statement")
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
        CheckJournalContext(FREJnlLine);

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

        ImportPreviewToFREJournalFromBankStatement(PreviewRec, FREJnlLine.GetRangeMax("Journal Template Name"), FREJnlLine.GetRangeMax("Journal Batch Name"), FREBankStatement);

        if Confirm(OpenImportedJournalQst, false) then
            PreviewLoadMgt.OpenImportedJournal('FRE', FREJnlLine.GetRangeMax("Journal Template Name"), FREJnlLine.GetRangeMax("Journal Batch Name"));

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

    procedure ImportBankStatementFromExcel(var FREJnlLine: Record "FRE Jnl. Line")
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
        TargetCode: Text[10];
        JournalTemplateName: Code[10];
        JournalBatchName: Code[10];
        PreviewLoadMgt: Codeunit "Preview Load Mgt.";
    begin
        CheckJournalContext(FREJnlLine);

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

        if not SelectPreviewDestination(PreviewRec, TargetCode, JournalTemplateName, JournalBatchName) then
            exit;

        if TargetCode = 'FRE' then
            ImportPreviewToFREJournal(PreviewRec, JournalTemplateName, JournalBatchName)
        else
            PreviewLoadMgt.ImportPreviewToGenJournal(PreviewRec, JournalTemplateName, JournalBatchName);

        if Confirm(OpenImportedJournalQst, false) then
            PreviewLoadMgt.OpenImportedJournal(TargetCode, JournalTemplateName, JournalBatchName);

        Message('Importación del extracto bancario completada correctamente.');
    end;

    procedure ImportPreviewToFREJournal(var PreviewRec: Record "FRE Import Preview v2" temporary; JournalTemplateName: Code[10]; JournalBatchName: Code[10])
    var
        FREJnlBatch: Record "FRE Jnl. Batch";
        FREJnlLine: Record "FRE Jnl. Line";
    begin
        FREJnlBatch.Get(JournalTemplateName, JournalBatchName);
        FREJnlLine.SetRange("Journal Template Name", JournalTemplateName);
        FREJnlLine.SetRange("Journal Batch Name", JournalBatchName);
        FREJnlLine."Journal Template Name" := JournalTemplateName;
        FREJnlLine."Journal Batch Name" := JournalBatchName;
        InsertPreviewLines(FREJnlLine, PreviewRec);
    end;

    procedure ImportPreviewToFREJournalFromBankStatement(var PreviewRec: Record "FRE Import Preview v2" temporary; JournalTemplateName: Code[10]; JournalBatchName: Code[10]; FREBankStatement: Record "FRE Bank Statement")
    var
        FREJnlBatch: Record "FRE Jnl. Batch";
        FREJnlLine: Record "FRE Jnl. Line";
    begin
        FREJnlBatch.Get(JournalTemplateName, JournalBatchName);
        FREJnlLine.SetRange("Journal Template Name", JournalTemplateName);
        FREJnlLine.SetRange("Journal Batch Name", JournalBatchName);
        FREJnlLine."Journal Template Name" := JournalTemplateName;
        FREJnlLine."Journal Batch Name" := JournalBatchName;
        InsertPreviewLinesFromBankStatement(FREJnlLine, PreviewRec, FREBankStatement);
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

    var
        NoTemplateUploadedErr: Label 'No template uploaded.';
        NoSheetSelectedErr: Label 'No se ha seleccionado ninguna hoja.';
        NoLinesToImportErr: Label 'El fichero Excel no contiene líneas para importar.';
        OpenImportedJournalQst: Label '¿Desea abrir el diario cargado?';
        ExcelTemplateSetupMissingErr: Label 'No existe la configuración de plantilla Excel.';
        NoExcelTemplateConfiguredErr: Label 'No se ha configurado ninguna plantilla Excel.';
        FRETemplateRequiredErr: Label 'Debe informar la plantilla del diario o configurarla por defecto en "FRE Excel Template Setup".';
        FREBatchRequiredErr: Label 'Debe informar el lote del diario o configurarlo por defecto en "FRE Excel Template Setup".';
        MultipleFREDescriptionErr: Label 'Existen varios activos inmobiliarios con la descripción %1.';
        MultipleRowDescriptionErr: Label 'Existen varias filas con la descripción %1.';
        BankStatementUrlMissingErr: Label 'El extracto no tiene URL de SharePoint.';
        BankStatementUrlRequiredErr: Label 'La URL o ruta del extracto bancario es obligatoria.';
        BankStatementConnectErr: Label 'No se ha podido conectar con la URL del extracto.';
        BankStatementDownloadErr: Label 'Error al descargar el extracto. Código HTTP: %1';
        NoFileSelectedErr: Label 'No se ha seleccionado ningún fichero.';
}
