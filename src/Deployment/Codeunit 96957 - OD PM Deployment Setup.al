codeunit 96957 "OD PM Deployment Setup"
{
    [EventSubscriber(ObjectType::Codeunit, Codeunit::"OD Deployment Package Mgt.", 'OnAddDefaultDeploymentTables', '', false, false)]
    local procedure OnAddDefaultDeploymentTables()
    var
        DeploymentPackageMgt: Codeunit "OD Deployment Package Mgt.";
    begin
        RegisterAssetTables(DeploymentPackageMgt);
        RegisterContractTables(DeploymentPackageMgt);
    end;

    [EventSubscriber(ObjectType::Codeunit, Codeunit::"OD Deployment Package Mgt.", 'OnBeforeIsExplicitlyExcludedField', '', false, false)]
    local procedure OnBeforeIsExplicitlyExcludedField(TableId: Integer; FieldNo: Integer; var IsHandled: Boolean; var IsExcluded: Boolean)
    var
        FixedRealEstate: Record "Fixed Real Estate";
        LeaseContract: Record "Lease Contract";
        LeaseContractLine: Record "Lease Contract Line";
        LeaseContractUnit: Record "OD AM Lease Contract Unit";
    begin
        case TableId of
            Database::"Fixed Real Estate":
                if FieldNo = FixedRealEstate.FieldNo("OD Hierarchy Sort Key") then begin
                    IsHandled := true;
                    IsExcluded := true;
                end;
            Database::"Lease Contract":
                if FieldNo = LeaseContract.FieldNo("Preferred Bank Account Code") then begin
                    IsHandled := true;
                    IsExcluded := true;
                end;
            Database::"Lease Contract Line":
                if FieldNo = LeaseContractLine.FieldNo("Dimension Set ID") then begin
                    IsHandled := true;
                    IsExcluded := true;
                end;
            Database::"OD AM Lease Contract Unit":
                if FieldNo in [LeaseContractUnit.FieldNo(Active), LeaseContractUnit.FieldNo("Annual Rent")] then begin
                    IsHandled := true;
                    IsExcluded := true;
                end;
        end;
    end;

    local procedure RegisterAssetTables(var DeploymentPackageMgt: Codeunit "OD Deployment Package Mgt.")
    begin
        DeploymentPackageMgt.AddDeploymentTable(
            'OD-05-ACTIVOS',
            100,
            Database::"Type Fixed Real Estate",
            Enum::"OD Deploy Table Class."::Master,
            Enum::"OD Deployment Table Origin"::OneData,
            true,
            'Maestro de tipos de activos inmobiliarios utilizado por Fixed Real Estate.',
            'Debe existir antes de importar los inmuebles.');

        DeploymentPackageMgt.AddDeploymentTable(
            'OD-05-ACTIVOS',
            110,
            Database::"Street Type",
            Enum::"OD Deploy Table Class."::Master,
            Enum::"OD Deployment Table Origin"::OneData,
            true,
            'Maestro de tipos de via utilizado por las direcciones inmobiliarias.',
            'Se usa en Fixed Real Estate y Lease Contract.');

        DeploymentPackageMgt.AddDeploymentTable(
            'OD-05-ACTIVOS',
            120,
            Database::"Types Street Numbering",
            Enum::"OD Deploy Table Class."::Master,
            Enum::"OD Deployment Table Origin"::OneData,
            true,
            'Maestro complementario para la numeracion estructurada de direcciones.',
            'Debe existir antes de activos y contratos.');

        DeploymentPackageMgt.AddDeploymentTable(
            'OD-05-ACTIVOS',
            130,
            Database::"Estancia",
            Enum::"OD Deploy Table Class."::Master,
            Enum::"OD Deployment Table Origin"::OneData,
            true,
            'Catalogo de estancias utilizado por el equipamiento del inmueble.',
            'Dependencia directa de FRE Equipment.');

        DeploymentPackageMgt.AddDeploymentTable(
            'OD-05-ACTIVOS',
            140,
            Database::"FRE Attribute",
            Enum::"OD Deploy Table Class."::Master,
            Enum::"OD Deployment Table Origin"::OneData,
            true,
            'Definicion de atributos inmobiliarios.',
            'Base para valores, traducciones y mapeos de atributos.');

        DeploymentPackageMgt.AddDeploymentTable(
            'OD-05-ACTIVOS',
            150,
            Database::"FRE Attribute Value",
            Enum::"OD Deploy Table Class."::Master,
            Enum::"OD Deployment Table Origin"::OneData,
            true,
            'Valores permitidos de los atributos inmobiliarios.',
            'Depende del maestro de atributos.');

        DeploymentPackageMgt.AddDeploymentTable(
            'OD-05-ACTIVOS',
            160,
            Database::"FRE Attr. Value Translation",
            Enum::"OD Deploy Table Class."::Master,
            Enum::"OD Deployment Table Origin"::OneData,
            true,
            'Traducciones de los valores de atributo.',
            'Depende de FRE Attribute Value.');

        DeploymentPackageMgt.AddDeploymentTable(
            'OD-05-ACTIVOS',
            170,
            Database::"FRE Attribute Translation",
            Enum::"OD Deploy Table Class."::Master,
            Enum::"OD Deployment Table Origin"::OneData,
            true,
            'Traducciones de los atributos inmobiliarios.',
            'Depende de FRE Attribute.');

        DeploymentPackageMgt.AddDeploymentTable(
            'OD-05-ACTIVOS',
            180,
            Database::"REF Income & Expense Template",
            Enum::"OD Deploy Table Class."::Setup,
            Enum::"OD Deployment Table Origin"::OneData,
            true,
            'Plantillas economicas utilizadas por la configuracion inmobiliaria.',
            'REF Setup depende de estas plantillas.');

        DeploymentPackageMgt.AddDeploymentTable(
            'OD-05-ACTIVOS',
            190,
            Database::"FRE Jnl. Template",
            Enum::"OD Deploy Table Class."::Setup,
            Enum::"OD Deployment Table Origin"::OneData,
            true,
            'Plantillas de diario inmobiliario.',
            'Dependencia de la configuracion REF y de los lotes.');

        DeploymentPackageMgt.AddDeploymentTable(
            'OD-05-ACTIVOS',
            200,
            Database::"FRE Jnl. Batch",
            Enum::"OD Deploy Table Class."::Setup,
            Enum::"OD Deployment Table Origin"::OneData,
            true,
            'Lotes de diario inmobiliario.',
            'Depende de FRE Jnl. Template.');

        DeploymentPackageMgt.AddDeploymentTable(
            'OD-05-ACTIVOS',
            210,
            Database::"REF Setup",
            Enum::"OD Deploy Table Class."::Setup,
            Enum::"OD Deployment Table Origin"::OneData,
            true,
            'Configuracion principal del modulo inmobiliario.',
            'Debe aplicarse despues de los maestros y setup referenciados.');

        DeploymentPackageMgt.AddDeploymentTable(
            'OD-05-ACTIVOS',
            300,
            Database::"Fixed Real Estate",
            Enum::"OD Deploy Table Class."::Master,
            Enum::"OD Deployment Table Origin"::OneData,
            true,
            'Maestro unico de propiedades, activos y unidades inmobiliarias.',
            'Incluye jerarquia Property/Asset mediante campos persistentes de Property Management.');

        DeploymentPackageMgt.AddDeploymentTable(
            'OD-05-ACTIVOS',
            400,
            Database::"REF Income & Expense Lines",
            Enum::"OD Deploy Table Class."::Master,
            Enum::"OD Deployment Table Origin"::OneData,
            true,
            'Configuracion economica especifica de cada inmueble.',
            'Depende de Fixed Real Estate y G/L Account.');

        DeploymentPackageMgt.AddDeploymentTable(
            'OD-05-ACTIVOS',
            410,
            Database::"FRE Superficies",
            Enum::"OD Deploy Table Class."::Master,
            Enum::"OD Deployment Table Origin"::OneData,
            true,
            'Detalle estructural de superficies del activo.',
            'Depende del inmueble principal.');

        DeploymentPackageMgt.AddDeploymentTable(
            'OD-05-ACTIVOS',
            420,
            Database::"FRE Equipment",
            Enum::"OD Deploy Table Class."::Master,
            Enum::"OD Deployment Table Origin"::OneData,
            true,
            'Equipamiento asociado al inmueble.',
            'Depende de Fixed Real Estate y Estancia.');

        DeploymentPackageMgt.AddDeploymentTable(
            'OD-05-ACTIVOS',
            430,
            Database::"FRE Attribute Value Mapping",
            Enum::"OD Deploy Table Class."::Master,
            Enum::"OD Deployment Table Origin"::OneData,
            true,
            'Asignacion efectiva de atributos y valores a cada activo.',
            'Depende de atributos, valores y del registro maestro mapeado.');

        DeploymentPackageMgt.AddDeploymentTable(
            'OD-05-ACTIVOS',
            440,
            Database::"OD RE FA Link",
            Enum::"OD Deploy Table Class."::Master,
            Enum::"OD Deployment Table Origin"::OneData,
            true,
            'Relacion funcional entre inmueble y activo fijo.',
            'Depende de Fixed Real Estate y Fixed Asset.');
    end;

    local procedure RegisterContractTables(var DeploymentPackageMgt: Codeunit "OD Deployment Package Mgt.")
    begin
        DeploymentPackageMgt.AddDeploymentTable(
            'OD-07-CONTRATOS',
            100,
            Database::"Consumer Price Index Categorie",
            Enum::"OD Deploy Table Class."::Master,
            Enum::"OD Deployment Table Origin"::OneData,
            true,
            'Maestro de categorias IPC referenciado por contratos y lineas.',
            'Debe existir antes de importar contratos.');

        DeploymentPackageMgt.AddDeploymentTable(
            'OD-07-CONTRATOS',
            110,
            Database::"Consumer Price Index",
            Enum::"OD Deploy Table Class."::Master,
            Enum::"OD Deployment Table Origin"::OneData,
            true,
            'Datos IPC utilizados en revisiones de renta.',
            'Depende de Consumer Price Index Categorie.');

        DeploymentPackageMgt.AddDeploymentTable(
            'OD-07-CONTRATOS',
            300,
            Database::"Lease Contract",
            Enum::"OD Deploy Table Class."::Document,
            Enum::"OD Deployment Table Origin"::OneData,
            true,
            'Contrato real necesario para Go-Live.',
            'Incluye campos persistentes de Property Management sobre el contrato.');

        DeploymentPackageMgt.AddDeploymentTable(
            'OD-07-CONTRATOS',
            400,
            Database::"Lease Bank Account",
            Enum::"OD Deploy Table Class."::Document,
            Enum::"OD Deployment Table Origin"::OneData,
            false,
            'Cuentas bancarias especificas del contrato cuando el cliente las utiliza.',
            'Existe dependencia circular con Lease Contract y requiere prueba funcional especifica.');

        DeploymentPackageMgt.AddDeploymentTable(
            'OD-07-CONTRATOS',
            500,
            Database::"Lease Contract Line",
            Enum::"OD Deploy Table Class."::Document,
            Enum::"OD Deployment Table Origin"::OneData,
            true,
            'Lineas economicas necesarias para reconstruir contratos vigentes.',
            'Depende de la cabecera de contrato y de maestros contables previos.');

        DeploymentPackageMgt.AddDeploymentTable(
            'OD-07-CONTRATOS',
            600,
            Database::"OD AM Lease Contract Unit",
            Enum::"OD Deploy Table Class."::Document,
            Enum::"OD Deployment Table Origin"::OneData,
            true,
            'Relacion multi-activo y unidad contractual necesaria para reconstruir contratos.',
            'Debe aplicarse despues de Lease Contract y de Fixed Real Estate.');

        DeploymentPackageMgt.AddDeploymentTable(
            'OD-07-CONTRATOS',
            700,
            Database::"Rental Deposit",
            Enum::"OD Deploy Table Class."::Document,
            Enum::"OD Deployment Table Origin"::OneData,
            true,
            'Fianza asociada al contrato vigente.',
            'Forma parte del estado economico operativo del contrato.');

        DeploymentPackageMgt.AddDeploymentTable(
            'OD-07-CONTRATOS',
            710,
            Database::"Tax Amount Line",
            Enum::"OD Deploy Table Class."::Document,
            Enum::"OD Deployment Table Origin"::OneData,
            false,
            'Detalle fiscal asociado a lineas contractuales cuando la funcionalidad esta en uso.',
            'Tabla opcional hasta confirmar uso funcional en cliente.');

        DeploymentPackageMgt.AddDeploymentTable(
            'OD-07-CONTRATOS',
            800,
            Database::"Lease Comment Line",
            Enum::"OD Deploy Table Class."::Document,
            Enum::"OD Deployment Table Origin"::OneData,
            false,
            'Comentarios complementarios del contrato.',
            'Se mantiene opcional para no cargar informacion no critica en el Go-Live.');

        DeploymentPackageMgt.AddDeploymentTable(
            'OD-07-CONTRATOS',
            900,
            Database::"REF Related Contactos",
            Enum::"OD Deploy Table Class."::Master,
            Enum::"OD Deployment Table Origin"::OneData,
            true,
            'Relacion persistente entre contactos y entidades inmobiliarias.',
            'Debe importarse al final para que contratos y activos ya existan.');
    end;
}
