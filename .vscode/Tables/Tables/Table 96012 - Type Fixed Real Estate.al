// ------------------------------------------------------------------------------------------------
// Copyright (c) Tomàs Forné Martínez. All rights reserved.
// ------------------------------------------------------------------------------------------------
namespace OneData.Property.Asset;

table 96012 "Type Fixed Real Estate"
{
    Caption = 'Tipo de activos inmobiliarios';
    DataPerCompany = false;
    DrillDownPageID = 96024;
    LookupPageID = 96024;

    fields
    {
        field(1; "Code"; Code[10])
        {
            DataClassification = ToBeClassified;
        }
        field(2; Description; Text[30])
        {
            DataClassification = ToBeClassified;
        }
    }

    keys
    {
        key(Key1; "Code")
        {
            Clustered = true;
        }
    }

    fieldgroups
    {
    }
}

