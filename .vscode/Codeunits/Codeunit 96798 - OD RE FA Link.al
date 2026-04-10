codeunit 96798 "FRE Journal Integration Mgt."
{
    procedure CreateFREEntries(GenJnlLine: Record "Gen. Journal Line"; GLEntryNo: Integer)
    var
        Link: Record "OD RE FA Link";
        NextLineNo: Integer;
        REFSetup: Record "REF Setup";
    begin
        if not GenJnlLine."FRE Integration" then
            exit;

        ValidateLine(GenJnlLine);

        REFSetup.Get();
        REFSetup.TestField("Journal Template Name");
        REFSetup.TestField("Journal Batch Name");
        NextLineNo := GetNextFREJournalLineNo(REFSetup."Journal Template Name", REFSetup."Journal Batch Name");

        if GenJnlLine."FRE FA No." <> '' then begin
            Link.SetRange("FA No.", GenJnlLine."FRE FA No.");
            Link.SetRange(Active, true);

            if Link.FindSet() then
                repeat
                    CreateFREEntry(GenJnlLine, GLEntryNo, Link, NextLineNo);
                    NextLineNo += 10000;
                until Link.Next() = 0;
            if Link.IsEmpty() then
                Error('No existen vínculos activos entre el activo fijo %1 y ningún inmueble.', GenJnlLine."FRE FA No.");

        end else begin
            CreateFREEntryDirect(GenJnlLine, GLEntryNo, NextLineNo);
        end;
    end;

    local procedure ValidateLine(GenJnlLine: Record "Gen. Journal Line")
    begin
        if (GenJnlLine."FRE Fixed Real Estate No." = '') and (GenJnlLine."FRE FA No." = '') then
            Error('Debe informar inmueble o activo fijo.');

        if GetJournalEntryCategory(GenJnlLine) = GenJnlLine."Entry Category"::Undefined then
            Error('Debe informar Entry Category.');

        if GetJournalRowNo(GenJnlLine) = '' then
            Error('Debe informar Row No.');
    end;

    local procedure CreateFREEntryDirect(GenJnlLine: Record "Gen. Journal Line"; GLEntryNo: Integer; LineNo: Integer)
    var
        FREJnlLine: Record "FRE Jnl. Line";
    begin
        CreateAndPostFREJournalLine(
            FREJnlLine,
            GenJnlLine,
            GLEntryNo,
            LineNo,
            GenJnlLine."FRE Fixed Real Estate No.",
            GenJnlLine."FRE Source Type",
            GenJnlLine."FRE Source No.",
            -GenJnlLine.Amount);
    end;

    local procedure CreateFREEntry(GenJnlLine: Record "Gen. Journal Line"; GLEntryNo: Integer; Link: Record "OD RE FA Link"; LineNo: Integer)
    var
        FREJnlLine: Record "FRE Jnl. Line";
        Amount: Decimal;
    begin
        Amount := GetDistributedAmount(GenJnlLine.Amount, Link);

        CreateAndPostFREJournalLine(
            FREJnlLine,
            GenJnlLine,
            GLEntryNo,
            LineNo,
            Link."Real Estate No.",
            FREJnlLine."Source Type"::"Fixed Asset",
            GenJnlLine."FRE FA No.",
            -Amount);
    end;

    local procedure GetDistributedAmount(BaseAmount: Decimal; Link: Record "OD RE FA Link"): Decimal
    begin
        if Link."Link Type" = Link."Link Type"::Shared then
            exit(Round(BaseAmount * Link."Allocation %" / 100, 0.01));

        exit(BaseAmount);
    end;

    local procedure CreateAndPostFREJournalLine(
        var FREJnlLine: Record "FRE Jnl. Line";
        GenJnlLine: Record "Gen. Journal Line";
        GLEntryNo: Integer;
        LineNo: Integer;
        FixedRealEstateNo: Code[20];
        FRESourceType: Enum "FRE Journal Source Type";
        FRESourceNo: Code[20];
        Amount: Decimal)
    var
        REFSetup: Record "REF Setup";
        FREJnlPostLine: Codeunit "FRE Jnl.-Post Line";
    begin
        REFSetup.Get();
        REFSetup.TestField("Journal Template Name");
        REFSetup.TestField("Journal Batch Name");

        FREJnlLine.Init();
        FREJnlLine."Journal Template Name" := REFSetup."Journal Template Name";
        FREJnlLine."Journal Batch Name" := REFSetup."Journal Batch Name";
        FREJnlLine."Line No." := LineNo;
        FREJnlLine.Date := GenJnlLine."Posting Date";
        FREJnlLine."Line Type" := FREJnlLine."Line Type"::Invoice;
        FREJnlLine."Fixed Real Estate No." := FixedRealEstateNo;
        FREJnlLine.Description := GenJnlLine.Description;
        FREJnlLine."Row No." := GetJournalRowNo(GenJnlLine);
        FREJnlLine."Description Row No." := GenJnlLine."Description Row No.";
        FREJnlLine."Entry Category" := GetJournalEntryCategory(GenJnlLine);
        FREJnlLine.Amount := Amount;
        FREJnlLine."Amount Including VAT" := Amount;
        FREJnlLine."Document Type" := GenJnlLine."Document Type";
        FREJnlLine."Document No." := GenJnlLine."Document No.";
        FREJnlLine."Source Type" := FRESourceType;
        FREJnlLine."Source No." := FRESourceNo;
        FREJnlLine."Ledger Entry No." := GLEntryNo;
        FREJnlLine."System-Created Entry" := true;

        if FREJnlLine."Source No." <> '' then
            FREJnlLine.Validate("Source No.", FREJnlLine."Source No.");

        FREJnlLine.Insert(true);
        FREJnlPostLine.PostLine(FREJnlLine);
    end;

    local procedure GetNextFREJournalLineNo(JournalTemplateName: Code[10]; JournalBatchName: Code[10]): Integer
    var
        FREJnlLine: Record "FRE Jnl. Line";
    begin
        FREJnlLine.SetRange("Journal Template Name", JournalTemplateName);
        FREJnlLine.SetRange("Journal Batch Name", JournalBatchName);

        if FREJnlLine.FindLast() then
            exit(FREJnlLine."Line No." + 10000);

        exit(10000);
    end;

    procedure CreateFREEntriesFromGLEntry(GenJnlLine: Record "Gen. Journal Line"; GLEntry: Record "G/L Entry")
    begin
        CreateFREEntries(GenJnlLine, GLEntry."Entry No.");
    end;

    local procedure GetJournalEntryCategory(GenJnlLine: Record "Gen. Journal Line"): Enum "FRE Entry Category"
    begin
        if GenJnlLine."Entry Category" <> GenJnlLine."Entry Category"::Undefined then
            exit(GenJnlLine."Entry Category");

        exit(GenJnlLine."FRE Entry Category");
    end;

    local procedure GetJournalRowNo(GenJnlLine: Record "Gen. Journal Line"): Code[10]
    begin
        if GenJnlLine."Row No." <> '' then
            exit(GenJnlLine."Row No.");

        exit(GenJnlLine."FRE Row No.");
    end;

    [EventSubscriber(ObjectType::Codeunit, Codeunit::"Gen. Jnl.-Post Line", 'OnAfterGLFinishPosting', '', false, false)]
    local procedure OnAfterGLFinishPosting(
        GLEntry: Record "G/L Entry";
        var GenJnlLine: Record "Gen. Journal Line";
        var IsTransactionConsistent: Boolean;
        FirstTransactionNo: Integer;
        var GLRegister: Record "G/L Register";
        var TempGLEntryBuf: Record "G/L Entry" temporary;
        var NextEntryNo: Integer;
        var NextTransactionNo: Integer)
    var
        FREJournalIntegrationMgt: Codeunit "FRE Journal Integration Mgt.";
    begin
        if not GenJnlLine."FRE Integration" then
            exit;

        FREJournalIntegrationMgt.CreateFREEntriesFromGLEntry(GenJnlLine, GLEntry);
    end;
    
}
