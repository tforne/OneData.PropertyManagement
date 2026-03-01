page 96009 "REF Income & Expenses Template"
{
    MultipleNewLines = true;
    PageType = List;
    SourceTable = "REF Income & Expense Template";

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
                    ApplicationArea = All;
                }
                field(Description; rec.Description)
                {
                    ApplicationArea = All;
                    Style = Strong;
                    StyleExpr = Emphasize;
                }
                field(Date; rec.Date)
                {
                    ApplicationArea = All;
                }
                field(Identation; rec.Identation)
                {
                    ApplicationArea = All;
                }
                field(Type; rec.Type)
                {
                    ApplicationArea = All;
                    OptionCaption = 'Income,Expense,Title';
                    Style = Standard;
                    StyleExpr = Emphasize;
                }
                field("Account No."; rec."Account No.")
                {
                    ApplicationArea = All;
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

