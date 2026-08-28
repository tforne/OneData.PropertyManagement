table 96939 "OD AM Asset Structure Buffer"
{
    Caption = 'OD Asset Structure Buffer';
    TableType = Temporary;
    DataClassification = CustomerContent;

    fields
    {
        field(1; "Entry No."; Integer)
        {
            Caption = 'Entry No.';
        }
        field(2; "Fixed Real Estate No."; Code[20])
        {
            Caption = 'Fixed Real Estate No.';
        }
        field(3; "Property No."; Code[20])
        {
            Caption = 'Property No.';
        }
        field(4; "Parent FRE No."; Code[20])
        {
            Caption = 'Parent FRE No.';
        }
        field(5; Description; Text[100])
        {
            Caption = 'Description';
        }
        field(6; "Asset Type"; Enum "OD Asset Type")
        {
            Caption = 'Asset Type';
        }
        field(7; "Hierarchy Level"; Integer)
        {
            Caption = 'Hierarchy Level';
        }
        field(8; "Display Order"; Integer)
        {
            Caption = 'Display Order';
        }
        field(9; "Display Description"; Text[250])
        {
            Caption = 'Display Description';
        }
        field(10; "Has Children"; Boolean)
        {
            Caption = 'Has Children';
        }
        field(11; "Is Property"; Boolean)
        {
            Caption = 'Is Property';
        }
        field(12; Status; Text[50])
        {
            Caption = 'Status';
        }
        field(13; "Rental Price"; Decimal)
        {
            Caption = 'Rental Price';
        }
    }

    keys
    {
        key(PK; "Entry No.")
        {
            Clustered = true;
        }
        key(DisplayOrder; "Display Order")
        {
        }
    }
}
