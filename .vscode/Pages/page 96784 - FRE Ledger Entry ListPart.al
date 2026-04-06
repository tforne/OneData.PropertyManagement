page 96784 "FRE Ledger Entry ListPart"
{
    PageType = ListPart;
    SourceTable = "FRE Ledger Entry";
    Caption = 'Latest FRE Movements';
    ApplicationArea = All;
    Editable = false;

    layout
    {
        area(content)
        {
            repeater(Group)
            {
                field("Posting Date"; Rec."Posting Date")
                {
                }
                field("Document No."; Rec."Document No.")
                {
                }
                field("Fixed Real Estate No."; Rec."Fixed Real Estate No.")
                {
                }
                field(Description; Rec.Description)
                {
                }
                field(Amount; Rec.Amount)
                {
                }
            }
        }
    }
}