page 96751 "FRE Bank Statement Card"
{
    PageType = Card;
    SourceTable = "FRE Bank Statement";
    ApplicationArea = All;
    Caption = 'Bank Statement Card';

    layout
    {
        area(content)
        {
            group(General)
            {
                Caption = 'General';

                field("No."; Rec."No.")
                {
                    Editable = false;
                }
                field(Company; Rec.Company)
                {
                }
                field(Year; Rec.Year)
                {
                }
                field(Month; Rec.Month)
                {
                }
                field(Status; Rec.Status)
                {
                    Editable = false;
                }
                field(Imported; Rec.Imported)
                {
                    Editable = false;
                }
                field(Posted; Rec.Posted)
                {
                    Editable = false;
                }
            }

            group(Banking)
            {
                Caption = 'Banking';

                field("Bank Account No."; Rec."Bank Account No.")
                {
                }
                field(Counterparty; Rec."Bal. Account No.")
                {
                }
                field("Target Journal"; Rec."Target Journal")
                {
                }
                field("SharePoint URL"; Rec."SharePoint URL")
                {
                    MultiLine = true;
                }
            }

            group("Journal Defaults")
            {
                Caption = 'Journal Defaults';

                field("Default Gen. Journal Template"; Rec."Default Gen. Journal Template")
                {
                }
                field("Default Gen. Journal Batch"; Rec."Default Gen. Journal Batch")
                {
                }
                field("Default FRE Journal Template"; Rec."Default FRE Journal Template")
                {
                }
                field("Default FRE Journal Batch"; Rec."Default FRE Journal Batch")
                {
                }
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
                    Rec.TestField("SharePoint URL");
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
                    GenImport: Codeunit "Gen Journal Import Mgt.";
                    FREJnlLine: Record "FRE Jnl. Line";
                    GenJnlLine: Record "Gen. Journal Line";
                    FREExcelTemplateSetup : record "FRE Excel Template Setup";

                begin
                    FREExcelTemplateSetup.get('SETUP');
                    if rec."Target Journal" = rec."Target Journal"::"FRE Journal" then begin
                        FREExcelTemplateSetup.TestField("Default FRE Journal Template");
                        FREExcelTemplateSetup.TestField("Default FRE Journal Batch");
                        FREJnlLine.reset;
                        FREJnlLine.SetRange("Journal Template Name", FREExcelTemplateSetup."Default FRE Journal Template");
                        FREJnlLine.SetRange("Journal Batch Name", FREExcelTemplateSetup."Default FRE Journal Batch");
                        FREImport.BankStatementImportFromExcel(FREJnlLine, Rec);
                        Rec.Imported := true;
                        Rec.Status := Rec.Status::Imported;
                        Rec.Modify();
                    end;
                    if rec."Target Journal" = rec."Target Journal"::"Gen Journal" then begin
                        FREExcelTemplateSetup.TestField("Default Gen. Journal Template");
                        FREExcelTemplateSetup.TestField("Default Gen. Journal Batch");
                        GenJnlLine.reset;
                        GenJnlLine.SetRange("Journal Template Name", FREExcelTemplateSetup."Default Gen. Journal Template");
                        GenJnlLine.SetRange("Journal Batch Name", FREExcelTemplateSetup."Default Gen. Journal Batch");
                        GenImport.BankStatementImportFromExcel(GenJnlLine, Rec);
                        Rec.Imported := true;
                        Rec.Status := Rec.Status::Imported;
                        Rec.Modify();
                    end;

                end;
            }
            action(ImportExcelDirect)
            {
                Caption = 'Importar sin vista previa';
                Image = Import;

                trigger OnAction()
                var
                    FREImport: Codeunit "FRE Import Jnl. Lines";
                    GenImport: Codeunit "Gen Journal Import Mgt.";
                    FREJnlLine: Record "FRE Jnl. Line";
                    GenJnlLine: Record "Gen. Journal Line";
                    FREExcelTemplateSetup: Record "FRE Excel Template Setup";
                begin
                    FREExcelTemplateSetup.Get('SETUP');
                    if Rec."Target Journal" = Rec."Target Journal"::"FRE Journal" then begin
                        FREExcelTemplateSetup.TestField("Default FRE Journal Template");
                        FREExcelTemplateSetup.TestField("Default FRE Journal Batch");
                        FREJnlLine.Reset();
                        FREJnlLine.SetRange("Journal Template Name", FREExcelTemplateSetup."Default FRE Journal Template");
                        FREJnlLine.SetRange("Journal Batch Name", FREExcelTemplateSetup."Default FRE Journal Batch");
                        FREImport.BankStatementImportFromExcelDirect(FREJnlLine, Rec);
                    end;

                    if Rec."Target Journal" = Rec."Target Journal"::"Gen Journal" then begin
                        FREExcelTemplateSetup.TestField("Default Gen. Journal Template");
                        FREExcelTemplateSetup.TestField("Default Gen. Journal Batch");
                        GenJnlLine.Reset();
                        GenJnlLine.SetRange("Journal Template Name", FREExcelTemplateSetup."Default Gen. Journal Template");
                        GenJnlLine.SetRange("Journal Batch Name", FREExcelTemplateSetup."Default Gen. Journal Batch");
                        GenImport.BankStatementImportFromExcelDirect(GenJnlLine, Rec);
                    end;
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
