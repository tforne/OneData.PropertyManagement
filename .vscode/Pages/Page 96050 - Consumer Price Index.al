page 96050 "Consumer Price Index"
{
    PageType = List;
    SourceTable = "Consumer Price Index";
    ApplicationArea = All;

    layout
    {
        area(content)
        {
            repeater(Group)
            {
                field("Consumer Price Index Category"; rec."Consumer Price Index Category")
                {
                }
                field(Year; rec.Year)
                {
                }
                field("% Increment"; rec."% Increment")
                {
                }
            }
        }
    }

    actions
    {
    }
}

