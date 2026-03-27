// ------------------------------------------------------------------------------------------------
// Copyright (c) Tomàs Forné Martínez. All rights reserved.
// ------------------------------------------------------------------------------------------------
namespace OneData.Property.Setup;

table 96008 "Description Documents Class"
{
    Caption = 'Description Documents Classified';
    DrillDownPageID = 96017;
    LookupPageID = 96017;

    fields
    {
        field(1; "Code"; Code[10])
        {
            Caption = 'Código';
            DataClassification = ToBeClassified;
        }
        field(2; Description; Text[80])
        {
            Caption = 'Descripción';
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

