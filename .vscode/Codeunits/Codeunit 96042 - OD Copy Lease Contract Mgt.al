namespace OneData.Property.Lease;

codeunit 96042 "OD Copy Lease Contract Mgt."
{
    procedure RunCopyContract(var TargetHeader: Record "Lease Contract")
    var
        CopyRequest: Record "OD Copy Lease Contract Request";
        CopyRequestPage: Page "OD Copy Lease Contract Req.";
    begin
        CopyRequestPage.SetDefaults();

        if CopyRequestPage.RunModal() <> Action::OK then
            exit;

        CopyRequest.Init();
        CopyRequest."Source Company Name" := CopyRequestPage.GetSourceCompanyName();
        CopyRequest."Source Contract No." := CopyRequestPage.GetSourceContractNo();
        CopyRequest."Replace Lines" := CopyRequestPage.GetReplaceLines();
        CopyRequest."Copy Header" := CopyRequestPage.GetCopyHeader();
        CopyRequest."Copy Lines" := CopyRequestPage.GetCopyLines();
        CopyRequest."Copy Comments" := CopyRequestPage.GetCopyComments();

        CopyContract(TargetHeader, CopyRequest);
    end;

    procedure CopyContract(var TargetHeader: Record "Lease Contract"; CopyRequest: Record "OD Copy Lease Contract Request")
    var
        SourceHeader: Record "Lease Contract";
        Helper: Codeunit "OD Lease Contract Copy Helper";
        IsHandled: Boolean;
    begin
        ValidateRequest(CopyRequest);

        Helper.GetSourceHeader(
            CopyRequest."Source Company Name",
            CopyRequest."Source Contract No.",
            SourceHeader);

        Helper.EnsureTargetCanBeUpdated(TargetHeader);
        Helper.ValidateMasterDataCompatibility(SourceHeader);

        IsHandled := false;
        OnBeforeCopyContract(SourceHeader, TargetHeader, CopyRequest, IsHandled);
        if IsHandled then
            exit;

        if CopyRequest."Copy Header" then begin
            OnBeforeCopyHeader(SourceHeader, TargetHeader, CopyRequest);
            Helper.CopyHeaderFields(SourceHeader, TargetHeader);
            OnAfterCopyHeader(SourceHeader, TargetHeader, CopyRequest);
        end;

        if CopyRequest."Copy Lines" then begin
            Helper.EnsureLinesCanBeReplaced(TargetHeader."Contract No.", CopyRequest."Replace Lines");

            if CopyRequest."Replace Lines" then
                Helper.DeleteTargetLines(TargetHeader."Contract No.");

            OnBeforeCopyLines(SourceHeader, TargetHeader, CopyRequest);
            Helper.CopyLines(
                CopyRequest."Source Company Name",
                CopyRequest."Source Contract No.",
                TargetHeader."Contract No.");
            OnAfterCopyLines(SourceHeader, TargetHeader, CopyRequest);
        end;

        if CopyRequest."Copy Comments" then
            CopyComments(SourceHeader, TargetHeader, CopyRequest."Source Company Name");

        InsertAuditLog(TargetHeader, CopyRequest);

        OnAfterCopyContract(SourceHeader, TargetHeader, CopyRequest);

        Message(
            'Contrato %1 copiado correctamente desde el contrato %2 de la empresa %3.',
            TargetHeader."Contract No.",
            CopyRequest."Source Contract No.",
            CopyRequest."Source Company Name");
    end;

    local procedure ValidateRequest(CopyRequest: Record "OD Copy Lease Contract Request")
    begin
        if CopyRequest."Source Company Name" = '' then
            Error('Debes indicar la empresa origen.');

        if CopyRequest."Source Contract No." = '' then
            Error('Debes indicar el contrato origen.');

        if not CopyRequest."Copy Header" and not CopyRequest."Copy Lines" then
            Error('Debes seleccionar al menos una opción de copia.');
    end;

    local procedure CopyComments(SourceHeader: Record "Lease Contract"; var TargetHeader: Record "Lease Contract"; SourceCompanyName: Text[30])
    begin
        OnCopyComments(SourceHeader, TargetHeader, SourceCompanyName);
    end;

    local procedure InsertAuditLog(TargetHeader: Record "Lease Contract"; CopyRequest: Record "OD Copy Lease Contract Request")
    var
        LogEntry: Record "OD Lease Contract Copy Log";
    begin
        LogEntry.Init();
        LogEntry."Date Time" := CurrentDateTime();
        LogEntry."User ID" := CopyStr(UserId(), 1, MaxStrLen(LogEntry."User ID"));
        LogEntry."Source Company Name" := CopyRequest."Source Company Name";
        LogEntry."Source Contract No." := CopyRequest."Source Contract No.";
        LogEntry."Target Company Name" := CopyStr(CompanyName(), 1, MaxStrLen(LogEntry."Target Company Name"));
        LogEntry."Target Contract No." := TargetHeader."Contract No.";
        LogEntry."Copy Header" := CopyRequest."Copy Header";
        LogEntry."Copy Lines" := CopyRequest."Copy Lines";
        LogEntry."Replace Lines" := CopyRequest."Replace Lines";
        LogEntry."Copy Comments" := CopyRequest."Copy Comments";
        LogEntry.Insert(true);
    end;

    [IntegrationEvent(false, false)]
    local procedure OnBeforeCopyContract(SourceHeader: Record "Lease Contract"; var TargetHeader: Record "Lease Contract"; CopyRequest: Record "OD Copy Lease Contract Request"; var IsHandled: Boolean)
    begin
    end;

    [IntegrationEvent(false, false)]
    local procedure OnBeforeCopyHeader(SourceHeader: Record "Lease Contract"; var TargetHeader: Record "Lease Contract"; CopyRequest: Record "OD Copy Lease Contract Request")
    begin
    end;

    [IntegrationEvent(false, false)]
    local procedure OnAfterCopyHeader(SourceHeader: Record "Lease Contract"; var TargetHeader: Record "Lease Contract"; CopyRequest: Record "OD Copy Lease Contract Request")
    begin
    end;

    [IntegrationEvent(false, false)]
    local procedure OnBeforeCopyLines(SourceHeader: Record "Lease Contract"; var TargetHeader: Record "Lease Contract"; CopyRequest: Record "OD Copy Lease Contract Request")
    begin
    end;

    [IntegrationEvent(false, false)]
    local procedure OnAfterCopyLines(SourceHeader: Record "Lease Contract"; var TargetHeader: Record "Lease Contract"; CopyRequest: Record "OD Copy Lease Contract Request")
    begin
    end;

    [IntegrationEvent(false, false)]
    local procedure OnCopyComments(SourceHeader: Record "Lease Contract"; var TargetHeader: Record "Lease Contract"; SourceCompanyName: Text[30])
    begin
    end;

    [IntegrationEvent(false, false)]
    local procedure OnAfterCopyContract(SourceHeader: Record "Lease Contract"; var TargetHeader: Record "Lease Contract"; CopyRequest: Record "OD Copy Lease Contract Request")
    begin
    end;
}
