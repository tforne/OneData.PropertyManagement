page 96944 "OD AM New Asset"
{
    PageType = StandardDialog;
    SourceTable = "OD AM Asset Create Req.";
    Caption = 'Nuevo activo';

    layout
    {
        area(Content)
        {
            group(General)
            {
                Caption = 'General';

                field("Asset Type"; Rec."Asset Type")
                {
                    ToolTip = 'Selecciona el tipo de activo que se va a crear.';
                }
            }
        }
    }
}
