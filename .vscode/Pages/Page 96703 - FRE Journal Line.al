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
                    EXIT(FREJnlManagement.LookupName(rec.GETRANGEMAX("Journal Template Name"), CurrentJnlBatchName, Text));
                end;

                trigger OnValidate()
                begin

                    FREJnlManagement.CheckName(CurrentJnlBatchName, Rec);
                    CurrentJnlBatchNameOnAfterVali;
                end;
            }
            repeater(Group)
            {
                field(Date; rec.Date)
                {
                    ApplicationArea = Basic, Suite;
                    StyleExpr = LineStyleExpression;
                    ToolTip = 'Specifies the date the item entry was posted.';
                }
                field("Document Type"; rec."Document Type")
                {
                }
                field("Document No."; rec."Document No.")
                {
                    ApplicationArea = Basic, Suite;
                    StyleExpr = LineStyleExpression;
                    ToolTip = 'Specifies the document number on the entry.';
                }
                field("Source Type"; rec."Source Type")
                {
                    ApplicationArea = Basic, Suite;
                    ToolTip = 'Specifies the entry type.';
                }
                field("Source No."; rec."Source No.")
                {
                    ApplicationArea = Basic, Suite;
                    ToolTip = 'Specifies the number that the item entry had in the table it came from.';
                }
                field("Source Name";Rec."Source Name")
                {

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
                //     GetGLRegister.RUNMODAL;
                //     CLEAR(GetGLRegister);
                // end;
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
                Image = "Filter";
                Promoted = true;
                PromotedCategory = Process;
                PromotedIsBig = true;
                PromotedOnly = true;
                ToolTip = 'Show or hide FRE journal lines that do not have errors.';

                trigger OnAction()
                begin
                    rec.MARKEDONLY(NOT rec.MARKEDONLY);
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
                        ODataUtility.EditJournalWorksheetInExcel(CurrPage.CAPTION, CurrPage.OBJECTID(FALSE), rec."Journal Batch Name", rec."Journal Template Name");
                    end;
                }
            }
        }
    }

    trigger OnAfterGetCurrRecord()
    begin
        UpdateErrors;
    end;

    trigger OnAfterGetRecord()
    begin
        UpdateErrors;
    end;

    trigger OnInit()
    begin
        StatisticalValueVisible := TRUE;
    end;

    trigger OnOpenPage()
    var
        JnlSelected: Boolean;
    begin

        IF rec.IsOpenedFromBatch THEN BEGIN
            CurrentJnlBatchName := rec."Journal Batch Name";
            FREJnlManagement.OpenJnl(CurrentJnlBatchName, Rec);
            EXIT;
        END;
        FREJnlManagement.TemplateSelection(PAGE::"FRE Journal Line", Rec, JnlSelected);
        IF NOT JnlSelected THEN
            ERROR('');
        FREJnlManagement.OpenJnl(CurrentJnlBatchName, Rec);

        LineStyleExpression := 'Standard';
    end;

    var
        NoLinesLbl: label 'No hay líneas en el diario para generar el modelo. ¿ Quieres que te las sugiramos ?';
        FREJnlLine: Record "FRE Jnl. Line";
        GetGLRegister: Report "IRPF Get IRPF Entries";
        ReportPrint: Codeunit "Test Report-Print";
        FREJnlManagement: Codeunit "Journals Management";
        //ClientTypeManagement: Codeunit "ClientTypeManagement";
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

        CurrPage.SAVERECORD;
        FREJnlManagement.SetName(CurrentJnlBatchName, Rec);
        CurrPage.UPDATE(FALSE);
    end;

    local procedure ErrorsExistOnCurrentBatch(ShowError: Boolean): Boolean
    var
        ErrorMessage: Record "Error Message";
        FREJnlBatch: Record "FRE Jnl. Batch";
    begin
        FREJnlBatch.GET(rec."Journal Template Name", rec."Journal Batch Name");
        ErrorMessage.SetContext(FREJnlBatch);
        EXIT(ErrorMessage.HasErrors(ShowError));
    end;

    local procedure ErrorsExistOnCurrentLine(): Boolean
    var
        ErrorMessage: Record "Error Message";
        FREJnlBatch: Record "FRE Jnl. Batch";
    begin
        FREJnlBatch.GET(rec."Journal Template Name", rec."Journal Batch Name");
        ErrorMessage.SetContext(FREJnlBatch);
        EXIT(ErrorMessage.HasErrorMessagesRelatedTo(Rec));
    end;

    local procedure UpdateErrors()
    begin
        CurrPage.ErrorMessagesPart.PAGE.SetRecordID(rec.RECORDID);
        CurrPage.ErrorMessagesPart.PAGE.GetStyleOfRecord(Rec, LineStyleExpression);
        rec.MARK(ErrorsExistOnCurrentLine);
    end;
    local procedure ExistJournalLines() ExisLine : Boolean
    var
        FREJnlLine: Record "FRE Jnl. Line";    
    begin
        FREJnlLine.Reset();
        FREJnlLine.SetRange("Journal Template Name", rec.GETRANGEMAX("Journal Template Name"));
        FREJnlLine.SetRange("Journal Batch Name", CurrentJnlBatchName);
        ExisLine := FREJnlLine.FindFirst();
    end;
}

