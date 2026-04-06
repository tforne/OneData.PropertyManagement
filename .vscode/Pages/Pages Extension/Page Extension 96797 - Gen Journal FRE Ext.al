pageextension 96797 "Gen Journal FRE Ext" extends "General Journal"
{
    layout
    {
        addlast(Control1)
        {

                field("FRE Integration"; Rec."FRE Integration") 
                { 
                    ApplicationArea = All;
                }
                field("FRE Real Estate No."; Rec."FRE Real Estate No.")
                { 
                    ApplicationArea = All;
                }
                field("FRE Entry Category"; Rec."FRE Entry Category")
                { 
                    ApplicationArea = All;
                }
                field("FRE Row No."; Rec."FRE Row No.")
                { 
                    ApplicationArea = All;
                }
                field("FRE Source Type"; Rec."FRE Source Type") 
                { 
                    ApplicationArea = All;
                }
                field("FRE Source No."; Rec."FRE Source No.")
                { 
                    ApplicationArea = All;
                }
                field("FRE FA No."; Rec."FRE FA No.") 
                { 
                    ApplicationArea = All;
                }
        }
    }
    actions
    {
        addlast(Processing)
        {
            group(ImportToExcel)
            {
                Caption = 'Import to Excel';
                action(DownloadTemplate)
                {
                    ApplicationArea = Basic, Suite;
                    Caption = 'Download Template';
                    Image = Excel;
                    Promoted = true;
                    PromotedCategory = Process;
                    PromotedIsBig = true;
                    PromotedOnly = true;
                    ToolTip = 'Download the Excel template to import FRE journal lines.';

                    trigger OnAction()
                    var
                        FREImportJnlLines: Codeunit "FRE Import Jnl. Lines";
                    begin
                        FREImportJnlLines.DownloadTemplate();
                    end;
                }

                action(ImportFromExcel)
                {
                    ApplicationArea = Basic, Suite;
                    Caption = 'Import from Excel';
                    Image = ImportExcel;
                    Promoted = true;
                    PromotedCategory = Process;
                    PromotedIsBig = true;
                    PromotedOnly = true;
                    ToolTip = 'Import journal lines from an Excel file into the current FRE journal batch.';

                    trigger OnAction()
                    var
                        ImportGenJnlLines: Codeunit "Gen Journal Import Mgt.";
                    begin
                        ImportGenJnlLines.ImportFromExcel();
                        CurrPage.Update(false);
                    end;
                }

                action(ImportFREBankStatement)
                {
                    ApplicationArea = Basic, Suite;
                    Caption = 'Importar extracto bancario';
                    Image = ImportExcel;
                    Promoted = true;
                    PromotedCategory = Process;
                    PromotedIsBig = true;

                    trigger OnAction()
                    var
                        FREImportJnlLines: Codeunit "FRE Import Jnl. Lines";
                        FREBankStatement: Record "FRE Bank Statement";
                    begin
                        // Aquí puedes pedir selección de extracto
                        if Page.RunModal(Page::"FRE Bank Statements", FREBankStatement) = Action::LookupOK then begin
                            // FREImportJnlLines.ImportBankStatementFromStatement(Rec, FREBankStatement);
                            CurrPage.Update(false);
                        end;
                    end;
                }
            }
        }
    }
}