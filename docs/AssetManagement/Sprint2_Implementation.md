# Sprint 2 Implementation

## Objetivo

Sprint 2 integra `Asset Management` con contratos de alquiler para permitir multiples activos por contrato sin romper el comportamiento actual de `Lease Contract`.

## Arquitectura

Relaciones funcionales:

`Property -> Asset -> Contract Unit -> Lease Contract`

Puntos clave:

- `Fixed Real Estate` sigue siendo la fuente maestra.
- `Lease Contract."Fixed Real Estate No."` se mantiene como activo principal legacy.
- `Lease Contract."FRE Property No."` se mantiene como propiedad raiz.
- `OD AM Lease Contract Unit` anade activos adicionales y accesorios.

## Objetos creados

| Type | ID | Name |
| ---- | -: | ---- |
| Enum | 96945 | OD Contract Unit Role |
| Table | 96946 | OD AM Lease Contract Unit |
| Codeunit | 96947 | OD AM Contract Asset Mgt. |
| Page | 96948 | OD AM Lease Contract Units |
| Page | 96949 | OD AM Contract Asset FactBox |
| Page | 96964 | OD AM Lease Contract Card |
| Page | 96965 | OD AM Lease Contract List |
| TableExtension | 96966 | OD AM Lease Contract Ext |
| Codeunit | 96967 | OD AM Contract Unit Upgrade |
| PageExtension | 96968 | OD AM Asset Struct Contracts |

## Objetos extendidos

- `table 96018 "Lease Contract"` mediante `OD AM Lease Contract Ext`
- `page 96940 "OD AM Asset Structure"` mediante `OD AM Asset Struct Contracts`
- permission set extensions de Sprint 1 para incluir los nuevos objetos

## Reglas de sincronizacion

- el contrato solo puede tener un activo `Principal`,
- la linea `Principal` debe coincidir con `Lease Contract."Fixed Real Estate No."`,
- al insertar o modificar el contrato se sincroniza la linea principal cuando procede,
- si cambia la `Property` del principal y existen activos incompatibles, se genera error,
- no se borran silenciosamente activos adicionales o accesorios.

## Compatibilidad legacy

- contratos existentes siguen funcionando aunque no tengan unidades contractuales,
- `OD AM Contract Unit Upgrade` puede crear la linea principal faltante a partir del contrato actual,
- la lista y ficha clasicas de `Lease Contract` no se sustituyen,
- la facturacion sigue utilizando solo el activo principal legacy.

## Vistas funcionales nuevas

- `OD AM Lease Contract List`: lista alternativa con contador de activos,
- `OD AM Lease Contract Card`: vista del contrato orientada a Asset Management,
- `OD AM Lease Contract Units`: subpage para activos del contrato,
- `OD AM Contract Asset FactBox`: resumen del contrato multi-activo.

Ademas:

- `OD AM Asset Structure` incorpora la accion `Ver contratos`.

## Validaciones implementadas

- no permitir `Type = Propiedad` como unidad contractual,
- no permitir un segundo `Principal`,
- no permitir duplicados simples del mismo activo dentro del mismo contrato,
- no permitir activos de distinta `Property No.` dentro del mismo contrato,
- no permitir activos adicionales si el contrato no tiene principal legacy informado.

## Pruebas previstas

Escenarios objetivo del sprint:

1. contrato legacy con un solo activo principal y migracion de unidad principal,
2. vivienda principal con parking accesorio,
3. dos habitaciones dentro de la misma propiedad,
4. intento de alta de activo de otra propiedad,
5. intento de crear dos principales,
6. intento de duplicar el mismo activo,
7. cambio de activo principal con adicionales incompatibles.

## Pruebas realizadas

En esta iteracion se ha realizado revision estructural y validacion por lectura del codigo.

No se ha ejecutado todavia una prueba funcional completa en Business Central ni una compilacion final automatizada dentro de este turno.

## Limitaciones actuales

- no se implementa todavia ocupacion ni control de solapamientos por fecha,
- `Monthly Rent` en `OD AM Lease Contract Unit` es informativo,
- no se modifica `Lease Contract Line`,
- no se modifica facturacion ni posting,
- no se modifica `Financial Flow`.

## Preparacion Sprint 3

La estructura resultante deja preparada la siguiente fase:

- reglas de ocupacion,
- disponibilidad por fechas,
- vivienda completa frente a habitaciones,
- solapamientos y estados de ocupacion parciales.
