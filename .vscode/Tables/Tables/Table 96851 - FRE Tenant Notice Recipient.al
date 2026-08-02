table 96851 "FRE Tenant Notice Recipient"
{
    Caption = 'Tenant Notice Recipient';
    DataClassification = CustomerContent;
    DataPerCompany = false;

    fields
    {
        field(1; "Notice Id."; Guid)
        {
            Caption = 'Notice Id.';
            TableRelation = "FRE Tenant Notice Header"."Notice Id.";
        }
        field(2; "Line No."; Integer)
        {
            Caption = 'Line No.';
        }
        field(3; "Customer No."; Code[20])
        {
            Caption = 'Customer No.';
            TableRelation = Customer."No.";
        }
        field(4; "Contact No."; Code[20])
        {
            Caption = 'Contact No.';
            TableRelation = Contact."No.";
        }
        field(5; "Contract No."; Code[20])
        {
            Caption = 'Contract No.';
        }
        field(6; "Asset No."; Code[20])
        {
            Caption = 'Asset No.';
        }
        field(7; Name; Text[100])
        {
            Caption = 'Name';
        }
        field(8; Email; Text[250])
        {
            Caption = 'Email';
            ExtendedDatatype = EMail;
        }
        field(9; "Portal Visible"; Boolean)
        {
            Caption = 'Portal Visible';
            InitValue = true;
        }
        field(10; "Email Sent"; Boolean)
        {
            Caption = 'Email Sent';
            Editable = false;
        }
        field(11; "Email Sent DateTime"; DateTime)
        {
            Caption = 'Email Sent DateTime';
            Editable = false;
        }
        field(12; "Read In Portal"; Boolean)
        {
            Caption = 'Read In Portal';
            Editable = false;
        }
        field(13; "Read DateTime"; DateTime)
        {
            Caption = 'Read DateTime';
            Editable = false;
        }
    }

    keys
    {
        key(PK; "Notice Id.", "Line No.") { Clustered = true; }
        key(Customer; "Customer No.") { }
        key(Contract; "Contract No.") { }
        key(Asset; "Asset No.") { }
    }
}
