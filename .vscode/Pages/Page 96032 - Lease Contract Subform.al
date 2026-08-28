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
                field(type; rec.Type)
                {
                    trigger OnValidate()
                    begin
                        UpdateLineEditability();
                        CurrPage.Update(false);
                    end;
                }
                field("Account No."; rec."Account No.")
                {
                    Editable = CanEditLineDetails;
                }
                field(Description; rec.Description)
                {
                    ToolTip = 'Specifies the description of the service item that is subject to the contract.';
                }
                field("Unit of Measure Code"; rec."Unit of Measure Code")
                {
                    Editable = CanEditLineDetails;
                    ToolTip = 'Specifies how each unit of the item or resource is measured, such as in pieces or hours. By default, the value in the Base Unit of Measure field on the item or resource card is inserted.';
                }
                field("Base Contract"; rec."Base Contract")
                {
                    Editable = CanEditLineDetails;
                    ToolTip = 'Specifies the base service contract from which this service contract line is derived.';
                }
                field("Response Time (Hours)"; rec."Response Time (Hours)")
                {
                    Editable = CanEditLineDetails;
                    ToolTip = 'Specifies the response time for the service item associated with the service contract.';
                }
                field(Value; rec.Value)
                {
                    Editable = CanEditLineDetails;
                    ToolTip = 'Specifies the value of the service item line in the contract or contract quote.';
                }
                field(Amount; rec.Amount)
                {
                    Editable = CanEditLineDetails;
                    Importance = Standard;
                    ToolTip = 'Specifies the net amount, excluding any invoice discount amount, that must be paid for products on the line.';
                }
                field(Cost; rec.Cost)
                {
                    Editable = CanEditLineDetails;
                    ToolTip = 'Specifies the calculated cost of the service item line in the service contract or contract quote.';
                }
                field(Profit; rec.Profit)
                {
                    Editable = CanEditLineDetails;
                    ToolTip = 'Specifies the profit, expressed as the difference between the Line Amount and Line Cost fields on the service contract line.';
                }
                field("VAT Prod. Posting Group"; rec."VAT Prod. Posting Group")
                {
                    Editable = CanEditLineDetails;
                }
                field("VAT Calculation Type"; rec."VAT Calculation Type")
                {
                    Editable = CanEditLineDetails;
                }
                field("VAT %"; rec."VAT %")
                {
                    Editable = CanEditLineDetails;
                }
                field("VAT Base Amount"; rec."VAT Base Amount")
                {
                    Editable = CanEditLineDetails;
                }
                field("VAT Amount"; rec."VAT Amount")
                {
                    Editable = CanEditLineDetails;
                }
                field("Tax Amount Line";Rec."Tax Amount Line")
                {
                }
                field("Service Period"; rec."Service Period")
                {
                    Editable = CanEditLineDetails;
                    ToolTip = 'Specifies the period of time that must pass between each servicing of an item.';
                }
                field("Starting Date"; rec."Starting Date")
                {
                    Editable = CanEditLineDetails;
                    ToolTip = 'Specifies the starting date of the service contract.';
                }
                field("Contract Expiration Date"; rec."Contract Expiration Date")
                {
                    Editable = CanEditLineDetails;
                    ToolTip = 'Specifies the date when an item should be removed from the contract.';
                }
                field("Credit Memo Date"; rec."Credit Memo Date")
                {
                    Editable = CanEditLineDetails;
                    ToolTip = 'Specifies the date when you can create a credit memo for the service item that needs to be removed from the service contract.';
                }
                field("Shortcut Dimension 1 Code"; rec."Shortcut Dimension 1 Code")
                {
                    Editable = CanEditLineDetails;
                    ToolTip = 'Specifies whether the service contract line is new or existing.';
                }
                field("Aplicar incrementos"; rec."Aplicar incrementos")
                {
                    Editable = CanEditLineDetails;
                    ToolTip = 'Indicates whether to apply increments to this line.';
                }
                field("Aplicar Impuestos";Rec."Aplicar Impuestos")
                {
                    Editable = CanEditLineDetails;
                    ToolTip = 'Indicates whether to apply taxes to this line.';
                
                }
            }
            group(Totals)
            {
                ShowCaption = false;
                field(TotalVATBaseAmount; TotalVATBaseAmount)
                {
                    ApplicationArea = All;
                    Caption = 'Total Importe base IVA';
                    Editable = false;
                }
                field(TotalVATAmount; TotalVATAmount)
                {
                    ApplicationArea = All;
                    Caption = 'Total Importe IVA';
                    Editable = false;
                }
                field(TotalTaxAmountLine; TotalTaxAmountLine)
                {
                    ApplicationArea = All;
                    Caption = 'Total Importe impuesto';
                    Editable = false;
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
        UpdateLineEditability();
        UpdateTotals();
    end;

    trigger OnAfterGetRecord()
    begin
        UpdateLineEditability();
        UpdateTotals();
    end;

    trigger OnAfterGetCurrRecord()
    begin
        UpdateLineEditability();
        UpdateTotals();
    end;

    var
        ItemLedgerEntry: Record "Item Ledger Entry";
        ServContractLine: Record "Service Contract Line";
        CreateCreditfromContractLines: Codeunit createCreditfromContractLines;
        NoOfSelectedLines: Integer;
        TotalVATBaseAmount: Decimal;
        TotalVATAmount: Decimal;
        TotalTaxAmountLine: Decimal;
        CanEditLineDetails: Boolean;

    local procedure UpdateTotals()
    var
        LeaseContractLine: Record "Lease Contract Line";
    begin
        LeaseContractLine.Copy(Rec);
        LeaseContractLine.CalcSums("VAT Base Amount", "VAT Amount");

        TotalVATBaseAmount := LeaseContractLine."VAT Base Amount";
        TotalVATAmount := LeaseContractLine."VAT Amount";
        TotalTaxAmountLine := 0;

        if LeaseContractLine.FindSet() then
            repeat
                LeaseContractLine.CalcFields("Tax Amount Line");
                TotalTaxAmountLine += LeaseContractLine."Tax Amount Line";
            until LeaseContractLine.Next() = 0;
    end;

    local procedure UpdateLineEditability()
    begin
        CanEditLineDetails := Rec.Type <> Rec.Type::" ";
    end;
}

