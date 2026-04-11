page 96166 "RE Insurance Policy Assets"
{
    PageType = List;
    SourceTable = "RE Insurance Policy Asset";
    ApplicationArea = All;
    UsageCategory = Lists;
    Caption = 'Insurance Policy Assets';

    layout
    {
        area(content)
        {
            repeater(Group)
            {
                field("Policy No."; Rec."Policy No.") {}
                field("Fixed Real Estate No."; Rec."Fixed Real Estate No.") {}
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
        ApplyPageContextToRecord();
    end;

    local procedure ApplyPageContextToRecord()
    begin
        if Rec.GetFilter("Policy No.") <> '' then
            Rec.Validate("Policy No.", Rec.GetRangeMin("Policy No."));

        if Rec.GetFilter("Fixed Real Estate No.") <> '' then
            Rec.Validate("Fixed Real Estate No.", Rec.GetRangeMin("Fixed Real Estate No."));
    end;
}
