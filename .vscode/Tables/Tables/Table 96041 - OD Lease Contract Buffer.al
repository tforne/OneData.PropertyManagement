// ------------------------------------------------------------------------------------------------
// Copyright (c) Tomàs Forné Martínez. All rights reserved.
// ------------------------------------------------------------------------------------------------

namespace OneData.Property.Lease;

table 96041 "OD Lease Contract Buffer"
{
    Caption = 'Lease Contract Buffer';
    DataClassification = CustomerContent;

    fields
    {
        field(1; "Entry No."; Integer)
        {
            Caption = 'Entry No.';
        }
        field(2; "Company Name"; Text[30])
        {
            Caption = 'Company Name';
        }
        field(3; "Contract No."; Code[20])
        {
            Caption = 'Contract No.';
        }
        field(4; Description; Text[80])
        {
            Caption = 'Description';
        }
        field(5; "Customer No."; Code[20])
        {
            Caption = 'Customer No.';
        }
        field(6; "Fixed Real Estate No."; Code[20])
        {
            Caption = 'Fixed Real Estate No.';
        }
        field(7; "Starting Date"; Date)
        {
            Caption = 'Starting Date';
        }
        field(8; "Expiration Date"; Date)
        {
            Caption = 'Expiration Date';
        }
        field(9; StatusText; Text[30])
        {
            Caption = 'Status';
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
