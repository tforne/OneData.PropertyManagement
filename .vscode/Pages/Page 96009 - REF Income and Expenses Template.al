page 96009 "REF Income & Expenses Template"
{
    MultipleNewLines = true;
    PageType = List;
    SourceTable = "REF Income & Expense Template";
    ApplicationArea = All;

    layout
    {
        area(content)
        {
            repeater(Group)
            {
                IndentationColumn = NameIndent;
                IndentationControls = Description;
                field("Row No."; rec."Row No.")
                {
                }
                field(Description; rec.Description)
                {
                    Style = Strong;
                    StyleExpr = Emphasize;
                }
                field(Date; rec.Date)
                {
                }
                field(Identation; rec.Identation)
                {
                }
                field(Type; rec.Type)
                {
                    OptionCaption = 'Income,Expense,Title';
                    Style = Standard;
                    StyleExpr = Emphasize;
                }
                field("Account No."; rec."Account No.")
                {
                    Style = Strong;
                    StyleExpr = Emphasize;
                }
                field("Entry Category";rec."Entry Category")
                {
                    Style = Strong;
                    StyleExpr = Emphasize;
                }
            }
        }
    }

    actions
    {
    }

    trigger OnAfterGetRecord()
    begin
        Emphasize := (rec.Type = rec.Type::Title);
        NameIndent := rec.Identation;
    end;

    var
        Emphasize: Boolean;
        NameIndent: Integer;
}

