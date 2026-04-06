page 96011 "REF Income & Expenses List"
{
    DelayedInsert = false;
    DeleteAllowed = false;
    Editable = false;
    InsertAllowed = false;
    MultipleNewLines = true;
    PageType = List;
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
                field("No. Fixed Real Estate"; rec."No. Fixed Real Estate")
                {
                }
                field("Row No."; rec."Row No.")
                {
                }
                field(Type; rec.Type)
                {
                }
                field(Description; rec.Description)
                {
                    Style = Strong;
                    StyleExpr = Emphasize;
                }
                field("Entry Category";Rec."Entry Category")
                {
                }
                field(Quantity; rec.Quantity)
                {
                }
                field(Price; rec.Price)
                {
                }
                field(Amount; rec.Amount)
                {
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
                        ApplicationArea = Basic, Suite;
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

    var
        Emphasize: Boolean;
        NameIndent: Integer;
}

