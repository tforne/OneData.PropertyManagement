codeunit 96981 "OD FF Analyzer"
{
    procedure NormalizeMonthlyRent(Amount: Decimal; BillingFrequency: Text): Decimal
    var
        FrequencyTxt: Text;
    begin
        FrequencyTxt := UpperCase(BillingFrequency);

        if (FrequencyTxt = '') or (StrPos(FrequencyTxt, 'MES') > 0) or (StrPos(FrequencyTxt, 'MONTH') > 0) then
            exit(Amount);
        if (StrPos(FrequencyTxt, 'BIM') > 0) then
            exit(Amount / 2);
        if (StrPos(FrequencyTxt, 'TRIM') > 0) or (StrPos(FrequencyTxt, 'QUART') > 0) then
            exit(Amount / 3);
        if (StrPos(FrequencyTxt, 'SEM') > 0) then
            exit(Amount / 6);
        if (StrPos(FrequencyTxt, 'AN') > 0) or (StrPos(FrequencyTxt, 'YEAR') > 0) then
            exit(Amount / 12);
        if (StrPos(FrequencyTxt, 'DIA') > 0) or (StrPos(FrequencyTxt, 'DAY') > 0) then
            exit(Amount * 30);

        exit(Amount);
    end;

    procedure CalculateRemainingMonths(StartDate: Date; EndDate: Date; WorkDate: Date): Decimal
    var
        EffectiveStartDate: Date;
    begin
        if EndDate = 0D then
            exit(0);

        EffectiveStartDate := WorkDate;
        if (StartDate <> 0D) and (StartDate > EffectiveStartDate) then
            EffectiveStartDate := StartDate;

        if EndDate < EffectiveStartDate then
            exit(0);

        exit(CalculateMonthsBetween(EffectiveStartDate, EndDate));
    end;

    procedure CalculateRemainingIncome(MonthlyRent: Decimal; RemainingMonths: Decimal): Decimal
    begin
        exit(MonthlyRent * RemainingMonths);
    end;

    procedure CalculateForecastIncome(MonthlyRent: Decimal; Months: Integer; StartDate: Date; EndDate: Date; WorkDate: Date): Decimal
    var
        EffectiveStartDate: Date;
        EffectiveEndDate: Date;
        EffectiveMonths: Decimal;
    begin
        if Months <= 0 then
            exit(0);

        EffectiveStartDate := WorkDate;
        if (StartDate <> 0D) and (StartDate > EffectiveStartDate) then
            EffectiveStartDate := StartDate;

        EffectiveEndDate := CalcDate('<+' + Format(Months - 1) + 'M>', WorkDate);
        if (EndDate <> 0D) and (EndDate < EffectiveEndDate) then
            EffectiveEndDate := EndDate;

        if EffectiveEndDate < EffectiveStartDate then
            exit(0);

        EffectiveMonths := CalculateMonthsBetween(EffectiveStartDate, EffectiveEndDate);

        exit(MonthlyRent * EffectiveMonths);
    end;

    procedure CalculateGrossYield(AnnualRent: Decimal; PropertyValue: Decimal): Decimal
    begin
        if PropertyValue = 0 then
            exit(0);
        exit((AnnualRent / PropertyValue) * 100);
    end;

    procedure CalculateNetYield(AnnualNetIncome: Decimal; PropertyValue: Decimal): Decimal
    begin
        if PropertyValue = 0 then
            exit(0);
        exit((AnnualNetIncome / PropertyValue) * 100);
    end;

    procedure CalculateROI(AnnualNetIncome: Decimal; PurchasePrice: Decimal): Decimal
    begin
        if PurchasePrice = 0 then
            exit(0);
        exit((AnnualNetIncome / PurchasePrice) * 100);
    end;

    procedure CalculateCapRate(AnnualNetIncome: Decimal; PropertyValue: Decimal): Decimal
    begin
        if PropertyValue = 0 then
            exit(0);
        exit((AnnualNetIncome / PropertyValue) * 100);
    end;

    procedure CalculateEstimatedCapitalGain(PurchasePrice: Decimal; EstimatedSellingPrice: Decimal; SellingCostPct: Decimal): Decimal
    var
        SellingCosts: Decimal;
    begin
        SellingCosts := EstimatedSellingPrice * SellingCostPct / 100;
        exit(EstimatedSellingPrice - PurchasePrice - SellingCosts);
    end;

    procedure CalculateCashFlow(AnnualRent: Decimal; AnnualOperatingCosts: Decimal): Decimal
    begin
        exit(AnnualRent - AnnualOperatingCosts);
    end;

    procedure CalculateOperatingCosts(AnnualRent: Decimal; MarketValue: Decimal; Setup: Record "OD FF Setup"): Decimal
    var
        MaintenanceCost: Decimal;
        VacancyCost: Decimal;
        ManagementCost: Decimal;
    begin
        MaintenanceCost := MarketValue * Setup."Default Annual Maint. %" / 100;
        VacancyCost := AnnualRent * Setup."Default Vacancy Percentage" / 100;
        ManagementCost := AnnualRent * Setup."Default Management Cost %" / 100;
        exit(MaintenanceCost + VacancyCost + ManagementCost);
    end;

    procedure CalculateRiskLevel(var Buffer: Record "OD FF Buffer"; Setup: Record "OD FF Setup")
    var
        RiskScore: Integer;
        DescriptionTxt: Text;
    begin
        RiskScore := 0;

        if (Buffer."Contract End Date" <> 0D) and (Buffer."Contract End Date" <= CalcDate('<+' + Format(Setup."Warning Days Before End") + 'D>', Today)) then begin
            RiskScore += 2;
            AppendReason(DescriptionTxt, 'Contrato próximo a vencer');
        end;

        if Buffer."Contract End Date" = 0D then begin
            RiskScore += 1;
            AppendReason(DescriptionTxt, 'Contrato sin fecha final');
        end;

        if Buffer."Outstanding Amount" > Buffer."Monthly Rent" * 2 then begin
            RiskScore += 2;
            AppendReason(DescriptionTxt, 'Importe pendiente elevado');
        end;

        if Buffer."Customer Concentration %" > Setup."Max. Customer Concentration %" then begin
            RiskScore += 2;
            AppendReason(DescriptionTxt, 'Concentración de cliente elevada');
        end;

        if Buffer."Market Value" = 0 then begin
            RiskScore += 1;
            AppendReason(DescriptionTxt, 'Activo sin valor de mercado');
        end;

        if Buffer."Cadastral Reference" = '' then begin
            RiskScore += 1;
            AppendReason(DescriptionTxt, 'Activo sin referencia catastral');
        end;

        if Buffer."Gross Yield Percentage" < Setup."Minimum Target Yield" then begin
            RiskScore += 2;
            AppendReason(DescriptionTxt, 'Rentabilidad inferior al objetivo');
        end;

        if (Buffer."Deposit Amount" = 0) and (Buffer."Guarantee Amount" = 0) then begin
            RiskScore += 1;
            AppendReason(DescriptionTxt, 'Sin fianza ni garantía');
        end;

        if (Buffer."Customer No." = '') or (Buffer."Contract No." = '') then begin
            RiskScore += 3;
            AppendReason(DescriptionTxt, 'Datos contractuales incompletos');
        end;

        case true of
            RiskScore >= 7:
                Buffer."Risk Level" := Buffer."Risk Level"::Critical;
            RiskScore >= 5:
                Buffer."Risk Level" := Buffer."Risk Level"::High;
            RiskScore >= 3:
                Buffer."Risk Level" := Buffer."Risk Level"::Medium;
            else
                Buffer."Risk Level" := Buffer."Risk Level"::Low;
        end;

        Buffer."Risk Description" := CopyStr(DescriptionTxt, 1, MaxStrLen(Buffer."Risk Description"));
    end;

    local procedure AppendReason(var DescriptionTxt: Text; Reason: Text)
    begin
        if DescriptionTxt = '' then
            DescriptionTxt := Reason
        else
            DescriptionTxt := DescriptionTxt + '; ' + Reason;
    end;

    local procedure CalculateMonthsBetween(StartDate: Date; EndDate: Date): Decimal
    begin
        exit(((Date2DMY(EndDate, 3) - Date2DMY(StartDate, 3)) * 12) + Date2DMY(EndDate, 2) - Date2DMY(StartDate, 2) + 1);
    end;
}
