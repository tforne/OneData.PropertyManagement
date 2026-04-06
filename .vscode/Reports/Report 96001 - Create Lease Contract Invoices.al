report 96001 "Create Lease Contract Invoices"
{
    ApplicationArea = Service;
    Caption = 'Create Lease Contract Invoices';
    ProcessingOnly = true;
    UsageCategory = Tasks;

    dataset
    {
        dataitem("Lease Contract"; "Lease Contract")
        {
            DataItemTableView = WHERE (Status = CONST (Signed));
            RequestFilterFields = "Customer No.", "Contract No.";

            trigger OnAfterGetRecord()
            begin
                Counter1 := Counter1 + 1;
                Counter2 := Counter2 + 1;
                IF Counter2 >= CounterBreak THEN BEGIN
                    Counter2 := 0;
                    Window.UPDATE(1, ROUND(Counter1 / CounterTotal * 10000, 1));
                END;

                LeaseContract := "Lease Contract";
                Cust.GET(LeaseContract."Customer No.");
                ResultDescription := '';
                RealEstateMangement.GetNextInvoicePeriod(LeaseContract, InvoiceFrom, InvoiceTo);
                InvoicedAmount := ROUND(
                    RealEstateMangement.CalcContractAmount(LeaseContract, InvoiceFrom, InvoiceTo),
                    Currency."Amount Rounding Precision");
                IF InvoicedAmount = 0 THEN
                    CurrReport.SKIP;
                IF NOT "Combine Invoices" OR (LastCustomer <> LeaseContract."Customer No.") OR NOT LastContractCombined
                THEN BEGIN
                    InvoiceNo := RealEstateMangement.CreateInvoiceLeaseContract(LeaseContract, PostingDate, ContractExist, InvoiceHeader, LeaseInvoiceHeader);
                    NoOfInvoices := NoOfInvoices + 1;
                END;
                ResultDescription := InvoiceNo;
                RealEstateMangement.CreateAllLeaseContractLines(InvoiceNo, LeaseContract, InvoiceHeader, LeaseInvoiceHeader);
                LastCustomer := LeaseContract."Second Customer No.";
                LastContractCombined := LeaseContract."Combine Invoices";
                FREJnlPostLine.PostFRELedgerEntryFromLeaseInvoice(LeaseInvoiceHeader);
            end;

            trigger OnPostDataItem()
            begin
                IF NOT HideDialog THEN BEGIN
                    IF CreateInvoices = CreateInvoices::"Create Invoices" THEN
                        IF NoOfInvoices > 1 THEN
                            MESSAGE(Text010, NoOfInvoices)
                        ELSE
                            MESSAGE(Text011, NoOfInvoices);
                END;
            end;

            trigger OnPreDataItem()
            begin

                IF PostingDate = 0D THEN
                    ERROR(Text000);

                IF NOT HideDialog THEN
                    IF PostingDate > WORKDATE THEN
                        IF NOT CONFIRM(Text001) THEN
                            ERROR(Text002);

                IF InvoiceToDate = 0D THEN
                    ERROR(Text003);

                IF NOT HideDialog THEN
                    IF InvoiceToDate > WORKDATE THEN
                        IF NOT CONFIRM(Text004) THEN
                            ERROR(Text002);

                LastCustomer := '';
                LastContractCombined := FALSE;

                Window.OPEN(
                  Text005 +
                  '@1@@@@@@@@@@@@@@@@@@@@@@@@@@@@@');

                CounterTotal := COUNT;
                Counter1 := 0;
                Counter2 := 0;
                CounterBreak := ROUND(CounterTotal / 100, 1, '>');
                Currency.InitRoundingPrecision;
            end;
        }
    }

    requestpage
    {

        layout
        {
            area(content)
            {
                group(Options)
                {
                    Caption = 'Options';
                    field(PostingDate; PostingDate)
                    {
                        Caption = 'Posting Date';
                        ToolTip = 'Specifies the date that you want to use as the posting date on the service invoices created.';
                    }
                    field(InvoiceToDate; InvoiceToDate)
                    {
                        Caption = 'Invoice to Date';
                        ToolTip = 'Specifies the date up to which you want to invoice contracts. The batch job includes contracts with next invoice dates on or before this date.';
                    }
                    field(CreateInvoices; CreateInvoices)
                    {
                        Caption = 'Action';
                        OptionCaption = 'Create Invoices,Print Only';
                        ToolTip = 'Specifies the desired action for service contracts that are due for invoicing.';
                    }
                }
            }
        }

        actions
        {
        }
    }

    labels
    {
    }

    trigger OnInitReport()
    begin
        IF NOT SetOptionsCalled THEN
            PostingDate := WORKDATE;
        NoOfInvoices := 0;
    end;

    var
        Text000: Label 'You have not filled in the posting date.';
        Text001: Label 'The posting date is later than the work date.\\Confirm that this is the correct date.';
        Text002: Label 'The program has stopped the batch job at your request.';
        Text003: Label 'You must fill in the Invoice-to Date field.';
        Text004: Label 'The Invoice-to Date is later than the work date.\\Confirm that this is the correct date.';
        Text005: Label 'Creating contract invoices...\\';
        Text006: Label 'Service Order is missing.';
        Text009: Label '%1 is missing.';
        Text010: Label '%1 invoices were created.';
        Text011: Label '%1 invoice was created.';
        Cust: Record Customer;
        LeaseContract: Record "Lease Contract";
        Currency: Record Currency;
        InvoiceHeader: Record "Sales Header";
        LeaseInvoiceHeader: Record "Lease Invoice Header";
        RealEstateMangement: Codeunit "Real Estate Management";
        FREJnlPostLine : Codeunit "FRE Jnl.-Post Line";
        Window: Dialog;
        InvoicedAmount: Decimal;
        NoOfInvoices: Integer;
        CounterTotal: Integer;
        Counter1: Integer;
        Counter2: Integer;
        CounterBreak: Integer;
        ResultDescription: Text[80];
        InvoiceNo: Code[20];
        LastCustomer: Code[20];
        InvoiceFrom: Date;
        InvoiceTo: Date;
        PostingDate: Date;
        InvoiceToDate: Date;
        LastContractCombined: Boolean;
        CreateInvoices: Option "Create Invoices","Print Only";
        ContractExist: Boolean;
        HideDialog: Boolean;
        SetOptionsCalled: Boolean;

    local procedure CheckIfCombinationExists(FromLeaseContract: Record "Lease Contract"): Boolean
    var
        LeaseContract2: Record "Lease Contract";
    begin
        LeaseContract2.SETCURRENTKEY("Customer No.", "Second Customer No.");
        LeaseContract2.SETFILTER("Contract No.", '<>%1', FromLeaseContract."Contract No.");
        LeaseContract2.SETRANGE("Customer No.", FromLeaseContract."Customer No.");
        LeaseContract2.SETRANGE("Second Customer No.", FromLeaseContract."Second Customer No.");
        EXIT(LeaseContract2.FINDFIRST);
    end;

    procedure SetOptions(NewPostingDate: Date; NewInvoiceToDate: Date; NewCreateInvoices: Option "Create Invoices","Print Only")
    begin
        SetOptionsCalled := TRUE;
        PostingDate := NewPostingDate;
        InvoiceToDate := NewInvoiceToDate;
        CreateInvoices := NewCreateInvoices;
    end;

    procedure SetHideDialog(NewHideDialog: Boolean)
    begin
        HideDialog := NewHideDialog;
    end;
}

