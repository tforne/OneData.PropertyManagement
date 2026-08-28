page 96977 "OD AM Occupancy View"
{
    Caption = 'Ocupacion de activos';
    PageType = List;
    SourceTable = "OD AM Occupancy Buffer";
    SourceTableTemporary = true;
    ApplicationArea = All;
    UsageCategory = Lists;
    Editable = false;

    layout
    {
        area(Content)
        {
            group(Filters)
            {
                Caption = 'Filtros';

                field(SelectedPropertyNo; SelectedPropertyNo)
                {
                    Caption = 'Property No.';
                    ToolTip = 'Selecciona la propiedad raiz para revisar la ocupacion.';

                    trigger OnLookup(var Text: Text): Boolean
                    var
                        PropertyFixedRealEstate: Record "Fixed Real Estate";
                    begin
                        PropertyFixedRealEstate.SetRange(Type, PropertyFixedRealEstate.Type::Propiedad);
                        if Page.RunModal(Page::"Fixed Real Estate List", PropertyFixedRealEstate) <> Action::LookupOK then
                            exit(false);

                        SelectedPropertyNo := PropertyFixedRealEstate."No.";
                        SelectedPropertyDescription := PropertyFixedRealEstate.Description;
                        RebuildBuffer();
                        Text := SelectedPropertyNo;
                        exit(true);
                    end;

                    trigger OnValidate()
                    begin
                        LoadPropertyDescription();
                        RebuildBuffer();
                    end;
                }
                field(SelectedPropertyDescription; SelectedPropertyDescription)
                {
                    Caption = 'Descripcion propiedad';
                    Editable = false;
                }
                field(SelectedDate; SelectedDate)
                {
                    Caption = 'Fecha';
                    ToolTip = 'Indica la fecha de referencia para calcular la ocupacion.';

                    trigger OnValidate()
                    begin
                        RebuildBuffer();
                    end;
                }
            }

            repeater(Occupancy)
            {
                field("Display Description"; Rec."Display Description")
                {
                    Caption = 'Estructura';
                }
                field("Asset Type"; Rec."Asset Type")
                {
                }
                field("Occupancy Status"; Rec."Occupancy Status")
                {
                }
                field("Current Contract No."; Rec."Current Contract No.")
                {
                }
                field("Customer No."; Rec."Customer No.")
                {
                }
                field("Starting Date"; Rec."Starting Date")
                {
                }
                field("Ending Date"; Rec."Ending Date")
                {
                }
                field("Occupancy Percentage"; Rec."Occupancy Percentage")
                {
                }
            }
        }
    }

    actions
    {
        area(Processing)
        {
            action(RefreshView)
            {
                Caption = 'Actualizar ocupacion';
                Image = Refresh;
                Promoted = true;
                PromotedCategory = Process;

                trigger OnAction()
                begin
                    RebuildBuffer();
                end;
            }
            action(ViewContract)
            {
                Caption = 'Ver contrato';
                Image = ContractPayment;
                Promoted = true;
                PromotedCategory = Process;

                trigger OnAction()
                var
                    LeaseContract: Record "Lease Contract";
                begin
                    if Rec."Current Contract No." = '' then
                        Error(NoContractErr);

                    LeaseContract.Get(Rec."Current Contract No.");
                    Page.Run(Page::"OD AM Lease Contract Card", LeaseContract);
                end;
            }
            action(OpenAvailabilitySearch)
            {
                Caption = 'Buscar disponibles';
                Image = Calculate;

                trigger OnAction()
                var
                    AvailabilityPage: Page "OD AM Asset Availability";
                begin
                    AvailabilityPage.SetRequest(SelectedPropertyNo, Enum::"OD Asset Type"::Undefined, SelectedDate, SelectedDate);
                    AvailabilityPage.Run();
                end;
            }
            action(OpenAssetCard)
            {
                Caption = 'Abrir activo';
                Image = FixedAssets;

                trigger OnAction()
                var
                    FixedRealEstate: Record "Fixed Real Estate";
                begin
                    if Rec."Fixed Real Estate No." = '' then
                        exit;

                    if not FixedRealEstate.Get(Rec."Fixed Real Estate No.") then
                        exit;

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
                    if Rec."Property No." = '' then
                        exit;

                    AssetStructurePage.SetSelectedProperty(Rec."Property No.");
                    AssetStructurePage.Run();
                end;
            }
            action(GoToToday)
            {
                Caption = 'Ir a hoy';
                Image = Workdays;

                trigger OnAction()
                begin
                    SelectedDate := WorkDate();
                    RebuildBuffer();
                end;
            }
        }
    }

    trigger OnOpenPage()
    begin
        if SelectedDate = 0D then
            SelectedDate := WorkDate();
        RebuildBuffer();
    end;

    var
        AssetStructureMgt: Codeunit "OD AM Asset Structure Mgt.";
        OccupancyMgt: Codeunit "OD AM Occupancy Mgt.";
        SelectedPropertyNo: Code[20];
        SelectedPropertyDescription: Text[100];
        SelectedDate: Date;
        NoContractErr: Label 'La linea seleccionada no tiene un contrato activo asociado.';

    procedure SetPropertyAndDate(PropertyNo: Code[20]; OnDate: Date)
    begin
        SelectedPropertyNo := PropertyNo;
        SelectedDate := OnDate;
        if SelectedDate = 0D then
            SelectedDate := WorkDate();
        LoadPropertyDescription();
        RebuildBuffer();
    end;

    local procedure RebuildBuffer()
    var
        TempAssetStructureBuffer: Record "OD AM Asset Structure Buffer" temporary;
        LeaseContract: Record "Lease Contract";
        EntryNo: Integer;
    begin
        Rec.Reset();
        Rec.DeleteAll();

        if SelectedPropertyNo = '' then begin
            CurrPage.Update(false);
            exit;
        end;

        AssetStructureMgt.BuildAssetStructureBuffer(TempAssetStructureBuffer, SelectedPropertyNo);
        if TempAssetStructureBuffer.FindSet() then
            repeat
                EntryNo += 1;
                Rec.Init();
                Rec."Entry No." := EntryNo;
                Rec."Property No." := TempAssetStructureBuffer."Property No.";
                Rec."Fixed Real Estate No." := TempAssetStructureBuffer."Fixed Real Estate No.";
                Rec."Parent FRE No." := TempAssetStructureBuffer."Parent FRE No.";
                Rec."Asset Type" := TempAssetStructureBuffer."Asset Type";
                Rec.Description := TempAssetStructureBuffer.Description;
                Rec."Hierarchy Level" := TempAssetStructureBuffer."Hierarchy Level";
                Rec."Display Description" := TempAssetStructureBuffer."Display Description";
                Rec."Occupancy Status" := OccupancyMgt.GetOccupancyStatus(Rec."Fixed Real Estate No.", SelectedDate);
                Rec."Occupancy Percentage" := OccupancyMgt.GetOccupancyPercentage(Rec."Fixed Real Estate No.", SelectedDate);

                if OccupancyMgt.GetBlockingContractForAsset(Rec."Fixed Real Estate No.", SelectedDate, LeaseContract) then begin
                    Rec."Current Contract No." := LeaseContract."Contract No.";
                    Rec."Customer No." := LeaseContract."Customer No.";
                    Rec."Starting Date" := LeaseContract."Starting Date";
                    Rec."Ending Date" := LeaseContract."Expiration Date";
                end;

                Rec.Insert();
            until TempAssetStructureBuffer.Next() = 0;

        CurrPage.Update(false);
    end;

    local procedure LoadPropertyDescription()
    var
        PropertyFixedRealEstate: Record "Fixed Real Estate";
    begin
        if (SelectedPropertyNo <> '') and PropertyFixedRealEstate.Get(SelectedPropertyNo) then
            SelectedPropertyDescription := PropertyFixedRealEstate.Description
        else
            Clear(SelectedPropertyDescription);
    end;
}
