codeunit 96001 "Customer RE-Notify by Email"
{

    trigger OnRun()
    begin
    end;

    var
        Text000: Label 'Next lease invoice %1 period %2';
        Text001: Label 'Se ha generado una nueva deuda de %1 Euros con vencimiento %2';
        Text002: Label 'The customer will be notified as requested because service order %1 is now %2.';
        LeaseInvoiceHeader: Record "Lease Invoice Header";
        Text003: Label 'El próximo día %1, se va a proceder al cargo del recibo domiciliado ';
        Text004: Label 'para el cobro de %1 , correspondiente al alquiler del inmueble del mes de %2';
        Text005: Label 'Aviso de cargo recibo domiciliado el %1';

    procedure NotificarPorCorreoDeudaAlquiler(LeaseInvoiceHeader: Record "Lease Invoice Header")
    var
        ServEmailQueue: Record "Service Email Queue";
    begin
        IF LeaseInvoiceHeader."Notify Customer" <> LeaseInvoiceHeader."Notify Customer"::"By Email" THEN
            EXIT;

        ServEmailQueue.INIT;
        ServEmailQueue."To Address" := LeaseInvoiceHeader."E-Mail";
        IF ServEmailQueue."To Address" = '' THEN
            EXIT;

        LeaseInvoiceHeader.CALCFIELDS("Amount Including VAT");

        ServEmailQueue."Copy-to Address" := '';
        ServEmailQueue."Subject Line" := STRSUBSTNO(Text000, LeaseInvoiceHeader."No.", FORMAT(LeaseInvoiceHeader."Posting Date", 0, '<Month Text>'));
        ServEmailQueue."Body Line" := STRSUBSTNO(Text001, LeaseInvoiceHeader."Amount Including VAT", LeaseInvoiceHeader."Due Date");
        ServEmailQueue."Attachment Filename" := '';
        ServEmailQueue."Document Type" := ServEmailQueue."Document Type"::" ";
        ServEmailQueue."Document No." := LeaseInvoiceHeader."No.";
        ServEmailQueue.Status := ServEmailQueue.Status::" ";
        ServEmailQueue.INSERT(TRUE);
        ServEmailQueue.ScheduleInJobQueue;
        MESSAGE(
          Text002,
          LeaseInvoiceHeader."No.", LeaseInvoiceHeader."Customer No.");
    end;

    procedure NotificarPorCorreoAdeudo(BillGroup: Record "Bill Group")
    var
        ServEmailQueue: Record "Service Email Queue";
        CarteraDoc: Record "Cartera Doc.";
        Customer: Record Customer;
    begin

        CarteraDoc.RESET;
        CarteraDoc.SETRANGE(Type, CarteraDoc.Type::Receivable);
        CarteraDoc.SETRANGE("Bill Gr./Pmt. Order No.", BillGroup."No.");
        IF CarteraDoc.FINDFIRST THEN
            REPEAT
                Customer.GET(CarteraDoc."Account No.");
                ServEmailQueue.INIT;
                ServEmailQueue."To Address" := Customer."E-Mail";
                IF ServEmailQueue."To Address" <> '' THEN BEGIN
                    ServEmailQueue."Copy-to Address" := '';
                    ServEmailQueue."Subject Line" := STRSUBSTNO(Text005, FORMAT(CarteraDoc."Due Date", 0, '<Month Text>'));
                    ServEmailQueue."Body Line" := STRSUBSTNO(Text003, FORMAT(CarteraDoc."Due Date", 0, '<Month Text>'));
                    ServEmailQueue."Attachment Filename" := '';
                    ServEmailQueue."Document Type" := 0;
                    ServEmailQueue."Document No." := '';
                    ServEmailQueue.Status := ServEmailQueue.Status::" ";
                    ServEmailQueue.INSERT(TRUE);
                    ServEmailQueue.ScheduleInJobQueue;
                END;
            UNTIL CarteraDoc.NEXT = 0;
    end;
}

