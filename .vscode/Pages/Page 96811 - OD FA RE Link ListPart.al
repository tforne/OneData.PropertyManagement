page 96811 "OD FA RE Link ListPart"
{
    PageType = ListPart;
    SourceTable = "OD RE FA Link";
    ApplicationArea = All;
    Caption = 'Activos inmobiliarios relacionados';
    PopulateAllFields = true;

    Editable = true;
    InsertAllowed = true;
    ModifyAllowed = true;
    DeleteAllowed = true;

    layout
    {
        area(content)
        {
            repeater(Lines)
            {
                field("Real Estate No."; Rec."Real Estate No.")
                {
                    ApplicationArea = All;
                }
                field("FA Description"; Rec."FA Description")
                {
                    ApplicationArea = All;
                }
                field("Real Estate Description"; Rec."Real Estate Description")
                {
                    ApplicationArea = All;
                }
                field("Link Type"; Rec."Link Type")
                {
                    ApplicationArea = All;
                }
                field("Primary Link"; Rec."Primary Link")
                {
                    ApplicationArea = All;
                }
                field("Allocation %"; Rec."Allocation %")
                {
                    ApplicationArea = All;
                }
                field(Active; Rec.Active)
                {
                    ApplicationArea = All;
                }
                field("Starting Date"; Rec."Starting Date")
                {
                    ApplicationArea = All;
                }
                field("Ending Date"; Rec."Ending Date")
                {
                    ApplicationArea = All;
                }
            }
        }
    }
}
