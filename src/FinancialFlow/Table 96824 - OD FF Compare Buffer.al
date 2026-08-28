table 96934 "OD FF Compare Buffer"
{
    Caption = 'OD Financial Flow Compare Buffer';
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
        field(3; "Snapshot No. 1"; Code[20])
        {
            Caption = 'Snapshot 1';
        }
        field(4; "Snapshot No. 2"; Code[20])
        {
            Caption = 'Snapshot 2';
        }
        field(5; "Company Name"; Text[30])
        {
            Caption = 'Empresa';
        }
        field(6; "Property No."; Code[20])
        {
            Caption = 'Nº activo';
        }
        field(7; "Contract No."; Code[20])
        {
            Caption = 'Nº contrato';
        }
        field(8; Description; Text[100])
        {
            Caption = 'Descripción';
        }
        field(9; "Change Type"; Text[30])
        {
            Caption = 'Tipo cambio';
        }
        field(10; "Monthly Rent Delta"; Decimal)
        {
            Caption = 'Variación renta mensual';
        }
        field(11; "Annual Rent Delta"; Decimal)
        {
            Caption = 'Variación renta anual';
        }
        field(12; "Market Value Delta"; Decimal)
        {
            Caption = 'Variación valor mercado';
        }
        field(13; "Cadastral Value Delta"; Decimal)
        {
            Caption = 'Variación valor catastral';
        }
        field(14; "Selling Price Delta"; Decimal)
        {
            Caption = 'Variación precio venta';
        }
        field(15; "Gross Yield Delta"; Decimal)
        {
            Caption = 'Variación yield bruto';
            DecimalPlaces = 0 : 5;
        }
        field(16; "Net Yield Delta"; Decimal)
        {
            Caption = 'Variación yield neto';
            DecimalPlaces = 0 : 5;
        }
        field(17; "Cash Flow Delta"; Decimal)
        {
            Caption = 'Variación cash flow';
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
    }
}
