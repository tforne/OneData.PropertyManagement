page 96018 "Lease Contract Gain/Loss Entry"
{
    Caption = 'Comment List';
    DataCaptionFields = "Entry No.";
    Editable = false;
    LinksAllowed = false;
    PageType = List;
    SourceTable = "Lease Contract Gain/Loss Entry";

    layout
    {
        area(content)
        {
            repeater(Group)
            {
                field("Entry No."; rec."Entry No.")
                {
                    ApplicationArea = All;
                }
                field("Contract No."; rec."Contract No.")
                {
                    ApplicationArea = All;
                }
                field(Description; rec.Description)
                {
                    ApplicationArea = All;
                }
                field(Amount; rec.Amount)
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

