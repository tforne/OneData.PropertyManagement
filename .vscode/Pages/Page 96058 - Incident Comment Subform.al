page 96058 "Incident Comment Subform"
{
    AutoSplitKey = true;
    Caption = 'Incident Comment Subform';
    DataCaptionFields = "Incident Id.";
    DelayedInsert = true;
    LinksAllowed = false;
    MultipleNewLines = true;
    PageType = ListPart;
    SourceTable = "Incident Comment Line";
    ApplicationArea = All;

    layout
    {
        area(content)
        {
            repeater(Group)
            {
                field(Date; rec.Date)
                {
                    ApplicationArea = Comments;
                    ToolTip = 'Specifies the date the comment was created.';
                }
                field(Comment; rec.Comment)
                {
                    ApplicationArea = Comments;
                    ToolTip = 'Specifies the comment itself.';
                }
                field("Comentario del sistema"; Rec."Comentario del sistema")
                {
                    ApplicationArea = Comments;
                    ToolTip = 'Indica si el comentario ha sido generado por el sistema.';
                }
            }
        }
    }

    actions
    {
    }

    trigger OnNewRecord(BelowxRec: Boolean)
    begin
        rec.SetUpNewLine;
    end;
}

