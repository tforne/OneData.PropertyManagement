report 96610 "Liquidacion Contrato"
{
    Caption = 'Liquidación de contrato';
    UsageCategory = ReportsAndAnalysis;
    ApplicationArea = All;
    DefaultLayout = Word;
    WordLayout = '.vscode/Reports/Report 96610 - Liquidación Contrato.docx';



    dataset
    {
        dataitem(LiquidacionHeader; "Liquidacion Contrato Header")
        {
            RequestFilterFields = "Contract No.";

            column(ContractNo; "Contract No.") { }
            column(FechaEntregaLlaves; "Fecha Entrega Llaves") { }
            column(MotivoLiquidacion; "Motivo Liquidacion") { }
            column(FechaLiquidacion; "Fecha Liquidacion") { }

            column(AmountRentalDeposit; "Amount Rental Deposit") { }
            column(RentaFinal; "Renta Final") { }
            column(Penalizacion; Penalizacion) { } // AJUSTAR si el campo es rec."Penalizacion"

            // Datos literales / presentación
            column(CiudadFirma; CiudadFirma) { }
            column(FechaFirmaTexto; Format("Fecha Liquidacion", 0, '<Day,2> de <Month Text> de <Year4>')) { }

            // Datos arrendador
            column(ArrendadorNombre; ArrendadorNombre) { }
            column(ArrendadorNIF; ArrendadorNIF) { }
            column(ArrendadorDomicilio; ArrendadorDomicilio) { }

            // Datos arrendatario 1
            column(Arrendatario1Nombre; Arrendatario1Nombre) { }
            column(Arrendatario1NIF; Arrendatario1NIF) { }
            column(Arrendatario1Domicilio; Arrendatario1Domicilio) { }

            // Datos arrendatario 2
            column(Arrendatario2Nombre; Arrendatario2Nombre) { }
            column(Arrendatario2NIF; Arrendatario2NIF) { }
            column(Arrendatario2Domicilio; Arrendatario2Domicilio) { }

            // Datos contrato / inmueble
            column(FechaContrato; FechaContrato) { }
            column(DireccionInmueble; DireccionInmueble) { }
            column(CodigoPostalInmueble; CodigoPostalInmueble) { }
            column(PoblacionInmueble; PoblacionInmueble) { }
            column(ProvinciaInmueble; ProvinciaInmueble) { }

            // Importes complementarios
            column(FianzaLegal; FianzaLegal) { }
            column(FianzaAdicional; FianzaAdicional) { }
            column(CuentaBancaria; CuentaBancaria) { }

            // Rentas / observaciones
            column(AlCorrientePagoTexto; AlCorrientePagoTexto) { }
            column(MesesPendientesTexto; MesesPendientesTexto) { }

            // Estado inmueble
            column(EstadoInmuebleBueno; EstadoInmuebleBueno) { }
            column(EstadoInmuebleDeficiencias; EstadoInmuebleDeficiencias) { }

            // Suministros
            column(LecturaAgua; LecturaAgua) { }
            column(LecturaLuz; LecturaLuz) { }
            column(LecturaGas; LecturaGas) { }

            // Textos checkbox Word
            column(CheckBueno; CheckBueno) { }
            column(CheckDeficiencias; CheckDeficiencias) { }

            // Texto cantidades formateadas
            column(FianzaLegalTexto; Format(FianzaLegal, 0, '<Sign><Integer><Decimals,2>')) { }
            column(FianzaAdicionalTexto; Format(FianzaAdicional, 0, '<Sign><Integer><Decimals,2>')) { }
            column(AmountRentalDepositTexto; Format("Amount Rental Deposit", 0, '<Sign><Integer><Decimals,2>')) { }
            column(RentaFinalTexto; Format("Renta Final", 0, '<Sign><Integer><Decimals,2>')) { }
            column(PenalizacionTexto; Format(Penalizacion, 0, '<Sign><Integer><Decimals,2>')) { }

            dataitem(LiquidacionLine; "Liquidacion Contrato Lines")
            {
                DataItemLink = "Contract No." = FIELD("Contract No.");
                DataItemLinkReference = LiquidacionHeader;

                column(LineNo; "Line No.") { }
                column(Descripcion; Description) { } // AJUSTAR
                column(Importe; Amount) { } // AJUSTAR
            }

            trigger OnAfterGetRecord()
            begin
                CargarDatosContrato();
                PrepararChecks();
            end;
        }

        // DataItem opcional para imprimir 10 líneas vacías en el anexo
        dataitem(AnexoBlankLines; Integer)
        {
            DataItemTableView = sorting(Number) where(Number = filter(1 .. 10));

            column(AnexoNumero; Number) { }
            column(AnexoDescripcionVacia; '') { }
            column(AnexoObservacionesVacia; '') { }
        }
    }

    requestpage
    {
        layout
        {
            area(content)
            {
                group(Opciones)
                {
                    field(UsarLineasRealesEnAnexo; UsarLineasRealesEnAnexo)
                    {
                        Caption = 'Usar líneas reales en Anexo I';
                    }
                }
            }
        }
    }

    labels
    {
        TituloLbl = 'RESOLUCIÓN DE CONTRATO';
        ClausulasLbl = 'CLÁUSULAS DEL ACUERDO';
        AnexoLbl = 'ANEXO I';
    }

    var
        Penalizacion: Decimal;

        CiudadFirma: Text[100];

        ArrendadorNombre: Text[150];
        ArrendadorNIF: Text[50];
        ArrendadorDomicilio: Text[250];

        Arrendatario1Nombre: Text[150];
        Arrendatario1NIF: Text[50];
        Arrendatario1Domicilio: Text[250];

        Arrendatario2Nombre: Text[150];
        Arrendatario2NIF: Text[50];
        Arrendatario2Domicilio: Text[250];

        FechaContrato: Date;
        DireccionInmueble: Text[250];
        CodigoPostalInmueble: Code[20];
        PoblacionInmueble: Text[100];
        ProvinciaInmueble: Text[100];

        FianzaLegal: Decimal;
        FianzaAdicional: Decimal;
        CuentaBancaria: Text[50];

        AlCorrientePagoTexto: Text[250];
        MesesPendientesTexto: Text[250];

        EstadoInmuebleBueno: Boolean;
        EstadoInmuebleDeficiencias: Boolean;

        LecturaAgua: Text[100];
        LecturaLuz: Text[100];
        LecturaGas: Text[100];

        CheckBueno: Text[5];
        CheckDeficiencias: Text[5];

        UsarLineasRealesEnAnexo: Boolean;

    local procedure CargarDatosContrato()
    var
        ContractHeader: Record "Lease Contract"; 
        Customer1, Customer2: Record Customer; // si usas cliente como arrendatario
        Vendor: Record Vendor;     // si usas proveedor como arrendador
    begin
        Penalizacion := LiquidacionHeader."Penalizacion"; // AJUSTAR si el campo existe
        CiudadFirma := 'Montornés del Vallès'; // o recuperar del inmueble/empresa

        // Recuperar datos del contrato
        if ContractHeader.Get(LiquidacionHeader."Contract No.") then begin
            FechaContrato := ContractHeader."Starting Date"; 
            DireccionInmueble := ContractHeader.Address; 
            CodigoPostalInmueble := ContractHeader."Post Code"; 
            PoblacionInmueble := ContractHeader.City; 
            ProvinciaInmueble := ContractHeader.County; 

            ArrendadorNombre := '';
            ArrendadorNIF := '';
            ArrendadorDomicilio := '';
            Arrendatario1Nombre := '';
            Arrendatario1NIF := '';
            Arrendatario1Domicilio := '';

            Arrendatario2Nombre := '';
            Arrendatario2NIF := '';
            Arrendatario2Domicilio := '';
            
            ArrendadorNombre := Customer1.Name; 
            ArrendadorNIF := Customer1."VAT Registration No.";
            ArrendadorDomicilio := Customer1.Address;

            if contractHeader."Customer No." <> '' then begin
                Customer1.get(ContractHeader."Customer No.");    
                Arrendatario1Nombre := Customer1.Name;
                Arrendatario1NIF := Customer1."VAT Registration No.";
                Arrendatario1Domicilio := Customer1.Address;
            end;
            if ContractHeader."Second Customer No." <> '' then begin
                Customer2.get(ContractHeader."Second Customer No.");    
                
                Arrendatario2Nombre := Customer2.Name;
                Arrendatario2NIF := Customer2."VAT Registration No.";
                Arrendatario2Domicilio := Customer2.Address;
            end;

            ContractHeader.CalcFields("Amount Rental Deposit");
            FianzaLegal := ContractHeader."Amount Rental Deposit";
            //FianzaAdicional := ContractHeader."Additional Deposit Amount";
            // CuentaBancaria := ContractHeader."Bank Account No.";
        end;

        // Estado económico
        if LiquidacionHeader."Renta Final" = 0 then
            AlCorrientePagoTexto := 'La parte arrendadora declara estar al corriente de pago.'
        else
            AlCorrientePagoTexto := 'Existen importes pendientes de regularización.';

        MesesPendientesTexto := ''; // AJUSTAR si guardas meses pendientes en texto o en líneas

        // Checks estado inmueble
        EstadoInmuebleBueno := not ExistenDeficienciasVisibles();
        EstadoInmuebleDeficiencias := not EstadoInmuebleBueno;

        // Lecturas
        LecturaAgua := 'Fotos por WhatsApp ambas partes.'; // o campo tabla
        LecturaLuz := 'Fotos por WhatsApp ambas partes.';  // o campo tabla
        LecturaGas := '-';                                  // o campo tabla
    end;

    local procedure ExistenDeficienciasVisibles(): Boolean
    var
        LiquidacionLine: Record "Liquidacion Contrato Lines";
    begin
        LiquidacionLine.SetRange("Contract No.", LiquidacionHeader."Contract No.");
        // Opcional: filtrar solo líneas de tipo deficiencia visible
        exit(not LiquidacionLine.IsEmpty());
    end;

    local procedure PrepararChecks()
    begin
        if EstadoInmuebleBueno then
            CheckBueno := 'X'
        else
            CheckBueno := '';

        if EstadoInmuebleDeficiencias then
            CheckDeficiencias := 'X'
        else
            CheckDeficiencias := '';
    end;
}