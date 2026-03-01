table 96051 "Consumer Price Index Categorie"
{
    DrillDownPageID = 96051;
    LookupPageID = 96051;

    fields
    {
        field(1; "Con. Price Index Category Code"; Code[10])
        {
            Caption = 'IPC Categoría Code';
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
        key(Key1; "Con. Price Index Category Code")
        {
            Clustered = true;
        }
    }

    fieldgroups
    {
    }
}

