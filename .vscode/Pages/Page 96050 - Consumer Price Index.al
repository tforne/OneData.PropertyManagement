page 96050 "Consumer Price Index"
{
    PageType = List;
    SourceTable = "Consumer Price Index";

    layout
    {
        area(content)
        {
            repeater(Group)
            {
                field("Consumer Price Index Category"; rec."Consumer Price Index Category")
                {
                    ApplicationArea = All;
                }
                field(Year; rec.Year)
                {
                    ApplicationArea = All;
                }
                field("% Increment"; rec."% Increment")
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

