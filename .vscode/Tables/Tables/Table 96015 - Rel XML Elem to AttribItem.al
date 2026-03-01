table 96015 "Rel. XML Elem. to Attrib. Item"
{
    DrillDownPageID = 96028;
    LookupPageID = 96028;

    fields
    {
        field(1; "Web Site Code"; Code[10])
        {
            Caption = 'Código sitio web';
            DataClassification = ToBeClassified;
            TableRelation = "Fixed Real Estate Web Site";
        }
        field(2; "Element XML Name"; Text[250])
        {
            Caption = 'Nombre elemento XML';
            DataClassification = ToBeClassified;
        }
        field(3; "Attribute Id."; Integer)
        {
            BlankZero = true;
            DataClassification = ToBeClassified;
            TableRelation = "Item Attribute".ID;
        }
        field(4; Description; Text[250])
        {
            Caption = 'Descripción';
            DataClassification = ToBeClassified;
        }
        field(5; Required; Boolean)
        {
            Caption = 'Obligatorio';
            DataClassification = ToBeClassified;
        }
        field(10; "Field No."; Integer)
        {
            Caption = 'No. campo';
            DataClassification = ToBeClassified;
            TableRelation = Field."No." WHERE (TableNo=CONST(96000));
        }
    }

    keys
    {
        key(Key1;"Web Site Code","Element XML Name")
        {
            Clustered = true;
        }
    }

    fieldgroups
    {
    }
}

