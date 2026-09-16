page 96944 "OD AM New Asset"
{
    PageType = StandardDialog;
    Caption = 'Nuevo activo';

    layout
    {
        area(Content)
        {
            group(General)
            {
                Caption = 'General';

                field("Asset Type"; SelectedAssetType)
                {
                    ApplicationArea = All;
                    Caption = 'Tipo de activo';
                    ToolTip = 'Selecciona el tipo de activo que se va a crear.';
                }
            }
        }
    }

    var
        SelectedAssetType: Enum "OD Asset Type";

    procedure SetAssetType(AssetType: Enum "OD Asset Type")
    begin
        SelectedAssetType := AssetType;
    end;

    procedure GetAssetType(): Enum "OD Asset Type"
    begin
        exit(SelectedAssetType);
    end;
}
