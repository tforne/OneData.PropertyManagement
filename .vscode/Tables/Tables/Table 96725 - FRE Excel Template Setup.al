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

        field(30; "Default Gen. Journal Template"; Code[10])
        {
            Caption = 'Plantilla diario general por defecto';
            TableRelation = "Gen. Journal Template".Name;
        }

        field(31; "Default Gen. Journal Batch"; Code[10])
        {
            Caption = 'Sección diario general por defecto';
            TableRelation = "Gen. Journal Batch".Name where("Journal Template Name" = field("Default Gen. Journal Template"));
        }

        field(40; "Default FRE Journal Template"; Code[10])
        {
            Caption = 'Plantilla diario FRE por defecto';
            TableRelation = "FRE Jnl. Template".Name;
        }

        field(41; "Default FRE Journal Batch"; Code[10])
        {
            Caption = 'Sección diario FRE por defecto';
            TableRelation = "FRE Jnl. Batch".Name where("Journal Template Name" = field("Default FRE Journal Template"));
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
