codeunit 96923 "OD AM Lease Wizard Mgt."
{
    procedure RunWizard(FixedRealEstate: Record "Fixed Real Estate")
    var
        WizardBuffer: Record "OD AM Lease Wizard Buffer";
        WizardPage: Page "OD AM Lease Contract Wizard";
    begin
        InitializeWizard(FixedRealEstate, WizardBuffer);
        Commit();
        WizardPage.SetWizard(WizardBuffer."Wizard Id");
        WizardPage.RunModal();
    end;

    procedure InitializeWizard(FixedRealEstate: Record "Fixed Real Estate"; var WizardBuffer: Record "OD AM Lease Wizard Buffer")
    var
        WizardUnit: Record "OD AM Lease Wizard Unit";
    begin
        FixedRealEstate.TestField("No.");
        FixedRealEstate.TestField(Type, FixedRealEstate.Type::Activo);

        Clear(WizardBuffer);
        WizardBuffer.Init();
        WizardBuffer."Wizard Id" := CreateGuid();
        WizardBuffer.Validate("Fixed Real Estate No.", FixedRealEstate."No.");
        WizardBuffer.Description := CopyStr(StrSubstNo('Contrato %1', FixedRealEstate.Description), 1, MaxStrLen(WizardBuffer.Description));
        WizardBuffer."Starting Date" := WorkDate();
        WizardBuffer."Contract Date" := WorkDate();
        WizardBuffer."Ending Date" := CalcDate('<1Y>', WorkDate());
        WizardBuffer."Invoice Period" := WizardBuffer."Invoice Period"::Month;
        WizardBuffer.Insert(true);

        WizardUnit.Init();
        WizardUnit."Wizard Id" := WizardBuffer."Wizard Id";
        WizardUnit.Validate("Fixed Real Estate No.", FixedRealEstate."No.");
        WizardUnit.Validate(Role, WizardUnit.Role::Principal);
        WizardUnit.Validate("Starting Date", WizardBuffer."Starting Date");
        WizardUnit.Validate("Ending Date", WizardBuffer."Ending Date");
        WizardUnit.Insert(true);
    end;

    procedure EnsureDefaultContractLines(WizardId: Guid)
    var
        WizardBuffer: Record "OD AM Lease Wizard Buffer";
        WizardLine: Record "OD AM Lease Wizard Line";
        FixedRealEstate: Record "Fixed Real Estate";
        REFSetup: Record "REF Setup";
    begin
        WizardLine.SetRange("Wizard Id", WizardId);
        if not WizardLine.IsEmpty() then
            exit;

        if not WizardBuffer.Get(WizardId) then
            exit;

        if not FixedRealEstate.Get(WizardBuffer."Fixed Real Estate No.") then
            exit;

        REFSetup.Get();
        REFSetup.TestField("Service Charge Acc.");

        WizardLine.Init();
        WizardLine."Wizard Id" := WizardId;
        WizardLine.Validate(Type, WizardLine.Type::"G/L Account");
        WizardLine.Validate("Account No.", REFSetup."Service Charge Acc.");
        WizardLine.Validate(Description, CopyStr(FixedRealEstate.Description, 1, MaxStrLen(WizardLine.Description)));
        WizardLine."Starting Date" := WizardBuffer."Starting Date";
        WizardLine."Contract Expiration Date" := WizardBuffer."Ending Date";
        WizardLine."Service Period" := LeasePeriodFromInvoicePeriod(WizardBuffer."Invoice Period");
        WizardLine.Validate(Value, FixedRealEstate."Last Rental Price");
        WizardLine.Insert(true);
    end;

    procedure ValidateWizard(WizardId: Guid)
    var
        WizardBuffer: Record "OD AM Lease Wizard Buffer";
        WizardUnit: Record "OD AM Lease Wizard Unit";
        WizardLine: Record "OD AM Lease Wizard Line";
        FixedRealEstate: Record "Fixed Real Estate";
        PrincipalCount: Integer;
    begin
        WizardBuffer.Get(WizardId);
        WizardBuffer.TestField("Fixed Real Estate No.");
        WizardBuffer.TestField("Customer No.");
        WizardBuffer.TestField("Starting Date");

        if FixedRealEstate.Get(WizardBuffer."Fixed Real Estate No.") then
            if FixedRealEstate.Blocked then
                Error(AssetBlockedErr, WizardBuffer."Fixed Real Estate No.");

        if (WizardBuffer."Ending Date" <> 0D) and (WizardBuffer."Ending Date" < WizardBuffer."Starting Date") then
            Error(InvalidDatesErr);

        WizardUnit.SetRange("Wizard Id", WizardId);
        if WizardUnit.IsEmpty() then
            Error(MissingUnitsErr);

        WizardUnit.SetRange(Role, WizardUnit.Role::Principal);
        PrincipalCount := WizardUnit.Count();
        if PrincipalCount <> 1 then
            Error(PrincipalUnitErr);
        WizardUnit.SetRange(Role);

        if WizardUnit.FindSet() then
            repeat
                WizardUnit.TestField("Fixed Real Estate No.");
                if (WizardUnit."Starting Date" <> 0D) and (WizardUnit."Ending Date" <> 0D) and
                   (WizardUnit."Ending Date" < WizardUnit."Starting Date")
                then
                    Error(UnitDatesErr, WizardUnit."Fixed Real Estate No.");
                CheckDuplicateUnit(WizardUnit);
            until WizardUnit.Next() = 0;

        WizardLine.SetRange("Wizard Id", WizardId);
        if WizardLine.IsEmpty() then
            Error(MissingLinesErr);

        if WizardLine.FindSet() then
            repeat
                if WizardLine.Type = WizardLine.Type::" " then
                    Error(LineTypeErr, WizardLine."Line No.");
                WizardLine.TestField("Account No.");
                WizardLine.TestField(Description);
            until WizardLine.Next() = 0;
    end;

    procedure CreateLeaseContract(WizardId: Guid): Code[20]
    var
        WizardBuffer: Record "OD AM Lease Wizard Buffer";
        LeaseContract: Record "Lease Contract";
        RealEstateManagement: Codeunit "Real Estate Management";
    begin
        ValidateWizard(WizardId);
        WizardBuffer.Get(WizardId);

        CreateContractHeader(WizardBuffer, LeaseContract);
        CreateContractUnits(WizardId, LeaseContract);
        CreateContractLines(WizardId, LeaseContract);

        LeaseContract."Amount per Period" :=
            RealEstateManagement.CalcContractAmount(LeaseContract, LeaseContract."Starting Date", LeaseContract."Expiration Date");
        LeaseContract."Annual Amount" := LeaseContract."Amount per Period" * 12;
        LeaseContract.Modify(true);

        if WizardBuffer.Status = WizardBuffer.Status::Signed then
            RealEstateManagement.SignContract(LeaseContract);

        WizardBuffer."Created Contract No." := LeaseContract."Contract No.";
        WizardBuffer.Modify(true);

        exit(LeaseContract."Contract No.");
    end;

    procedure OpenLeaseContract(ContractNo: Code[20])
    var
        LeaseContract: Record "Lease Contract";
    begin
        if not LeaseContract.Get(ContractNo) then
            exit;

        Page.Run(Page::"Lease Contract Card", LeaseContract);
    end;

    procedure DeleteWizardData(WizardId: Guid)
    var
        WizardBuffer: Record "OD AM Lease Wizard Buffer";
        WizardUnit: Record "OD AM Lease Wizard Unit";
        WizardLine: Record "OD AM Lease Wizard Line";
    begin
        WizardUnit.SetRange("Wizard Id", WizardId);
        if not WizardUnit.IsEmpty() then
            WizardUnit.DeleteAll(true);

        WizardLine.SetRange("Wizard Id", WizardId);
        if not WizardLine.IsEmpty() then
            WizardLine.DeleteAll(true);

        if WizardBuffer.Get(WizardId) then
            WizardBuffer.Delete(true);
    end;

    procedure BuildSummary(WizardId: Guid; var SummaryText: Text; var PeriodicAmount: Decimal; var AnnualAmount: Decimal)
    var
        WizardBuffer: Record "OD AM Lease Wizard Buffer";
        WizardUnit: Record "OD AM Lease Wizard Unit";
        WizardLine: Record "OD AM Lease Wizard Line";
        UnitsText: Text;
    begin
        Clear(SummaryText);
        Clear(PeriodicAmount);
        Clear(AnnualAmount);

        if not WizardBuffer.Get(WizardId) then
            exit;

        WizardUnit.SetRange("Wizard Id", WizardId);
        if WizardUnit.FindSet() then
            repeat
                if UnitsText <> '' then
                    UnitsText += ', ';
                UnitsText += StrSubstNo('%1 (%2)', WizardUnit."Fixed Real Estate No.", Format(WizardUnit.Role));
            until WizardUnit.Next() = 0;

        WizardLine.SetRange("Wizard Id", WizardId);
        if WizardLine.FindSet() then
            repeat
                PeriodicAmount += WizardLine."VAT Base Amount";
            until WizardLine.Next() = 0;

        AnnualAmount := PeriodicAmount * 12;
        SummaryText :=
            StrSubstNo(
                'Activo principal: %1 - %2\Unidades: %3\Arrendatario: %4 - %5\Inicio: %6\Fin: %7\Periodicidad: %8',
                WizardBuffer."Fixed Real Estate No.",
                WizardBuffer."Fixed Real Estate Description",
                UnitsText,
                WizardBuffer."Customer No.",
                WizardBuffer."Customer Name",
                Format(WizardBuffer."Starting Date"),
                Format(WizardBuffer."Ending Date"),
                Format(WizardBuffer."Invoice Period"));
    end;

    local procedure CreateContractHeader(WizardBuffer: Record "OD AM Lease Wizard Buffer"; var LeaseContract: Record "Lease Contract")
    begin
        LeaseContract.Init();
        LeaseContract.Insert(true);
        LeaseContract.Validate(Description, WizardBuffer.Description);
        LeaseContract.Validate("Customer No.", WizardBuffer."Customer No.");
        LeaseContract.Validate("Fixed Real Estate No.", WizardBuffer."Fixed Real Estate No.");

        if WizardBuffer."Contract Date" <> 0D then
            LeaseContract.Validate("Contract Date", WizardBuffer."Contract Date")
        else
            LeaseContract.Validate("Contract Date", WizardBuffer."Starting Date");

        LeaseContract.Validate("Starting Date", WizardBuffer."Starting Date");

        if WizardBuffer."Ending Date" <> 0D then
            LeaseContract.Validate("Expiration Date", WizardBuffer."Ending Date");

        LeaseContract.Validate("Invoice Period", ConvertInvoicePeriod(WizardBuffer."Invoice Period", LeaseContract));

        if WizardBuffer."Payment Method Code" <> '' then
            LeaseContract.Validate("Payment Method Code", WizardBuffer."Payment Method Code");

        if WizardBuffer."Payment Terms Code" <> '' then
            LeaseContract.Validate("Payment Terms Code", WizardBuffer."Payment Terms Code");

        LeaseContract.Modify(true);
    end;

    local procedure CreateContractUnits(WizardId: Guid; var LeaseContract: Record "Lease Contract")
    var
        WizardUnit: Record "OD AM Lease Wizard Unit";
        ContractAssetMgt: Codeunit "OD AM Contract Asset Mgt.";
        ContractUnit: Record "OD AM Lease Contract Unit";
    begin
        ContractAssetMgt.SyncPrincipalAsset(LeaseContract);

        WizardUnit.SetRange("Wizard Id", WizardId);
        if not WizardUnit.FindSet() then
            exit;

        repeat
            if WizardUnit.Role = WizardUnit.Role::Principal then begin
                ContractUnit.SetRange("Contract No.", LeaseContract."Contract No.");
                ContractUnit.SetRange(Role, ContractUnit.Role::Principal);
                if ContractUnit.FindFirst() then begin
                    ContractUnit.Validate("Starting Date", WizardUnit."Starting Date");
                    ContractUnit.Validate("Ending Date", WizardUnit."Ending Date");
                    ContractUnit.Validate("Monthly Rent", WizardUnit."Monthly Rent");
                    ContractUnit.Modify(true);
                end;
            end else begin
                ContractAssetMgt.AddAssetToContract(LeaseContract."Contract No.", WizardUnit."Fixed Real Estate No.", WizardUnit.Role);
                ContractUnit.Reset();
                ContractUnit.SetRange("Contract No.", LeaseContract."Contract No.");
                ContractUnit.SetRange("Fixed Real Estate No.", WizardUnit."Fixed Real Estate No.");
                if ContractUnit.FindFirst() then begin
                    ContractUnit.Validate("Starting Date", WizardUnit."Starting Date");
                    ContractUnit.Validate("Ending Date", WizardUnit."Ending Date");
                    ContractUnit.Validate("Monthly Rent", WizardUnit."Monthly Rent");
                    ContractUnit.Modify(true);
                end;
            end;
        until WizardUnit.Next() = 0;
    end;

    local procedure CreateContractLines(WizardId: Guid; LeaseContract: Record "Lease Contract")
    var
        WizardLine: Record "OD AM Lease Wizard Line";
        LeaseContractLine: Record "Lease Contract Line";
    begin
        WizardLine.SetRange("Wizard Id", WizardId);
        if not WizardLine.FindSet() then
            exit;

        repeat
            LeaseContractLine.Init();
            LeaseContractLine."Contract No." := LeaseContract."Contract No.";
            LeaseContractLine."Line No." := WizardLine."Line No.";
            LeaseContractLine.Description := WizardLine.Description;
            LeaseContractLine.Insert(true);
            LeaseContractLine.Validate(Type, WizardLine.Type);
            LeaseContractLine.Validate("Account No.", WizardLine."Account No.");
            LeaseContractLine.Validate(Description, WizardLine.Description);
            LeaseContractLine."Customer No." := LeaseContract."Customer No.";
            LeaseContractLine."Contract Status" := LeaseContract.Status;
            LeaseContractLine."Contract Expiration Date" := WizardLine."Contract Expiration Date";
            LeaseContractLine."Service Period" := WizardLine."Service Period";
            LeaseContractLine."Starting Date" := WizardLine."Starting Date";
            LeaseContractLine."Credit Memo Date" := WizardLine."Credit Memo Date";
            LeaseContractLine."Unit of Measure Code" := WizardLine."Unit of Measure Code";
            LeaseContractLine."Response Time (Hours)" := WizardLine."Response Time (Hours)";
            LeaseContractLine."Shortcut Dimension 1 Code" := WizardLine."Shortcut Dimension 1 Code";
            LeaseContractLine."Shortcut Dimension 2 Code" := WizardLine."Shortcut Dimension 2 Code";
            LeaseContractLine."Dimension Set ID" := WizardLine."Dimension Set ID";
            LeaseContractLine."Aplicar incrementos" := WizardLine."Aplicar incrementos";
            LeaseContractLine."Base Contract" := WizardLine."Base Contract";
            LeaseContractLine."Aplicar Impuestos" := WizardLine."Aplicar Impuestos";
            LeaseContractLine."Consumer Price Index Category" := WizardLine."Consumer Price Index Category";
            LeaseContractLine.Year := WizardLine.Year;
            LeaseContractLine."% Increment" := WizardLine."% Increment";
            LeaseContractLine."CPI calculation amount" := WizardLine."CPI calculation amount";

            if WizardLine."VAT Bus. Posting Group" <> '' then
                LeaseContractLine.Validate("VAT Bus. Posting Group", WizardLine."VAT Bus. Posting Group");
            if WizardLine."VAT Prod. Posting Group" <> '' then
                LeaseContractLine.Validate("VAT Prod. Posting Group", WizardLine."VAT Prod. Posting Group");

            LeaseContractLine.Validate(Value, WizardLine.Value);
            LeaseContractLine.Modify(true);
        until WizardLine.Next() = 0;
    end;

    local procedure ConvertInvoicePeriod(WizardInvoicePeriod: Option Month,"Two Months",Quarter,"Half Year",Year,"None"; LeaseContract: Record "Lease Contract"): Integer
    begin
        case WizardInvoicePeriod of
            WizardInvoicePeriod::Month:
                exit(LeaseContract."Invoice Period"::Month);
            WizardInvoicePeriod::"Two Months":
                exit(LeaseContract."Invoice Period"::"Two Months");
            WizardInvoicePeriod::Quarter:
                exit(LeaseContract."Invoice Period"::Quarter);
            WizardInvoicePeriod::"Half Year":
                exit(LeaseContract."Invoice Period"::"Half Year");
            WizardInvoicePeriod::Year:
                exit(LeaseContract."Invoice Period"::Year);
            WizardInvoicePeriod::"None":
                exit(LeaseContract."Invoice Period"::"None");
        end;
    end;

    local procedure LeasePeriodFromInvoicePeriod(WizardInvoicePeriod: Option Month,"Two Months",Quarter,"Half Year",Year,"None"): DateFormula
    var
        LeasePeriod: DateFormula;
    begin
        case WizardInvoicePeriod of
            WizardInvoicePeriod::Month:
                Evaluate(LeasePeriod, '1M');
            WizardInvoicePeriod::"Two Months":
                Evaluate(LeasePeriod, '2M');
            WizardInvoicePeriod::Quarter:
                Evaluate(LeasePeriod, '3M');
            WizardInvoicePeriod::"Half Year":
                Evaluate(LeasePeriod, '6M');
            WizardInvoicePeriod::Year:
                Evaluate(LeasePeriod, '1Y');
            else
                Clear(LeasePeriod);
        end;

        exit(LeasePeriod);
    end;

    local procedure CheckDuplicateUnit(CurrentUnit: Record "OD AM Lease Wizard Unit")
    var
        WizardUnit: Record "OD AM Lease Wizard Unit";
    begin
        WizardUnit.SetRange("Wizard Id", CurrentUnit."Wizard Id");
        WizardUnit.SetRange("Fixed Real Estate No.", CurrentUnit."Fixed Real Estate No.");
        WizardUnit.SetFilter("Line No.", '<>%1', CurrentUnit."Line No.");
        if not WizardUnit.IsEmpty() then
            Error(DuplicateUnitErr, CurrentUnit."Fixed Real Estate No.");
    end;

    var
        MissingUnitsErr: Label 'Debe existir al menos una unidad contractual.';
        PrincipalUnitErr: Label 'Debe existir exactamente una unidad principal.';
        MissingLinesErr: Label 'Debe existir al menos una linea contractual valida.';
        DuplicateUnitErr: Label 'El activo %1 esta duplicado dentro del wizard.';
        InvalidDatesErr: Label 'La fecha fin no puede ser anterior a la fecha inicio.';
        UnitDatesErr: Label 'La unidad %1 tiene un rango de fechas invalido.';
        AssetBlockedErr: Label 'El activo %1 esta bloqueado y no se puede usar para crear contratos.';
        LineTypeErr: Label 'La linea %1 debe indicar un tipo contractual valido.';
}
