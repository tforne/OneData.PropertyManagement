// ------------------------------------------------------------------------------------------------
// Copyright (c) Tomàs Forné Martínez. All rights reserved.
// ------------------------------------------------------------------------------------------------

table 96100 "Incident Assets Real Estate"
{
    Caption = 'Incident Assets Real Estate';
    Description = 'Service request case associated with a contract.';
    DrillDownPageId = "Incidents List";
    DataPerCompany  = false;

    fields
    {
        field(1; "Incident Id."; Guid)
        {
            Caption = 'Case';
            Description = 'Unique identifier of the case.';
        }
        field(2; "Fixed Real Estate No."; Code[20])
        {
            Caption = 'Fixed Real Estate No.';
            TableRelation = "Fixed Real Estate"."No.";
            Description = 'Select the real estate asset for which the case is being created.';

            trigger OnValidate()
            var
                fixedRE: Record "Fixed Real Estate"; 
            begin 
                ClearContractData();
                "REF Description" := '';

                if "Fixed Real Estate No." = '' then
                    exit;

                if FixedRE.Get("Fixed Real Estate No.") then
                    "REF Description" := FixedRE.Description;
            end;
        }
        field(3; "Contract No."; Code[20])
        {
            Caption = 'Contract';
            Description = 'Choose the service contract that the case should be logged under to make sure the customer is eligible for support services.';
            TableRelation = "Lease Contract"."Contract No." where ("Fixed Real Estate No."=field("Fixed Real Estate No."));
            trigger OnValidate()
            var
                LeaseContract: Record "Lease Contract";              
            begin   
                ClearContractSnapshot();

                if "Contract No." = '' then begin
                    Validate("Contact No", '');
                    exit;
                end;

                if LeaseContract.Get("Contract No.") then begin
                    "Contract - Contact Name" := LeaseContract."Contact Name";
                    "Contract - Phone No." := LeaseContract."Phone No.";
                    "Contract - EMail" := LeaseContract."E-Mail";
                    Validate("Contact No", LeaseContract."Contact No.");
                end;
                end;
        }
        field(4; "Incident Date"; Date)
        {
            Caption = 'Incident Date';
            Description = 'Enter the date when the case was created.';
        }   
        field(5; "REF Description"; Text[250])
        {
            Caption = 'REF Description';
            Description = 'Type additional information to describe the case, such as the customer''s issue or request.';
        }
        field(8; "Case Type"; Option)
        {
            Caption = 'Case Type';
            Description = 'Select the type of case to identify the incident for use in case routing and analysis.';
            InitValue = " ";
            OptionCaption = ' ,Question,Problem,Request';
            OptionMembers = " ",Question,Problem,Request;
        }
        field(10; Title; Text[200])
        {
            Caption = 'Case Title';
            Description = 'Type a subject or descriptive name, such as the request, issue, or company name, to identify the case in Microsoft Dynamics CRM views.';
        }
        field(15; "Contact No"; Code[20])
        {
            Caption = 'Contact';
            Description = 'Unique identifier of the contact associated with the case.';
            TableRelation = Contact."No.";
            trigger OnValidate()
            var
                ContactRec: Record Contact;     
            begin   
                if not ContactRec.Get(rec."Contact No") then
                    ContactRec.init;    
                rec."Contact - Name" := ContactRec.Name;    
            end;
        }
        field(16; "Contact - Name"; Text[100])
        {
            Caption = 'Contact Name';
            Description = 'Name of the contact associated with the case.';
        }
        field(17; CreatedOn; DateTime)
        {
            Caption = 'Created On';
            Description = 'Shows the date and time when the record was created. The date and time are displayed in the time zone selected in Microsoft Dynamics CRM options.';
        }
        field(19; Priority; Option)
        {
            Caption = 'Priority';
            Description = 'Select the priority so that preferred customers or critical issues are handled quickly.';
            InitValue = Normal;
            OptionCaption = 'High,Normal,Low';
            OptionMembers = High,Normal,Low;
        }
        field(20; CustomerSatisfactionCode; Option)
        {
            Caption = 'Satisfaction';
            Description = 'Select the customer''s level of satisfaction with the handling and resolution of the case.';
            InitValue = " ";
            OptionCaption = ' ,Very Satisfied,Satisfied,Neutral,Dissatisfied,Very Dissatisfied';
            OptionMembers = " ",VerySatisfied,Satisfied,Neutral,Dissatisfied,VeryDissatisfied;
        }
        field(22; ModifiedOn; DateTime)
        {
            Caption = 'Modified On';
            Description = 'Shows the date and time when the record was last updated. The date and time are displayed in the time zone selected in Microsoft Dynamics CRM options.';
        }
        field(24; FollowupBy; Date)
        {
            Caption = 'Follow Up By';
            Description = 'Enter the date by which a customer service representative has to follow up with the customer on this case.';
            trigger OnValidate()
            begin
                REIncidentMgt.CheckStatusConsistency(Rec);
            end;
        }
        field(27; StateCode; Option)
        {
            Caption = 'Status';
            Description = 'Shows whether the case is active, resolved, or canceled. Resolved and canceled cases are read-only and can''t be edited unless they are reactivated.';
            InitValue = Active;
            OptionCaption = 'Active,Resolved,Canceled,Closed';
            OptionMembers = Active,Resolved,Canceled,Closed;
            
            trigger OnValidate()
            begin
                REIncidentMgt.OnValidateStateCode(Rec);
            end;
        }
        field(29; StatusCode; Option)
        {
            Caption = 'Status Reason';
            Description = 'Select the case''s status.';
            InitValue = " ";
            OptionCaption = ' ,Problem Solved,Information Provided,Canceled,Merged,In Progress,On Hold,Waiting for Details,Researching';
            OptionMembers = " ",ProblemSolved,InformationProvided,Canceled,Merged,InProgress,OnHold,WaitingforDetails,Researching;
    
            trigger OnValidate()
            begin
                REIncidentMgt.OnValidateStatusCode(Rec);
            end;
        }
        field(31; Description; Text[2048])
        {
            Caption = 'Description';
            Description = 'Type additional information to describe the case, such as the customer''s issue or request.';
        }
        field(33; "Capture Medium Code"; Code[10])
        {
            Caption = 'Capture Medium';
            Description = 'Indicates the medium through which the case was captured.';
            TableRelation = "Capture Medium".Code;
        }
        field(34; "Expected Resolution Date"; Date)
        {
            Caption = 'Expected Resolution Date';
            Description = 'Enter the date by which the case is expected to be resolved.';
        }
        field(35; "Resolution Date"; Date)
        {
            Caption = 'Resolution Date';
            Description = 'Enter the date when the case was resolved.';
            trigger OnValidate()
            begin
                REIncidentMgt.OnValidateResolutionDate(Rec);
            end;
        }
        field(40; "Contract - Contact Name" ; text[100])
        {
            Caption = 'Contract - Contact Name';
            Editable = false;
        }
        field(41; "Contract - Phone No." ; Text[30])
        {
            Caption = 'Contract - Phone No.';
            ExtendedDatatype = PhoneNo;

        }
        field(42;"Contract - EMail"; Text[80])
        {
            Caption = 'Email';
            ExtendedDatatype = EMail;
        }

        field(60; URL; Text[1024])
        {
            Caption = 'URL';
            Editable = false;
        }
    }

    keys
    {
        key(Key1; "Incident Id.")
        {
            Clustered = true;
        }
        key(Key2; Title){}
        key(ket3; "Fixed Real Estate No.","Incident Date"){}
        key(Key4; StateCode, StatusCode) { }
        key(Key5; "Contract No.") { }
        key(Key6; "Incident Date") { }
        key(Key7; Priority, StateCode) { }
    }

    fieldgroups
    {
        fieldgroup(DropDown; Title,"REF Description", "Contact - Name")
        {
        }
        fieldgroup(drilldown; "Incident Id.", Title, "Contract No.","Contact - Name")
        {
        }
    }

    trigger OnInsert()
    var
        CaptureMedium: Record "Capture Medium";
    begin
        REIncidentMgt.OnInsertIncident(Rec);
    end;

    trigger OnModify()
    begin
        REIncidentMgt.OnModifyIncident(Rec);
    end;
    
    trigger OnDelete()
    // Delete related attachments when an incident is deleted
    var
        IncidentAttachment: Record "Incident Attachment";
    begin
        IncidentAttachment.SetRange("Incident Id.", rec."Incident Id.");
        IncidentAttachment.DeleteAll();
    end;
    
    procedure GetURL(): Text
    begin
        exit(URL);
    end;

    var
        UrlTooLongErr: Label 'Only URLs with a maximum of %1 characters are allowed.', Comment = '%1 = length of the URL field (e.g. 1024).';
        REIncidentMgt: Codeunit "RE Incident Management";     

    procedure SetURL(NewURL: Text)
    begin

        if StrLen(NewURL) > MaxStrLen(URL) then
            Error(UrlTooLongErr, MaxStrLen(URL));

        URL := NewURL;
    end;

    procedure CreateIncident(PictureInStream: InStream; FileName: Text)
    var
        Incident: Record "Incident Assets Real Estate";
        IncidentAttachment: Record "Incident Attachment";
        FileManagement: Codeunit "File Management";
    begin
        Incident.CopyFilters(Rec);
        CreateIncident(FileManagement.GetFileNameWithoutExtension(FileName), '');
        AddAttachmentFromStream(IncidentAttachment, FileName, FileManagement.GetExtension(FileName), PictureInStream);
        CopyFilters(Incident);
    end;

    procedure CreateIncident(NewDescription: Text; NewURL: Text): Guid
    begin
        Reset();
        Clear(Rec);
        Init();
        Description := CopyStr(NewDescription, 1, MaxStrLen(Description));
        Insert(true);
        exit("Incident Id.");
    end;
    
    procedure CreateIncident(IncidentAttachment: Record "Incident Attachment"; NewDescription: Text; NewURL: Text): Guid
    begin
        Reset();
        Clear(Rec);
        Init();
        "Incident Id." := IncidentAttachment."Incident Id.";
        Description := CopyStr(NewDescription, 1, MaxStrLen(Description));
        Insert(true);
        exit("Incident Id.");
    end;
    
    procedure CreateFromAttachment()
    var
        IncidentAttachment: Record "Incident Attachment";
        Incident: Record "Incident Assets Real Estate";
    begin
        if IncidentAttachment.Import(true) then begin
            Incident.Get(IncidentAttachment."Incident Id.");
            PAGE.Run(PAGE::"RE Incident Card", Incident);
        end;
    end;

    procedure AddAttachmentFromStream(var IncidentAttachment: Record "Incident Attachment"; OrgFileName: Text; FileExtension: Text; var InStr: InStream)
    var
        insIncidentAttachment: Record "Incident Attachment";
        lastIncidentAttachment: Record "Incident Attachment";   
        FileManagement: Codeunit "File Management";
        OutStr: OutStream;
        LineNo: Integer;
    begin
        insIncidentAttachment := IncidentAttachment;
        lastIncidentAttachment.reset;
        lastIncidentAttachment.SetRange("Incident Id.", IncidentAttachment."Incident Id.");
        if not lastIncidentAttachment.FindLast() then
            LineNo := 10000
        else
            LineNo := lastIncidentAttachment."Line No." + 10000;
        insIncidentAttachment."Incident Id." := rec."Incident Id.";
        insIncidentAttachment."Line No." := LineNo;
        insIncidentAttachment.Name :=
          CopyStr(FileManagement.GetFileNameWithoutExtension(OrgFileName), 1, MaxStrLen(IncidentAttachment.Name));
        insIncidentAttachment.Validate(
          "File Extension", CopyStr(FileExtension, 1, MaxStrLen(IncidentAttachment."File Extension")));
        insIncidentAttachment.Content.CreateOutStream(OutStr);
        CopyStream(OutStr, InStr);
        insIncidentAttachment.Insert(true);
    end;

    procedure ImportAttachment(var Incident: Record "Incident Assets Real Estate")
    var
        IncidentAttachment: Record "Incident Attachment";
    begin
        IncidentAttachment.Reset();
        IncidentAttachment.SetRange("Incident Id.", Incident."Incident Id.");
        IncidentAttachment.NewAttachment();
        Incident.Get(IncidentAttachment."Incident Id.")
    end;
   procedure GetMainAttachment(var IncidentAttachment: Record "Incident Attachment"): Boolean
    begin
        IncidentAttachment.SetRange("Incident Id.", "Incident Id.");
        IncidentAttachment.SetRange("Main Attachment", true);
        exit(IncidentAttachment.FindFirst())
    end;

    procedure GetMainAttachmentFileName(): Text
    var
        IncidentAttachment: Record "Incident Attachment";
    begin
        if GetMainAttachment(IncidentAttachment) then
            exit(IncidentAttachment.GetFullName());
        exit('');
    end;
        
        
    procedure GetAdditionalAttachments(var IncidentAttachment: Record "Incident Attachment"): Boolean
    begin
        IncidentAttachment.SetRange("Incident Id.", "Incident Id.");
        exit(IncidentAttachment.FindSet());
    end;

    local procedure ClearContractData()
    begin
        "Contract No." := '';
        ClearContractSnapshot();
        Validate("Contact No", '');
    end;

    local procedure ClearContractSnapshot()
    begin
        "Contract - Contact Name" := '';
        "Contract - Phone No." := '';
        "Contract - EMail" := '';
    end;
}

