codeunit 96002 "Correct Lease Invoice (Yes/No)"
{
    TableNo = "Lease Invoice Header";

    trigger OnRun()
    begin
        CorrectInvoice(Rec);
    end;

    var
        CorrectPostedInvoiceQst: Label 'The posted sales invoice will be canceled, and a new version of the sales invoice will automatically be created by the system so that you can make the correction.\ \Do you want to continue?';
    
    procedure CorrectInvoice(var LeaseInvoiceHeader: Record "Lease Invoice Header"): Boolean
    var
        CorrectLeaseInvoice: Codeunit "Correct Lease Invoice";
        RelatedOrderNo: Code[20];
        MultipleOrderRelated: Boolean;
        SalesHeaderExists: Boolean;
    begin
        exit(CancelPostedInvoice(LeaseInvoiceHeader,CorrectPostedInvoiceQst));
    end;

    
    local procedure CancelPostedInvoice(var LeaseInvoiceHeader: Record "Lease Invoice Header"; ConfirmationText: Text): Boolean
    var
        ConfirmManagement: Codeunit "Confirm Management";
        CorrectLeaseInvoice: Codeunit "Correct Lease Invoice";
    begin
        if ConfirmManagement.GetResponse(ConfirmationText, true) then
            exit(CorrectLeaseInvoice.CancelPostedInvoice(LeaseInvoiceHeader));

        exit(false);
    end;



}

