page 96154 "O365 Incident Att. Pict."
{
    Caption = 'Attachment Picture';
    DataCaptionExpression = Rec.Name;
    Editable = false;
    PageType = Card;
    SourceTable = "Incident Attachment";
    SourceTableView = where(Type = const(Image));
      Permissions = 
        tabledata "Incident Attachment" = RD;
        
    layout
    {
        area(content)
        {
            field(AttachmentContent; Rec.Content)
            {
                ApplicationArea = Invoicing, Basic, Suite;
                ShowCaption = false;
                ToolTip = 'Specifies the content of the attachment. ';
            }
        }
    }

    actions
    {
        area(processing)
        {
            action(DeleteLine)
            {
                ApplicationArea = Invoicing, Basic, Suite;
                Caption = 'Remove attachment';
                Image = Delete;

                trigger OnAction()
                begin
                    if not Confirm(DeleteQst, true) then
                        exit;
                    Rec.Delete();
                    CurrPage.Close();
                end;
            }
        }
        area(Promoted)
        {
            group(Category_Report)
            {
                Caption = 'Report', Comment = 'Generated from the PromotedActionCategories property index 2.';
            }
            group(Category_Category4)
            {
                Caption = 'Manage', Comment = 'Generated from the PromotedActionCategories property index 3.';

                actionref(DeleteLine_Promoted; DeleteLine)
                {
                }
            }
        }
    }

    trigger OnAfterGetRecord()
    begin
        if not IncidentAttachment.Get(Rec."Incident Id.", Rec."Line No.") then
            IncidentAttachment.Init();
        IncidentAttachment.CalcFields(Content);
        Rec.SetRecFilter();
    end;

    var
        IncidentAttachment: Record "Incident Attachment";
        DeleteQst: Label 'Are you sure?';
}