codeunit 96103 "AI Incident Intake Mgt."
{
    procedure RegisterIncomingEmail(
        FromEmail: Text[100];
        FromName: Text[100];
        MailSubject: Text[250];
        BodyPreview: Text;
        ReceivedAt: DateTime;
        OriginalMessageId: Text[250];
        HasAttachments: Boolean;
        AttachmentNames: Text[250]): Integer
    var
        IntakeBuffer: Record "AI Incident Intake Buffer";
    begin
        IntakeBuffer.Init();
        IntakeBuffer."Received At" := ReceivedAt;
        IntakeBuffer."From E-Mail" := FromEmail;
        IntakeBuffer."From Name" := FromName;
        IntakeBuffer.Subject := MailSubject;
        IntakeBuffer."Body Preview" := CopyStr(BodyPreview, 1, MaxStrLen(IntakeBuffer."Body Preview"));
        IntakeBuffer."Original Message Id" := OriginalMessageId;
        IntakeBuffer."Has Attachments" := HasAttachments;
        IntakeBuffer."Attachment Names" := AttachmentNames;
        IntakeBuffer.Status := IntakeBuffer.Status::New;
        IntakeBuffer.Insert(true);

        exit(IntakeBuffer."Entry No.");
    end;

    procedure ApplyAISuggestions(
        var IntakeBuffer: Record "AI Incident Intake Buffer";
        AISummary: Text;
        AIConfidence: Decimal;
        SuggestedTitle: Text[200];
        SuggestedDescription: Text;
        SuggestedRealEstateNo: Code[20];
        SuggestedContractNo: Code[20];
        SuggestedContactNo: Code[20];
        SuggestedInsurancePolicyNo: Code[20];
        SuggestedIncidentDate: Date;
        SuggestedPriority: Option " ",High,Normal,Low;
        SuggestedCaseType: Option " ",Question,Problem,Request;
        SuggestNotifyInsurance: Boolean;
        InsuranceReason: Text)
    begin
        IntakeBuffer."AI Summary" := CopyStr(AISummary, 1, MaxStrLen(IntakeBuffer."AI Summary"));
        IntakeBuffer."AI Confidence" := AIConfidence;
        IntakeBuffer."Suggested Title" := SuggestedTitle;
        IntakeBuffer."Suggested Description" := CopyStr(SuggestedDescription, 1, MaxStrLen(IntakeBuffer."Suggested Description"));
        IntakeBuffer."Suggested Real Estate No." := SuggestedRealEstateNo;
        IntakeBuffer."Suggested Contract No." := SuggestedContractNo;
        IntakeBuffer."Suggested Contact No." := SuggestedContactNo;
        IntakeBuffer."Suggested Insurance Policy No." := SuggestedInsurancePolicyNo;
        IntakeBuffer."Suggested Incident Date" := SuggestedIncidentDate;
        IntakeBuffer."AI Priority" := SuggestedPriority;
        IntakeBuffer."AI Case Type" := SuggestedCaseType;
        IntakeBuffer."AI Notify Insurance" := SuggestNotifyInsurance;
        IntakeBuffer."AI Insurance Reason" := CopyStr(InsuranceReason, 1, MaxStrLen(IntakeBuffer."AI Insurance Reason"));

        if IntakeBuffer."Suggested Title" <> '' then
            IntakeBuffer.Status := IntakeBuffer.Status::ReadyToCreate
        else
            IntakeBuffer.Status := IntakeBuffer.Status::Analyzed;

        IntakeBuffer.Modify(true);
    end;

    procedure CreateDraftIncidentFromBuffer(var IntakeBuffer: Record "AI Incident Intake Buffer"): Guid
    var
        Incident: Record "Incident Assets Real Estate";
        IncidentId: Guid;
    begin
        if not IsNullGuid(IntakeBuffer."Created Incident Id") then
            exit(IntakeBuffer."Created Incident Id");

        Incident.Init();
        if IntakeBuffer."Suggested Incident Date" <> 0D then
            Incident."Incident Date" := IntakeBuffer."Suggested Incident Date";

        if IntakeBuffer."Suggested Real Estate No." <> '' then
            Incident.Validate("Fixed Real Estate No.", IntakeBuffer."Suggested Real Estate No.");

        if IntakeBuffer."Suggested Contract No." <> '' then
            Incident.Validate("Contract No.", IntakeBuffer."Suggested Contract No.");

        if IntakeBuffer."Suggested Contact No." <> '' then
            Incident.Validate("Contact No", IntakeBuffer."Suggested Contact No.");

        if IntakeBuffer."Suggested Title" <> '' then
            Incident.Title := IntakeBuffer."Suggested Title"
        else
            Incident.Title := CopyStr(IntakeBuffer.Subject, 1, MaxStrLen(Incident.Title));

        if IntakeBuffer."Suggested Description" <> '' then
            Incident.Description := IntakeBuffer."Suggested Description"
        else
            Incident.Description := IntakeBuffer."Body Preview";

        Incident."REF Description" := CopyStr(IntakeBuffer."AI Summary", 1, MaxStrLen(Incident."REF Description"));
        Incident."Notify Insurance" := IntakeBuffer."AI Notify Insurance";

        if IntakeBuffer."Suggested Insurance Policy No." <> '' then
            Incident.Validate("Insurance Policy No.", IntakeBuffer."Suggested Insurance Policy No.");

        case IntakeBuffer."AI Priority" of
            IntakeBuffer."AI Priority"::High:
                Incident.Priority := Incident.Priority::High;
            IntakeBuffer."AI Priority"::Low:
                Incident.Priority := Incident.Priority::Low;
            else
                Incident.Priority := Incident.Priority::Normal;
        end;

        case IntakeBuffer."AI Case Type" of
            IntakeBuffer."AI Case Type"::Question:
                Incident."Case Type" := Incident."Case Type"::Question;
            IntakeBuffer."AI Case Type"::Problem:
                Incident."Case Type" := Incident."Case Type"::Problem;
            IntakeBuffer."AI Case Type"::Request:
                Incident."Case Type" := Incident."Case Type"::Request;
        end;

        Incident.Insert(true);
        IncidentId := Incident."Incident Id.";

        IntakeBuffer.MarkAsCreated(IncidentId);
        IntakeBuffer."Processing Log" := CopyStr(
            StrSubstNo('Incident created from AI intake buffer %1.', IntakeBuffer."Entry No."),
            1,
            MaxStrLen(IntakeBuffer."Processing Log"));
        IntakeBuffer.Modify(true);

        exit(IncidentId);
    end;
}
