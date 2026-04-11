table 96163 "RE Insurance Cue"
{
    Caption = 'RE Insurance Cue';
    DataClassification = SystemMetadata;

    fields
    {
        field(1; "Primary Key"; Code[10])
        {
            Caption = 'Primary Key';
        }
        field(2; "Active Policies"; Integer)
        {
            Caption = 'Active Policies';
        }
        field(3; "Expired Policies"; Integer)
        {
            Caption = 'Expired Policies';
        }
    }

    keys
    {
        key(PK; "Primary Key")
        {
            Clustered = true;
        }
    }
}
