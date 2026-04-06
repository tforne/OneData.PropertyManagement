page 96019 "RE Analisis Ingresos y Gastos"
{
    PageType = CardPart;
    SourceTable = "Business Chart Buffer";
    SourceTableTemporary = true;
    Caption = 'Análisis de Ingresos y Gastos';
    ApplicationArea = All;

    layout
    {
        area(content)
        {
            usercontrol(BusinessChart; BusinessChart)
            {

                trigger AddInReady()
                begin
                    BuildChart();
                end;

                trigger DataPointClicked(Point: JsonObject)
                begin
                    HandleDrillDown(Point);
                end;
            }
        }
    }

    var
        MonthNo: Integer;
        MonthStartDates: array[12] of Date;
        MonthEndDates: array[12] of Date;

    // =========================
    // BUILD CHART
    // =========================
    local procedure BuildChart()
    var
        XAxisIndex: Integer;
        MonthLabel: Text;
        SalesAmount: Decimal;
        ExpenseAmount: Decimal;
        CurrentMonthStart: Date;
        CurrentMonthEnd: Date;
    begin
        Rec.Initialize();

        Rec.SetXAxis('Mes', Rec."Data Type"::String);
        Rec.AddDecimalMeasure('Ventas', 0, Rec."Chart Type"::Column);
        Rec.AddDecimalMeasure('Gastos', 0, Rec."Chart Type"::Column);

        XAxisIndex := 0;

        for MonthNo := 11 downto 0 do begin
            CurrentMonthStart := CalcDate('<-CM>', CalcDate(StrSubstNo('-%1M', MonthNo), Today));
            CurrentMonthEnd := CalcDate('<CM>', CurrentMonthStart);

            MonthStartDates[XAxisIndex + 1] := CurrentMonthStart;
            MonthEndDates[XAxisIndex + 1] := CurrentMonthEnd;

            MonthLabel := Format(CurrentMonthStart, 0, '<Month Text,3> <Year4>');

            SalesAmount := GetSalesAmount(CurrentMonthStart, CurrentMonthEnd);
            ExpenseAmount := GetExpensesAmount(CurrentMonthStart, CurrentMonthEnd);

            Rec.AddColumn(MonthLabel);
            Rec.SetValueByIndex(0, XAxisIndex, SalesAmount);
            Rec.SetValueByIndex(1, XAxisIndex, ExpenseAmount);

            XAxisIndex += 1;
        end;

        Rec.UpdateChart(CurrPage.BusinessChart);
    end;

    // =========================
    // DRILL DOWN
    // =========================
    local procedure HandleDrillDown(Point: JsonObject)
    var
        FRELedgerEntry: Record "FRE Ledger Entry";
        FromDate: Date;
        ToDate: Date;
        XIndex: Integer;
        MeasureIndex: Integer;
        MeasureName: Text;
    begin
        // Captura índices del punto clicado
        Rec.SetDrillDownIndexes(Point);

        XIndex := Rec."Drill-Down X Index";
        MeasureIndex := Rec."Drill-Down Measure Index";

        FromDate := MonthStartDates[XIndex + 1];
        ToDate := MonthEndDates[XIndex + 1];

        MeasureName := Rec.GetMeasureName(MeasureIndex);

        FRELedgerEntry.Reset();
        FRELedgerEntry.SetRange("Posting Date", FromDate, ToDate);

        case MeasureName of
            'Ventas':
                begin
                    FRELedgerEntry.SetRange("Line Type", FRELedgerEntry."Line Type"::Invoice);
                    FRELedgerEntry.SetRange("Document Type", FRELedgerEntry."Document Type"::Invoice);
                end;

            'Gastos':
                begin
                    FRELedgerEntry.SetFilter(Amount, '<0');
                end;
        end;

        Page.Run(Page::"Movs. FRE", FRELedgerEntry);
    end;

    // =========================
    // DATA
    // =========================
    local procedure GetSalesAmount(DateFrom: Date; DateTo: Date): Decimal
    var
        FRELedgerEntry: Record "FRE Ledger Entry";
        Total: Decimal;
    begin
        FRELedgerEntry.SetRange("Line Type", FRELedgerEntry."Line Type"::Invoice);
        FRELedgerEntry.SetRange("Document Type", FRELedgerEntry."Document Type"::Invoice);
        FRELedgerEntry.SetRange("Posting Date", DateFrom, DateTo);

        if FRELedgerEntry.FindSet() then
            repeat
                Total += FRELedgerEntry.Amount;
            until FRELedgerEntry.Next() = 0;

        exit(Total);
    end;

    local procedure GetExpensesAmount(DateFrom: Date; DateTo: Date): Decimal
    var
        FRELedgerEntry: Record "FRE Ledger Entry";
        Total: Decimal;
    begin
        FRELedgerEntry.SetRange("Posting Date", DateFrom, DateTo);

        if FRELedgerEntry.FindSet() then
            repeat
                if FRELedgerEntry.Amount < 0 then
                    Total += Abs(FRELedgerEntry.Amount); // 👈 mejor visual
            until FRELedgerEntry.Next() = 0;

        exit(Total);
    end;
}