codeunit 96803 "Gen Journal FRE Subscribers"
{
    [EventSubscriber(ObjectType::Table, Database::"Gen. Journal Line", 'OnAfterSetupNewLine', '', false, false)]
    local procedure OnAfterSetupNewLine(var GenJournalLine: Record "Gen. Journal Line")
    begin
        CopyLastFREValues(GenJournalLine);
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
}
