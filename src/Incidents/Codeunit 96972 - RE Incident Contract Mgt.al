codeunit 96972 "RE Incident Contract Mgt."
{
    Permissions = tabledata Company = r,
                  tabledata "Lease Contract" = r;

    procedure OpenContractLookup(var REIncident: Record "Incident Assets Real Estate"): Boolean
    var
        LookupBuffer: Record "RE Incident Contract Lookup" temporary;
    begin
        if REIncident."Fixed Real Estate No." = '' then
            exit(false);

        BuildLookupBuffer(REIncident."Fixed Real Estate No.", LookupBuffer);
        if LookupBuffer.IsEmpty() then begin
            Message(NoActiveContractsFoundMsg, REIncident."Fixed Real Estate No.");
            exit(false);
        end;

        if Page.RunModal(Page::"RE Incident Contract Lookup", LookupBuffer) <> Action::LookupOK then
            exit(false);

        ApplySelection(REIncident, LookupBuffer);
        exit(true);
    end;

    procedure SyncContractFields(var REIncident: Record "Incident Assets Real Estate")
    var
        LookupBuffer: Record "RE Incident Contract Lookup" temporary;
        MatchesFound: Integer;
    begin
        if REIncident."Contract No." = '' then begin
            ClearContractFields(REIncident);
            exit;
        end;

        if REIncident."Fixed Real Estate No." = '' then
            exit;

        MatchesFound := FindMatchingContracts(REIncident."Fixed Real Estate No.", REIncident."Contract No.", LookupBuffer);
        case MatchesFound of
            0:
                ClearDerivedContractFields(REIncident);
            1:
                begin
                    LookupBuffer.FindFirst();
                    ApplySelection(REIncident, LookupBuffer);
                end;
            else
                begin
                    if TryResolveSelectedContract(REIncident, LookupBuffer) then
                        exit;

                    Error(MultipleContractsFoundErr, REIncident."Contract No.", REIncident."Fixed Real Estate No.");
                end;
        end;
    end;

    procedure HandleFixedRealEstateChange(var REIncident: Record "Incident Assets Real Estate"; xREIncident: Record "Incident Assets Real Estate")
    begin
        if REIncident."Fixed Real Estate No." = xREIncident."Fixed Real Estate No." then
            exit;

        ClearContractFields(REIncident);
    end;

    local procedure BuildLookupBuffer(FixedRealEstateNo: Code[20]; var LookupBuffer: Record "RE Incident Contract Lookup" temporary)
    var
        Company: Record Company;
        LeaseContract: Record "Lease Contract";
        EntryNo: Integer;
    begin
        LookupBuffer.Reset();
        LookupBuffer.DeleteAll();
        EntryNo := 0;

        if not Company.FindSet() then
            exit;

        repeat
            LeaseContract.ChangeCompany(Company.Name);
            LeaseContract.Reset();
            if LeaseContract.FindSet() then
                repeat
                    if IsSelectableContract(LeaseContract, FixedRealEstateNo) then begin
                        EntryNo += 1;
                        InsertLookupEntry(LookupBuffer, EntryNo, Company.Name, LeaseContract);
                    end;
                until LeaseContract.Next() = 0;
        until Company.Next() = 0;
    end;

    local procedure FindMatchingContracts(FixedRealEstateNo: Code[20]; ContractNo: Code[20]; var LookupBuffer: Record "RE Incident Contract Lookup" temporary): Integer
    begin
        BuildLookupBuffer(FixedRealEstateNo, LookupBuffer);
        LookupBuffer.SetRange("Contract No.", ContractNo);
        exit(LookupBuffer.Count());
    end;

    local procedure InsertLookupEntry(var LookupBuffer: Record "RE Incident Contract Lookup" temporary; EntryNo: Integer; CompanyName: Text[30]; LeaseContract: Record "Lease Contract")
    begin
        LookupBuffer.Init();
        LookupBuffer."Entry No." := EntryNo;
        LookupBuffer."Company Name" := CompanyName;
        LookupBuffer."Contract No." := LeaseContract."Contract No.";
        LookupBuffer."Customer No." := LeaseContract."Customer No.";
        LookupBuffer."Contact No." := LeaseContract."Contact No.";
        LookupBuffer."Contract Contact Name" := CopyStr(LeaseContract."Contact Name", 1, MaxStrLen(LookupBuffer."Contract Contact Name"));
        LookupBuffer."Contact Phone No." := CopyStr(LeaseContract."Phone No.", 1, MaxStrLen(LookupBuffer."Contact Phone No."));
        LookupBuffer."Contact E-Mail" := CopyStr(LeaseContract."E-Mail", 1, MaxStrLen(LookupBuffer."Contact E-Mail"));
        LookupBuffer."Contract Phone No." := CopyStr(LeaseContract."Phone No. 2", 1, MaxStrLen(LookupBuffer."Contract Phone No."));
        LookupBuffer."Contract E-Mail" := CopyStr(LeaseContract."E-Mail 2", 1, MaxStrLen(LookupBuffer."Contract E-Mail"));
        LookupBuffer."Fixed Real Estate No." := FixedRealEstateNoFromContract(LeaseContract);
        LookupBuffer."Starting Date" := LeaseContract."Starting Date";
        LookupBuffer."Expiration Date" := LeaseContract."Expiration Date";
        LookupBuffer.Insert();
    end;

    local procedure ApplySelection(var REIncident: Record "Incident Assets Real Estate"; LookupBuffer: Record "RE Incident Contract Lookup" temporary)
    begin
        REIncident."Contract No." := LookupBuffer."Contract No.";
        REIncident."Customer No." := LookupBuffer."Customer No.";
        REIncident."Contact No" := LookupBuffer."Contact No.";
        REIncident."Contract - Contact Name" := LookupBuffer."Contract Contact Name";
        REIncident."Contact Phone No." := CopyStr(LookupBuffer."Contact Phone No.", 1, MaxStrLen(REIncident."Contact Phone No."));
        REIncident."Contact E-Mail" := CopyStr(LookupBuffer."Contact E-Mail", 1, MaxStrLen(REIncident."Contact E-Mail"));
        REIncident."Contract - Phone No." := CopyStr(LookupBuffer."Contract Phone No.", 1, MaxStrLen(REIncident."Contract - Phone No."));
        REIncident."Contract - EMail" := CopyStr(LookupBuffer."Contract E-Mail", 1, MaxStrLen(REIncident."Contract - EMail"));
    end;

    local procedure TryResolveSelectedContract(var REIncident: Record "Incident Assets Real Estate"; var LookupBuffer: Record "RE Incident Contract Lookup" temporary): Boolean
    var
        ResolvedBuffer: Record "RE Incident Contract Lookup" temporary;
        MatchCount: Integer;
    begin
        if LookupBuffer.FindSet() then
            repeat
                if MatchesCurrentSelection(REIncident, LookupBuffer) then begin
                    MatchCount += 1;
                    ResolvedBuffer := LookupBuffer;
                end;
            until LookupBuffer.Next() = 0;

        if MatchCount <> 1 then
            exit(false);

        ApplySelection(REIncident, ResolvedBuffer);
        exit(true);
    end;

    local procedure MatchesCurrentSelection(REIncident: Record "Incident Assets Real Estate"; LookupBuffer: Record "RE Incident Contract Lookup" temporary): Boolean
    begin
        exit(
          (LookupBuffer."Customer No." = REIncident."Customer No.") and
          (LookupBuffer."Contact No." = REIncident."Contact No") and
          (LookupBuffer."Contract Contact Name" = REIncident."Contract - Contact Name") and
          (CopyStr(LookupBuffer."Contact Phone No.", 1, MaxStrLen(REIncident."Contact Phone No.")) = REIncident."Contact Phone No.") and
          (CopyStr(LookupBuffer."Contact E-Mail", 1, MaxStrLen(REIncident."Contact E-Mail")) = REIncident."Contact E-Mail") and
          (CopyStr(LookupBuffer."Contract Phone No.", 1, MaxStrLen(REIncident."Contract - Phone No.")) = REIncident."Contract - Phone No.") and
          (CopyStr(LookupBuffer."Contract E-Mail", 1, MaxStrLen(REIncident."Contract - EMail")) = REIncident."Contract - EMail"));
    end;

    local procedure ClearContractFields(var REIncident: Record "Incident Assets Real Estate")
    begin
        REIncident."Contract No." := '';
        ClearDerivedContractFields(REIncident);
    end;

    local procedure ClearDerivedContractFields(var REIncident: Record "Incident Assets Real Estate")
    begin
        REIncident."Customer No." := '';
        REIncident."Contact No" := '';
        REIncident."Contract - Contact Name" := '';
        REIncident."Contact Phone No." := '';
        REIncident."Contact E-Mail" := '';
        REIncident."Contract - Phone No." := '';
        REIncident."Contract - EMail" := '';
    end;

    local procedure IsSelectableContract(LeaseContract: Record "Lease Contract"; FixedRealEstateNo: Code[20]): Boolean
    begin
        if not MatchesFixedRealEstate(LeaseContract, FixedRealEstateNo) then
            exit(false);

        if (LeaseContract."Starting Date" <> 0D) and (LeaseContract."Starting Date" > Today) then
            exit(false);

        if (LeaseContract."Expiration Date" <> 0D) and (LeaseContract."Expiration Date" < Today) then
            exit(false);

        exit(not IsClosedStatus(Format(LeaseContract.Status)));
    end;

    local procedure MatchesFixedRealEstate(LeaseContract: Record "Lease Contract"; FixedRealEstateNo: Code[20]): Boolean
    begin
        exit(
          (LeaseContract."Fixed Real Estate No." = FixedRealEstateNo) or
          (LeaseContract."FRE Property No." = FixedRealEstateNo));
    end;

    local procedure FixedRealEstateNoFromContract(LeaseContract: Record "Lease Contract"): Code[20]
    begin
        if LeaseContract."Fixed Real Estate No." <> '' then
            exit(LeaseContract."Fixed Real Estate No.");

        exit(LeaseContract."FRE Property No.");
    end;

    local procedure IsClosedStatus(StatusText: Text): Boolean
    var
        UpperStatusText: Text;
    begin
        UpperStatusText := UpperCase(StatusText);
        exit(
          (StrPos(UpperStatusText, 'CANCEL') > 0) or
          (StrPos(UpperStatusText, 'FINAL') > 0) or
          (StrPos(UpperStatusText, 'FINISH') > 0));
    end;

    var
        NoActiveContractsFoundMsg: Label 'No hay contratos de alquiler vigentes para el activo inmobiliario %1.';
        MultipleContractsFoundErr: Label 'Se ha encontrado mas de un contrato vigente con el numero %1 para el activo inmobiliario %2. Seleccione el contrato desde la lista.';
}
