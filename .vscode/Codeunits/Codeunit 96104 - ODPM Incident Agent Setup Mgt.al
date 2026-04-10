codeunit 96104 "ODPM Incident Agent Setup Mgt."
{
    var
        SetupTitleLbl: Label 'Incident Intake Agent Setup';
        SetupShortTitleLbl: Label 'Incident Intake Agent';
        SetupDescriptionLbl: Label 'Configure the shared mailbox, Power Automate flow and AI behavior for the incident intake agent.';
        SetupHelpUrlLbl: Label 'https://tforne.github.io/OneData.PropertyManagement/docs/roadmap/';
        MailboxMissingLbl: Label 'shared mailbox';
        FlowUrlMissingLbl: Label 'Power Automate flow URL';
        ThresholdMissingLbl: Label 'confidence threshold';
        ValidationOkLbl: Label 'Configuration validated successfully.';
        ValidationPendingLbl: Label 'Pending configuration: %1';

    [EventSubscriber(ObjectType::Codeunit, Codeunit::"Guided Experience", 'OnRegisterAssistedSetup', '', true, true)]
    local procedure RegisterAssistedSetup()
    var
        GuidedExperience: Codeunit "Guided Experience";
    begin
        GuidedExperience.InsertAssistedSetup(
            SetupTitleLbl,
            SetupShortTitleLbl,
            SetupDescriptionLbl,
            10,
            ObjectType::Page,
            Page::"ODPM Incid. Agent Setup Wizard",
            Enum::"Assisted Setup Group"::ODPM,
            '',
            Enum::"Video Category"::Uncategorized,
            SetupHelpUrlLbl);
    end;

    [EventSubscriber(ObjectType::Codeunit, Codeunit::"Guided Experience", 'OnRegisterManualSetup', '', true, true)]
    local procedure RegisterManualSetup()
    var
        GuidedExperience: Codeunit "Guided Experience";
    begin
        GuidedExperience.InsertManualSetup(
            SetupTitleLbl,
            SetupShortTitleLbl,
            SetupDescriptionLbl,
            11,
            ObjectType::Page,
            Page::"ODPM Incident Agent Setup",
            Enum::"Manual Setup Category"::ODPM,
            SetupHelpUrlLbl);
    end;

    procedure GetSetup(var AgentSetup: Record "ODPM Incident Agent Setup")
    begin
        EnsureSetupExists(AgentSetup);
    end;

    procedure EnsureSetupExists(var AgentSetup: Record "ODPM Incident Agent Setup")
    begin
        if AgentSetup.Get('') then begin
            ApplyDefaultValues(AgentSetup);
            exit;
        end;

        AgentSetup.Init();
        AgentSetup."Primary Key" := '';
        AgentSetup.Enabled := false;
        AgentSetup."Incoming Mail Folder" := 'Inbox';
        AgentSetup."Use AI" := true;
        AgentSetup."Confidence Threshold" := 0.85;
        AgentSetup."Help URL" := SetupHelpUrlLbl;
        AgentSetup.Insert(true);
    end;

    procedure ValidateConfiguration(var AgentSetup: Record "ODPM Incident Agent Setup"): Boolean
    var
        MissingItems: Text;
    begin
        EnsureSetupExists(AgentSetup);
        MissingItems := GetMissingConfigurationText(AgentSetup);
        AgentSetup."Last Validation At" := CurrentDateTime();

        if MissingItems = '' then
            AgentSetup."Last Validation Result" := ValidationOkLbl
        else
            AgentSetup."Last Validation Result" :=
                CopyStr(StrSubstNo(ValidationPendingLbl, MissingItems), 1, MaxStrLen(AgentSetup."Last Validation Result"));

        AgentSetup."Setup Completed" := MissingItems = '';
        AgentSetup.Modify(true);

        exit(MissingItems = '');
    end;

    procedure MarkSetupCompleted(var AgentSetup: Record "ODPM Incident Agent Setup")
    begin
        ValidateConfiguration(AgentSetup);
        if AgentSetup."Setup Completed" then
            AgentSetup.Enabled := true;
        AgentSetup.Modify(true);
    end;

    procedure GetChecklistState(
        var AgentSetup: Record "ODPM Incident Agent Setup";
        var MailboxConfigured: Boolean;
        var FlowConfigured: Boolean;
        var AIConfigured: Boolean;
        var SetupReady: Boolean;
        var Summary: Text)
    var
        MissingItems: Text;
    begin
        EnsureSetupExists(AgentSetup);

        MailboxConfigured := AgentSetup."Shared Mailbox" <> '';
        FlowConfigured := AgentSetup."Power Automate Flow URL" <> '';
        AIConfigured := (not AgentSetup."Use AI") or (AgentSetup."Confidence Threshold" > 0);

        MissingItems := GetMissingConfigurationText(AgentSetup);
        SetupReady := MissingItems = '';

        if SetupReady then
            Summary := ValidationOkLbl
        else
            Summary := CopyStr(StrSubstNo(ValidationPendingLbl, MissingItems), 1, 2048);
    end;

    procedure OpenFlowUrl(var AgentSetup: Record "ODPM Incident Agent Setup")
    begin
        if AgentSetup."Power Automate Flow URL" = '' then
            Error(FlowUrlMissingLbl);

        Hyperlink(AgentSetup."Power Automate Flow URL");
    end;

    local procedure ApplyDefaultValues(var AgentSetup: Record "ODPM Incident Agent Setup")
    var
        IsModified: Boolean;
    begin
        if AgentSetup."Incoming Mail Folder" = '' then begin
            AgentSetup."Incoming Mail Folder" := 'Inbox';
            IsModified := true;
        end;

        if AgentSetup."Confidence Threshold" = 0 then begin
            AgentSetup."Confidence Threshold" := 0.85;
            IsModified := true;
        end;

        if AgentSetup."Help URL" = '' then begin
            AgentSetup."Help URL" := SetupHelpUrlLbl;
            IsModified := true;
        end;

        if IsModified then
            AgentSetup.Modify(true);
    end;

    local procedure GetMissingConfigurationText(var AgentSetup: Record "ODPM Incident Agent Setup"): Text
    var
        MissingItems: Text;
    begin
        if AgentSetup."Shared Mailbox" = '' then
            AddMissingItem(MissingItems, MailboxMissingLbl);

        if AgentSetup."Power Automate Flow URL" = '' then
            AddMissingItem(MissingItems, FlowUrlMissingLbl);

        if AgentSetup."Use AI" and (AgentSetup."Confidence Threshold" <= 0) then
            AddMissingItem(MissingItems, ThresholdMissingLbl);

        exit(MissingItems);
    end;

    local procedure AddMissingItem(var MissingItems: Text; MissingItem: Text)
    begin
        if MissingItems <> '' then
            MissingItems += ', ';

        MissingItems += MissingItem;
    end;
}
