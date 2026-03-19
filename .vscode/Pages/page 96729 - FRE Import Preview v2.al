page 96729 "FRE Import Preview v2"
{
    PageType = List;
    SourceTable = "FRE Import Preview v2";
    Caption = 'Import Preview';
    ApplicationArea = All;
    UsageCategory = Tasks;

    layout
    {
        area(content)
        {
            repeater(Group)
            {
                field("Excel Row No."; Rec."Excel Row No.") {}
                field(Date; Rec.Date) {}

                field("Document No."; Rec."Document No.") {}

                //field("Line Type Text"; Rec."Line Type Text") {}

                field(Description;Rec.Description){}
                field("Fixed Real Estate Description"; Rec."Fixed Real Estate Description") {}
                field("Fixed Real Estate No."; Rec."Fixed Real Estate No.") {}

                field("Description Row No. Text"; Rec."Description Row No. Text") {}
                field("Row No."; Rec."Row No.") {}

                field(Amount; Rec.Amount) {}
                field("Amount Including VAT"; Rec."Amount Including VAT") {}

                field(Error; Rec.Error)
                {
                    Style = Unfavorable;
                    StyleExpr = Rec.Error <> '';
                }
                field("Suggested Source Type"; Rec."Suggested Source Type") {}
                field("Suggested Source No."; Rec."Suggested Source No.") {}
                field("Suggestion Confidence"; Rec."Suggestion Confidence") {}
                field("Accept Suggestion"; Rec."Accept Suggestion") {}
            }
        }
    }
}