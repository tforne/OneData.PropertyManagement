# OneData Asset Management

## Sprint 1 - Core & Structure

Sprint 1 introduce una vista paralela de Asset Management sobre la misma tabla maestra `Fixed Real Estate`.

### Arquitectura

- La tabla maestra sigue siendo `table 96000 "Fixed Real Estate"`.
- `Property No.` continua identificando la propiedad raiz.
- La nueva jerarquia se completa con `OD Parent FRE No.` para soportar `Property -> Asset -> Child Asset`.

### Objetos

- Enum `OD Asset Type`
- TableExtension `OD AM Fixed Real Estate Ext`
- Codeunit `OD AM Asset Structure Mgt.`
- Tabla temporal `OD AM Asset Structure Buffer`
- Paginas `OD AM Asset Structure`, `OD AM Asset List`, `OD AM Property Asset FactBox`, `OD AM New Asset`

### Uso

- `OD AM Asset Structure` permite filtrar por propiedad y navegar la estructura jerarquica.
- `OD AM Asset List` ofrece una lista moderna editable de activos.
- Las acciones crean viviendas, habitaciones, parkings, trasteros y activos genericos.

### Compatibilidad

- No sustituye `Fixed Real Estate List` ni `Fixed Real Estate Card`.
- No modifica contratos, facturacion, Financial Flow, Active Valuation ni Fixed Asset Integration.
- Los activos existentes siguen siendo validos con `OD Asset Type = Undefined` y `OD Parent FRE No. = blank`.

### Limitaciones

- La jerarquia se representa por indentacion visual, sin arbol expandible nativo.
- La ficha clasica sigue siendo la referencia principal; Sprint 1 no introduce una card nueva para Asset Management.

## Sprint 2 - Contract Assets

Sprint 2 integra `Asset Management` con contratos de alquiler para soportar multiples activos por contrato sin romper el comportamiento actual de `Lease Contract`.

### Objetivo

- mantener `Lease Contract."Fixed Real Estate No."` como activo principal legacy,
- permitir activos adicionales y accesorios por contrato,
- conservar facturacion, Financial Flow y modulos economicos sin cambios.

### Objetos

- Enum `OD Contract Unit Role`
- Table `OD AM Lease Contract Unit`
- Codeunit `OD AM Contract Asset Mgt.`
- Codeunit `OD AM Contract Unit Upgrade`
- TableExtension `OD AM Lease Contract Ext`
- Paginas `OD AM Lease Contract Units`, `OD AM Contract Asset FactBox`, `OD AM Lease Contract Card`, `OD AM Lease Contract List`
- PageExtension `OD AM Asset Struct Contracts`

### Reglas principales

- el contrato solo puede tener un activo `Principal`,
- el principal debe coincidir con `Lease Contract."Fixed Real Estate No."`,
- todos los activos del contrato deben pertenecer a la misma `Property No.`,
- no se permiten duplicados simples del mismo activo en el mismo contrato.

### Compatibilidad

- la lista y ficha clasicas de `Lease Contract` continúan operativas,
- la facturacion sigue utilizando el activo principal legacy,
- `Financial Flow`, `Active Valuation`, `OneData Fiscal` y `Fixed Asset Integration` no se modifican.

### Limitaciones actuales

- no se implementa todavia ocupacion ni solapamientos por fechas,
- `Monthly Rent` en unidades contractuales es solo informativo,
- no se modifica `Lease Contract Line`.

## Sprint 3 - Occupancy & Availability

Sprint 3 completa la capa operativa de disponibilidad para evitar solapamientos entre contratos y ofrecer visibilidad de ocupacion por propiedad y por activo.

### Objetivo

- validar disponibilidad por fechas,
- bloquear conflictos directos y jerarquicos,
- distinguir vivienda completa frente a habitaciones u otros descendientes,
- exponer vistas de ocupacion y busqueda de activos disponibles.

### Objetos

- Enum `OD AM Occupancy Status`
- Table `OD AM Occupancy Buffer`
- Codeunit `OD AM Occupancy Mgt.`
- Paginas `OD AM Occupancy View`, `OD AM Asset Availability`

### Reglas principales

- un activo no puede solaparse con otro contrato en el mismo periodo,
- un hijo no puede alquilarse si su padre esta ocupado,
- un padre no puede alquilarse si un descendiente ya esta ocupado,
- los activos agregados pueden mostrarse como `PartiallyOccupied`,
- la ficha de contrato puede validar disponibilidad del conjunto de unidades.

### Compatibilidad

- la facturacion y `Lease Contract Line` siguen sin cambios,
- el activo principal legacy sigue siendo la referencia economica,
- la nueva capa se apoya en `OD AM Lease Contract Unit` y no rompe contratos existentes.

### Limitaciones actuales

- no hay calendario visual ni planificacion avanzada,
- `Reserved` no tiene logica especifica aun,
- el porcentaje de ocupacion no pondera por superficie ni renta.
