page 96026 "Types Street Numbering List"
{
    Caption = 'Types Street Numbering List';
    PageType = List;
    SourceTable = "Types Street Numbering";

    layout
    {
        area(content)
        {
            repeater(Group)
            {
                field("Id."; rec."Id.")
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

