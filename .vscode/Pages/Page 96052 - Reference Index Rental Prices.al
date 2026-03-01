page 96052 "Reference Index Rental Prices"
{
    PageType = List;
    SourceTable = "Reference Index Rental Prices";

    layout
    {
        area(content)
        {
            repeater(Group)
            {
                field(Date; rec.Date)
                {
                    ApplicationArea = All;
                }
                field("Index Rental Price"; rec."Index Rental Price")
                {
                    ApplicationArea = All;
                }
                field(Active; rec.Active)
                {
                    ApplicationArea = All;
                }
                field(Price; rec.Price)
                {
                    ApplicationArea = All;
                }
                field(Comments;rec.Comments)
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

