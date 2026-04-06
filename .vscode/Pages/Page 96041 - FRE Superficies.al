page 96041 "FRE Superficies"
{
    PageType = List;
    SourceTable = "FRE Superficies";
    ApplicationArea = All;

    layout
    {
        area(content)
        {
            repeater(Group)
            {
                field("FRE Description"; rec."FRE Description")
                {
                }
                field(Uso; rec.Uso)
                {
                }
                field("Superficie m2"; rec."Superficie m2")
                {
                }
                field(Construida;Rec.Construida)
                {
                }
            }
        }
    }

    actions
    {
    }
}

