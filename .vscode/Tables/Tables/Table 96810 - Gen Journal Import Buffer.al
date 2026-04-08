table 96810 "Gen Journal Import Buffer"
{
    Caption = 'Gen Journal Import Buffer';
    DataClassification = ToBeClassified;

    fields
    {
        field(1; "Line No."; Integer) { }
        field(2; "Posting Date"; Date) { }
        field(3; "Document No."; Code[20]) { }
        field(4; "Account Type"; Text[30]) { }
        field(5; "Account No."; Code[20]) { }
        field(6; Description; Text[100]) { }
        field(7; Amount; Decimal) { }

        field(20; "FRE Integration"; Boolean) { }
        field(21; "FRE Fixed Real Estate No."; Code[20]) { }
        field(22; "FRE FA No."; Code[20]) { }
        field(23; "FRE Entry Category"; Text[50]) { }
        field(24; "FRE Row No."; Code[10]) { }

        field(90; Status; Option)
        {
            OptionMembers = OK,Warning,Error;
        }

        field(91; Message; Text[250]) { }
    }

    keys
    {
        key(PK; "Line No.") { Clustered = true; }
    }
}