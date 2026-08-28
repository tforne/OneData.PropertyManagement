pageextension 96968 "OD AM Asset Struct Contracts" extends "OD AM Asset Structure"
{
    actions
    {
        addafter(RefreshStructure)
        {
            action(ViewContracts)
            {
                Caption = 'Ver contratos';
                ApplicationArea = All;
                Image = ContractPayment;
                Promoted = true;
                PromotedCategory = Process;

                trigger OnAction()
                var
                    ContractAssetMgt: Codeunit "OD AM Contract Asset Mgt.";
                begin
                    if Rec."Fixed Real Estate No." = '' then
                        Error(NoAssetSelectionErr);

                    ContractAssetMgt.OpenContractsForAssetSelection(Rec."Fixed Real Estate No.", Rec."Property No.", Rec."Is Property");
                end;
            }
            action(ViewAvailability)
            {
                Caption = 'Ver disponibilidad';
                ApplicationArea = All;
                Image = ViewDetails;
                Promoted = true;
                PromotedCategory = Process;

                trigger OnAction()
                var
                    OccupancyView: Page "OD AM Occupancy View";
                begin
                    if Rec."Property No." = '' then
                        Error(NoAssetSelectionErr);

                    OccupancyView.SetPropertyAndDate(Rec."Property No.", WorkDate());
                    OccupancyView.Run();
                end;
            }
        }
    }

    var
        NoAssetSelectionErr: Label 'Debe seleccionar una propiedad o activo de la estructura.';
}
