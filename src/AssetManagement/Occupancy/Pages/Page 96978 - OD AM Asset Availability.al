page 96978 "OD AM Asset Availability"
{
    Caption = 'Disponibilidad de activos';
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
                Caption = 'Consulta';

                field(SelectedPropertyNo; SelectedPropertyNo)
                {
                    Caption = 'Property No.';
                    ToolTip = 'Selecciona la propiedad raiz donde buscar activos disponibles.';

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
                    end;
                }
                field(SelectedPropertyDescription; SelectedPropertyDescription)
                {
                    Caption = 'Descripcion propiedad';
                    Editable = false;
                }
                field(SelectedAssetType; SelectedAssetType)
                {
                    Caption = 'Asset Type';

                    trigger OnValidate()
                    begin
                        RebuildBuffer();
                    end;
                }
                field(SelectedStartDate; SelectedStartDate)
                {
                    Caption = 'Starting Date';

                    trigger OnValidate()
                    begin
                        if SelectedEndDate = 0D then
                            SelectedEndDate := SelectedStartDate;
                        RebuildBuffer();
                    end;
                }
                field(SelectedEndDate; SelectedEndDate)
                {
                    Caption = 'Ending Date';

                    trigger OnValidate()
                    begin
                        RebuildBuffer();
                    end;
                }
            }

            repeater(AvailableAssets)
            {
                field("Fixed Real Estate No."; Rec."Fixed Real Estate No.")
                {
                }
                field(Description; Rec.Description)
                {
                }
                field("Asset Type"; Rec."Asset Type")
                {
                }
                field("Parent FRE No."; Rec."Parent FRE No.")
                {
                }
                field("Occupancy Status"; Rec."Occupancy Status")
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
            action(SearchAvailability)
            {
                Caption = 'Buscar disponibles';
                Image = Calculate;
                Promoted = true;
                PromotedCategory = Process;

                trigger OnAction()
                begin
                    RebuildBuffer();
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
            action(OpenAssetStructure)
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
            action(UseTodayRange)
            {
                Caption = 'Hoy';
                Image = Workdays;

                trigger OnAction()
                begin
                    SelectedStartDate := WorkDate();
                    SelectedEndDate := WorkDate();
                    RebuildBuffer();
                end;
            }
        }
    }

    trigger OnOpenPage()
    begin
        if SelectedStartDate = 0D then
            SelectedStartDate := WorkDate();
        if SelectedEndDate = 0D then
            SelectedEndDate := SelectedStartDate;
        RebuildBuffer();
    end;

    var
        OccupancyMgt: Codeunit "OD AM Occupancy Mgt.";
        SelectedPropertyNo: Code[20];
        SelectedPropertyDescription: Text[100];
        SelectedAssetType: Enum "OD Asset Type";
        SelectedStartDate: Date;
        SelectedEndDate: Date;

    procedure SetRequest(PropertyNo: Code[20]; AssetType: Enum "OD Asset Type"; StartDate: Date; EndDate: Date)
    begin
        SelectedPropertyNo := PropertyNo;
        SelectedAssetType := AssetType;
        SelectedStartDate := StartDate;
        SelectedEndDate := EndDate;
        if SelectedStartDate = 0D then
            SelectedStartDate := WorkDate();
        if SelectedEndDate = 0D then
            SelectedEndDate := SelectedStartDate;
        LoadPropertyDescription();
    end;

    local procedure RebuildBuffer()
    var
        TempFixedRealEstate: Record "Fixed Real Estate" temporary;
        EntryNo: Integer;
    begin
        Rec.Reset();
        Rec.DeleteAll();

        if SelectedPropertyNo = '' then begin
            CurrPage.Update(false);
            exit;
        end;

        OccupancyMgt.GetAvailableAssets(SelectedPropertyNo, SelectedAssetType, SelectedStartDate, SelectedEndDate, TempFixedRealEstate);
        if TempFixedRealEstate.FindSet() then
            repeat
                EntryNo += 1;
                Rec.Init();
                Rec."Entry No." := EntryNo;
                Rec."Property No." := SelectedPropertyNo;
                Rec."Fixed Real Estate No." := TempFixedRealEstate."No.";
                Rec."Parent FRE No." := TempFixedRealEstate."OD Parent FRE No.";
                Rec."Asset Type" := TempFixedRealEstate."OD Asset Type";
                Rec.Description := TempFixedRealEstate.Description;
                Rec."Hierarchy Level" := 0;
                Rec."Display Description" := TempFixedRealEstate."No." + ' ' + TempFixedRealEstate.Description;
                Rec."Occupancy Status" := Enum::"OD AM Occupancy Status"::Available;
                Rec."Occupancy Percentage" := OccupancyMgt.GetOccupancyPercentage(TempFixedRealEstate."No.", SelectedStartDate);
                Rec.Insert();
            until TempFixedRealEstate.Next() = 0;

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
