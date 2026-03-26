// ------------------------------------------------------------------------------------------------
// Copyright (c) Tomàs Forné Martínez. All rights reserved.
// ------------------------------------------------------------------------------------------------
namespace OneData.Property.Asset;

table 96014 "Types Street Numbering"
{
    Caption = 'Types Street Numbering';
    DataPerCompany = false;
    DrillDownPageID = 96026;
    LookupPageID = 96026;

    fields
    {
        field(1; "Id."; Code[10])
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
        key(Key1; "Id.")
        {
            Clustered = true;
        }
    }

    fieldgroups
    {
    }
}

