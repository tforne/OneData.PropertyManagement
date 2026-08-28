table 96970 "RE Incident Contract Lookup"
{
    Caption = 'RE Incident Contract Lookup';
    TableType = Temporary;

    fields
    {
        field(1; "Entry No."; Integer)
        {
            Caption = 'Entry No.';
        }
        field(10; "Company Name"; Text[30])
        {
            Caption = 'Company Name';
        }
        field(20; "Contract No."; Code[20])
        {
            Caption = 'Contract No.';
        }
        field(30; "Customer No."; Code[20])
        {
            Caption = 'Customer No.';
        }
        field(40; "Contact No."; Code[20])
        {
            Caption = 'Contact No.';
        }
        field(50; "Contract Contact Name"; Text[100])
        {
            Caption = 'Contract - Contact Name';
        }
        field(60; "Contact Phone No."; Text[100])
        {
            Caption = 'Contact Phone No.';
        }
        field(70; "Contact E-Mail"; Text[100])
        {
            Caption = 'Contact E-Mail';
        }
        field(80; "Contract Phone No."; Text[100])
        {
            Caption = 'Contract - Phone No.';
        }
        field(90; "Contract E-Mail"; Text[100])
        {
            Caption = 'Contract E-Mail';
        }
        field(100; "Fixed Real Estate No."; Code[20])
        {
            Caption = 'Fixed Real Estate No.';
        }
        field(110; "Starting Date"; Date)
        {
            Caption = 'Starting Date';
        }
        field(120; "Expiration Date"; Date)
        {
            Caption = 'Expiration Date';
        }
    }

    keys
    {
        key(PK; "Entry No.")
        {
            Clustered = true;
        }
        key(Contract; "Fixed Real Estate No.", "Company Name", "Contract No.")
        {
        }
    }
}
