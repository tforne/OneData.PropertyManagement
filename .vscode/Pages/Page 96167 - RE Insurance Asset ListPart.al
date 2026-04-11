page 96167 "RE Insurance Asset ListPart"
{
    PageType = ListPart;
    SourceTable = "RE Insurance Policy Asset";
    ApplicationArea = All;
    Caption = 'Insurance Policies';

    layout
    {
        area(content)
        {
            repeater(Group)
            {
                field("Policy No."; Rec."Policy No.") {}
                field("Policy Description"; Rec."Policy Description") {}
                field("Policy Document No."; Rec."Policy Document No.") {}
                field("Insurer Name"; Rec."Insurer Name") {}
                field("Ending Date"; Rec."Ending Date") {}
                field(Active; Rec.Active) {}
                field("Claim E-Mail"; Rec."Claim E-Mail") {}
            }
        }
    }

    trigger OnNewRecord(BelowxRec: Boolean)
    begin
        if Rec.GetFilter("Fixed Real Estate No.") <> '' then
            Rec.Validate("Fixed Real Estate No.", Rec.GetRangeMin("Fixed Real Estate No."));
    end;
}
