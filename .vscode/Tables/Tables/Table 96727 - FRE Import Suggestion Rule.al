// ------------------------------------------------------------------------------------------------
// Copyright (c) Tomàs Forné Martínez. All rights reserved.
// ------------------------------------------------------------------------------------------------

table 96727 "FRE Import Suggestion Rule"
{
    Caption = 'FRE Import Suggestion Rule';
    DataClassification = ToBeClassified;

    fields
    {
        field(1; "Entry No."; Integer)
        {
            AutoIncrement = true;
        }

        field(2; "Pattern"; Text[250])
        {
            Caption = 'Pattern';
        }

        field(3; "Row No."; Code[10])
        {
            Caption = 'Row No.';
        }

        field(4; "Source Type"; Enum "FRE Journal Source Type")
        {
            Caption = 'Source Type';
        }

        field(5; "Source No."; Code[20])
        {
            Caption = 'Source No.';
        }

        field(6; "Hit Count"; Integer)
        {
            Caption = 'Hit Count';
        }

        field(7; "Last Used Date"; Date)
        {
            Caption = 'Last Used Date';
        }
        field(27; "Entry Category"; Enum "FRE Entry Category")
        {
            Caption = 'Entry Category';
        }
    }

    keys
    {
        key(PK; "Entry No.") { Clustered = true; }
        key(PatternKey; Pattern) { }
    }
}