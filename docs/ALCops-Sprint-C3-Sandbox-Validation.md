# ALCops Sprint C.3 - Sandbox Validation

Fecha: 2026-09-04.

## 1. Resumen ejecutivo

La prevalidacion local obligatoria se completo. No se ejecutaron publicacion ni pruebas funcionales porque esta sesion no tiene conexion autenticada ni una herramienta de publicacion Business Central contra el Sandbox configurado. No se simularon resultados Sandbox ni se modifico codigo, esquema, permisos, API, XLF o configuracion.

## 2. Entorno

| Dato | Valor |
| --- | --- |
| Configuracion encontrada | `.vscode/launch.json` |
| Tipo | `Sandbox` |
| Nombre configurado | `ALIPS` |
| Modo de esquema | `Synchronize` |
| Empresa | No disponible sin conexion autenticada |
| Version anterior instalada | No disponible sin conexion autenticada |
| Version nueva instalada | No publicada |
| Fecha/hora de publicacion | No ejecutable |

No se utilizo `ForceSync`.

## 3. Baseline

Compilacion local de prevalidacion con AL Language `17.0.2273547`, AL Compiler `17.0.34.45391`, ALCops `1.1.0`, ApplicationCop, LinterCop y PlatformCop.

| Metrica | Resultado |
| --- | ---: |
| AL errors | 0 |
| APP generada | Si |
| Diagnosticos totales | 6.733 |
| Informacion | 3.091 |
| Warnings | 3.642 |

| Regla | Resultado |
| --- | ---: |
| PC0001 | 0 |
| PC0017 | 0 |
| PC0022 | 0 |
| PC0024 | 0 |
| PC0026 | 0 |
| PC0027 | 0 |
| PC0028 | 0 |
| PC0034 | 0 |
| PC0036 | 0 |
| AC0010 | 0 |

## 4. Publicacion

**Estado: NO EJECUTABLE.** La configuracion identifica `ALIPS`, pero no aporta un endpoint ni credenciales utilizables por esta sesion, y no existe un cliente Business Central de publicacion disponible. La APP de prevalidacion esta generada localmente; queda pendiente publicar mediante VS Code con autenticacion autorizada.

## 5. Schema Sync

**Estado: NO EJECUTABLE.** Tras publicacion normal con `Synchronize`, validar:

| Tabla | Campo | Longitud anterior | Longitud actual | Relacion |
| --- | --- | ---: | ---: | --- |
| `Fixed Real Estate Images` (96001) | `Description` | `Text[50]` | `Text[80]` | `Description Documents Class.Description` |
| `Incident Assets Real Estate` (96100) | `Capture Medium Code` | `Code[10]` | `Code[20]` | `Capture Medium.Code` |

Comprobar apertura de empresa, lectura y modificacion de registros existentes, alta con valores de 80 y 20 caracteres y ausencia de perdida de datos.

## 6. PC0001 - FlowFields

**Estado: NO EJECUTABLE.** Los 27 campos inventariados en `ALCops-Sprint-C2.md` siguen compilando con `PC0001=0`.

| Objeto | Campo(s) | Modulo | Resultado | Observaciones |
| --- | --- | --- | --- | --- |
| Tabla 96006 `REF Related Contactos` | `Post Code` | Contactos | NO EJECUTABLE | Sin y con contacto relacionado. |
| Tabla 96007 `RE Owner Cue` | 22 cues `Count/Sum` | Role Center | NO EJECUTABLE | Filtros, cero/uno/multiples y refresco. |
| Tabla 96011 `FRE Publicacions Register` | `No. of Transfers` | Publicaciones | NO EJECUTABLE | Conteo y drilldown. |
| Tabla 96167 `FRE Attribute Value` | `Attribute Name` | Atributos | NO EJECUTABLE | Lookup de maestro. |
| Tabla 96790 `OD RE FA Link` | Descripciones de inmueble y activo fijo | Activos | NO EJECUTABLE | Claves relacionadas y `CalcFields`. |

Confirmar que `CalcFormula`, filtros y valores no han cambiado; C.2 solo anadio `Editable = false`.

## 7. AC0010 - Permisos

**Estado: NO EJECUTABLE.** Probar con usuario de pruebas sin `SUPER` y licencia valida. Los roles afectados son `ODPM READ`, `ODPM USER`, `ODPM ADMIN`, las extensiones OD AM y `OD FF User/Admin`.

| Rol | Funcion | Tabla/Objeto | Operacion | Resultado |
| --- | --- | --- | --- | --- |
| ODPM READ | Resultados de validacion | Objetos C.1 AC0010 | Lectura/ejecucion | NO EJECUTABLE |
| ODPM USER | Importacion, asistente e incidencias | Objetos C.1 AC0010 | Operacion funcional | NO EJECUTABLE |
| ODPM ADMIN | Administracion, despliegue e informe | Objetos C.1 AC0010 | Ejecucion | NO EJECUTABLE |
| OD AM roles | Wizards y FactBoxes | Extensiones 96960-96963 | Segun rol | NO EJECUTABLE |
| OD FF roles | Financial Flow | Objetos 968xx | Lectura/ejecucion | NO EJECUTABLE |

Verificar que los permisos no requieren `SUPER` y que no existe acceso no autorizado a `tabledata`.

## 8. API v1

**Estado: NO EJECUTABLE.** Ejecutar GET de coleccion y registro individual en la API de extractos bancarios y comprobar `systemId`, `id` y `lastModifiedDateTime`. Mantener `systemId` para consumidores existentes. Probar POST/PATCH/DELETE solo con un registro de prueba y si el contrato lo permite; no incluir credenciales ni borrar datos reales.

## 9. PC0022 - Longitudes

**Estado: NO EJECUTABLE.** Validar los once casos C.1 con valores inferior, igual y superior al maximo, mas vacio cuando aplique. Cubrir diarios FRE, valores por defecto de incidencias, caption de factura, adjuntos e importacion de activos. Un valor demasiado largo debe rechazar sin truncado silencioso ni datos parciales.

## 10. PC0027 - Excel Buffer

**Estado: NO EJECUTABLE.** Ejecutar el exportador Financial Flow de Codeunit 96984 con datos validos, varias filas/columnas, celda vacia, valor invalido, ultima fila y dos ejecuciones consecutivas. Confirmar filas, columnas, las 16 columnas de salida y ausencia de valores residuales.

## 11. PC0034 - Mensaje/mapa

**Estado: NO EJECUTABLE.** Ejecutar `DisplayMap` de tabla 96018 sin `Online Map Setup` y confirmar el mensaje sin `%1` u otros placeholders; repetir con configuracion existente y confirmar la seleccion de mapa.

## 12. PC0036 - Temporales UI

**Estado: NO EJECUTABLE.** En la estructura de activos, probar apertura, seleccion, confirmacion y cancelacion del dialogo de nuevo activo. Repetir y comprobar que no se conserva tipo o estado de una ejecucion previa.

## 13. PC0017 - Paginas

**Estado: NO EJECUTABLE.** Probar desde las entradas reales: seleccion de plantilla y lote mediante `FRE Jnl. Template List`; lookup y drilldown de publicaciones hacia Page 96046 `FRE Publication Registers`; y lookup/drilldown de lineas de factura de alquiler hacia la pagina OneData compatible. Confirmar pagina, filtros, registro, navegacion y retorno.

## 14. Creacion de activos

**Estado: NO EJECUTABLE.** Crear activo desde estructura, seleccionar tipo, completar datos, abrir ficha, modificar y volver a abrir. Si existe jerarquia, validar `Property -> Asset -> Child Asset` con un caso representativo.

## 15. Smoke test

**Estado: NO EJECUTABLE.** Abrir Role Center, activos inmobiliarios, contratos, Asset Management, Financial Flow, incidencias, configuracion, facturacion y asistentes principales.

## 16. Incidencias

No se registraron incidencias: no se ejecutaron operaciones Sandbox. Ante un fallo, registrar `INC-C3-xxx` con diagnostico, modulo, resultado esperado y obtenido, causa probable, cambio C relacionado, severidad y propuesta. No aplicar propuestas durante C.3.

## 17. Pruebas no ejecutadas

Todas las pruebas que requieren Business Central siguen pendientes: publicacion, schema sync, FlowFields, permisos, API, longitudes, Excel Buffer, mapa, temporales UI, paginas, creacion de activos y smoke test.

## 18. Riesgos residuales

- La sincronizacion de los dos cambios de longitud no esta confirmada en Sandbox.
- Los roles no se han comprobado con un usuario sin `SUPER`.
- La compatibilidad API v1 y los flujos UI no estan demostrados en un entorno ejecutable.

## 19. Conclusion

La prevalidacion tecnica local es PASS. La validacion funcional no puede cerrarse hasta que un operador autenticado publique en `ALIPS` y complete esta matriz con evidencias.

## 20. Matriz final

| ID | Area | Diagnostico | Prueba | Resultado | Observaciones |
| -- | ---- | ----------- | ------ | --------- | ------------- |
| C3-00 | Prevalidacion | Todos | Compilacion completa y APP | PASS | 0 errores; 6.733 diagnosticos; reglas objetivo a 0. |
| C3-01 | Schema | PC0028 | Publicacion y sincronizacion | NO EJECUTABLE | Requiere Sandbox autenticado. |
| C3-02 | FlowFields | PC0001 | Valores, filtros y refresco | NO EJECUTABLE | 27 campos. |
| C3-03 | Permisos | AC0010 | Roles sin SUPER | NO EJECUTABLE | 21 objetos C.1. |
| C3-04 | API | PC0024/PC0026 | GET y compatibilidad v1 | NO EJECUTABLE | Tres campos API. |
| C3-05 | Longitudes | PC0022 | Limites y sin truncado | NO EJECUTABLE | 11 casos. |
| C3-06 | Excel | PC0027 | Exportacion Financial Flow | NO EJECUTABLE | Coordenadas y estado temporal. |
| C3-07 | Mapa | PC0034 | Mensaje y seleccion | NO EJECUTABLE | Sin placeholders. |
| C3-08 | UI | PC0036 | Dialogo y creacion de activos | NO EJECUTABLE | Sin estado residual. |
| C3-09 | Paginas | PC0017 | Lookup, drilldown y retorno | NO EJECUTABLE | 6 casos C.1. |
| C3-10 | Smoke | General | Navegacion principal | NO EJECUTABLE | Requiere Sandbox autenticado. |

| Area | PASS | FAIL | No ejecutable | Estado |
| ---- | ---: | ---: | ------------: | ------ |
| Prevalidacion local | 1 | 0 | 0 | PASS |
| Validacion Sandbox | 0 | 0 | 10 | PENDIENTE |

`SPRINT C.3 INCOMPLETO — PRUEBAS PENDIENTES`
