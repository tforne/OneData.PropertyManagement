namespace OneData.Property.Asset;

table 96056 "Estancia"
{
    Caption = 'Estancias';
    DataPerCompany = false;
    DrillDownPageID = 96059;
    LookupPageID = 96059;

    fields
    {
        field(1; Code; Code[20])
        {
            Caption = 'Estancia';
            DataClassification = ToBeClassified;
        }
        field(2; Description; Text[100])
        {
            Caption = 'Descripción';
            DataClassification = ToBeClassified;
        }
    }

    keys
    {
        key(PK; Code)
        {
            Clustered = true;
        }
    }
}
