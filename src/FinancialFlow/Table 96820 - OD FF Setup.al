table 96930 "OD FF Setup"
{
    Caption = 'OD Financial Flow Setup';
    DataClassification = CustomerContent;

    fields
    {
        field(1; "Primary Key"; Code[10])
        {
            Caption = 'Clave primaria';
            DataClassification = SystemMetadata;
        }
        field(10; "Include Inactive Companies"; Boolean)
        {
            Caption = 'Incluir empresas inactivas';
        }
        field(11; "Include Blocked Companies"; Boolean)
        {
            Caption = 'Incluir empresas bloqueadas';
        }
        field(12; "Include Expired Contracts"; Boolean)
        {
            Caption = 'Incluir contratos vencidos';
        }
        field(13; "Include Future Contracts"; Boolean)
        {
            Caption = 'Incluir contratos futuros';
        }
        field(14; "Include Cancelled Contracts"; Boolean)
        {
            Caption = 'Incluir contratos cancelados';
        }
        field(20; "Default Market Value Source"; Enum "OD FF Value Source")
        {
            Caption = 'Origen valoración por defecto';
        }
        field(21; "Default Selling Cost %"; Decimal)
        {
            Caption = '% costes venta por defecto';
            DecimalPlaces = 0 : 5;
        }
        field(22; "Default Annual Maint. %"; Decimal)
        {
            Caption = '% mantenimiento anual por defecto';
            DecimalPlaces = 0 : 5;
        }
        field(23; "Default Vacancy Percentage"; Decimal)
        {
            Caption = '% vacancia por defecto';
            DecimalPlaces = 0 : 5;
        }
        field(24; "Default Management Cost %"; Decimal)
        {
            Caption = '% coste gestión por defecto';
            DecimalPlaces = 0 : 5;
        }
        field(25; "Default Discount Rate"; Decimal)
        {
            Caption = '% tasa descuento por defecto';
            DecimalPlaces = 0 : 5;
        }
        field(26; "Warning Days Before End"; Integer)
        {
            Caption = 'Días aviso antes vencimiento';
        }
        field(27; "Minimum Target Yield"; Decimal)
        {
            Caption = 'Rentabilidad objetivo mínima';
            DecimalPlaces = 0 : 5;
        }
        field(28; "Max. Customer Concentration %"; Decimal)
        {
            Caption = '% máx. concentración cliente';
            DecimalPlaces = 0 : 5;
        }
        field(29; "Snapshot No. Series"; Code[20])
        {
            Caption = 'Serie nº snapshots';
            TableRelation = "No. Series";
        }
        field(30; "Last Analysis DateTime"; DateTime)
        {
            Caption = 'Fecha/hora último análisis';
        }
        field(31; "Last Snapshot No."; Code[20])
        {
            Caption = 'Último nº snapshot';
        }
        field(32; "Exclude Test Companies"; Boolean)
        {
            Caption = 'Excluir empresas de prueba';
        }
        field(33; "Test Company Filter"; Text[100])
        {
            Caption = 'Filtro empresas de prueba';
        }
    }

    keys
    {
        key(PK; "Primary Key")
        {
            Clustered = true;
        }
    }

    procedure EnsureSetup()
    begin
        if Rec.Get('SETUP') then
            exit;

        Rec.Init();
        Rec."Primary Key" := 'SETUP';
        Rec."Default Market Value Source" := Rec."Default Market Value Source"::MarketValue;
        Rec."Default Selling Cost %" := 5;
        Rec."Default Annual Maint. %" := 2;
        Rec."Default Vacancy Percentage" := 3;
        Rec."Default Management Cost %" := 5;
        Rec."Default Discount Rate" := 6;
        Rec."Warning Days Before End" := 90;
        Rec."Minimum Target Yield" := 4;
        Rec."Max. Customer Concentration %" := 35;
        Rec."Test Company Filter" := 'TEST|CRONUS*';
        Rec.Insert();
    end;
}
