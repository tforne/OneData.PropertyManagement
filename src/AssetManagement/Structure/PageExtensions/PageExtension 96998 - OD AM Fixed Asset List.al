pageextension 96998 "OD AM Fixed Asset List" extends "Fixed Asset List"
{
    actions
    {
        addlast(processing)
        {
            action(ODCreateAssetStructureBuffer)
            {
                ApplicationArea = All;
                Caption = 'Generar buffer activos inmobiliarios';
                Image = CreateLinesFromJob;
                ToolTip = 'Genera un lote en el buffer de estructura de activos a partir de los activos fijos seleccionados para completar la jerarquia y crear despues los activos inmobiliarios.';

                trigger OnAction()
                var
                    FixedAsset: Record "Fixed Asset";
                    AssetImportMgt: Codeunit "OD AM Asset Import Mgt.";
                    AssetImport: Record "OD AM Asset Import";
                    BatchId: Guid;
                    EmptyGuid: Guid;
                begin
                    CurrPage.SetSelectionFilter(FixedAsset);
                    BatchId := AssetImportMgt.CreateBatchFromFixedAssets(FixedAsset);
                    if BatchId = EmptyGuid then
                        exit;

                    AssetImport.SetRange("Import Batch ID", BatchId);
                    Page.Run(Page::"OD AM Asset Import List", AssetImport);
                end;
            }
        }
    }
}
