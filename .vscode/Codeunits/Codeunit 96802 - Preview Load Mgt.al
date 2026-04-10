codeunit 96802 "Preview Load Mgt."
{
    procedure OpenImportedJournal(TargetCode: Text[10]; JournalTemplateName: Code[10]; JournalBatchName: Code[10])
    var
        GenJnlLine: Record "Gen. Journal Line";
        FREJnlLine: Record "FRE Jnl. Line";
    begin
        case UpperCase(TargetCode) of
            'GEN':
                begin
                    GenJnlLine.SetRange("Journal Template Name", JournalTemplateName);
                    GenJnlLine.SetRange("Journal Batch Name", JournalBatchName);
                    Page.Run(Page::"General Journal", GenJnlLine);
                end;
            'FRE':
                begin
                    FREJnlLine.SetRange("Journal Template Name", JournalTemplateName);
                    FREJnlLine.SetRange("Journal Batch Name", JournalBatchName);
                    Page.Run(Page::"FRE Journal Line", FREJnlLine);
                end;
        end;
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
        InsertPreviewLinesToGenJournal(GenJnlLine, PreviewRec);
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
        InsertPreviewLinesToGenJournalFromBankStatement(GenJnlLine, PreviewRec, FREBankStatement);
    end;

    local procedure InsertPreviewLinesToGenJournal(var GenJnlLine: Record "Gen. Journal Line"; var PreviewRec: Record "FRE Import Preview v2")
    var
        NewLine: Record "Gen. Journal Line";
        NextLineNo: Integer;
        AssetSuggestionMgt: Codeunit "FRE Asset Suggestion Mgt.";
        SelectedFRENo: Code[20];
    begin
        NextLineNo := GetNextGenJournalLineNo(GenJnlLine."Journal Template Name", GenJnlLine."Journal Batch Name");

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

                AssetSuggestionMgt.LearnFromPreview(PreviewRec);
                NextLineNo += 10000;
            until PreviewRec.Next() = 0;
    end;

    local procedure InsertPreviewLinesToGenJournalFromBankStatement(var GenJnlLine: Record "Gen. Journal Line"; var PreviewRec: Record "FRE Import Preview v2"; FREBankStatement: Record "FRE Bank Statement")
    var
        NewLine: Record "Gen. Journal Line";
        NextLineNo: Integer;
        AssetSuggestionMgt: Codeunit "FRE Asset Suggestion Mgt.";
    begin
        NextLineNo := GetNextGenJournalLineNo(GenJnlLine."Journal Template Name", GenJnlLine."Journal Batch Name");

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

                if PreviewRec."Fixed Real Estate No." <> '' then
                    NewLine.Validate("FRE Fixed Real Estate No.", PreviewRec."Fixed Real Estate No.");

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

                NewLine.Validate(Amount, PreviewRec.Amount);
                NewLine.Insert(true);

                AssetSuggestionMgt.LearnFromPreview(PreviewRec);
                NextLineNo += 10000;
            until PreviewRec.Next() = 0;
    end;

    local procedure GetNextGenJournalLineNo(JournalTemplateName: Code[10]; JournalBatchName: Code[10]): Integer
    var
        GenJnlLine: Record "Gen. Journal Line";
    begin
        GenJnlLine.SetRange("Journal Template Name", JournalTemplateName);
        GenJnlLine.SetRange("Journal Batch Name", JournalBatchName);

        if GenJnlLine.FindLast() then
            exit(GenJnlLine."Line No." + 10000);

        exit(10000);
    end;
}
