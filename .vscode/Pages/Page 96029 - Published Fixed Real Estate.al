page 96029 "Published Fixed Real Estate"
{
    PageType = List;
    SourceTable = "Published Fixed Real Estate";
    ApplicationArea = All;

    layout
    {
        area(content)
        {
            repeater(Group)
            {
                field("Web Site Code"; rec."Web Site Code")
                {
                }
                field("Fixed Real Estate No."; rec."Fixed Real Estate No.")
                {
                }
            }
        }
    }

    actions
    {
    }
}

