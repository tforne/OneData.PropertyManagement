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
        Text110: Label 'The client will be notified of the incident %1';

        Text120: Label 'Cierre de la incidencia %1';
        Text121: Label 'Se ha enviado el correo de cierre de la incidencia %1 al cliente.';
        Text122: Label 'La incidencia ha sido resuelta.';
        Text123: Label 'La incidencia ha sido cancelada.';


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

    
    
    //----------------------------------------
    // RECEPCIÓN INCIDENCIA
    //----------------------------------------
    procedure NotificarPorCorreoRecepciónIncidencia(Incidencia: Record "Incident Assets Real Estate")
    var
        Contract: Record "Lease Contract";
        Email: Codeunit Email;
        EmailMessage: Codeunit "Email Message";
        Recipients: List of [Text];
        SubjectText: Text;
        BodyText: Text;
        REIncidentManagement: Codeunit "RE Incident Management";
    begin
        if not Contract.Get(Incidencia."Contract No.") then
            exit;

        if Contract."E-Mail" = '' then
            exit;

        SubjectText := StrSubstNo(Text100, Incidencia.Title);

        BodyText :=
            '<html><body style="font-family: Segoe UI; font-size:14px;">' +
            '<h2>Recepción de incidencia</h2>' +
            '<p>Estimado/a cliente,</p>' +
            '<p>Hemos recibido correctamente su incidencia.</p>' +

            '<p><strong>Nº:</strong> ' + Format(Incidencia."Incident Id.") + '<br>' +
            '<strong>Título:</strong> ' + FormatearTextoParaHTML(Incidencia.Title) + '<br>' +
            '<strong>Fecha:</strong> ' + Format(Incidencia."Incident Date") + '</p>' +

            '<p>Gracias por su colaboración.</p>' +
            '</body></html>';

        Recipients.Add(Contract."E-Mail");

        EmailMessage.Create(Recipients, SubjectText, BodyText, true);

        if not TrySendEmail(Email, EmailMessage) then
            Error('Error enviando email de incidencia %1', Incidencia."Incident Id.");

        REIncidentManagement.InsCommentLineSystem(Incidencia, 'Correo de recepción enviado', Format(Today));
    end;

    //----------------------------------------
    // ACTUALIZACIÓN INCIDENCIA
    //----------------------------------------
    procedure NotificarPorCorreoSituaciónIncidencia(Incidencia: Record "Incident Assets Real Estate")
    var
        Contract: Record "Lease Contract";
        IncidentCommentLine: Record "Incident Comment Line";
        Email: Codeunit Email;
        EmailMessage: Codeunit "Email Message";
        Recipients: List of [Text];
        ComentarioText: Text;
        REIncidentManagement: Codeunit "RE Incident Management";
    begin
        if not Contract.Get(Incidencia."Contract No.") then
            exit;

        if Contract."E-Mail" = '' then
            exit;

        IncidentCommentLine.SetRange("Incident Id.", Incidencia."Incident Id.");
        if not IncidentCommentLine.FindLast() then
            exit;

        ComentarioText := FormatearTextoParaHTML(IncidentCommentLine.Comment);

        Recipients.Add(Contract."E-Mail");

        EmailMessage.Create(
            Recipients,
            'Actualización de incidencia ' + Format(Incidencia."Incident Id."),
            '<html><body>' +
            '<p>Nuevo comentario:</p>' +
            '<p>' + ComentarioText + '</p>' +
            '</body></html>',
            true);

        Email.Send(EmailMessage);
        REIncidentManagement.InsCommentLineSystem(Incidencia, 'Correo de actualización enviado', Format(Today));
    end;

    //----------------------------------------
    // 🔥 NUEVO: CIERRE INCIDENCIA
    //----------------------------------------
    procedure NotificarPorCorreoCierreIncidencia(Incidencia: Record "Incident Assets Real Estate")
    var
        Contract: Record "Lease Contract";
        Email: Codeunit Email;
        EmailMessage: Codeunit "Email Message";
        Recipients: List of [Text];
        EstadoTxt: Text;
        REIncidentManagement: Codeunit "RE Incident Management";
    begin
        if not Contract.Get(Incidencia."Contract No.") then
            exit;

        if Contract."E-Mail" = '' then
            exit;

        case Incidencia.StateCode of
            Incidencia.StateCode::Resolved:
                EstadoTxt := Text122;
            Incidencia.StateCode::Canceled:
                EstadoTxt := Text123;
            else
                exit;
        end;

        Recipients.Add(Contract."E-Mail");

        EmailMessage.Create(
            Recipients,
            StrSubstNo(Text120, Incidencia."Incident Id."),
            '<html><body style="font-family: Segoe UI;">' +

            '<h2>Cierre de incidencia</h2>' +

            '<p>Estimado/a cliente,</p>' +

            '<p>Su incidencia ha sido cerrada.</p>' +

            '<p><strong>Nº:</strong> ' + Format(Incidencia."Incident Id.") + '<br>' +
            '<strong>Título:</strong> ' + FormatearTextoParaHTML(Incidencia.Title) + '<br>' +
            '<strong>Estado:</strong> ' + EstadoTxt + '<br>' +
            '<strong>Fecha cierre:</strong> ' + Format(Incidencia."Resolution Date") + '</p>' +

            '<p>Gracias por su confianza.</p>' +

            '</body></html>',
            true);

        if TrySendEmail(Email, EmailMessage) then begin
            REIncidentManagement.InsCommentLineSystem(Incidencia, 'Correo de cierre enviado', Format(Today));
            Message(Text121, Incidencia."Incident Id.");
        end else
            Error('Error enviando cierre incidencia %1', Incidencia."Incident Id.");
    end;

    //----------------------------------------
    // UTILIDADES
    //----------------------------------------
    local procedure FormatearTextoParaHTML(InputText: Text): Text
    begin
        InputText := InputText.Replace('&', '&amp;');
        InputText := InputText.Replace('<', '&lt;');
        InputText := InputText.Replace('>', '&gt;');
        InputText := InputText.Replace('"', '&quot;');
        InputText := InputText.Replace('''', '&#39;');
        exit(InputText);
    end;

    [TryFunction]
    local procedure TrySendEmail(var Email: Codeunit Email; var EmailMessage: Codeunit "Email Message")
    begin
        Email.Send(EmailMessage);
    end;
}

