page 96158 "AI Incident Intake Buffers"
{
    ApplicationArea = All;
    Caption = 'AI Incident Intake Buffers';
    CardPageId = "RE Incident Card";
    PageType = List;
    SourceTable = "AI Incident Intake Buffer";
    UsageCategory = Lists;

    layout
    {
        area(Content)
        {
            repeater(General)
            {
                field("Entry No."; Rec."Entry No.") { Editable = false; }
                field("Received At"; Rec."Received At") { }
                field(Status; Rec.Status) { }
                field("From E-Mail"; Rec."From E-Mail") { }
                field("From Name"; Rec."From Name") { }
                field(Subject; Rec.Subject) { }
                field("AI Confidence"; Rec."AI Confidence") { }
                field("Suggested Real Estate No."; Rec."Suggested Real Estate No.") { }
                field("Suggested Contract No."; Rec."Suggested Contract No.") { }
                field("Suggested Title"; Rec."Suggested Title") { }
                field("Has Attachments"; Rec."Has Attachments") { }
                field("Created Incident Id"; Rec."Created Incident Id") { Editable = false; }
            }
            group(Details)
            {
                field("Body Preview"; Rec."Body Preview")
                {
                    MultiLine = true;
                }
                field("AI Summary"; Rec."AI Summary")
                {
                    MultiLine = true;
                }
                field("Suggested Description"; Rec."Suggested Description")
                {
                    MultiLine = true;
                }
                field("Processing Log"; Rec."Processing Log")
                {
                    MultiLine = true;
                }
            }
        }
    }

    actions
    {
        area(Processing)
        {
            action(IncidentAgentSetup)
            {
                AccessByPermission = TableData "ODPM Incident Agent Setup" = R;
                ApplicationArea = All;
                Caption = 'Incident Agent Setup';
                Image = Setup;
                Promoted = true;
                PromotedCategory = Process;
                RunObject = Page "ODPM Incident Agent Setup";
                ToolTip = 'Open the setup page for the Power Automate and AI incident intake agent.';
            }
            action(CreateDraftIncident)
            {
                ApplicationArea = All;
                Caption = 'Create Draft Incident';
                Image = CreateDocument;
                Promoted = true;
                PromotedCategory = Process;

                trigger OnAction()
                var
                    AIIncidentIntakeMgt: Codeunit "AI Incident Intake Mgt.";
                    Incident: Record "Incident Assets Real Estate";
                    IncidentId: Guid;
                begin
                    IncidentId := AIIncidentIntakeMgt.CreateDraftIncidentFromBuffer(Rec);
                    if Incident.Get(IncidentId) then
                        Page.Run(Page::"RE Incident Card", Incident);
                end;
            }
        }
    }
}
