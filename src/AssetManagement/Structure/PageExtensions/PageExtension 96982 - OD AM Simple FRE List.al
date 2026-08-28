pageextension 96982 "OD AM Simple FRE List Ext" extends "Simple Fixed Real Estate List"
{
    layout
    {
        addafter("Post Code")
        {
            field("Property No."; Rec."Property No.")
            {
                ApplicationArea = All;
                ToolTip = 'Muestra la propiedad raiz a la que pertenece el activo.';
            }
            field("Property Description"; Rec."Property Description")
            {
                ApplicationArea = All;
                ToolTip = 'Muestra la descripcion de la propiedad raiz.';
            }
            field("OD Asset Type"; Rec."OD Asset Type")
            {
                ApplicationArea = All;
                Caption = 'Tipo Asset Management';
                ToolTip = 'Muestra la clasificacion operativa del activo para Asset Management.';
                Style = Strong;
                StyleExpr = HighlightByAssetType;
            }
            field("OD Parent FRE No."; Rec."OD Parent FRE No.")
            {
                ApplicationArea = All;
                Caption = 'Activo padre';
                ToolTip = 'Muestra el activo padre inmediato dentro de la jerarquia de Asset Management.';
            }
            field(Status; Rec.Status)
            {
                ApplicationArea = All;
                ToolTip = 'Muestra el estado comercial u operativo actual del activo.';
            }
            field("Last Rental Price"; Rec."Last Rental Price")
            {
                ApplicationArea = All;
                Caption = 'Ultima renta';
                ToolTip = 'Muestra la ultima renta registrada del activo.';
                BlankZero = true;
            }
        }
        addlast(FactBoxes)
        {
            part(ODAMPropertyAssetFactBox; "OD AM Property Asset FactBox")
            {
                ApplicationArea = All;
                SubPageLink = "No." = field("Property No.");
            }
            part(ODAMSecondaryUnitsListPart; "OD AM Secondary Units FB")
            {
                ApplicationArea = All;
            }
        }
    }

    actions
    {
        addlast(Processing)
        {
            action(FilterAllAssets)
            {
                Caption = 'Todos los activos';
                ApplicationArea = All;
                Image = RemoveFilterLines;
                Promoted = true;
                PromotedCategory = Process;

                trigger OnAction()
                begin
                    ClearAssetTypeFilter();
                end;
            }
            action(FilterDwellings)
            {
                Caption = 'Solo viviendas';
                ApplicationArea = All;
                Image = Home;
                Promoted = true;
                PromotedCategory = Process;

                trigger OnAction()
                begin
                    ApplyAssetTypeFilter(Rec."OD Asset Type"::Dwelling);
                end;
            }
            action(FilterRooms)
            {
                Caption = 'Solo habitaciones';
                ApplicationArea = All;
                Image = ItemGroup;

                trigger OnAction()
                begin
                    ApplyAssetTypeFilter(Rec."OD Asset Type"::Room);
                end;
            }
            action(FilterParking)
            {
                Caption = 'Solo parkings';
                ApplicationArea = All;
                Image = Allocations;

                trigger OnAction()
                begin
                    ApplyAssetTypeFilter(Rec."OD Asset Type"::Parking);
                end;
            }
            action(FilterStorage)
            {
                Caption = 'Solo trasteros';
                ApplicationArea = All;
                Image = Warehouse;

                trigger OnAction()
                begin
                    ApplyAssetTypeFilter(Rec."OD Asset Type"::Storage);
                end;
            }
            action(OpenAssetStructure)
            {
                Caption = 'Abrir estructura';
                ApplicationArea = All;
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
            action(OpenAvailability)
            {
                Caption = 'Ver disponibilidad';
                ApplicationArea = All;
                Image = ViewDetails;

                trigger OnAction()
                var
                    AvailabilityPage: Page "OD AM Asset Availability";
                begin
                    if Rec."Property No." = '' then
                        exit;

                    AvailabilityPage.SetRequest(Rec."Property No.", Rec."OD Asset Type", WorkDate(), WorkDate());
                    AvailabilityPage.Run();
                end;
            }
            action(OpenClassicAssetCard)
            {
                Caption = 'Abrir ficha';
                ApplicationArea = All;
                Image = EditLines;

                trigger OnAction()
                var
                    FixedRealEstate: Record "Fixed Real Estate";
                begin
                    if not FixedRealEstate.Get(Rec."No.") then
                        exit;

                    Page.Run(Page::"Fixed Real Estate Card", FixedRealEstate);
                end;
            }
        }
    }

    trigger OnAfterGetCurrRecord()
    begin
        HighlightByAssetType := Rec."OD Asset Type" <> Rec."OD Asset Type"::Undefined;
        CurrPage.ODAMSecondaryUnitsListPart.Page.SetContext(Rec."No.");
    end;

    var
        HighlightByAssetType: Boolean;

    local procedure ApplyAssetTypeFilter(AssetType: Enum "OD Asset Type")
    begin
        Rec.FilterGroup(2);
        Rec.SetRange("OD Asset Type", AssetType);
        Rec.FilterGroup(0);
        CurrPage.Update(false);
    end;

    local procedure ClearAssetTypeFilter()
    begin
        Rec.FilterGroup(2);
        Rec.SetRange("OD Asset Type");
        Rec.FilterGroup(0);
        CurrPage.Update(false);
    end;
}
