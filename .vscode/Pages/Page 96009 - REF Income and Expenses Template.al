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
        area(processing)
        {
            action(InsertStandardTemplate)
            {
                ApplicationArea = All;
                Caption = 'Insertar plantilla estandar';
                Image = NewDocument;
                ToolTip = 'Inserta una estructura base de ingresos y gastos para configurar la plantilla estándar.';

                trigger OnAction()
                begin
                    InsertStandardTemplateLines();
                    CurrPage.Update(false);
                end;
            }
        }
    }

    trigger OnAfterGetRecord()
    begin
        Emphasize := (rec.Type = rec.Type::Title);
        NameIndent := rec.Identation;
    end;

    var
        Emphasize: Boolean;
        NameIndent: Integer;
        StandardTemplateAlreadyExistsErr: Label 'La plantilla estándar ya contiene líneas. Elimine las existentes si desea volver a generarla.';

    local procedure InsertStandardTemplateLines()
    var
        TemplateLine: Record "REF Income & Expense Template";
    begin
        TemplateLine.SetRange("No. Template", '');
        if not TemplateLine.IsEmpty() then
            Error(StandardTemplateAlreadyExistsErr);

        InsertTemplateLine(10000, '', Rec.Type::Title, 'Ingresos', 0);
        InsertTemplateLine(20000, '100', Rec.Type::Income, 'Ingresos por alquiler', 1);
        InsertTemplateLine(30000, '200', Rec.Type::Income, 'Otros ingresos', 1);
        InsertTemplateLine(40000, '', Rec.Type::Title, 'Gastos', 0);
        InsertTemplateLine(50000, '300', Rec.Type::Expense, 'Comunidad', 1);
        InsertTemplateLine(60000, '400', Rec.Type::Expense, 'Suministros', 1);
        InsertTemplateLine(70000, '500', Rec.Type::Expense, 'Mantenimiento', 1);
        InsertTemplateLine(80000, '600', Rec.Type::Expense, 'Seguros', 1);
        InsertTemplateLine(90000, '700', Rec.Type::Expense, 'Impuestos', 1);
        InsertTemplateLine(100000, '800', Rec.Type::Expense, 'Otros gastos', 1);
    end;

    local procedure InsertTemplateLine(EntryNo: Integer; RowNo: Code[10]; LineType: Option Income,Expense,Title; Description: Text[50]; Identation: Integer)
    var
        TemplateLine: Record "REF Income & Expense Template";
    begin
        TemplateLine.Init();
        TemplateLine."No. Template" := '';
        TemplateLine."No. Entry" := EntryNo;
        TemplateLine.Type := LineType;
        TemplateLine.Description := Description;
        TemplateLine.Identation := Identation;
        if RowNo <> '' then
            TemplateLine.Validate("Row No.", RowNo);
        TemplateLine.Insert();
    end;
}

