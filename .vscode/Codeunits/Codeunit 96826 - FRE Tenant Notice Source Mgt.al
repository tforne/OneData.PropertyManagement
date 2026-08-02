codeunit 96826 "FRE Tenant Notice Source Mgt."
{
    
    procedure AddRecipientsFromActiveContracts(var TenantNotice: Record "FRE Tenant Notice Header"; AssetNoFilter: Code[20]; ContractNoFilter: Code[20]; CustomerNoFilter: Code[20])
    var
        LeaseContract: Record "Lease Contract";
        TenantNoticeRecipient: Record "FRE Tenant Notice Recipient";
        Customer: Record Customer;
        NextLineNo: Integer;
        AddedCount: Integer;
    begin
        TenantNotice.TestField("Notice Id.");

        // Ajusta estos filtros según los campos reales de tu tabla 96018 "Lease Contract".
        // Recomendado: filtrar solo contratos activos/vigentes.
        if AssetNoFilter <> '' then
            LeaseContract.SetRange("Fixed Real Estate No.", AssetNoFilter);

        if ContractNoFilter <> '' then
            LeaseContract.SetRange("Contract No.", ContractNoFilter);

        if CustomerNoFilter <> '' then
            LeaseContract.SetRange("Customer No.", CustomerNoFilter);

        // Si tu enum/option de estado se llama distinto, ajusta esta línea.
        // Ejemplo:
        // LeaseContract.SetRange(Status, LeaseContract.Status::Active);

        if not LeaseContract.FindSet() then
            exit;

        repeat
            if not RecipientExists(TenantNotice."Notice Id.", LeaseContract."Contract No.", LeaseContract."Customer No.") then begin
                NextLineNo := GetNextRecipientLineNo(TenantNotice."Notice Id.");

                TenantNoticeRecipient.Init();
                TenantNoticeRecipient."Notice Id." := TenantNotice."Notice Id.";
                TenantNoticeRecipient."Line No." := NextLineNo;
                TenantNoticeRecipient."Customer No." := LeaseContract."Customer No.";
                TenantNoticeRecipient."Contract No." := LeaseContract."Contract No.";
                TenantNoticeRecipient."Asset No." := LeaseContract."Fixed Real Estate No.";
                TenantNoticeRecipient."Portal Visible" := true;

                if Customer.Get(LeaseContract."Customer No.") then begin
                    TenantNoticeRecipient.Name := Customer.Name;
                    TenantNoticeRecipient.Email := Customer."E-Mail";
                end;

                TenantNoticeRecipient.Insert(true);
                AddedCount += 1;
            end;
        until LeaseContract.Next() = 0;

        Message('%1 destinatarios añadidos desde contratos.', AddedCount);
    end;

    procedure AddRecipientsFromNoticeFilters(var TenantNotice: Record "FRE Tenant Notice Header")
    begin
        AddRecipientsFromActiveContracts(
            TenantNotice,
            TenantNotice."Asset No.",
            TenantNotice."Contract No.",
            '');
    end;

    procedure AddIncidentSystemComment(TenantNotice: Record "FRE Tenant Notice Header"; CommentText: Text[250])
    var
        IncidentCommentLine: Record "Incident Comment Line";
        NextLineNo: Integer;
    begin
        if IsNullGuid(TenantNotice."Incident Id.") then
            exit;

        if CommentText = '' then
            CommentText := StrSubstNo(
                'Se ha informado a los inquilinos del aviso %1 - %2.',
                TenantNotice."No.",
                TenantNotice.Title);

        NextLineNo := GetNextIncidentCommentLineNo(TenantNotice."Incident Id.");

        IncidentCommentLine.Init();
        IncidentCommentLine."Incident Id." := TenantNotice."Incident Id.";
        IncidentCommentLine."Line No." := NextLineNo;
        IncidentCommentLine.Comment := CopyStr(CommentText, 1, MaxStrLen(IncidentCommentLine.Comment));
        IncidentCommentLine.Date := Today;
        IncidentCommentLine."Comentario del sistema" := true;
        IncidentCommentLine.Insert(true);
    end;

    procedure AddIncidentCommentAfterPublish(TenantNotice: Record "FRE Tenant Notice Header")
    begin
        AddIncidentSystemComment(
            TenantNotice,
            StrSubstNo(
                'Aviso publicado para inquilinos: %1 - %2.',
                TenantNotice."No.",
                TenantNotice.Title));
    end;

    procedure AddIncidentCommentAfterEmail(TenantNotice: Record "FRE Tenant Notice Header")
    begin
        AddIncidentSystemComment(
            TenantNotice,
            StrSubstNo(
                'Se ha enviado por correo a los inquilinos el aviso: %1 - %2.',
                TenantNotice."No.",
                TenantNotice.Title));
    end;

    local procedure RecipientExists(NoticeId: Guid; ContractNo: Code[20]; CustomerNo: Code[20]): Boolean
    var
        TenantNoticeRecipient: Record "FRE Tenant Notice Recipient";
    begin
        TenantNoticeRecipient.SetRange("Notice Id.", NoticeId);
        TenantNoticeRecipient.SetRange("Contract No.", ContractNo);
        TenantNoticeRecipient.SetRange("Customer No.", CustomerNo);
        exit(not TenantNoticeRecipient.IsEmpty());
    end;

    local procedure GetNextRecipientLineNo(NoticeId: Guid): Integer
    var
        TenantNoticeRecipient: Record "FRE Tenant Notice Recipient";
    begin
        TenantNoticeRecipient.SetRange("Notice Id.", NoticeId);

        if TenantNoticeRecipient.FindLast() then
            exit(TenantNoticeRecipient."Line No." + 10000);

        exit(10000);
    end;

    local procedure GetNextIncidentCommentLineNo(IncidentId: Guid): Integer
    var
        IncidentCommentLine: Record "Incident Comment Line";
    begin
        IncidentCommentLine.SetRange("Incident Id.", IncidentId);

        if IncidentCommentLine.FindLast() then
            exit(IncidentCommentLine."Line No." + 10000);

        exit(10000);
    end;
}
