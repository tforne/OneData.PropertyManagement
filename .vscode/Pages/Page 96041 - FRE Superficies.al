page 96041 "FRE Superficies"
{
    PageType = List;
    SourceTable = "FRE Superficies";

    layout
    {
        area(content)
        {
            repeater(Group)
            {
                field("FRE Description"; rec."FRE Description")
                {
                    ApplicationArea = All;
                }
                field(Uso; rec.Uso)
                {
                    ApplicationArea = All;
                }
                field("Superficie m2"; rec."Superficie m2")
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

