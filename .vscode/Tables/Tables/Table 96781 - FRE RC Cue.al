// ------------------------------------------------------------------------------------------------
// Copyright (c) Tomàs Forné Martínez. All rights reserved.
// ------------------------------------------------------------------------------------------------


namespace OneData.Property.Finance;

table 96781 "FRE RC Cue"
{
    Caption = 'FRE RC Cue';
    DataClassification = SystemMetadata;

    fields
    {
        field(1; "Primary Key"; Code[10])
        {
            Caption = 'Primary Key';
        }

        field(2; "Pending Statements"; Integer)
        {
            Caption = 'Pending Statements';
        }

        field(3; "Imported Statements"; Integer)
        {
            Caption = 'Imported Statements';
        }

        field(4; "Posted Statements"; Integer)
        {
            Caption = 'Posted Statements';
        }

        field(5; "Journal Lines"; Integer)
        {
            Caption = 'Journal Lines';
        }

        field(6; "Ledger Entries"; Integer)
        {
            Caption = 'Ledger Entries';
        }
        field(7; "Pending Imports"; Integer)
        {
            Caption = 'Pending Imports';
        }

        field(8; "Property Assets"; Integer)
        {
            Caption = 'Property Assets';
        }

        field(9; "Fixed Assets"; Integer)
        {
            Caption = 'Fixed Assets';
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