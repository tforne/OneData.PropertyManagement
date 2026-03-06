page 50100 "Sales by Month Chart"
{
    PageType = CardPart;
    ApplicationArea = All;
    UsageCategory = None;
    Caption = 'Ventas por mes';

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
        SalesInvHeader: Record "Sales Invoice Header";
        StartDate: Date;
        EndDate: Date;
        MonthNo: Integer;
        MonthLabel: Text;
        MonthAmount: Decimal;
        CurrentMonthStart: Date;
        CurrentMonthEnd: Date;

    local procedure UpdateChart()
    var
        XAxisIndex: Integer;
    begin
        BusinessChart.Initialize();
        BusinessChart.SetXDimension('Mes', Enum::System.Visualization."Business Chart Data Type"::String);
        BusinessChart.AddMeasure('Ventas',0,Enum::"Business Chart Data Type"::Decimal,Enum::"Business Chart Type"::Column);

        XAxisIndex := 0;
        for MonthNo := 11 downto 0 do begin
            CurrentMonthStart := CalcDate('<-CM>', CalcDate(StrSubstNo('-%1M', MonthNo), Today));
            CurrentMonthEnd := CalcDate('<CM>', CurrentMonthStart);

            MonthLabel := Format(CurrentMonthStart, 0, '<Month Text,3> <Year4>');
            // MonthAmount := GetSalesAmount(CurrentMonthStart, CurrentMonthEnd);
            MonthAmount := XAxisIndex * 1000; // Dummy data for testing
            BusinessChart.AddDataRowWithXDimension(MonthLabel);
            BusinessChart.SetValue(0, XAxisIndex, MonthAmount);
            XAxisIndex += 1;
        end;

        BusinessChart.Update(CurrPage.BusinessChart);
    end;

    local procedure GetSalesAmount(DateFrom: Date; DateTo: Date): Decimal
    var
        TotalSales: Decimal;
        SalesInvHeader2: Record "Sales Invoice Header";
    begin
        TotalSales := 0;
        SalesInvHeader2.Reset();
        SalesInvHeader2.SetRange("Posting Date", DateFrom, DateTo);

        if SalesInvHeader2.FindSet() then
            repeat
                TotalSales += SalesInvHeader2.Amount;
            until SalesInvHeader2.Next() = 0;

        exit(TotalSales);
    end;
}