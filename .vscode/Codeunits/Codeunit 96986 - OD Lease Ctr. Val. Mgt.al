codeunit 96986 "OD Lease Ctr. Val. Mgt."
{
    procedure BuildLeaseContractValidationBuffer(var LeaseContract: Record "Lease Contract"; var TempValidationBuffer: Record 96044 temporary)
    var
        FixedRealEstate: Record "Fixed Real Estate";
        LeaseContractLine: Record "Lease Contract Line";
        RealEstateManagement: Codeunit "Real Estate Management";
        ExpectedAmountPerPeriod: Decimal;
        ExpectedAnnualAmount: Decimal;
    begin
        TempValidationBuffer.Reset();
        TempValidationBuffer.DeleteAll();

        if LeaseContract."Contract No." = '' then begin
            AddIssue(TempValidationBuffer, '', TempValidationBuffer."Issue Type"::General, 0, ContractMustBeSavedErr);
            exit;
        end;

        LeaseContract.CalcFields("Description Fixed Real Estate", Name);

        if LeaseContract.Description = '' then
            AddIssue(TempValidationBuffer, LeaseContract."Contract No.", TempValidationBuffer."Issue Type"::Header, 0, MissingContractDescriptionErr);
        if LeaseContract."Customer No." = '' then
            AddIssue(TempValidationBuffer, LeaseContract."Contract No.", TempValidationBuffer."Issue Type"::Header, 0, MissingCustomerErr);
        if LeaseContract."Contact No." = '' then
            AddIssue(TempValidationBuffer, LeaseContract."Contract No.", TempValidationBuffer."Issue Type"::Header, 0, MissingContactErr);
        if LeaseContract."Fixed Real Estate No." = '' then
            AddIssue(TempValidationBuffer, LeaseContract."Contract No.", TempValidationBuffer."Issue Type"::Header, 0, MissingAssetErr);
        if LeaseContract."Description Fixed Real Estate" = '' then
            AddIssue(TempValidationBuffer, LeaseContract."Contract No.", TempValidationBuffer."Issue Type"::Header, 0, MissingAssetDescriptionErr);
        if LeaseContract."Starting Date" = 0D then
            AddIssue(TempValidationBuffer, LeaseContract."Contract No.", TempValidationBuffer."Issue Type"::Header, 0, MissingStartingDateErr);
        if (LeaseContract."Expiration Date" = 0D) and (Format(LeaseContract."Lease Period") = '') then
            AddIssue(TempValidationBuffer, LeaseContract."Contract No.", TempValidationBuffer."Issue Type"::Header, 0, MissingExpirationOrPeriodErr);
        if (LeaseContract."Starting Date" <> 0D) and
           (LeaseContract."Expiration Date" <> 0D) and
           (LeaseContract."Expiration Date" < LeaseContract."Starting Date")
        then
            AddIssue(TempValidationBuffer, LeaseContract."Contract No.", TempValidationBuffer."Issue Type"::Header, 0, InvalidExpirationDateErr);
        if LeaseContract."Salesperson Code" = '' then
            AddIssue(TempValidationBuffer, LeaseContract."Contract No.", TempValidationBuffer."Issue Type"::Header, 0, MissingSalespersonErr);
        if LeaseContract."Payment Method Code" = '' then
            AddIssue(TempValidationBuffer, LeaseContract."Contract No.", TempValidationBuffer."Issue Type"::Header, 0, MissingPaymentMethodErr);
        if LeaseContract."Payment Terms Code" = '' then
            AddIssue(TempValidationBuffer, LeaseContract."Contract No.", TempValidationBuffer."Issue Type"::Header, 0, MissingPaymentTermsErr);
        if LeaseContract."Preferred Bank Account Code" = '' then
            AddIssue(TempValidationBuffer, LeaseContract."Contract No.", TempValidationBuffer."Issue Type"::Header, 0, MissingPreferredBankErr);

        if (LeaseContract."Fixed Real Estate No." <> '') and (not FixedRealEstate.Get(LeaseContract."Fixed Real Estate No.")) then
            AddIssue(
              TempValidationBuffer,
              LeaseContract."Contract No.",
              TempValidationBuffer."Issue Type"::Header,
              0,
              StrSubstNo(MissingAssetRecordErr, LeaseContract."Fixed Real Estate No."));

        LeaseContractLine.Reset();
        LeaseContractLine.SetRange("Contract No.", LeaseContract."Contract No.");
        if LeaseContractLine.IsEmpty() then
            AddIssue(TempValidationBuffer, LeaseContract."Contract No.", TempValidationBuffer."Issue Type"::Line, 0, MissingEconomicLinesErr)
        else
            if LeaseContractLine.FindSet() then
                repeat
                    if LeaseContractLine.Type = LeaseContractLine.Type::" " then begin
                        if LeaseContractLine.Description = '' then
                            AddIssue(TempValidationBuffer, LeaseContract."Contract No.", TempValidationBuffer."Issue Type"::Line, LeaseContractLine."Line No.", StrSubstNo(MissingLineDescriptionErr, LeaseContractLine."Line No."));
                    end else begin
                        if LeaseContractLine."Account No." = '' then
                            AddIssue(TempValidationBuffer, LeaseContract."Contract No.", TempValidationBuffer."Issue Type"::Line, LeaseContractLine."Line No.", StrSubstNo(MissingLineAccountErr, LeaseContractLine."Line No."));
                        if LeaseContractLine.Description = '' then
                            AddIssue(TempValidationBuffer, LeaseContract."Contract No.", TempValidationBuffer."Issue Type"::Line, LeaseContractLine."Line No.", StrSubstNo(MissingLineDescriptionErr, LeaseContractLine."Line No."));
                        if LeaseContractLine.Amount = 0 then
                            AddIssue(TempValidationBuffer, LeaseContract."Contract No.", TempValidationBuffer."Issue Type"::Line, LeaseContractLine."Line No.", StrSubstNo(ZeroLineAmountErr, LeaseContractLine."Line No."));
                    end;
                    if (LeaseContractLine."Starting Date" <> 0D) and
                       (LeaseContractLine."Contract Expiration Date" <> 0D) and
                       (LeaseContractLine."Contract Expiration Date" < LeaseContractLine."Starting Date")
                    then
                        AddIssue(TempValidationBuffer, LeaseContract."Contract No.", TempValidationBuffer."Issue Type"::Line, LeaseContractLine."Line No.", StrSubstNo(InvalidLineDatesErr, LeaseContractLine."Line No."));
                    if (LeaseContractLine.Type = LeaseContractLine.Type::"G/L Account") and
                       (LeaseContractLine."VAT Prod. Posting Group" = '')
                    then
                        AddIssue(TempValidationBuffer, LeaseContract."Contract No.", TempValidationBuffer."Issue Type"::Line, LeaseContractLine."Line No.", StrSubstNo(MissingVatProdPostingGroupErr, LeaseContractLine."Line No."));
                    if LeaseContractLine."Aplicar Impuestos" and (LeaseContract."Grupo IRPF" = '') then
                        AddIssue(TempValidationBuffer, LeaseContract."Contract No.", TempValidationBuffer."Issue Type"::Line, LeaseContractLine."Line No.", StrSubstNo(MissingIRPFGroupErr, LeaseContractLine."Line No."));
                    if LeaseContractLine."Aplicar incrementos" and (LeaseContract."Consumer Price Index Category" = '') then
                        AddIssue(TempValidationBuffer, LeaseContract."Contract No.", TempValidationBuffer."Issue Type"::Line, LeaseContractLine."Line No.", StrSubstNo(MissingIPCGroupErr, LeaseContractLine."Line No."));
                until LeaseContractLine.Next() = 0;

        if (LeaseContract."Starting Date" <> 0D) and (LeaseContract."Expiration Date" <> 0D) then begin
            ExpectedAmountPerPeriod := RealEstateManagement.CalcContractAmount(LeaseContract, LeaseContract."Starting Date", LeaseContract."Expiration Date");
            ExpectedAnnualAmount := ExpectedAmountPerPeriod * 12;

            if ExpectedAmountPerPeriod <= 0 then
                AddIssue(TempValidationBuffer, LeaseContract."Contract No.", TempValidationBuffer."Issue Type"::Amount, 0, NonPositiveCalculatedAmountErr);

            if LeaseContract."Amount per Period" <> ExpectedAmountPerPeriod then
                AddIssue(
                  TempValidationBuffer,
                  LeaseContract."Contract No.",
                  TempValidationBuffer."Issue Type"::Amount,
                  0,
                  StrSubstNo(AmountPerPeriodMismatchErr, LeaseContract."Amount per Period", ExpectedAmountPerPeriod));

            if LeaseContract."Annual Amount" <> ExpectedAnnualAmount then
                AddIssue(
                  TempValidationBuffer,
                  LeaseContract."Contract No.",
                  TempValidationBuffer."Issue Type"::Amount,
                  0,
                  StrSubstNo(AnnualAmountMismatchErr, LeaseContract."Annual Amount", ExpectedAnnualAmount));
        end;
    end;

    local procedure AddIssue(var TempValidationBuffer: Record 96044 temporary; ContractNo: Code[20]; IssueType: Option General,Header,Line,Amount; RelatedLineNo: Integer; IssueMessage: Text)
    begin
        if IssueMessage = '' then
            exit;

        TempValidationBuffer.Init();
        TempValidationBuffer."Line No." := TempValidationBuffer.Count + 1;
        TempValidationBuffer."Contract No." := ContractNo;
        TempValidationBuffer."Issue Type" := IssueType;
        TempValidationBuffer."Related Line No." := RelatedLineNo;
        TempValidationBuffer.Message := CopyStr(IssueMessage, 1, MaxStrLen(TempValidationBuffer.Message));
        TempValidationBuffer.Insert();
    end;

    var
        ContractMustBeSavedErr: Label 'El contrato debe estar guardado antes de poder comprobarlo.';
        MissingContractDescriptionErr: Label 'Falta la descripción del contrato.';
        MissingCustomerErr: Label 'Falta el arrendador principal (Customer No.).';
        MissingContactErr: Label 'Falta el contacto principal del contrato.';
        MissingAssetErr: Label 'Falta el activo inmobiliario principal.';
        MissingAssetDescriptionErr: Label 'No se ha resuelto la descripción del activo inmobiliario.';
        MissingStartingDateErr: Label 'Falta la fecha de inicio.';
        MissingExpirationOrPeriodErr: Label 'Debe informar la fecha de vencimiento o el periodo del contrato.';
        InvalidExpirationDateErr: Label 'La fecha de vencimiento no puede ser anterior a la fecha de inicio.';
        MissingSalespersonErr: Label 'Falta el comercial responsable.';
        MissingPaymentMethodErr: Label 'Falta la forma de pago.';
        MissingPaymentTermsErr: Label 'Faltan los términos de pago.';
        MissingPreferredBankErr: Label 'Falta la cuenta bancaria preferida para el cobro/pago del contrato.';
        MissingAssetRecordErr: Label 'No existe el activo inmobiliario %1.';
        MissingEconomicLinesErr: Label 'El contrato no tiene líneas económicas.';
        MissingLineAccountErr: Label 'La línea %1 no tiene cuenta o recurso contable informado.';
        MissingLineDescriptionErr: Label 'La línea %1 no tiene descripción.';
        ZeroLineAmountErr: Label 'La línea %1 tiene importe 0.';
        InvalidLineDatesErr: Label 'La línea %1 tiene una fecha de fin anterior a la fecha de inicio.';
        MissingVatProdPostingGroupErr: Label 'La línea %1 no tiene grupo registro IVA producto.';
        MissingIRPFGroupErr: Label 'La línea %1 aplica impuestos pero el contrato no tiene grupo IRPF.';
        MissingIPCGroupErr: Label 'La línea %1 aplica incrementos pero el contrato no tiene categoría IPC.';
        NonPositiveCalculatedAmountErr: Label 'El importe calculado del contrato es 0 o negativo. Revise las líneas económicas.';
        AmountPerPeriodMismatchErr: Label 'El importe por periodo no está sincronizado. Actual: %1. Calculado: %2.';
        AnnualAmountMismatchErr: Label 'El importe anual no está sincronizado. Actual: %1. Calculado: %2.';
}
