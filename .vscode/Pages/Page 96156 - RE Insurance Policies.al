page 96156 "RE Insurance Policies"
{
    PageType = List;
    SourceTable = "RE Insurance Policy";
    ApplicationArea = All;
    UsageCategory = Lists;
    Caption = 'Insurance Policies';

    layout
    {
        area(content)
        {
            repeater(Group)
            {
                field("No."; Rec."No.") {}
                field("Fixed Real Estate No."; Rec."Fixed Real Estate No.") {}
                field(Description; Rec.Description) {}
                field("Policy No."; Rec."Policy No.") {}
                field("Insurer Name"; Rec."Insurer Name") {}
                field("Coverage Type"; Rec."Coverage Type") {}
                field("Starting Date"; Rec."Starting Date") {}
                field("Ending Date"; Rec."Ending Date") {}
                field("Claim E-Mail"; Rec."Claim E-Mail") {}
                field("Claim Phone No."; Rec."Claim Phone No.") {}
                field(Active; Rec.Active) {}
            }
        }
    }
}
