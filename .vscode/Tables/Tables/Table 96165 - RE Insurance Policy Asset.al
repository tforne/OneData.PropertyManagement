table 96165 "RE Insurance Policy Asset"
{
    Caption = 'RE Insurance Policy Asset';
    DataPerCompany = false;

    fields
    {
        field(1; "Policy No."; Code[20])
        {
            Caption = 'Policy No.';
            TableRelation = "RE Insurance Policy"."No.";
        }
        field(2; "Fixed Real Estate No."; Code[20])
        {
            Caption = 'Fixed Real Estate No.';
            TableRelation = "Fixed Real Estate"."No.";
        }
        field(10; "Policy Description"; Text[100])
        {
            CalcFormula = lookup("RE Insurance Policy".Description where("No." = field("Policy No.")));
            Caption = 'Policy Description';
            Editable = false;
            FieldClass = FlowField;
        }
        field(11; "Policy Document No."; Code[50])
        {
            CalcFormula = lookup("RE Insurance Policy"."Policy No." where("No." = field("Policy No.")));
            Caption = 'Policy Document No.';
            Editable = false;
            FieldClass = FlowField;
        }
        field(12; "Insurer Name"; Text[100])
        {
            CalcFormula = lookup("RE Insurance Policy"."Insurer Name" where("No." = field("Policy No.")));
            Caption = 'Insurer Name';
            Editable = false;
            FieldClass = FlowField;
        }
        field(13; "Ending Date"; Date)
        {
            CalcFormula = lookup("RE Insurance Policy"."Ending Date" where("No." = field("Policy No.")));
            Caption = 'Ending Date';
            Editable = false;
            FieldClass = FlowField;
        }
        field(14; Active; Boolean)
        {
            CalcFormula = lookup("RE Insurance Policy".Active where("No." = field("Policy No.")));
            Caption = 'Active';
            Editable = false;
            FieldClass = FlowField;
        }
        field(15; "Claim E-Mail"; Text[100])
        {
            CalcFormula = lookup("RE Insurance Policy"."Claim E-Mail" where("No." = field("Policy No.")));
            Caption = 'Claim E-Mail';
            Editable = false;
            FieldClass = FlowField;
        }
    }

    keys
    {
        key(PK; "Policy No.", "Fixed Real Estate No.")
        {
            Clustered = true;
        }
        key(Key2; "Fixed Real Estate No.", "Policy No.")
        {
        }
    }

    trigger OnInsert()
    begin
        EnsurePropertyAssetLinks();
        SyncRelatedIncidents();
    end;

    trigger OnModify()
    begin
        EnsurePropertyAssetLinks();
        SyncRelatedIncidents();
    end;

    local procedure EnsurePropertyAssetLinks()
    var
        FixedRealEstate: Record "Fixed Real Estate";
        ChildFixedRealEstate: Record "Fixed Real Estate";
        ChildPolicyAsset: Record "RE Insurance Policy Asset";
    begin
        if ("Policy No." = '') or ("Fixed Real Estate No." = '') then
            exit;

        if not FixedRealEstate.Get("Fixed Real Estate No.") then
            exit;

        if FixedRealEstate.Type <> FixedRealEstate.Type::Propiedad then
            exit;

        ChildFixedRealEstate.SetRange(Type, ChildFixedRealEstate.Type::Activo);
        ChildFixedRealEstate.SetRange("Property No.", FixedRealEstate."No.");

        if not ChildFixedRealEstate.FindSet() then
            exit;

        repeat
            if not ChildPolicyAsset.Get("Policy No.", ChildFixedRealEstate."No.") then begin
                ChildPolicyAsset.Init();
                ChildPolicyAsset."Policy No." := "Policy No.";
                ChildPolicyAsset."Fixed Real Estate No." := ChildFixedRealEstate."No.";
                ChildPolicyAsset.Insert(true);
            end;
        until ChildFixedRealEstate.Next() = 0;
    end;

    local procedure SyncRelatedIncidents()
    var
        Incident: Record "Incident Assets Real Estate";
        InsurancePolicy: Record "RE Insurance Policy";
    begin
        if ("Policy No." = '') or ("Fixed Real Estate No." = '') then
            exit;

        if not InsurancePolicy.Get("Policy No.") then
            exit;

        if not InsurancePolicy.Active then
            exit;

        Incident.SetRange("Fixed Real Estate No.", "Fixed Real Estate No.");
        Incident.SetFilter(StateCode, '<>%1', Incident.StateCode::Closed);

        if not Incident.FindSet() then
            exit;

        repeat
            if ShouldSyncIncident(Incident) then begin
                Incident.Validate("Insurance Policy No.", "Policy No.");
                Incident."Notify Insurance" := true;

                if not Incident."Insurance Notified" then
                    Incident."Insurance Status" := Incident."Insurance Status"::Pending;

                Incident.Modify(true);
            end;
        until Incident.Next() = 0;
    end;

    local procedure ShouldSyncIncident(Incident: Record "Incident Assets Real Estate"): Boolean
    begin
        if Incident."Insurance Policy No." = '' then
            exit(true);

        if Incident."Insurance Policy No." = "Policy No." then
            exit(true);

        exit(false);
    end;
}
