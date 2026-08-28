# Sprint 3 Implementation

## Objetivo

Sprint 3 incorpora reglas de ocupacion y disponibilidad sobre la base multi-activo creada en Sprint 2 para evitar solapamientos contractuales y ofrecer una vista operativa del estado de los activos.

## Alcance funcional

- validar conflictos por fechas al asignar activos a contratos,
- impedir solapamientos directos sobre el mismo activo,
- impedir alquilar una vivienda completa si una unidad hija ya esta ocupada,
- impedir alquilar una unidad hija si su activo padre ya esta ocupado,
- calcular estados de ocupacion `Disponible`, `Ocupado`, `Parcialmente ocupado`, `Bloqueado` e `Inactivo`,
- ofrecer consulta visual de ocupacion por propiedad y busqueda de activos disponibles por periodo.

## Arquitectura

Relaciones funcionales:

`Property -> Asset -> Contract Unit -> Lease Contract -> Occupancy`

Puntos clave:

- `OD AM Lease Contract Unit` sigue siendo la fuente contractual de ocupacion.
- `OD AM Occupancy Mgt.` centraliza validaciones, deteccion de conflictos y calculo de estados.
- la jerarquia `OD Parent FRE No.` se reutiliza para propagar reglas entre padre e hijos.
- no se modifica la logica economica de `Lease Contract Line`, facturacion ni posting.

## Objetos creados

| Type | ID | Name |
| ---- | -: | ---- |
| Enum | 96969 | OD AM Occupancy Status |
| Table | 96975 | OD AM Occupancy Buffer |
| Codeunit | 96976 | OD AM Occupancy Mgt. |
| Page | 96977 | OD AM Occupancy View |
| Page | 96978 | OD AM Asset Availability |

## Objetos extendidos o integrados

- `table 96946 "OD AM Lease Contract Unit"` valida periodos y disponibilidad,
- `codeunit 96947 "OD AM Contract Asset Mgt."` valida conflictos de ocupacion al insertar o modificar unidades,
- `page 96964 "OD AM Lease Contract Card"` muestra indicadores y accion de validacion de disponibilidad,
- `pageextension 96968 "OD AM Asset Struct Contracts"` anade acceso a disponibilidad desde la estructura de activos,
- permission set extensions de Sprint 1 y Sprint 2 incorporan los objetos de ocupacion.

## Reglas implementadas

- no se permite una fecha fin anterior a la fecha inicio,
- no se permiten solapamientos del mismo activo en contratos distintos,
- no se permite ocupar un activo hijo si un padre jerarquico esta alquilado en el mismo periodo,
- no se permite ocupar un activo padre si alguna unidad descendiente esta alquilada en el mismo periodo,
- los conflictos ignoran la misma linea contractual durante su propia validacion,
- la ocupacion administrativa puede devolverse como `Bloqueado` o `Inactivo` segun el estado del activo.

## Vistas funcionales nuevas

- `OD AM Occupancy View`: estructura de una propiedad con estado de ocupacion, contrato actual y porcentaje,
- `OD AM Asset Availability`: consulta de activos disponibles por propiedad, tipo y rango de fechas,
- `OD AM Lease Contract Card`: accion `Validar disponibilidad` e indicadores de activos ocupados,
- `OD AM Asset Structure`: accion `Ver disponibilidad`.

## Estados de ocupacion

- `Disponible`: sin conflicto directo ni jerarquico en la fecha consultada,
- `Ocupado`: existe conflicto directo o por activo padre,
- `Parcialmente ocupado`: el activo agregado tiene descendientes hoja y solo una parte esta ocupada,
- `Bloqueado`: el estado administrativo del activo lo marca como no alquilable,
- `Inactivo`: el estado administrativo del activo indica baja o inactividad,
- `Sin determinar`: no se pudo resolver un estado mas preciso.

## Compatibilidad

- `Lease Contract."Fixed Real Estate No."` sigue siendo el principal legacy,
- la facturacion continua trabajando con el activo principal legacy,
- no se modifica `Lease Contract Line`,
- no se modifica `Financial Flow`,
- no se modifica `Active Valuation`,
- no se sustituye la ficha clasica de inmuebles ni la ficha clasica de contratos.

## Pruebas objetivo del sprint

1. contrato A ocupa una vivienda completa y contrato B intenta alquilar una habitacion hija en fechas solapadas,
2. contrato A ocupa una habitacion y contrato B intenta alquilar la vivienda padre en fechas solapadas,
3. dos contratos intentan alquilar el mismo parking en fechas coincidentes,
4. una propiedad con habitaciones parcialmente ocupadas devuelve estado `Parcialmente ocupado`,
5. una busqueda de disponibilidad excluye activos bloqueados por conflictos jerarquicos o directos,
6. la validacion del contrato identifica el primer conflicto y devuelve contrato y fechas bloqueantes.

## Pruebas realizadas

En esta iteracion se ha realizado validacion estructural por lectura de codigo y alineacion documental del sprint.

No se ha ejecutado una prueba funcional completa en Business Central dentro de este turno.

## Limitaciones actuales

- `Reserved` queda disponible en el enum pero no se explota todavia con logica propia,
- el porcentaje de ocupacion se basa en descendientes hoja y no en superficie ni renta,
- la deteccion administrativa de `Bloqueado` e `Inactivo` depende del texto del estado actual del activo,
- no se introduce todavia planning operativo, reservas futuras ni calendario visual.
