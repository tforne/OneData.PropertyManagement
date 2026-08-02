pageextension 96861 "FRE Annual Income Export" extends "Simple Fixed Real Estate List"
{
    actions
    {
        addlast(processing)
        {
            action(ExportAnnualIncomeByOwner)
            {
                ApplicationArea = All;
                Caption = 'Exportar ingresos anuales';
                Image = ExportToExcel;
                Promoted = true;
                PromotedCategory = Process;
                ToolTip = 'Exporta un Excel con ingresos y gastos anuales por activo y propietario.';

                trigger OnAction()
                var
                    AnnualIncomeReport: Report "FRE Annual Income Excel";
                begin
                    AnnualIncomeReport.SetTableView(Rec);
                    AnnualIncomeReport.RunModal();
                end;
             }
        }
    }
}
