codeunit 96009 "Correct PstdLeaseInv (Yes/No)"
{
    Permissions = TableData "Lease Invoice Header" = rm;          
    TableNo = "Lease Invoice Header";

    trigger OnRun()
    begin
        CorrectInvoice(Rec);
    end;

    var
        CorrectPostedInvoiceQst: Label 'The Lease invoice will be canceled, and a new version of the sales invoice will automatically be created by the system so that you can make the correction.\ \Do you want to continue?';
        CorrectPostedInvoiceFromSingleOrderQst: Label 'The invoice was posted from an order. The invoice will be cancelled, and the order will open so that you can make the correction.\ \Do you want to continue?';
        CorrectPostedInvoiceFromDeletedOrderQst: Label 'The invoice was posted from an order. The order has been deleted, and the invoice will be cancelled. You can create a new invoice or order by using the Copy Document action.\ \Do you want to continue?';
        CorrectPostedInvoiceFromMultipleOrderQst: Label 'The invoice was posted from multiple orders. It will now be cancelled, and you can make a correction manually in the original orders.\ \Do you want to continue?';

    procedure CorrectInvoice(var LeaseInvoiceHeader: Record "Lease Invoice Header"): Boolean
    var
        CorrectLeaseInvoice: Codeunit "Correct Lease Invoice";
        RelatedOrderNo: Code[20];
        MultipleOrderRelated: Boolean;
        LeaseHeaderExists: Boolean;
    begin
        CorrectLeaseInvoice.TestCorrectInvoiceIsAllowed(LeaseInvoiceHeader, false);
        LeaseHeaderExists := LeaseInvoiceHeader.Get(LeaseInvoiceHeader."No.");
        exit(true)  
    end;
}
