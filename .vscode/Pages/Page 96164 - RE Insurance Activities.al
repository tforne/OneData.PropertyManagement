page 96164 "RE Insurance Activities"
{
    PageType = CardPart;
    SourceTable = "RE Insurance Cue";
    Caption = 'Insurance';
    ApplicationArea = All;
    RefreshOnActivate = true;

    layout
    {
        area(content)
        {
            cuegroup(Insurance)
            {
                Caption = 'Seguros';
                CueGroupLayout = Wide;

                field("Active Policies"; Rec."Active Policies")
                {
                    Caption = 'Vigentes';

                    trigger OnDrillDown()
                    var
                        InsurancePolicy: Record "RE Insurance Policy";
                    begin
                        InsurancePolicy.SetRange(Active, true);
                        InsurancePolicy.SetFilter("Ending Date", '%1|%2..', 0D, WorkDate());
                        Page.Run(Page::"RE Insurance Policies", InsurancePolicy);
                    end;
                }

                field("Expired Policies"; Rec."Expired Policies")
                {
                    Caption = 'Caducadas';

                    trigger OnDrillDown()
                    var
                        InsurancePolicy: Record "RE Insurance Policy";
                    begin
                        InsurancePolicy.SetFilter("Ending Date", '..%1', CalcDate('<-1D>', WorkDate()));
                        Page.Run(Page::"RE Insurance Policies", InsurancePolicy);
                    end;
                }
            }
        }
    }

    trigger OnOpenPage()
    begin
        LoadCue();
    end;

    trigger OnAfterGetRecord()
    begin
        LoadCue();
    end;

    local procedure LoadCue()
    var
        InsurancePolicy: Record "RE Insurance Policy";
    begin
        if not Rec.Get('DEFAULT') then begin
            Rec.Init();
            Rec."Primary Key" := 'DEFAULT';
            Rec.Insert();
        end;

        InsurancePolicy.Reset();
        InsurancePolicy.SetRange(Active, true);
        InsurancePolicy.SetFilter("Ending Date", '%1|%2..', 0D, WorkDate());
        Rec."Active Policies" := InsurancePolicy.Count();

        InsurancePolicy.Reset();
        InsurancePolicy.SetFilter("Ending Date", '..%1', CalcDate('<-1D>', WorkDate()));
        Rec."Expired Policies" := InsurancePolicy.Count();

        Rec.Modify();
    end;
}
