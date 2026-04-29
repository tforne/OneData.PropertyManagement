page 96152 "Incidents List"
{
    ApplicationArea = All;
    Caption = 'Incidents List';
    PageType = List;
    SourceTable = "Incident Assets Real Estate";
    SourceTableView = SORTING("Fixed Real Estate No.", "Incident Date") ORDER(Ascending);
    UsageCategory = Lists;
    CardPageId = 96151;
    
    layout
    {
        area(Content)
        {
            repeater(General)
            {
                field("Incident Id."; Rec."Incident Id.")
                {
                    ToolTip = 'Specifies the value of the Case field.', Comment = '%';
                    Visible = true;
                    Editable = false;
                }
                field(Title; Rec.Title)
                {
                    ToolTip = 'Specifies the value of the Case Title field.', Comment = '%';
                }
                field(Description; Rec.Description)
                {
                    ToolTip = 'Specifies the value of the Description field.', Comment = '%';
                }
                field("Fixed Real Estate No."; Rec."Fixed Real Estate No.")
                {
                    ToolTip = 'Specifies the value of the No. field.', Comment = '%';
                }
                field("REF Description";Rec."REF Description")
                {
                    
                }
                field("Contract No."; Rec."Contract No.")
                {
                    ToolTip = 'Specifies the value of the Contract field.', Comment = '%';
                }
                field("Customer No.";Rec."Customer No.")
                {
                    ToolTip = 'Specifies the value of the Customer No. field.', Comment = '%';
                }
                field("Contact No"; Rec."Contact No")
                {
                    ToolTip = 'Specifies the value of the Contact field.', Comment = '%';
                }
                field("Contact Name"; Rec."Contact - Name")
                {
                    ToolTip = 'Specifies the value of the Contact Name field.', Comment = '%';
                }
                field("Contact Phone No."; Rec."Contact Phone No.")
                {
                    ToolTip = 'Specifies the phone number of the contact associated with the incident.', Comment = '%';
                }
                field("Contact E-Mail"; Rec."Contact E-Mail")
                {
                    ToolTip = 'Specifies the email address of the contact associated with the incident.', Comment = '%';
                }
                field("Case Type"; Rec."Case Type")
                {
                    ToolTip = 'Specifies the value of the Case Type field.', Comment = '%';
                }
                field("Incident Date"; Rec."Incident Date")
                {
                    ToolTip = 'Specifies the value of the Incident Date field.', Comment = '%';
                }

                field(StateCode; Rec.StateCode)
                {
                    ToolTip = 'Specifies the value of the Status field.', Comment = '%';
                }
            }
        }
    }
    actions
    {
        area(Creation)
        {
            action(CreateFromCamera)
            {
                Promoted = true;
                PromotedCategory = New;
                Caption = 'Create from Camera';
                Image = Camera;
                ToolTip = 'Create a new incident record by taking a picture.';
                Visible = HasCamera;

                trigger OnAction()
                var
                    InStr: InStream;
                    PictureName: Text;
                begin
                    if Camera.GetPicture(InStr, PictureName) then
                        Rec.CreateIncident(InStr, PictureName);
                end;
            }
            action(CreateFromAttachment)
            {
                Promoted = true;
                PromotedCategory = New;
                Caption = 'Create from File';
                Image = ExportAttachment;
                ToolTip = 'Create a new incident record by first selecting the file it will be based on. The selected file will be attached.';

                trigger OnAction()
                begin
                    Rec.CreateFromAttachment();
                end;
            }
        }
        area(processing)
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
            action(AIIntakeQueue)
            {
                ApplicationArea = All;
                Caption = 'AI Intake Queue';
                Image = List;
                Promoted = true;
                PromotedCategory = Process;
                RunObject = Page "AI Incident Intake Buffers";
                ToolTip = 'Review incoming e-mails analyzed by AI before creating incidents.';
            }
            action(AttachFile)
            {
                ApplicationArea = Basic, Suite;
                Caption = 'Attach File';
                Promoted = true;
                PromotedCategory = Process;
                Image = Attach;
                ToolTip = 'Attach a file to the incident document record.';

                trigger OnAction()
                begin
                    Rec.ImportAttachment(rec);
                end;
            }
        }
    }
    var
        Camera: Codeunit Camera;
        HasCamera: Boolean;

    trigger OnOpenPage()
    begin
        if GuiAllowed then
            HasCamera := Camera.IsAvailable();
    end;

}
