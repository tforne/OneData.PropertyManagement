table 96730 "FRE Asset Suggestion Rule"
{
    Caption = 'FRE Asset Suggestion Rule';
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

        field(3; "Fixed Real Estate No."; Code[20])
        {
            Caption = 'Fixed Real Estate No.';
        }

        field(4; "Hit Count"; Integer)
        {
            Caption = 'Hit Count';
        }

        field(5; "Last Used Date"; Date)
        {
            Caption = 'Last Used Date';
        }
                
        field(10; "Row No."; Code[10])
        {
            Caption = 'Row No.';
            DataClassification = ToBeClassified;
        }
        field(27; "Entry Category"; Enum "FRE Entry Category")
        {
            Caption = 'Entry Category';
        }
    }

    keys
    {
        key(PK; "Entry No.")
        {
            Clustered = true;
        }

        key(PatternKey; Pattern)
        {
        }
    }
}