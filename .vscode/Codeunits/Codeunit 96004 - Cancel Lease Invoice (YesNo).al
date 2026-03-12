codeunit 96004 "Cancel Lease Invoice (Yes/No)"
{
    TableNo = "Lease Invoice Header";

    trigger OnRun()
    begin
        CancelInvoice(Rec);
    end;

    var
        CancelPostedInvoiceQst: Label 'This invoice was posted from a sales order. To cancel it, a sales credit memo will be created and posted. The quantities from the original sales order will be restored, provided the sales order still exists.\ \Do you want to continue?';
        OpenPostedCreditMemoQst: Label 'A credit memo was successfully created. Do you want to open the posted credit memo?';

    procedure CancelInvoice(var LeaseInvoiceHeader: Record "Lease Invoice Header"): Boolean
    var
        CorrectLeaseInvoice: Codeunit "Correct Lease Invoice";
        IsHandled: Boolean;
    begin
        if Confirm(CancelPostedInvoiceQst) then
            if CorrectLeaseInvoice.CancelPostedInvoice(LeaseInvoiceHeader) then begin
                LeaseInvoiceHeader.modify;
            end;

        exit(false);
    end;

}
