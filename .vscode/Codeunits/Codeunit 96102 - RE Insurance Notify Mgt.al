codeunit 96102 "RE Insurance Notify Mgt"
{
    procedure NotifyInsurance(var Incident: Record "Incident Assets Real Estate")
    var
        InsurancePolicy: Record "RE Insurance Policy";
        Email: Codeunit Email;
        EmailMessage: Codeunit "Email Message";
        Recipients: List of [Text];
        SubjectText: Text;
        BodyText: Text;
        REIncidentManagement: Codeunit "RE Incident Management";
    begin
        Incident.TestField("Insurance Policy No.");

        InsurancePolicy.Get(Incident."Insurance Policy No.");
        InsurancePolicy.TestField("Claim E-Mail");

        SubjectText := StrSubstNo('Incidencia inmueble %1 - Poliza %2', Incident."Fixed Real Estate No.", InsurancePolicy."Policy No.");
        BodyText :=
            '<html><body style="font-family:Segoe UI;font-size:14px;">' +
            '<h2>Comunicacion de incidencia</h2>' +
            '<p><strong>Activo:</strong> ' + Incident."Fixed Real Estate No." + ' - ' + EscapeHtml(Incident."REF Description") + '</p>' +
            '<p><strong>Poliza:</strong> ' + EscapeHtml(InsurancePolicy."Policy No.") + '</p>' +
            '<p><strong>Aseguradora:</strong> ' + EscapeHtml(InsurancePolicy."Insurer Name") + '</p>' +
            '<p><strong>Incidencia:</strong> ' + EscapeHtml(Incident.Title) + '</p>' +
            '<p><strong>Fecha:</strong> ' + Format(Incident."Incident Date") + '</p>' +
            '<p><strong>Descripcion:</strong><br>' + EscapeHtml(Incident.Description) + '</p>' +
            '</body></html>';

        Recipients.Add(InsurancePolicy."Claim E-Mail");
        EmailMessage.Create(Recipients, SubjectText, BodyText, true);
        AttachIncidentAttachments(EmailMessage, Incident);

        if not TrySendEmail(Email, EmailMessage) then begin
            Message('No se ha podido enviar el correo automáticamente. Revise la configuración de cuentas de correo y complete el envío desde el editor de correo.\%1', GetLastErrorText());
            Email.OpenInEditorModally(EmailMessage);
            exit;
        end;

        REIncidentManagement.InsCommentLineSystem(Incident, 'Correo a aseguradora enviado', Format(Today));

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
        if IncidentAttachment.FindSet() then begin
            repeat
                IncidentAttachment.CalcFields(Content);
                if IncidentAttachment.Content.HasValue() then begin
                    AttachmentName := GetIncidentAttachmentFileName(IncidentAttachment);
                    AttachmentContentType := GetIncidentAttachmentContentType(IncidentAttachment."File Extension");
                    IncidentAttachment.Content.CreateInStream(AttachmentInStream);
                    EmailMessage.AddAttachment(AttachmentName, AttachmentContentType, AttachmentInStream);
                end;
            until IncidentAttachment.Next() = 0;
        end;
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
