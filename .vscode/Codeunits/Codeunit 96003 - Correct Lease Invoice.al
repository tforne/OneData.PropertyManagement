codeunit 96003 "Correct Lease Invoice"
{
    TableNo = "Lease Invoice Header";

    trigger OnRun()
    var
        NoSeries: Codeunit "No. Series";
        IsHandled: Boolean;
    begin

    end;

    var
        CancellingOnly: Boolean;
        SuppressCommit: Boolean;

    procedure CancelPostedInvoice(var LeaseInvoiceHeader: Record "Lease Invoice Header"): Boolean
    begin
        CancellingOnly := true;
        LeaseInvoiceHeader.Status := "Status Lease Invoice"::Canceled;
        exit(true);
    end;

}

