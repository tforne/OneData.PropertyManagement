page 96964 "OD AM Lease Contract Card"
{
    PageType = Card;
    SourceTable = "Lease Contract";
    Caption = 'Contrato alquiler Asset Management';
    ApplicationArea = All;

    layout
    {
        area(Content)
        {
            group(General)
            {
                Caption = 'General';

                field("Contract No."; Rec."Contract No.")
                {
                }
                field(Description; Rec.Description)
                {
                }
                field("Customer No."; Rec."Customer No.")
                {
                }
                field(Name; Rec.Name)
                {
                }
                field(Status; Rec.Status)
                {
                    Editable = false;
                }
                field("Starting Date"; Rec."Starting Date")
                {
                }
                field("Expiration Date"; Rec."Expiration Date")
                {
                }
                field("Fixed Real Estate No."; Rec."Fixed Real Estate No.")
                {
                }
                field("Description Fixed Real Estate"; Rec."Description Fixed Real Estate")
                {
                    Caption = 'Descripcion activo principal';
                }
                field("FRE Property No."; Rec."FRE Property No.")
                {
                }
            }
            group(Indicators)
            {
                Caption = 'Indicadores';

                field(AssetCount; AssetCount)
                {
                    Caption = 'Numero de activos';
                    Editable = false;
                }
                field(DwellingCount; DwellingCount)
                {
                    Caption = 'Numero de viviendas';
                    Editable = false;
                }
                field(RoomCount; RoomCount)
                {
                    Caption = 'Numero de habitaciones';
                    Editable = false;
                }
                field(ParkingCount; ParkingCount)
                {
                    Caption = 'Numero de parkings';
                    Editable = false;
                }
                field(StorageCount; StorageCount)
                {
                    Caption = 'Numero de trasteros';
                    Editable = false;
                }
                field(OccupiedAssetCount; OccupiedAssetCount)
                {
                    Caption = 'Activos ocupados';
                    Editable = false;
                }
                field(AvailabilityValidationStatus; AvailabilityValidationStatus)
                {
                    Caption = 'Estado disponibilidad';
                    Editable = false;
                }
            }
            part(ContractUnits; "OD AM Lease Contract Units")
            {
                Caption = 'Activos del contrato';
                ApplicationArea = All;
                SubPageLink = "Contract No." = field("Contract No.");
                UpdatePropagation = Both;
            }
            part(LeaseContractLines; "Lease Contract Subform")
            {
                Caption = 'Lineas economicas';
                ApplicationArea = All;
                SubPageLink = "Contract No." = field("Contract No.");
            }
        }
        area(FactBoxes)
        {
            part(ContractAssetFactBox; "OD AM Contract Asset FactBox")
            {
                ApplicationArea = All;
                SubPageLink = "Contract No." = field("Contract No.");
            }
        }
    }

    actions
    {
        area(Processing)
        {
            action(AddAsset)
            {
                Caption = 'Anadir activo';
                Image = New;
                Promoted = true;
                PromotedCategory = Process;

                trigger OnAction()
                begin
                    AddAssetWithRole(Enum::"OD Asset Type"::Undefined, Enum::"OD Contract Unit Role"::Additional);
                end;
            }
            action(AddRoom)
            {
                Caption = 'Anadir habitacion';
                Image = New;
                Promoted = true;
                PromotedCategory = Process;

                trigger OnAction()
                begin
                    AddAssetWithRole(Enum::"OD Asset Type"::Room, Enum::"OD Contract Unit Role"::Additional);
                end;
            }
            action(AddParking)
            {
                Caption = 'Anadir parking';
                Image = New;
                Promoted = true;
                PromotedCategory = Process;

                trigger OnAction()
                begin
                    AddAssetWithRole(Enum::"OD Asset Type"::Parking, Enum::"OD Contract Unit Role"::Accessory);
                end;
            }
            action(AddStorage)
            {
                Caption = 'Anadir trastero';
                Image = New;
                Promoted = true;
                PromotedCategory = Process;

                trigger OnAction()
                begin
                    AddAssetWithRole(Enum::"OD Asset Type"::Storage, Enum::"OD Contract Unit Role"::Accessory);
                end;
            }
            action(OpenPrincipalAsset)
            {
                Caption = 'Abrir activo';
                Image = FixedAssets;

                trigger OnAction()
                var
                    ContractAssetMgt: Codeunit "OD AM Contract Asset Mgt.";
                    FixedRealEstate: Record "Fixed Real Estate";
                begin
                    if not ContractAssetMgt.GetPrincipalAsset(Rec."Contract No.", FixedRealEstate) then
                        Error(NoPrincipalAssetErr);

                    Page.Run(Page::"Fixed Real Estate Card", FixedRealEstate);
                end;
            }
            action(OpenStructure)
            {
                Caption = 'Abrir estructura';
                Image = Hierarchy;

                trigger OnAction()
                var
                    AssetStructurePage: Page "OD AM Asset Structure";
                begin
                    if Rec."FRE Property No." = '' then
                        Error(NoPropertyErr);

                    AssetStructurePage.SetSelectedProperty(Rec."FRE Property No.");
                    AssetStructurePage.Run();
                end;
            }
            action(SyncPrincipalAsset)
            {
                Caption = 'Sincronizar activo principal';
                Image = Refresh;

                trigger OnAction()
                var
                    ContractAssetMgt: Codeunit "OD AM Contract Asset Mgt.";
                begin
                    CurrPage.SaveRecord();
                    ContractAssetMgt.SyncPrincipalAsset(Rec);
                    CurrPage.Update(false);
                end;
            }
            action(RepairLeaseContractLines)
            {
                Caption = 'Reparar lineas de inmueble';
                Image = RefreshLines;

                trigger OnAction()
                var
                    ContractAssetMgt: Codeunit "OD AM Contract Asset Mgt.";
                    RepairedLineCount: Integer;
                begin
                    CurrPage.SaveRecord();
                    RepairedLineCount := ContractAssetMgt.RepairLeaseContractLinesForContract(Rec);
                    Message(LeaseLinesRepairMsg, RepairedLineCount, Rec."Contract No.");
                    CurrPage.Update(false);
                end;
            }
            action(ValidateAvailability)
            {
                Caption = 'Validar disponibilidad';
                Image = CheckRulesSyntax;
                Promoted = true;
                PromotedCategory = Process;

                trigger OnAction()
                var
                    OccupancyMgt: Codeunit "OD AM Occupancy Mgt.";
                begin
                    CurrPage.SaveRecord();
                    OccupancyMgt.ValidateContractAvailability(Rec."Contract No.");
                    Message(AvailabilityValidatedMsg, Rec."Contract No.");
                    LoadStatistics();
                    CurrPage.Update(false);
                end;
            }
        }
    }

    trigger OnAfterGetCurrRecord()
    begin
        LoadStatistics();
    end;

    trigger OnOpenPage()
    begin
        LoadStatistics();
    end;

    var
        AssetCount: Integer;
        DwellingCount: Integer;
        RoomCount: Integer;
        ParkingCount: Integer;
        StorageCount: Integer;
        OccupiedAssetCount: Integer;
        AvailabilityValidationStatus: Text[50];
        NoPrincipalAssetErr: Label 'El contrato no tiene activo principal disponible.';
        NoPropertyErr: Label 'El contrato no tiene una propiedad raiz informada.';
        AvailabilityValidatedMsg: Label 'La disponibilidad del contrato %1 es valida.';
        LeaseLinesRepairMsg: Label 'Se han reparado %1 lineas economicas del contrato %2.';

    local procedure LoadStatistics()
    var
        ContractAssetMgt: Codeunit "OD AM Contract Asset Mgt.";
        OccupancyMgt: Codeunit "OD AM Occupancy Mgt.";
    begin
        ContractAssetMgt.GetContractAssetStatistics(Rec."Contract No.", AssetCount, DwellingCount, RoomCount, ParkingCount, StorageCount);
        OccupiedAssetCount := OccupancyMgt.GetContractOccupiedAssetCount(Rec."Contract No.", WorkDate());
        AvailabilityValidationStatus := CopyStr(OccupancyMgt.EvaluateContractAvailabilityStatus(Rec."Contract No."), 1, MaxStrLen(AvailabilityValidationStatus));
    end;

    local procedure AddAssetWithRole(AssetTypeFilter: Enum "OD Asset Type"; Role: Enum "OD Contract Unit Role")
    var
        FixedRealEstate: Record "Fixed Real Estate";
        ContractAssetMgt: Codeunit "OD AM Contract Asset Mgt.";
    begin
        CurrPage.SaveRecord();
        FixedRealEstate.SetRange(Type, FixedRealEstate.Type::Activo);
        if Rec."FRE Property No." <> '' then
            FixedRealEstate.SetRange("Property No.", Rec."FRE Property No.");
        if AssetTypeFilter <> AssetTypeFilter::Undefined then
            FixedRealEstate.SetRange("OD Asset Type", AssetTypeFilter);

        if Page.RunModal(Page::"Simple Fixed Real Estate List", FixedRealEstate) <> Action::LookupOK then
            exit;

        ContractAssetMgt.AddAssetToContract(Rec."Contract No.", FixedRealEstate."No.", Role);
        CurrPage.Update(false);
    end;
}
