table 96943 "OD AM Asset Create Req."
{
    Caption = 'OD AM Asset Create Request';
    TableType = Temporary;
    DataClassification = CustomerContent;

    fields
    {
        field(1; "Entry No."; Integer)
        {
            Caption = 'Entry No.';
        }
        field(2; "Asset Type"; Enum "OD Asset Type")
        {
            Caption = 'Tipo de activo';
        }
    }

    keys
    {
        key(PK; "Entry No.")
        {
            Clustered = true;
        }
    }
}
