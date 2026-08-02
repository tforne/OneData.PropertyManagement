pageextension 96862 "Lease Contract Selected Inv." extends "Lease Contract List"
{
    actions
    {
        addlast("F&unctions")
        {
            action(InvoiceSelectedContracts)
            {
                ApplicationArea = All;
                Caption = 'Facturar contratos seleccionados';
                Image = Invoice;
                Promoted = true;
                PromotedCategory = Process;
                PromotedIsBig = true;
                ToolTip = 'Ejecuta la facturacion solo para los contratos de alquiler seleccionados en la lista.';

                trigger OnAction()
                var
                    SelectedLeaseContract: Record "Lease Contract";
                    NoContractsSelectedErr: Label 'Debe seleccionar al menos un contrato de alquiler.';
                begin
                    CurrPage.SetSelectionFilter(SelectedLeaseContract);

                    if SelectedLeaseContract.IsEmpty() then
                        Error(NoContractsSelectedErr);

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
