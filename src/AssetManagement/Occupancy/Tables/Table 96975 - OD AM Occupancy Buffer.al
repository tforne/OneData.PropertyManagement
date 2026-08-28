table 96975 "OD AM Occupancy Buffer"
{
    Caption = 'OD AM Occupancy Buffer';
    TableType = Temporary;
    DataClassification = CustomerContent;

    fields
    {
        field(1; "Entry No."; Integer)
        {
            Caption = 'Entry No.';
        }
        field(2; "Property No."; Code[20])
        {
            Caption = 'Property No.';
        }
        field(3; "Fixed Real Estate No."; Code[20])
        {
            Caption = 'Fixed Real Estate No.';
        }
        field(4; "Parent FRE No."; Code[20])
        {
            Caption = 'Parent FRE No.';
        }
        field(5; "Asset Type"; Enum "OD Asset Type")
        {
            Caption = 'Asset Type';
        }
        field(6; Description; Text[100])
        {
            Caption = 'Description';
        }
        field(7; "Hierarchy Level"; Integer)
        {
            Caption = 'Hierarchy Level';
        }
        field(8; "Display Description"; Text[250])
        {
            Caption = 'Display Description';
        }
        field(9; "Occupancy Status"; Enum "OD AM Occupancy Status")
        {
            Caption = 'Occupancy Status';
        }
        field(10; "Current Contract No."; Code[20])
        {
            Caption = 'Current Contract No.';
        }
        field(11; "Customer No."; Code[20])
        {
            Caption = 'Customer No.';
        }
        field(12; "Starting Date"; Date)
        {
            Caption = 'Starting Date';
        }
        field(13; "Ending Date"; Date)
        {
            Caption = 'Ending Date';
        }
        field(14; "Occupancy Percentage"; Decimal)
        {
            Caption = 'Occupancy Percentage';
            DecimalPlaces = 0 : 5;
        }
    }

    keys
    {
        key(PK; "Entry No.")
        {
            Clustered = true;
        }
        key(PropertyAsset; "Property No.", "Fixed Real Estate No.")
        {
        }
    }
}
