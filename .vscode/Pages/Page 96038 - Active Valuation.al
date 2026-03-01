page 96038 "Active Valuation"
{
    PageType = List;
    SourceTable = "Active Valuation";

    layout
    {
        area(content)
        {
            repeater(Group)
            {
                field(Date; Rec.Date)
                {
                    ApplicationArea = All;
                }
                field("Owner Price"; Rec."Owner Price")
                {
                    ApplicationArea = All;
                }
                field("Publish Price"; Rec."Publish Price")
                {
                    ApplicationArea = All;
                }
                field("API Price"; Rec."API Price")
                {
                    ApplicationArea = All;
                }
                field("Competition Price"; Rec."Competition Price")
                {
                    ApplicationArea = All;
                }
                field("Service Amount"; Rec."Service Amount")
                {
                    ApplicationArea = All;
                }
            }
        }
    }

    actions
    {
    }
}

