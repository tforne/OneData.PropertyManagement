table 96023 "Active Valuation"
{
    DrillDownPageID = 96038;
    LookupPageID = 96038;

    fields
    {
        field(2; "Entity Type"; Option)
        {
            Caption = 'Type de entidad';
            DataClassification = ToBeClassified;
            OptionCaption = 'Fixed Real Estate,Opportunity';
            OptionMembers = "Fixed Real Estate",Opportunity;
        }
        field(3; "Source No."; Code[20])
        {
            Caption = 'No.';
            DataClassification = ToBeClassified;
            TableRelation = IF ("Entity Type"=CONST("Fixed Real Estate")) "Fixed Real Estate"."No."
                            ELSE IF ("Entity Type"=CONST(Opportunity)) Opportunity."No.";
        }
        field(5;Date;Date)
        {
            DataClassification = ToBeClassified;
        }
        field(10;"Owner Price";Decimal)
        {
            Caption = 'Precio de la propiedad';
            DataClassification = ToBeClassified;
        }
        field(11;"Publish Price";Decimal)
        {
            Caption = 'Precio publicado';
            DataClassification = ToBeClassified;
        }
        field(12;"API Price";Decimal)
        {
            Caption = 'Precio valoración';
            DataClassification = ToBeClassified;
        }
        field(13;"Competition Price";Decimal)
        {
            Caption = 'Precio competencia';
            DataClassification = ToBeClassified;
        }
        field(14;"Service Amount";Decimal)
        {
            Caption = 'Importe servicio';
            DataClassification = ToBeClassified;
        }
    }

    keys
    {
        key(Key1;"Entity Type","Source No.")
        {
            Clustered = true;
        }
    }

    fieldgroups
    {
    }
}

