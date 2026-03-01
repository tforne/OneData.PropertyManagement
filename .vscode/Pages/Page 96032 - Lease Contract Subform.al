page 96032 "Lease Contract Subform"
{
    AutoSplitKey = true;
    Caption = 'Lines';
    DelayedInsert = true;
    LinksAllowed = false;
    MultipleNewLines = true;
    PageType = ListPart;
    SourceTable = "Lease Contract Line";
    ApplicationArea = All;

    layout
    {
        area(content)
        {
            repeater(Group)
            {
                field("Account No."; rec."Account No.")
                {
                }
                field(Description; rec.Description)
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the description of the service item that is subject to the contract.';
                }
                field("Unit of Measure Code"; rec."Unit of Measure Code")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies how each unit of the item or resource is measured, such as in pieces or hours. By default, the value in the Base Unit of Measure field on the item or resource card is inserted.';
                }
                field("Base Contract"; rec."Base Contract")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the base service contract from which this service contract line is derived.';
                }
                field("Response Time (Hours)"; rec."Response Time (Hours)")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the response time for the service item associated with the service contract.';
                }
                field(Value; rec.Value)
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the service item line in the contract or contract quote.';
                }
                field(Amount; rec.Amount)
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the net amount, excluding any invoice discount amount, that must be paid for products on the line.';
                }
                field(Cost; rec.Cost)
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the calculated cost of the service item line in the service contract or contract quote.';
                }
                field(Profit; rec.Profit)
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the profit, expressed as the difference between the Line Amount and Line Cost fields on the service contract line.';
                }
                field("VAT Prod. Posting Group"; rec."VAT Prod. Posting Group")
                {
                }
                field("VAT Calculation Type"; rec."VAT Calculation Type")
                {
                }
                field("VAT %"; rec."VAT %")
                {
                }
                field("VAT Base Amount"; rec."VAT Base Amount")
                {
                }
                field("VAT Amount"; rec."VAT Amount")
                {
                    ApplicationArea = All;
                    
                }
                field("Tax Amount Line";Rec."Tax Amount Line")
                {
                    ApplicationArea = All;
                }
                field("Service Period"; rec."Service Period")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the period of time that must pass between each servicing of an item.';
                }
                field("Starting Date"; rec."Starting Date")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the starting date of the service contract.';
                }
                field("Contract Expiration Date"; rec."Contract Expiration Date")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the date when an item should be removed from the contract.';
                }
                field("Credit Memo Date"; rec."Credit Memo Date")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the date when you can create a credit memo for the service item that needs to be removed from the service contract.';
                }
                field("Shortcut Dimension 1 Code"; rec."Shortcut Dimension 1 Code")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies whether the service contract line is new or existing.';
                }
                field("Aplicar incrementos"; rec."Aplicar incrementos")
                {
                    ApplicationArea = All;
                    ToolTip = 'Indicates whether to apply increments to this line.';
                }
                field("Aplicar Impuestos";Rec."Aplicar Impuestos")
                {
                    ApplicationArea = All;
                    ToolTip = 'Indicates whether to apply taxes to this line.';
                
                }
            }
        }
    }

    actions
    {
        area(processing)
        {
            group("&Line")
            {
                Caption = '&Line';
                Image = Line;
                action("&Comments")
                {
                    ApplicationArea = Comments;
                    Caption = '&Comments';
                    Image = ViewComments;
                    ToolTip = 'View or create a comment.';

                    trigger OnAction()
                    begin
                        rec.ShowComments;
                    end;
                }
            }
        }
    }

    trigger OnDeleteRecord(): Boolean
    begin
        IF rec."Contract Status" = rec."Contract Status"::Signed THEN BEGIN

        END;
    end;

    trigger OnNewRecord(BelowxRec: Boolean)
    begin
        rec.SetupNewLine;
    end;

    var
        ItemLedgerEntry: Record "Item Ledger Entry";
        ServContractLine: Record "Service Contract Line";
        CreateCreditfromContractLines: Codeunit createCreditfromContractLines;
        NoOfSelectedLines: Integer;
}

