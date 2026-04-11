page 96160 "ODPM Incid. Agent Setup Wizard"
{
    ApplicationArea = All;
    Caption = 'Incident Intake Agent Setup Wizard';
    DeleteAllowed = false;
    InsertAllowed = false;
    PageType = NavigatePage;
    SourceTable = "ODPM Incident Agent Setup";

    layout
    {
        area(Content)
        {
            group(WelcomeStep)
            {
                Caption = 'Welcome';
                Visible = Step = 1;
                group(WelcomeContent)
                {
                    InstructionalText = 'This wizard helps you configure the shared mailbox and Power Automate flow required to intake incidents from e-mail.';
                    field(WelcomeInfo; WelcomeInfo)
                    {
                        ApplicationArea = All;
                        ShowCaption = false;
                        Editable = false;
                        MultiLine = true;
                    }
                }
            }
            group(PowerAutomateStep)
            {
                Caption = 'Power Automate';
                Visible = Step = 2;
                group(PowerAutomateContent)
                {
                    field("Shared Mailbox"; Rec."Shared Mailbox")
                    {
                        ToolTip = 'Specifies the mailbox to monitor for incident e-mails.';
                    }
                    field("Incoming Mail Folder"; Rec."Incoming Mail Folder")
                    {
                        ToolTip = 'Specifies the folder to monitor in the shared mailbox.';
                    }
                    field("Power Automate Flow Name"; Rec."Power Automate Flow Name")
                    {
                        ToolTip = 'Specifies the flow name shown to users.';
                    }
                    field("Power Automate Flow URL"; Rec."Power Automate Flow URL")
                    {
                        ExtendedDatatype = URL;
                        ToolTip = 'Specifies the endpoint or flow URL used to receive incident intake data.';
                    }
                }
            }
            group(AIStep)
            {
                Caption = 'AI';
                Visible = Step = 3;
                group(AIContent)
                {
                    field("Use AI"; Rec."Use AI")
                    {
                        ToolTip = 'Specifies whether the flow should request AI suggestions before creating draft incidents.';
                    }
                    field("AI Provider"; Rec."AI Provider")
                    {
                        ToolTip = 'Specifies the planned AI provider.';
                    }
                    field("Auto Create Drafts"; Rec."Auto Create Drafts")
                    {
                        ToolTip = 'Specifies whether draft incidents can be created automatically.';
                    }
                    field("Confidence Threshold"; Rec."Confidence Threshold")
                    {
                        ToolTip = 'Specifies the confidence threshold expected for automation.';
                    }
                }
            }
            group(ReviewStep)
            {
                Caption = 'Review';
                Visible = Step = 4;
                group(ReviewContent)
                {
                    field(ReviewSummary; ReviewSummary)
                    {
                        ApplicationArea = All;
                        ShowCaption = false;
                        Editable = false;
                        MultiLine = true;
                    }
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
                }
            }
        }
    }

    actions
    {
        area(Processing)
        {
            action(BackAction)
            {
                ApplicationArea = All;
                Caption = 'Back';
                Enabled = Step > 1;
                Image = PreviousRecord;
                InFooterBar = true;

                trigger OnAction()
                begin
                    Step -= 1;
                    UpdateStep();
                end;
            }
            action(NextAction)
            {
                ApplicationArea = All;
                Caption = 'Next';
                Enabled = Step < 4;
                Image = NextRecord;
                InFooterBar = true;

                trigger OnAction()
                begin
                    if Step < 4 then
                        Step += 1;
                    UpdateStep();
                end;
            }
            action(FinishAction)
            {
                ApplicationArea = All;
                Caption = 'Finish';
                Enabled = Step = 4;
                Image = Approve;
                InFooterBar = true;

                trigger OnAction()
                begin
                    CurrPage.SaveRecord();
                    SetupMgt.MarkSetupCompleted(Rec);
                    if Rec."Setup Completed" then
                        Message(SetupCompletedMsgLbl)
                    else
                        Message(Rec."Last Validation Result");

                    CurrPage.Close();
                end;
            }
            action(CancelAction)
            {
                ApplicationArea = All;
                Caption = 'Cancel';
                Image = Cancel;
                InFooterBar = true;

                trigger OnAction()
                begin
                    CurrPage.Close();
                end;
            }
        }
    }

    trigger OnOpenPage()
    begin
        SetupMgt.GetSetup(Rec);
        WelcomeInfo := WelcomeInfoLbl;
        Step := 1;
        RefreshStepState();
    end;

    trigger OnAfterGetCurrRecord()
    begin
        RefreshStepState();
    end;

    var
        SetupMgt: Codeunit "ODPM Incident Agent Setup Mgt.";
        Step: Integer;
        WelcomeInfo: Text;
        ReviewSummary: Text;
        MailboxConfigured: Boolean;
        FlowConfigured: Boolean;
        AIConfigured: Boolean;
        SetupReady: Boolean;
        WelcomeInfoLbl: Label 'Recommended quick path: configure the shared mailbox, add the Power Automate flow URL, decide whether AI will enrich the intake, and finish the validation step.';
        SetupCompletedMsgLbl: Label 'The incident intake agent setup has been completed.';

    local procedure UpdateStep()
    begin
        RefreshStepState();
        CurrPage.Update(false);
    end;

    local procedure RefreshStepState()
    begin
        SetupMgt.GetChecklistState(Rec, MailboxConfigured, FlowConfigured, AIConfigured, SetupReady, ReviewSummary);
    end;
}
