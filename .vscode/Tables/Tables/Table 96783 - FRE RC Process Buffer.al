table 96783 "FRE RC Process Buffer"
{
    Caption = 'FRE RC Process Buffer';
    DataClassification = SystemMetadata;

    fields
    {
        field(1; "Step No."; Integer)
        {
            Caption = 'Step No.';
        }

        field(2; Title; Text[100])
        {
            Caption = 'Title';
        }

        field(3; Description; Text[250])
        {
            Caption = 'Description';
        }
    }

    keys
    {
        key(PK; "Step No.")
        {
            Clustered = true;
        }
    }
}