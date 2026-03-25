table 96026 "FRE Superficies"
{
    DrillDownPageID = 96041;
    LookupPageID = 96041;

    fields
    {
        field(1; "FRE No"; Code[20])
        {
            DataClassification = ToBeClassified;
        }
        field(2; Uso; Code[50])
        {
            DataClassification = ToBeClassified;
        }
        field(3; "Superficie m2"; Decimal)
        {
            DataClassification = ToBeClassified;
        }
        field(10; "FRE Description"; Text[80])
        {
            CalcFormula = Lookup ("Fixed Real Estate".Description WHERE ("No."=FIELD("FRE No")));
            Caption = 'Descripción';
            Editable = false;
            FieldClass = FlowField;
        }
        field(20;Construida;Boolean)
        {
            DataClassification = ToBeClassified;
        }
    }

    keys
    {
        key(Key1;"FRE No",Uso)
        {
            Clustered = true;
        }
    }

    fieldgroups
    {
    }
}

