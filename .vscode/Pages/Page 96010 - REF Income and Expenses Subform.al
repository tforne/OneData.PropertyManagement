page 96010 "REF Income & Expenses Subform"
{
    DelayedInsert = false;
    DeleteAllowed = false;
    InsertAllowed = false;
    MultipleNewLines = true;
    PageType = ListPart;
    SourceTable = "REF Income & Expense Lines";
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
                field(Type; rec.Type)
                {
                    OptionCaption = 'Income,Expense,Title';
                    Style = Standard;
                    StyleExpr = Emphasize;
                }
                field(Description; rec.Description)
                {
                    Style = Strong;
                    StyleExpr = Emphasize;
                }
                field(Quantity; rec.Quantity)
                {
                    BlankZero = true;
                }
                field("Entry Category"; rec."Entry Category")
                {
                    Caption = 'Entry Category';
                    Style = Standard;
                    StyleExpr = Emphasize;
                }
                field(Price; rec.Price)
                {
                    BlankZero = true;
                }
                field(Amount; rec.Amount)
                {
                    BlankZero = true;
                }
            }
            group(Group1)
            {
                Caption = 'Total';
                field(NetIncome; NetIncome)
                {
                    AutoFormatType = 1;
                    Caption = 'Net Income';
                    Editable = false;
                }
            }
        }
    }

    actions
    {
        area(processing)
        {
            group("&Line")
            {
                Caption = '&Line';
                Image = Line;
                group("F&unctions")
                {
                    Caption = 'F&unctions';
                    Image = "Action";
                    action("Insert Template")
                    {
                        AccessByPermission = TableData 279 = R;
                        Caption = 'Insert &Ext. Texts';
                        Image = Text;
                        ToolTip = 'Insert the extended item description that is set up for the item that is being processed on the line.';

                        trigger OnAction()
                        var
                            RealEstateMangement: Codeunit "Real Estate Management";
                        begin
                            RealEstateMangement.CopyTemplateToREF(rec."No. Fixed Real Estate");
                        end;
                    }
                }
            }
        }
    }

    trigger OnAfterGetCurrRecord()
    begin
        CalculateNetIncome;
    end;

    var
        TotalREFIncomeExpenseLines: Record "REF Income & Expense Lines";
        Emphasize: Boolean;
        NameIndent: Integer;
        NetIncome: Decimal;

    local procedure CalculateNetIncome()
    begin
        NetIncome := 0;
        TotalREFIncomeExpenseLines.COPYFILTERS(Rec);
        IF TotalREFIncomeExpenseLines.FINDFIRST THEN
            REPEAT
                IF TotalREFIncomeExpenseLines.Type = TotalREFIncomeExpenseLines.Type::Income THEN BEGIN
                    NetIncome := NetIncome + TotalREFIncomeExpenseLines.Amount
                END ELSE
                    NetIncome := NetIncome - TotalREFIncomeExpenseLines.Amount;
            UNTIL TotalREFIncomeExpenseLines.NEXT = 0;
    end;
}

