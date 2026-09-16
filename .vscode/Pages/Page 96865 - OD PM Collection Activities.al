page 96865 "OD PM Collection Activities"
{
    Caption = 'Cobros';
    PageType = CardPart;
    SourceTable = "OD PM Collection Cue";
    SourceTableTemporary = true;
    ApplicationArea = All;
    RefreshOnActivate = true;

    layout
    {
        area(content)
        {
            cuegroup(Collections)
            {
                Caption = 'Cobros';
                CueGroupLayout = Wide;

                field(OpenReceivables; Rec."Open Receivables (LCY)")
                {
                    Caption = 'Pendiente de cobro';

                    trigger OnDrillDown()
                    var
                        CustLedgerEntry: Record "Cust. Ledger Entry";
                    begin
                        CustLedgerEntry.SetRange(Open, true);
                        Page.Run(Page::"Customer Ledger Entries", CustLedgerEntry);
                    end;
                }
                field(OverdueReceivables; Rec."Overdue Receivables (LCY)")
                {
                    Caption = 'Cobros vencidos';

                    trigger OnDrillDown()
                    var
                        CustLedgerEntry: Record "Cust. Ledger Entry";
                    begin
                        CustLedgerEntry.SetRange(Open, true);
                        CustLedgerEntry.SetFilter("Due Date", '..%1', CalcDate('<-1D>', WorkDate()));
                        Page.Run(Page::"Customer Ledger Entries", CustLedgerEntry);
                    end;
                }
                field(DueNext7Days; Rec."Due Next 7 Days (LCY)")
                {
                    Caption = 'Próximos 7 días';

                    trigger OnDrillDown()
                    var
                        CustLedgerEntry: Record "Cust. Ledger Entry";
                    begin
                        CustLedgerEntry.SetRange(Open, true);
                        CustLedgerEntry.SetRange("Due Date", WorkDate(), CalcDate('<+7D>', WorkDate()));
                        Page.Run(Page::"Customer Ledger Entries", CustLedgerEntry);
                    end;
                }
                field(DueNext30Days; Rec."Due Next 30 Days (LCY)")
                {
                    Caption = 'Próximos 30 días';

                    trigger OnDrillDown()
                    var
                        CustLedgerEntry: Record "Cust. Ledger Entry";
                    begin
                        CustLedgerEntry.SetRange(Open, true);
                        CustLedgerEntry.SetRange("Due Date", WorkDate(), CalcDate('<+30D>', WorkDate()));
                        Page.Run(Page::"Customer Ledger Entries", CustLedgerEntry);
                    end;
                }
                field(ReceivablesCarteraDocuments; Rec."Receivables Cartera Documents")
                {
                    Caption = 'Documentos en cartera';

                    trigger OnDrillDown()
                    var
                        CarteraDoc: Record "Cartera Doc.";
                    begin
                        CarteraDoc.SetRange(Type, CarteraDoc.Type::Receivable);
                        Page.Run(Page::"Receivables Cartera Docs", CarteraDoc);
                    end;
                }
                field(RejectedCarteraDocuments; Rec."Rejected Cartera Documents")
                {
                    Caption = 'Impagados / devueltos';

                    trigger OnDrillDown()
                    var
                        PostedCarteraDoc: Record "Posted Cartera Doc.";
                    begin
                        PostedCarteraDoc.SetRange(Type, PostedCarteraDoc.Type::Receivable);
                        PostedCarteraDoc.SetRange(Status, PostedCarteraDoc.Status::Rejected);
                        Page.Run(Page::"Posted Cartera Documents", PostedCarteraDoc);
                    end;
                }
                field(OpenBillGroups; Rec."Open Bill Groups")
                {
                    Caption = 'Grupos / remesas';
                    Style = Ambiguous;

                    trigger OnDrillDown()
                    begin
                        Page.Run(Page::"Bill Groups");
                    end;
                }
            }
        }
    }

    trigger OnOpenPage()
    begin
        EnsureCue();
        UpdateCueAmounts();
    end;

    trigger OnAfterGetRecord()
    begin
        UpdateCueAmounts();
    end;

    local procedure EnsureCue()
    begin
        if Rec.Get('DEFAULT') then
            exit;

        Rec.Init();
        Rec."Primary Key" := 'DEFAULT';
        Rec.Insert();
    end;

    local procedure UpdateCueAmounts()
    begin
        Rec."Open Receivables (LCY)" := GetOpenReceivableAmount(0D, 0D, false);
        Rec."Overdue Receivables (LCY)" := GetOpenReceivableAmount(0D, CalcDate('<-1D>', WorkDate()), true);
        Rec."Due Next 7 Days (LCY)" := GetOpenReceivableAmount(WorkDate(), CalcDate('<+7D>', WorkDate()), true);
        Rec."Due Next 30 Days (LCY)" := GetOpenReceivableAmount(WorkDate(), CalcDate('<+30D>', WorkDate()), true);
        Rec.CalcFields("Receivables Cartera Documents", "Rejected Cartera Documents", "Open Bill Groups");
        Rec.Modify();
    end;

    local procedure GetOpenReceivableAmount(StartDate: Date; EndDate: Date; FilterDueDate: Boolean): Decimal
    var
        OpenReceivableSum: Query "OD PM Open Receivable Sum";
        Amount: Decimal;
    begin
        if FilterDueDate then
            OpenReceivableSum.SetRange(DueDate, StartDate, EndDate);

        OpenReceivableSum.Open();
        if OpenReceivableSum.Read() then
            Amount := OpenReceivableSum.RemainingAmtLCY;
        OpenReceivableSum.Close();

        exit(Amount);
    end;
}
