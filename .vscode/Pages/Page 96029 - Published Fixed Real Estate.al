page 96029 "Published Fixed Real Estate"
{
    PageType = List;
    SourceTable = "Published Fixed Real Estate";

    layout
    {
        area(content)
        {
            repeater(Group)
            {
                field("Web Site Code"; rec."Web Site Code")
                {
                    ApplicationArea = All;
                }
                field("Fixed Real Estate No."; rec."Fixed Real Estate No.")
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

