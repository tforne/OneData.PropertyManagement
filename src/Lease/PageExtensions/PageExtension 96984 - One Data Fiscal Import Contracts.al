pageextension 96984 "OD Fiscal Import Contracts" extends "One Data Fiscal"
{
    actions
    {

        addlast(ToolsImport)
        {
            group(ODLeaseContractsMenu)
            {
                Caption = 'Contratos de alquiler';

                action(ODImportAssetStructure)
                {
                    Caption = 'Importar estructura de activos';
                    ApplicationArea = All;
                    Image = Import;
                    ToolTip = 'Abrir el importador para cargar la estructura de activos desde Excel.';
                    RunObject = page "OD AM Asset Import List";
                }

                action(ODImportContractsProcess)
                {
                    Caption = 'Importar contratos';
                    ApplicationArea = All;
                    Image = Import;
                    ToolTip = 'Abrir el importador de cabeceras de contratos de alquiler con la informacion minima.';
                    RunObject = page "OD Lease Contract Import List";
                }
            }
        }
    }
}
