table 96932 "OD FF Snapshot Header"
{
    Caption = 'OD Financial Flow Snapshot Header';
    DataClassification = CustomerContent;

    fields
    {
        field(1; "Snapshot No."; Code[20])
        {
            Caption = 'Nº snapshot';
        }
        field(2; Description; Text[100])
        {
            Caption = 'Descripción';
        }
        field(3; "Analysis Date"; Date)
        {
            Caption = 'Fecha análisis';
        }
        field(4; "Analysis Time"; Time)
        {
            Caption = 'Hora análisis';
        }
        field(5; "Analysis DateTime"; DateTime)
        {
            Caption = 'Fecha/hora análisis';
        }
        field(6; "User ID"; Code[50])
        {
            Caption = 'Id. usuario';
        }
        field(7; "Source Company"; Text[30])
        {
            Caption = 'Empresa origen';
        }
        field(10; "No. of Companies"; Integer)
        {
            Caption = 'Nº empresas';
        }
        field(11; "No. of Properties"; Integer)
        {
            Caption = 'Nº activos';
        }
        field(12; "No. of Contracts"; Integer)
        {
            Caption = 'Nº contratos';
        }
        field(20; "Total Monthly Rent"; Decimal)
        {
            Caption = 'Renta mensual total';
        }
        field(21; "Total Annual Rent"; Decimal)
        {
            Caption = 'Renta anual total';
        }
        field(22; "Total Cadastral Value"; Decimal)
        {
            Caption = 'Valor catastral total';
        }
        field(23; "Total Purchase Price"; Decimal)
        {
            Caption = 'Precio compra total';
        }
        field(24; "Total Market Value"; Decimal)
        {
            Caption = 'Valor mercado total';
        }
        field(25; "Total Est. Selling Price"; Decimal)
        {
            Caption = 'Precio venta estimado total';
        }
        field(26; "Forecast Income 12M"; Decimal)
        {
            Caption = 'Ingresos previstos 12M';
        }
        field(27; "Forecast Income 24M"; Decimal)
        {
            Caption = 'Ingresos previstos 24M';
        }
        field(28; "Forecast Income 60M"; Decimal)
        {
            Caption = 'Ingresos previstos 60M';
        }
        field(29; "Weighted Gross Yield %"; Decimal)
        {
            Caption = 'Yield bruto ponderado %';
            DecimalPlaces = 0 : 5;
        }
        field(30; "Weighted Net Yield %"; Decimal)
        {
            Caption = 'Yield neto ponderado %';
            DecimalPlaces = 0 : 5;
        }
        field(31; "Total Cash Flow"; Decimal)
        {
            Caption = 'Cash flow total';
        }
        field(32; "High Risk Contracts"; Integer)
        {
            Caption = 'Contratos alto riesgo';
        }
        field(33; "Critical Risk Contracts"; Integer)
        {
            Caption = 'Contratos riesgo crítico';
        }
        field(34; Status; Enum "OD FF Status")
        {
            Caption = 'Estado';
        }
        field(35; "Version No."; Code[20])
        {
            Caption = 'Versión';
        }
    }

    keys
    {
        key(PK; "Snapshot No.")
        {
            Clustered = true;
        }
        key(Key1; "Analysis DateTime")
        {
        }
    }
}
