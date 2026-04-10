page 96157 "RE Insurance Policy ListPart"
{
    PageType = ListPart;
    SourceTable = "RE Insurance Policy";
    ApplicationArea = All;
    Caption = 'Insurance Policies';

    layout
    {
        area(content)
        {
            repeater(Group)
            {
                field("No."; Rec."No.") {}
                field(Description; Rec.Description) {}
                field("Policy No."; Rec."Policy No.") {}
                field("Insurer Name"; Rec."Insurer Name") {}
                field("Coverage Type"; Rec."Coverage Type") {}
                field("Ending Date"; Rec."Ending Date") {}
                field("Claim E-Mail"; Rec."Claim E-Mail") {}
                field(Active; Rec.Active) {}
            }
        }
    }
}
