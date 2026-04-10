page 96159 "ODPM Incident Agent Setup"
{
    ApplicationArea = All;
    Caption = 'ODPM Incident Agent Setup';
    DeleteAllowed = false;
    InsertAllowed = false;
    PageType = Card;
    SourceTable = "ODPM Incident Agent Setup";
    UsageCategory = Administration;

    layout
    {
        area(Content)
        {
            group(General)
            {
                Caption = 'General';
                field(Enabled; Rec.Enabled)
                {
                    ToolTip = 'Specifies whether the incident intake agent is enabled.';
                }
                field("Shared Mailbox"; Rec."Shared Mailbox")
                {
                    ToolTip = 'Specifies the Office 365 shared mailbox that receives incident e-mails.';
                }
                field("Incoming Mail Folder"; Rec."Incoming Mail Folder")
                {
                    ToolTip = 'Specifies the mailbox folder that Power Automate should monitor.';
                }
            }
            group(PowerAutomate)
            {
                Caption = 'Power Automate';
                field("Power Automate Flow Name"; Rec."Power Automate Flow Name")
                {
                    ToolTip = 'Specifies the display name of the Power Automate flow used for intake.';
                }
                field("Power Automate Flow URL"; Rec."Power Automate Flow URL")
                {
                    ExtendedDatatype = URL;
                    ToolTip = 'Specifies the HTTP endpoint or flow URL used to send e-mail intake data to Business Central.';
                }
            }
            group(AI)
            {
                Caption = 'AI';
                field("Use AI"; Rec."Use AI")
                {
                    ToolTip = 'Specifies whether the intake flow should use AI to enrich the incident proposal.';
                }
                field("AI Provider"; Rec."AI Provider")
                {
                    ToolTip = 'Specifies the AI provider planned for the intake flow.';
                }
                field("Auto Create Drafts"; Rec."Auto Create Drafts")
                {
                    ToolTip = 'Specifies whether the flow can create draft incidents automatically when confidence is high enough.';
                }
                field("Confidence Threshold"; Rec."Confidence Threshold")
                {
                    ToolTip = 'Specifies the minimum confidence expected before allowing automated draft creation.';
                }
            }
            group(Checklist)
            {
                Caption = 'Connection Checklist';
                field(MailboxConfigured; MailboxConfigured)
                {
                    ApplicationArea = All;
                    Caption = 'Shared Mailbox Configured';
                    Editable = false;
                }
                field(FlowConfigured; FlowConfigured)
                {
                    ApplicationArea = All;
                    Caption = 'Power Automate Flow Configured';
                    Editable = false;
                }
                field(AIConfigured; AIConfigured)
                {
                    ApplicationArea = All;
                    Caption = 'AI Threshold Ready';
                    Editable = false;
                }
                field(SetupReady; SetupReady)
                {
                    ApplicationArea = All;
                    Caption = 'Setup Ready';
                    Editable = false;
                }
                field(ChecklistSummary; ChecklistSummary)
                {
                    ApplicationArea = All;
                    Caption = 'Summary';
                    Editable = false;
                    MultiLine = true;
                }
                field("Setup Completed"; Rec."Setup Completed")
                {
                    Editable = false;
                }
                field("Last Validation At"; Rec."Last Validation At")
                {
                    Editable = false;
                }
                field("Last Validation Result"; Rec."Last Validation Result")
                {
                    Editable = false;
                    MultiLine = true;
                }
            }
        }
    }

    actions
    {
        area(Processing)
        {
            action(RunAssistedSetup)
            {
                ApplicationArea = All;
                Caption = 'Run Assisted Setup';
                Image = Setup;
                Promoted = true;
                PromotedCategory = Process;
                ToolTip = 'Open the assisted setup wizard for the incident intake agent.';

                trigger OnAction()
                begin
                    Page.RunModal(Page::"ODPM Incid. Agent Setup Wizard");
                    CurrPage.Update(false);
                end;
            }
            action(TestConfiguration)
            {
                ApplicationArea = All;
                Caption = 'Test Configuration';
                Image = TestFile;
                Promoted = true;
                PromotedCategory = Process;
                ToolTip = 'Validate the minimum setup required to connect Power Automate and Business Central.';

                trigger OnAction()
                begin
                    CurrPage.SaveRecord();
                    if SetupMgt.ValidateConfiguration(Rec) then
                        Message('Configuration validated successfully.')
                    else
                        Message(Rec."Last Validation Result");

                    UpdateChecklist();
                    CurrPage.Update(false);
                end;
            }
            action(OpenPowerAutomate)
            {
                ApplicationArea = All;
                Caption = 'Open Power Automate Flow';
                Image = LinkWeb;
                ToolTip = 'Open the configured Power Automate flow URL.';

                trigger OnAction()
                begin
                    CurrPage.SaveRecord();
                    SetupMgt.OpenFlowUrl(Rec);
                end;
            }
            action(OpenHelp)
            {
                ApplicationArea = All;
                Caption = 'Open Help';
                Image = Questionaire;
                ToolTip = 'Open the documentation URL for the incident intake agent.';

                trigger OnAction()
                begin
                    if Rec."Help URL" <> '' then
                        Hyperlink(Rec."Help URL");
                end;
            }
        }
    }

    trigger OnOpenPage()
    begin
        SetupMgt.GetSetup(Rec);
        UpdateChecklist();
    end;

    trigger OnAfterGetCurrRecord()
    begin
        UpdateChecklist();
    end;

    var
        SetupMgt: Codeunit "ODPM Incident Agent Setup Mgt.";
        MailboxConfigured: Boolean;
        FlowConfigured: Boolean;
        AIConfigured: Boolean;
        SetupReady: Boolean;
        ChecklistSummary: Text;

    local procedure UpdateChecklist()
    begin
        SetupMgt.GetChecklistState(Rec, MailboxConfigured, FlowConfigured, AIConfigured, SetupReady, ChecklistSummary);
    end;
}
