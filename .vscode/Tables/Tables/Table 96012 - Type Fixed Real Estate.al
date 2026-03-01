table 96012 "Type Fixed Real Estate"
{
    Caption = 'Tipo de activos inmobiliarios';
    DrillDownPageID = 96024;
    LookupPageID = 96024;

    fields
    {
        field(1; "Code"; Code[10])
        {
            DataClassification = ToBeClassified;
        }
        field(2; Description; Text[30])
        {
            DataClassification = ToBeClassified;
        }
    }

    keys
    {
        key(Key1; "Code")
        {
            Clustered = true;
        }
    }

    fieldgroups
    {
    }
}

