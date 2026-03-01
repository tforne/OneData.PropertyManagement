page 96152 "Incidents List"
{
    ApplicationArea = All;
    Caption = 'Incidents List';
    PageType = List;
    SourceTable = "Incident Assets Real Estate";
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
                    Visible = false;
                }
                field(Title; Rec.Title)
                {
                    ToolTip = 'Specifies the value of the Case Title field.', Comment = '%';
                }
                field(Description; Rec.Description)
                {
                    ToolTip = 'Specifies the value of the Description field.', Comment = '%';
                }
                field("Contract No."; Rec."Contract No.")
                {
                    ToolTip = 'Specifies the value of the Contract field.', Comment = '%';
                }
                field("Contact No"; Rec."Contact No")
                {
                    ToolTip = 'Specifies the value of the Contact field.', Comment = '%';
                }
                field("Case Type"; Rec."Case Type")
                {
                    ToolTip = 'Specifies the value of the Case Type field.', Comment = '%';
                }
                field("Incident Date"; Rec."Incident Date")
                {
                    ToolTip = 'Specifies the value of the Incident Date field.', Comment = '%';
                }
                field("Fixed Real Estate No."; Rec."Fixed Real Estate No.")
                {
                    ToolTip = 'Specifies the value of the No. field.', Comment = '%';
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
                ApplicationArea = All;
                Promoted = true;
                PromotedCategory = New;
                Caption = 'Create from Camera';
                Image = Camera;
                ToolTip = 'Create a new incoming document record by taking a picture.';
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
                ApplicationArea = All;
                Promoted = true;
                PromotedCategory = New;
                Caption = 'Create from File';
                Image = ExportAttachment;
                ToolTip = 'Create a new incoming document record by first selecting the file it will be based on. The selected file will be attached.';

                trigger OnAction()
                begin
                    Rec.CreateFromAttachment();
                end;
            }
        }
        area(processing)
        { 
            action(AttachFile)
            {
                ApplicationArea = Basic, Suite;
                Caption = 'Attach File';
                Image = Attach;
                Scope = Repeater;
                ToolTip = 'Attach a file to the incoming document record.';

                trigger OnAction()
                begin
                    Rec.CreateFromAttachment();
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
