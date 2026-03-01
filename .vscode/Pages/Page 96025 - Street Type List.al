page 96025 "Street Type List"
{
    Caption = 'Street Type List';
    PageType = List;
    SourceTable = "Street Type";

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

