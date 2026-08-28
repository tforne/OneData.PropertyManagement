page 96950 "OD FF Setup"
{
    PageType = Card;
    SourceTable = "OD FF Setup";
    ApplicationArea = All;
    UsageCategory = Administration;
    Caption = 'OD Financial Flow Setup';

    layout
    {
        area(Content)
        {
            group(General)
            {
                Caption = 'General';

                field("Include Inactive Companies"; Rec."Include Inactive Companies")
                {
                    ToolTip = 'Especifica si se incluyen empresas inactivas en el análisis.';
                }
                field("Include Blocked Companies"; Rec."Include Blocked Companies")
                {
                    ToolTip = 'Especifica si se incluyen empresas bloqueadas.';
                }
                field("Exclude Test Companies"; Rec."Exclude Test Companies")
                {
                    ToolTip = 'Especifica si se excluyen empresas de prueba.';
                }
                field("Test Company Filter"; Rec."Test Company Filter")
                {
                    ToolTip = 'Indica el filtro de nombres de empresas de prueba.';

                    trigger OnLookup(var Text: Text): Boolean
                    var
                        Company: Record Company;
                        CompaniesPage: Page Companies;
                    begin
                        CompaniesPage.LookupMode(true);
                        CompaniesPage.SetRecord(Company);
                        if CompaniesPage.RunModal() <> Action::LookupOK then
                            exit(false);

                        CompaniesPage.GetRecord(Company);
                        AddCompanyToTestFilter(Company.Name);
                        Text := Rec."Test Company Filter";
                        Rec.Modify();
                        CurrPage.Update(false);
                        exit(true);
                    end;
                }
                field("Include Expired Contracts"; Rec."Include Expired Contracts")
                {
                    ToolTip = 'Especifica si se incluyen contratos vencidos.';
                }
                field("Include Future Contracts"; Rec."Include Future Contracts")
                {
                    ToolTip = 'Especifica si se incluyen contratos futuros.';
                }
                field("Include Cancelled Contracts"; Rec."Include Cancelled Contracts")
                {
                    ToolTip = 'Especifica si se incluyen contratos cancelados.';
                }
            }
            group(Finance)
            {
                Caption = 'Finanzas';

                field("Default Market Value Source"; Rec."Default Market Value Source")
                {
                    ToolTip = 'Indica el origen de valoración preferente cuando existan varios importes.';
                }
                field("Default Selling Cost Percentage"; Rec."Default Selling Cost %")
                {
                    ToolTip = 'Indica el porcentaje de costes de venta usado para la plusvalía estimada.';
                }
                field("Default Annual Maint. %"; Rec."Default Annual Maint. %")
                {
                    ToolTip = 'Indica el porcentaje anual de mantenimiento a aplicar.';
                }
                field("Default Vacancy Percentage"; Rec."Default Vacancy Percentage")
                {
                    ToolTip = 'Indica el porcentaje de vacancia estimada.';
                }
                field("Default Management Cost %"; Rec."Default Management Cost %")
                {
                    ToolTip = 'Indica el porcentaje de coste de gestión.';
                }
                field("Default Discount Rate"; Rec."Default Discount Rate")
                {
                    ToolTip = 'Indica la tasa de descuento de referencia.';
                }
                field("Minimum Target Yield"; Rec."Minimum Target Yield")
                {
                    ToolTip = 'Indica la rentabilidad objetivo mínima usada en el análisis de riesgo.';
                }
                field("Max. Customer Concentration %"; Rec."Max. Customer Concentration %")
                {
                    ToolTip = 'Indica el porcentaje máximo de concentración admisible por cliente.';
                }
                field("Warning Days Before End"; Rec."Warning Days Before End")
                {
                    ToolTip = 'Indica cuántos días antes del vencimiento se considera un contrato próximo a vencer.';
                }
            }
            group(Snapshots)
            {
                Caption = 'Snapshots';

                field("Snapshot No. Series"; Rec."Snapshot No. Series")
                {
                    ToolTip = 'Indica la serie numérica para snapshots, si se configura.';
                }
                field("Last Analysis DateTime"; Rec."Last Analysis DateTime")
                {
                    Editable = false;
                    ToolTip = 'Muestra la fecha y hora del último análisis ejecutado.';
                }
                field("Last Snapshot No."; Rec."Last Snapshot No.")
                {
                    Editable = false;
                    ToolTip = 'Muestra el último snapshot generado.';
                }
            }
        }
    }

    trigger OnOpenPage()
    begin
        Rec.EnsureSetup();
        Rec.Get('SETUP');
    end;

    local procedure AddCompanyToTestFilter(CompanyName: Text)
    var
        NormalizedFilter: Text;
        CompanyToken: Text;
    begin
        CompanyToken := DelChr(CompanyName, '<>', ' ');
        NormalizedFilter := Rec."Test Company Filter";

        if NormalizedFilter = '' then begin
            Rec."Test Company Filter" := CopyStr(CompanyName, 1, MaxStrLen(Rec."Test Company Filter"));
            exit;
        end;

        if StrPos('|' + UpperCase(NormalizedFilter) + '|', '|' + UpperCase(CompanyToken) + '|') > 0 then
            exit;

        Rec."Test Company Filter" := CopyStr(NormalizedFilter + '|' + CompanyName, 1, MaxStrLen(Rec."Test Company Filter"));
    end;
}
