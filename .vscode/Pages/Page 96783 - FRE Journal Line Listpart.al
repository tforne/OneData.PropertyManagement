page 96783 "FRE Journal Line ListPart"
{
    PageType = ListPart;
    SourceTable = "FRE Jnl. Line";
    Caption = 'FRE Journal Lines';
    ApplicationArea = All;
    Editable = false;

    layout
    {
        area(content)
        {
            repeater(Group)
            {
                field(Date; Rec.Date)
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