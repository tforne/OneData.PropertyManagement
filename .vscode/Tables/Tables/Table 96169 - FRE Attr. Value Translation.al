namespace OneData.Property.Asset;

using System.Globalization;
table 96169 "FRE Attr. Value Translation"
{
    Caption = 'FRE Attr. Value Translation';
    DataClassification = CustomerContent;
    DataPerCompany = false;

    fields
    {
        field(1; "Attribute ID"; Integer)
        {
            Caption = 'Attribute ID';
            NotBlank = true;
        }
        field(2; ID; Integer)
        {
            Caption = 'ID';
            NotBlank = true;
        }
        field(4; "Language Code"; Code[10])
        {
            Caption = 'Language Code';
            NotBlank = true;
            TableRelation = Language;
        }
        field(5; Name; Text[250])
        {
            Caption = 'Name';
        }
    }

    keys
    {
        key(Key1; "Attribute ID", ID, "Language Code")
        {
            Clustered = true;
        }
    }

    fieldgroups
    {
    }
}
