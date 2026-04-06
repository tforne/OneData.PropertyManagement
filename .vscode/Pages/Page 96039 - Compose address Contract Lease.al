page 96039 "Compose address Contract Lease"
{
    DeleteAllowed = false;
    InsertAllowed = false;
    PageType = Card;
    ShowFilter = false;
    SourceTable = "Lease Contract";
    ApplicationArea = All;

    layout
    {
        area(content)
        {
            group(General)
            {
                field("Street Type Id."; rec."Street Type Id.")
                {
                    trigger OnValidate()
                    begin
                        rec.Compose;
                    end;
                }
                field("Types Street Numbering Id."; rec."Types Street Numbering Id.")
                {
                    trigger OnValidate()
                    begin
                        rec.Compose;
                    end;
                }
                field("Street Name"; rec."Street Name")
                {
                    trigger OnValidate()
                    begin
                        rec.Compose;
                    end;
                }
                field("Number On Street"; rec."Number On Street")
                {
                    trigger OnValidate()
                    begin
                        rec.Compose;
                    end;
                }
                field("Location Height Floor"; rec."Location Height Floor")
                {
                    trigger OnValidate()
                    begin
                        rec.Compose;
                    end;
                }
            }
        }
    }

    actions
    {
    }
}

