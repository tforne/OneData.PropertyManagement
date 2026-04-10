codeunit 96803 "Gen Journal FRE Subscribers"
{
    [EventSubscriber(ObjectType::Table, Database::"Gen. Journal Line", 'OnAfterSetupNewLine', '', false, false)]
    local procedure OnAfterSetupNewLine(var GenJournalLine: Record "Gen. Journal Line")
    begin
        CopyLastFREValues(GenJournalLine);
    end;

    [EventSubscriber(ObjectType::Table, Database::"Gen. Journal Line", 'OnBeforeInsertEvent', '', false, false)]
    local procedure OnBeforeInsertGenJournalLine(var Rec: Record "Gen. Journal Line"; RunTrigger: Boolean)
    begin
        ApplyFREDefaultsForDepreciation(Rec);
    end;

    local procedure CopyLastFREValues(var GenJournalLine: Record "Gen. Journal Line")
    var
        LastGenJnlLine: Record "Gen. Journal Line";
    begin
        LastGenJnlLine.SetRange("Journal Template Name", GenJournalLine."Journal Template Name");
        LastGenJnlLine.SetRange("Journal Batch Name", GenJournalLine."Journal Batch Name");

        if not LastGenJnlLine.FindLast() then
            exit;

        if LastGenJnlLine."Line No." = GenJournalLine."Line No." then begin
            LastGenJnlLine.SetFilter("Line No.", '<>%1', GenJournalLine."Line No.");
            if not LastGenJnlLine.FindLast() then
                exit;
        end;

        GenJournalLine."FRE Integration" := LastGenJnlLine."FRE Integration";
        GenJournalLine."FRE Fixed Real Estate No." := LastGenJnlLine."FRE Fixed Real Estate No.";
        GenJournalLine."FRE Entry Category" := LastGenJnlLine."FRE Entry Category";
        GenJournalLine."FRE Row No." := LastGenJnlLine."FRE Row No.";
        GenJournalLine."Row No." := LastGenJnlLine."Row No.";
        GenJournalLine."Entry Category" := LastGenJnlLine."Entry Category";
        GenJournalLine."Description Row No." := LastGenJnlLine."Description Row No.";
        GenJournalLine."FRE Source Type" := LastGenJnlLine."FRE Source Type";
        GenJournalLine."FRE Source No." := LastGenJnlLine."FRE Source No.";
        GenJournalLine."FRE FA No." := LastGenJnlLine."FRE FA No.";
    end;

    local procedure ApplyFREDefaultsForDepreciation(var GenJournalLine: Record "Gen. Journal Line")
    var
        REFSetup: Record "REF Setup";
        RealEstateLink: Record "OD RE FA Link";
        FANo: Code[20];
    begin
        if GenJournalLine.IsTemporary() then
            exit;

        FANo := GetFixedAssetNo(GenJournalLine);
        if FANo = '' then
            exit;

        if GenJournalLine."FA Posting Type" <> GenJournalLine."FA Posting Type"::Depreciation then
            exit;

        RealEstateLink.SetRange("FA No.", FANo);
        RealEstateLink.SetRange(Active, true);
        if not RealEstateLink.FindFirst() then
            exit;

        if not REFSetup.Get() then
            exit;

        REFSetup.TestField("Default Depreciation Row No");

        GenJournalLine."FRE Integration" := true;
        GenJournalLine.Validate("FRE FA No.", FANo);
        GenJournalLine."FRE Source Type" := GenJournalLine."FRE Source Type"::"Fixed Asset";
        GenJournalLine."FRE Source No." := FANo;

        if GenJournalLine."FRE Fixed Real Estate No." = '' then
            GenJournalLine."FRE Fixed Real Estate No." := RealEstateLink."Real Estate No.";

        if GenJournalLine."Row No." = '' then
            GenJournalLine.Validate("Row No.", REFSetup."Default Depreciation Row No");

        if GenJournalLine."FRE Row No." = '' then
            GenJournalLine.Validate("FRE Row No.", REFSetup."Default Depreciation Row No");
    end;

    local procedure GetFixedAssetNo(GenJournalLine: Record "Gen. Journal Line"): Code[20]
    begin
        if GenJournalLine."Account Type" = GenJournalLine."Account Type"::"Fixed Asset" then
            exit(GenJournalLine."Account No.");

        if GenJournalLine."Bal. Account Type" = GenJournalLine."Bal. Account Type"::"Fixed Asset" then
            exit(GenJournalLine."Bal. Account No.");

        exit('');
    end;
}
