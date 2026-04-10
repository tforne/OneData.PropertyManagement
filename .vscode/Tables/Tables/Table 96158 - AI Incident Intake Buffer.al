table 96158 "AI Incident Intake Buffer"
{
    Caption = 'AI Incident Intake Buffer';
    DataPerCompany = false;
    DrillDownPageId = "AI Incident Intake Buffers";
    LookupPageId = "AI Incident Intake Buffers";

    fields
    {
        field(1; "Entry No."; Integer)
        {
            AutoIncrement = true;
            Caption = 'Entry No.';
        }
        field(2; "Received At"; DateTime)
        {
            Caption = 'Received At';
        }
        field(3; "From E-Mail"; Text[100])
        {
            Caption = 'From E-Mail';
            ExtendedDatatype = EMail;
        }
        field(4; "From Name"; Text[100])
        {
            Caption = 'From Name';
        }
        field(5; Subject; Text[250])
        {
            Caption = 'Subject';
        }
        field(6; "Body Preview"; Text[2048])
        {
            Caption = 'Body Preview';
        }
        field(7; "Original Message Id"; Text[250])
        {
            Caption = 'Original Message Id';
        }
        field(8; "Has Attachments"; Boolean)
        {
            Caption = 'Has Attachments';
        }
        field(9; "Attachment Names"; Text[250])
        {
            Caption = 'Attachment Names';
        }
        field(20; Status; Option)
        {
            Caption = 'Status';
            OptionMembers = New,Analyzed,ReadyToCreate,Created,Error,Reviewed;
            OptionCaption = 'New,Analyzed,Ready to Create,Created,Error,Reviewed';
        }
        field(21; "Processing Log"; Text[2048])
        {
            Caption = 'Processing Log';
        }
        field(30; "AI Summary"; Text[2048])
        {
            Caption = 'AI Summary';
        }
        field(31; "AI Confidence"; Decimal)
        {
            Caption = 'AI Confidence';
            DecimalPlaces = 0 : 5;
        }
        field(32; "AI Priority"; Option)
        {
            Caption = 'AI Priority';
            OptionMembers = " ",High,Normal,Low;
            OptionCaption = ' ,High,Normal,Low';
        }
        field(33; "AI Case Type"; Option)
        {
            Caption = 'AI Case Type';
            OptionMembers = " ",Question,Problem,Request;
            OptionCaption = ' ,Question,Problem,Request';
        }
        field(34; "AI Notify Insurance"; Boolean)
        {
            Caption = 'AI Notify Insurance';
        }
        field(35; "AI Insurance Reason"; Text[250])
        {
            Caption = 'AI Insurance Reason';
        }
        field(40; "Suggested Real Estate No."; Code[20])
        {
            Caption = 'Suggested Real Estate No.';
            TableRelation = "Fixed Real Estate"."No.";
        }
        field(41; "Suggested Contract No."; Code[20])
        {
            Caption = 'Suggested Contract No.';
            TableRelation = "Lease Contract"."Contract No.";
        }
        field(42; "Suggested Contact No."; Code[20])
        {
            Caption = 'Suggested Contact No.';
            TableRelation = Contact."No.";
        }
        field(43; "Suggested Insurance Policy No."; Code[20])
        {
            Caption = 'Suggested Insurance Policy No.';
            TableRelation = "RE Insurance Policy"."No.";
        }
        field(44; "Suggested Incident Date"; Date)
        {
            Caption = 'Suggested Incident Date';
        }
        field(45; "Suggested Title"; Text[200])
        {
            Caption = 'Suggested Title';
        }
        field(46; "Suggested Description"; Text[2048])
        {
            Caption = 'Suggested Description';
        }
        field(47; "Suggested Resolution Date"; Date)
        {
            Caption = 'Suggested Resolution Date';
        }
        field(48; "Created Incident Id"; Guid)
        {
            Caption = 'Created Incident Id';
            TableRelation = "Incident Assets Real Estate"."Incident Id.";
        }
    }

    keys
    {
        key(PK; "Entry No.")
        {
            Clustered = true;
        }
        key(StatusKey; Status, "Received At")
        {
        }
        key(MessageKey; "Original Message Id")
        {
        }
    }

    procedure MarkAsError(LogText: Text)
    begin
        Status := Status::Error;
        "Processing Log" := CopyStr(LogText, 1, MaxStrLen("Processing Log"));
    end;

    procedure MarkAsCreated(IncidentId: Guid)
    begin
        "Created Incident Id" := IncidentId;
        Status := Status::Created;
    end;
}
