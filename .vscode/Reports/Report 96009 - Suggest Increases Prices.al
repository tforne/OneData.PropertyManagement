report 96009 "Sugg. Incr. Prices Refer Index"
{
    ApplicationArea = Service;
    Caption = 'Suggest Increases Prices by Refer Index';
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
                InvoicedAmount := 0;
                Cust.GET(LeaseContract."Customer No.");
                LeaseContractLine.RESET;
                LeaseContractLine.SETRANGE("Contract No.", LeaseContract."Contract No.");
                LeaseContractLine.SETRANGE("Aplicar incrementos", TRUE);
                IF LeaseContractLine.FINDFIRST THEN
                    REPEAT
                        InvoicedAmount := InvoicedAmount + LeaseContractLine.Amount;
                    UNTIL LeaseContractLine.NEXT = 0;
                IF InvoicedAmount = 0 THEN
                    CurrReport.SKIP;
                LeaseContract."Amount per Period" := RealEstateMangement.CalcContractAmount(LeaseContract, LeaseContract."Starting Date", LeaseContract."Expiration Date");
                LeaseContract."Annual Amount" := LeaseContract."Amount per Period" * 12;
                LeaseContract.VALIDATE("Last Invoice Date", InvoiceTo);
                LeaseContract.MODIFY;
                LeaseContractLine.CreateLineWorksheet(LeaseContract, Year, InvoicedAmount);

                NoOfSuggest += 1;
            end;

            trigger OnPostDataItem()
            begin
                IF NOT HideDialog THEN BEGIN
                    MESSAGE(Text011, NoOfSuggest);
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
                        ApplicationArea = All;
                        Caption = 'Posting Date';
                        ToolTip = 'Specifies the date that you want to use as the posting date on the service invoices created.';
                    }

                    field(Year; Year)
                    {
                        ApplicationArea = All;
                        Caption = 'Año';
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
        NoOfSuggest := 0;
        Year := Date2DMY(WorkDate(),3);
    end;

    var
        Text000: Label 'You have not filled in the posting date.';
        Text001: Label 'The posting date is later than the work date.\\Confirm that this is the correct date.';
        Text002: Label 'The program has stopped the batch job at your request.';
        Text005: Label 'Creating sugesst Increases...\\';
        Text011: Label '%1 suggest was created.';
        Cust: Record Customer;
        LeaseContract: Record "Lease Contract";
        LeaseContractLine: Record "Lease Contract Line";
        Currency: Record Currency;
        InvoiceHeader: Record "Sales Header";
        LeaseInvoiceHeader: Record "Lease Invoice Header";
        ConsumerPriceIndexCategorie: Record "Consumer Price Index Categorie";
        ConsumerPriceIndex: Record "Consumer Price Index";
        RealEstateMangement: Codeunit "Real Estate Management";
        Window: Dialog;
        InvoicedAmount: Decimal;
        "%IPC": Decimal;
        NoOfSuggest: Integer;
        CounterTotal: Integer;
        Counter1: Integer;
        Counter2: Integer;
        CounterBreak: Integer;
        Year: Integer;
        ResultDescription: Text[80];
        InvoiceNo: Code[20];
        LastCustomer: Code[20];
        ConsumerPriceIndexCategorieCode: Code[10];
        InvoiceFrom: Date;
        InvoiceTo: Date;
        PostingDate: Date;
        LastContractCombined: Boolean;
        ContractExist: Boolean;
        HideDialog: Boolean;
        SetOptionsCalled: Boolean;

    procedure SetOptions(NewPostingDate: Date)
    begin
        SetOptionsCalled := TRUE;
        PostingDate := NewPostingDate;
    end;

    procedure SetHideDialog(NewHideDialog: Boolean)
    begin
        HideDialog := NewHideDialog;
    end;
}

