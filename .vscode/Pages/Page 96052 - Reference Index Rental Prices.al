page 96052 "Reference Index Rental Prices"
{
    PageType = List;
    SourceTable = "Reference Index Rental Prices";
    ApplicationArea = All;

    layout
    {
        area(content)
        {
            repeater(Group)
            {
                field(Date; rec.Date)
                {
                }
                field("Index Rental Price"; rec."Index Rental Price")
                {
                }
                field(Active; rec.Active)
                {
                }
                field(Price; rec.Price)
                {
                }
                field(Comments;rec.Comments)
                {
                }
            }
        }
    }

    actions
    {
    }
}

