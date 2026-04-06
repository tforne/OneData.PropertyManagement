page 96004 "Fixed RE Statistics"
{
    Caption = 'Fixed Real Estate Statistics';
    DataCaptionExpression = Rec.Caption();
    Editable = false;
    LinksAllowed = false;
    PageType = Card;
    RefreshOnActivate = true;
    SourceTable = "Fixed Real Estate";
    AboutTitle = 'About Fixed Real Estate Statistics';
    AboutText = 'Here you overview the total acquisition cost, depreciation, and book value for the asset.';
    ApplicationArea = All;

    layout
    {
        area(content)
        {
            group(General)
            {
                Caption = 'General';
                // fixed(Control1903895301)
                // {
                ShowCaption = false;
                group(Amount)
                {
                    Caption = 'Amount';

                    field("Val. Castastral Const. Activo"; rec."Val. Castastral Const. Activo")
                    {
                        ToolTip = 'Specifies the total LCY amount of write-down entries for the real estate asset.';
                    }
                    field("Val. Catastral Activo"; rec."Val. Catastral Activo")
                    {
                        ToolTip = 'Specifies the total LCY amount for custom 1 entries for the real estate asset.';
                    }
                    field("Sales Price"; rec."Sales price")
                    {
                        ToolTip = 'Specifies the total LCY amount for custom 2 entries for the real estate asset.';
                    }
                    field("Minimum Sales Price"; Rec."Minimum Sales Price")
                    {
                        ToolTip = 'Specifies the minimum sale price for the real estate asset.';
                    }
                    field("Last Rental Sales Price"; Rec."Last Rental Price")
                    {
                        ToolTip = 'Specifies the last rental sale price for the real estate asset including tax.';
                    }
                    field("Last Rental Price Modified"; rec."Last Rental Price Modified")
                    {
                        ToolTip = 'Specifies when the last rental price was last modified.';
                    }
                }
                //                }
            }
            group(FlujoCaja)
            {
                Caption = 'Flujo de Caja';
                usercontrol(BusinessChart; BusinessChart)
                {

                    trigger AddInReady()
                    begin
                        UpdateChart();
                    end;
                }
            }
            group(Rentability)
            {
                Caption = 'Rentability';
                field("Total Flujo Caja"; TotalFlujoCaja)
                {
                    Caption = 'Total Flujo Caja';
                    ToolTip = 'Specifies the cash flow for the real estate asset.';
                    DecimalPlaces = 2 : 2;
                    AutoFormatType = 1;
                    BlankZero = true;
                }

                field("Rentabilidad Bruta"; RentabilidadBruta)
                {
                    Caption = 'Gross Rentability';
                    ToolTip = 'Specifies the gross rentability for the real estate asset.';
                    DecimalPlaces = 2 : 2;
                    AutoFormatType = 2;

                }
                field("Previsión Gastos Anual"; PrevisionGastosAnual)
                {
                    Caption = 'Annual Expense Forecast';
                    ToolTip = 'Specifies the annual expense forecast for the real estate asset.';
                    DecimalPlaces = 2 : 2;
                    AutoFormatType = 1;
                    BlankZero = true;

                }
                field("Rentabilidad Prevista Neta"; RentabilidadPrevistaNeta)
                {
                    Caption = 'Net Rentability Forecast';
                    ToolTip = 'Specifies the net rentability forecast for the real estate asset.';
                    DecimalPlaces = 2 : 2;
                    AutoFormatType = 2;
                }
                field("Gastos Anual"; GastosAnual)
                {
                    Caption = 'Annual Expense';
                    ToolTip = 'Specifies the annual expense for the real estate asset.';
                    DecimalPlaces = 2 : 2;
                    AutoFormatType = 1;
                    BlankZero = true;
                }
                field("Rentabilidad Neta"; RentabilidadNeta)
                {
                    Caption = 'Net Rentability';
                    ToolTip = 'Specifies the net rentability for the real estate asset.';
                    DecimalPlaces = 2 : 2;
                    AutoFormatType = 2;
                    StyleExpr = RentabilidadStyle;
                }

            }
            group(OcupaciónEstabilidad)
            {
                Caption = 'Ocupación y Estabilidad';
            }
            group(Proyecciones)
            {
                Caption = 'Proyecciones';
                // Proyecciones de cash flow a 5 años.
            }
        }
    }

    actions
    {
    }

    trigger OnAfterGetRecord()
    begin
        DisposalValueVisible := Disposed;
        ProceedsOnDisposalVisible := Disposed;
        GainLossVisible := Disposed;
        DisposalDateVisible := Disposed;
        CalculateRentability(rec, RentabilidadBruta, RentabilidadNeta, TotalFlujoCaja);
        if RentabilidadNeta < 5 then
            RentabilidadStyle := 'Unfavorable'
        else
            RentabilidadStyle := 'Favorable';
    end;

    trigger OnInit()
    begin
        DisposalDateVisible := true;
        GainLossVisible := true;
        ProceedsOnDisposalVisible := true;
        DisposalValueVisible := true;
    end;

    var
        Disposed: Boolean;
        DisposalValueVisible: Boolean;
        ProceedsOnDisposalVisible: Boolean;
        GainLossVisible: Boolean;
        DisposalDateVisible: Boolean;
        RentabilidadBruta: Decimal;
        RentabilidadPrevistaNeta : Decimal;
        RentabilidadNeta: Decimal;
        FlujoCajaMensual: Decimal;
        PrevisionGastosAnual: Decimal;
        GastosAnual: Decimal;
        TotalFlujoCaja: Decimal;
        BusinessChart: Codeunit "Business Chart";
        SalesInvHeader: Record "Sales Invoice Header";
        StartDate: Date;
        EndDate: Date;
        MonthNo: Integer;
        MonthLabel: Text;
        MonthAmountIncoming: Decimal;
        MonthAmountExpenses: Decimal;
        CurrentMonthStart: Date;
        CurrentMonthEnd: Date;
        RentabilidadStyle : Text;


    local procedure UpdateChart()
    var
        XAxisIndex: Integer;
    begin
        BusinessChart.Initialize();
        BusinessChart.SetXDimension('Mes', Enum::System.Visualization."Business Chart Data Type"::String);
        BusinessChart.AddMeasure('Ventas', 0, Enum::"Business Chart Data Type"::Decimal, Enum::"Business Chart Type"::Column);
        BusinessChart.AddMeasure('Gastos', 0, Enum::"Business Chart Data Type"::Decimal, Enum::"Business Chart Type"::Column);

        XAxisIndex := 0;
        TotalFlujoCaja := 0;
        for MonthNo := 11 downto 0 do begin
            CurrentMonthStart := CalcDate('<-CM>', CalcDate(StrSubstNo('-%1M', MonthNo), Today));
            CurrentMonthEnd := CalcDate('<CM>', CurrentMonthStart);
            MonthLabel := Format(CurrentMonthStart, 0, '<Month Text,3> <Year4>');
            MonthAmountIncoming := GetSalesAmount(rec."No.", CurrentMonthStart, CurrentMonthEnd);
            MonthAmountExpenses := GetExpensesAmount(rec."No.", CurrentMonthStart, CurrentMonthEnd);
            TotalFlujoCaja += MonthAmountIncoming;
            GastosAnual += MonthAmountExpenses;
            BusinessChart.AddDataRowWithXDimension(MonthLabel);
            BusinessChart.SetValue(0, XAxisIndex, MonthAmountIncoming);
            BusinessChart.SetValue(1, XAxisIndex, MonthAmountExpenses);
            XAxisIndex += 1;
        end;
        BusinessChart.Update(CurrPage.BusinessChart);
    end;

    local procedure CalculateRentability(FixedRealEstate: record "Fixed Real Estate"; var RentabilidadBruta: Decimal; var RentabilidadNeta: Decimal; FlujoCajaMensual: Decimal)
    var
        FixedRealEstate2: Record "Fixed Real Estate";
        TotalSalesPrice: Decimal;
    begin
        // Implementation for calculating rentability   
        // Calculate Total Flujo Caja for the last 12 months
        TotalFlujoCaja := 0;
        GastosAnual := 0;
        for MonthNo := 11 downto 0 do begin
            CurrentMonthStart := CalcDate('<-CM>', CalcDate(StrSubstNo('-%1M', MonthNo), Today));
            CurrentMonthEnd := CalcDate('<CM>', CurrentMonthStart);
            MonthAmountIncoming := GetSalesAmount(rec."No.", CurrentMonthStart, CurrentMonthEnd);
            MonthAmountExpenses := GetExpensesAmount(rec."No.", CurrentMonthStart, CurrentMonthEnd);
            TotalFlujoCaja += MonthAmountIncoming;
            GastosAnual += MonthAmountExpenses;
        end;
        PrevisionGastosAnual := 0;
        FixedRealEstate2.reset;
        if FixedRealEstate.Type = FixedRealEstate.Type::Propiedad then
            FixedRealEstate2.Setfilter("Totaling", FixedRealEstate.Totaling)
        else
            FixedRealEstate2.SetRange("No.", FixedRealEstate."No.");
        if FixedRealEstate2.FindSet() then
            repeat
                FixedRealEstate2.CalcFields("Expense Amount");
                PrevisionGastosAnual += FixedRealEstate2."Expense Amount";
                TotalSalesPrice += FixedRealEstate2."Sales price";
            until FixedRealEstate2.Next() = 0;

        if TotalSalesPrice <> 0 then begin
            RentabilidadBruta := TotalFlujoCaja / TotalSalesPrice * 100;
            RentabilidadPrevistaNeta := (TotalFlujoCaja - PrevisionGastosAnual) / TotalSalesPrice * 100;
            RentabilidadNeta := (TotalFlujoCaja + GastosAnual) / TotalSalesPrice * 100;
        end else begin
            RentabilidadBruta := 0;
            RentabilidadPrevistaNeta := 0;
            RentabilidadNeta := 0;
        end;
    end;

    local procedure GetSalesAmount(RealStateNo: Code[20]; DateFrom: Date; DateTo: Date): Decimal
    var
        TotalSales: Decimal;
        FRELedgerEntry: Record "FRE Ledger Entry";
        FixedRealEstate: Record "Fixed Real Estate";
    begin
        TotalSales := 0;
        FixedRealEstate.Get(RealStateNo);
        FRELedgerEntry.reset();
        if FixedRealEstate.Type = FixedRealEstate.Type::Propiedad then
            FRELedgerEntry.Setfilter("Fixed Real Estate No.", FixedRealEstate.Totaling)
        else
            FRELedgerEntry.SetRange("Fixed Real Estate No.", RealStateNo);
        FRELedgerEntry.SetRange("Line Type", FRELedgerEntry."Line Type"::Invoice);
        FRELedgerEntry.SetRange("Document Type", FRELedgerEntry."Document Type"::Invoice);
        FRELedgerEntry.SetRange("Posting Date", DateFrom, DateTo);
        if FRELedgerEntry.FindSet() then
            repeat
                TotalSales += FRELedgerEntry.Amount;
            until FRELedgerEntry.Next() = 0;

        exit(TotalSales);
    end;
    
    local procedure GetExpensesAmount(RealStateNo: Code[20]; DateFrom: Date; DateTo: Date): Decimal
    var
        TotalExpenses: Decimal;
        FRELedgerEntry: Record "FRE Ledger Entry";
        FixedRealEstate: Record "Fixed Real Estate";
    begin
        TotalExpenses := 0;
        FixedRealEstate.Get(RealStateNo);
        FRELedgerEntry.reset();
        if FixedRealEstate.Type = FixedRealEstate.Type::Propiedad then
            FRELedgerEntry.Setfilter("Fixed Real Estate No.", FixedRealEstate.Totaling)
        else
            FRELedgerEntry.SetRange("Fixed Real Estate No.", RealStateNo);
        //FRELedgerEntry.SetRange("Line Type", FRELedgerEntry."Line Type"::Invoice);
        //FRELedgerEntry.SetRange("Document Type", FRELedgerEntry."Document Type"::Invoice);
        FRELedgerEntry.SetRange("Posting Date", DateFrom, DateTo);
        if FRELedgerEntry.FindSet() then
            repeat
                if FRELedgerEntry.Amount < 0 then
                    TotalExpenses += FRELedgerEntry.Amount;
            until FRELedgerEntry.Next() = 0;
        exit(TotalExpenses);
    end;

}

