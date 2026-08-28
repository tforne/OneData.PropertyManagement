codeunit 96976 "OD AM Occupancy Mgt."
{
    procedure IsAssetAvailable(FixedRealEstateNo: Code[20]; StartDate: Date; EndDate: Date; ExcludeContractNo: Code[20]): Boolean
    begin
        ValidatePeriod(StartDate, EndDate);
        exit(not HasAnyConflict(FixedRealEstateNo, StartDate, EndDate, ExcludeContractNo, 0));
    end;

    procedure CheckAssetAvailability(FixedRealEstateNo: Code[20]; StartDate: Date; EndDate: Date; ExcludeContractNo: Code[20])
    begin
        ValidatePeriod(StartDate, EndDate);
        RaiseAvailabilityErrorIfNeeded(FixedRealEstateNo, StartDate, EndDate, ExcludeContractNo, 0);
    end;

    procedure HasDateOverlap(StartDate1: Date; EndDate1: Date; StartDate2: Date; EndDate2: Date): Boolean
    begin
        if (EndDate1 <> 0D) and (StartDate2 <> 0D) and (EndDate1 < StartDate2) then
            exit(false);

        if (EndDate2 <> 0D) and (StartDate1 <> 0D) and (EndDate2 < StartDate1) then
            exit(false);

        exit(true);
    end;

    procedure HasDirectContractConflict(FixedRealEstateNo: Code[20]; StartDate: Date; EndDate: Date; ExcludeContractNo: Code[20]): Boolean
    var
        BlockingContractNo: Code[20];
        BlockingAssetNo: Code[20];
        BlockingStartDate: Date;
        BlockingEndDate: Date;
    begin
        exit(FindBlockingConflict(FixedRealEstateNo, StartDate, EndDate, ExcludeContractNo, 0, ConflictSearchScope::DirectOnly, BlockingAssetNo, BlockingContractNo, BlockingStartDate, BlockingEndDate));
    end;

    procedure HasParentConflict(FixedRealEstateNo: Code[20]; StartDate: Date; EndDate: Date; ExcludeContractNo: Code[20]): Boolean
    var
        BlockingContractNo: Code[20];
        BlockingAssetNo: Code[20];
        BlockingStartDate: Date;
        BlockingEndDate: Date;
    begin
        exit(FindBlockingConflict(FixedRealEstateNo, StartDate, EndDate, ExcludeContractNo, 0, ConflictSearchScope::ParentsOnly, BlockingAssetNo, BlockingContractNo, BlockingStartDate, BlockingEndDate));
    end;

    procedure HasChildConflict(FixedRealEstateNo: Code[20]; StartDate: Date; EndDate: Date; ExcludeContractNo: Code[20]): Boolean
    var
        BlockingContractNo: Code[20];
        BlockingAssetNo: Code[20];
        BlockingStartDate: Date;
        BlockingEndDate: Date;
    begin
        exit(FindBlockingConflict(FixedRealEstateNo, StartDate, EndDate, ExcludeContractNo, 0, ConflictSearchScope::ChildrenOnly, BlockingAssetNo, BlockingContractNo, BlockingStartDate, BlockingEndDate));
    end;

    procedure GetOccupancyStatus(FixedRealEstateNo: Code[20]; OnDate: Date): Enum "OD AM Occupancy Status"
    var
        FixedRealEstate: Record "Fixed Real Estate";
        LeafAssetCount: Integer;
        OccupiedLeafCount: Integer;
        AdministrativeStatus: Enum "OD AM Occupancy Status";
    begin
        if (FixedRealEstateNo = '') or (not FixedRealEstate.Get(FixedRealEstateNo)) then
            exit("OD AM Occupancy Status"::Unknown);

        AdministrativeStatus := GetAdministrativeOccupancyStatus(FixedRealEstate);
        if AdministrativeStatus in [AdministrativeStatus::Blocked, AdministrativeStatus::Inactive] then
            exit(AdministrativeStatus);

        if HasDirectContractConflict(FixedRealEstateNo, OnDate, OnDate, '') then
            exit("OD AM Occupancy Status"::Occupied);

        if HasParentConflict(FixedRealEstateNo, OnDate, OnDate, '') then
            exit("OD AM Occupancy Status"::Occupied);

        LeafAssetCount := GetLeafDescendantCount(FixedRealEstateNo);
        if LeafAssetCount > 0 then begin
            OccupiedLeafCount := GetOccupiedLeafDescendantCount(FixedRealEstateNo, OnDate);
            if OccupiedLeafCount = 0 then
                exit("OD AM Occupancy Status"::Available);
            if OccupiedLeafCount < LeafAssetCount then
                exit("OD AM Occupancy Status"::PartiallyOccupied);
            exit("OD AM Occupancy Status"::Occupied);
        end;

        exit("OD AM Occupancy Status"::Available);
    end;

    procedure GetCurrentContract(FixedRealEstateNo: Code[20]; OnDate: Date; var LeaseContract: Record "Lease Contract"): Boolean
    var
        BlockingContractNo: Code[20];
        BlockingAssetNo: Code[20];
        BlockingStartDate: Date;
        BlockingEndDate: Date;
    begin
        Clear(LeaseContract);
        if not FindBlockingConflict(FixedRealEstateNo, OnDate, OnDate, '', 0, ConflictSearchScope::DirectOnly, BlockingAssetNo, BlockingContractNo, BlockingStartDate, BlockingEndDate) then
            exit(false);

        exit(LeaseContract.Get(BlockingContractNo));
    end;

    procedure GetOccupancyPercentage(FixedRealEstateNo: Code[20]; OnDate: Date): Decimal
    var
        LeafAssetCount: Integer;
        OccupiedLeafCount: Integer;
    begin
        LeafAssetCount := GetLeafDescendantCount(FixedRealEstateNo);
        if LeafAssetCount = 0 then
            exit(0);

        OccupiedLeafCount := GetOccupiedLeafDescendantCount(FixedRealEstateNo, OnDate);
        exit(Round((OccupiedLeafCount * 100) / LeafAssetCount, 0.01));
    end;

    procedure GetAvailableAssets(PropertyNo: Code[20]; AssetType: Enum "OD Asset Type"; StartDate: Date; EndDate: Date; var TempFixedRealEstate: Record "Fixed Real Estate" temporary)
    var
        FixedRealEstate: Record "Fixed Real Estate";
    begin
        ValidatePeriod(StartDate, EndDate);
        TempFixedRealEstate.Reset();
        TempFixedRealEstate.DeleteAll();

        if PropertyNo = '' then
            exit;

        FixedRealEstate.SetRange(Type, FixedRealEstate.Type::Activo);
        FixedRealEstate.SetRange("Property No.", PropertyNo);
        if AssetType <> AssetType::Undefined then
            FixedRealEstate.SetRange("OD Asset Type", AssetType);

        if FixedRealEstate.FindSet() then
            repeat
                if IsAssetAvailable(FixedRealEstate."No.", StartDate, EndDate, '') then begin
                    TempFixedRealEstate := FixedRealEstate;
                    TempFixedRealEstate.Insert();
                end;
            until FixedRealEstate.Next() = 0;
    end;

    procedure CheckContractUnitAvailability(var ContractUnit: Record "OD AM Lease Contract Unit")
    begin
        ValidatePeriod(ContractUnit."Starting Date", ContractUnit."Ending Date");
        RaiseAvailabilityErrorIfNeeded(ContractUnit."Fixed Real Estate No.", ContractUnit."Starting Date", ContractUnit."Ending Date", ContractUnit."Contract No.", ContractUnit."Line No.");
    end;

    procedure ValidateContractAvailability(ContractNo: Code[20])
    var
        ContractUnit: Record "OD AM Lease Contract Unit";
    begin
        if ContractNo = '' then
            exit;

        ContractUnit.SetRange("Contract No.", ContractNo);
        if ContractUnit.FindSet() then
            repeat
                CheckContractUnitAvailability(ContractUnit);
            until ContractUnit.Next() = 0;
    end;

    procedure EvaluateContractAvailabilityStatus(ContractNo: Code[20]): Text
    begin
        if TryValidateContractAvailability(ContractNo) then
            exit(AvailabilityValidLbl);

        exit(AvailabilityConflictLbl);
    end;

    procedure GetContractOccupiedAssetCount(ContractNo: Code[20]; OnDate: Date): Integer
    var
        ContractUnit: Record "OD AM Lease Contract Unit";
        CountOccupied: Integer;
    begin
        ContractUnit.SetRange("Contract No.", ContractNo);
        if ContractUnit.FindSet() then
            repeat
                if GetOccupancyStatus(ContractUnit."Fixed Real Estate No.", OnDate) in
                   ["OD AM Occupancy Status"::Occupied, "OD AM Occupancy Status"::PartiallyOccupied, "OD AM Occupancy Status"::Blocked]
                then
                    CountOccupied += 1;
            until ContractUnit.Next() = 0;

        exit(CountOccupied);
    end;

    procedure GetBlockingContractForAsset(FixedRealEstateNo: Code[20]; OnDate: Date; var LeaseContract: Record "Lease Contract"): Boolean
    var
        BlockingContractNo: Code[20];
        BlockingAssetNo: Code[20];
        BlockingStartDate: Date;
        BlockingEndDate: Date;
    begin
        Clear(LeaseContract);
        if not FindBlockingConflict(FixedRealEstateNo, OnDate, OnDate, '', 0, ConflictSearchScope::AnyConflict, BlockingAssetNo, BlockingContractNo, BlockingStartDate, BlockingEndDate) then
            exit(false);

        exit(LeaseContract.Get(BlockingContractNo));
    end;

    procedure GetBlockingContractInfo(FixedRealEstateNo: Code[20]; StartDate: Date; EndDate: Date; ExcludeContractNo: Code[20]; var BlockingAssetNo: Code[20]; var BlockingContractNo: Code[20]; var BlockingStartDate: Date; var BlockingEndDate: Date): Boolean
    begin
        exit(FindBlockingConflict(FixedRealEstateNo, StartDate, EndDate, ExcludeContractNo, 0, ConflictSearchScope::AnyConflict, BlockingAssetNo, BlockingContractNo, BlockingStartDate, BlockingEndDate));
    end;

    [TryFunction]
    local procedure TryValidateContractAvailability(ContractNo: Code[20])
    begin
        ValidateContractAvailability(ContractNo);
    end;

    local procedure RaiseAvailabilityErrorIfNeeded(FixedRealEstateNo: Code[20]; StartDate: Date; EndDate: Date; ExcludeContractNo: Code[20]; ExcludeLineNo: Integer)
    var
        BlockingAssetNo: Code[20];
        BlockingContractNo: Code[20];
        BlockingStartDate: Date;
        BlockingEndDate: Date;
    begin
        if not FindBlockingConflict(FixedRealEstateNo, StartDate, EndDate, ExcludeContractNo, ExcludeLineNo, ConflictSearchScope::AnyConflict, BlockingAssetNo, BlockingContractNo, BlockingStartDate, BlockingEndDate) then
            exit;

        if BlockingAssetNo = FixedRealEstateNo then
            Error(DirectConflictErr, FixedRealEstateNo, BlockingContractNo, Format(BlockingStartDate), Format(BlockingEndDate));

        if IsAncestorOf(BlockingAssetNo, FixedRealEstateNo) then
            Error(ParentConflictErr, FixedRealEstateNo, BlockingAssetNo, BlockingContractNo, Format(BlockingStartDate), Format(BlockingEndDate));

        Error(ChildConflictErr, FixedRealEstateNo, BlockingAssetNo, BlockingContractNo, Format(BlockingStartDate), Format(BlockingEndDate));
    end;

    local procedure FindBlockingConflict(FixedRealEstateNo: Code[20]; StartDate: Date; EndDate: Date; ExcludeContractNo: Code[20]; ExcludeLineNo: Integer; SearchScope: Option AnyConflict,DirectOnly,ParentsOnly,ChildrenOnly; var BlockingAssetNo: Code[20]; var BlockingContractNo: Code[20]; var BlockingStartDate: Date; var BlockingEndDate: Date): Boolean
    begin
        Clear(BlockingAssetNo);
        Clear(BlockingContractNo);
        Clear(BlockingStartDate);
        Clear(BlockingEndDate);

        if FixedRealEstateNo = '' then
            exit(false);

        case SearchScope of
            ConflictSearchScope::AnyConflict,
            ConflictSearchScope::DirectOnly:
                if FindDirectConflictInfo(FixedRealEstateNo, StartDate, EndDate, ExcludeContractNo, ExcludeLineNo, BlockingContractNo, BlockingStartDate, BlockingEndDate) then begin
                    BlockingAssetNo := FixedRealEstateNo;
                    exit(true);
                end;
        end;

        case SearchScope of
            ConflictSearchScope::AnyConflict,
            ConflictSearchScope::ParentsOnly:
                if FindParentConflictInfo(FixedRealEstateNo, StartDate, EndDate, ExcludeContractNo, ExcludeLineNo, BlockingAssetNo, BlockingContractNo, BlockingStartDate, BlockingEndDate) then
                    exit(true);
        end;

        case SearchScope of
            ConflictSearchScope::AnyConflict,
            ConflictSearchScope::ChildrenOnly:
                if FindChildConflictInfo(FixedRealEstateNo, StartDate, EndDate, ExcludeContractNo, ExcludeLineNo, BlockingAssetNo, BlockingContractNo, BlockingStartDate, BlockingEndDate) then
                    exit(true);
        end;

        exit(false);
    end;

    local procedure FindDirectConflictInfo(FixedRealEstateNo: Code[20]; StartDate: Date; EndDate: Date; ExcludeContractNo: Code[20]; ExcludeLineNo: Integer; var BlockingContractNo: Code[20]; var BlockingStartDate: Date; var BlockingEndDate: Date): Boolean
    var
        ContractUnit: Record "OD AM Lease Contract Unit";
    begin
        ContractUnit.SetCurrentKey("Fixed Real Estate No.", "Starting Date", "Ending Date");
        ContractUnit.SetRange("Fixed Real Estate No.", FixedRealEstateNo);
        if ContractUnit.FindSet() then
            repeat
                if ShouldEvaluateUnit(ContractUnit, ExcludeContractNo, ExcludeLineNo) and
                   HasDateOverlap(StartDate, EndDate, ContractUnit."Starting Date", ContractUnit."Ending Date")
                then begin
                    BlockingContractNo := ContractUnit."Contract No.";
                    BlockingStartDate := ContractUnit."Starting Date";
                    BlockingEndDate := ContractUnit."Ending Date";
                    exit(true);
                end;
            until ContractUnit.Next() = 0;

        exit(false);
    end;

    local procedure FindParentConflictInfo(FixedRealEstateNo: Code[20]; StartDate: Date; EndDate: Date; ExcludeContractNo: Code[20]; ExcludeLineNo: Integer; var BlockingAssetNo: Code[20]; var BlockingContractNo: Code[20]; var BlockingStartDate: Date; var BlockingEndDate: Date): Boolean
    var
        FixedRealEstate: Record "Fixed Real Estate";
        ParentAssetNo: Code[20];
    begin
        if not FixedRealEstate.Get(FixedRealEstateNo) then
            exit(false);

        ParentAssetNo := FixedRealEstate."OD Parent FRE No.";
        while ParentAssetNo <> '' do begin
            if FindDirectConflictInfo(ParentAssetNo, StartDate, EndDate, ExcludeContractNo, ExcludeLineNo, BlockingContractNo, BlockingStartDate, BlockingEndDate) then begin
                BlockingAssetNo := ParentAssetNo;
                exit(true);
            end;

            if not FixedRealEstate.Get(ParentAssetNo) then
                exit(false);
            ParentAssetNo := FixedRealEstate."OD Parent FRE No.";
        end;

        exit(false);
    end;

    local procedure FindChildConflictInfo(FixedRealEstateNo: Code[20]; StartDate: Date; EndDate: Date; ExcludeContractNo: Code[20]; ExcludeLineNo: Integer; var BlockingAssetNo: Code[20]; var BlockingContractNo: Code[20]; var BlockingStartDate: Date; var BlockingEndDate: Date): Boolean
    var
        ContractUnit: Record "OD AM Lease Contract Unit";
        FixedRealEstate: Record "Fixed Real Estate";
        PropertyNo: Code[20];
    begin
        if not FixedRealEstate.Get(FixedRealEstateNo) then
            exit(false);

        PropertyNo := GetPropertyNo(FixedRealEstate);
        if PropertyNo <> '' then
            ContractUnit.SetRange("Property No.", PropertyNo);

        if ContractUnit.FindSet() then
            repeat
                if ShouldEvaluateUnit(ContractUnit, ExcludeContractNo, ExcludeLineNo) and
                   (ContractUnit."Fixed Real Estate No." <> FixedRealEstateNo) and
                   IsAncestorOf(FixedRealEstateNo, ContractUnit."Fixed Real Estate No.") and
                   HasDateOverlap(StartDate, EndDate, ContractUnit."Starting Date", ContractUnit."Ending Date")
                then begin
                    BlockingAssetNo := ContractUnit."Fixed Real Estate No.";
                    BlockingContractNo := ContractUnit."Contract No.";
                    BlockingStartDate := ContractUnit."Starting Date";
                    BlockingEndDate := ContractUnit."Ending Date";
                    exit(true);
                end;
            until ContractUnit.Next() = 0;

        exit(false);
    end;

    local procedure ShouldEvaluateUnit(ContractUnit: Record "OD AM Lease Contract Unit"; ExcludeContractNo: Code[20]; ExcludeLineNo: Integer): Boolean
    begin
        if ContractUnit."Contract No." = '' then
            exit(false);

        if (ExcludeLineNo <> 0) and (ContractUnit."Contract No." = ExcludeContractNo) and (ContractUnit."Line No." = ExcludeLineNo) then
            exit(false);

        if (ExcludeLineNo = 0) and (ExcludeContractNo <> '') and (ContractUnit."Contract No." = ExcludeContractNo) then
            exit(false);

        exit(true);
    end;

    procedure ValidatePeriod(StartDate: Date; EndDate: Date)
    begin
        if (EndDate <> 0D) and (StartDate <> 0D) and (EndDate < StartDate) then
            Error(InvalidPeriodErr);
    end;

    local procedure GetLeafDescendantCount(FixedRealEstateNo: Code[20]): Integer
    var
        FixedRealEstate: Record "Fixed Real Estate";
        PropertyNo: Code[20];
        LeafCount: Integer;
    begin
        if FixedRealEstateNo = '' then
            exit(0);

        if not FixedRealEstate.Get(FixedRealEstateNo) then
            exit(0);

        PropertyNo := GetPropertyNo(FixedRealEstate);
        if PropertyNo = '' then
            exit(0);

        FixedRealEstate.Reset();
        FixedRealEstate.SetRange(Type, FixedRealEstate.Type::Activo);
        FixedRealEstate.SetRange("Property No.", PropertyNo);
        if FixedRealEstate.FindSet() then
            repeat
                if (FixedRealEstate."No." <> FixedRealEstateNo) and
                   IsAncestorOf(FixedRealEstateNo, FixedRealEstate."No.") and
                   (not HasChildAssets(FixedRealEstate."No."))
                then
                    LeafCount += 1;
            until FixedRealEstate.Next() = 0;

        exit(LeafCount);
    end;

    local procedure GetOccupiedLeafDescendantCount(FixedRealEstateNo: Code[20]; OnDate: Date): Integer
    var
        FixedRealEstate: Record "Fixed Real Estate";
        PropertyNo: Code[20];
        OccupiedCount: Integer;
    begin
        if FixedRealEstateNo = '' then
            exit(0);

        if not FixedRealEstate.Get(FixedRealEstateNo) then
            exit(0);

        PropertyNo := GetPropertyNo(FixedRealEstate);
        if PropertyNo = '' then
            exit(0);

        FixedRealEstate.Reset();
        FixedRealEstate.SetRange(Type, FixedRealEstate.Type::Activo);
        FixedRealEstate.SetRange("Property No.", PropertyNo);
        if FixedRealEstate.FindSet() then
            repeat
                if (FixedRealEstate."No." <> FixedRealEstateNo) and
                   IsAncestorOf(FixedRealEstateNo, FixedRealEstate."No.") and
                   (not HasChildAssets(FixedRealEstate."No.")) and
                   (GetOccupancyStatus(FixedRealEstate."No.", OnDate) in ["OD AM Occupancy Status"::Occupied, "OD AM Occupancy Status"::Blocked])
                then
                    OccupiedCount += 1;
            until FixedRealEstate.Next() = 0;

        exit(OccupiedCount);
    end;

    local procedure HasAnyConflict(FixedRealEstateNo: Code[20]; StartDate: Date; EndDate: Date; ExcludeContractNo: Code[20]; ExcludeLineNo: Integer): Boolean
    var
        BlockingContractNo: Code[20];
        BlockingAssetNo: Code[20];
        BlockingStartDate: Date;
        BlockingEndDate: Date;
    begin
        exit(FindBlockingConflict(FixedRealEstateNo, StartDate, EndDate, ExcludeContractNo, ExcludeLineNo, ConflictSearchScope::AnyConflict, BlockingAssetNo, BlockingContractNo, BlockingStartDate, BlockingEndDate));
    end;

    local procedure HasChildAssets(FixedRealEstateNo: Code[20]): Boolean
    var
        ChildFixedRealEstate: Record "Fixed Real Estate";
    begin
        ChildFixedRealEstate.SetRange("OD Parent FRE No.", FixedRealEstateNo);
        exit(ChildFixedRealEstate.FindFirst());
    end;

    local procedure IsAncestorOf(ParentAssetNo: Code[20]; ChildAssetNo: Code[20]): Boolean
    var
        AssetStructureMgt: Codeunit "OD AM Asset Structure Mgt.";
    begin
        exit(AssetStructureMgt.IsDescendant(ParentAssetNo, ChildAssetNo));
    end;

    local procedure GetPropertyNo(FixedRealEstate: Record "Fixed Real Estate"): Code[20]
    var
        AssetStructureMgt: Codeunit "OD AM Asset Structure Mgt.";
    begin
        if FixedRealEstate.Type = FixedRealEstate.Type::Propiedad then
            exit(FixedRealEstate."No.");

        if FixedRealEstate."Property No." <> '' then
            exit(FixedRealEstate."Property No.");

        exit(AssetStructureMgt.GetRootProperty(FixedRealEstate."No."));
    end;

    local procedure GetAdministrativeOccupancyStatus(FixedRealEstate: Record "Fixed Real Estate"): Enum "OD AM Occupancy Status"
    var
        StatusText: Text;
    begin
        StatusText := UpperCase(Format(FixedRealEstate.Status));
        if (StrPos(StatusText, 'INACTIVE') > 0) or (StrPos(StatusText, 'INACTIV') > 0) then
            exit("OD AM Occupancy Status"::Inactive);

        if (StrPos(StatusText, 'BLOCK') > 0) or (StrPos(StatusText, 'BLOQ') > 0) then
            exit("OD AM Occupancy Status"::Blocked);

        exit("OD AM Occupancy Status"::Unknown);
    end;

    var
        ConflictSearchScope: Option AnyConflict,DirectOnly,ParentsOnly,ChildrenOnly;
        DirectConflictErr: Label 'El activo %1 ya esta ocupado durante el periodo indicado por el contrato %2 (%3 - %4).';
        ParentConflictErr: Label 'La unidad %1 no esta disponible porque su activo padre %2 esta alquilado en el contrato %3 (%4 - %5).';
        ChildConflictErr: Label 'El activo %1 no esta disponible porque la unidad descendiente %2 esta ocupada en el contrato %3 (%4 - %5).';
        InvalidPeriodErr: Label 'La fecha final no puede ser anterior a la fecha inicial.';
        AvailabilityValidLbl: Label 'Valido';
        AvailabilityConflictLbl: Label 'Conflicto detectado';
}
