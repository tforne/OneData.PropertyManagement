codeunit 96010 "Correct Lease Invoice"
{
    Permissions = TableData "Lease Invoice Header" = rm;
                  
    TableNo = "Lease Invoice Header";

    trigger OnRun()
    var
        LeaseHeader: Record "Lease Invoice Header";
        NoSeries: Codeunit "No. Series";
        IsHandled: Boolean;
    begin
    end;

    var
        CancellingOnly: Boolean;
        SuppressCommit: Boolean;

    procedure TestCorrectInvoiceIsAllowed(var LeaseInvoiceHeader: Record "Lease Invoice Header"; Cancelling: Boolean)
    begin
        CancellingOnly := Cancelling;

    end;
}