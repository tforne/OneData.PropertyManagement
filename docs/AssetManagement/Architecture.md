# Asset Management Architecture

## Objetivo

`OneData Asset Management` crea una segunda vista funcional sobre `table 96000 "Fixed Real Estate"` para representar estructuras `Property -> Asset -> Child Asset` sin romper la vista clasica existente.

`OD AM Asset Structure` soporta dos modos de entrada:

- vista filtrada por `Property No.` cuando otra pagina pasa una propiedad concreta,
- vista global cuando se abre directamente desde Buscar y el filtro de propiedad queda vacio.

## Convivencia con la vista clasica

- `Fixed Real Estate List` y `Fixed Real Estate Card` permanecen sin cambios funcionales.
- Asset Management no reemplaza contratos, facturacion, Financial Flow, Active Valuation ni OneData Fiscal.
- La nueva capa solo anade clasificacion y jerarquia sobre los registros ya existentes.

## Uso de table 96000

- La fuente maestra sigue siendo `table 96000 "Fixed Real Estate"`.
- `Type` sigue diferenciando `Propiedad` y `Activo`.
- `Property No.` sigue apuntando siempre a la propiedad raiz.
- `OD Parent FRE No.` complementa `Property No.` para soportar descendencia adicional.
- si `OD Parent FRE No.` esta vacio en un activo legacy, `Property No.` sigue permitiendo mostrarlo como hijo directo de la propiedad raiz.

## Campos anadidos

- `OD Asset Type`: enum extensible para clasificar activos.
- `OD Parent FRE No.`: referencia al padre jerarquico dentro de la misma tabla.

## Objetos nuevos

- Enum `OD Asset Type`
- TableExtension `OD AM Fixed Real Estate Ext`
- Codeunit `OD AM Asset Structure Mgt.`
- Tabla temporal `OD AM Asset Structure Buffer`
- Paginas `OD AM Asset Structure`, `OD AM Asset List`, `OD AM Property Asset FactBox`, `OD AM New Asset`
- PermissionSetExtensions `OD AM Admin Ext`, `OD AM Read Ext`, `OD AM Setup Ext`, `OD AM User Ext`

## Arquitectura contractual de Sprint 2

Sprint 2 anade una capa contractual multi-activo sin cambiar la fuente maestra de inmuebles ni el significado del contrato clasico.

Relaciones conceptuales:

`Property -> Asset -> Contract Unit -> Lease Contract`

### Principios

- `Lease Contract."Fixed Real Estate No."` sigue siendo el activo principal del contrato.
- `Lease Contract."FRE Property No."` sigue siendo la propiedad raiz.
- `OD AM Lease Contract Unit` anade activos adicionales y accesorios sin tocar la logica economica actual.

### Objetos nuevos de Sprint 2

- Enum `OD Contract Unit Role`
- Table `OD AM Lease Contract Unit`
- Codeunit `OD AM Contract Asset Mgt.`
- Codeunit `OD AM Contract Unit Upgrade`
- TableExtension `OD AM Lease Contract Ext`
- Page `OD AM Lease Contract Units`
- Page `OD AM Contract Asset FactBox`
- Page `OD AM Lease Contract Card`
- Page `OD AM Lease Contract List`
- PageExtension `OD AM Asset Struct Contracts`

### Regla de compatibilidad

Mientras `Lease Contract."Fixed Real Estate No."` tenga valor, debe existir exactamente una linea contractual principal con el mismo activo.

### Alcance actual

- se soportan multiples activos por contrato dentro de la misma propiedad,
- no se toca todavia facturacion,
- no se toca todavia Financial Flow,
- Sprint 3 completa la capa de ocupacion, disponibilidad y control de solapamientos.

## Arquitectura de ocupacion de Sprint 3

Sprint 3 reutiliza la jerarquia de activos y la capa contractual multi-activo para proyectar disponibilidad operativa.

Relaciones conceptuales:

`Property -> Asset -> Contract Unit -> Occupancy`

### Objetos nuevos de Sprint 3

- Enum `OD AM Occupancy Status`
- Table `OD AM Occupancy Buffer`
- Codeunit `OD AM Occupancy Mgt.`
- Page `OD AM Occupancy View`
- Page `OD AM Asset Availability`

### Principios

- la ocupacion se calcula desde `OD AM Lease Contract Unit`,
- las validaciones consideran conflictos directos, con padres y con hijos,
- los activos agregados pueden devolver estado `PartiallyOccupied`,
- la validacion de disponibilidad no altera la logica economica del contrato.

### Alcance actual

- se soporta consulta de ocupacion por propiedad,
- se soporta busqueda de activos disponibles por rango de fechas,
- se soporta validacion preventiva de conflictos desde el contrato,
- no se modifica todavia la planificacion avanzada ni las reservas futuras.

## Limitaciones de Sprint 1

- La visualizacion jerarquica usa indentacion visual, no control tree nativo.
- La relacion padre-hijo nacio para estructura y navegacion; Sprint 3 la amplia con reglas de ocupacion y solapamientos.
- No se modifica la ficha clasica ni la logica contractual/economica.

## Preparacion para Sprint 2

- La jerarquia ya diferencia propiedad raiz y activos descendientes.
- Los contratos podran integrarse posteriormente sin cambiar la tabla maestra.
- La clasificacion extensible deja preparada la evolucion hacia unidades alquilables y reglas de ocupacion.

## Evolucion posterior a Sprint 3

- extender el estado `Reserved` para precontratos o bloqueos operativos,
- anadir calendarios visuales y planificacion avanzada,
- estudiar porcentajes de ocupacion ponderados por superficie, renta o capacidad.
