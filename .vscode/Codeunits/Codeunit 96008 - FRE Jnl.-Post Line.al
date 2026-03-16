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
    procedure PostLine(var FREJnlLine: Record "FRE Jnl. Line")
    var
        FRELedgerEntry: Record "FRE Ledger Entry";
        NextEntryNo: Integer;
    begin
        CheckLine(FREJnlLine);

        NextEntryNo := GetNextLedgerEntryNo();

        FRELedgerEntry.Init();
        FRELedgerEntry."Entry No." := NextEntryNo;
        FRELedgerEntry."Journal Template Name" := FREJnlLine."Journal Template Name";
        FRELedgerEntry."Journal Batch Name" := FREJnlLine."Journal Batch Name";
        FRELedgerEntry."Posting Date" := FREJnlLine.Date;
        FRELedgerEntry."Line Type" := FREJnlLine."Line Type";
        FRELedgerEntry."Fixed Real Estate No." := FREJnlLine."Fixed Real Estate No.";
        FRELedgerEntry.Description := FREJnlLine.Description;
        FRELedgerEntry."Row No." := FREJnlLine."Row No.";
        FRELedgerEntry."Description Row No." := FREJnlLine."Description Row No.";
        FRELedgerEntry.Amount := FREJnlLine.Amount;
        FRELedgerEntry."Amount Including VAT" := FREJnlLine."Amount Including VAT";
        FRELedgerEntry."Document Type" := FREJnlLine."Document Type";
        FRELedgerEntry."Document No." := FREJnlLine."Document No.";
        FRELedgerEntry."Source Type" := FREJnlLine."Source Type";
        FRELedgerEntry."Source No." := FREJnlLine."Source No.";
        FRELedgerEntry."Source Name" := FREJnlLine."Source Name";
        FRELedgerEntry."Ledger Entry No." := FREJnlLine."Ledger Entry No.";
        FRELedgerEntry.Insert();

        // Aquí podéis enlazar con vuestra lógica contable o con una codeunit adicional de aplicación.
        // Ejemplo de uso:
        // ApplyEntries(OpenEntryNo, FRELedgerEntry."Entry No.", Abs(FRELedgerEntry.Amount), FRELedgerEntry."Posting Date", FRELedgerEntry."Document No.");

        FREJnlLine.Delete();
    end;

    procedure ApplyEntries(OpenEntryNo: Integer; AppliedEntryNo: Integer; AmountToApply: Decimal; ApplicationDate: Date; DocumentNo: Code[20])
    var
        OpenEntry: Record "FRE Ledger Entry";
        AppliedEntry: Record "FRE Ledger Entry";
        FREDetailedLedgEntry: Record "FRE Detailed Ledg. Entry";
    begin
        if AmountToApply <= 0 then
            Error('El importe a aplicar debe ser mayor que cero.');

        OpenEntry.Get(OpenEntryNo);
        AppliedEntry.Get(AppliedEntryNo);

        FREDetailedLedgEntry.Init();
        FREDetailedLedgEntry."FRE Ledger Entry No." := OpenEntry."Entry No.";
        FREDetailedLedgEntry."Applied FRE Ledger Entry No." := AppliedEntry."Entry No.";
        FREDetailedLedgEntry."Application Date" := ApplicationDate;
        FREDetailedLedgEntry."Posting Date" := AppliedEntry."Posting Date";
        FREDetailedLedgEntry."Document No." := DocumentNo;
        FREDetailedLedgEntry."Document Type" := AppliedEntry."Document Type";
        FREDetailedLedgEntry.Amount := AmountToApply;
        FREDetailedLedgEntry."Fixed Real Estate No." := OpenEntry."Fixed Real Estate No.";
        FREDetailedLedgEntry."Source Type" := AppliedEntry."Source Type";
        FREDetailedLedgEntry."Source No." := AppliedEntry."Source No.";
        FREDetailedLedgEntry."User ID" := CopyStr(UserId(), 1, MaxStrLen(FREDetailedLedgEntry."User ID"));
        FREDetailedLedgEntry."Ledger Entry No." := AppliedEntry."Ledger Entry No.";
        FREDetailedLedgEntry."Initial Entry Amount" := OpenEntry.Amount;
        FREDetailedLedgEntry."Applied Entry Amount" := AppliedEntry.Amount;
        FREDetailedLedgEntry.Insert();

        // IMPORTANTE:
        // Para un control completo de cobros/pagos, os recomiendo añadir en FRE Ledger Entry:
        //  - Open : Boolean
        //  - Remaining Amount : Decimal
        //  - Closed at Date : Date
        //  - Closed by Entry No. : Integer
        // y actualizar esos campos aquí.
    end;

    local procedure CheckLine(var FREJnlLine: Record "FRE Jnl. Line")
    begin
        FREJnlLine.TestField("Journal Template Name");
        FREJnlLine.TestField("Journal Batch Name");
        FREJnlLine.TestField(Date);
        FREJnlLine.TestField("Fixed Real Estate No.");
        FREJnlLine.TestField("Document No.");

        if FREJnlLine.Amount = 0 then
            Error('El importe no puede ser cero.');
    end;

    local procedure GetNextLedgerEntryNo(): Integer
    var
        FRELedgerEntry: Record "FRE Ledger Entry";
    begin
        if FRELedgerEntry.FindLast() then
            exit(FRELedgerEntry."Entry No." + 1);

        exit(1);
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