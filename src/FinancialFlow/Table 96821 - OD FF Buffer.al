table 96931 "OD FF Buffer"
{
    Caption = 'OD Financial Flow Buffer';
    DataClassification = CustomerContent;

    fields
    {
        field(1; "Entry No."; Integer)
        {
            Caption = 'Nº movimiento';
            AutoIncrement = true;
        }
        field(2; "User ID"; Code[50])
        {
            Caption = 'Id. usuario';
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
        field(10; "Company Name"; Text[30])
        {
            Caption = 'Empresa';
        }
        field(11; "Company Display Name"; Text[100])
        {
            Caption = 'Nombre empresa';
        }
        field(12; "Property No."; Code[20])
        {
            Caption = 'Nº activo';
        }
        field(13; "Property Description"; Text[100])
        {
            Caption = 'Descripción activo';
        }
        field(14; "Contract No."; Code[20])
        {
            Caption = 'Nº contrato';
        }
        field(15; "Contract Description"; Text[100])
        {
            Caption = 'Descripción contrato';
        }
        field(16; "Customer No."; Code[20])
        {
            Caption = 'Nº cliente';
        }
        field(17; "Customer Name"; Text[100])
        {
            Caption = 'Nombre cliente';
        }
        field(18; "Contract Status"; Text[50])
        {
            Caption = 'Estado contrato';
        }
        field(19; "Contract Start Date"; Date)
        {
            Caption = 'Fecha inicio contrato';
        }
        field(20; "Contract End Date"; Date)
        {
            Caption = 'Fecha fin contrato';
        }
        field(21; "Remaining Months"; Decimal)
        {
            Caption = 'Meses restantes';
            DecimalPlaces = 0 : 5;
        }
        field(30; "Property Address"; Text[100])
        {
            Caption = 'Dirección activo';
        }
        field(31; "Postal Code"; Code[20])
        {
            Caption = 'C.P.';
        }
        field(32; City; Text[50])
        {
            Caption = 'Ciudad';
        }
        field(33; "Cadastral Reference"; Text[50])
        {
            Caption = 'Referencia catastral';
        }
        field(34; "Cadastral Value"; Decimal)
        {
            Caption = 'Valor catastral';
        }
        field(35; "Purchase Price"; Decimal)
        {
            Caption = 'Precio compra';
        }
        field(36; "Market Value"; Decimal)
        {
            Caption = 'Valor mercado';
        }
        field(37; "Estimated Selling Price"; Decimal)
        {
            Caption = 'Precio estimado venta';
        }
        field(38; "Acquisition Date"; Date)
        {
            Caption = 'Fecha adquisición';
        }
        field(39; "Surface Area"; Decimal)
        {
            Caption = 'Superficie';
            DecimalPlaces = 0 : 5;
        }
        field(40; "Monthly Rent"; Decimal)
        {
            Caption = 'Renta mensual';

            trigger OnValidate()
            begin
                UpdateCollectionDifference();
            end;
        }
        field(41; "Annual Rent"; Decimal)
        {
            Caption = 'Renta anual';
        }
        field(42; "Billing Frequency"; Text[50])
        {
            Caption = 'Periodicidad facturación';
        }
        field(43; "Next Billing Date"; Date)
        {
            Caption = 'Próxima facturación';
        }
        field(44; "Indexed Rent"; Decimal)
        {
            Caption = 'Renta indexada';
        }
        field(45; "CPI Percentage"; Decimal)
        {
            Caption = '% IPC';
            DecimalPlaces = 0 : 5;
        }
        field(46; "Deposit Amount"; Decimal)
        {
            Caption = 'Fianza';
        }
        field(47; "Guarantee Amount"; Decimal)
        {
            Caption = 'Garantía';
        }
        field(48; "Outstanding Amount"; Decimal)
        {
            Caption = 'Importe pendiente';
        }
        field(49; CollectedAmount; Decimal)
        {
            Caption = 'Importe cobrado';

            trigger OnValidate()
            begin
                UpdateCollectionDifference();
            end;
        }
        field(50; "Accrued Income"; Decimal)
        {
            Caption = 'Ingreso devengado';
        }
        field(51; "Remaining Contract Income"; Decimal)
        {
            Caption = 'Ingreso restante contrato';
        }
        field(52; "Forecast Income 12M"; Decimal)
        {
            Caption = 'Previsión ingresos 12M';
        }
        field(53; "Forecast Income 24M"; Decimal)
        {
            Caption = 'Previsión ingresos 24M';
        }
        field(54; "Forecast Income 60M"; Decimal)
        {
            Caption = 'Previsión ingresos 60M';
        }
        field(55; "Annual Operating Costs"; Decimal)
        {
            Caption = 'Costes operativos anuales';
        }
        field(56; "Annual Net Income"; Decimal)
        {
            Caption = 'Ingreso neto anual';
        }
        field(57; CollectionDifference; Decimal)
        {
            Caption = 'Diferencia cobros';
        }
        field(60; "Gross Yield Percentage"; Decimal)
        {
            Caption = 'Yield bruto %';
            DecimalPlaces = 0 : 5;
        }
        field(61; "Net Yield Percentage"; Decimal)
        {
            Caption = 'Yield neto %';
            DecimalPlaces = 0 : 5;
        }
        field(62; "ROI Percentage"; Decimal)
        {
            Caption = 'ROI %';
            DecimalPlaces = 0 : 5;
        }
        field(63; "Cap Rate Percentage"; Decimal)
        {
            Caption = 'Cap rate %';
            DecimalPlaces = 0 : 5;
        }
        field(64; "Estimated Capital Gain"; Decimal)
        {
            Caption = 'Plusvalía estimada';
        }
        field(65; "Cash Flow Amount"; Decimal)
        {
            Caption = 'Cash flow';
        }
        field(66; "Customer Concentration %"; Decimal)
        {
            Caption = '% concentración cliente';
            DecimalPlaces = 0 : 5;
        }
        field(67; "Risk Level"; Enum "OD FF Risk")
        {
            Caption = 'Riesgo';
        }
        field(68; "Risk Description"; Text[250])
        {
            Caption = 'Descripción riesgo';
        }
        field(69; "Value Source"; Enum "OD FF Value Source")
        {
            Caption = 'Origen valoración';
        }
        field(70; "Has Error"; Boolean)
        {
            Caption = 'Tiene error';
        }
        field(71; "Error Message"; Text[250])
        {
            Caption = 'Mensaje error';
        }
        field(72; Selected; Boolean)
        {
            Caption = 'Seleccionado';
        }
        field(73; "Flow Ranking"; Integer)
        {
            Caption = 'Ranking flujo';
        }
        field(74; "Asset Ranking"; Integer)
        {
            Caption = 'Ranking activo';
        }
        field(75; "Contract Ranking"; Integer)
        {
            Caption = 'Ranking contrato';
        }
        field(76; "Contract Page Id"; Integer)
        {
            Caption = 'Id. página contrato';
        }
        field(77; "Property Page Id"; Integer)
        {
            Caption = 'Id. página activo';
        }
    }

    keys
    {
        key(PK; "Entry No.")
        {
            Clustered = true;
        }
        key(Key1; "User ID", "Company Name", "Property No.", "Contract No.")
        {
        }
        key(Key2; "User ID", "Company Name", "Annual Rent")
        {
        }
        key(Key3; "User ID", "Company Name", "Market Value")
        {
        }
        key(Key4; "User ID", "Gross Yield Percentage")
        {
        }
        key(Key5; "User ID", "Risk Level")
        {
        }
        key(Key6; "User ID", "Contract End Date")
        {
        }
    }

    local procedure UpdateCollectionDifference()
    begin
        CollectionDifference := "Monthly Rent" - CollectedAmount;
    end;
}
