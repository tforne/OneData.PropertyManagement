table 96933 "OD FF Snapshot Line"
{
    Caption = 'OD Financial Flow Snapshot Line';
    DataClassification = CustomerContent;

    fields
    {
        field(1; "Snapshot No."; Code[20])
        {
            Caption = 'Nº snapshot';
        }
        field(2; "Line No."; Integer)
        {
            Caption = 'Nº línea';
        }
        field(3; "Company Name"; Text[30])
        {
            Caption = 'Empresa';
        }
        field(4; "Property No."; Code[20])
        {
            Caption = 'Nº activo';
        }
        field(5; "Property Description"; Text[100])
        {
            Caption = 'Descripción activo';
        }
        field(6; "Contract No."; Code[20])
        {
            Caption = 'Nº contrato';
        }
        field(7; "Contract Description"; Text[100])
        {
            Caption = 'Descripción contrato';
        }
        field(8; "Customer No."; Code[20])
        {
            Caption = 'Nº cliente';
        }
        field(9; "Customer Name"; Text[100])
        {
            Caption = 'Nombre cliente';
        }
        field(10; "Contract Status"; Text[50])
        {
            Caption = 'Estado contrato';
        }
        field(11; "Contract Start Date"; Date)
        {
            Caption = 'Fecha inicio';
        }
        field(12; "Contract End Date"; Date)
        {
            Caption = 'Fecha fin';
        }
        field(13; "Monthly Rent"; Decimal)
        {
            Caption = 'Renta mensual';
        }
        field(14; "Annual Rent"; Decimal)
        {
            Caption = 'Renta anual';
        }
        field(15; "Cadastral Value"; Decimal)
        {
            Caption = 'Valor catastral';
        }
        field(16; "Purchase Price"; Decimal)
        {
            Caption = 'Precio compra';
        }
        field(17; "Market Value"; Decimal)
        {
            Caption = 'Valor mercado';
        }
        field(18; "Estimated Selling Price"; Decimal)
        {
            Caption = 'Precio estimado venta';
        }
        field(19; "Remaining Contract Income"; Decimal)
        {
            Caption = 'Ingreso restante';
        }
        field(20; "Forecast Income 12M"; Decimal)
        {
            Caption = 'Previsión 12M';
        }
        field(21; "Forecast Income 24M"; Decimal)
        {
            Caption = 'Previsión 24M';
        }
        field(22; "Forecast Income 60M"; Decimal)
        {
            Caption = 'Previsión 60M';
        }
        field(23; "Annual Operating Costs"; Decimal)
        {
            Caption = 'Costes operativos anuales';
        }
        field(24; "Annual Net Income"; Decimal)
        {
            Caption = 'Ingreso neto anual';
        }
        field(25; "Gross Yield Percentage"; Decimal)
        {
            Caption = 'Yield bruto %';
            DecimalPlaces = 0 : 5;
        }
        field(26; "Net Yield Percentage"; Decimal)
        {
            Caption = 'Yield neto %';
            DecimalPlaces = 0 : 5;
        }
        field(27; "ROI Percentage"; Decimal)
        {
            Caption = 'ROI %';
            DecimalPlaces = 0 : 5;
        }
        field(28; "Cap Rate Percentage"; Decimal)
        {
            Caption = 'Cap rate %';
            DecimalPlaces = 0 : 5;
        }
        field(29; "Estimated Capital Gain"; Decimal)
        {
            Caption = 'Plusvalía estimada';
        }
        field(30; "Cash Flow Amount"; Decimal)
        {
            Caption = 'Cash flow';
        }
        field(31; "Customer Concentration %"; Decimal)
        {
            Caption = '% concentración cliente';
            DecimalPlaces = 0 : 5;
        }
        field(32; "Risk Level"; Enum "OD FF Risk")
        {
            Caption = 'Riesgo';
        }
        field(33; "Risk Description"; Text[250])
        {
            Caption = 'Descripción riesgo';
        }
        field(34; "Value Source"; Enum "OD FF Value Source")
        {
            Caption = 'Origen valoración';
        }
        field(35; "Has Error"; Boolean)
        {
            Caption = 'Tiene error';
        }
        field(36; "Error Message"; Text[250])
        {
            Caption = 'Mensaje error';
        }
    }

    keys
    {
        key(PK; "Snapshot No.", "Line No.")
        {
            Clustered = true;
        }
        key(Key1; "Snapshot No.", "Company Name", "Property No.", "Contract No.")
        {
        }
    }
}
