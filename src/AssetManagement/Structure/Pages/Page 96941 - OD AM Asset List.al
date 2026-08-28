page 96941 "OD AM Asset List"
{
    PageType = List;
    SourceTable = "Fixed Real Estate";
    SourceTableView = sorting("Property Description", "Property No.", Type, Description) where(Type = const(Activo));
    Caption = 'Activos';
    ApplicationArea = All;
    UsageCategory = Lists;
    CardPageId = "Fixed Real Estate Card";

    layout
    {
        area(Content)
        {
            repeater(Assets)
            {
                field("No."; Rec."No.")
                {
                    ToolTip = 'Muestra el codigo del activo.';
                    Style = Strong;
                    StyleExpr = HighlightTypedAsset;
                }
                field(Description; Rec.Description)
                {
                    ToolTip = 'Muestra la descripcion del activo.';
                    Style = Strong;
                    StyleExpr = HighlightTypedAsset;
                }
                field("Property No."; Rec."Property No.")
                {
                    ToolTip = 'Muestra la propiedad raiz del activo.';
                }
                field("Property Description"; Rec."Property Description")
                {
                    ToolTip = 'Muestra la descripcion de la propiedad raiz.';
                }
                field("OD Parent FRE No."; Rec."OD Parent FRE No.")
                {
                    ToolTip = 'Muestra el padre jerarquico del activo.';
                }
                field("OD Asset Type"; Rec."OD Asset Type")
                {
                    ToolTip = 'Muestra la clasificacion del activo.';
                    Style = Strong;
                    StyleExpr = HighlightTypedAsset;
                }
                field(Status; Rec.Status)
                {
                    ToolTip = 'Muestra el estado del activo.';
                }
                field("Sales price"; Rec."Sales price")
                {
                    ToolTip = 'Muestra el precio de venta del activo.';
                }
                field("Last Rental Price"; Rec."Last Rental Price")
                {
                    ToolTip = 'Muestra la ultima renta registrada del activo.';
                }
                field("Minimum Rental Price"; Rec."Minimum Rental Price")
                {
                    ToolTip = 'Muestra la renta minima del activo.';
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
            part(SecondaryUnitsFactBox; "OD AM Secondary Units FB")
            {
                ApplicationArea = All;
            }
        }
    }

    actions
    {
        area(Processing)
        {
            action(FilterAllAssetTypes)
            {
                Caption = 'Todos los tipos';
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
                Image = ItemGroup;

                trigger OnAction()
                begin
                    ApplyAssetTypeFilter(Rec."OD Asset Type"::Room);
                end;
            }
            action(FilterParking)
            {
                Caption = 'Solo parkings';
                Image = Allocations;

                trigger OnAction()
                begin
                    ApplyAssetTypeFilter(Rec."OD Asset Type"::Parking);
                end;
            }
            action(FilterStorage)
            {
                Caption = 'Solo trasteros';
                Image = Warehouse;

                trigger OnAction()
                begin
                    ApplyAssetTypeFilter(Rec."OD Asset Type"::Storage);
                end;
            }
            action(OpenAssetStructure)
            {
                Caption = 'Abrir estructura';
                Image = Hierarchy;
                Promoted = true;
                PromotedCategory = Process;

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
        }
    }

    trigger OnAfterGetCurrRecord()
    begin
        HighlightTypedAsset := Rec."OD Asset Type" <> Rec."OD Asset Type"::Undefined;
        CurrPage.SecondaryUnitsFactBox.Page.SetContext(Rec."No.");
    end;

    var
        HighlightTypedAsset: Boolean;

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
