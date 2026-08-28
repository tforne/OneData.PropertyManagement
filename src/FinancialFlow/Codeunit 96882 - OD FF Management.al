codeunit 96982 "OD FF Management"
{
    procedure RunAnalysis()
    var
        Setup: Record "OD FF Setup";
        Company: Record Company;
        ContractsProcessed: Integer;
        CompaniesProcessed: Integer;
        CompaniesWithError: Integer;
        TelemetryDimensions: Dictionary of [Text, Text];
    begin
        Setup.EnsureSetup();
        Setup.Get('SETUP');

        ClearUserBuffer();
        Session.LogMessage('ODFF001', 'Inicio análisis Financial Flow Map', Verbosity::Normal, DataClassification::SystemMetadata, TelemetryScope::ExtensionPublisher, TelemetryDimensions);

        if Company.FindSet() then
            repeat
                if not FFAdapter.IsCompanyIncluded(Company.Name, Setup) then
                    continue;

                if AnalyzeCompany(Company.Name, Setup, ContractsProcessed) then
                    CompaniesProcessed += 1
                else
                    CompaniesWithError += 1;
            until Company.Next() = 0;

        RecalculateCustomerConcentrationAndRisk(CopyStr(UserId(), 1, 50), Setup);

        Setup."Last Analysis DateTime" := CurrentDateTime();
        Setup.Modify();

        Session.LogMessage(
            'ODFF002',
            StrSubstNo('Fin análisis Financial Flow Map. Empresas %1. Contratos %2. Empresas error %3.', CompaniesProcessed, ContractsProcessed, CompaniesWithError),
            Verbosity::Normal,
            DataClassification::SystemMetadata,
            TelemetryScope::ExtensionPublisher,
            TelemetryDimensions);
    end;

    procedure CalculatePageTotals(UserIdFilter: Code[50]; var TotalCompanies: Integer; var TotalProperties: Integer; var TotalContracts: Integer; var TotalMonthlyRent: Decimal; var TotalAnnualRent: Decimal; var TotalMarketValue: Decimal; var WeightedGrossYield: Decimal; var WeightedNetYield: Decimal)
    var
        Buffer: Record "OD FF Buffer";
        LastCompany: Text[30];
        LastPropertyKey: Text[100];
        GrossIncomeTotal: Decimal;
        NetIncomeTotal: Decimal;
        PropertyValue: Decimal;
    begin
        Clear(TotalCompanies);
        Clear(TotalProperties);
        Clear(TotalContracts);
        Clear(TotalMonthlyRent);
        Clear(TotalAnnualRent);
        Clear(TotalMarketValue);
        Clear(WeightedGrossYield);
        Clear(WeightedNetYield);

        Buffer.SetRange("User ID", UserIdFilter);
        Buffer.SetCurrentKey("User ID", "Company Name", "Property No.", "Contract No.");
        if not Buffer.FindSet() then
            exit;

        repeat
            if Buffer."Company Name" <> LastCompany then begin
                TotalCompanies += 1;
                LastCompany := Buffer."Company Name";
            end;

            if Format(Buffer."Company Name") + '|' + Format(Buffer."Property No.") <> LastPropertyKey then begin
                TotalProperties += 1;
                LastPropertyKey := CopyStr(Buffer."Company Name" + '|' + Buffer."Property No.", 1, MaxStrLen(LastPropertyKey));
                PropertyValue := FFAdapter.GetPropertyValue(Buffer, GetSetup());
                TotalMarketValue += PropertyValue;
            end;

            TotalContracts += 1;
            TotalMonthlyRent += Buffer."Monthly Rent";
            TotalAnnualRent += Buffer."Annual Rent";
            GrossIncomeTotal += Buffer."Annual Rent";
            NetIncomeTotal += Buffer."Annual Net Income";
        until Buffer.Next() = 0;

        if TotalMarketValue <> 0 then begin
            WeightedGrossYield := (GrossIncomeTotal / TotalMarketValue) * 100;
            WeightedNetYield := (NetIncomeTotal / TotalMarketValue) * 100;
        end;
    end;

    procedure ShowContractSummary(Buffer: Record "OD FF Buffer")
    var
        LeaseContract: Record "Lease Contract";
        ContractSummary: Record "OD FF Contract Summary" temporary;
    begin
        LeaseContract.ChangeCompany(Buffer."Company Name");
        LeaseContract.SetRange("Contract No.", Buffer."Contract No.");
        if not LeaseContract.FindFirst() then
            Error('No se ha encontrado el contrato %1 en la empresa %2.', Buffer."Contract No.", Buffer."Company Name");

        FillContractSummary(ContractSummary, Buffer."Company Name", LeaseContract);
        Page.RunModal(Page::"OD FF Contract Summary", ContractSummary);
    end;

    procedure OpenPropertyInCompany(Buffer: Record "OD FF Buffer")
    var
        Url: Text;
    begin
        Url := GetUrl(ClientType::Web, Buffer."Company Name", ObjectType::Page, Page::"Simple Fixed Real Estate List");
        Hyperlink(Url);
        Message('Se ha abierto la lista de activos de la empresa %1. Activo objetivo: %2.', Buffer."Company Name", Buffer."Property No.");
    end;

    procedure CreateCollectionDifferenceIncident(Buffer: Record "OD FF Buffer")
    var
        REIncident: Record "Incident Assets Real Estate";
        LeaseContract: Record "Lease Contract";
    begin
        if Buffer.CollectionDifference <= 0 then
            Error(NoCollectionDifferenceErr);

        REIncident.Init();
        REIncident.Validate("Fixed Real Estate No.", Buffer."Property No.");
        LeaseContract.ChangeCompany(Buffer."Company Name");
        LeaseContract.SetRange("Contract No.", Buffer."Contract No.");
        if LeaseContract.FindFirst() then
            FillIncidentContractContext(REIncident, LeaseContract);
        REIncident.Validate("Contract No.", Buffer."Contract No.");
        SetIncidentTextField(REIncident, 'Description', StrSubstNo(CollectionDifferenceDescriptionLbl, Buffer."Contract No."));
        SetIncidentTextField(
          REIncident,
          'Observations',
          StrSubstNo(
            CollectionDifferenceObservationsLbl,
            Format(Buffer.CollectionDifference),
            Format(Buffer."Monthly Rent"),
            Format(Buffer.CollectedAmount),
            Buffer."Company Name"));

        Page.RunModal(Page::"RE Incident Card", REIncident);
    end;

    procedure ApplyUpcomingContractsFilter(var Buffer: Record "OD FF Buffer")
    var
        Setup: Record "OD FF Setup";
        FutureDate: Date;
    begin
        Setup.EnsureSetup();
        Setup.Get('SETUP');
        FutureDate := CalcDate('<+' + Format(Setup."Warning Days Before End") + 'D>', Today);
        Buffer.SetRange("Contract End Date", Today, FutureDate);
    end;

    procedure ExportAnalysisToExcel()
    var
        ExcelExport: Codeunit "OD FF Excel Export";
    begin
        ExcelExport.ExportCurrentUserAnalysis();
    end;

    procedure ClearUserBuffer()
    var
        Buffer: Record "OD FF Buffer";
    begin
        Buffer.SetRange("User ID", CopyStr(UserId(), 1, 50));
        if not Buffer.IsEmpty() then
            Buffer.DeleteAll();
    end;

    local procedure FillContractSummary(var ContractSummary: Record "OD FF Contract Summary" temporary; CompanyName: Text[30]; var LeaseContract: Record "Lease Contract")
    begin
        LeaseContract.CalcFields(Name, "Description Fixed Real Estate");

        ContractSummary.Reset();
        ContractSummary.DeleteAll();
        ContractSummary.Init();
        ContractSummary."Entry No." := 1;
        ContractSummary."Company Name" := CompanyName;
        ContractSummary."Contract No." := LeaseContract."Contract No.";
        ContractSummary.Description := CopyStr(LeaseContract.Description, 1, MaxStrLen(ContractSummary.Description));
        ContractSummary."Customer No." := LeaseContract."Customer No.";
        ContractSummary."Customer Name" := CopyStr(LeaseContract.Name, 1, MaxStrLen(ContractSummary."Customer Name"));
        ContractSummary.Status := CopyStr(Format(LeaseContract.Status), 1, MaxStrLen(ContractSummary.Status));
        ContractSummary."Starting Date" := LeaseContract."Starting Date";
        ContractSummary."Expiration Date" := LeaseContract."Expiration Date";
        ContractSummary."Invoice Period" := CopyStr(Format(LeaseContract."Invoice Period"), 1, MaxStrLen(ContractSummary."Invoice Period"));
        ContractSummary."Amount per Period" := LeaseContract."Amount per Period";
        ContractSummary."Annual Amount" := LeaseContract."Annual Amount";
        ContractSummary."Property No." := LeaseContract."Fixed Real Estate No.";
        ContractSummary."Property Description" := CopyStr(LeaseContract."Description Fixed Real Estate", 1, MaxStrLen(ContractSummary."Property Description"));
        ContractSummary."Contact Name" := CopyStr(LeaseContract."Contact Name", 1, MaxStrLen(ContractSummary."Contact Name"));
        ContractSummary."Payment Method Code" := LeaseContract."Payment Method Code";
        ContractSummary."Payment Terms Code" := LeaseContract."Payment Terms Code";
        ContractSummary."Last Invoice Date" := LeaseContract."Last Invoice Date";
        ContractSummary."Next Invoice Date" := LeaseContract."Next Invoice Date";
        ContractSummary.Insert();
    end;

    local procedure AnalyzeCompany(CompanyName: Text[30]; Setup: Record "OD FF Setup"; var ContractsProcessed: Integer): Boolean
    var
        LeaseContract: Record "Lease Contract";
    begin
        LeaseContract.ChangeCompany(CompanyName);
        if not LeaseContract.FindSet() then
            exit(true);

        repeat
            if FFAdapter.IsContractIncluded(LeaseContract, Setup, Today) then begin
                AnalyzeContract(CompanyName, LeaseContract, Setup);
                ContractsProcessed += 1;
            end;
        until LeaseContract.Next() = 0;

        exit(true);
    end;

    local procedure AnalyzeContract(CompanyName: Text[30]; var LeaseContract: Record "Lease Contract"; Setup: Record "OD FF Setup")
    var
        Buffer: Record "OD FF Buffer";
        PropertyValue: Decimal;
        MonthlyRentBase: Decimal;
    begin
        Buffer.Init();
        Buffer."User ID" := CopyStr(UserId(), 1, 50);
        Buffer."Analysis Date" := Today;
        Buffer."Analysis Time" := DT2Time(CurrentDateTime());
        Buffer."Analysis DateTime" := CurrentDateTime();

        FFAdapter.FillBufferFromContract(CompanyName, LeaseContract, Buffer);
        FFAdapter.FillBufferFromProperty(CompanyName, Buffer."Property No.", Buffer);

        MonthlyRentBase := FFAdapter.GetContractMonthlyRent(CompanyName, LeaseContract);
        Buffer.Validate("Monthly Rent", MonthlyRentBase);
        Buffer."Annual Rent" := Buffer."Monthly Rent" * 12;
        Buffer."Remaining Months" := FFAnalyzer.CalculateRemainingMonths(Buffer."Contract Start Date", Buffer."Contract End Date", Today);
        Buffer."Remaining Contract Income" := FFAnalyzer.CalculateRemainingIncome(Buffer."Monthly Rent", Buffer."Remaining Months");
        Buffer."Forecast Income 12M" := FFAnalyzer.CalculateForecastIncome(Buffer."Monthly Rent", 12, Buffer."Contract Start Date", Buffer."Contract End Date", Today);
        Buffer."Forecast Income 24M" := FFAnalyzer.CalculateForecastIncome(Buffer."Monthly Rent", 24, Buffer."Contract Start Date", Buffer."Contract End Date", Today);
        Buffer."Forecast Income 60M" := FFAnalyzer.CalculateForecastIncome(Buffer."Monthly Rent", 60, Buffer."Contract Start Date", Buffer."Contract End Date", Today);

        PropertyValue := FFAdapter.GetPropertyValue(Buffer, Setup);
        Buffer."Annual Operating Costs" := FFAnalyzer.CalculateOperatingCosts(Buffer."Annual Rent", PropertyValue, Setup);
        Buffer."Annual Net Income" := Buffer."Annual Rent" - Buffer."Annual Operating Costs";
        Buffer."Gross Yield Percentage" := FFAnalyzer.CalculateGrossYield(Buffer."Annual Rent", PropertyValue);
        Buffer."Net Yield Percentage" := FFAnalyzer.CalculateNetYield(Buffer."Annual Net Income", PropertyValue);
        Buffer."ROI Percentage" := FFAnalyzer.CalculateROI(Buffer."Annual Net Income", Buffer."Purchase Price");
        Buffer."Cap Rate Percentage" := FFAnalyzer.CalculateCapRate(Buffer."Annual Net Income", PropertyValue);
        Buffer."Estimated Capital Gain" := FFAnalyzer.CalculateEstimatedCapitalGain(Buffer."Purchase Price", Buffer."Estimated Selling Price", Setup."Default Selling Cost %");
        Buffer."Cash Flow Amount" := FFAnalyzer.CalculateCashFlow(Buffer."Annual Rent", Buffer."Annual Operating Costs");

        FFAnalyzer.CalculateRiskLevel(Buffer, Setup);
        Buffer.Insert();
    end;

    local procedure RecalculateCustomerConcentrationAndRisk(UserIdFilter: Code[50]; Setup: Record "OD FF Setup")
    var
        Buffer: Record "OD FF Buffer";
        CustomerTotals: Dictionary of [Text, Decimal];
        TotalAnnualRent: Decimal;
        CustomerNoKey: Text;
        CustomerAnnualRent: Decimal;
    begin
        Buffer.SetRange("User ID", UserIdFilter);
        if Buffer.FindSet() then
            repeat
                TotalAnnualRent += Buffer."Annual Rent";
                CustomerNoKey := Format(Buffer."Customer No.");
                if CustomerTotals.ContainsKey(CustomerNoKey) then begin
                    CustomerTotals.Get(CustomerNoKey, CustomerAnnualRent);
                    CustomerTotals.Set(CustomerNoKey, CustomerAnnualRent + Buffer."Annual Rent");
                end else
                    CustomerTotals.Add(CustomerNoKey, Buffer."Annual Rent");
            until Buffer.Next() = 0;

        Buffer.SetRange("User ID", UserIdFilter);
        if Buffer.FindSet() then
            repeat
                CustomerNoKey := Format(Buffer."Customer No.");
                CustomerAnnualRent := 0;
                if CustomerTotals.ContainsKey(CustomerNoKey) then
                    CustomerTotals.Get(CustomerNoKey, CustomerAnnualRent);

                if TotalAnnualRent = 0 then
                    Buffer."Customer Concentration %" := 0
                else
                    Buffer."Customer Concentration %" := (CustomerAnnualRent / TotalAnnualRent) * 100;

                FFAnalyzer.CalculateRiskLevel(Buffer, Setup);
                Buffer.Modify();
            until Buffer.Next() = 0;
    end;

    local procedure GetSetup(): Record "OD FF Setup"
    var
        Setup: Record "OD FF Setup";
    begin
        Setup.EnsureSetup();
        Setup.Get('SETUP');
        exit(Setup);
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

        IncidentFieldRef.Value := CopyStr(FieldValue, 1, IncidentFieldRef.Length);
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

    var
        FFAdapter: Codeunit "OD FF Contract Adapter";
        FFAnalyzer: Codeunit "OD FF Analyzer";
        NoCollectionDifferenceErr: Label 'Solo se puede crear una incidencia cuando existe una diferencia de cobro pendiente.';
        CollectionDifferenceDescriptionLbl: Label 'Diferencia de cobro del contrato %1';
        CollectionDifferenceObservationsLbl: Label 'Incidencia creada desde Financial Flow. Diferencia de cobro: %1. Renta mensual: %2. Importe cobrado: %3. Empresa origen: %4.';
}
