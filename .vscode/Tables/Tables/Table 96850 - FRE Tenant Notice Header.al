table 96850 "FRE Tenant Notice Header"
{
    Caption = 'Tenant Notice';
    DataClassification = CustomerContent;
    DataPerCompany = false;
    DrillDownPageId = "FRE Tenant Notice List";
    LookupPageId = "FRE Tenant Notice List";

    fields
    {
        field(1; "Notice Id."; Guid)
        {
            Caption = 'Notice Id.';
        }
        field(2; "No."; Code[20])
        {
            Caption = 'No.';
        }
        field(3; Title; Text[100])
        {
            Caption = 'Title';
        }
        field(4; Description; Text[2048])
        {
            Caption = 'Description';
        }
        field(5; "Notice Type"; Enum "OD Tenant Notice Type")
        {
            Caption = 'Notice Type';
        }
        field(6; Priority; Enum "OD Tenant Notice Priority")
        {
            Caption = 'Priority';
            InitValue = Normal;
        }
        field(7; Status; Enum "OD Tenant Notice Status")
        {
            Caption = 'Status';
            InitValue = Draft;
        }
        field(8; "Show In Portal"; Boolean)
        {
            Caption = 'Show In Portal';
            InitValue = true;
        }
        field(9; "Send Email"; Boolean)
        {
            Caption = 'Send Email';
            InitValue = true;
        }
        field(10; "Publish From"; DateTime)
        {
            Caption = 'Publish From';
        }
        field(11; "Publish Until"; DateTime)
        {
            Caption = 'Publish Until';
        }
        field(12; "Requires Read Confirmation"; Boolean)
        {
            Caption = 'Requires Read Confirmation';
        }
        field(20; "Company Name"; Text[100])
        {
            Caption = 'Company Name';
        }
        field(21; "Asset No."; Code[20])
        {
            Caption = 'Asset No.';
        }
        field(22; "Contract No."; Code[20])
        {
            Caption = 'Contract No.';
        }
        field(23; "Incident Id."; Guid)
        {
            Caption = 'Incident Id.';
        }
        field(30; "Created By"; Code[50])
        {
            Caption = 'Created By';
            Editable = false;
        }
        field(31; "Created DateTime"; DateTime)
        {
            Caption = 'Created DateTime';
            Editable = false;
        }
        field(32; "Published DateTime"; DateTime)
        {
            Caption = 'Published DateTime';
            Editable = false;
        }
        field(33; "Sent DateTime"; DateTime)
        {
            Caption = 'Sent DateTime';
            Editable = false;
        }
        field(40; "Total Recipients"; Integer)
        {
            Caption = 'Total Recipients';
            FieldClass = FlowField;
            CalcFormula = count("FRE Tenant Notice Recipient" where("Notice Id." = field("Notice Id.")));
            Editable = false;
        }
        field(41; "Emails Sent"; Integer)
        {
            Caption = 'Emails Sent';
            FieldClass = FlowField;
            CalcFormula = count("FRE Tenant Notice Recipient" where("Notice Id." = field("Notice Id."), "Email Sent" = const(true)));
            Editable = false;
        }
        field(42; "Portal Reads"; Integer)
        {
            Caption = 'Portal Reads';
            FieldClass = FlowField;
            CalcFormula = count("FRE Tenant Notice Recipient" where("Notice Id." = field("Notice Id."), "Read In Portal" = const(true)));
            Editable = false;
        }
    }

    keys
    {
        key(PK; "Notice Id.") { Clustered = true; }
        key(No; "No.") { }
        key(Status; Status) { }
    }

    trigger OnInsert()
    begin
        if IsNullGuid("Notice Id.") then
            "Notice Id." := CreateGuid();

        if "Created DateTime" = 0DT then
            "Created DateTime" := CurrentDateTime;

        if "Created By" = '' then
            "Created By" := CopyStr(UserId(), 1, MaxStrLen("Created By"));
    end;
}
