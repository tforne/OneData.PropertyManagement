report 96611 "Entrega Llaves y Posesion"
{
    Caption = 'Entrega de llaves y toma de posesión';
    UsageCategory = ReportsAndAnalysis;
    ApplicationArea = All;
    DefaultLayout = Word;
    WordLayout = '.vscode/Reports/Report 96611 - Entrega llaves y posesion.docx';

    dataset
    {
        dataitem(LiquidacionHeader; "Liquidacion Contrato Header")
        {
            RequestFilterFields = "Contract No.";

            column(ContractNo; "Contract No.") { }
            column(FechaEntregaLlaves; "Fecha Entrega Llaves") { }
            column(FechaLiquidacion; "Fecha Liquidacion") { }
            column(MotivoLiquidacion; "Motivo Liquidacion") { }
            column(AmountRentalDeposit; "Amount Rental Deposit") { }
            column(RentaFinal; "Renta Final") { }
            column(PenalizacionTexto; Format(Penalizacion, 0, '<Sign><Integer Thousand><Decimals,2> €')) { }
            column(FianzaLegalTexto; Format(FianzaLegal, 0, '<Sign><Integer Thousand><Decimals,2> €')) { }
            column(FianzaAdicionalTexto; Format(FianzaAdicional, 0, '<Sign><Integer Thousand><Decimals,2> €')) { }
            column(RentaFinalTexto; Format("Renta Final", 0, '<Sign><Integer Thousand><Decimals,2> €')) { }
            column(CiudadFirma; CiudadFirma) { }
            column(FechaFirmaTexto; FechaFirmaTexto) { }
            column(FechaContratoTexto; FechaContratoTexto) { }
            column(DireccionInmuebleCompleta; DireccionInmuebleCompleta) { }
            column(ArrendadorNombre; ArrendadorNombre) { }
            column(ArrendadorNIF; ArrendadorNIF) { }
            column(ArrendadorDomicilio; ArrendadorDomicilio) { }
            column(Arrendatario1Nombre; Arrendatario1Nombre) { }
            column(Arrendatario1NIF; Arrendatario1NIF) { }
            column(Arrendatario1Domicilio; Arrendatario1Domicilio) { }
            column(Arrendatario2Nombre; Arrendatario2Nombre) { }
            column(Arrendatario2NIF; Arrendatario2NIF) { }
            column(Arrendatario2Domicilio; Arrendatario2Domicilio) { }
            column(Arrendatario2Bloque; Arrendatario2Bloque) { }
            column(CuentaBancaria; CuentaBancaria) { }
            column(TextoEstadoPago; TextoEstadoPago) { }
            column(LecturaAgua; LecturaAgua) { }
            column(LecturaLuz; LecturaLuz) { }
            column(LecturaGas; LecturaGas) { }
            column(ObservacionesSuministros; ObservacionesSuministros) { }
            column(CheckBueno; CheckBueno) { }
            column(CheckDeficiencias; CheckDeficiencias) { }

            dataitem(DefectLine; Integer)
            {
                DataItemTableView = sorting(Number);

                column(DefectNo; Number) { }
                column(DefectDescription; GetDefectDescription(Number)) { }
                column(DefectObservation; GetDefectObservation(Number)) { }

                trigger OnPreDataItem()
                begin
                    SetRange(Number, 1, GetDefectLineCount());
                end;
            }

            trigger OnAfterGetRecord()
            begin
                LoadDocumentData();
            end;
        }
    }

    requestpage
    {
        layout
        {
            area(content)
            {
                group(Options)
                {
                    field(ShowEmptyAnnexLines; ShowEmptyAnnexLines)
                    {
                        Caption = 'Mostrar 10 líneas vacías si no hay deficiencias';
                    }
                }
            }
        }
    }

    var
        ContractHeader: Record "Lease Contract";
        FixedRealEstate : Record "Fixed Real Estate";
        LiquidacionLine: Record "Liquidacion Contrato Lines";
        TempDefectLine: Record "Liquidacion Contrato Lines" temporary;
        RelatedContact: Record "REF Related Contactos";
        Customer1, Customer2 : record Customer;
        CiudadFirma: Text[100];
        FechaFirmaTexto: Text[100];
        FechaContratoTexto: Text[100];
        DireccionInmuebleCompleta: Text[250];
        ArrendadorNombre: Text[150];
        ArrendadorNIF: Text[50];
        ArrendadorDomicilio: Text[250];
        Arrendatario1Nombre: Text[150];
        Arrendatario1NIF: Text[50];
        Arrendatario1Domicilio: Text[250];
        Arrendatario2Nombre: Text[150];
        Arrendatario2NIF: Text[50];
        Arrendatario2Domicilio: Text[250];
        Arrendatario2Bloque: Text[250];
        CuentaBancaria: Text[100];
        TextoEstadoPago: Text[250];
        LecturaAgua: Text[100];
        LecturaLuz: Text[100];
        LecturaGas: Text[100];
        ObservacionesSuministros: Text[250];
        FianzaLegal: Decimal;
        FianzaAdicional: Decimal;
        Penalizacion: Decimal;
        CheckBueno: Text[5];
        CheckDeficiencias: Text[5];
        ShowEmptyAnnexLines: Boolean;
        FechaContrato: Date;
        DireccionInmueble: Text[250];
        CodigoPostalInmueble: Code[20];
        PoblacionInmueble: Text[100];
        ProvinciaInmueble: Text[100];

    local procedure LoadDocumentData()
    begin
        ClearDocumentData();

        // Ajustar estos campos al modelo real del proyecto.

        // Recuperar datos del contrato
        if ContractHeader.Get(LiquidacionHeader."Contract No.") then begin
            FechaContrato := ContractHeader."Starting Date"; 
            FechaContratoTexto := Format(FechaContrato, 0, '<Day,2> de <Month Text> de <Year4>');
            DireccionInmueble := ContractHeader.Address; 
            CodigoPostalInmueble := ContractHeader."Post Code"; 
            PoblacionInmueble := ContractHeader.City; 
            ProvinciaInmueble := ContractHeader.County; 

            // DireccionInmuebleCompleta := FormatAddressDocument(DireccionInmueble,PoblacionInmueble,CodigoPostalInmueble, ProvinciaInmueble);
            FixedRealEstate.get(ContractHeader."Fixed Real Estate No.");
            DireccionInmuebleCompleta := FixedRealEstate.Description;

            RelatedContact.reset;
            RelatedContact.setrange("Entity Type", RelatedContact."Entity Type"::Contract);
            RelatedContact.setrange("Source No.",ContractHeader."Contract No.");
            RelatedContact.setrange(Type,RelatedContact.type::Owner);
            if RelatedContact.FindFirst() then begin
                RelatedContact.CalcFields(Name,Address,City,"Post Code",County);
                ArrendadorNombre := RelatedContact.Name; 
                ArrendadorNIF := Customer1."VAT Registration No.";
                ArrendadorDomicilio := FormatAddressDocument(RelatedContact.Address,RelatedContact.City,RelatedContact."Post Code",RelatedContact.County);
            end;

            if contractHeader."Customer No." <> '' then begin
                Customer1.get(ContractHeader."Customer No.");    
                Arrendatario1Nombre := Customer1.Name;
                Arrendatario1NIF := Customer1."VAT Registration No.";
                Arrendatario1Domicilio := FormatAddressDocument(Customer1.Address,Customer1.City,Customer1."Post Code",Customer1.County);
            end;
            
            if ContractHeader."Second Customer No." <> '' then begin
                Customer2.get(ContractHeader."Second Customer No.");    
                Arrendatario2Nombre := Customer2.Name;
                Arrendatario2NIF := Customer2."VAT Registration No.";
                Arrendatario2Domicilio := FormatAddressDocument(Customer2.Address,Customer2.City,Customer2."Post Code",Customer2.County);
            end;

            ContractHeader.CalcFields("Amount Rental Deposit");
            FianzaLegal := ContractHeader."Amount Rental Deposit";
            //FianzaAdicional := ContractHeader."Additional Deposit Amount";
            // CuentaBancaria := ContractHeader."Bank Account No.";
        end;


        FechaFirmaTexto := Format(LiquidacionHeader."Fecha Liquidacion", 0, '<Day,2> de <Month Text> de <Year4>');
        CiudadFirma := LiquidacionHeader."Ciudad Entrega Llaves";
        Penalizacion := LiquidacionHeader.Penalizacion;

        if Arrendatario2Nombre <> '' then begin
            Arrendatario2Bloque := StrSubstNo('Y también %1, con NIF %2 y domicilio en %3, en su condición de ARRENDATARIO/A.', Arrendatario2Nombre, Arrendatario2NIF, Arrendatario2Domicilio)
        end else
            Arrendatario2Bloque := '';

        if LiquidacionHeader."Renta Final" = 0 then
            TextoEstadoPago := 'La parte arrendadora declara que no existen rentas pendientes a la fecha de la entrega, sin perjuicio de las regularizaciones posteriores que procedan.'
        else
            TextoEstadoPago := StrSubstNo('Queda una regularización pendiente por importe de %1.', Format(LiquidacionHeader."Renta Final", 0, '<Sign><Integer Thousand><Decimals,2> €'));

        LecturaAgua := 'Pendiente de informar';
        LecturaLuz := 'Pendiente de informar';
        LecturaGas := '-';
        ObservacionesSuministros := 'Adjuntar lecturas o últimas facturas si procede.';

        LoadDefectLines();
        SetChecks();
    end;

    local procedure LoadDefectLines()

    begin
        TempDefectLine.DeleteAll();

        LiquidacionLine.Reset();
        LiquidacionLine.SetRange("Contract No.", LiquidacionHeader."Contract No.");
        // Recomendado: filtrar aquí solo líneas de tipo deficiencia visible.
        if LiquidacionLine.FindSet() then
            repeat
                TempDefectLine := LiquidacionLine;
                TempDefectLine.Insert();
            until LiquidacionLine.Next() = 0;
    end;

    local procedure SetChecks()
    begin
        if TempDefectLine.IsEmpty() then begin
            CheckBueno := '☒';
            CheckDeficiencias := '☐';
        end else begin
            CheckBueno := '☐';
            CheckDeficiencias := '☒';
        end;
    end;

    local procedure GetDefectLineCount(): Integer
    begin
        if TempDefectLine.IsEmpty() then begin
            if ShowEmptyAnnexLines then
                exit(10)
            else
                exit(1);
        end;

        exit(TempDefectLine.Count);
    end;

    local procedure GetDefectDescription(LineNo: Integer): Text
    var
        Counter: Integer;
    begin
        if TempDefectLine.IsEmpty() then
            exit('');

        Counter := 0;
        TempDefectLine.Reset();
        if TempDefectLine.FindSet() then
            repeat
                Counter += 1;
                if Counter = LineNo then
                    exit(TempDefectLine.Description);
            until TempDefectLine.Next() = 0;

        exit('');
    end;

    local procedure GetDefectObservation(LineNo: Integer): Text
    var
        Counter: Integer;
    begin
        if TempDefectLine.IsEmpty() then
            exit('');

        Counter := 0;
        TempDefectLine.Reset();
        if TempDefectLine.FindSet() then
            repeat
                Counter += 1;
                if Counter = LineNo then
                    exit(Format(TempDefectLine."Description"));
            until TempDefectLine.Next() = 0;

        exit('');
    end;

    local procedure ClearDocumentData()
    begin
        Clear(CiudadFirma);
        Clear(FechaFirmaTexto);
        Clear(FechaContratoTexto);
        Clear(DireccionInmuebleCompleta);
        Clear(ArrendadorNombre);
        Clear(ArrendadorNIF);
        Clear(ArrendadorDomicilio);
        Clear(Arrendatario1Nombre);
        Clear(Arrendatario1NIF);
        Clear(Arrendatario1Domicilio);
        Clear(Arrendatario2Nombre);
        Clear(Arrendatario2NIF);
        Clear(Arrendatario2Domicilio);
        Clear(Arrendatario2Bloque);
        Clear(CuentaBancaria);
        Clear(TextoEstadoPago);
        Clear(LecturaAgua);
        Clear(LecturaLuz);
        Clear(LecturaGas);
        Clear(ObservacionesSuministros);
        Clear(FianzaLegal);
        Clear(FianzaAdicional);
        Clear(Penalizacion);
        Clear(CheckBueno);
        Clear(CheckDeficiencias);
    end;
    
    local procedure FormatAddressDocument(Address:Text[100];City: Text[30]; PostCode:Code[20]; County: Text[30]) : Text
    var
        AddresAux : text;    
    begin
        AddresAux := '';
        if City <> '' then
            AddresAux := City;
        if County <> '' then
            AddresAux := AddresAux + ' (' +County+')';
        if PostCode <> '' then
            Address := Address + ' C.P. '+ PostCode;
        if Address<>'' then
            AddresAux := AddresAux +', '+Address;
        exit(AddresAux);
    end;
}
