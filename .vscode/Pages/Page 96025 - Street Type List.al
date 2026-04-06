page 96025 "Street Type List"
{
    Caption = 'Street Type List';
    PageType = List;
    SourceTable = "Street Type";
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

