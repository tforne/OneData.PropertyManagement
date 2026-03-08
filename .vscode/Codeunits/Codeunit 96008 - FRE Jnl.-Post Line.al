codeunit 96008 "FRE Jnl.-Post Line"
{
    var
    GLSetup: Record "General Ledger Setup";
    NextEntryNo: integer;
    OpenFromBatch : Boolean;
    // Text000	: Label	'IRPF';
    Text001	 :Label 'Diario Propietario';
    Text002	: label 'GENERICO';
    Text003	: label 'Diario genérico';
    

    trigger OnRun()
    begin
    end;

procedure PostFRELedgerEntryFromLeaseInvoice(LeaseInvoiceHeader: Record "Lease Invoice Header")
    var
        insFREJnlLine : Record "FRE Jnl. Line" temporary;
        REFSetup : record "REF Setup";
    begin
        //  Control de registro        
        REFSetup.get;
        refsetup.testfield("Journal Template Name");
        refsetup.testfield("Journal Batch Name");   
        refsetup.TestField(refsetup."Default Income Row No");

        NextEntryNo := 1000;
        insFREJnlLine.INIT;
        insFREJnlLine."Journal Template Name" := REFSetup."Journal Template Name";
        insFREJnlLine."Journal Batch Name" := REFSetup."Journal Batch Name";
        insFREJnlLine."Line No." := NextEntryNo;
        insFREJnlLine."Line Type" := insFREJnlLine."Line Type"::Invoice;
        insFREJnlLine."Fixed Real Estate No." := LeaseInvoiceHeader."Fixed Real Estate No.";
        insFREJnlLine."Date" := LeaseInvoiceHeader."Posting Date";
        insFREJnlLine."Source Type" := insFREJnlLine."Source Type"::Customer;
        insFREJnlLine."Source No." := LeaseInvoiceHeader."Customer No.";
        insFREJnlLine."Source Name" := LeaseInvoiceHeader.Name;
        insFREJnlLine."Document Type" := insFREJnlLine."Document Type"::Invoice;
        insFREJnlLine."Document No." := LeaseInvoiceHeader."No.";
        insFREJnlLine."Row No." := REFSetup."Default Income Row No";
        insFREJnlLine."Description Row No." := REFSetup."Default Income Row No";
        insFREJnlLine.Description := StrSubstNo('%1 %2',insFREJnlLine."Document Type",LeaseInvoiceHeader."No."); 
        LeaseInvoiceHeader.calcfields(Amount,"Amount Including VAT");
        insFREJnlLine.Amount := LeaseInvoiceHeader."Amount";
        insFREJnlLine."Amount Including VAT" := LeaseInvoiceHeader."Amount Including VAT";
        insFREJnlLine."Ledger Entry No." := 0;
        //
        
        if insFREJnlLine.INSERT then
            Post(insFREJnlLine);
    end;


    procedure Post(FREJnlLine: Record "FRE Jnl. Line")
    var
        recFRELedgerEntry : Record "FRE Ledger Entry";
        insFRELedgerEntry : Record "FRE Ledger Entry";
        FRE : Record "Fixed Real Estate";
        REFSetup : record "REF Setup";
    begin
        REFSetup.get;
        //  Control de registro        
        NextEntryNo := 0;
        recFRELedgerEntry.reset;
        if recFRELedgerEntry.FindLast() then
            NextEntryNo := recFRELedgerEntry."Entry No." + 10;

        insFRELedgerEntry.INIT;
        insFRELedgerEntry."Entry No." := NextEntryNo;
        insFRELedgerEntry."Journal Template Name" := FREJnlLine."Journal Template Name";
        insFRELedgerEntry."Journal Batch Name" := FREJnlLine."Journal Batch Name";
        insFRELedgerEntry."Line Type" := FREJnlLine."Line Type";
        insFRELedgerEntry."Fixed Real Estate No." := FREJnlLine."Fixed Real Estate No.";
        insFRELedgerEntry.Description := FREJnlLine.Description;
        insFRELedgerEntry."Posting Date" := FREJnlLine."Date";
        insFRELedgerEntry."Source Type" := FREJnlLine."Source Type";
        insFRELedgerEntry."Source No." := FREJnlLine."Source No.";
        insFRELedgerEntry."Source Name" := FREJnlLine."Source Name";
        insFRELedgerEntry."Document Type" := FREJnlLine."Document Type";
        insFRELedgerEntry."Document No." := FREJnlLine."Document No.";
        insFRELedgerEntry."Row No." := FREJnlLine."Row No.";
        insFRELedgerEntry."Description Row No." := FREJnlLine."Description Row No.";
        insFRELedgerEntry.Amount := FREJnlLine.Amount;
        insFRELedgerEntry."Amount Including VAT" := FREJnlLine."Amount Including VAT";
        insFRELedgerEntry."Ledger Entry No." := FREJnlLine."Ledger Entry No.";
        // modiffy Fixed Real Estate Table to update the last transaction date and amount
        if FREJnlLine."Line Type" = FREJnlLine."Line Type"::Invoice then begin
            if FRE.GET(insFRELedgerEntry."Fixed Real Estate No.") then begin
                FRE."Last Rental Price" := insFRELedgerEntry."Amount";
                fre."Last Rental Price Modified" := insFRELedgerEntry."Posting Date";
                FRE.MODIFY;
            end;
        end;
        insFRELedgerEntry.INSERT;
    end;
}