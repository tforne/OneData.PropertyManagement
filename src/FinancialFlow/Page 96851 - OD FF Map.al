page 96951 "OD FF Map"
{
    PageType = ListPlus;
    SourceTable = "OD FF Buffer";
    ApplicationArea = All;
    UsageCategory = Lists;
    Caption = 'OneData Financial Flow Map';
    SourceTableView = sorting("User ID", "Company Name", "Property No.", "Contract No.");
    InsertAllowed = false;

    layout
    {
        area(Content)
        {
            group(Totals)
            {
                Caption = 'Totales';

                field(RegistrationDate; RegistrationDate)
                {
                    Caption = 'Fecha registro';
                    Editable = false;
                    ToolTip = 'Muestra la fecha del análisis actualmente cargado.';
                }
                field(CoveredPeriod; CoveredPeriod)
                {
                    Caption = 'Periodo comprendido';
                    ToolTip = 'Permite indicar el periodo comprendido mediante una fórmula de fecha.';
                }
                field(TotalCompanies; TotalCompanies)
                {
                    Caption = 'Empresas analizadas';
                    Editable = false;
                    ToolTip = 'Muestra el número de empresas analizadas.';
                }
                field(TotalProperties; TotalProperties)
                {
                    Caption = 'Activos';
                    Editable = false;
                    ToolTip = 'Muestra el número de activos incluidos.';
                }
                field(TotalContracts; TotalContracts)
                {
                    Caption = 'Contratos vigentes';
                    Editable = false;
                    ToolTip = 'Muestra el número de contratos incluidos.';
                }
                field(TotalMonthlyRent; TotalMonthlyRent)
                {
                    Caption = 'Renta mensual total';
                    Editable = false;
                    ToolTip = 'Muestra la renta mensual agregada.';
                }
                field(TotalAnnualRent; TotalAnnualRent)
                {
                    Caption = 'Renta anual total';
                    Editable = false;
                    ToolTip = 'Muestra la renta anual agregada.';
                }
                field(TotalMarketValue; TotalMarketValue)
                {
                    Caption = 'Valor mercado total';
                    Editable = false;
                    ToolTip = 'Muestra el valor total de mercado utilizado.';
                }
                field(WeightedGrossYield; WeightedGrossYield)
                {
                    Caption = 'Yield bruto ponderado %';
                    Editable = false;
                    ToolTip = 'Muestra el yield bruto ponderado del análisis, calculado como la renta anual total de los contratos incluidos dividida entre el valor total de los activos incluidos, multiplicado por 100.';
                }
                field(WeightedNetYield; WeightedNetYield)
                {
                    Caption = 'Yield neto ponderado %';
                    Editable = false;
                    ToolTip = 'Muestra el yield neto global ponderado.';
                }
            }
            repeater(Lines)
            {
                field("Company Name"; Rec."Company Name")
                {
                    Caption = 'Empresa';
                    ToolTip = 'Indica la empresa a la que pertenece el contrato analizado.';
                }
                field("Contract No."; Rec."Contract No.")
                {
                    Caption = 'Nº contrato';
                    StyleExpr = YieldBelowTargetStyle;
                    ToolTip = 'Indica el número del contrato.';
                }
                field("Contract Status"; Rec."Contract Status")
                {
                    Caption = 'Estado';
                    ToolTip = 'Muestra el estado del contrato.';
                }
                field("Contract Start Date"; Rec."Contract Start Date")
                {
                    Caption = 'Fecha inicio';
                    ToolTip = 'Muestra la fecha de inicio del contrato.';
                }
                field("Contract End Date"; Rec."Contract End Date")
                {
                    Caption = 'Fecha vencimiento';
                    ToolTip = 'Muestra la fecha fin o vencimiento del contrato.';
                }
                field("Customer Name"; Rec."Customer Name")
                {
                    Caption = 'Cliente';
                    ToolTip = 'Muestra el nombre del arrendatario.';
                }
                field("Monthly Rent"; Rec."Monthly Rent")
                {
                    Caption = 'Renta mensual';
                    ToolTip = 'Muestra la renta mensual normalizada.';
                }
                field("Annual Rent"; Rec."Annual Rent")
                {
                    Caption = 'Renta anual';
                    ToolTip = 'Muestra la renta anual equivalente.';
                }
                field("Market Value"; Rec."Market Value")
                {
                    Caption = 'Valor activo';
                    ToolTip = 'Muestra el valor utilizado para los cálculos.';
                }
                field("Forecast Income 12M"; Rec."Forecast Income 12M")
                {
                    Caption = 'Previsión 12M';
                    ToolTip = 'Muestra la previsión de ingresos a 12 meses.';
                }
                field("Gross Yield Percentage"; Rec."Gross Yield Percentage")
                {
                    Caption = 'Yield bruto %';
                    StyleExpr = YieldBelowTargetStyle;
                    ToolTip = 'Muestra el yield bruto calculado.';
                }
                field("Net Yield Percentage"; Rec."Net Yield Percentage")
                {
                    Caption = 'Yield neto %';
                    StyleExpr = YieldBelowTargetStyle;
                    ToolTip = 'Muestra el yield neto calculado.';
                }
                field("Cash Flow Amount"; Rec."Cash Flow Amount")
                {
                    Caption = 'Cash flow';
                    ToolTip = 'Muestra el cash flow operativo calculado.';
                }
                field("Risk Level"; Rec."Risk Level")
                {
                    Caption = 'Riesgo';
                    StyleExpr = YieldBelowTargetStyle;
                    ToolTip = 'Muestra el nivel de riesgo evaluado.';
                }
                field("Property No."; Rec."Property No.")
                {
                    Caption = 'Nº activo';
                    ToolTip = 'Indica el activo inmobiliario relacionado.';
                }
                field("Property Description"; Rec."Property Description")
                {
                    Caption = 'Descripción activo';
                    ToolTip = 'Muestra la descripción del activo.';
                }
                field("Contract Description"; Rec."Contract Description")
                {
                    Caption = 'Descripción contrato';
                    ToolTip = 'Muestra la descripción del contrato.';
                }
                field("Customer No."; Rec."Customer No.")
                {
                    Caption = 'Nº cliente';
                    ToolTip = 'Indica el cliente o arrendatario.';
                }
                field(CollectedAmount; Rec.CollectedAmount)
                {
                    Caption = 'Importe cobrado';
                    ToolTip = 'Permite informar manualmente el importe cobrado del contrato.';
                }
                field(CollectionDifference; Rec.CollectionDifference)
                {
                    Caption = 'Diferencia cobros';
                    Editable = false;
                    ToolTip = 'Muestra la diferencia entre la renta mensual y el importe cobrado.';
                }
                field("Risk Description"; Rec."Risk Description")
                {
                    Caption = 'Motivo riesgo';
                    ToolTip = 'Explica los motivos de riesgo detectados.';
                }
                field("Has Error"; Rec."Has Error")
                {
                    ToolTip = 'Indica si la línea se generó con error.';
                }
                field("Error Message"; Rec."Error Message")
                {
                    ToolTip = 'Muestra el mensaje de error si existe.';
                }
            }
        }
    }

    actions
    {
        area(Processing)
        {
            action(RunAnalysis)
            {
                Caption = 'Analizar Financial Flow';
                ApplicationArea = All;
                Image = Calculate;
                Promoted = true;
                PromotedCategory = Process;
                PromotedOnly = true;
                ToolTip = 'Ejecuta el análisis consolidado de contratos de alquiler.';

                trigger OnAction()
                var
                    FFManagement: Codeunit "OD FF Management";
                begin
                    FFManagement.RunAnalysis();
                    RefreshPageView();
                end;
            }
            action(RefreshAnalysis)
            {
                Caption = 'Actualizar análisis';
                ApplicationArea = All;
                Image = Refresh;
                Promoted = true;
                PromotedCategory = Process;
                PromotedOnly = true;
                ToolTip = 'Repite el análisis con la misma configuración.';

                trigger OnAction()
                var
                    FFManagement: Codeunit "OD FF Management";
                begin
                    FFManagement.RunAnalysis();
                    RefreshPageView();
                end;
            }
            action(SaveSnapshot)
            {
                Caption = 'Guardar snapshot';
                ApplicationArea = All;
                Image = Archive;
                ToolTip = 'Guarda una fotografía exacta del análisis actual.';

                trigger OnAction()
                var
                    SnapshotMgt: Codeunit "OD FF Snapshot Mgt";
                    SnapshotNo: Code[20];
                    Description: Text[100];
                begin
                    Description := CopyStr(StrSubstNo('Financial Flow Map %1', Format(Today, 0, '<Day,2>/<Month,2>/<Year4>')), 1, MaxStrLen(Description));
                    SnapshotMgt.CreateSnapshotForCurrentUser(Description, SnapshotNo);
                    Message('Snapshot creado: %1', SnapshotNo);
                end;
            }
            action(OpenContract)
            {
                Caption = 'Resumen contrato';
                ApplicationArea = All;
                Image = EditLines;
                ToolTip = 'Muestra un resumen del contrato sin salir del análisis.';

                trigger OnAction()
                var
                    FFManagement: Codeunit "OD FF Management";
                begin
                    FFManagement.ShowContractSummary(Rec);
                end;
            }
            action(OpenProperty)
            {
                Caption = 'Abrir activo';
                ApplicationArea = All;
                Image = FixedAssets;
                ToolTip = 'Abre la lista de activos en la empresa correspondiente.';

                trigger OnAction()
                var
                    FFManagement: Codeunit "OD FF Management";
                begin
                    FFManagement.OpenPropertyInCompany(Rec);
                end;
            }
            action(CreateCollectionDifferenceIncident)
            {
                Caption = 'Crear incidencia cobro';
                ApplicationArea = All;
                Image = CreateDocument;
                Promoted = true;
                PromotedCategory = Process;
                PromotedOnly = true;
                ToolTip = 'Crea una nueva incidencia vinculada al activo y contrato de la línea cuando existe una diferencia de cobro pendiente.';

                trigger OnAction()
                begin
                    RunCreateCollectionDifferenceIncident();
                end;
            }
            action(ViewHistory)
            {
                Caption = 'Ver histórico';
                ApplicationArea = All;
                Image = History;
                Promoted = true;
                PromotedCategory = Process;
                PromotedOnly = true;
                ToolTip = 'Muestra el histórico de snapshots.';

                trigger OnAction()
                begin
                    Page.Run(Page::"OD FF Snapshot List");
                end;
            }
            action(CompareSnapshots)
            {
                Caption = 'Comparar snapshots';
                ApplicationArea = All;
                Image = Calculate;
                Promoted = true;
                PromotedCategory = Process;
                PromotedOnly = true;
                ToolTip = 'Compara automáticamente los dos últimos snapshots generados.';

                trigger OnAction()
                var
                    SnapshotMgt: Codeunit "OD FF Snapshot Mgt";
                begin
                    SnapshotMgt.CompareLastTwoSnapshotsForCurrentUser();
                    Page.Run(Page::"OD FF Compare");
                end;
            }
            action(ExportToExcel)
            {
                Caption = 'Exportar a Excel';
                ApplicationArea = All;
                Image = ExportToExcel;
                Promoted = true;
                PromotedCategory = Report;
                PromotedOnly = true;
                ToolTip = 'Exporta las líneas visibles y los totales principales a Excel.';

                trigger OnAction()
                var
                    ExcelExport: Codeunit "OD FF Excel Export";
                begin
                    ExcelExport.ExportCurrentUserAnalysis();
                end;
            }
            action(ShowOnlyRisks)
            {
                Caption = 'Mostrar solo riesgos';
                ApplicationArea = All;
                Image = Warning;
                ToolTip = 'Filtra contratos con riesgo alto o crítico.';

                trigger OnAction()
                begin
                    ApplyUserFilter();
                    Rec.SetFilter("Risk Level", '%1|%2', Rec."Risk Level"::High, Rec."Risk Level"::Critical);
                    EnsureCurrentRecordInView();
                    CurrPage.Update(false);
                end;
            }
            action(ShowUpcoming)
            {
                Caption = 'Mostrar próximos vencimientos';
                ApplicationArea = All;
                Image = Calendar;
                ToolTip = 'Filtra contratos próximos a vencer según la configuración.';

                trigger OnAction()
                var
                    FFManagement: Codeunit "OD FF Management";
                begin
                    ApplyUserFilter();
                    FFManagement.ApplyUpcomingContractsFilter(Rec);
                    EnsureCurrentRecordInView();
                    CurrPage.Update(false);
                end;
            }
        }
    }

    trigger OnOpenPage()
    begin
        RefreshPageView();
    end;

    trigger OnAfterGetRecord()
    begin
        UpdateYieldStyle();
    end;

    var
        TotalCompanies: Integer;
        TotalProperties: Integer;
        TotalContracts: Integer;
        TotalMonthlyRent: Decimal;
        TotalAnnualRent: Decimal;
        TotalMarketValue: Decimal;
        WeightedGrossYield: Decimal;
        WeightedNetYield: Decimal;
        RegistrationDate: Date;
        CoveredPeriod: DateFormula;
        YieldBelowTargetStyle: Text;
        NoCollectionDifferenceErr: Label 'Solo se puede crear una incidencia cuando existe una diferencia de cobro pendiente.';
        CollectionDifferenceDescriptionLbl: Label 'Diferencia de cobro del contrato %1';
        CollectionDifferenceObservationsLbl: Label 'Incidencia creada desde Financial Flow. Diferencia de cobro: %1. Renta mensual: %2. Importe cobrado: %3. Empresa origen: %4.';

    local procedure ApplyUserFilter()
    begin
        Rec.Reset();
        Rec.SetRange("User ID", CopyStr(UserId(), 1, 50));
    end;

    local procedure EnsureCurrentRecordInView()
    begin
        if not Rec.FindFirst() then;
    end;

    local procedure UpdateTotals()
    var
        FFManagement: Codeunit "OD FF Management";
        Buffer: Record "OD FF Buffer";
    begin
        FFManagement.CalculatePageTotals(
            CopyStr(UserId(), 1, 50),
            TotalCompanies,
            TotalProperties,
            TotalContracts,
            TotalMonthlyRent,
            TotalAnnualRent,
            TotalMarketValue,
            WeightedGrossYield,
            WeightedNetYield);

        Clear(RegistrationDate);
        Buffer.SetRange("User ID", CopyStr(UserId(), 1, 50));
        if Buffer.FindFirst() then
            RegistrationDate := Buffer."Analysis Date";
    end;

    local procedure RefreshPageView()
    begin
        ApplyUserFilter();
        EnsureCurrentRecordInView();
        UpdateTotals();
        CurrPage.Update(false);
    end;

    local procedure UpdateYieldStyle()
    var
        Setup: Record "OD FF Setup";
    begin
        Clear(YieldBelowTargetStyle);

        Setup.EnsureSetup();
        Setup.Get('SETUP');
        if Rec."Gross Yield Percentage" < Setup."Minimum Target Yield" then
            YieldBelowTargetStyle := 'Unfavorable';
    end;

    local procedure RunCreateCollectionDifferenceIncident()
    var
        REIncident: Record "Incident Assets Real Estate";
        LeaseContract: Record "Lease Contract";
    begin
        if Rec.CollectionDifference <= 0 then
            Error(NoCollectionDifferenceErr);

        REIncident.Init();
        REIncident.Validate("Fixed Real Estate No.", Rec."Property No.");
        LeaseContract.ChangeCompany(Rec."Company Name");
        LeaseContract.SetRange("Contract No.", Rec."Contract No.");
        if LeaseContract.FindFirst() then
            FillIncidentContractContext(REIncident, LeaseContract);
        REIncident."Contract No." := Rec."Contract No.";
        SetIncidentTextField(REIncident, 'Description', StrSubstNo(CollectionDifferenceDescriptionLbl, Rec."Contract No."));
        SetIncidentTextField(
          REIncident,
          'Observations',
          StrSubstNo(
            CollectionDifferenceObservationsLbl,
            Format(Rec.CollectionDifference),
            Format(Rec."Monthly Rent"),
            Format(Rec.CollectedAmount),
            Rec."Company Name"));

        Page.RunModal(Page::"RE Incident Card", REIncident);
    end;

    local procedure FillIncidentContractContext(var REIncident: Record "Incident Assets Real Estate"; LeaseContract: Record "Lease Contract")
    begin
        REIncident."Customer No." := LeaseContract."Customer No.";
        REIncident."Contact No" := LeaseContract."Contact No.";
        REIncident."Contract - Contact Name" := CopyStr(LeaseContract."Contact Name", 1, MaxStrLen(REIncident."Contract - Contact Name"));
        REIncident."Contact Phone No." := CopyStr(LeaseContract."Phone No.", 1, MaxStrLen(REIncident."Contact Phone No."));
        REIncident."Contact E-Mail" := CopyStr(LeaseContract."E-Mail", 1, MaxStrLen(REIncident."Contact E-Mail"));
        REIncident."Contract - Phone No." := CopyStr(LeaseContract."Phone No. 2", 1, MaxStrLen(REIncident."Contract - Phone No."));
        REIncident."Contract - EMail" := CopyStr(LeaseContract."E-Mail 2", 1, MaxStrLen(REIncident."Contract - EMail"));
    end;

    local procedure SetIncidentTextField(var REIncident: Record "Incident Assets Real Estate"; FieldName: Text; FieldValue: Text)
    var
        IncidentRecRef: RecordRef;
        IncidentFieldRef: FieldRef;
    begin
        if FieldValue = '' then
            exit;

        IncidentRecRef.GetTable(REIncident);
        if not GetFieldRefByName(IncidentRecRef, FieldName, IncidentFieldRef) then
            exit;

        IncidentFieldRef.Value := FieldValue;
        IncidentRecRef.SetTable(REIncident);
    end;

    local procedure GetFieldRefByName(RecRef: RecordRef; FieldName: Text; var FieldRef: FieldRef): Boolean
    var
        i: Integer;
        CurrentFieldRef: FieldRef;
    begin
        if FieldName = '' then
            exit(false);

        for i := 1 to RecRef.FieldCount do begin
            CurrentFieldRef := RecRef.FieldIndex(i);
            if UpperCase(CurrentFieldRef.Name) = UpperCase(FieldName) then begin
                FieldRef := CurrentFieldRef;
                exit(true);
            end;
        end;

        exit(false);
    end;
}
