codeunit 96000 "Real Estate Management"
{

    trigger OnRun()
    begin
    end;

    var
        Text003: Label 'Service contract line(s) included in:';
        Text004: Label 'You cannot sign service contract %1,\because some Service Contract Lines have a missing %2.';
        Text008: Label 'The specified record could not be found.';
        Text009: Label 'Quieres borrar las lineas existentes actualmente';
        REFSetup: Record "REF Setup";
        CarteraSetup: Record "Cartera Setup";
        NoSeriesMgt: Codeunit "No. Series";
        SelectionFilterManagement: Codeunit SelectionFilterManagement;
        SplitPayment: Codeunit "Invoice-Split Payment";
        FileManagement: Codeunit "File Management";
        RealEstateMangement: Codeunit "Real Estate Management";
        CheckMParts: Boolean;
        HideDialog: Boolean;
        Text010: Label 'Do you want to sign lease contract %1?';
        Text011: Label 'Do you want to cancel lease contract %1?';
        Text012: Label 'Signing contract          #1######\';
        Text013: Label 'Processing contract lines #2######\';
        Text014: Label 'Canceling contract          #1######\';
        Text015: Label 'Do you want to create an invoice for the period %1 .. %2?';
        Text019: Label 'You cannot sign service contract with negative annual amount.';
        Text024: Label 'You cannot sign a canceled service contract.';
        Text023: Label 'You cannot sign a service contract if its %1 is not equal to the %2 value.';
        Window: Dialog;
        WPostLine: Integer;
        InvoicingStartingPeriod: Boolean;
        InvoiceNow: Boolean;
        PostingDate: Date;
        InvoiceFrom: Date;
        InvoiceTo: Date;
        GoOut: Boolean;
        CannotCreateCarteraDocErr: Label 'You do not have permissions to create Documents in Cartera.\Please, change the Payment Method.';

    procedure CreateInvoiceLeaseContract(LeaseContract2: Record "Lease Contract"; PostDate: Date; ContractExists: Boolean; var InvoiceHeader2: Record "Sales Header"; var LeaseInvoiceHeader2: Record "Lease Invoice Header") ServInvNo: Code[20]
    var
        Cust: Record Customer;
        REFSetup: Record "REF Setup";
        CurrExchRate: Record "Curr. Exch. Rate Update Setup";
        Cust2: Record Customer;
        FixedRealEstate: Record "Fixed Real Estate";
        UserMgt: Codeunit "User Setup Management";
        RecordLinkManagement: Codeunit "Record Link Management";
        NoSeriesCode: Code[20];
    begin
        //*****
        IF LeaseContract2."Invoice Period" = LeaseContract2."Invoice Period"::None THEN
        EXIT;

        IF PostDate = 0D THEN
        PostDate := WORKDATE;

        FixedRealEstate.GET(LeaseContract2."Fixed Real Estate No.");

        IF FixedRealEstate.Acquired THEN BEGIN
            CLEAR(InvoiceHeader2);
            InvoiceHeader2.INIT;
            InvoiceHeader2.SetHideValidationDialog(TRUE);
            InvoiceHeader2."Document Type" := InvoiceHeader2."Document Type"::Invoice;
            REFSetup.GET ;
            REFSetup.TESTFIELD("Contract Invoice Nos.");
            InvoiceHeader2.INSERT(TRUE);
            ServInvNo := InvoiceHeader2."No.";

            InvoiceHeader2."Order Date" := WORKDATE;
            InvoiceHeader2."Posting Description" :='Recibo alquiler No.: ' + InvoiceHeader2."No.";
            InvoiceHeader2.VALIDATE("Sell-to Customer No.",LeaseContract2."Customer No.");
            IF LeaseContract2."Second Customer No."<>'' THEN
                InvoiceHeader2.VALIDATE("Bill-to Customer No.",LeaseContract2."Second Customer No.");


            InvoiceHeader2."Prices Including VAT" := FALSE;

            Cust.GET(InvoiceHeader2."Sell-to Customer No.");
            InvoiceHeader2."Responsibility Center" := Cust."Responsibility Center";

            Cust.CheckBlockedCustOnDocs(Cust,InvoiceHeader2."Document Type",FALSE,FALSE);

            Cust.TESTFIELD("Gen. Bus. Posting Group");
            InvoiceHeader2."Sell-to Customer Name" := Cust.Name;
            InvoiceHeader2."Sell-to Customer Name 2" := Cust."Name 2";
            InvoiceHeader2."Sell-to Address" := Cust.Address;
            InvoiceHeader2."Sell-to Address 2" := Cust."Address 2";
            InvoiceHeader2."Sell-to City" := Cust.City;
            InvoiceHeader2."Sell-to Post Code" := Cust."Post Code";
            InvoiceHeader2."Sell-to County" := Cust.County;
            InvoiceHeader2."Sell-to Country/Region Code" := Cust."Country/Region Code";
            InvoiceHeader2."Sell-to Contact" := LeaseContract2."Contact Name";
            InvoiceHeader2."Sell-to Contact No." := LeaseContract2."Contact No.";
            InvoiceHeader2."Bill-to Contact No." := LeaseContract2."Second Contact No.";
            InvoiceHeader2."Bill-to Contact" := LeaseContract2."Second Contact";
            InvoiceHeader2."VAT Registration No." := Cust."VAT Registration No.";
            InvoiceHeader2."Sell-to E-Mail" := Cust."E-Mail";

            IF NOT ContractExists THEN
            InvoiceHeader2.VALIDATE("Posting Date",PostDate);
            InvoiceHeader2.VALIDATE("Document Date",PostDate);
            InvoiceHeader2."Contract No." := LeaseContract2."Contract No.";
            InvoiceHeader2."Gen. Bus. Posting Group" := Cust."Gen. Bus. Posting Group";
            InvoiceHeader2.VALIDATE("Payment Terms Code",LeaseContract2."Payment Terms Code");
            InvoiceHeader2.VALIDATE("Payment Method Code",LeaseContract2."Payment Method Code");


            IF LeaseContract2."Second Customer No."<>'' THEN BEGIN
                Cust2.GET(LeaseContract2."Second Customer No.");
                InvoiceHeader2."VAT Bus. Posting Group" := Cust2."VAT Bus. Posting Group";
            END ELSE
                InvoiceHeader2."VAT Bus. Posting Group" := Cust."VAT Bus. Posting Group";

            InvoiceHeader2.VALIDATE("Payment Terms Code",LeaseContract2."Payment Terms Code");
            InvoiceHeader2."Your Reference" := LeaseContract2."Your Reference";
            InvoiceHeader2.MODIFY
        END ELSE BEGIN
        CLEAR(LeaseInvoiceHeader2);
            LeaseInvoiceHeader2.INIT;
            REFSetup.GET ;
            REFSetup.TESTFIELD("Contract Lease Invoice Nos.");

            LeaseInvoiceHeader2.INSERT(TRUE);
            ServInvNo := LeaseInvoiceHeader2."No.";

            LeaseInvoiceHeader2."Posting Description" := 'Recibo alquiler No.: ' + LeaseInvoiceHeader2."No.";
            LeaseInvoiceHeader2.VALIDATE("Customer No.",LeaseContract2."Customer No.");

            LeaseInvoiceHeader2."Prices Including VAT" := FALSE;

            Cust.GET(LeaseInvoiceHeader2."Customer No.");
            LeaseInvoiceHeader2."Responsibility Center" := Cust."Responsibility Center";

            Cust.TESTFIELD("Gen. Bus. Posting Group");
            LeaseInvoiceHeader2."Customer No." := Cust."No.";
            LeaseInvoiceHeader2.Name := Cust.Name;
            LeaseInvoiceHeader2."Name 2" := Cust."Name 2";
            LeaseInvoiceHeader2.Address := Cust.Address;
            LeaseInvoiceHeader2."Address 2" := Cust."Address 2";
            LeaseInvoiceHeader2.City := Cust.City;
            LeaseInvoiceHeader2."Post Code" := Cust."Post Code";
            LeaseInvoiceHeader2.County := Cust.County;
            LeaseInvoiceHeader2."Country/Region Code" := Cust."Country/Region Code";
            LeaseInvoiceHeader2."Contact Name" := LeaseContract2."Contact Name";
            LeaseInvoiceHeader2."Contact No." := LeaseContract2."Contact No.";
            LeaseInvoiceHeader2."VAT Registration No." := Cust."VAT Registration No.";
            LeaseInvoiceHeader2."E-Mail" := Cust."E-Mail";
            LeaseInvoiceHeader2."Notify Customer" := LeaseContract2."Notify Customer";


            IF NOT ContractExists THEN
            LeaseInvoiceHeader2.VALIDATE("Posting Date",PostDate);
            LeaseInvoiceHeader2.VALIDATE("Document Date",PostDate);
            LeaseInvoiceHeader2."Contract No." := LeaseContract2."Contract No.";
            LeaseInvoiceHeader2."Fixed Real Estate No." := LeaseContract2."Fixed Real Estate No.";
            LeaseInvoiceHeader2."Gen. Bus. Posting Group" := Cust."Gen. Bus. Posting Group";
            LeaseInvoiceHeader2.VALIDATE("Payment Terms Code",LeaseContract2."Payment Terms Code");
            LeaseInvoiceHeader2.VALIDATE("Payment Method Code",LeaseContract2."Payment Method Code");

            IF LeaseContract2."Second Customer No."<>'' THEN BEGIN
                Cust2.GET(LeaseContract2."Second Customer No.");
                LeaseInvoiceHeader2."VAT Bus. Posting Group" := Cust2."VAT Bus. Posting Group";
            END ELSE
                LeaseInvoiceHeader2."VAT Bus. Posting Group" := Cust."VAT Bus. Posting Group";

            LeaseInvoiceHeader2.VALIDATE("Payment Terms Code",LeaseContract2."Payment Terms Code");
            LeaseInvoiceHeader2."Your Reference" := LeaseContract2."Your Reference";
            LeaseInvoiceHeader2.MODIFY;
        END;
    end;

    // procedure CreateInvoiceLeaseContract(LeaseContract2: Record "Lease Contract"; PostDate: Date; ContractExists: Boolean; var InvoiceHeader2: Record "Sales Header") ServInvNo: Code[20]
    // var
    //     InvoiceHeaderAux: Record "Sales Header";
    //     LeaseInvoiceHeader2: Record "Lease Invoice Header";
    //     Cust: Record Customer;
    //     REFSetup: Record "REF Setup";
    //     CurrExchRate: Record "Curr. Exch. Rate Update Setup";
    //     Cust2: Record Customer;
    //     FixedRealEstate: Record "Fixed Real Estate";
    //     UserMgt: Codeunit "User Management";
    //     RecordLinkManagement: Codeunit "Record Link Management";
    //     NoSeriesCode: Code[20];
    // begin
    //     IF PostDate = 0D THEN
    //         PostDate := WORKDATE;

    //     FixedRealEstate.GET(LeaseContract2."Fixed Real Estate No.");

    //     IF LeaseContract2."Lease Manag. Amount per Period" <> 0 THEN BEGIN
    //         IF GetOwnerCustomerRealEstateAssets(LeaseContract2, Cust) THEN BEGIN
    //             InvoiceHeaderAux.RESET;
    //             InvoiceHeaderAux.SETRANGE("Document Type", InvoiceHeaderAux."Document Type"::Invoice);
    //             InvoiceHeaderAux.SETRANGE("Sell-to Customer No.", Cust."No.");
    //             InvoiceHeaderAux.SETRANGE("Posting Date", PostDate);
    //             IF NOT InvoiceHeaderAux.FINDFIRST THEN BEGIN
    //                 CLEAR(InvoiceHeader2);
    //                 InvoiceHeader2.INIT;
    //                 InvoiceHeader2.SetHideValidationDialog(TRUE);
    //                 InvoiceHeader2."Document Type" := InvoiceHeader2."Document Type"::Invoice;
    //                 REFSetup.GET;
    //                 REFSetup.TESTFIELD("Contract Invoice Nos.");
    //                 // NoSeriesMgt.InitSeries(
    //                 //   REFSetup."Contract Invoice Nos.", '',
    //                 //   PostDate, InvoiceHeader2."No.", InvoiceHeader2."No. Series");
    //                 NoSeriesCode := REFSetup."Contract Invoice Nos.";
    //                 InvoiceHeader2."No." := NoSeriesMgt.GetNextNo(NoSeriesCode, WorkDate(), true);
    //                 InvoiceHeader2.INSERT(TRUE);
    //                 InvoiceHeader2.INSERT(TRUE);
    //                 ServInvNo := InvoiceHeader2."No.";

    //                 InvoiceHeader2."Order Date" := WORKDATE;
    //                 InvoiceHeader2."Posting Description" := 'Gestión contrato alquiler No.: ' + LeaseContract2."Contract No.";
    //                 InvoiceHeader2.VALIDATE("Sell-to Customer No.", Cust."No.");
    //                 InvoiceHeader2."Prices Including VAT" := FALSE;
    //                 InvoiceHeader2."Responsibility Center" := Cust."Responsibility Center";
    //                 Cust.CheckBlockedCustOnDocs(Cust, InvoiceHeader2."Document Type", FALSE, FALSE);

    //                 Cust.TESTFIELD("Gen. Bus. Posting Group");
    //                 InvoiceHeader2."Sell-to Customer Name" := Cust.Name;
    //                 InvoiceHeader2."Sell-to Customer Name 2" := Cust."Name 2";
    //                 InvoiceHeader2."Sell-to Address" := Cust.Address;
    //                 InvoiceHeader2."Sell-to Address 2" := Cust."Address 2";
    //                 InvoiceHeader2."Sell-to City" := Cust.City;
    //                 InvoiceHeader2."Sell-to Post Code" := Cust."Post Code";
    //                 InvoiceHeader2."Sell-to County" := Cust.County;
    //                 InvoiceHeader2."Sell-to Country/Region Code" := Cust."Country/Region Code";
    //                 InvoiceHeader2."Sell-to Contact" := LeaseContract2."Contact Name";
    //                 InvoiceHeader2."Sell-to Contact No." := LeaseContract2."Contact No.";
    //                 InvoiceHeader2."Bill-to Contact No." := LeaseContract2."Second Contact No.";
    //                 InvoiceHeader2."Bill-to Contact" := LeaseContract2."Second Contact";
    //                 InvoiceHeader2."VAT Registration No." := Cust."VAT Registration No.";
    //                 InvoiceHeader2."Sell-to E-Mail" := Cust."E-Mail";

    //                 IF NOT ContractExists THEN
    //                     InvoiceHeader2.VALIDATE("Posting Date", PostDate);
    //                 InvoiceHeader2.VALIDATE("Document Date", PostDate);
    //                 InvoiceHeader2."Contract No." := LeaseContract2."Contract No.";
    //                 InvoiceHeader2."Gen. Bus. Posting Group" := Cust."Gen. Bus. Posting Group";
    //                 InvoiceHeader2.VALIDATE("Payment Terms Code", LeaseContract2."Payment Terms Code");
    //                 InvoiceHeader2.VALIDATE("Payment Method Code", LeaseContract2."Payment Method Code");


    //                 IF LeaseContract2."Second Customer No." <> '' THEN BEGIN
    //                     Cust2.GET(LeaseContract2."Second Customer No.");
    //                     InvoiceHeader2."VAT Bus. Posting Group" := Cust2."VAT Bus. Posting Group";
    //                 END ELSE
    //                     InvoiceHeader2."VAT Bus. Posting Group" := Cust."VAT Bus. Posting Group";

    //                 InvoiceHeader2.VALIDATE("Payment Terms Code", LeaseContract2."Payment Terms Code");
    //                 InvoiceHeader2."Your Reference" := LeaseContract2."Your Reference";
    //                 InvoiceHeader2."Prices Including VAT" := TRUE;
    //                 InvoiceHeader2.MODIFY;
    //             END ELSE BEGIN
    //                 InvoiceHeader2 := InvoiceHeaderAux;
    //             END;
    //             CreateLineServiceContractLine(InvoiceHeader2, LeaseContract2."Contract No.");

    //         END;
    //     END;
    // end;

    procedure CreateAllLeaseContractLines(InvNo: Code[20]; LeaseContractToInvoice: Record "Lease Contract"; InvoiceHeader: Record "Sales Header"; LeaseInvoiceHeader: Record "Lease Invoice Header")
    var
        FixedRealEstate: Record "Fixed Real Estate";
        LeaseContractLine: Record "Lease Contract Line";
        InvoiceFrom: Date;
        InvoiceTo: Date;
    begin
        FixedRealEstate.GET(LeaseContractToInvoice."Fixed Real Estate No.");

        GetNextInvoicePeriod(LeaseContractToInvoice, InvoiceFrom, InvoiceTo);

        IF FixedRealEstate.Acquired THEN BEGIN
            LeaseContractLine.RESET;
            LeaseContractLine.SETRANGE("Contract No.", LeaseContractToInvoice."Contract No.");
            IF LeaseContractLine.FIND('-') THEN
                REPEAT
                    CreateLeaseContractLine(
                        InvoiceHeader, LeaseContractToInvoice."Contract No.", LeaseContractLine, InvoiceFrom, InvoiceTo, FALSE)
                UNTIL LeaseContractLine.NEXT = 0;
        END;
        LeaseContractLine.RESET;
        LeaseContractLine.SETRANGE("Contract No.", LeaseContractToInvoice."Contract No.");
        IF LeaseContractLine.FIND('-') THEN
            REPEAT
                CreateLeaseContractLine2(
                    LeaseInvoiceHeader, LeaseContractToInvoice."Contract No.", LeaseContractLine, InvoiceFrom, InvoiceTo, FALSE)
            UNTIL LeaseContractLine.NEXT = 0;
        LeaseContractToInvoice.VALIDATE("Last Invoice Date", LeaseContractToInvoice."Next Invoice Date");
        LeaseContractToInvoice.MODIFY;
    
    end;

    procedure CreateLeaseContractLine(InvoiceHeader: Record "Sales Header"; ContractNo: Code[20]; LeaseContractLine: Record "Lease Contract Line"; InvFrom: Date; InvTo: Date; SignningContract: Boolean)
    var
        LeaseContract: Record "Lease Contract";
        InvoiceLine: Record "Sales Line";
        Cust: Record Customer;
        REFSetup: Record "REF Setup";
        InvoiceLineNo: Integer;
        FirstLine: Boolean;
    begin

        LeaseContract.GET(ContractNo);

        IF LeaseContract."Invoice Period" = LeaseContract."Invoice Period"::None THEN
            EXIT;

        InvoiceLineNo := 0;
        InvoiceLine.SETRANGE("Document Type", InvoiceLine."Document Type"::Invoice);
        InvoiceLine.SETRANGE("Document No.", InvoiceHeader."No.");
        IF InvoiceLine.FINDLAST THEN BEGIN
            InvoiceLineNo := InvoiceLine."Line No.";
            InvoiceLine.INIT;
        END ELSE BEGIN
            FirstLine := TRUE;
        END;
        IF LeaseContract."Second Customer No." <> '' THEN
            Cust.GET(LeaseContract."Second Customer No.")
        ELSE
            Cust.GET(LeaseContract."Customer No.");

        InvoiceLine.RESET;

        IF FirstLine THEN
            REFSetup.GET;

        IF FirstLine THEN BEGIN
            InvoiceLine.INIT;
            InvoiceLineNo := InvoiceLineNo + 10000;
            InvoiceLine."Document Type" := InvoiceHeader."Document Type";
            InvoiceLine."Document No." := InvoiceHeader."No.";
            InvoiceLine."Line No." := InvoiceLineNo;
            InvoiceLine.Type := InvoiceLine.Type::" ";
            InvoiceLine.Description := STRSUBSTNO('Contrato no.: %1', LeaseContractLine."Contract No.");
            InvoiceLine.INSERT;
        END;

        InvoiceLine.INIT;
        InvoiceLineNo := InvoiceLineNo + 10000;
        InvoiceLine."Document No." := InvoiceHeader."No.";
        InvoiceLine."Line No." := InvoiceLineNo;
        InvoiceLine.Type := InvoiceLine.Type::"G/L Account";
        InvoiceLine.VALIDATE("No.", LeaseContractLine."Account No.");
        InvoiceLine.Description := STRSUBSTNO(LeaseContractLine.Description,
          FORMAT(InvoiceHeader."Posting Date", 0, '<Month Text>'));
        InvoiceLine.VALIDATE("VAT Bus. Posting Group", InvoiceHeader."VAT Bus. Posting Group");
        InvoiceLine.VALIDATE(Quantity, 1);
        InvoiceLine.VALIDATE("VAT Prod. Posting Group", LeaseContractLine."VAT Prod. Posting Group");
        InvoiceLine.VALIDATE("Unit Price", LeaseContractLine.Amount);
        InvoiceLine.INSERT;
        IF LeaseContractLine."Shortcut Dimension 1 Code" <> '' THEN BEGIN
            InvoiceLine.VALIDATE("Shortcut Dimension 1 Code", LeaseContractLine."Shortcut Dimension 1 Code");
            InvoiceLine.MODIFY;
        END;
    end;

    procedure CreateLeaseContractLine2(InvoiceHeader: Record "Lease Invoice Header"; ContractNo: Code[20]; LeaseContractLine: Record "Lease Contract Line"; InvFrom: Date; InvTo: Date; SignningContract: Boolean)
    var
        LeaseContract: Record "Lease Contract";
        InvoiceLine: Record "Lease Invoice Line";
        Cust: Record Customer;
        REFSetup: Record "REF Setup";
        InvoiceLineNo: Integer;
        FirstLine: Boolean;
    begin

        LeaseContract.GET(ContractNo);

        IF LeaseContract."Invoice Period" = LeaseContract."Invoice Period"::None THEN
            EXIT;

        InvoiceLineNo := 0;
        InvoiceLine.SETRANGE("Document No.", InvoiceHeader."No.");
        IF InvoiceLine.FINDLAST THEN BEGIN
            InvoiceLineNo := InvoiceLine."Line No.";
            InvoiceLine.INIT;
        END ELSE BEGIN
            FirstLine := TRUE;
        END;
        IF LeaseContract."Second Customer No." <> '' THEN
            Cust.GET(LeaseContract."Second Customer No.")
        ELSE
            Cust.GET(LeaseContract."Customer No.");

        InvoiceLine.RESET;

        IF FirstLine THEN
            REFSetup.GET;

        IF FirstLine THEN BEGIN
            InvoiceLine.INIT;
            InvoiceLineNo := InvoiceLineNo + 10000;
            InvoiceLine."Document No." := InvoiceHeader."No.";
            InvoiceLine."Line No." := InvoiceLineNo;
            InvoiceLine.Type := InvoiceLine.Type::" ";
            InvoiceLine.Description := STRSUBSTNO('Contrato no.: %1', LeaseContractLine."Contract No.");
            InvoiceLine.INSERT;
        END;

        InvoiceLine.INIT;
        InvoiceLineNo := InvoiceLineNo + 10000;
        InvoiceLine."Document No." := InvoiceHeader."No.";
        InvoiceLine."Line No." := InvoiceLineNo;
        InvoiceLine.Type := InvoiceLine.Type::"G/L Account";
        InvoiceLine.VALIDATE("No.", LeaseContractLine."Account No.");
        InvoiceLine.Description := STRSUBSTNO(LeaseContractLine.Description,
          FORMAT(InvoiceHeader."Posting Date", 0, '<Month Text>'));

        InvoiceLine.VALIDATE("VAT Bus. Posting Group", InvoiceHeader."VAT Bus. Posting Group");
        InvoiceLine.VALIDATE(Quantity, 1);
        InvoiceLine.VALIDATE("VAT Prod. Posting Group", LeaseContractLine."VAT Prod. Posting Group");
        InvoiceLine.VALIDATE("Unit Price", LeaseContractLine.Amount);
        InvoiceLine."Posting Date" := InvoiceHeader."Posting Date";
        InvoiceLine."Customer No." := InvoiceHeader."Customer No.";
        InvoiceLine."Contract No." := InvoiceHeader."Contract No.";
        InvoiceLine."Fixed Real Estate No." := InvoiceHeader."Fixed Real Estate No.";
        InvoiceLine.INSERT;
    end;

    // procedure CreateLineServiceContractLine(InvoiceHeader: Record "Sales Header"; ContractNo: Code[20])
    // var
    //     LeaseContract: Record "Lease Contract";
    //     InvoiceLine: Record "Sales Line";
    //     Cust: Record Customer;
    //     REFSetup: Record "REF Setup";
    //     InvoiceLineNo: Integer;
    //     FirstLine: Boolean;
    // begin

    //     LeaseContract.GET(ContractNo);

    //     InvoiceLineNo := 0;
    //     InvoiceLine.SETRANGE("Document Type", InvoiceLine."Document Type"::Invoice);
    //     InvoiceLine.SETRANGE("Document No.", InvoiceHeader."No.");
    //     IF InvoiceLine.FINDLAST THEN BEGIN
    //         InvoiceLineNo := InvoiceLine."Line No.";
    //         InvoiceLine.INIT;
    //     END ELSE BEGIN
    //         FirstLine := TRUE;
    //     END;

    //     InvoiceLine.RESET;

    //     REFSetup.GET;

    //     REFSetup.TESTFIELD("Service Charge Acc.");
    //     InvoiceLine.INIT;
    //     InvoiceLineNo := InvoiceLineNo + 10000;
    //     InvoiceLine."Document Type" := InvoiceLine."Document Type"::Invoice;
    //     InvoiceLine."Document No." := InvoiceHeader."No.";
    //     InvoiceLine."Line No." := InvoiceLineNo;
    //     InvoiceLine.Type := InvoiceLine.Type::"G/L Account";
    //     InvoiceLine.VALIDATE("No.", REFSetup."Service Charge Acc.");
    //     InvoiceLine.Description := STRSUBSTNO('Admon alquiler %2 periodo %1',
    //       FORMAT(InvoiceHeader."Posting Date", 0, '<Month Text>'), LeaseContract."Contract No.");
    //     InvoiceLine.VALIDATE("VAT Bus. Posting Group", InvoiceHeader."VAT Bus. Posting Group");
    //     InvoiceLine.VALIDATE(Quantity, 1);
    //     InvoiceLine.VALIDATE("Unit Price", LeaseContract."Lease Manag. Amount per Period");
    //     InvoiceLine.INSERT;
    // end;

    procedure CreateBills(var LeaseInvoiceHeader: Record "Lease Invoice Header")
    var
        PaymentMethod: Record "Payment Method";
    begin
        // Create Bills
        IF PaymentMethod.GET(LeaseInvoiceHeader."Payment Method Code") THEN
            IF (PaymentMethod."Create Bills" OR PaymentMethod."Invoices to Cartera") AND
               (NOT CarteraSetup.READPERMISSION) THEN
                ERROR(CannotCreateCarteraDocErr);

        SplitLeaseInvoice(LeaseInvoiceHeader);
    end;

    procedure SplitLeaseInvoice(var LeaseInvoiceHeader: Record "Lease Invoice Header")
    var
        VATPostingSetup: Record "VAT Posting Setup";
        SepaDirectDebitMandate: Record "SEPA Direct Debit Mandate";
        PaymentMethod: Record "Payment Method";
        PaymentTerms: Record "Payment Terms";
        GenJnlLine: Record "Gen. Journal Line";
        GenJnlLine2: Record "Gen. Journal Line";
        GLSetup: Record "General Ledger Setup";
        SalesSetup: Record "Sales & Receivables Setup";
        Currency: Record Currency;
        CurrDocNo: Integer;
        CurrencyFactor: Decimal;
        VATAmountLCY: Decimal;
        TotalAmount: Decimal;
        TotalAmountLCY: Decimal;
        RemainingAmount: Decimal;
        RemainingAmountLCY: Decimal;
        ExistsVATNoReal: Boolean;
        ErrorMessage: Boolean;
        NextDueDate: Date;
        GenJnlPostLine: Codeunit "Gen. Jnl.-Post Line";
        Text1100001: Label '%1 debe ser 1 si %2 is Sí en %3';
        Text1100002: Label 'Recibo alquiler %1 de %2';
        Text1100004: Label 'Efecto %1/%2';
    begin
        CurrDocNo := 1;
        IF NOT PaymentMethod.GET(LeaseInvoiceHeader."Payment Method Code") THEN
            EXIT;
        IF (NOT PaymentMethod."Create Bills") AND (NOT PaymentMethod."Invoices to Cartera") THEN
            EXIT;

        IF LeaseInvoiceHeader."Currency Code" = '' THEN
            CurrencyFactor := 1
        ELSE
            CurrencyFactor := LeaseInvoiceHeader."Currency Factor";

        GLSetup.GET;
        SalesSetup.GET;
        LeaseInvoiceHeader.TESTFIELD("Payment Terms Code");
        PaymentTerms.GET(LeaseInvoiceHeader."Payment Terms Code");
        PaymentTerms.CALCFIELDS("No. of Installments");
        IF PaymentTerms."No. of Installments" = 0 THEN
            PaymentTerms."No. of Installments" := 1;
        IF PaymentMethod."Invoices to Cartera" AND (PaymentTerms."No. of Installments" > 1) THEN
            ERROR(
            Text1100001,
            PaymentTerms.FIELDCAPTION("No. of Installments"),
            PaymentMethod.FIELDCAPTION("Invoices to Cartera"),
            PaymentMethod.TABLECAPTION);

        LeaseInvoiceHeader.CALCFIELDS(Amount,"Amount Including VAT");
        TotalAmount := LeaseInvoiceHeader."Amount Including VAT";
        TotalAmountLCY := LeaseInvoiceHeader."Amount Including VAT";
        RemainingAmount := TotalAmount;
        RemainingAmountLCY := TotalAmountLCY;

        // close invoice entry
        IF PaymentMethod."Create Bills" THEN BEGIN
            GenJnlLine.INIT;
            GenJnlLine."Posting Date" := LeaseInvoiceHeader."Posting Date";
            GenJnlLine."Document Date" := LeaseInvoiceHeader."Document Date";
            GenJnlLine.VALIDATE("Account Type",GenJnlLine."Account Type"::Customer);
            GenJnlLine.VALIDATE("Account No.",LeaseInvoiceHeader."Customer No.");
            GenJnlLine."Document Type" := GenJnlLine."Document Type"::" ";
            GenJnlLine."Document No." := LeaseInvoiceHeader."No.";
            GenJnlLine.Description := COPYSTR(STRSUBSTNO(Text1100002,LeaseInvoiceHeader."No.",LeaseInvoiceHeader.Name),1,MAXSTRLEN(GenJnlLine.Description));
            GenJnlLine."Shortcut Dimension 1 Code" := LeaseInvoiceHeader."Shortcut Dimension 1 Code";
            GenJnlLine."Shortcut Dimension 2 Code" := LeaseInvoiceHeader."Shortcut Dimension 2 Code";
            GenJnlLine."External Document No." := LeaseInvoiceHeader."No.";
            GenJnlLine.VALIDATE("Currency Code",LeaseInvoiceHeader."Currency Code");
            GenJnlLine.Amount := -TotalAmount;
            GenJnlLine."Amount (LCY)" := -TotalAmountLCY;
            GenJnlLine."System-Created Entry" := TRUE;
            GenJnlLine."Currency Factor" := CurrencyFactor;
            GenJnlLine."Payment Terms Code" := LeaseInvoiceHeader."Payment Terms Code";
            GenJnlLine."Payment Method Code" := LeaseInvoiceHeader."Payment Method Code";
            GenJnlLine."Salespers./Purch. Code" := LeaseInvoiceHeader."Salesperson Code";
            GenJnlLine.Amount := -TotalAmount;
            GenJnlLine."Amount (LCY)" := -TotalAmountLCY;

            IF GLSetup."Unrealized VAT" AND ExistsVATNoReal THEN
            GenJnlLine2.COPY(GenJnlLine)
            ELSE
            GenJnlPostLine.RUN(GenJnlLine);
        END;

        // create bills
        IF LeaseInvoiceHeader."Currency Code" = '' THEN BEGIN
            Currency."Invoice Rounding Type" := GLSetup."Inv. Rounding Type (LCY)";
            Currency."Amount Rounding Precision" := GLSetup."Amount Rounding Precision";
            IF SalesSetup."Invoice Rounding" THEN
            GLSetup.TESTFIELD("Inv. Rounding Precision (LCY)")
            ELSE
            GLSetup.TESTFIELD("Amount Rounding Precision");
        END ELSE BEGIN
            Currency.GET(LeaseInvoiceHeader."Currency Code");
            IF SalesSetup."Invoice Rounding" THEN
            Currency.TESTFIELD("Invoice Rounding Precision")
            ELSE
            Currency.TESTFIELD("Amount Rounding Precision");
        END;


        NextDueDate := LeaseInvoiceHeader."Due Date";

        GenJnlLine.INIT;
        GenJnlLine."Posting Date" := LeaseInvoiceHeader."Posting Date";
        GenJnlLine."Document Date" := LeaseInvoiceHeader."Document Date";
        GenJnlLine.VALIDATE("Account Type",GenJnlLine."Account Type"::Customer);
        GenJnlLine.VALIDATE("Account No.",LeaseInvoiceHeader."Customer No.");
        GenJnlLine."Document Type" := GenJnlLine."Document Type"::Bill;
        GenJnlLine."Document No." := LeaseInvoiceHeader."No.";
        GenJnlLine."Shortcut Dimension 1 Code" := LeaseInvoiceHeader."Shortcut Dimension 1 Code";
        GenJnlLine."Shortcut Dimension 2 Code" := LeaseInvoiceHeader."Shortcut Dimension 2 Code";
        GenJnlLine."External Document No." := LeaseInvoiceHeader."No.";
        GenJnlLine.VALIDATE("Currency Code",LeaseInvoiceHeader."Currency Code");
        GenJnlLine."System-Created Entry" := TRUE;
        GenJnlLine."Currency Factor" := CurrencyFactor;
        GenJnlLine."Payment Terms Code" := LeaseInvoiceHeader."Payment Terms Code";
        GenJnlLine."Payment Method Code" := LeaseInvoiceHeader."Payment Method Code";
        GenJnlLine."Salespers./Purch. Code" := LeaseInvoiceHeader."Salesperson Code";
        GenJnlLine."Bill No." := FORMAT(CurrDocNo);
        GenJnlLine.Description :=
            COPYSTR(STRSUBSTNO(Text1100004,LeaseInvoiceHeader."No.",CurrDocNo),1,MAXSTRLEN(GenJnlLine.Description));
        GenJnlLine."Due Date" := NextDueDate;
        GenJnlLine.Amount := TotalAmount;
        GenJnlLine."Amount (LCY)" := TotalAmountLCY;
        IF PaymentMethod."Create Bills" THEN
            GenJnlPostLine.RUN(GenJnlLine);
        MESSAGE('Se ha registrado el efecto');
    end;
    
    procedure GetNextInvoicePeriod(LeaseContract: Record "Lease Contract"; var InvFrom: Date; var InvTo: Date)
    begin
        InvFrom := LeaseContract."Next Invoice Period Start";
        InvTo := LeaseContract."Next Invoice Period End";
    end;

    procedure CheckIfServiceExist(LeaseContract: Record "Lease Contract"): Boolean
    var
        LeaseContractLine: Record "Lease Contract Line";
    begin
        LeaseContractLine.RESET;
        LeaseContractLine.SETRANGE("Contract No.", LeaseContract."Contract No.");
        EXIT(LeaseContractLine.FINDFIRST);
    end;

    procedure CalcContractAmount(LeaseContract: Record "Lease Contract"; PeriodStarts: Date; PeriodEnds: Date) AmountCalculated: Decimal
    var
        LeaseContractLine: Record "Lease Contract Line";
        Currency: Record Currency;
        LinePeriodStarts: Date;
        LinePeriodEnds: Date;
        ContractLineIncluded: Boolean;
    begin

        Currency.InitRoundingPrecision;
        AmountCalculated := 0;

        LeaseContractLine.RESET;
        LeaseContractLine.SETRANGE("Contract No.", LeaseContract."Contract No.");
        // LeaseContractLine.SETRANGE("Base Contract",TRUE);

        IF LeaseContractLine.FIND('-') THEN BEGIN
            REPEAT
                AmountCalculated := AmountCalculated + LeaseContractLine."VAT Base Amount";
            UNTIL LeaseContractLine.NEXT = 0;
            AmountCalculated := ROUND(AmountCalculated, Currency."Amount Rounding Precision");
        END ELSE BEGIN
            LeaseContractLine.SETRANGE("Starting Date");
            LeaseContractLine.SETRANGE("Invoiced to Date");
            IF LeaseContractLine.ISEMPTY THEN
                AmountCalculated :=
                  ROUND(
                    LeaseContract."Annual Amount" / 12 * NoOfMonthsAndMPartsInPeriod(PeriodStarts, PeriodEnds),
                    Currency."Amount Rounding Precision");
        END;
    end;

    procedure GetOwnerCustomerRealEstateAssets(LeaseContract: Record "Lease Contract"; var Customer: Record Customer): Boolean
    var
        ContactBusinessRelation: Record "Contact Business Relation";
        REFRelatedContactos: Record "REF Related Contactos";
    begin
        // Propiedad
        REFRelatedContactos.SETRANGE("Entity Type", REFRelatedContactos."Entity Type"::"Fixed Real Estate");
        REFRelatedContactos.SETRANGE("Source No.", LeaseContract."Fixed Real Estate No.");
        REFRelatedContactos.SETRANGE(Type, REFRelatedContactos.Type::Owner);
        IF REFRelatedContactos.FINDFIRST THEN BEGIN
            ContactBusinessRelation.RESET;
            ContactBusinessRelation.SETRANGE("Contact No.", REFRelatedContactos."Contact No.");
            ContactBusinessRelation.SETRANGE("Link to Table", ContactBusinessRelation."Link to Table"::Customer);
            IF ContactBusinessRelation.FINDFIRST THEN BEGIN
                Customer.GET(ContactBusinessRelation."No.");
                EXIT(TRUE)
            END;
        END;
        EXIT(FALSE);
    end;

    procedure NoOfMonthsAndDaysInPeriod(Day1: Date; Day2: Date; var NoOfMonthsInPeriod: Integer; var NoOfDaysInPeriod: Integer)
    var
        Wdate: Date;
        FirstDayinCrntMonth: Date;
        LastDayinCrntMonth: Date;
    begin
        NoOfMonthsInPeriod := 0;
        NoOfDaysInPeriod := 0;

        IF Day1 > Day2 THEN
            EXIT;
        IF Day1 = 0D THEN
            EXIT;
        IF Day2 = 0D THEN
            EXIT;

        Wdate := Day1;
        REPEAT
            FirstDayinCrntMonth := CALCDATE('<-CM>', Wdate);
            LastDayinCrntMonth := CALCDATE('<CM>', Wdate);
            IF (Wdate = FirstDayinCrntMonth) AND (LastDayinCrntMonth <= Day2) THEN BEGIN
                NoOfMonthsInPeriod := NoOfMonthsInPeriod + 1;
                Wdate := LastDayinCrntMonth + 1;
            END ELSE BEGIN
                NoOfDaysInPeriod := NoOfDaysInPeriod + 1;
                Wdate := Wdate + 1;
            END;
        UNTIL Wdate > Day2;
    end;

    procedure LoadItemFREAttributesFactBoxData(KeyValue : Code[20])
    var
    ItemAttributeValue : record "Item Attribute Value";
    ItemAttributeValueMapping : record "Item Attribute Value Mapping";
    begin
        ItemAttributeValue.RESET;
        ItemAttributeValue.DELETEALL;
        ItemAttributeValueMapping.SETRANGE("Table ID",DATABASE::"Fixed Real Estate");
        ItemAttributeValueMapping.SETRANGE("No.",KeyValue);
        IF ItemAttributeValueMapping.FINDSET THEN
        REPEAT
            IF ItemAttributeValue.GET(ItemAttributeValueMapping."Item Attribute ID",ItemAttributeValueMapping."Item Attribute Value ID") THEN BEGIN
                ItemAttributeValue.TRANSFERFIELDS(ItemAttributeValue);
                ItemAttributeValue.INSERT;
            END
    UNTIL ItemAttributeValueMapping.NEXT = 0;
    end;
    procedure NoOfMonthsAndMPartsInPeriod(Day1: Date; Day2: Date) MonthsAndMParts: Decimal
    var
        WDate: Date;
        OldWDate: Date;
    begin
        IF Day1 > Day2 THEN
            EXIT;
        IF (Day1 = 0D) OR (Day2 = 0D) THEN
            EXIT;
        MonthsAndMParts := 0;

        WDate := CALCDATE('<-CM>', Day1);
        REPEAT
            OldWDate := CALCDATE('<CM>', WDate);
            IF WDate < Day1 THEN
                WDate := Day1;
            IF OldWDate > Day2 THEN
                OldWDate := Day2;
            IF (WDate <> CALCDATE('<-CM>', WDate)) OR (OldWDate <> CALCDATE('<CM>', OldWDate)) THEN
                MonthsAndMParts := MonthsAndMParts +
                  (OldWDate - WDate + 1) / (CALCDATE('<CM>', OldWDate) - CALCDATE('<-CM>', WDate) + 1)
            ELSE
                MonthsAndMParts := MonthsAndMParts + 1;
            WDate := CALCDATE('<CM>', OldWDate) + 1;
            IF MonthsAndMParts <> ROUND(MonthsAndMParts, 1) THEN
                CheckMParts := TRUE;
        UNTIL WDate > Day2;
    end;

    

    [EventSubscriber(ObjectType::Codeunit, 802, 'OnAfterValidAddress', '', false, false)]
    local procedure "Codeunit802.OnAfterValidAddress"(TableID: Integer; var IsValid: Boolean)
    begin
        IF TableID = 96000 THEN
            IsValid := TRUE;
    end;


    [EventSubscriber(ObjectType::Codeunit, 802, 'OnBeforeValidAddress', '', false, false)]
    local procedure "Codeunit802.OnBeforeValidAddress"(TableID: Integer; var IsValid: Boolean)
    begin
        IF TableID = 96000 THEN
            IsValid := TRUE;
    end;

    [EventSubscriber(ObjectType::Table, 5077, 'OnAfterFinishWizard', '', false, false)]
    local procedure "Table5077.OnAfterFinishWizard"(var SegmentLine: Record "Segment Line"; InteractionLogEntry: Record "Interaction Log Entry"; IsFinish: Boolean; Flag: Boolean)
    var
        ModInteractionLogEntry: Record "Interaction Log Entry";
    begin
        IF ModInteractionLogEntry.GET(InteractionLogEntry."Entry No.") THEN BEGIN
            ModInteractionLogEntry."Contact Visit No." := SegmentLine."Contact Visit No.";
            ModInteractionLogEntry."Contact Visit Name" := SegmentLine."Contact Visit Name";
            ModInteractionLogEntry."Contact Visit Phone No." := SegmentLine."Contact Visit Phone No.";
            ModInteractionLogEntry."Contact Visit E-Mail" := SegmentLine."Contact Visit E-Mail";
            ModInteractionLogEntry.MODIFY;
        END;
    end;

   procedure CopyTemplateToREF(NoFRE: Code[20])
    var
        REFIncomeExpensesTemplate: Record "REF Income & Expense Template";
        REFIncomeExpensesLines: Record "REF Income & Expense Lines";
    begin
        IF NoFRE <> '' THEN BEGIN
            REFIncomeExpensesTemplate.RESET;
            REFIncomeExpensesTemplate.SETRANGE("No. Template", '');
            REFIncomeExpensesTemplate.SETFILTER(Type, '<>%1', REFIncomeExpensesTemplate.Type::Title);
            IF REFIncomeExpensesTemplate.FINDFIRST THEN BEGIN
                // delete line
                REFIncomeExpensesLines.RESET;
                REFIncomeExpensesLines.SETRANGE("No. Fixed Real Estate", NoFRE);
                REFIncomeExpensesLines.SETRANGE(Amount, 0);
                IF REFIncomeExpensesLines.FINDFIRST THEN BEGIN
                    IF CONFIRM(Text009, TRUE) THEN
                        REFIncomeExpensesLines.DELETEALL;
                END;
                REPEAT
                    REFIncomeExpensesLines."No. Fixed Real Estate" := NoFRE;
                    REFIncomeExpensesLines."No. Entry" := REFIncomeExpensesTemplate."No. Entry";
                    REFIncomeExpensesLines."Row No." := REFIncomeExpensesTemplate."Row No.";
                    REFIncomeExpensesLines.Type := REFIncomeExpensesTemplate.Type;
                    REFIncomeExpensesLines.Description := REFIncomeExpensesTemplate.Description;
                    REFIncomeExpensesLines.Quantity := 0;
                    REFIncomeExpensesLines.Price := 0;
                    REFIncomeExpensesLines.Amount := 0;
                    IF REFIncomeExpensesLines.INSERT THEN;
                UNTIL REFIncomeExpensesTemplate.NEXT = 0;

            END;
        END;
    end;

    procedure GetSelectionFilterForTypeREF(var TypeFixedRealEstate: Record "Type Fixed Real Estate"): Text
    var
        RecRef: RecordRef;
    begin
        RecRef.GETTABLE(TypeFixedRealEstate);
        EXIT(SelectionFilterManagement.GetSelectionFilter(RecRef, TypeFixedRealEstate.FIELDNO(Code)));
    end;

    procedure SignContract(FromLeaseContract: Record "Lease Contract")
    var
        LeaseContract: Record "Lease Contract";
        LeaseContractLine: Record "Lease Contract Line";
        LockOpenServContract: Codeunit "Lock-OpenServContract";
    begin
        OnBeforeSignContract(FromLeaseContract);

        IF NOT HideDialog THEN
            CLEARALL;

        IF NOT HideDialog THEN
            IF NOT CONFIRM(Text010, TRUE, FromLeaseContract."Contract No.") THEN
                EXIT;

        LeaseContract.GET(FromLeaseContract."Contract No.");

        CheckServContract(LeaseContract);

        Window.OPEN(Text012 + Text013);


        Window.UPDATE(1, 1);
        WPostLine := 0;
        InvoicingStartingPeriod := FALSE;
        SetInvoicing(LeaseContract);

        IF InvoiceNow THEN
            PostingDate := InvoiceFrom;

        IF InvoiceNow THEN BEGIN
            LeaseContract."Last Invoice Date" := LeaseContract."Starting Date";
            LeaseContract.VALIDATE("Last Invoice Period End", InvoiceTo);
        END;

        LeaseContractLine.RESET;
        LeaseContractLine.SETRANGE("Contract No.", FromLeaseContract."Contract No.");
        IF LeaseContractLine.FINDSET THEN
            REPEAT
                LeaseContractLine."Contract Status" := LeaseContractLine."Contract Status"::Signed;
                LeaseContractLine.MODIFY;
                WPostLine := WPostLine + 1;
                Window.UPDATE(2, WPostLine);
            UNTIL LeaseContractLine.NEXT = 0;

        LeaseContract."Amount per Period" := RealEstateMangement.CalcContractAmount(LeaseContract, LeaseContract."Starting Date", LeaseContract."Expiration Date");
        LeaseContract."Annual Amount" := LeaseContract."Amount per Period" * 12;

        LeaseContract.VALIDATE("Last Invoice Date", InvoiceTo);
        LeaseContract.Status := LeaseContract.Status::Signed;
        LeaseContract.MODIFY;

        Window.CLOSE;
    end;

procedure CancelContract(FromLeaseContract: Record "Lease Contract")
    var
        LeaseContract: Record "Lease Contract";
        LeaseContractLine: Record "Lease Contract Line";
        LockOpenServContract: Codeunit "Lock-OpenServContract";
    begin
        OnBeforeCancelContract(FromLeaseContract);

        IF NOT HideDialog THEN
            CLEARALL;

        IF NOT HideDialog THEN
            IF NOT CONFIRM(Text011, TRUE, FromLeaseContract."Contract No.") THEN
                EXIT;

        LeaseContract.GET(FromLeaseContract."Contract No.");

        CheckServContract(LeaseContract);

        Window.OPEN(Text014 + Text013);


        Window.UPDATE(1, 1);
        WPostLine := 0;
        InvoicingStartingPeriod := FALSE;
        SetInvoicing(LeaseContract);

        IF InvoiceNow THEN
            PostingDate := InvoiceFrom;

        IF InvoiceNow THEN BEGIN
            LeaseContract."Last Invoice Date" := LeaseContract."Starting Date";
            LeaseContract.VALIDATE("Last Invoice Period End", InvoiceTo);
        END;

        LeaseContractLine.RESET;
        LeaseContractLine.SETRANGE("Contract No.", FromLeaseContract."Contract No.");
        IF LeaseContractLine.FINDSET THEN
            REPEAT
                LeaseContractLine."Contract Status" := LeaseContractLine."Contract Status"::Cancelled;
                LeaseContractLine.MODIFY;
                WPostLine := WPostLine + 1;
                Window.UPDATE(2, WPostLine);
            UNTIL LeaseContractLine.NEXT = 0;

        LeaseContract."Amount per Period" := RealEstateMangement.CalcContractAmount(LeaseContract, LeaseContract."Starting Date", LeaseContract."Expiration Date");
        LeaseContract."Annual Amount" := LeaseContract."Amount per Period" * 12;

        LeaseContract.VALIDATE("Last Invoice Date", InvoiceTo);
        LeaseContract.Status := LeaseContract.Status::Canceled;
        LeaseContract.MODIFY;

        Window.CLOSE;
    end;

    procedure SetHideDialog(NewHideDialog: Boolean)
    begin
        HideDialog := NewHideDialog;
    end;

    procedure CheckServContract(var LeaseContract: Record "Lease Contract")
    var
        Text019: Label 'You cannot sign service contract with negative annual amount.';
        LeaseContractLine: Record "Lease Contract Line";
    begin
        IF LeaseContract.Status = LeaseContract.Status::Signed THEN
            EXIT;
        IF LeaseContract.Status = LeaseContract.Status::Canceled THEN
            ERROR(Text024);

        IF LeaseContract."Annual Amount" < 0 THEN
            ERROR(Text019);

        LeaseContractLine.RESET;
        LeaseContractLine.SETRANGE("Contract No.", LeaseContract."Contract No.");
        LeaseContractLine.SETRANGE(Amount, 0);
        IF NOT LeaseContractLine.ISEMPTY THEN
            ERROR(
              Text004,
              LeaseContract."Contract No.",
              LeaseContractLine.FIELDCAPTION(Amount));

        LeaseContract.TESTFIELD("Starting Date");
        LeaseContract.TESTFIELD("Salesperson Code");
    end;

    local procedure SetInvoicing(LeaseContract: Record "Lease Contract")
    var
        TempDate: Date;
    begin
        IF LeaseContract."Invoice Period" = LeaseContract."Invoice Period"::None THEN
            EXIT;

        GoOut := TRUE;
        TempDate := LeaseContract."Next Invoice Period Start";
        IF LeaseContract."Starting Date" < TempDate THEN BEGIN
            TempDate := TempDate - 1;
            GoOut := FALSE;
        END;
        IF NOT GoOut THEN BEGIN
            IF HideDialog THEN
                InvoiceNow := TRUE
            ELSE
                IF CONFIRM(
                      Text015, TRUE,
                      LeaseContract."Starting Date", TempDate)
                THEN
                    InvoiceNow := TRUE;
            InvoiceFrom := LeaseContract."Starting Date";
            InvoiceTo := TempDate;
            InvoicingStartingPeriod := TRUE;
        END;
    end;

    [EventSubscriber(ObjectType::Table, 1173, 'OnBeforeInsertAttachment', '', false, false)]
    local procedure OnBeforeInsertAttachment(var DocumentAttachment: Record "Document Attachment"; var RecRef: RecordRef)
    begin
    end;
    
    [EventSubscriber(ObjectType::Table, 1173, 'OnAfterInitFieldsFromRecRef', '', false, false)]
    local procedure OnAfterInitFieldsFromRecRef(var DocumentAttachment: Record "Document Attachment"; var RecRef: RecordRef)
        var
        DocumentAttachmentMgmt: Codeunit "Document Attachment Mgmt";
        FieldRef: FieldRef;
        RecNo: Code[20];
        AttachmentDocumentType: Enum "Attachment Document Type";
        FieldNo: Integer;
        LineNo: Integer;
        VATRepConfigType: Enum "VAT Report Configuration";
    begin 
    end;

    procedure RecalculateIRPFLeaseLine(LeaseContract: Record "Lease Contract"; var LeaseContractLine: Record "Lease Contract Line")
    var
        IRPFGrupo : Record "OneData Grupos IRPF";
        TaxAmountLine : Record "Tax Amount Line";
    begin
        TaxAmountLine.reset;
        TaxAmountLine.setrange("Document Type", TaxAmountLine."Document Type"::"Lease Contract");
        TaxAmountLine.setrange("Document No.", LeaseContract."Contract No.");
        TaxAmountLine.setrange("Line No.", LeaseContractLine."Line No.");
        TaxAmountLine.setrange("Tax Group Code",'IRPF');
        IF TaxAmountLine.findfirst then
             TaxAmountLine.deleteAll;
        TaxAmountLine."Document Type" := TaxAmountLine."Document Type"::"Lease Contract";
        TaxAmountLine."Document No." := LeaseContract."Contract No.";
        TaxAmountLine."Line No." := LeaseContractLine."Line No.";
        TaxAmountLine."Tax Group Code" := 'IRPF'; 
        TaxAmountLine.INSERT;
        if IRPFGrupo.get(LeaseContract."Grupo IRPF") then begin
            TaxAmountLine."Tax %" := IRPFGrupo."% Retencion";
            if (IRPFGrupo."Importe Origen" = IRPFGrupo."Importe Origen"::" ") or 
                (IRPFGrupo."Importe Origen" = IRPFGrupo."Importe Origen"::Importe) then begin
                TaxAmountLine."Tax Base" := LeaseContractLine."VAT Base Amount";
                TaxAmountLine."Tax Amount" := LeaseContractLine."VAT Base Amount" * IRPFGrupo."% Retencion" / 100;
            end;
            if IRPFGrupo."Importe Origen" = IRPFGrupo."Importe Origen"::"Importe IVA Incl." then begin
                TaxAmountLine."Tax Base" := LeaseContractLine.Amount;
                // LeaseContractLine."VAT Base Amount" + LeaseContractLine."VAT Amount";
                TaxAmountLine."Tax Amount" := TaxAmountLine."Tax Base" * IRPFGrupo."% Retencion" / 100;
            end;
        end;
        TaxAmountLine.MODIFY;
    END;

    [EventSubscriber(ObjectType::Codeunit, 1173, 'OnAfterTableHasNumberFieldPrimaryKey', '', false, false)]
    local procedure OnAfterTableHasNumberFieldPrimaryKey(TableNo: Integer; var Result: Boolean; var FieldNo: Integer)
    begin
        if TableNo = DATABASE::"Lease Contract" then begin
            FieldNo := 1;
            Result := true
        end;
    end;

    [IntegrationEvent(false, false)]
    local procedure OnBeforeSignContract(var LeaseContract: Record "Lease Contract")
    begin
    end;

    [IntegrationEvent(false, false)]
    local procedure OnBeforeCancelContract(var LeaseContract: Record "Lease Contract")
    begin
    end;
    [IntegrationEvent(false, false)]
    local procedure OnBeforeSignContractQuote(var LeaseContract: Record "Lease Contract")
    begin
    end;
}

