page 96940 "OD AM Asset Structure"
{
    PageType = List;
    SourceTable = "OD AM Asset Structure Buffer";
    SourceTableView = sorting("Display Order");
    Caption = 'Estructura de activos';
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
                    ToolTip = 'Selecciona la propiedad raiz cuya estructura se va a mostrar. Si queda vacio, se muestran todas las propiedades.';

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
                        LoadSelectedPropertyDescription();
                        RebuildBuffer();
                    end;
                }
                field(SelectedPropertyDescription; SelectedPropertyDescription)
                {
                    Caption = 'Descripcion propiedad';
                    Editable = false;
                }
            }
            group(ContextSummary)
            {
                Caption = 'Contexto';

                field(CurrentContextAssetNo; CurrentContextAssetNo)
                {
                    Caption = 'Activo seleccionado';
                    Editable = false;
                }
                field(CurrentContextAssetType; CurrentContextAssetType)
                {
                    Caption = 'Tipo';
                    Editable = false;
                }
                field(VisibleLinesCount; VisibleLinesCount)
                {
                    Caption = 'Lineas visibles';
                    Editable = false;
                }
                field(VisiblePropertiesCount; VisiblePropertiesCount)
                {
                    Caption = 'Propiedades visibles';
                    Editable = false;
                }
            }

            repeater(Structure)
            {
                field("Display Description"; Rec."Display Description")
                {
                    Caption = 'Estructura';
                    ToolTip = 'Muestra la estructura jerarquica de la propiedad seleccionada.';
                    Style = Strong;
                    StyleExpr = IsPropertyStyle;
                }
                field("Asset Type"; Rec."Asset Type")
                {
                    ToolTip = 'Muestra la clasificacion del activo.';
                    Style = Strong;
                    StyleExpr = IsPropertyStyle;
                }
                field(Status; Rec.Status)
                {
                    ToolTip = 'Muestra el estado actual del activo.';
                    Style = Strong;
                    StyleExpr = IsPropertyStyle;
                }
                field("Property No."; Rec."Property No.")
                {
                    ToolTip = 'Muestra la propiedad raiz asociada al registro.';
                    Style = Strong;
                    StyleExpr = IsPropertyStyle;
                }
                field("Parent FRE No."; Rec."Parent FRE No.")
                {
                    ToolTip = 'Muestra el padre jerarquico del registro.';
                    Style = Strong;
                    StyleExpr = IsPropertyStyle;
                }
                field("Has Children"; Rec."Has Children")
                {
                    ToolTip = 'Indica si el registro tiene hijos en la estructura.';
                    Style = Strong;
                    StyleExpr = IsPropertyStyle;
                }
                field("Rental Price"; Rec."Rental Price")
                {
                    ToolTip = 'Muestra la ultima renta registrada del activo.';
                    Style = Strong;
                    StyleExpr = IsPropertyStyle;
                }
            }
        }
        area(FactBoxes)
        {
            part(PropertyAssetFactBox; "OD AM Property Asset FactBox")
            {
                ApplicationArea = All;
                SubPageLink = "No." = field("Property No.");
            }
            part(AssetContextFactBox; "OD AM Asset Context FB")
            {
                ApplicationArea = All;
            }
        }
    }

    actions
    {
        area(Processing)
        {
            action(NewDwelling)
            {
                Caption = 'Nueva vivienda';
                Image = New;
                Promoted = true;
                PromotedCategory = Process;

                trigger OnAction()
                begin
                    CreateAssetUnderRoot(Rec."Asset Type"::Dwelling);
                end;
            }
            action(NewRoom)
            {
                Caption = 'Nueva habitacion';
                Image = New;
                Promoted = true;
                PromotedCategory = Process;

                trigger OnAction()
                begin
                    CreateRoomUnderSelectedAsset();
                end;
            }
            action(NewParking)
            {
                Caption = 'Nuevo parking';
                Image = New;
                Promoted = true;
                PromotedCategory = Process;

                trigger OnAction()
                begin
                    CreateAssetUnderRoot(Rec."Asset Type"::Parking);
                end;
            }
            action(NewStorage)
            {
                Caption = 'Nuevo trastero';
                Image = New;
                Promoted = true;
                PromotedCategory = Process;

                trigger OnAction()
                begin
                    CreateAssetUnderRoot(Rec."Asset Type"::Storage);
                end;
            }
            action(NewAsset)
            {
                Caption = 'Nuevo activo';
                Image = New;
                Promoted = true;
                PromotedCategory = Process;

                trigger OnAction()
                begin
                    CreateGenericAsset();
                end;
            }
            action(OpenClassicCard)
            {
                Caption = 'Abrir ficha clasica';
                Image = EditLines;
                Promoted = true;
                PromotedCategory = Process;

                trigger OnAction()
                var
                    FixedRealEstate: Record "Fixed Real Estate";
                begin
                    EnsureCurrentLineSelected();
                    FixedRealEstate.Get(Rec."Fixed Real Estate No.");
                    Page.Run(Page::"Fixed Real Estate Card", FixedRealEstate);
                end;
            }
            action(RefreshStructure)
            {
                Caption = 'Actualizar estructura';
                Image = Refresh;
                Promoted = true;
                PromotedCategory = Process;

                trigger OnAction()
                begin
                    RebuildBuffer();
                end;
            }
            action(ShowAllProperties)
            {
                Caption = 'Mostrar todas las propiedades';
                Image = ShowList;

                trigger OnAction()
                begin
                    Clear(SelectedPropertyNo);
                    LoadSelectedPropertyDescription();
                    RebuildBuffer();
                end;
            }
            action(FilterAllTypes)
            {
                Caption = 'Todos los tipos';
                Image = RemoveFilterLines;

                trigger OnAction()
                begin
                    ClearTypeFilter();
                end;
            }
            action(FilterDwellings)
            {
                Caption = 'Solo viviendas';
                Image = Home;

                trigger OnAction()
                begin
                    ApplyTypeFilter(Rec."Asset Type"::Dwelling);
                end;
            }
            action(FilterRooms)
            {
                Caption = 'Solo habitaciones';
                Image = ItemGroup;

                trigger OnAction()
                begin
                    ApplyTypeFilter(Rec."Asset Type"::Room);
                end;
            }
            action(FilterParkings)
            {
                Caption = 'Solo parkings';
                Image = Allocations;

                trigger OnAction()
                begin
                    ApplyTypeFilter(Rec."Asset Type"::Parking);
                end;
            }
            action(FilterStorages)
            {
                Caption = 'Solo trasteros';
                Image = Warehouse;

                trigger OnAction()
                begin
                    ApplyTypeFilter(Rec."Asset Type"::Storage);
                end;
            }
        }
    }

    trigger OnOpenPage()
    begin
        LoadSelectedPropertyDescription();
        RebuildBuffer();
    end;

    trigger OnAfterGetRecord()
    begin
        UpdateRowStyle();
    end;

    trigger OnAfterGetCurrRecord()
    begin
        UpdateRowStyle();
        RefreshContextSummary();
        UpdateFactBox();
    end;

    var
        AssetStructureMgt: Codeunit "OD AM Asset Structure Mgt.";
        SelectedPropertyNo: Code[20];
        SelectedPropertyDescription: Text[100];
        NoSelectionErr: Label 'Debe seleccionar una linea de la estructura.';
        InvalidRoomParentErr: Label 'La accion Nueva habitacion solo esta disponible cuando el activo seleccionado es una vivienda.';
        PropertySelectionRequiredErr: Label 'Debe seleccionar primero una propiedad valida.';
        AllPropertiesLbl: Label 'Todas las propiedades';
        IsPropertyStyle: Boolean;
        CurrentContextAssetNo: Text[100];
        CurrentContextAssetType: Text[50];
        VisibleLinesCount: Integer;
        VisiblePropertiesCount: Integer;

    local procedure UpdateRowStyle()
    begin
        IsPropertyStyle := Rec."Is Property";
    end;

    local procedure RebuildBuffer()
    var
        TempCountBuffer: Record "OD AM Asset Structure Buffer" temporary;
    begin
        Rec.Reset();
        Rec.DeleteAll();
        AssetStructureMgt.BuildAssetStructureBuffer(Rec, SelectedPropertyNo);
        TempCountBuffer.Copy(Rec, true);
        RefreshVisibleCounters(TempCountBuffer);
        UpdateFactBox();
        CurrPage.Update(false);
    end;

    local procedure CreateAssetUnderRoot(AssetType: Enum "OD Asset Type")
    var
        RootProperty: Record "Fixed Real Estate";
    begin
        RootProperty := GetRootPropertyRecord();
        OpenCreatedAssetCard(AssetStructureMgt.CreateChildAsset(RootProperty, AssetType));
    end;

    local procedure CreateRoomUnderSelectedAsset()
    var
        ParentFixedRealEstate: Record "Fixed Real Estate";
    begin
        EnsureCurrentLineSelected();
        ParentFixedRealEstate.Get(Rec."Fixed Real Estate No.");
        if (ParentFixedRealEstate.Type <> ParentFixedRealEstate.Type::Activo) or
           (ParentFixedRealEstate."OD Asset Type" <> ParentFixedRealEstate."OD Asset Type"::Dwelling)
        then
            Error(InvalidRoomParentErr);

        OpenCreatedAssetCard(AssetStructureMgt.CreateChildAsset(ParentFixedRealEstate, ParentFixedRealEstate."OD Asset Type"::Room));
    end;

    local procedure CreateGenericAsset()
    var
        AssetCreateRequest: Record "OD AM Asset Create Req." temporary;
        NewAssetDialog: Page "OD AM New Asset";
        ParentFixedRealEstate: Record "Fixed Real Estate";
    begin
        AssetCreateRequest.Init();
        AssetCreateRequest."Entry No." := 1;
        AssetCreateRequest."Asset Type" := AssetCreateRequest."Asset Type"::Undefined;
        AssetCreateRequest.Insert();

        NewAssetDialog.SetRecord(AssetCreateRequest);
        NewAssetDialog.LookupMode(true);
        if NewAssetDialog.RunModal() <> Action::LookupOK then
            exit;

        NewAssetDialog.GetRecord(AssetCreateRequest);

        if Rec."Fixed Real Estate No." <> '' then
            ParentFixedRealEstate.Get(Rec."Fixed Real Estate No.")
        else
            ParentFixedRealEstate := GetRootPropertyRecord();

        OpenCreatedAssetCard(AssetStructureMgt.CreateChildAsset(ParentFixedRealEstate, AssetCreateRequest."Asset Type"));
    end;

    local procedure GetRootPropertyRecord(): Record "Fixed Real Estate"
    var
        RootProperty: Record "Fixed Real Estate";
        SelectedFixedRealEstate: Record "Fixed Real Estate";
    begin
        if SelectedPropertyNo <> '' then begin
            RootProperty.Get(SelectedPropertyNo);
            exit(RootProperty);
        end;

        EnsureCurrentLineSelected();
        SelectedFixedRealEstate.Get(Rec."Fixed Real Estate No.");
        if SelectedFixedRealEstate.Type <> SelectedFixedRealEstate.Type::Propiedad then
            Error(PropertySelectionRequiredErr);

        exit(SelectedFixedRealEstate);
    end;

    local procedure OpenCreatedAssetCard(NewFixedRealEstateNo: Code[20])
    var
        NewFixedRealEstate: Record "Fixed Real Estate";
    begin
        if NewFixedRealEstateNo = '' then
            exit;

        NewFixedRealEstate.Get(NewFixedRealEstateNo);
        Page.Run(Page::"Fixed Real Estate Card", NewFixedRealEstate);
        RebuildBuffer();
    end;

    local procedure EnsureCurrentLineSelected()
    begin
        if Rec."Fixed Real Estate No." = '' then
            Error(NoSelectionErr);
    end;

    procedure SetSelectedProperty(PropertyNo: Code[20])
    begin
        SelectedPropertyNo := PropertyNo;
        LoadSelectedPropertyDescription();
        RebuildBuffer();
    end;

    local procedure LoadSelectedPropertyDescription()
    var
        PropertyFixedRealEstate: Record "Fixed Real Estate";
    begin
        if SelectedPropertyNo = '' then begin
            SelectedPropertyDescription := CopyStr(AllPropertiesLbl, 1, MaxStrLen(SelectedPropertyDescription));
            exit;
        end;

        if PropertyFixedRealEstate.Get(SelectedPropertyNo) then
            SelectedPropertyDescription := PropertyFixedRealEstate.Description
        else
            Clear(SelectedPropertyDescription);
    end;

    local procedure UpdateFactBox()
    begin
        CurrPage.AssetContextFactBox.Page.SetContext(Rec."Fixed Real Estate No.");
    end;

    local procedure ApplyTypeFilter(AssetType: Enum "OD Asset Type")
    var
        TempCountBuffer: Record "OD AM Asset Structure Buffer" temporary;
    begin
        Rec.FilterGroup(2);
        Rec.SetRange("Asset Type", AssetType);
        Rec.FilterGroup(0);
        TempCountBuffer.Copy(Rec, true);
        RefreshVisibleCounters(TempCountBuffer);
        CurrPage.Update(false);
    end;

    local procedure ClearTypeFilter()
    var
        TempCountBuffer: Record "OD AM Asset Structure Buffer" temporary;
    begin
        Rec.FilterGroup(2);
        Rec.SetRange("Asset Type");
        Rec.FilterGroup(0);
        TempCountBuffer.Copy(Rec, true);
        RefreshVisibleCounters(TempCountBuffer);
        CurrPage.Update(false);
    end;

    local procedure RefreshVisibleCounters(var TempAssetStructureBuffer: Record "OD AM Asset Structure Buffer" temporary)
    begin
        Clear(VisibleLinesCount);
        Clear(VisiblePropertiesCount);
        if TempAssetStructureBuffer.FindSet() then
            repeat
                VisibleLinesCount += 1;
                if TempAssetStructureBuffer."Is Property" then
                    VisiblePropertiesCount += 1;
            until TempAssetStructureBuffer.Next() = 0;
    end;

    local procedure RefreshContextSummary()
    begin
        if Rec."Fixed Real Estate No." = '' then begin
            Clear(CurrentContextAssetNo);
            Clear(CurrentContextAssetType);
            exit;
        end;

        CurrentContextAssetNo := CopyStr(Rec."Fixed Real Estate No." + ' ' + Rec.Description, 1, MaxStrLen(CurrentContextAssetNo));
        CurrentContextAssetType := Format(Rec."Asset Type");
    end;
}
