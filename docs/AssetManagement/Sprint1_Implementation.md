# Sprint 1 Implementation

## Objects Created

- Enum `OD Asset Type`
- Codeunit `OD AM Asset Structure Mgt.`
- Tables `OD AM Asset Structure Buffer`, `OD AM Asset Create Req.`
- Pages `OD AM Asset Structure`, `OD AM Asset List`, `OD AM Property Asset FactBox`, `OD AM New Asset`
- Permission set extensions for `ODPM ADMIN`, `ODPM READ`, `ODPM SETUP`, `ODPM USER`

## Objects Extended

- `table 96000 "Fixed Real Estate"` mediante `OD AM Fixed Real Estate Ext`

## Fields Added

- `OD Asset Type` (Enum `OD Asset Type`)
- `OD Parent FRE No.` (Code[20])

## Business Rules

- Un activo no puede ser padre de si mismo.
- El padre debe pertenecer a la misma propiedad raiz.
- No se permiten ciclos en la jerarquia.
- Una propiedad no puede tener padre.
- `Property No.` se mantiene como identificador de la propiedad raiz.

## Hierarchy Rules

- Nivel 0: propiedad
- Nivel 1: activo hijo directo de la propiedad
- Nivel 2+: activo descendiente de otro activo
- Los activos legacy con `OD Parent FRE No.` en blanco siguen visibles bajo la propiedad raiz.

## User Interface

- `OD AM Asset Structure` muestra la jerarquia con indentacion visual.
- `OD AM Asset List` muestra la alternativa moderna de consulta y mantenimiento.
- `OD AM Property Asset FactBox` resume conteos por tipo.
- `OD AM New Asset` permite elegir el tipo al crear activos genericos.

## Functional Test

- Preparado para verificar el escenario `PROP-001 -> VIV-001 -> HAB-001/HAB-002/HAB-003`, junto con `VIV-002`, `GAR-001` y `GAR-002`.
- Las acciones de creacion usan la misma tabla maestra y mantienen `Property No.` en la raiz.

## Compatibility Test

- El diseno preserva `Fixed Real Estate List` y `Fixed Real Estate Card`.
- No se han tocado `Lease Contract`, `Real Estate Management`, `FinancialFlow` ni `Active Valuation`.
- Los activos existentes con campos nuevos en blanco siguen siendo validos.

## Compilation Result

- Compilacion completa de la extension ejecutada correctamente con `alc.exe`.
- No han quedado errores de compilacion en los objetos nuevos de Asset Management ni en el resto del proyecto.

## Known Limitations

- La visualizacion usa indentacion, no nodos expandibles.
- La ficha clasica no muestra aun los campos nuevos.
- La accion `Nuevo activo` usa un dialogo simple con tabla temporal.

## Asset Structure Direct Navigation Fix

- `OD AM Asset Structure` ya no depende de recibir previamente un `Property No.` para mostrar informacion.
- Cuando la pagina se abre directamente desde Buscar con el filtro vacio, reconstruye el buffer con todas las propiedades `Type = Propiedad`.
- El filtro `Property No.` pasa a ser opcional: con valor muestra una unica propiedad; vacio muestra vista global.
- La compatibilidad legacy se mantiene: activos con `OD Parent FRE No. = ''` siguen apareciendo como hijos directos de su `Property No.` raiz.
- `OD AM Property Asset FactBox` soporta tanto conteo por propiedad como conteo global de todas las propiedades.

## Sprint 2 Preparation

- La estructura padre/hijo ya esta centralizada en `OD AM Asset Structure Mgt.`.
- La raiz contractual puede seguir dependiendo de `Property No.` mientras Sprint 2 introduce integracion con contratos y unidades.
