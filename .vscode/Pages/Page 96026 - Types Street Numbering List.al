page 96026 "Types Street Numbering List"
{
    Caption = 'Types Street Numbering List';
    PageType = List;
    SourceTable = "Types Street Numbering";
    ApplicationArea = All;

    layout
    {
        area(content)
        {
            repeater(Group)
            {
                field("Id."; rec."Id.")
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

