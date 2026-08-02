pageextension 96863 "Lease Contract Card Invoice" extends "Lease Contract Card"
{
    actions
    {
        addlast(Contract)
        {
            action(InvoiceCurrentContract)
            {
                ApplicationArea = All;
                Caption = 'Facturar contrato';
                Image = Invoice;
                Promoted = true;
                PromotedCategory = Process;
                PromotedIsBig = true;
                ToolTip = 'Ejecuta la facturacion solo para el contrato de alquiler actual.';

                trigger OnAction()
                var
                    SelectedLeaseContract: Record "Lease Contract";
                    NoContractSelectedErr: Label 'Debe seleccionar un contrato de alquiler.';
                begin
                    CurrPage.SaveRecord();

                    SelectedLeaseContract.SetRange("Contract No.", Rec."Contract No.");

                    if SelectedLeaseContract.IsEmpty() then
                        Error(NoContractSelectedErr);

                    Report.RunModal(
                        Report::"Create Lease Contract Invoices",
                        true,
                        false,
                        SelectedLeaseContract);
                end;
            }
        }
    }
}
