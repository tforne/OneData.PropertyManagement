page 96051 "Consumer Price Index Categorie"
{
    PageType = List;
    SourceTable = "Consumer Price Index Categorie";
    ApplicationArea = All;

    layout
    {
        area(content)
        {
            repeater(Group)
            {
                field("Con. Price Index Category Code"; rec."Con. Price Index Category Code")
                {
                }
                field(Description; rec.Description)
                {
                }
            }
        }
    }

    actions
    {
    }
}

