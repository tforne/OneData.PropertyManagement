page 96160 "ODPM Incid. Agent Setup Wizard"
{
    ApplicationArea = All;
    Caption = WizardCaptionLbl;
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
                Caption = WelcomeStepCaptionLbl;
                Visible = Step = 1;
                group(WelcomeContent)
                {
                    InstructionalText = WelcomeInstructionLbl;
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
                Caption = PowerAutomateStepCaptionLbl;
                Visible = Step = 2;
                group(PowerAutomateContent)
                {
                    field("Shared Mailbox"; Rec."Shared Mailbox")
                    {
                        ToolTip = SharedMailboxToolTipLbl;
                    }
                    field("Incoming Mail Folder"; Rec."Incoming Mail Folder")
                    {
                        ToolTip = IncomingMailFolderToolTipLbl;
                    }
                    field("Power Automate Flow Name"; Rec."Power Automate Flow Name")
                    {
                        ToolTip = PowerAutomateFlowNameToolTipLbl;
                    }
                    field("Power Automate Flow URL"; Rec."Power Automate Flow URL")
                    {
                        ExtendedDatatype = URL;
                        ToolTip = PowerAutomateFlowUrlToolTipLbl;
                    }
                }
            }
            group(AIStep)
            {
                Caption = AIStepCaptionLbl;
                Visible = Step = 3;
                group(AIContent)
                {
                    field("Use AI"; Rec."Use AI")
                    {
                        ToolTip = UseAIToolTipLbl;
                    }
                    field("AI Provider"; Rec."AI Provider")
                    {
                        ToolTip = AIProviderToolTipLbl;
                    }
                    field("Auto Create Drafts"; Rec."Auto Create Drafts")
                    {
                        ToolTip = AutoCreateDraftsToolTipLbl;
                    }
                    field("Confidence Threshold"; Rec."Confidence Threshold")
                    {
                        ToolTip = ConfidenceThresholdToolTipLbl;
                    }
                }
            }
            group(ReviewStep)
            {
                Caption = ReviewStepCaptionLbl;
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
                        Caption = MailboxConfiguredCaptionLbl;
                        Editable = false;
                    }
                    field(FlowConfigured; FlowConfigured)
                    {
                        ApplicationArea = All;
                        Caption = FlowConfiguredCaptionLbl;
                        Editable = false;
                    }
                    field(AIConfigured; AIConfigured)
                    {
                        ApplicationArea = All;
                        Caption = AIConfiguredCaptionLbl;
                        Editable = false;
                    }
                    field(SetupReady; SetupReady)
                    {
                        ApplicationArea = All;
                        Caption = SetupReadyCaptionLbl;
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
                Caption = BackActionCaptionLbl;
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
                Caption = NextActionCaptionLbl;
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
                Caption = FinishActionCaptionLbl;
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
                Caption = CancelActionCaptionLbl;
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
        WizardCaptionLbl: Label 'Incident Intake Agent Setup Wizard';
        WelcomeStepCaptionLbl: Label 'Welcome';
        WelcomeInstructionLbl: Label 'This wizard helps you configure the shared mailbox and Power Automate flow required to intake incidents from e-mail.';
        WelcomeInfoLbl: Label 'Recommended quick path: configure the shared mailbox, add the Power Automate flow URL, decide whether AI will enrich the intake, and finish the validation step.';
        PowerAutomateStepCaptionLbl: Label 'Power Automate';
        SharedMailboxToolTipLbl: Label 'Specifies the mailbox to monitor for incident e-mails.';
        IncomingMailFolderToolTipLbl: Label 'Specifies the folder to monitor in the shared mailbox.';
        PowerAutomateFlowNameToolTipLbl: Label 'Specifies the flow name shown to users.';
        PowerAutomateFlowUrlToolTipLbl: Label 'Specifies the endpoint or flow URL used to receive incident intake data.';
        AIStepCaptionLbl: Label 'AI';
        UseAIToolTipLbl: Label 'Specifies whether the flow should request AI suggestions before creating draft incidents.';
        AIProviderToolTipLbl: Label 'Specifies the planned AI provider.';
        AutoCreateDraftsToolTipLbl: Label 'Specifies whether draft incidents can be created automatically.';
        ConfidenceThresholdToolTipLbl: Label 'Specifies the confidence threshold expected for automation.';
        ReviewStepCaptionLbl: Label 'Review';
        MailboxConfiguredCaptionLbl: Label 'Shared Mailbox Configured';
        FlowConfiguredCaptionLbl: Label 'Power Automate Flow Configured';
        AIConfiguredCaptionLbl: Label 'AI Threshold Ready';
        SetupReadyCaptionLbl: Label 'Setup Ready';
        BackActionCaptionLbl: Label 'Back';
        NextActionCaptionLbl: Label 'Next';
        FinishActionCaptionLbl: Label 'Finish';
        CancelActionCaptionLbl: Label 'Cancel';
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
