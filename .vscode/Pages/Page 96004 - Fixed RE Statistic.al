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

    layout
    {
        area(content)
        {
            group(General)
            {
                Caption = 'General';
                fixed(Control1903895301)
                {
                    ShowCaption = false;
                    group(Amount)
                    {
                        Caption = 'Amount';

                        field("Val. Castastral Const. Activo"; rec."Val. Castastral Const. Activo")
                        {
                            ApplicationArea = All;
                            ToolTip = 'Specifies the total LCY amount of write-down entries for the fixed asset.';
                        }
                        field("Val. Catastral Activo"; rec."Val. Catastral Activo")
                        {
                            ApplicationArea = All;
                            ToolTip = 'Specifies the total LCY amount for custom 1 entries for the fixed asset.';
                        }
                        field("Sales Price"; rec."Sales price")
                        {   
                            ApplicationArea = All;
                            ToolTip = 'Specifies the total LCY amount for custom 2 entries for the fixed asset.';
                        }
                        field("Minimum Sales Price";Rec."Minimum Sales Price")
                        {
                            ApplicationArea = All;
                            ToolTip = 'Specifies the minimum sale price for the fixed asset.';
                        }
                        field("Minimum Rental Sales Price";Rec."Rental Price")
                        {
                            ApplicationArea = All;
                            ToolTip = 'Specifies the minimum rental sale price for the fixed asset including tax.';
                        }
                    }
                }

            }
            group(FlujoCaja)
            {
                Caption = 'Flujo de Caja';
                usercontrol(BusinessChart; BusinessChart)
                {
                    ApplicationArea = All;

                    trigger AddInReady()
                    begin
                        UpdateChart();
                    end;
                }
            }
            group(Rentability)
            {
                Caption = 'Rentability';
                field("Rentabilidad Bruta"; RentabilidadBruta)
                {
                    ApplicationArea = All;
                    Caption = 'Gross Rentability';
                    ToolTip = 'Specifies the gross rentability for the fixed asset.';
                }
                field("Rentabilidad Neta"; RentabilidadNeta)
                {
                    ApplicationArea = All;
                    Caption = 'Net Rentability';
                    ToolTip = 'Specifies the net rentability for the fixed asset.';
                }
                field("Flujo Caja Mensual"; FlujoCajaMensual)
                {
                    ApplicationArea = All;
                    Caption = 'Monthly Cash Flow';
                    ToolTip = 'Specifies the monthly cash flow for the fixed asset.';
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
        // Rec.CalcBookValue();
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
        RentabilidadNeta: Decimal;
        FlujoCajaMensual: Decimal;
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

