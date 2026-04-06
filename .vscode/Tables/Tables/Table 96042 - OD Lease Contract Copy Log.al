// ------------------------------------------------------------------------------------------------
// Copyright (c) Tomàs Forné Martínez. All rights reserved.
// ------------------------------------------------------------------------------------------------

namespace OneData.Property.Lease;

table 96042 "OD Lease Contract Copy Log"
{
    Caption = 'Lease Contract Copy Log';
    DataClassification = CustomerContent;

    fields
    {
        field(1; "Entry No."; Integer)
        {
            Caption = 'Entry No.';
            AutoIncrement = true;
        }
        field(2; "Date Time"; DateTime)
        {
            Caption = 'Date Time';
        }
        field(3; "User ID"; Code[50])
        {
            Caption = 'User ID';
        }
        field(4; "Source Company Name"; Text[30])
        {
            Caption = 'Source Company Name';
        }
        field(5; "Source Contract No."; Code[20])
        {
            Caption = 'Source Contract No.';
        }
        field(6; "Target Company Name"; Text[30])
        {
            Caption = 'Target Company Name';
        }
        field(7; "Target Contract No."; Code[20])
        {
            Caption = 'Target Contract No.';
        }
        field(8; "Copy Header"; Boolean)
        {
            Caption = 'Copy Header';
        }
        field(9; "Copy Lines"; Boolean)
        {
            Caption = 'Copy Lines';
        }
        field(10; "Replace Lines"; Boolean)
        {
            Caption = 'Replace Lines';
        }
        field(11; "Copy Comments"; Boolean)
        {
            Caption = 'Copy Comments';
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
