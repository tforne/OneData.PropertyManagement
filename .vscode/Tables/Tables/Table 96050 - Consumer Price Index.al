// ------------------------------------------------------------------------------------------------
// Copyright (c) Tomàs Forné Martínez. All rights reserved.
// ------------------------------------------------------------------------------------------------

table 96050 "Consumer Price Index"
{
    Caption = 'Consumer Price Index';
    DataPerCompany = false;
    
    fields
    {
        field(1; "Consumer Price Index Category"; Code[10])
        {
            Caption = 'IPC Categoría';
            DataClassification = ToBeClassified;
            TableRelation = "Consumer Price Index Categorie";
        }
        field(2; Year; Integer)
        {
            Caption = 'Año';
            DataClassification = ToBeClassified;
        }
        field(3; "% Increment"; Decimal)
        {
            DataClassification = ToBeClassified;
        }
    }

    keys
    {
        key(Key1; "Consumer Price Index Category", Year)
        {
            Clustered = true;
        }
    }

    fieldgroups
    {
    }
}

