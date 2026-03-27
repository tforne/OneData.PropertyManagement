page 96019 "RE Cash Flow Chart"
{
    PageType = CardPart;
    SourceTable = "Business Chart Buffer";
    Caption = 'Flujo de Caja';
    ApplicationArea = All;

    layout
    {
        area(content)
        {
            usercontrol(BusinessChart; BusinessChart)
            {
                ApplicationArea = All;

                trigger AddInReady()
                begin
                    UpdateChart();
                end;
            }
        }
    }

    var
        BusinessChart: Codeunit "Business Chart";
        MonthNo: Integer;
        MonthLabel: Text;
        MonthAmountIncoming: Decimal;
        MonthAmountExpenses: Decimal;
        CurrentMonthStart: Date;
        CurrentMonthEnd: Date;

    local procedure UpdateChart()
    var
        XAxisIndex: Integer;
    begin
        BusinessChart.Initialize();
        BusinessChart.SetXDimension('Mes', Enum::System.Visualization."Business Chart Data Type"::String);
        BusinessChart.AddMeasure('Ventas', 0, Enum::"Business Chart Data Type"::Decimal, Enum::"Business Chart Type"::Column);
        BusinessChart.AddMeasure('Gastos', 0, Enum::"Business Chart Data Type"::Decimal, Enum::"Business Chart Type"::Column);

        XAxisIndex := 0;
        for MonthNo := 11 downto 0 do begin
            CurrentMonthStart := CalcDate('<-CM>', CalcDate(StrSubstNo('-%1M', MonthNo), Today));
            CurrentMonthEnd := CalcDate('<CM>', CurrentMonthStart);
            MonthLabel := Format(CurrentMonthStart, 0, '<Month Text,3> <Year4>');
            MonthAmountIncoming := GetSalesAmount(CurrentMonthStart, CurrentMonthEnd);
            MonthAmountExpenses := GetExpensesAmount(CurrentMonthStart, CurrentMonthEnd);

            BusinessChart.AddDataRowWithXDimension(MonthLabel);
            BusinessChart.SetValue(0, XAxisIndex, MonthAmountIncoming);
            BusinessChart.SetValue(1, XAxisIndex, MonthAmountExpenses);
            XAxisIndex += 1;
        end;

        BusinessChart.Update(CurrPage.BusinessChart);
    end;

    local procedure GetSalesAmount(DateFrom: Date; DateTo: Date): Decimal
    var
        FRELedgerEntry: Record "FRE Ledger Entry";
        TotalSales: Decimal;
    begin
        TotalSales := 0;
        FRELedgerEntry.SetRange("Line Type", FRELedgerEntry."Line Type"::Invoice);
        FRELedgerEntry.SetRange("Document Type", FRELedgerEntry."Document Type"::Invoice);
        FRELedgerEntry.SetRange("Posting Date", DateFrom, DateTo);
        if FRELedgerEntry.FindSet() then
            repeat
                TotalSales += FRELedgerEntry.Amount;
            until FRELedgerEntry.Next() = 0;
        exit(TotalSales);
    end;

    local procedure GetExpensesAmount(DateFrom: Date; DateTo: Date): Decimal
    var
        FRELedgerEntry: Record "FRE Ledger Entry";
        TotalExpenses: Decimal;
    begin
        TotalExpenses := 0;
        FRELedgerEntry.SetRange("Posting Date", DateFrom, DateTo);
        if FRELedgerEntry.FindSet() then
            repeat
                if FRELedgerEntry.Amount < 0 then
                    TotalExpenses += FRELedgerEntry.Amount;
            until FRELedgerEntry.Next() = 0;
        exit(TotalExpenses);
    end;
}