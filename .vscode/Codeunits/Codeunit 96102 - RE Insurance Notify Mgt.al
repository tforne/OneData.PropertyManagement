codeunit 96102 "RE Insurance Notify Mgt"
{
    procedure NotifyInsurance(var Incident: Record "Incident Assets Real Estate")
    var
        InsurancePolicy : Record "RE Insurance Policy";
        contact : Record Contact;
        Email: Codeunit Email;
        EmailMessage: Codeunit "Email Message";
        Recipients: List of [Text];
        SubjectText: Text;
        BodyText: Text;
    begin
        Incident.TestField("Insurance Policy No.");

        if Incident."Insurance Notified" then
            if not Confirm(
                'La aseguradora ya fue notificada anteriormente. ¿Desea reenviar el correo?',
                false)
            then
                exit;

        InsurancePolicy.Get(Incident."Insurance Policy No.");
        InsurancePolicy.TestField("Claim E-Mail");
        if not contact.Get(Incident."Contact No") then
            contact.init;
            
        SubjectText :=
            StrSubstNo(
                'Incidencia %1 - Inmueble %2 - Póliza %3',
                Incident."Incident Id.",
                Incident."Fixed Real Estate No.",
                InsurancePolicy."Policy No.");

        BodyText :=
            '<html>' +
            '<body style="font-family:Segoe UI;font-size:14px;color:#333333;line-height:1.5;">' +

                '<div style="max-width:700px;margin:0 auto;border:1px solid #E5E5E5;border-radius:8px;overflow:hidden;">' +

                    '<div style="background-color:#1F4E79;color:white;padding:18px 24px;">' +
                        '<h2 style="margin:0;">Comunicación de incidencia</h2>' +
                    '</div>' +

                    '<div style="padding:24px;">' +

                        '<p>Se comunica una incidencia relacionada con un inmueble asegurado.</p>' +

                        '<div style="background:#F7F9FC;border:1px solid #D9E2F3;border-radius:6px;padding:16px;margin:18px 0;">' +

                            '<p><strong>Número de incidencia:</strong> ' + Format(Incident."Incident Id.") + '</p>' +
                            '<p><strong>Activo:</strong> ' +
                                EscapeHtml(Incident."Fixed Real Estate No.") + ' - ' +
                                EscapeHtml(Incident."REF Description") + '</p>' +

                            '<p><strong>Incidencia:</strong> ' +
                                EscapeHtml(Incident.Title) + '</p>' +

                            '<p><strong>Fecha:</strong> ' +
                                Format(Incident."Incident Date") + '</p>' +

                            '<p><strong>Descripción:</strong><br>' +
                                EscapeHtml(Incident.Description) + '</p>' +
                        '</div>' +

                        '<h3 style="margin-bottom:8px;">Datos de contacto</h3>' +

                        '<p><strong>Contrato:</strong> ' +
                            EscapeHtml(Incident."Contract No.") + '</p>' +

                        '<p><strong>Contacto:</strong> ' +
                            EscapeHtml(contact.Name) + '</p>' +

                        '<p><strong>Teléfono:</strong> ' +
                            EscapeHtml(contact."Phone No.") + '</p>' +

                        '<p><strong>Email:</strong> ' +
                            EscapeHtml(Incident."Contract - EMail") + '</p>' +

                        '<h3 style="margin:20px 0 8px 0;">Datos póliza</h3>' +

                        '<p><strong>Póliza:</strong> ' +
                            EscapeHtml(InsurancePolicy."Policy No.") + '</p>' +

                        '<p><strong>Aseguradora:</strong> ' +
                            EscapeHtml(InsurancePolicy."Insurer Name") + '</p>' +

                        '<p style="margin-top:24px;">' +
                            'Atentamente,<br>' +
                            '<strong>Equipo de gestión</strong>' +
                        '</p>' +

                    '</div>' +
                '</div>' +

            '</body>' +
            '</html>';

        Clear(Recipients);
        Recipients.Add(InsurancePolicy."Claim E-Mail");

        Clear(EmailMessage);
        EmailMessage.Create(Recipients, SubjectText, BodyText, true);

        AttachIncidentAttachments(EmailMessage, Incident);

        if not TrySendEmail(Email, EmailMessage) then begin
            Message(
                'No se ha podido enviar el correo automáticamente. Revise la configuración de cuentas de correo y complete el envío desde el editor de correo.\Error: %1',
                GetLastErrorText());

            Email.OpenInEditorModally(EmailMessage);
            exit;
        end;

        InsertIncidentCommentSystem(
            Incident,
            StrSubstNo(
                'Correo enviado a la aseguradora %1. Póliza %2. Email %3.',
                InsurancePolicy."Insurer Name",
                InsurancePolicy."Policy No.",
                InsurancePolicy."Claim E-Mail"));

        Incident."Insurance Notified" := true;
        Incident."Insurance Notification Date" := CurrentDateTime();
        Incident."Insurance Status" := Incident."Insurance Status"::Reported;
        Incident.Modify(true);
    end;

    [TryFunction]
    local procedure TrySendEmail(var Email: Codeunit Email; var EmailMessage: Codeunit "Email Message")
    begin
        Email.Send(EmailMessage);
    end;

    local procedure AttachIncidentAttachments(var EmailMessage: Codeunit "Email Message"; var Incident: Record "Incident Assets Real Estate")
    var
        IncidentAttachment: Record "Incident Attachment";
        AttachmentName: Text[250];
        AttachmentContentType: Text[250];
        AttachmentInStream: InStream;
    begin
        IncidentAttachment.SetRange("Incident Id.", Incident."Incident Id.");

        if IncidentAttachment.FindSet() then
            repeat
                IncidentAttachment.CalcFields(Content);

                if IncidentAttachment.Content.HasValue() then begin
                    AttachmentName := GetIncidentAttachmentFileName(IncidentAttachment);
                    AttachmentContentType := GetIncidentAttachmentContentType(IncidentAttachment."File Extension");
                    IncidentAttachment.Content.CreateInStream(AttachmentInStream);
                    EmailMessage.AddAttachment(
                        AttachmentName,
                        AttachmentContentType,
                        AttachmentInStream);
                end;
            until IncidentAttachment.Next() = 0;
    end;

    local procedure GetIncidentAttachmentFileName(var IncidentAttachment: Record "Incident Attachment"): Text[250]
    begin
        if IncidentAttachment."File Extension" <> '' then
            exit(IncidentAttachment.Name + '.' + IncidentAttachment."File Extension");

        exit(IncidentAttachment.Name);
    end;

    local procedure GetIncidentAttachmentContentType(FileExtension: Text): Text[250]
    begin
        case LowerCase(FileExtension) of
            'pdf':
                exit('application/pdf');
            'jpg', 'jpeg':
                exit('image/jpeg');
            'png':
                exit('image/png');
            'gif':
                exit('image/gif');
            'bmp':
                exit('image/bmp');
            'tiff', 'tif':
                exit('image/tiff');
            'docx':
                exit('application/vnd.openxmlformats-officedocument.wordprocessingml.document');
            'doc':
                exit('application/msword');
            'xlsx':
                exit('application/vnd.openxmlformats-officedocument.spreadsheetml.sheet');
            'xls':
                exit('application/vnd.ms-excel');
            'pptx':
                exit('application/vnd.openxmlformats-officedocument.presentationml.presentation');
            'ppt':
                exit('application/vnd.ms-powerpoint');
            'msg':
                exit('application/vnd.ms-outlook');
            'xml':
                exit('application/xml');
            'txt':
                exit('text/plain');
        end;

        exit('application/octet-stream');
    end;

    local procedure InsertIncidentCommentSystem(var Incident: Record "Incident Assets Real Estate"; CommentText: Text[250])
    var
        IncidentCommentLine: Record "Incident Comment Line";
        LastIncidentCommentLine: Record "Incident Comment Line";
        LineNo: Integer;
    begin
        LastIncidentCommentLine.SetRange("Incident Id.", Incident."Incident Id.");

        if LastIncidentCommentLine.FindLast() then
            LineNo := LastIncidentCommentLine."Line No." + 10000
        else
            LineNo := 10000;

        IncidentCommentLine.Init();
        IncidentCommentLine."Incident Id." := Incident."Incident Id.";
        IncidentCommentLine."Line No." := LineNo;
        IncidentCommentLine.Date := WorkDate();
        IncidentCommentLine.Comment :=
            CopyStr(CommentText, 1, MaxStrLen(IncidentCommentLine.Comment));
        IncidentCommentLine."Comentario del sistema" := true;
        IncidentCommentLine.Insert(true);
    end;

    local procedure EscapeHtml(InputText: Text): Text
    begin
        InputText := InputText.Replace('&', '&amp;');
        InputText := InputText.Replace('<', '&lt;');
        InputText := InputText.Replace('>', '&gt;');
        InputText := InputText.Replace('"', '&quot;');
        InputText := InputText.Replace('''', '&#39;');
        exit(InputText);
    end;
}