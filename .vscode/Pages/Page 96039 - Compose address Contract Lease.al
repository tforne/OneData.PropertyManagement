page 96039 "Compose address Contract Lease"
{
    DeleteAllowed = false;
    InsertAllowed = false;
    PageType = Card;
    ShowFilter = false;
    SourceTable = "Lease Contract";

    layout
    {
        area(content)
        {
            group(General)
            {
                field("Street Type Id."; rec."Street Type Id.")
                {
                    ApplicationArea = All;
                    trigger OnValidate()
                    begin
                        rec.Compose;
                    end;
                }
                field("Types Street Numbering Id."; rec."Types Street Numbering Id.")
                {
                    ApplicationArea = All;
                    trigger OnValidate()
                    begin
                        rec.Compose;
                    end;
                }
                field("Street Name"; rec."Street Name")
                {
                    ApplicationArea = All;
                    trigger OnValidate()
                    begin
                        rec.Compose;
                    end;
                }
                field("Number On Street"; rec."Number On Street")
                {
                    ApplicationArea = All;
                    trigger OnValidate()
                    begin
                        rec.Compose;
                    end;
                }
                field("Location Height Floor"; rec."Location Height Floor")
                {
                    ApplicationArea = All;
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

