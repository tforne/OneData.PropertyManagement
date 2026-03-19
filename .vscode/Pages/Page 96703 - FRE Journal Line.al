page 96703 "FRE Journal Line"
{
    ApplicationArea = Basic, Suite;
    AutoSplitKey = true;
    Caption = 'FRE Journals';
    DataCaptionFields = "Journal Batch Name";
    PageType = Worksheet;
    PromotedActionCategories = 'New,Process,Report,Bank,Application,Payroll,Approve,Page';
    SaveValues = true;
    SourceTable = "FRE Jnl. Line";
    UsageCategory = Tasks;
    Editable = true;

    layout
    {
        area(content)
        {
            field(CurrentJnlBatchName; CurrentJnlBatchName)
            {
                ApplicationArea = Basic, Suite;
                Caption = 'Batch Name';
                Lookup = true;
                ToolTip = 'Specifies the name of the journal batch.';

                trigger OnLookup(var Text: Text): Boolean
                begin
                    exit(FREJnlManagement.LookupName(Rec.GetRangeMax("Journal Template Name"), CurrentJnlBatchName, Text));
                end;

                trigger OnValidate()
                begin
                    FREJnlManagement.CheckName(CurrentJnlBatchName, Rec);
                    CurrentJnlBatchNameOnAfterVali();
                end;
            }

            repeater(Group)
            {
                field(Date; Rec.Date)
                {
                    ApplicationArea = Basic, Suite;
                    StyleExpr = LineStyleExpression;
                    ToolTip = 'Specifies the date the item entry was posted.';
                }

                field("Document Type"; Rec."Document Type")
                {
                    ApplicationArea = Basic, Suite;
                }

                field("Document No."; Rec."Document No.")
                {
                    ApplicationArea = Basic, Suite;
                    StyleExpr = LineStyleExpression;
                    ToolTip = 'Specifies the document number on the entry.';
                }

                field("Line Type"; Rec."Line Type")
                {
                    ApplicationArea = Basic, Suite;
                    StyleExpr = LineStyleExpression;
                    ToolTip = 'Specifies the type of the item entry.';
                }

                field("Row No."; Rec."Row No.")
                {
                    ApplicationArea = Basic, Suite;
                    StyleExpr = LineStyleExpression;
                    ToolTip = 'Specifies the row number.';
                }

                field("Description Row No."; Rec."Description Row No.")
                {
                    ApplicationArea = Basic, Suite;
                    StyleExpr = LineStyleExpression;
                    ToolTip = 'Specifies the description row number.';
                }

                field("Source Type"; Rec."Source Type")
                {
                    ApplicationArea = Basic, Suite;
                    ToolTip = 'Specifies the entry type.';
                }

                field("Source No."; Rec."Source No.")
                {
                    ApplicationArea = Basic, Suite;
                    ToolTip = 'Specifies the number that the item entry had in the table it came from.';
                }

                field("Source Name"; Rec."Source Name")
                {
                    ApplicationArea = Basic, Suite;
                    ToolTip = 'Specifies the name related to the source number.';
                }

                field(Amount; Rec.Amount)
                {
                    ApplicationArea = Basic, Suite;
                    StyleExpr = LineStyleExpression;
                    ToolTip = 'Specifies the amount of the entry.';
                }

                field("Amount Including VAT"; Rec."Amount Including VAT")
                {
                    ApplicationArea = Basic, Suite;
                    StyleExpr = LineStyleExpression;
                    ToolTip = 'Specifies the amount including VAT of the entry.';
                }
            }
        }

        area(factboxes)
        {
            part(ErrorMessagesPart; 701)
            {
                ApplicationArea = Basic, Suite;
            }

            systempart(Control1900383207; Links)
            {
                Visible = false;
            }

            systempart(Control1900383208; Notes)
            {
                Visible = false;
            }
        }
    }

    actions
    {
        area(navigation)
        {
        }

        area(processing)
        {
            action(GetEntries)
            {
                ApplicationArea = Basic, Suite;
                Caption = 'Suggest Lines';
                Ellipsis = true;
                Image = SuggestLines;
                Promoted = true;
                PromotedCategory = Process;
                PromotedIsBig = true;
                PromotedOnly = true;
                ToolTip = 'Suggests FRE Ledger Entries transactions to be reported and fills in FRE journal.';

                // trigger OnAction()
                // begin
                //     GetGLRegister.SetIRPFJnlLine(Rec);
                //     GetGLRegister.RunModal();
                //     Clear(GetGLRegister);
                // end;
            }

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
                    FREImportJnlLines: Codeunit "FRE Import Jnl. Lines";
                begin
                    FREImportJnlLines.ImportFromExcel(Rec);
                    CurrPage.Update(false);
                end;
            }

            action(ChecklistReport)
            {
                ApplicationArea = Basic, Suite;
                Caption = 'Checklist Report';
                Image = PrintChecklistReport;
                Promoted = true;
                PromotedCategory = Process;
                PromotedIsBig = true;
                PromotedOnly = true;
                ToolTip = 'Validate the FRE journal lines.';

                trigger OnAction()
                var
                    VATReportsConfiguration: Record "VAT Reports Configuration";
                begin
                    /*
                    VATReportsConfiguration.SETRANGE("VAT Report Type",VATReportsConfiguration."VAT Report Type"::"Intrastat Report");
                    IF VATReportsConfiguration.FINDFIRST AND (VATReportsConfiguration."Validate Codeunit ID" <> 0) THEN BEGIN
                      CODEUNIT.RUN(VATReportsConfiguration."Validate Codeunit ID",Rec);
                      EXIT;
                    END;

                    ReportPrint.PrintIntrastatJnlLine(Rec);
                    */
                end;
            }

            action("Toggle Error Filter")
            {
                ApplicationArea = Basic, Suite;
                Caption = 'Filter Error Lines';
                Image = Filter;
                Promoted = true;
                PromotedCategory = Process;
                PromotedIsBig = true;
                PromotedOnly = true;
                ToolTip = 'Show or hide FRE journal lines that do not have errors.';

                trigger OnAction()
                begin
                    Rec.MarkedOnly(not Rec.MarkedOnly);
                end;
            }

            group(Page)
            {
                Caption = 'Page';

                action(EditInExcel)
                {
                    ApplicationArea = Basic, Suite;
                    Caption = 'Edit in Excel';
                    Image = Excel;
                    Promoted = true;
                    PromotedCategory = Category8;
                    PromotedIsBig = true;
                    PromotedOnly = true;
                    ToolTip = 'Send the data in the journal to an Excel file for analysis or editing.';
                    Visible = IsSaasExcelAddinEnabled;

                    trigger OnAction()
                    var
                        ODataUtility: Codeunit ODataUtility;
                    begin
                        ODataUtility.EditJournalWorksheetInExcel(
                          CurrPage.Caption,
                          CurrPage.ObjectId(false),
                          Rec."Journal Batch Name",
                          Rec."Journal Template Name");
                    end;
                }
            }
        }
    }

    trigger OnAfterGetCurrRecord()
    begin
        UpdateErrors();
    end;

    trigger OnAfterGetRecord()
    begin
        UpdateErrors();
    end;

    trigger OnInit()
    begin
        StatisticalValueVisible := true;
    end;

    trigger OnOpenPage()
    var
        JnlSelected: Boolean;
    begin
        if Rec.IsOpenedFromBatch then begin
            CurrentJnlBatchName := Rec."Journal Batch Name";
            FREJnlManagement.OpenJnl(CurrentJnlBatchName, Rec);
            exit;
        end;

        FREJnlManagement.TemplateSelection(Page::"FRE Journal Line", Rec, JnlSelected);
        if not JnlSelected then
            Error('');

        FREJnlManagement.OpenJnl(CurrentJnlBatchName, Rec);
        LineStyleExpression := 'Standard';
    end;

    var
        NoLinesLbl: Label 'No hay líneas en el diario para generar el modelo. ¿ Quieres que te las sugiramos ?';
        FREJnlLine: Record "FRE Jnl. Line";
        GetGLRegister: Report "IRPF Get IRPF Entries";
        ReportPrint: Codeunit "Test Report-Print";
        FREJnlManagement: Codeunit "FRE Journals Management";
        LineStyleExpression: Text;
        StatisticalValue: Decimal;
        TotalStatisticalValue: Decimal;
        CurrentJnlBatchName: Code[10];
        ShowStatisticalValue: Boolean;
        ShowTotalStatisticalValue: Boolean;
        StatisticalValueVisible: Boolean;
        IsSaasExcelAddinEnabled: Boolean;

    local procedure CurrentJnlBatchNameOnAfterVali()
    begin
        CurrPage.SaveRecord();
        FREJnlManagement.SetName(CurrentJnlBatchName, Rec);
        CurrPage.Update(false);
    end;

    local procedure ErrorsExistOnCurrentBatch(ShowError: Boolean): Boolean
    var
        ErrorMessage: Record "Error Message";
        FREJnlBatch: Record "FRE Jnl. Batch";
    begin
        FREJnlBatch.Get(Rec."Journal Template Name", Rec."Journal Batch Name");
        ErrorMessage.SetContext(FREJnlBatch);
        exit(ErrorMessage.HasErrors(ShowError));
    end;

    local procedure ErrorsExistOnCurrentLine(): Boolean
    var
        ErrorMessage: Record "Error Message";
        FREJnlBatch: Record "FRE Jnl. Batch";
    begin
        FREJnlBatch.Get(Rec."Journal Template Name", Rec."Journal Batch Name");
        ErrorMessage.SetContext(FREJnlBatch);
        exit(ErrorMessage.HasErrorMessagesRelatedTo(Rec));
    end;

    local procedure UpdateErrors()
    begin
        CurrPage.ErrorMessagesPart.Page.SetRecordId(Rec.RecordId);
        CurrPage.ErrorMessagesPart.Page.GetStyleOfRecord(Rec, LineStyleExpression);
        Rec.Mark(ErrorsExistOnCurrentLine());
    end;

    local procedure ExistJournalLines() ExisLine: Boolean
    var
        FREJnlLine2: Record "FRE Jnl. Line";
    begin
        FREJnlLine2.Reset();
        FREJnlLine2.SetRange("Journal Template Name", Rec.GetRangeMax("Journal Template Name"));
        FREJnlLine2.SetRange("Journal Batch Name", CurrentJnlBatchName);
        ExisLine := FREJnlLine2.FindFirst();
    end;
}
