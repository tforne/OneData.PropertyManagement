codeunit 96947 "OD AM Contract Asset Mgt."
{
    procedure AddPrincipalAssetFromContract(var LeaseContract: Record "Lease Contract")
    begin
        SyncPrincipalAsset(LeaseContract);
    end;

    procedure AddAssetToContract(ContractNo: Code[20]; FixedRealEstateNo: Code[20]; Role: Enum "OD Contract Unit Role")
    var
        LeaseContract: Record "Lease Contract";
        ContractUnit: Record "OD AM Lease Contract Unit";
    begin
        if ContractNo = '' then
            Error(ContractNoRequiredErr);
        if FixedRealEstateNo = '' then
            Error(FixedRealEstateNoRequiredErr);

        LeaseContract.Get(ContractNo);

        if Role = Role::Principal then
            Error(PrincipalCreationErr);

        ValidateUnitCompatibility(LeaseContract, FixedRealEstateNo, Role, 0);

        ContractUnit.Init();
        ContractUnit.Validate("Contract No.", ContractNo);
        ContractUnit.Validate("Fixed Real Estate No.", FixedRealEstateNo);
        ContractUnit.Validate(Role, Role);
        ContractUnit.Insert(true);
    end;

    procedure RemoveAssetFromContract(ContractNo: Code[20]; FixedRealEstateNo: Code[20])
    var
        ContractUnit: Record "OD AM Lease Contract Unit";
        LeaseContract: Record "Lease Contract";
    begin
        ContractUnit.SetRange("Contract No.", ContractNo);
        ContractUnit.SetRange("Fixed Real Estate No.", FixedRealEstateNo);
        if not ContractUnit.FindFirst() then
            exit;

        if LeaseContract.Get(ContractNo) and
           (ContractUnit.Role = ContractUnit.Role::Principal) and
           (LeaseContract."Fixed Real Estate No." = FixedRealEstateNo)
        then
            Error(CannotDeletePrincipalErr, ContractNo);

        ContractUnit.Delete();
    end;

    procedure DeleteAllUnitsForContract(ContractNo: Code[20])
    var
        ContractUnit: Record "OD AM Lease Contract Unit";
    begin
        ContractUnit.SetRange("Contract No.", ContractNo);
        if not ContractUnit.IsEmpty() then
            ContractUnit.DeleteAll();
    end;

    procedure GetPrincipalAsset(ContractNo: Code[20]; var FixedRealEstate: Record "Fixed Real Estate"): Boolean
    var
        ContractUnit: Record "OD AM Lease Contract Unit";
        LeaseContract: Record "Lease Contract";
    begin
        ContractUnit.SetRange("Contract No.", ContractNo);
        ContractUnit.SetRange(Role, ContractUnit.Role::Principal);
        if ContractUnit.FindFirst() then
            exit(FixedRealEstate.Get(ContractUnit."Fixed Real Estate No."));

        if not LeaseContract.Get(ContractNo) then
            exit(false);
        if LeaseContract."Fixed Real Estate No." = '' then
            exit(false);

        exit(FixedRealEstate.Get(LeaseContract."Fixed Real Estate No."));
    end;

    procedure GetAssetCount(ContractNo: Code[20]): Integer
    var
        ContractUnit: Record "OD AM Lease Contract Unit";
        LeaseContract: Record "Lease Contract";
    begin
        ContractUnit.SetRange("Contract No.", ContractNo);
        if not ContractUnit.IsEmpty() then
            exit(ContractUnit.Count());

        if LeaseContract.Get(ContractNo) and (LeaseContract."Fixed Real Estate No." <> '') then
            exit(1);

        exit(0);
    end;

    procedure SyncPrincipalAsset(var LeaseContract: Record "Lease Contract")
    var
        PrincipalUnit: Record "OD AM Lease Contract Unit";
        ExistingMatchingUnit: Record "OD AM Lease Contract Unit";
        CurrentLineNo: Integer;
    begin
        if LeaseContract."Contract No." = '' then
            exit;

        EnsureSinglePrincipalLine(LeaseContract."Contract No.");

        if LeaseContract."Fixed Real Estate No." = '' then begin
            if GetAssetCount(LeaseContract."Contract No.") > 0 then
                Error(ContractRequiresPrincipalErr, LeaseContract."Contract No.");
            exit;
        end;

        PrincipalUnit.SetRange("Contract No.", LeaseContract."Contract No.");
        PrincipalUnit.SetRange(Role, PrincipalUnit.Role::Principal);
        if PrincipalUnit.FindFirst() then
            CurrentLineNo := PrincipalUnit."Line No.";

        ExistingMatchingUnit.SetRange("Contract No.", LeaseContract."Contract No.");
        ExistingMatchingUnit.SetRange("Fixed Real Estate No.", LeaseContract."Fixed Real Estate No.");
        if (CurrentLineNo = 0) and ExistingMatchingUnit.FindFirst() then
            CurrentLineNo := ExistingMatchingUnit."Line No.";

        ValidateUnitCompatibility(LeaseContract, LeaseContract."Fixed Real Estate No.", PrincipalUnit.Role::Principal, CurrentLineNo);

        if PrincipalUnit.FindFirst() then begin
            PrincipalUnit.Validate("Fixed Real Estate No.", LeaseContract."Fixed Real Estate No.");
            PrincipalUnit.Validate(Role, PrincipalUnit.Role::Principal);
            PrincipalUnit.Validate("Starting Date", LeaseContract."Starting Date");
            PrincipalUnit.Validate("Ending Date", LeaseContract."Expiration Date");
            PrincipalUnit.Modify(true);
            exit;
        end;

        if ExistingMatchingUnit.FindFirst() then begin
            ExistingMatchingUnit.Validate(Role, ExistingMatchingUnit.Role::Principal);
            ExistingMatchingUnit.Validate("Starting Date", LeaseContract."Starting Date");
            ExistingMatchingUnit.Validate("Ending Date", LeaseContract."Expiration Date");
            ExistingMatchingUnit.Modify(true);
            exit;
        end;

        PrincipalUnit.Init();
        PrincipalUnit.Validate("Contract No.", LeaseContract."Contract No.");
        PrincipalUnit.Validate("Fixed Real Estate No.", LeaseContract."Fixed Real Estate No.");
        PrincipalUnit.Validate(Role, PrincipalUnit.Role::Principal);
        PrincipalUnit.Validate("Starting Date", LeaseContract."Starting Date");
        PrincipalUnit.Validate("Ending Date", LeaseContract."Expiration Date");
        PrincipalUnit.Insert(true);
    end;

    procedure SyncLeaseContractLinesFixedRealEstate(ContractNo: Code[20]; NewFixedRealEstateNo: Code[20]; PreviousFixedRealEstateNo: Code[20]): Integer
    var
        ContractUnit: Record "OD AM Lease Contract Unit";
        UpdatedUnitCount: Integer;
    begin
        if ContractNo = '' then
            exit(0);

        if NewFixedRealEstateNo = '' then
            exit(0);

        ContractUnit.SetRange("Contract No.", ContractNo);
        if PreviousFixedRealEstateNo <> '' then
            ContractUnit.SetRange("Fixed Real Estate No.", PreviousFixedRealEstateNo);

        if not ContractUnit.FindSet() then
            exit(0);

        repeat
            if ContractUnit."Fixed Real Estate No." <> NewFixedRealEstateNo then begin
                ContractUnit.Validate("Fixed Real Estate No.", NewFixedRealEstateNo);
                ContractUnit.Modify(true);
                UpdatedUnitCount += 1;
            end;
        until ContractUnit.Next() = 0;

        exit(UpdatedUnitCount);
    end;

    procedure RepairLeaseContractLinesForContract(var LeaseContract: Record "Lease Contract"): Integer
    begin
        if LeaseContract."Contract No." = '' then
            exit(0);

        if LeaseContract."Fixed Real Estate No." = '' then
            exit(0);

        SyncPrincipalAsset(LeaseContract);
        exit(SyncLeaseContractLinesFixedRealEstate(LeaseContract."Contract No.", LeaseContract."Fixed Real Estate No.", ''));
    end;

    procedure RepairLeaseContractLinesForSelection(var LeaseContract: Record "Lease Contract"; var RepairedContractCount: Integer): Integer
    var
        LeaseContractToRepair: Record "Lease Contract";
        RepairedLineCount: Integer;
        TotalRepairedLineCount: Integer;
    begin
        RepairedContractCount := 0;
        if LeaseContract.IsEmpty() then
            exit(0);

        LeaseContractToRepair.CopyFilters(LeaseContract);
        if not LeaseContractToRepair.FindSet() then
            exit(0);

        repeat
            RepairedLineCount := RepairLeaseContractLinesForContract(LeaseContractToRepair);
            if RepairedLineCount > 0 then begin
                RepairedContractCount += 1;
                TotalRepairedLineCount += RepairedLineCount;
            end;
        until LeaseContractToRepair.Next() = 0;
        exit(TotalRepairedLineCount);
    end;

    procedure GetContractAssetStatistics(ContractNo: Code[20]; var AssetCount: Integer; var DwellingCount: Integer; var RoomCount: Integer; var ParkingCount: Integer; var StorageCount: Integer)
    var
        ContractUnit: Record "OD AM Lease Contract Unit";
        LeaseContract: Record "Lease Contract";
        FixedRealEstate: Record "Fixed Real Estate";
    begin
        Clear(AssetCount);
        Clear(DwellingCount);
        Clear(RoomCount);
        Clear(ParkingCount);
        Clear(StorageCount);

        ContractUnit.SetRange("Contract No.", ContractNo);
        if ContractUnit.FindSet() then
            repeat
                AssetCount += 1;
                IncrementTypeCounter(ContractUnit."Asset Type", DwellingCount, RoomCount, ParkingCount, StorageCount);
            until ContractUnit.Next() = 0;

        if AssetCount > 0 then
            exit;

        if LeaseContract.Get(ContractNo) and
           (LeaseContract."Fixed Real Estate No." <> '') and
           FixedRealEstate.Get(LeaseContract."Fixed Real Estate No.")
        then begin
            AssetCount := 1;
            IncrementTypeCounter(FixedRealEstate."OD Asset Type", DwellingCount, RoomCount, ParkingCount, StorageCount);
        end;
    end;

    procedure GetAssetTypesSummary(ContractNo: Code[20]): Text
    var
        AssetCount: Integer;
        DwellingCount: Integer;
        RoomCount: Integer;
        ParkingCount: Integer;
        StorageCount: Integer;
        SummaryText: Text;
    begin
        GetContractAssetStatistics(ContractNo, AssetCount, DwellingCount, RoomCount, ParkingCount, StorageCount);

        if DwellingCount > 0 then
            SummaryText := AppendSummaryPiece(SummaryText, StrSubstNo(TypeSummaryLbl, DwellingCount, DwellingCaptionLbl));
        if RoomCount > 0 then
            SummaryText := AppendSummaryPiece(SummaryText, StrSubstNo(TypeSummaryLbl, RoomCount, RoomCaptionLbl));
        if ParkingCount > 0 then
            SummaryText := AppendSummaryPiece(SummaryText, StrSubstNo(TypeSummaryLbl, ParkingCount, ParkingCaptionLbl));
        if StorageCount > 0 then
            SummaryText := AppendSummaryPiece(SummaryText, StrSubstNo(TypeSummaryLbl, StorageCount, StorageCaptionLbl));

        if SummaryText = '' then
            SummaryText := StrSubstNo(TypeSummaryLbl, AssetCount, AssetCaptionLbl);

        exit(SummaryText);
    end;

    procedure OpenContractsForAssetSelection(FixedRealEstateNo: Code[20]; PropertyNo: Code[20]; IsProperty: Boolean)
    var
        LeaseContract: Record "Lease Contract";
        ContractFilter: Text;
    begin
        ContractFilter := BuildContractFilterForAssetSelection(FixedRealEstateNo, PropertyNo, IsProperty);
        if ContractFilter = '' then
            Error(NoContractsForAssetErr, FixedRealEstateNo);

        LeaseContract.SetFilter("Contract No.", ContractFilter);
        Page.Run(Page::"OD AM Lease Contract List", LeaseContract);
    end;

    procedure BuildContractFilterForAssetSelection(FixedRealEstateNo: Code[20]; PropertyNo: Code[20]; IsProperty: Boolean): Text
    var
        LeaseContract: Record "Lease Contract";
        ContractUnit: Record "OD AM Lease Contract Unit";
        ContractFilter: Text;
        SeenFilter: Text;
    begin
        if IsProperty then begin
            if PropertyNo <> '' then begin
                ContractUnit.SetRange("Property No.", PropertyNo);
                if ContractUnit.FindSet() then
                    repeat
                        AddContractNoToFilter(ContractFilter, SeenFilter, ContractUnit."Contract No.");
                    until ContractUnit.Next() = 0;

                LeaseContract.SetRange("FRE Property No.", PropertyNo);
            end;
        end else begin
            if FixedRealEstateNo <> '' then begin
                ContractUnit.SetRange("Fixed Real Estate No.", FixedRealEstateNo);
                if ContractUnit.FindSet() then
                    repeat
                        AddContractNoToFilter(ContractFilter, SeenFilter, ContractUnit."Contract No.");
                    until ContractUnit.Next() = 0;

                LeaseContract.SetRange("Fixed Real Estate No.", FixedRealEstateNo);
            end;
        end;

        if LeaseContract.FindSet() then
            repeat
                AddContractNoToFilter(ContractFilter, SeenFilter, LeaseContract."Contract No.");
            until LeaseContract.Next() = 0;

        exit(ContractFilter);
    end;

    procedure EnsurePrincipalUnitForContract(var LeaseContract: Record "Lease Contract"): Boolean
    begin
        if (LeaseContract."Contract No." = '') or (LeaseContract."Fixed Real Estate No." = '') then
            exit(false);

        if HasPrincipalUnit(LeaseContract."Contract No.", LeaseContract."Fixed Real Estate No.") then
            exit(false);

        SyncPrincipalAsset(LeaseContract);
        exit(true);
    end;

    procedure ValidateContractUnit(var ContractUnit: Record "OD AM Lease Contract Unit")
    var
        LeaseContract: Record "Lease Contract";
        OccupancyMgt: Codeunit "OD AM Occupancy Mgt.";
    begin
        if (ContractUnit."Contract No." = '') or (ContractUnit."Fixed Real Estate No." = '') then
            exit;

        LeaseContract.Get(ContractUnit."Contract No.");
        ValidateUnitCompatibility(LeaseContract, ContractUnit."Fixed Real Estate No.", ContractUnit.Role, ContractUnit."Line No.");
        OccupancyMgt.CheckContractUnitAvailability(ContractUnit);
    end;

    local procedure ValidateUnitCompatibility(LeaseContract: Record "Lease Contract"; FixedRealEstateNo: Code[20]; Role: Enum "OD Contract Unit Role"; CurrentLineNo: Integer)
    var
        FixedRealEstate: Record "Fixed Real Estate";
        ContractUnit: Record "OD AM Lease Contract Unit";
        ExpectedPropertyNo: Code[20];
        CandidatePropertyNo: Code[20];
    begin
        FixedRealEstate.Get(FixedRealEstateNo);
        FixedRealEstate.TestField(Type, FixedRealEstate.Type::Activo);

        CandidatePropertyNo := GetRootPropertyNo(FixedRealEstate);
        if CandidatePropertyNo = '' then
            Error(PropertyRootRequiredErr, FixedRealEstateNo);

        ExpectedPropertyNo := LeaseContract."FRE Property No.";
        if ExpectedPropertyNo = '' then
            ExpectedPropertyNo := GetContractPropertyFromUnits(LeaseContract."Contract No.", CurrentLineNo);

        if (Role <> Role::Principal) and (LeaseContract."Fixed Real Estate No." = '') then
            Error(PrincipalRequiredBeforeAdditionalErr, LeaseContract."Contract No.");

        if (Role = Role::Principal) and
           (LeaseContract."Fixed Real Estate No." <> '') and
           (LeaseContract."Fixed Real Estate No." <> FixedRealEstateNo)
        then
            Error(PrincipalMustMatchLegacyErr, LeaseContract."Contract No.", LeaseContract."Fixed Real Estate No.");

        if (ExpectedPropertyNo <> '') and (ExpectedPropertyNo <> CandidatePropertyNo) then
            Error(DifferentPropertyErr, FixedRealEstateNo, CandidatePropertyNo, LeaseContract."Contract No.", ExpectedPropertyNo);

        ContractUnit.SetRange("Contract No.", LeaseContract."Contract No.");
        ContractUnit.SetRange("Fixed Real Estate No.", FixedRealEstateNo);
        if CurrentLineNo <> 0 then
            ContractUnit.SetFilter("Line No.", '<>%1', CurrentLineNo);
        if not ContractUnit.IsEmpty() then
            Error(DuplicateAssetErr, FixedRealEstateNo, LeaseContract."Contract No.");

        if Role = Role::Principal then begin
            ContractUnit.Reset();
            ContractUnit.SetRange("Contract No.", LeaseContract."Contract No.");
            ContractUnit.SetRange(Role, Role::Principal);
            if CurrentLineNo <> 0 then
                ContractUnit.SetFilter("Line No.", '<>%1', CurrentLineNo);
            if not ContractUnit.IsEmpty() then
                Error(MultiplePrincipalErr, LeaseContract."Contract No.");
        end;

        ValidateAdditionalUnitsProperty(LeaseContract."Contract No.", CandidatePropertyNo, CurrentLineNo);
    end;

    local procedure ValidateAdditionalUnitsProperty(ContractNo: Code[20]; ExpectedPropertyNo: Code[20]; CurrentLineNo: Integer)
    var
        ContractUnit: Record "OD AM Lease Contract Unit";
    begin
        if ExpectedPropertyNo = '' then
            exit;

        ContractUnit.SetRange("Contract No.", ContractNo);
        if CurrentLineNo <> 0 then
            ContractUnit.SetFilter("Line No.", '<>%1', CurrentLineNo);
        if ContractUnit.FindSet() then
            repeat
                if (ContractUnit."Property No." <> '') and (ContractUnit."Property No." <> ExpectedPropertyNo) then
                    Error(IncompatibleExistingUnitsErr, ContractNo, ExpectedPropertyNo);
            until ContractUnit.Next() = 0;
    end;

    local procedure EnsureSinglePrincipalLine(ContractNo: Code[20])
    var
        ContractUnit: Record "OD AM Lease Contract Unit";
    begin
        ContractUnit.SetRange("Contract No.", ContractNo);
        ContractUnit.SetRange(Role, ContractUnit.Role::Principal);
        if ContractUnit.Count() > 1 then
            Error(MultiplePrincipalErr, ContractNo);
    end;

    local procedure HasPrincipalUnit(ContractNo: Code[20]; FixedRealEstateNo: Code[20]): Boolean
    var
        ContractUnit: Record "OD AM Lease Contract Unit";
    begin
        ContractUnit.SetRange("Contract No.", ContractNo);
        ContractUnit.SetRange(Role, ContractUnit.Role::Principal);
        ContractUnit.SetRange("Fixed Real Estate No.", FixedRealEstateNo);
        exit(ContractUnit.FindFirst());
    end;

    local procedure GetContractPropertyFromUnits(ContractNo: Code[20]; CurrentLineNo: Integer): Code[20]
    var
        ContractUnit: Record "OD AM Lease Contract Unit";
    begin
        ContractUnit.SetRange("Contract No.", ContractNo);
        if CurrentLineNo <> 0 then
            ContractUnit.SetFilter("Line No.", '<>%1', CurrentLineNo);
        if ContractUnit.FindFirst() then
            exit(ContractUnit."Property No.");

        exit('');
    end;

    local procedure GetRootPropertyNo(FixedRealEstate: Record "Fixed Real Estate"): Code[20]
    var
        AssetStructureMgt: Codeunit "OD AM Asset Structure Mgt.";
    begin
        if FixedRealEstate."Property No." <> '' then
            exit(FixedRealEstate."Property No.");

        exit(AssetStructureMgt.GetRootProperty(FixedRealEstate."No."));
    end;

    local procedure IncrementTypeCounter(AssetType: Enum "OD Asset Type"; var DwellingCount: Integer; var RoomCount: Integer; var ParkingCount: Integer; var StorageCount: Integer)
    begin
        case AssetType of
            AssetType::Dwelling:
                DwellingCount += 1;
            AssetType::Room:
                RoomCount += 1;
            AssetType::Parking:
                ParkingCount += 1;
            AssetType::Storage:
                StorageCount += 1;
        end;
    end;

    local procedure AppendSummaryPiece(CurrentText: Text; NewText: Text): Text
    begin
        if CurrentText = '' then
            exit(NewText);

        exit(CurrentText + ', ' + NewText);
    end;

    local procedure AddContractNoToFilter(var ContractFilter: Text; var SeenFilter: Text; ContractNo: Code[20])
    var
        FilterToken: Text;
    begin
        if ContractNo = '' then
            exit;

        FilterToken := '|' + ContractNo + '|';
        if StrPos(SeenFilter, FilterToken) > 0 then
            exit;

        if ContractFilter = '' then
            ContractFilter := ContractNo
        else
            ContractFilter += '|' + ContractNo;

        SeenFilter += FilterToken;
    end;

    var
        ContractNoRequiredErr: Label 'Debe indicar el numero de contrato.';
        FixedRealEstateNoRequiredErr: Label 'Debe indicar el activo inmobiliario.';
        PrincipalCreationErr: Label 'El activo principal se mantiene desde Lease Contract."Fixed Real Estate No.".';
        CannotDeletePrincipalErr: Label 'No se puede eliminar el activo principal del contrato %1 mientras siga informado como activo principal legacy.';
        ContractRequiresPrincipalErr: Label 'El contrato %1 contiene activos contractuales y requiere un activo principal en Lease Contract."Fixed Real Estate No.".';
        PropertyRootRequiredErr: Label 'No se ha podido determinar la propiedad raiz del activo %1.';
        DifferentPropertyErr: Label 'El activo %1 pertenece a la propiedad %2 y no es compatible con el contrato %3, que trabaja con la propiedad %4.';
        DuplicateAssetErr: Label 'El activo %1 ya existe en el contrato %2.';
        MultiplePrincipalErr: Label 'El contrato %1 solo puede tener un activo principal.';
        IncompatibleExistingUnitsErr: Label 'El contrato %1 contiene activos de una propiedad distinta a %2. Revise los activos adicionales antes de cambiar el principal.';
        PrincipalRequiredBeforeAdditionalErr: Label 'Debe informar primero el activo principal legacy del contrato %1 antes de anadir activos adicionales o accesorios.';
        PrincipalMustMatchLegacyErr: Label 'El activo principal del contrato %1 debe coincidir con Lease Contract."Fixed Real Estate No." = %2.';
        NoContractsForAssetErr: Label 'No se han encontrado contratos relacionados para el activo %1.';
        TypeSummaryLbl: Label '%1 %2';
        DwellingCaptionLbl: Label 'viviendas';
        RoomCaptionLbl: Label 'habitaciones';
        ParkingCaptionLbl: Label 'parkings';
        StorageCaptionLbl: Label 'trasteros';
        AssetCaptionLbl: Label 'activos';
}
