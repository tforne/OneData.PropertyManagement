codeunit 96001 "Customer RE-Notify by Email"
{

    trigger OnRun()
    begin
    end;

    var
        Text000: Label 'Next lease invoice %1 period %2';
        Text001: Label 'Se ha generado una nueva deuda de %1 Euros con vencimiento %2';
        Text002: Label 'The customer will be notified as requested because service order %1 is now %2.';
        Text003: Label 'El próximo día %1, se va a proceder al cargo del recibo domiciliado ';
        Text004: Label 'para el cobro de %1 , correspondiente al alquiler del inmueble del mes de %2';
        Text005: Label 'Aviso de cargo recibo domiciliado el %1';

        Text100: Label 'Incidencia %1';
        Text101: Label 'Hola %1';
        Text102: Label 'Hemos registrado correctamente la incidencia %1 que nos has comunicado y procedemos a su resolución.';
        Text103: Label 'Te iremos informando a medida que avancemos con cada punto.';
        Text104: Label 'Un saludo';
        Text110: Label 'The client will be notified of the incident %1';

        
    procedure NotificarPorCorreoDeudaAlquiler(LeaseInvoiceHeader: Record "Lease Invoice Header")
    var
        Email: Codeunit Email;
        EmailMessage: Codeunit "Email Message";
        Recipients: List of [Text];
        SubjectText: Text;
        BodyText: Text;
    begin
        if LeaseInvoiceHeader."Notify Customer" <> LeaseInvoiceHeader."Notify Customer"::"By Email" then
            exit;

        if LeaseInvoiceHeader."E-Mail" = '' then
            exit;

        LeaseInvoiceHeader.CalcFields("Amount Including VAT");

        SubjectText :=
            StrSubstNo(
                Text000,
                LeaseInvoiceHeader."No.",
                Format(LeaseInvoiceHeader."Posting Date", 0, '<Month Text>'));

        BodyText :=
            StrSubstNo(
                Text001,
                LeaseInvoiceHeader."Amount Including VAT",
                LeaseInvoiceHeader."Due Date");

        Clear(Recipients);
        Recipients.Add(LeaseInvoiceHeader."E-Mail");

        Clear(EmailMessage);
        EmailMessage.Create(
            Recipients,
            SubjectText,
            BodyText,
            false);

        if TrySendEmail(Email, EmailMessage) then
            Message(
                Text002,
                LeaseInvoiceHeader."No.",
                LeaseInvoiceHeader."Customer No.")
        else
            Error(
                'No se ha podido enviar el correo para la factura %1. Revise la configuración de email o la licencia/permisos del usuario.',
                LeaseInvoiceHeader."No.");
    end;

    
    procedure NotificarPorCorreoAdeudo(BillGroup: Record "Bill Group")
    var
        CarteraDoc: Record "Cartera Doc.";
        Customer: Record Customer;
        Email: Codeunit "Email";
        EmailMessage: Codeunit "Email Message";
        Recipients: List of [Text];
        BodyText: Text;
        SubjectText: Text;
    begin
        CarteraDoc.Reset();
        CarteraDoc.SetRange(Type, CarteraDoc.Type::Receivable);
        CarteraDoc.SetRange("Bill Gr./Pmt. Order No.", BillGroup."No.");

        if CarteraDoc.FindSet() then
            repeat
                if Customer.Get(CarteraDoc."Account No.") then
                    if Customer."E-Mail" <> '' then begin
                        Clear(Recipients);
                        Recipients.Add(Customer."E-Mail");

                        SubjectText := StrSubstNo(Text005, Format(CarteraDoc."Due Date", 0, '<Month Text>'));
                        BodyText := StrSubstNo(Text003, Format(CarteraDoc."Due Date", 0, '<Month Text>'));

                        Clear(EmailMessage);
                        EmailMessage.Create(
                            Recipients,
                            SubjectText,
                            BodyText,
                            false); // false = texto plano, true = HTML

                        Email.Send(EmailMessage);
                    end;
            until CarteraDoc.Next() = 0;
    end;

    
    procedure NotificarPorCorreoRecepciónIncidencia(Incidencia: Record "Incident Assets Real Estate")
    var
        Contract: Record "Lease Contract";
        Email: Codeunit Email;
        EmailMessage: Codeunit "Email Message";
        Recipients: List of [Text];
        SubjectText: Text;
        BodyText: Text;
    begin
        if not Contract.Get(Incidencia."Contract No.") then
            exit;

        if Contract."E-Mail" = '' then
            exit;

        SubjectText :=
            StrSubstNo(
                Text100,
                Incidencia.Title,
                Format(Incidencia."Incident Date", 0, '<Month Text>'));

        BodyText :=
            '<html>' +
            '<body style="font-family: Segoe UI, Arial, sans-serif; font-size: 14px; color: #333333; line-height: 1.6;">' +

                '<div style="max-width: 600px; margin: 0 auto; border: 1px solid #E5E5E5; border-radius: 8px; overflow: hidden;">' +

                    '<div style="background-color: #1F4E79; color: white; padding: 16px 24px;">' +
                        '<h2 style="margin: 0; font-size: 20px;">Recepción de incidencia</h2>' +
                    '</div>' +

                    '<div style="padding: 24px;">' +
                        '<p style="margin-top: 0;">Estimado/a cliente,</p>' +

                        '<p>Hemos recibido correctamente su incidencia y ya ha sido registrada en nuestro sistema.</p>' +

                        '<div style="background-color: #F7F9FC; border: 1px solid #D9E2F3; border-radius: 6px; padding: 16px; margin: 20px 0;">' +
                            '<p style="margin: 0 0 8px 0;"><strong>Número de incidencia:</strong> ' + Format(Incidencia."Incident Id.") + '</p>' +
                            '<p style="margin: 0 0 8px 0;"><strong>Título:</strong> ' + Incidencia.Title + '</p>' +
                            '<p style="margin: 0;"><strong>Fecha de registro:</strong> ' + Format(Incidencia."Incident Date") + '</p>' +
                        '</div>' +

                        '<p>Nos pondremos en contacto con usted si necesitamos más información o cuando haya novedades sobre su solicitud.</p>' +

                        '<p>Gracias por su colaboración.</p>' +

                        '<p style="margin-top: 24px;">' +
                            'Atentamente,<br>' +
                            '<strong>Equipo de gestión</strong>' +
                        '</p>' +
                    '</div>' +

                '</div>' +

            '</body>' +
            '</html>';

        Clear(Recipients);
        Recipients.Add(Contract."E-Mail");

        Clear(EmailMessage);
        EmailMessage.Create(
            Recipients,
            SubjectText,
            BodyText,
            true);

        if TrySendEmail(Email, EmailMessage) then
            Message(Text110, Incidencia."Incident Id.")
        else
            Error(
                'No se ha podido enviar el correo de recepción de la incidencia %1. Revise la configuración de email o la licencia/permisos del usuario.',
                Incidencia."Incident Id.");
    end;

    [TryFunction]
    local procedure TrySendEmail(var Email: Codeunit Email; var EmailMessage: Codeunit "Email Message")
    begin
        Email.Send(EmailMessage);
    end;
}

