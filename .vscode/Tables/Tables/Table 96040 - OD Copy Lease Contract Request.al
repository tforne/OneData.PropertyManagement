// ------------------------------------------------------------------------------------------------
// Copyright (c) Tomàs Forné Martínez. All rights reserved.
// ------------------------------------------------------------------------------------------------

namespace OneData.Property.Lease;

table 96040 "OD Copy Lease Contract Request"
{
    Caption = 'Copy Lease Contract Request';
    DataClassification = CustomerContent;

    fields
    {
        field(1; "Source Company Name"; Text[30])
        {
            Caption = 'Source Company';
            TableRelation = System.Environment.Company.Name;
        }
        field(2; "Source Contract No."; Code[20])
        {
            Caption = 'Source Contract No.';
        }
        field(3; "Replace Lines"; Boolean)
        {
            Caption = 'Replace Existing Lines';
            InitValue = true;
        }
        field(4; "Copy Header"; Boolean)
        {
            Caption = 'Copy Header';
            InitValue = true;
        }
        field(5; "Copy Lines"; Boolean)
        {
            Caption = 'Copy Lines';
            InitValue = true;
        }
        field(6; "Copy Comments"; Boolean)
        {
            Caption = 'Copy Comments';
        }
    }

    keys
    {
        key(PK; "Source Company Name", "Source Contract No.")
        {
            Clustered = true;
        }
    }
}
