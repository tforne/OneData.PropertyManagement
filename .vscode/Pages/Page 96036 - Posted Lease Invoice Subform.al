page 96036 "Posted Lease Invoice Subform"
{
    AutoSplitKey = true;
    Caption = 'Lines';
    Editable = true;
    LinksAllowed = false;
    PageType = ListPart;
    SourceTable = "Lease Invoice Line";
    ApplicationArea = All;

    layout
    {
        area(content)
        {
            repeater(Group)
            {
                field(Type; rec.Type)
                {
                    ToolTip = 'Specifies the type of this invoice line.';
                }
                field("No."; rec."No.")
                {
                    ToolTip = 'Specifies the number of the involved entry or record, according to the specified number series.';
                }
                field(Description; rec.Description)
                {
                    ToolTip = 'Specifies the name of an item, resource, cost, general ledger account description, or some descriptive text on the service invoice line.';
                }
                field(Quantity; rec.Quantity)
                {
                    BlankZero = true;
                    ToolTip = 'Specifies the number of item units, resource hours, general ledger account payments, or cost specified on the invoice line.';
                }
                field("Unit of Measure Code"; rec."Unit of Measure Code")
                {
                    ToolTip = 'Specifies how each unit of the item or resource is measured, such as in pieces or hours. By default, the value in the Base Unit of Measure field on the item or resource card is inserted.';
                }
                field("Unit of Measure"; rec."Unit of Measure")
                {
                    ToolTip = 'Specifies the name of the item or resource''s unit of measure, such as piece or hour.';
                    Visible = false;
                }
                field("Unit Cost (LCY)"; rec."Unit Cost (LCY)")
                {
                    ToolTip = 'Specifies the cost, in LCY, of one unit of the item or resource on the line.';
                    Visible = false;
                }
                field("Unit Price"; rec."Unit Price")
                {
                    BlankZero = true;
                    ToolTip = 'Specifies the price of one unit of the item or resource. You can enter a price manually or have it entered according to the Price/Profit Calculation field on the related card.';
                }
                field("Line Discount %"; rec."Line Discount %")
                {
                    BlankZero = true;
                    ToolTip = 'Specifies the discount percentage that is granted for the item on the line.';
                }
                field("VAT Prod. Posting Group"; rec."VAT Prod. Posting Group")
                {
                }
                field("Line Amount"; rec."Line Amount")
                {
                    BlankZero = true;
                    ToolTip = 'Specifies the net amount, excluding any invoice discount amount, that must be paid for products on the line.';
                }
                field("Line Discount Amount"; rec."Line Discount Amount")
                {
                    ToolTip = 'Specifies the discount amount that is granted for the item on the line.';
                    Visible = false;
                }
                field("Aplicar Impuestos";Rec."Aplicar Impuestos")
                {
                    ToolTip = 'Indicates whether taxes should be applied to this invoice line. If you clear this field, tax fields will be hidden on the invoice line, and no taxes will be calculated for this line.';
                }
                field("Tax Amount Line";Rec."Tax Amount Line")
                {
                    ToolTip = 'Shows the tax details for this invoice line. Click the AssistEdit button to view the related tax details.';
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
            }
        }
    }


}

