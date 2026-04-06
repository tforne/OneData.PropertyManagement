page 96602 "Liquidacion Contrato Subform"
{
    AutoSplitKey = true;
    Caption = 'Lines';
    DelayedInsert = true;
    LinksAllowed = false;
    MultipleNewLines = true;
    PageType = ListPart;
    SourceTable = "Liquidacion Contrato Lines";
    ApplicationArea = All;

    layout
    {
        area(content)
        {
            repeater(Group)
            {
                field(Description; rec.Description)
                {
                    ToolTip = 'Specifies the description of the service item that is subject to the contract.';
                }
                field(Amoun; rec.Amount)
                {
                    ToolTip = 'Specifies the value of the service item line in the contract or contract quote.';
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

