page 96014 "Small Real Estate Act."
{
    Caption = 'Contratación y Ventas';
    PageType = CardPart;
    RefreshOnActivate = true;
    SourceTable = "RE Owner Cue";
    ApplicationArea = All;

    layout
    {
        area(content)
        {
            cuegroup(LeaseContract)
            {
                Caption = 'Contratación';
                CueGroupLayout = Wide;
                field("Lease Contract Signed"; rec."Lease Contract Signed")
                {
                    trigger OnDrillDown()
                    var
                        LeaseContractList: Page "Lease Contract List";
                    begin
                        LeaseContract.RESET;
                        LeaseContract.SETRANGE(Status, LeaseContract.Status::Signed);
                        LeaseContractList.SETTABLEVIEW(LeaseContract);
                        LeaseContractList.RUN
                    end;
                }
                field("Lease Contract Expired"; rec."Lease Contract Expired")
                {
                    DrillDownPageID = "Lease Contract List";
                    LookupPageID = "Lease Contract List";
                    StyleExpr = ContractExpiredCueStyle;
                }
                field("Lease Contract Open"; rec."Lease Contract Open")
                {
                    ApplicationArea = Basic, Suite;
                }
                field("Rental Fixed Real Estate"; rec."Rental Fixed Real Estate")
                {
                }

                actions
                {
                    action("New Real Estate")
                    {
                        Caption = 'New Real Estate';
                        RunObject = Page 96000;
                        RunPageMode = Create;
                        ToolTip = 'Register a new real estate.';
                    }
                }
            }
            cuegroup(Sales)
            {
                Caption = 'Sales';
                field("Sales Invoices"; rec."Sales Invoices")
                {
                    Caption = 'Sales Invoices';
                    DrillDown = true;
                    Lookup = true;
                    LookupPageID = "Posted Sales Invoice";

                    trigger OnDrillDown()
                    var
                        SalesInvoiceList: Page "Sales Invoice List";
                    begin
                        SalesInvoiceList.RUNMODAL;
                    end;
                }
                field("Purchase Invoices"; rec."Purchase Invoices")
                {
                    Caption = 'Purchase Invoices';

                    trigger OnDrillDown()
                    var
                        PurchaseList: Page "Purchase List";
                    begin
                        PurchaseList.RUNMODAL;
                    end;
                }

                actions
                {
                }
            }
        }
    }

    var
      HasCamera: Boolean;
    trigger OnAfterGetRecord()
    begin
        
    end;

    trigger OnOpenPage()
    begin
        rec.RESET;
        IF NOT rec.GET THEN BEGIN
            rec.INIT;
            rec.INSERT;
        END;
        rec.SETFILTER("Due Date Filter", '<=%1', WORKDATE);
        rec.SETFILTER("Overdue Date Filter", '<%1', WORKDATE);
        rec.SETFILTER("User ID Filter", USERID);
    end;

    var
        FixedRealEstate: Record "Fixed Real Estate";
        LeaseContract: Record "Lease Contract";
        LeaseContractList: Page "Lease Contract List";
        M2NotRental: Decimal;
        "%NotRental": Decimal;
        PriceM2: Decimal;
        ContractExpiredCueStyle: Text;
        Disposed: Boolean;
        DisposalValueVisible: Boolean;
        ProceedsOnDisposalVisible: Boolean;
        GainLossVisible: Boolean;
        DisposalDateVisible: Boolean;
        RentabilidadBruta: Decimal;
        RentabilidadPrevistaNeta : Decimal;
        RentabilidadNeta: Decimal;
        FlujoCajaMensual: Decimal;
        PrevisionGastosAnual: Decimal;
        GastosAnual: Decimal;
        TotalFlujoCaja: Decimal;
        BusinessChart: Codeunit "Business Chart";
        SalesInvHeader: Record "Sales Invoice Header";
        StartDate: Date;
        EndDate: Date;
        MonthNo: Integer;
        MonthLabel: Text;
        MonthAmountIncoming: Decimal;
        MonthAmountExpenses: Decimal;
        CurrentMonthStart: Date;
        CurrentMonthEnd: Date;
        RentabilidadStyle : Text;


}

