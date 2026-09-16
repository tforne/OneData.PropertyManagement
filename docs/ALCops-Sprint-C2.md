# ALCops Sprint C.2 - Correcciones recomendadas

Fecha: 2026-09-04.

## 1. Baseline

Se compiló con AL Compiler `17.0.34.45391`, ALCops `1.1.0`,
ApplicationCop, LinterCop y PlatformCop. Los cambios autorizados de C.1 se
mantuvieron sin reinterpretarlos.

| Métrica | Baseline |
| --- | ---: |
| AL errors | 0 |
| Información | 3.091 |
| Warnings | 3.671 |
| Total diagnósticos | 6.762 |
| APP generada | Sí |

Objetivos verificados antes de editar: `PC0001=27`, `PC0027=2` y `PC0034=1`.

## 2. PC0001 - FlowFields

Mensaje exacto de PlatformCop: `Field '<campo>' is editable, which is uncommon
for a FlowField. Set Editable = false, or add a comment to justify why editing
is intentional.`

### Inventario

| Grupo | Archivo / objeto | ID | Tabla / campo FlowField | CalcFormula y dependencia |
| --- | --- | ---: | --- | --- |
| PC0001-A | `Table 96006 - REF Related Contactos.al` | 96006 | `Post Code` | `Lookup(Contact."Post Code" WHERE ("No."=FIELD("Contact No.")))`; Contact por `Contact No.` |
| PC0001-B | `Table 96007 - RE Owner Cue.al` | 96007 | `Released Sales Quotes`, `Open Sales Orders`, `Released Sales Orders`, `Shipped Not Invoiced`, `Sales Invoices`, `Sales Quotes` | `Count("Sales Header" ...)`; tipo, estado y filtros de venta |
| PC0001-B | mismo archivo | 96007 | `Released Purchase Orders`, `Purchase Invoices` | `Count("Purchase Header" ...)`; tipo y estado de compra |
| PC0001-B | mismo archivo | 96007 | `Overdue Sales Documents` | `Count("Cust. Ledger Entry" ...)`; documento, vencimiento y abierto |
| PC0001-B | mismo archivo | 96007 | `Customers - Blocked`, `Vendors - Payment on Hold` | `Count(Customer/Vendor ...)`; estado de bloqueo |
| PC0001-B | mismo archivo | 96007 | `Purchase Documents Due Today` | `Count("Vendor Ledger Entry" ...)`; vencimiento, tipo y abierto |
| PC0001-B | mismo archivo | 96007 | `Unpaid Sales Invoices`, `Overdue Sales Invoices` | `Count("Sales Invoice Header" ...)`; cerrado y vencimiento |
| PC0001-B | mismo archivo | 96007 | `Unpaid Purchase Invoices`, `Overdue Purchase Invoices` | `Count("Purch. Inv. Header" ...)`; cerrado y vencimiento |
| PC0001-B | mismo archivo | 96007 | `Pending Tasks` | `Count("User Task" ...)`; usuario y porcentaje completado |
| PC0001-B | mismo archivo | 96007 | `Lease Contract Expired` | `Count("Lease Contract" ...)`; estado y filtro de vencimiento |
| PC0001-B | mismo archivo | 96007 | `Receivable Documents`, `Payable Documents` | `Count("Cartera Doc." ...)`; tipo y grupo/orden de pago |
| PC0001-B | mismo archivo | 96007 | `Posted Receivable Documents`, `Posted Payable Documents` | `Count("Posted Cartera Doc." ...)`; tipo y grupo/orden de pago |
| PC0001-C | `Table 96011 - FRE Publicacions Register.al` | 96011 | `No. of Transfers` | `Count("Credit Transfer Entry" WHERE ("Credit Transfer Register No."=FIELD("No.")))`; registro de transferencia |
| PC0001-D | `Table 96167 - FRE Attribute Value.al` | 96167 | `Attribute Name` | `Lookup("FRE Attribute".Name WHERE (ID=FIELD("Attribute ID")))`; maestro de atributos |
| PC0001-E | `Table 96790 - OD RE FA Link.al` | 96790 | `Real Estate Description`, `FA Description` | `Lookup("Fixed Real Estate".Description ...)` y `Lookup("Fixed Asset".Description ...)`; claves de inmueble y activo fijo |

### Grupos

| Grupo | Casos | Patrón | Cambio aplicado | Impacto / riesgo |
| --- | ---: | --- | --- | --- |
| PC0001-A | 1 | Dato de presentación derivado de contacto | `Editable = false` | No cambia lookup, relación ni valor. Bajo. |
| PC0001-B | 22 | Cues calculados `Count` sin escritura | `Editable = false` | No cambia CalcFormula, FlowFilters ni drilldown. Bajo. |
| PC0001-C | 1 | Contador de transferencias derivado | `Editable = false` | No cambia registro ni conteo. Bajo. |
| PC0001-D | 1 | Nombre derivado de maestro | `Editable = false` | No cambia atributo ni su relación. Bajo. |
| PC0001-E | 2 | Descripciones derivadas de claves persistidas | `Editable = false` | No cambia las claves ni el proceso de enlace. Bajo. |

### Cambios

Se declararon explícitamente no editables los 27 FlowFields. No se modificaron
fórmulas, filtros, relaciones, IDs, claves, llamadas a `CalcFields` ni datos.

### Casos no corregidos

Ninguno. Los 27 casos coinciden con el análisis C.1 y son equivalentes desde
la perspectiva funcional.

## 3. PC0027 - Excel Buffer

Los dos casos pertenecían a Codeunit 96984 `OD FF Excel Export`, procedimiento
local `AddCell(var ExcelBuffer: Record "Excel Buffer" temporary; ...)`.

| Caso | Análisis | Clasificación | Cambio |
| --- | --- | --- | --- |
| `ExcelBuffer.Validate("Row No.", RowNo)` | El parámetro es `temporary`; cada celda ejecuta `Init()`, asigna coordenadas, valor e `Insert()`. El buffer solo se usa en `CreateNewBook`, `WriteSheet`, `CloseBook` y `OpenExcel`; no hay persistencia, `Get`, filtros o reutilización posterior. | CORREGIBLE | Asignación directa a `ExcelBuffer."Row No."`. |
| `ExcelBuffer.Validate("Column No.", ColNo)` | Mismo ciclo de vida y misma semántica de coordenada interna. No depende de triggers de validación para construir el libro. | CORREGIBLE | Asignación directa a `ExcelBuffer."Column No."`. |

La exportación mantiene las 16 columnas y el mismo orden de inserción. Se
requiere prueba Sandbox del fichero resultante.

## 4. PC0034

| Elemento | Resultado |
| --- | --- |
| Archivo / objeto | `Table 96018 - Lease Contract.al`, tabla 96018 |
| Procedimiento | Público `DisplayMap` |
| Mensaje exacto | `The format string contains 1 placeholder(s), but 0 argument(s) were provided.` |
| Causa | `MESSAGE(Text014)` usaba la etiqueta de confirmación `Do you want to change %1?` sin argumento. |
| Cambio | Nueva etiqueta `MapSetupMissingMsg`, sin placeholders, para el caso sin `Online Map Setup`. |
| Equivalencia | Se preserva la selección del mapa cuando existe configuración; solo se corrige el mensaje del camino sin configuración. |

## 5. Compilaciones

| Bloque | Resultado | AL errors | Total | APP |
| --- | --- | ---: | ---: | --- |
| Baseline | `PC0001=27`, `PC0027=2`, `PC0034=1` | 0 | 6.762 | Sí |
| 1 - PC0001 | 27 FlowFields eliminados | 0 | 6.735 | Sí |
| 2 - PC0027 | 2 casos eliminados | 0 | 6.733 | Sí |
| 3 - PC0034 | 1 caso eliminado | 0 | 6.733 | Sí |

## 6. Diagnósticos antes/después

| Regla | Antes | Después | Archivos modificados | Riesgo | Estado |
| ----- | ----: | ------: | -------------------: | ------ | ------ |
| PC0001 | 27 | 0 | 5 | Bajo | CORREGIDA |
| PC0027 | 2 | 0 | 1 | Medio | REQUIERE TEST SANDBOX |
| PC0034 | 1 | 0 | 1 | Bajo | REQUIERE TEST SANDBOX |

No se identificaron diagnósticos nuevos. El total disminuyó en 29, de 6.762 a
6.733; información permanece en 3.091 y warnings baja de 3.671 a 3.642.

## 7. Archivos modificados

Siete archivos AL:

- `.vscode/Tables/Tables/Table 96006 - REF Related Contactos.al`
- `.vscode/Tables/Tables/Table 96007 - RE Owner Cue.al`
- `.vscode/Tables/Tables/Table 96011 - FRE Publicacions Register.al`
- `.vscode/Tables/Tables/Table 96167 - FRE Attribute Value.al`
- `.vscode/Tables/Tables/Table 96790 - OD RE FA Link.al`
- `src/FinancialFlow/Codeunit 96884 - OD FF Excel Export.al`
- `.vscode/Tables/Tables/Table 96018 - Lease Contract.al`

## 8. Riesgos

- Los FlowFields cambian solo su declaracion de no edición; su valor debe
  verificarse en Sandbox con registros sin relaciones, con una relación y con
  varias relaciones cuando el cálculo sea acumulado.
- El Excel Buffer temporal debe validarse con exportaciones reales para
  confirmar posiciones, tipos y ausencia de datos residuales entre filas.
- El mensaje de mapa debe revisarse tanto sin configuración como con
  configuración existente.

## 9. Pruebas Sandbox

- Abrir los Cues y páginas de contactos, publicaciones, atributos y enlaces;
  comprobar valores, filtros, drilldowns y `CalcFields` con datos vacíos, uno y
  múltiples relacionados.
- Ejecutar exportación Financial Flow con datos válidos, sin datos, varias
  filas y distintos valores; revisar 16 columnas, última fila y posiciones.
- Ejecutar `DisplayMap` de contrato sin `Online Map Setup` y comprobar el nuevo
  mensaje; repetir con configuración y validar la selección de mapa.
- Publicar la extensión en Sandbox, sincronizar esquema, abrir empresa y
  verificar las tablas ampliadas en C.1: `Fixed Real Estate Images.Description`
  y `Incident Assets Real Estate.Capture Medium Code`.
- Completar los checks pendientes de C.1: permisos por rol, API v1,
  importaciones, creación/cancelación de activos y límites de texto.

## 10. Pendientes

No quedan `PC0001`, `PC0027` ni `PC0034`. El cierre funcional de Sprint C
depende de ejecutar el checklist Sandbox, incluida la sincronización de esquema
originada por `PC0028` en C.1.

## 11. Resultado final

Resumen: 7 archivos AL modificados, 27 `PC0001` eliminados, 2 `PC0027`
eliminados, 1 `PC0034` eliminado, 0 diagnósticos nuevos, `AL errors = 0` y APP
generada.

`SPRINT C.2 REQUIERE TEST SANDBOX`
