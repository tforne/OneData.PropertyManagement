codeunit 96798 "FRE Journal Integration Mgt."
{
    procedure CreateFREEntries(GenJnlLine: Record "Gen. Journal Line"; GLEntryNo: Integer)
    var
        Link: Record "OD RE FA Link";
    begin
        if not GenJnlLine."FRE Integration" then
            exit;

        ValidateLine(GenJnlLine);

        if GenJnlLine."FRE FA No." <> '' then begin
            Link.SetRange("FA No.", GenJnlLine."FRE FA No.");
            Link.SetRange(Active, true);

            if Link.FindSet() then
                repeat
                    CreateFREEntry(GenJnlLine, GLEntryNo, Link);
                until Link.Next() = 0;

        end else begin
            CreateFREEntryDirect(GenJnlLine, GLEntryNo);
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

    local procedure CreateFREEntryDirect(GenJnlLine: Record "Gen. Journal Line"; GLEntryNo: Integer)
    var
        FRE: Record "FRE Ledger Entry";
    begin
        FRE.Init();
        FRE."Entry No." := GetNextEntryNo();

        FRE."Posting Date" := GenJnlLine."Posting Date";
        FRE."Document No." := GenJnlLine."Document No.";

        FRE."Fixed Real Estate No." := GenJnlLine."FRE Fixed Real Estate No.";
        FRE.Description := GenJnlLine.Description;

        FRE.Amount := GenJnlLine.Amount;
        FRE."Amount Including VAT" := GenJnlLine.Amount;

        FRE."Row No." := GetJournalRowNo(GenJnlLine);
        FRE."Description Row No." := GenJnlLine."Description Row No.";
        FRE."Entry Category" := GetJournalEntryCategory(GenJnlLine);

        FRE."Source Type" := GenJnlLine."FRE Source Type";
        FRE."Source No." := GenJnlLine."FRE Source No.";

        FRE."Ledger Entry No." := GLEntryNo;

        FRE.Insert();
    end;

    local procedure CreateFREEntry(GenJnlLine: Record "Gen. Journal Line"; GLEntryNo: Integer; Link: Record "OD RE FA Link")
    var
        FRE: Record "FRE Ledger Entry";
        Amount: Decimal;
    begin
        Amount := GetDistributedAmount(GenJnlLine.Amount, Link);

        FRE.Init();
        FRE."Entry No." := GetNextEntryNo();

        FRE."Posting Date" := GenJnlLine."Posting Date";
        FRE."Document No." := GenJnlLine."Document No.";

        FRE."Fixed Real Estate No." := Link."Real Estate No.";
        FRE.Description := GenJnlLine.Description;

        FRE.Amount := Amount;
        FRE."Amount Including VAT" := Amount;

        FRE."Row No." := GetJournalRowNo(GenJnlLine);
        FRE."Description Row No." := GenJnlLine."Description Row No.";
        FRE."Entry Category" := GetJournalEntryCategory(GenJnlLine);

        FRE."Source Type" := FRE."Source Type"::"Fixed Asset";
        FRE."Source No." := GenJnlLine."FRE FA No.";

        FRE."Ledger Entry No." := GLEntryNo;

        FRE.Insert();
    end;

    local procedure GetDistributedAmount(BaseAmount: Decimal; Link: Record "OD RE FA Link"): Decimal
    begin
        if Link."Link Type" = Link."Link Type"::Shared then
            exit(Round(BaseAmount * Link."Allocation %" / 100, 0.01));

        exit(BaseAmount);
    end;

    local procedure GetNextEntryNo(): Integer
    var
        FRE: Record "FRE Ledger Entry";
    begin
        if FRE.FindLast() then
            exit(FRE."Entry No." + 1);

        exit(1);
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

    [EventSubscriber(ObjectType::Codeunit, Codeunit::"Gen. Jnl.-Post Line", 'OnAfterCreateGLEntry', '', false, false)]
    local procedure OnAfterCreateGLEntry(
        var GenJnlLine: Record "Gen. Journal Line";
        var GLEntry: Record "G/L Entry";
        NextEntryNo: Integer)
    var
        FREJournalIntegrationMgt: Codeunit "FRE Journal Integration Mgt.";
    begin
        if not GenJnlLine."FRE Integration" then
            exit;

        FREJournalIntegrationMgt.CreateFREEntriesFromGLEntry(GenJnlLine, GLEntry);
    end;
    
}
