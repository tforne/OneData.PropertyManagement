page 96750 "FRE Bank Statements"
{
    PageType = List;
    SourceTable = "FRE Bank Statement";
    ApplicationArea = All;
    UsageCategory = Lists;
    Caption = 'Bank Statements';

    layout
    {
        area(content)
        {
            repeater(Group)
            {
                field(Company; Rec.Company) {}
                field(Year; Rec.Year) {}
                field(Month; Rec.Month) {}
                field(Status; Rec.Status) {}
                field("SharePoint URL"; Rec."SharePoint URL") {}
            }
        }
    }

    actions
    {
        area(processing)
        {
            action(OpenDocument)
            {
                Caption = 'Abrir en SharePoint';
                Image = Link;

                trigger OnAction()
                begin
                    Hyperlink(Rec."SharePoint URL");
                end;
            }

            action(ImportExcel)
            {
                Caption = 'Importar Excel';
                Image = ImportExcel;

                trigger OnAction()
                var
                    FREImport: Codeunit "FRE Import Jnl. Lines";
                    JnlLine: Record "FRE Jnl. Line";
                begin
                    FREImport.ImportFromExcel(JnlLine);
                    Rec.Imported := true;
                    Rec.Status := Rec.Status::Imported;
                    Rec.Modify();
                end;
            }

            action(Post)
            {
                Caption = 'Registrar';
                Image = Post;

                trigger OnAction()
                begin
                    // Aquí conectarás con tu posting FRE
                    Rec.Posted := true;
                    Rec.Status := Rec.Status::Posted;
                    Rec.Modify();
                end;
            }
        }
    }
}