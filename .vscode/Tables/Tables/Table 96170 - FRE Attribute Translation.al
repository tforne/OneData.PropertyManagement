namespace OneData.Property.Asset;

using System.Globalization;
table 96170 "FRE Attribute Translation"
{
    Caption = 'FRE Attribute Translation';
    DataClassification = CustomerContent;
    DataPerCompany = false;

    fields
    {
        field(1; "Attribute ID"; Integer)
        {
            Caption = 'Attribute ID';
            NotBlank = true;
            TableRelation = "FRE Attribute";
        }
        field(2; "Language Code"; Code[10])
        {
            Caption = 'Language Code';
            NotBlank = true;
            TableRelation = Language;
        }
        field(3; Name; Text[250])
        {
            Caption = 'Name';
        }
    }

    keys
    {
        key(Key1; "Attribute ID", "Language Code")
        {
            Clustered = true;
        }
    }

    fieldgroups
    {
    }
}

