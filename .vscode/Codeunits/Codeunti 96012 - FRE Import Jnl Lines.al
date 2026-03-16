codeunit 96012 "FRE Import Jnl. Lines"
{

    procedure ImportFromExcel(var FREJnlLine: Record "FRE Jnl. Line")
    var
        TempExcelBuffer: Record "Excel Buffer" temporary;
        TempBlob: Codeunit "Temp Blob";
        UploadInStream: InStream;
        ExcelInStream: InStream;
        OutStr: OutStream;
        FileName: Text;
        SheetName: Text;
        RowNo: Integer;
        LastRowNo: Integer;
        NextLineNo: Integer;
        NewLine: Record "FRE Jnl. Line";
    begin

        UploadIntoStream(
            'Seleccione un Excel',
            '',
            'Excel files (*.xlsx)|*.xlsx',
            FileName,
            UploadInStream);

        TempBlob.CreateOutStream(OutStr);
        CopyStream(OutStr, UploadInStream);

        TempBlob.CreateInStream(ExcelInStream);
        SheetName := TempExcelBuffer.SelectSheetsNameStream(ExcelInStream);

        TempBlob.CreateInStream(ExcelInStream);
        TempExcelBuffer.OpenBookStream(ExcelInStream, SheetName);
        TempExcelBuffer.ReadSheet();

        LastRowNo := GetLastRowNo(TempExcelBuffer);

        NextLineNo := GetNextLineNo(
            FREJnlLine."Journal Template Name",
            FREJnlLine."Journal Batch Name");

        for RowNo := 2 to LastRowNo do begin

            if IsRowEmpty(TempExcelBuffer, RowNo) then
                continue;

            Clear(NewLine);
            NewLine.Init();

            NewLine."Journal Template Name" := FREJnlLine."Journal Template Name";
            NewLine."Journal Batch Name" := FREJnlLine."Journal Batch Name";
            NewLine."Line No." := NextLineNo;

            FillJournalLine(NewLine, TempExcelBuffer, RowNo);

            NewLine.Insert(true);

            NextLineNo += 10000;
        end;

        Message('Importación finalizada.');
    end;


    procedure DownloadTemplate()
    var
        TempExcelBuffer: Record "Excel Buffer" temporary;
        FixedRealEstate: Record "Fixed Real Estate";
        SheetLines: Text;
        SheetFRE: Text;
        FileName: Text;
    begin

        SheetLines := 'Journal Lines';
        SheetFRE := 'Fixed Real Estate';
        FileName := 'FRE_Journal_Template.xlsx';

        //--------------------------------
        // HOJA 1: JOURNAL LINES
        //--------------------------------

        TempExcelBuffer.DeleteAll();

        CreateJournalHeader(TempExcelBuffer);

        TempExcelBuffer.NewRow();
        TempExcelBuffer.AddColumn('2026-01-01', false, '', false, false, false, '', TempExcelBuffer."Cell Type"::Text);
        TempExcelBuffer.AddColumn('Invoice', false, '', false, false, false, '', TempExcelBuffer."Cell Type"::Text);
        TempExcelBuffer.AddColumn('DOC-0001', false, '', false, false, false, '', TempExcelBuffer."Cell Type"::Text);
        TempExcelBuffer.AddColumn('Income', false, '', false, false, false, '', TempExcelBuffer."Cell Type"::Text);
        TempExcelBuffer.AddColumn('FRE0001', false, '', false, false, false, '', TempExcelBuffer."Cell Type"::Text);
        TempExcelBuffer.AddColumn('Example description', false, '', false, false, false, '', TempExcelBuffer."Cell Type"::Text);
        TempExcelBuffer.AddColumn('100', false, '', false, false, false, '', TempExcelBuffer."Cell Type"::Text);
        TempExcelBuffer.AddColumn('RENT', false, '', false, false, false, '', TempExcelBuffer."Cell Type"::Text);
        TempExcelBuffer.AddColumn('Customer', false, '', false, false, false, '', TempExcelBuffer."Cell Type"::Text);
        TempExcelBuffer.AddColumn('C00010', false, '', false, false, false, '', TempExcelBuffer."Cell Type"::Text);
        TempExcelBuffer.AddColumn(1000, false, '', false, false, false, '', TempExcelBuffer."Cell Type"::Number);
        TempExcelBuffer.AddColumn(1210, false, '', false, false, false, '', TempExcelBuffer."Cell Type"::Number);

        TempExcelBuffer.CreateNewBook(SheetLines);
        TempExcelBuffer.WriteSheet(SheetLines, CompanyName, UserId);

        //--------------------------------
        // HOJA 2: FIXED REAL ESTATE
        //--------------------------------

        TempExcelBuffer.DeleteAll();

        CreateFixedRealEstateHeader(TempExcelBuffer);

        if FixedRealEstate.FindSet() then
            repeat

                TempExcelBuffer.NewRow();

                TempExcelBuffer.AddColumn(
                    FixedRealEstate."No.",
                    false,
                    '',
                    false,
                    false,
                    false,
                    '',
                    TempExcelBuffer."Cell Type"::Text);

                TempExcelBuffer.AddColumn(
                    FixedRealEstate.Description,
                    false,
                    '',
                    false,
                    false,
                    false,
                    '',
                    TempExcelBuffer."Cell Type"::Text);

            until FixedRealEstate.Next() = 0;

        TempExcelBuffer.WriteSheet(SheetFRE, CompanyName, UserId);

        TempExcelBuffer.CloseBook();
        TempExcelBuffer.SetFriendlyFilename(FileName);
        TempExcelBuffer.OpenExcel();
    end;



    //--------------------------------
    // FUNCIONES AUXILIARES
    //--------------------------------

    local procedure CreateJournalHeader(var TempExcelBuffer: Record "Excel Buffer" temporary)
    begin
        TempExcelBuffer.NewRow();

        TempExcelBuffer.AddColumn('Date', false, '', true, false, false, '', TempExcelBuffer."Cell Type"::Text);
        TempExcelBuffer.AddColumn('Document Type', false, '', true, false, false, '', TempExcelBuffer."Cell Type"::Text);
        TempExcelBuffer.AddColumn('Document No.', false, '', true, false, false, '', TempExcelBuffer."Cell Type"::Text);
        TempExcelBuffer.AddColumn('Line Type', false, '', true, false, false, '', TempExcelBuffer."Cell Type"::Text);
        TempExcelBuffer.AddColumn('Fixed Real Estate No. (see sheet "Fixed Real Estate")', false, '', true, false, false, '', TempExcelBuffer."Cell Type"::Text);
        TempExcelBuffer.AddColumn('Description', false, '', true, false, false, '', TempExcelBuffer."Cell Type"::Text);
        TempExcelBuffer.AddColumn('Row No.', false, '', true, false, false, '', TempExcelBuffer."Cell Type"::Text);
        TempExcelBuffer.AddColumn('Description Row No.', false, '', true, false, false, '', TempExcelBuffer."Cell Type"::Text);
        TempExcelBuffer.AddColumn('Source Type', false, '', true, false, false, '', TempExcelBuffer."Cell Type"::Text);
        TempExcelBuffer.AddColumn('Source No.', false, '', true, false, false, '', TempExcelBuffer."Cell Type"::Text);
        TempExcelBuffer.AddColumn('Amount', false, '', true, false, false, '', TempExcelBuffer."Cell Type"::Number);
        TempExcelBuffer.AddColumn('Amount Including VAT', false, '', true, false, false, '', TempExcelBuffer."Cell Type"::Number);
    end;


    local procedure CreateFixedRealEstateHeader(var TempExcelBuffer: Record "Excel Buffer" temporary)
    begin
        TempExcelBuffer.NewRow();

        TempExcelBuffer.AddColumn('No.', false, '', true, false, false, '', TempExcelBuffer."Cell Type"::Text);
        TempExcelBuffer.AddColumn('Description', false, '', true, false, false, '', TempExcelBuffer."Cell Type"::Text);
    end;



    local procedure FillJournalLine(var NewLine: Record "FRE Jnl. Line"; var TempExcelBuffer: Record "Excel Buffer" temporary; RowNo: Integer)
    var
        TextValue: Text;
        DecValue: Decimal;
    begin

        TextValue := GetCellValue(TempExcelBuffer, RowNo, 1);
        Evaluate(NewLine.Date, TextValue);

        TextValue := GetCellValue(TempExcelBuffer, RowNo, 2);
        Evaluate(NewLine."Document Type", TextValue);

        NewLine.Validate("Document No.", GetCellValue(TempExcelBuffer, RowNo, 3));

        TextValue := GetCellValue(TempExcelBuffer, RowNo, 4);
        Evaluate(NewLine."Line Type", TextValue);

        NewLine.Validate("Fixed Real Estate No.", GetCellValue(TempExcelBuffer, RowNo, 5));

        NewLine.Description := GetCellValue(TempExcelBuffer, RowNo, 6);

        NewLine."Row No." := GetCellValue(TempExcelBuffer, RowNo, 7);
        NewLine."Description Row No." := GetCellValue(TempExcelBuffer, RowNo, 8);

        TextValue := GetCellValue(TempExcelBuffer, RowNo, 9);
        Evaluate(NewLine."Source Type", TextValue);

        NewLine.Validate("Source No.", GetCellValue(TempExcelBuffer, RowNo, 10));

        TextValue := GetCellValue(TempExcelBuffer, RowNo, 11);
        Evaluate(DecValue, TextValue);
        NewLine.Amount := DecValue;

        TextValue := GetCellValue(TempExcelBuffer, RowNo, 12);
        Evaluate(DecValue, TextValue);
        NewLine."Amount Including VAT" := DecValue;

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



    local procedure IsRowEmpty(var TempExcelBuffer: Record "Excel Buffer" temporary; RowNo: Integer): Boolean
    begin
        exit(GetCellValue(TempExcelBuffer, RowNo, 1) = '');
    end;



    local procedure GetNextLineNo(JournalTemplateName: Code[10]; JournalBatchName: Code[10]): Integer
    var
        FREJnlLine: Record "FRE Jnl. Line";
    begin
        FREJnlLine.SetRange("Journal Template Name", JournalTemplateName);
        FREJnlLine.SetRange("Journal Batch Name", JournalBatchName);

        if FREJnlLine.FindLast() then
            exit(FREJnlLine."Line No." + 10000);

        exit(10000);
    end;

}