report 96010 "Generate FRE Movs."
{
    ApplicationArea = All;
    Caption = 'Generate FRE Movs.';
    ProcessingOnly = true;
    UsageCategory = Tasks;

    dataset
    {
        dataitem("Lease Invoice Header";"Lease Invoice Header")
        {
            RequestFilterFields = "Posting Date";

            trigger OnAfterGetRecord()
            begin
                Counter1 := Counter1 + 1;
                Counter2 := Counter2 + 1;
                IF Counter2 >= CounterBreak THEN BEGIN
                    Counter2 := 0;
                    Window.UPDATE(1, ROUND(Counter1 / CounterTotal * 10000, 1));
                END;

                LeaseInvoiceHeader := "Lease Invoice Header";
                ResultDescription := '';
                if Cust.GET(LeaseInvoiceHeader."Customer No.") then
                    FREJnlPostLine.PostFRELedgerEntryFromLeaseInvoice(LeaseInvoiceHeader);
            end;

            trigger OnPostDataItem()
            begin
            end;

            trigger OnPreDataItem()
            begin
                FRELedgerEntry.Reset();
                if FRELedgerEntry.FindFirst() then
                    FRELedgerEntry.DeleteAll();
                LastCustomer := '';
                Window.OPEN(
                  Text005 +
                  '@1@@@@@@@@@@@@@@@@@@@@@@@@@@@@@');

                CounterTotal := COUNT;
                Counter1 := 0;
                Counter2 := 0;
                CounterBreak := ROUND(CounterTotal / 100, 1, '>');
            end;
        }
    }

    labels
    {
    }

    var
        Text005: Label 'Creating FRE movs. invoices...\\';
        Cust: Record Customer;
        LeaseInvoiceHeader: Record "Lease Invoice Header";
        FRELedgerEntry: Record "FRE Ledger Entry";
        FREJnlPostLine : Codeunit "FRE Jnl.-Post Line";
        Window: Dialog;
        CounterTotal: Integer;
        Counter1: Integer;
        Counter2: Integer;
        CounterBreak: Integer;
        ResultDescription: Text[80];
        LastCustomer: Code[20];
        HideDialog: Boolean;
}