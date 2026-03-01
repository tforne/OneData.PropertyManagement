page 96500 "Price Increases by Refer index"
{
    AdditionalSearchTerms = 'special price,alternate price';
    ApplicationArea = Suite;
    Caption = 'Rental price increases by reference index';
    DelayedInsert = true;
    PageType = Worksheet;
    SaveValues = true;
    SourceTable = "Price Increases by Refer index";
    UsageCategory = Tasks;

    layout
    {
        area(content)
        {
            repeater(Control1)
            {
                ShowCaption = false;
                field("Contract No."; Rec."Contract No.")
                {
                    ApplicationArea = All;
                    Editable = false;
                }
                field("Starting Date"; rec."Starting Date")
                {
                    ApplicationArea = All;
                    Editable = false;
                }
                field("Fixed Real Estate Name";Rec."Fixed Real Estate Name")
                {
                    ApplicationArea = All;
                    Editable = false;
                }
                field("Contact No."; Rec."Contact No.")
                {
                    ApplicationArea = All;
                    Editable = false;
                }
                field("Contact Name"; rec."Contact Name")
                {
                    ApplicationArea = All;
                    Editable = false;
                }
                field("Contact E-Mail";Rec."Contact E-Mail")
                {
                    ApplicationArea = All;
                    Editable = false;
                }                
                field("Customer No."; Rec."Customer No.")
                {
                    ApplicationArea = All;
                    Editable = false;
                }
                field("Customer Name";Rec."Customer Name")
                {
                    ApplicationArea = All;
                    Editable = false;
                }
                field(Description;Rec.Description)
                {
                    ApplicationArea = All;
                }
                field("Contract Expiration Date";Rec."Contract Expiration Date")
                {
                    ApplicationArea = All;
                    Editable = false;
                }
                field("Current Unit Price";Rec."Current Unit Price")
                {
                    ApplicationArea = all;
                    Editable = false;
                }
                field("Amount Charged Last Periode";Rec."Amount Charged Last Periode")
                {
                    ApplicationArea = All;
                }
                field("Payment Method Code";Rec."Payment Method Code")
                {
                    ApplicationArea = All;
                    Editable = false;
                }
                field("CPI calculation amount";Rec."CPI calculation amount")
                {
                    ApplicationArea = All;
                    Editable = false;
                }
                field("Starting Date Increment";Rec."Starting Date Increment")
                {
                    ApplicationArea = All;
                    Editable = true;
                }
                field( "% Increment";Rec."% Increment")
                {
                    ApplicationArea = all;
                    Editable = false;
                }
                field(Amount;Rec.Amount)
                {
                    ApplicationArea = All;
                }
                field(Comunicate;Rec.Comunicate)
                {
                    ApplicationArea = All;
                }

            }
        }
        area(factboxes)
        {
            systempart(Control1900383207; Links)
            {
                ApplicationArea = RecordLinks;
                Visible = false;
            }
            systempart(Control1905767507; Notes)
            {
                ApplicationArea = Notes;
                Visible = false;
            }
        }
    }

    actions
    {
        area(processing)
        {
            group("F&unctions")
            {
                Caption = 'F&unctions';
                Image = "Action";
                action("Suggest Increases Prices")
                {
                    ApplicationArea = Basic, Suite;
                    Caption = 'Suggest Increases Prices';
                    Ellipsis = true;
                    Image = SuggestSalesPrice;
                    ToolTip = 'Create suggestions for changing the agreed item unit prices for your sales prices in the Sales Prices window on the basis of the unit price on the item cards. When the batch job has completed, you can see the result in the Sales Price Worksheet window. You can also use the Suggest Sales Price on Wksh. batch job to create suggestions for new sales prices.';

                    trigger OnAction()
                    begin
                        REPORT.RunModal(REPORT::"Sugg. Incr. Prices Refer Index", true, true);
                    end;
                }
                action("Comunication Increases Prices")
                {
                    ApplicationArea = Basic, Suite;
                    Caption = 'Comunication Increases Prices';
                    Ellipsis = true;
                    Image = SendConfirmation;
                    //Scope = Repeater;
                    ToolTip = 'Comunication Increase Prices';

                    trigger OnAction()
                    var
                        PriceIncreasesReferIndex: Record "Price Increases by Refer index";
                    begin
                        Error('Not implemented');
                        PriceIncreasesReferIndex := Rec;
                        CurrPage.SetSelectionFilter(PriceIncreasesReferIndex);
                        PriceIncreasesReferIndex.EmailRecords(true);
                    end;

                }

                action("I&mplement Increases Prices")
                {
                    ApplicationArea = Basic, Suite;
                    Caption = 'I&mplement Price Change';
                    Ellipsis = true;
                    Image = ImplementPriceChange;
                    //Scope = Repeater;
                    ToolTip = 'Update the alternate prices in the Sales Prices window with the ones in the Sales Price Worksheet window.';

                    trigger OnAction()
                    var
                        PriceIncreasesReferIndex: Record "Price Increases by Refer index";
                        ImplementedIncreasedPrice: Report "Implement Increased Price";
                    begin
                        PriceIncreasesReferIndex := Rec;
                        CurrPage.SetSelectionFilter(PriceIncreasesReferIndex);
                        ImplementedIncreasedPrice.SetTableView(PriceIncreasesReferIndex);
                        ImplementedIncreasedPrice.RunModal();
                    end;
                }
            }
        }
        area(Navigation)
        {
            action("Contract Lines")
            {
                ApplicationArea = Basic, Suite;
                Caption = 'Contract Lines';
                Ellipsis = true;
                Image = ServiceLines;
                ToolTip = 'Contract lines';
                RunObject = page 96032;
                RunPageLink = "Contract No."=FIELD("Contract No.");
                Scope = Repeater;
            }

        }
        area(Promoted)
        {
            group(Category_Process)
            {
                Caption = 'Process';

                actionref("Suggest Increases Prices_Promoted";"Suggest Increases Prices")
                {
                }
                actionref("Comunication Increases Prices_Promoted";"Comunication Increases Prices")
                {
                }
                actionref("I&mplement Increases Prices_Promoted"; "I&mplement Increases Prices")
                {
                }
            }
        }
    }
}
