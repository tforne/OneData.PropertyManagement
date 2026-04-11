table 96156 "RE Insurance Policy"
{
    Caption = 'RE Insurance Policy';
    DataPerCompany = false;
    LookupPageId = "RE Insurance Policies";

    fields
    {
        field(1; "No."; Code[20])
        {
            Caption = 'No.';
        }

        field(3; Description; Text[100])
        {
            Caption = 'Description';
        }
        field(4; "Policy No."; Code[50])
        {
            Caption = 'Policy No.';
        }
        field(5; "Insurer Name"; Text[100])
        {
            Caption = 'Insurer Name';
        }
        field(6; "Broker Name"; Text[100])
        {
            Caption = 'Broker Name';
        }
        field(7; "Coverage Type"; Option)
        {
            Caption = 'Coverage Type';
            OptionMembers = Building,Contents,Liability,RentDefault,Other;
            OptionCaption = 'Building,Contents,Liability,Rent Default,Other';
        }
        field(8; "Starting Date"; Date)
        {
            Caption = 'Starting Date';
        }
        field(9; "Ending Date"; Date)
        {
            Caption = 'Ending Date';
        }
        field(10; "Claim E-Mail"; Text[100])
        {
            Caption = 'Claim E-Mail';
            ExtendedDatatype = EMail;
        }
        field(11; "Claim Phone No."; Text[30])
        {
            Caption = 'Claim Phone No.';
            ExtendedDatatype = PhoneNo;
        }
        field(12; "Coverage Amount"; Decimal)
        {
            Caption = 'Coverage Amount';
        }
        field(13; Deductible; Decimal)
        {
            Caption = 'Deductible';
        }
        field(14; Premium; Decimal)
        {
            Caption = 'Premium';
        }
        field(15; Active; Boolean)
        {
            Caption = 'Active';
            InitValue = true;
        }
        field(16; Notes; Text[250])
        {
            Caption = 'Notes';
        }
    }

    keys
    {
        key(PK; "No.")
        {
            Clustered = true;
        }

        key(Key3; "Policy No.")
        {
        }
    }

    fieldgroups
    {
        fieldgroup(DropDown; "No.", Description, "Policy No.", "Insurer Name", "Broker Name", "Coverage Type", "Starting Date", "Ending Date", "Claim E-Mail", "Claim Phone No.", "Coverage Amount", Deductible, Premium, Active, Notes)
        {
        }
    }

    trigger OnInsert()
    var
        REFSetup: Record "REF Setup";
        NoSeries: Codeunit "No. Series";
    begin
        if "No." <> '' then
            exit;

        REFSetup.Get();
        REFSetup.TestField("Insurance Nos.");
        "No." := NoSeries.GetNextNo(REFSetup."Insurance Nos.", WorkDate(), true);
    end;

    trigger OnModify()
    begin
        SyncRelatedIncidents();
    end;

    procedure IsLinkedToFixedRealEstate(FixedRealEstateNo: Code[20]): Boolean
    var
        PolicyAsset: Record "RE Insurance Policy Asset";
    begin
        if FixedRealEstateNo = '' then
            exit(false);

        exit(PolicyAsset.Get("No.", FixedRealEstateNo));
    end;

    local procedure SyncRelatedIncidents()
    var
        Incident: Record "Incident Assets Real Estate";
        PolicyAsset: Record "RE Insurance Policy Asset";
    begin
        if not Active then
            exit;

        PolicyAsset.SetRange("Policy No.", "No.");
        if not PolicyAsset.FindSet() then
            exit;

        repeat
            Incident.Reset();
            Incident.SetRange("Fixed Real Estate No.", PolicyAsset."Fixed Real Estate No.");
            Incident.SetFilter(StateCode, '<>%1', Incident.StateCode::Closed);

            if Incident.FindSet() then
                repeat
                    if ShouldSyncIncident(Incident) then begin
                        Incident.Validate("Insurance Policy No.", "No.");
                        Incident."Notify Insurance" := true;

                        if not Incident."Insurance Notified" then
                            Incident."Insurance Status" := Incident."Insurance Status"::Pending;

                        Incident.Modify(true);
                    end;
                until Incident.Next() = 0;
        until PolicyAsset.Next() = 0;
    end;

    local procedure ShouldSyncIncident(Incident: Record "Incident Assets Real Estate"): Boolean
    begin
        if Incident."Insurance Policy No." = '' then
            exit(true);

        if Incident."Insurance Policy No." = "No." then
            exit(true);

        exit(false);
    end;
}
