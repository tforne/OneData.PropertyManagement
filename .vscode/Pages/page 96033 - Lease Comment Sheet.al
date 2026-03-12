page 96033 "Lease Comment Sheet"
{
    AutoSplitKey = true;
    Caption = 'Lease Comment Sheet';
    LinksAllowed = false;
    PageType = List;
    SourceTable = "Lease Comment Line";

    layout
    {
        area(content)
        {
            repeater(Group)
            {
                field(Date; rec.Date)
                {
                    ApplicationArea = all;
                    ToolTip = 'Specifies the date you entered the service comment.';
                }
                field(Comment; rec.Comment)
                {
                    ApplicationArea = Comments;
                    ToolTip = 'Specifies the service comment.';
                }
            }
        }
    }

    actions
    {
    }

    trigger OnAfterGetCurrRecord()
    begin
        CurrPage.CAPTION := COPYSTR(Caption , 1, 80);
    end;

    trigger OnNewRecord(BelowxRec: Boolean)
    begin
        rec.SetUpNewLine;
    end;

    trigger OnOpenPage()
    begin
        
    end;


    local procedure Caption(): Text[100]
    var
    begin
    end;
}

