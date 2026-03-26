// ------------------------------------------------------------------------------------------------
// Copyright (c) Tomàs Forné Martínez. All rights reserved.
// ------------------------------------------------------------------------------------------------

table 96725 "FRE Excel Template Setup"
{
    Caption = 'FRE Excel Template Setup';
    DataClassification = ToBeClassified;

    fields
    {
        field(1; "Primary Key"; Code[10])
        {
            Caption = 'Primary Key';
        }

        field(10; "Journal Template File"; Blob)
        {
            Caption = 'Journal Template File';
        }

        field(20; "Template File Name"; Text[100])
        {
            Caption = 'Template File Name';
        }
    }

    keys
    {
        key(PK; "Primary Key")
        {
            Clustered = true;
        }
    }
}