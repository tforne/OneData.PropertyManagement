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
                field(Superficie; rec."Area")
                {
                }
                field("Index Rental Price"; rec."Index Rental Price")
                {
                }
                field("Index Rental Price Max."; rec."Index Rental Price Max.")
                {
                }
                field(Price; rec.Price)
                {
                }
                field("Price Max."; rec."Price Max.")
                {
                }
                field(Active; rec.Active)
                {
                }
                field(Comments; rec.Comments)
                {
                }
            }
        }
    }

    actions
    {
    }
}

