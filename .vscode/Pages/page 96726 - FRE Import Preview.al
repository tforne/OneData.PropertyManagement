page 96726 "FRE Import Preview old"
{
    PageType = List;
    SourceTable = "FRE Import Preview";
    Caption = 'Import Preview';
    ApplicationArea = All;
    UsageCategory = Tasks;

    layout
    {
        area(content)
        {
            repeater(Group)
            {
                //field("Excel Row No."; Rec."Excel Row No.") {}
                field(Date; Rec.Date) {}

                field("Document No."; Rec."Document No.") {}

                //field("Line Type Text"; Rec."Line Type Text") {}

                field(Description;Rec.Description){}
                //field("Fixed Real Estate Description"; Rec."Fixed Real Estate Description") {}
                field("Fixed Real Estate No."; Rec."Fixed Real Estate No.") {}

                //field("Description Row No. Text"; Rec."Description Row No. Text") {}
                field("Row No."; Rec."Row No.") {}

                field(Amount; Rec.Amount) {}
                field("Amount Including VAT"; Rec."Amount Including VAT") {}

                field(Error; Rec.Error)
                {
                    Style = Unfavorable;
                    StyleExpr = Rec.Error <> '';
                }
            }
        }
    }
}