page 96038 "Active Valuation"
{
    PageType = List;
    SourceTable = "Active Valuation";
    ApplicationArea = All;

    layout
    {
        area(content)
        {
            repeater(Group)
            {
                field(Date; Rec.Date)
                {
                }
                field("Owner Price"; Rec."Owner Price")
                {
                }
                field("Publish Price"; Rec."Publish Price")
                {
                }
                field("API Price"; Rec."API Price")
                {
                }
                field("Competition Price"; Rec."Competition Price")
                {
                }
                field("Service Amount"; Rec."Service Amount")
                {
                }
            }
        }
    }

    actions
    {
    }
}

