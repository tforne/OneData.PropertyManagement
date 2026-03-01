page 96051 "Consumer Price Index Categorie"
{
    PageType = List;
    SourceTable = "Consumer Price Index Categorie";

    layout
    {
        area(content)
        {
            repeater(Group)
            {
                field("Con. Price Index Category Code"; rec."Con. Price Index Category Code")
                {
                    ApplicationArea = All;
                }
                field(Description; rec.Description)
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

