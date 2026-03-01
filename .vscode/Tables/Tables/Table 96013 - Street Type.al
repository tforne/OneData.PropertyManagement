table 96013 "Street Type"
{
    Caption = 'Street Type';
    DrillDownPageID = 96025;
    LookupPageID = 96025;

    fields
    {
        field(1; "Id."; Code[10])
        {
            DataClassification = ToBeClassified;
        }
        field(2; Description; Text[30])
        {
            Caption = 'Descripción';
            DataClassification = ToBeClassified;
        }
    }

    keys
    {
        key(Key1; "Id.")
        {
            Clustered = true;
        }
    }

    fieldgroups
    {
    }
}

