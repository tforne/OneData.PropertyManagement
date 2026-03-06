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
        insFREJnlLine."Document No." := LeaseInvoiceHeader."Posting No.";
        insFREJnlLine."Row No." := REFSetup."Default Income Row No";
        // insFREJnlLine."Description Row No."
        // insFREJnlLine.Description
        // insFREJnlLine."Total Cost" := LeaseInvoiceHeader."Total Cost";
        // insFREJnlLine."Total Price" := LeaseInvoiceHeader."Total Price";
        insFREJnlLine."Ledger Entry No." := 0;
        if insFREJnlLine.INSERT then
            Post(insFREJnlLine);
    end;


    procedure Post(FREJnlLine: Record "FRE Jnl. Line")
    var
        recFRELedgerEntry : Record "FRE Ledger Entry";
        insFRELedgerEntry : Record "FRE Ledger Entry";
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
        insFRELedgerEntry."Source Type" := insFRELedgerEntry."Source Type"::Customer;
        insFRELedgerEntry."Source No." := FREJnlLine."Source No.";
        insFRELedgerEntry."Source Name" := FREJnlLine."Source Name";
        insFRELedgerEntry."Document Type" := insFRELedgerEntry."Document Type"::Invoice;
        insFRELedgerEntry."Document No." := FREJnlLine."Document No.";
        insFRELedgerEntry."Row No." := FREJnlLine."Row No.";
        insFRELedgerEntry."Description Row No." := FREJnlLine."Description Row No.";
        insFRELedgerEntry."Total Cost" := FREJnlLine."Total Cost";
        insFRELedgerEntry."Total Price" := FREJnlLine."Total Price";
        insFRELedgerEntry."Ledger Entry No." := FREJnlLine."Ledger Entry No.";
        insFRELedgerEntry.INSERT;
    end;

}