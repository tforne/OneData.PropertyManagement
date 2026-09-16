# ALCops Sprint C.1 - Analisis funcional

Fecha de analisis: 2026-09-03.

## 1. Resumen ejecutivo

Se analizaron las 74 ocurrencias actuales de las diez reglas objetivo. No se
modifico codigo AL, `app.json`, XLF, permisos ni configuracion. La evidencia
permite autorizar dos cambios de bajo riesgo (hacer explicita la no edicion de
FlowFields) y una correccion de texto que requiere prueba. El resto afecta la
experiencia de usuario, permisos, contrato de API, datos temporales o esquema,
y no debe modificarse sin la decision indicada.

| Grupo | Regla | Casos | Area | Solucion | Riesgo | Decision |
| --- | --- | ---: | --- | --- | --- | --- |
| C-01 | PC0001 | 27 | Cues, contactos, publicaciones, atributos y activos | Declarar `Editable = false` en FlowFields | Bajo, solo UI | AUTORIZABLE C.2 |
| C-02 | PC0017 | 6 | Facturacion y publicaciones | Corregir paginas incompatibles, no sustituir a ciegas | Medio | REQUIERE DECISION |
| C-03 | PC0022 | 11 | Adjuntos, diarios, incidencias, factura e importacion | Acotar o ampliar segun contrato de dato | Medio/alto | REQUIERE DECISION |
| C-04 | AC0010 | 21 | Permisos transversales | Completar Permission Sets por rol | Seguridad | REQUIERE DECISION |
| C-05 | PC0024/PC0026 | 3 | API extractos bancarios | Retirar propiedad UI e incluir metadatos de concurrencia | Publico | AUTORIZABLE CON TEST |
| C-06 | PC0027 | 2 | Exportacion Financial Flow | Evitar `Validate` en buffer temporal | Medio | AUTORIZABLE CON TEST |
| C-07 | PC0028 | 2 | Imagenes e incidencias | Alinear longitudes de relacion | Esquema/datos | REQUIERE DECISION |
| C-08 | PC0034 | 1 | Contratos de alquiler | Corregir etiqueta sin argumento | Bajo | AUTORIZABLE CON TEST |
| C-09 | PC0036 | 1 | Estructura de activos | Replantear dialogo con registro temporal | UI/temporal | REQUIERE DECISION |

## 2. Baseline

Compilacion diagnostica ejecutada el 2026-09-03 con AL Language `17.0.2273547`,
AL Compiler `17.0.34.45391` y ALCops `1.1.0` (ApplicationCop, LinterCop y
PlatformCop activos). La salida se genero fuera del workspace.

| Metrica | Resultado |
| --- | ---: |
| AL errors | 0 |
| Warnings | 3.713 |
| Informacion | 3.094 |
| Total diagnosticos | 6.807 |
| APP generado | Si |

Confirmacion expresa: `AL errors = 0`.

## 3. Inventario de diagnosticos objetivo

| Regla | Ocurrencias | Objetos | Area funcional |
| --- | ---: | ---: | --- |
| PC0001 | 27 | 5 tablas | Cues, contactos, publicaciones, atributos, enlace activo inmobiliario-activo fijo |
| PC0017 | 6 | 3 objetos | Facturacion de alquiler y publicaciones |
| PC0022 | 11 | 5 objetos | Adjuntos, diarios, agente de incidencias, factura e importacion |
| AC0010 | 21 | 21 objetos | Permisos: contratos, activos, Financial Flow, incidencias, despliegue |
| PC0024 | 1 | 1 API Page | Integracion de extractos bancarios |
| PC0026 | 2 | 1 API Page | Integracion de extractos bancarios |
| PC0027 | 2 | 1 codeunit | Exportacion Financial Flow |
| PC0028 | 2 | 2 tablas | Imagenes e incidencias |
| PC0034 | 1 | 1 tabla | Contratos de alquiler |
| PC0036 | 1 | 1 pagina | Estructura de activos |

## 4. PC0001

Mensaje exacto comun: `Field '<campo>' is editable, which is uncommon for a
FlowField. Set Editable = false, or add a comment to justify why editing is
intentional.` El analizador detecta que un campo calculado no declara la
propiedad; un FlowField no persiste escritura directa, por lo que no hay cambio
de datos. La correccion propuesta solo hace explicita la semantica de UI.

| Caso(s) y linea | Objeto / contexto | Codigo afectado | Analisis y clasificacion |
| --- | --- | --- | --- |
| Tabla 96006 `REF Related Contactos`, 85 | Contactos de activo/contrato; pagina de contactos desde fichas de activo | `Post Code`: `Lookup(Contact."Post Code" ...)`, `TableRelation = "Post Code"` | El valor procede del contacto seleccionado. La relacion no convierte el FlowField en dato editable. `SEGURO`: `Editable = false`; probar visualizacion y lookup del contacto. |
| Tabla 96007 `RE Owner Cue`, 15, 22, 30, 38, 46, 54, 63, 69, 77, 83, 89, 95, 102, 119, 125, 131, 143, 164, 220, 227, 234, 241 | Cue del Role Center; contadores filtrados de ventas, compras, cartera, tareas y contratos | `CalcFormula = Count(...)` para `Released Sales Quotes`, `Open/Released Sales Orders`, `Released Purchase Orders`, `Overdue Sales Documents`, `Shipped Not Invoiced`, `Customers - Blocked`, `Purchase Documents Due Today`, `Vendors - Payment on Hold`, `Sales/Unpaid/Overdue Invoices`, `Sales Quotes`, `Purchase/Unpaid/Overdue Purchase Invoices`, `Pending Tasks`, `Lease Contract Expired` y cuatro contadores Cartera | Los 22 casos son indicadores calculados; no hay asignacion ni trigger de escritura. `SEGURO`: declarar no editables. Mantener editables los FlowFilters, que no son objeto de aviso. Probar que cada cue conserva conteo y drilldown. |
| Tabla 96011 `FRE Publicacions Register`, 45 | Registro persistente de ficheros de pago/publicacion | `No. of Transfers`: `Count("Credit Transfer Entry"...)` | El campo cuenta transferencias y el registro se crea/modifica por `CreateNew`, `SetStatus` y `SetFileContent`; el FlowField no participa en esas escrituras. `SEGURO`. |
| Tabla 96167 `FRE Attribute Value`, 91 | Maestro de atributos inmobiliarios | `Attribute Name`: `Lookup("FRE Attribute".Name...)` | Nombre derivado del maestro, no un atributo editable del valor. `SEGURO`; probar ficha/lista de valores y traducciones. |
| Tabla 96790 `OD RE FA Link`, 46 y 52 | Enlace entre inmueble y activo fijo; usado por importacion y despliegue | `Real Estate Description` y `FA Description`: `Lookup(...)` | Son descripciones de presentacion de dos claves ya persistidas. `SEGURO`; no altera `CreateLink` ni sincronizacion. |

Agrupacion C-01: 27 FlowFields de presentacion, sin escritura ni cambio de
esquema. Solucion: hacer explicito `Editable = false` en cada campo, no una
transformacion global sin revisar los cinco patrones anteriores.

## 5. PC0017

Los seis mensajes exactos son `Argument 1: cannot convert from Record <origen>
to Record <destino>.` No son conversiones de datos: exponen que una pagina
estandar recibe un record de tabla OneData incompatible, o que una tabla apunta
a una pagina de otra tabla.

| Archivo:linea | Objeto / procedimiento | Codigo afectado | Comportamiento y riesgo | Clasificacion |
| --- | --- | --- | --- | --- |
| `.vscode/Pages/Page 96704 - Create Payment Lease Invoice.al:30` | Pagina 96704, `OnLookup` de `Template Name` | `GeneralJournalTemplates.SetTableView(FREJnlTemplate)` | La UI pretende seleccionar un `FRE Jnl. Template`, pero abre la pagina estandar `General Journal Templates` (record `Gen. Journal Template`). El filtro/seleccion puede no representar la tabla OneData. | REQUIERE DECISION FUNCIONAL |
| mismo archivo:33 | mismo `OnLookup` | `GeneralJournalTemplates.GetRecord(FREJnlTemplate)` | Devuelve el record de la pagina estandar a una variable OneData. Cambiarlo exige elegir una pagina propia de plantillas FRE o redefinir la funcion de pago. Probar seleccion, lote y creacion de lineas. | REQUIERE DECISION FUNCIONAL |
| `.vscode/Tables/Tables/Table 96011 - FRE Publicacions Register.al:15` | Tabla 96011, propiedad `DrillDownPageID = 1205` | Pagina 1205 de `Credit Transfer Register` | La tabla se presenta como `Credit Transfer Register`, pero no es esa tabla. El drilldown puede abrir una pagina con tabla incompatible. Es registro persistente no por empresa de ficheros exportados. | REQUIERE DECISION ARQUITECTONICA |
| mismo archivo:16 | Tabla 96011, `LookupPageID = 1205` | misma pagina incompatible | Igual riesgo en lookup; una sustitucion por pagina propia cambia navegacion y potenciales extensiones. No se localizaron consumidores externos. | REQUIERE DECISION ARQUITECTONICA |
| `.vscode/Tables/Tables/Table 96022 - Lease Invoice Line.al:28` | Tabla 96022, `DrillDownPageID = 5951` | Pagina `Service Invoice Lines` | La linea de factura de alquiler se navega como `Service Invoice Line`, record distinto. Puede afectar drilldown desde FlowFields y enlaces. | REQUIERE DECISION FUNCIONAL |
| mismo archivo:29 | Tabla 96022, `LookupPageID = 5951` | misma pagina incompatible | Cambiar a pagina propia/listpart de lineas de alquiler requiere confirmar experiencia esperada. | REQUIERE DECISION FUNCIONAL |

No se recomienda correccion automatica: los tres pares comparten regla pero no
intencion funcional. El escenario minimo de prueba es abrir cada lookup y
drilldown desde la pagina invocadora, seleccionar un valor y completar el flujo
de factura/publicacion.

## 6. PC0022

Mensaje exacto: `Possible overflow assigning '<origen>' to '<destino>'.` Cada
aviso fue revisado como posible truncamiento; no implica que ya existan datos
truncados.

| Archivo:linea | Objeto / datos | Codigo afectado | Persistencia y recomendacion | Clasificacion |
| --- | --- | --- | --- | --- |
| `Codeunit 96006 - Import Attachment - Incident.al:128` | Importacion de adjunto de incidencia, tabla `Incident Attachment` | `Validate("File Extension", LowerCase(CopyStr(..., 1, MaxStrLen(...))))` | La expresion ya esta acotada a la longitud del campo; el analizador no infiere `CopyStr`. No hay truncamiento fuera del limite definido por el esquema. | NO CORREGIR |
| `Codeunit 96007 - Journals Management.al:85` | Inicializacion de `FRE Jnl. Template` | `Name := Text000` a `Code[10]` | Etiqueta a clave persistida. Debe verificarse que `Text000` sea un identificador estable de <=10, no un texto localizado. Cambiar a `CopyStr` ocultaria un contrato roto. | REQUIERE DECISION FUNCIONAL |
| mismo archivo:86 | misma plantilla | `Description := Text001` a `Text[80]` | Etiqueta persistida; posible truncamiento de descripcion traducida. Definir longitud funcional aceptada. | PROBABLEMENTE SEGURO |
| mismo archivo:117 | Inicializacion de `FRE Jnl. Batch` | `Name := Text002` a `Code[10]` | Mismo riesgo de clave estable y de localizacion. | REQUIERE DECISION FUNCIONAL |
| mismo archivo:118 | mismo lote | `Description := Text003` a `Text[50]` | Posible corte de descripcion visible; requiere prueba con idioma y valores largos. | PROBABLEMENTE SEGURO |
| `Codeunit 96104 - ODPM Incident Agent Setup Mgt.al:66` | Alta de configuracion del agente de incidencias | `Help URL := SetupHelpUrlLbl` a `Text[250]` | Valor persistido de configuracion. La URL debe rechazarse o acotarse de forma explicita si supera 250; no ampliar campo sin revisar esquema. | PROBABLEMENTE SEGURO |
| mismo archivo:79 | Validacion de configuracion | `Last Validation Result := ValidationOkLbl` a `Text[250]` | Resultado persistido de UI. La etiqueta actual cabe previsiblemente, pero una traduccion futura podria no caber. Acotar con `CopyStr` conserva el contrato y requiere prueba de mensaje. | PROBABLEMENTE SEGURO |
| mismo archivo:146 | Reparacion de configuracion existente | `Help URL := SetupHelpUrlLbl` a `Text[250]` | Mismo dato que linea 66; debe resolverse junto con ella. | PROBABLEMENTE SEGURO |
| `Report 96003 - Lease Sales Invoice.al:1149` | Factura de ventas de alquiler | `exit(Text004)` desde `DocumentCaption(): Text[250]` | Solo retorno de presentacion; no persiste. El limite ya es amplio. Acotar al retorno seria equivalente, pero confirmar que no se reutiliza como dato de integracion. | SEGURO |
| `Codeunit 96991 - OD AM Asset Import Mgt.al:377` | Importacion de activos; tabla `Fixed Real Estate` | `Validate(Description, AssetDescription)` `Text[100]` a campo `Text[50]` | Modifica un activo ya creado y ejecuta validacion. Hay riesgo real de truncamiento/error y de perder descripcion importada. Decidir si la importacion rechaza, acorta con aviso o se amplia esquema. | REQUIERE DECISION FUNCIONAL |
| mismo archivo:392 | Alta de activo desde importacion | mismo `Validate(Description, AssetDescription)` | Inserta despues de validar; mismo contrato y riesgo sobre dato maestro. Resolver junto a linea 377. | REQUIERE DECISION FUNCIONAL |

## 7. AC0010 - Permisos

Mensaje exacto comun: `The application object <tipo> '<nombre>' is not covered
by any PermissionSet in this extension.` AC0010 no indica que el objeto deba
declarar `Permissions = ...`; detecta que ningun Permission Set concede acceso
ejecutable/visible al objeto. Anadir permisos a un objeto elevaria privilegios
y no es la correccion por defecto.

| Objeto (archivo) | Recurso / operacion directa | Permission Sets observados | Clasificacion |
| --- | --- | --- | --- |
| Codeunit 96986 `OD Lease Ctr. Val. Mgt.` | Gestiona buffer de validacion de contratos; llamada por pagina 96074 | `ODPM ADMIN/SETUP/USER/READ` cubren la tabla buffer, no este codeunit ni la pagina resultado | PERMISO FUNCIONAL DEL USUARIO: decidir que rol puede ejecutar validacion. |
| Page 96074 `OD Lease Ctr. Val. Results` | UI sobre `OD Lease Ctr. Val. Buffer`, lectura de resultados | mismo contexto | PERMISO FUNCIONAL DEL USUARIO. |
| Report 96612 `FRE Annual Income Excel` | Lee activos/ingresos-gastos y genera Excel; expuesto desde extension de pagina 96861 | No aparece en Permission Sets actuales | PERMISO FUNCIONAL DEL USUARIO; decidir si usuarios de activos pueden exportar. |
| Codeunit 96923 `OD AM Lease Wizard Mgt.` | Inserta/modifica `OD AM Lease Wizard*`, `Lease Contract`, lineas y unidades; crea contrato | Extensiones `OD AM * Ext` cubren tablas relacionadas, no codeunit/wizard | REQUIERE REVISION DE SEGURIDAD: crear contrato es privilegio de negocio. |
| Page 96927 `OD AM Lease Wizard Units` | UI de unidades temporales/persistidas del asistente | no cubierta por extensiones OD AM | PERMISO FUNCIONAL DEL USUARIO, ligado al wizard. |
| Page 96928 `OD AM Lease Wizard Lines` | UI de lineas del asistente | no cubierta por extensiones OD AM | PERMISO FUNCIONAL DEL USUARIO, ligado al wizard. |
| Page 96929 `OD AM Lease Contract Wizard` | Orquesta alta de contrato desde ficha de activo | no cubierta por extensiones OD AM; invocada desde `Fixed Real Estate Card` | REQUIERE REVISION DE SEGURIDAD. |
| Page 96980 `OD AM Secondary Units FB` | FactBox de unidades de activo, lectura | Usada por paginas/listas de activos; no aparece en extensiones OD AM | PERMISO TECNICO NECESARIO: incluir con las paginas de activos ya autorizadas. |
| Page 96983 `OD AM Asset Context FB` | FactBox de contexto de estructura, lectura | Usada por pagina 96940; no aparece en extensiones OD AM | PERMISO TECNICO NECESARIO. |
| Codeunit 96957 `OD PM Deployment Setup` | Suscriptor que registra tablas de activos/contratos para despliegue | No aparece en sets; trabaja indirectamente mediante `OD Deployment Package Mgt.` | POSIBLE FALSO POSITIVO / CONTEXTO ESPECIAL: subscriber no debe ser asignable al usuario sin revisar la plataforma de despliegue. |
| Page 96954 `OD FF Snapshot Subpage` | ListPart de `OD FF Snapshot Line`, lectura | Sets `OD FF User/Admin` cubren tabla y paginas padre, no el subpage | PERMISO TECNICO NECESARIO. |
| Table 96930 `OD FF Setup` | Configuracion Financial Flow, lectura/modificacion | `OD FF User=R`, `OD FF Admin=RIMD`; falta permiso de objeto tabla | PERMISO TECNICO NECESARIO para coherencia de roles, sin elevar tabledata. |
| Table 96931 `OD FF Buffer` | Buffer por usuario, RIMD | `OD FF User/Admin=RIMD` | PERMISO TECNICO NECESARIO. |
| Table 96932 `OD FF Snapshot Header` | Cabecera persistida de snapshot, R/RIMD por rol | `OD FF User=R`, `OD FF Admin=RIMD` | PERMISO TECNICO NECESARIO. |
| Table 96933 `OD FF Snapshot Line` | Lineas persistidas de snapshot, lectura | `OD FF User/Admin=R` | PERMISO TECNICO NECESARIO. |
| Table 96934 `OD FF Compare Buffer` | Buffer comparativo por usuario, RIMD | `OD FF User/Admin=RIMD` | PERMISO TECNICO NECESARIO. |
| Table 96935 `OD FF Contract Summary` | Buffer/resumen de contrato, RIMD | `OD FF User/Admin=RIMD` | PERMISO TECNICO NECESARIO. |
| Codeunit 96972 `RE Incident Contract Mgt.` | Construye temporal de contratos y modifica `Incident Assets Real Estate` al aplicar seleccion | No aparece en sets; invocado desde table/page extensions de incidencias | REQUIERE REVISION DE SEGURIDAD: enlazar una incidencia modifica dato. |
| Page 96971 `RE Incident Contract Lookup` | Lookup sobre tabla temporal 96970 | No aparece en sets; solo se abre desde codeunit 96972 | PERMISO TECNICO NECESARIO si se autoriza la funcion anterior. |
| Table 96970 `RE Incident Contract Lookup` | Buffer de lookup, no dato de negocio final | No aparece en sets | POSIBLE FALSO POSITIVO / CONTEXTO ESPECIAL: no otorgar acceso directo salvo que sea necesario para abrir la pagina. |
| Codeunit 96985 `OD Import Lease Contracts` | Punto de entrada de importacion de contratos | No aparece en sets; la importacion persistente esta en objetos OD AM | REQUIERE REVISION DE SEGURIDAD: importar puede crear/modificar contratos. |

No se pudieron determinar consumidores externos de estos objetos desde el
repositorio. Los Permission Sets son contrato de seguridad: C.2 debe modificar
solo su cobertura, tras confirmar matriz de roles, y nunca anadir elevacion
`Permissions` por defecto.

## 8. PC0024 / PC0026 - API

Los tres casos estan en `.vscode/Pages/Page 96760 - FRE Bank Statement API.al`,
cuyo objeto declarado es Page 96761 `FRE Bank Statement API`. Es una API publica
(`APIPublisher = onedata`, grupo `operations`, version `v1.0`), de insercion
permitida sobre `FRE Bank Statement`; no se localizaron consumidores internos
ni es posible descartar consumidores externos.

| Regla:linea | Mensaje exacto | Analisis / impacto | Clasificacion |
| --- | --- | --- | --- |
| PC0024:23 | `The 'ApplicationArea' property is not applicable to API pages and should be removed.` | `ApplicationArea = All` no forma parte del contrato OData. Retirarla no cambia campos ni permisos. | PROBABLEMENTE SEGURO; impacto PUBLICO minimo. |
| PC0026:1 | `Field 'Rec.SystemId' exposed with the name 'id' should always be included on API Pages.` | La pagina define `ODataKeyFields = SystemId` y expone `field(systemId; Rec.SystemId)`, no `id`. La recomendacion exige el nombre estandar `id`; renombrar un campo ya publicado puede romper clientes. | REQUIERE DECISION ARQUITECTONICA; impacto PUBLICO. |
| PC0026:1 | `Field 'Rec.SystemModifiedAt' exposed with the name 'lastModifiedDateTime' should always be included on API Pages.` | No se expone `SystemModifiedAt`. Agregar el campo es aditivo, util para sincronizacion/concurrencia, pero debe confirmarse versionado y formato de API. | PROBABLEMENTE SEGURO; impacto POTENCIALMENTE PUBLICO. |

Recomendacion: en C.2 retirar `ApplicationArea` y agregar
`lastModifiedDateTime` tras una prueba de contrato. Para `id`, mantener
compatibilidad con el consumidor existente: decidir entre publicar `id` aditivo
conservar `systemId`, o versionar `v1.1`; no renombrar automaticamente.

## 9. PC0027 - Temporales

Ambos casos estan en Codeunit 96884 `OD FF Excel Export`, procedimiento local
`AddCell(var ExcelBuffer: Record "Excel Buffer" temporary; ...)`, lineas 65-66.
El ciclo de vida es local a `ExportCurrentUserAnalysis`: se inicializa el buffer,
se insertan cabeceras y lineas, se crea y abre un libro Excel; no se persiste el
record temporal en SQL ni se reutiliza despues de la ejecucion.

| Linea | Mensaje exacto / codigo | Riesgo y cambio posible | Clasificacion |
| --- | --- | --- | --- |
| 65 | `Do not execute table triggers or validation methods on temporary record variables.` / `ExcelBuffer.Validate("Row No.", RowNo)` | El campo es coordenada interna del Excel Buffer. Sustituir por asignacion directa evita triggers y conserva valor si no hay logica requerida. | PROBABLEMENTE SEGURO |
| 66 | mismo mensaje / `ExcelBuffer.Validate("Column No.", ColNo)` | Mismo patron para columna. No hay filtros residuales: `Init()` se ejecuta antes de cada celda. | PROBABLEMENTE SEGURO |

Tests: exportar Financial Flow sin datos y con varios contratos/empresas, revisar
encabezados, posicion de las 16 columnas, tipos de fecha/importe y que el Excel
se abra. No hay indicio de estado residual ni de eliminacion de datos.

## 10. PC0028 - Esquema

| Archivo:linea | Mensaje exacto | Contexto, datos y upgrade | Clasificacion |
| --- | --- | --- | --- |
| `Table 96001 - Fixed Real Estate Images.al:31` | `The related field has length 80 (Description) which is longer than the current field length 50 (Description)` | Campo persistido `Fixed Real Estate Images.Description: Text[50]` tiene `TableRelation = "Description Documents Class".Description` (80). Un usuario puede seleccionar una descripcion valida que no cabe, afectando alta/modificacion de imagenes. Ampliar campo es cambio de esquema y requiere sync/upgrade; acotar la relacion cambia datos seleccionables. | REQUIERE DECISION ARQUITECTONICA |
| `Table 96100 - Incident Assets Real Estate.al:198` | `The related field has length 20 (Code) which is longer than the current field length 10 ("Capture Medium Code")` | Campo persistido `Capture Medium Code: Code[10]` se relaciona con `Capture Medium.Code` de 20. Afecta creacion y actualizacion de incidencias. Misma eleccion: ampliar campo con plan de upgrade o limitar catalogo. | REQUIERE DECISION ARQUITECTONICA |

No hay correccion segura de esquema. Antes de C.2 hay que consultar datos
existentes y catalogos para saber si ya hay valores >10/>50, y ejecutar la
sincronizacion en Sandbox antes de produccion.

## 11. PC0034

Caso en Tabla 96018 `Lease Contract`, procedimiento publico `DisplayMap`, linea
1129. Mensaje exacto: `The format string contains 1 placeholder(s), but 0
argument(s) were provided.` Al no existir configuracion de mapa, se ejecuta
`MESSAGE(Text014);`. La etiqueta tiene un placeholder `%1`, por lo que el
usuario recibe un mensaje de formato incompleto o se genera error, segun el
contenido final de la etiqueta. No modifica datos ni persiste nada.

Clasificacion confirmada: `PROBABLEMENTE SEGURO`. C.2 debe revisar la etiqueta:
o bien eliminar `%1` si no hay dato que mostrar, o pasar el valor funcional que
debe mostrarse. Test: abrir contrato, ejecutar mapa sin `Online Map Setup` y
verificar el mensaje; repetir con configuracion existente y comprobar que abre
la seleccion de mapa.

## 12. PC0036

Caso en Page 96940 `OD AM Asset Structure`, procedimiento local
`CreateGenericAsset`, linea 378. Mensaje exacto: `NewAssetDialog.SetRecord():
You cannot use a temporary record for the Record parameter.`

La pagina lista usa `OD AM Asset Structure Buffer`; al pulsar `Nuevo activo`
crea un `OD AM Asset Create Req.` temporal, inserta una fila con tipo
`Undefined`, la entrega al dialogo Page 96944 `OD AM New Asset`, y recupera la
seleccion con `GetRecord` para crear un `Fixed Real Estate`. El usuario no ve
ni debe persistir la solicitud previa; el activo final se crea solo despues de
confirmar el dialogo. Cambiar a record no temporal podria dejar solicitudes
incompletas en tabla, pero cambiar el dialogo puede alterar `LookupMode`,
cancelacion y seleccion.

Clasificacion: `REQUIERE DECISION FUNCIONAL`. Probar, antes de elegir patron:
cancelar, elegir cada tipo de activo, crear bajo activo seleccionado y bajo
propiedad raiz, verificar que no haya filas residuales y que se abra la ficha
del activo creado.

## 13. Grupos funcionales

| Grupo | Patron | Objetos | Solucion propuesta | Riesgo | Tests necesarios |
| --- | --- | --- | --- | --- | --- |
| C-01 | FlowFields sin `Editable = false` | 5 tablas, 27 casos | Declarar propiedad en cada campo | Bajo | Cues, contactos, atributos y enlaces |
| C-02 | Pagina/record incompatibles | 3 objetos, 6 casos | Disenar pagina fuente correcta por flujo | Medio | Lookups y drilldowns de factura/publicacion |
| C-03 | Longitudes de texto | 5 objetos, 11 casos | Decidir rechazo, acotado visible o esquema | Medio/alto | Importacion, diario, agente y factura |
| C-04 | Objetos sin cobertura de rol | 21 objetos | Completar sets despues de matriz RBAC | Seguridad | Usuario Read/User/Setup/Admin limitado |
| C-05 | API de extractos | 1 API Page, 3 casos | Cambio aditivo/versionado de contrato | Alto | POST y lectura OData desde cliente real |
| C-06 | Excel Buffer temporal | 1 codeunit, 2 casos | Asignar coordenadas sin `Validate` | Medio | Exportacion multiempresa |
| C-07 | Relacion con longitudes distintas | 2 tablas, 2 casos | Decision de esquema y upgrade | Alto | Sync, datos existentes y alta/edicion |
| C-08 | Mensaje con placeholder | 1 tabla, 1 caso | Completar o retirar argumento | Bajo | Mapa configurado/no configurado |
| C-09 | `SetRecord` temporal | 1 pagina, 1 caso | Redisenar contrato del dialogo | Medio | Alta/cancelacion de activos |

## 14. Correcciones seguras C.2-A

Solo C-01 se considera inequivamente equivalente: los 27 campos son
FlowFields calculados y no hay codigo de escritura ni una necesidad funcional
de que parezcan editables. C.2-A debe anadir `Editable = false` de forma
individual a los casos enumerados en PC0001 y compilar.

## 15. Correcciones con validacion C.2-B

| Grupo | Cambio candidato | Validacion Sandbox |
| --- | --- | --- |
| C-03 parcial | Acotar explicitamente los textos de descripcion/URL/resultados; no claves de diarios ni descripcion de activo | Idiomas, altas de configuracion, diario inicial y factura |
| C-05 parcial | Retirar `ApplicationArea`; publicar `lastModifiedDateTime` de forma aditiva | GET/POST OData, consumidor existente, lectura de metadatos |
| C-06 | Sustituir dos `Validate` de coordenadas de Excel temporal por asignacion | Archivo Excel, 16 columnas, fechas e importes |
| C-08 | Corregir `Text014`/argumento en `DisplayMap` | Mapa configurado y no configurado |

## 16. Decisiones necesarias C.2-C

Los grupos C-02, C-03 para claves/importacion, C-04, C-07 y C-09 requieren
autorizacion funcional o arquitectonica antes de escribir codigo. Tambien el
nombre `id` de la API necesita decision de versionado.

## 17. Casos que no recomiendo corregir

No recomiendo cambiar el caso PC0022 de `Import Attachment - Incident`: la
expresion ya emplea `CopyStr(..., 1, MaxStrLen("File Extension"))`, por lo que
la advertencia no representa truncamiento no controlado. No recomiendo tampoco
anadir `Permissions` a objetos como respuesta automatica a AC0010: ampliaria
privilegios sin resolver la matriz de roles.

## 18. Matriz de pruebas

| Modulo | Escenarios concretos |
| --- | --- |
| Activos inmobiliarios | Abrir estructura, crear vivienda/habitacion/parking/trastero/activo, cancelar dialogo, abrir fichas, consultar links de activo fijo |
| Contratos de alquiler | Ejecutar wizard, crear contrato con unidades y lineas, abrir lookup/drilldown de diarios y lineas, ejecutar validacion de contrato |
| Facturacion y diarios | Seleccionar plantilla y lote FRE, crear lineas, emitir factura, abrir publicaciones/transferencias |
| Financial Flow | Ejecutar analisis, crear/consultar snapshot, comparar, exportar Excel con varias lineas y usuario limitado |
| Incidencias | Crear/editar incidencia, seleccionar medio de captura y contrato, ejecutar agente y adjuntar archivo con extension larga |
| API | POST valido/invalido, GET por `systemId`/`id` segun decision, verificar `lastModifiedDateTime`, probar cliente existente |
| Permisos | Probar cada flujo con ODPM Read, User, Setup, Admin, OD FF User/Admin y extensiones OD AM; confirmar acceso y ausencia de elevacion accidental |
| Upgrade | Copia de datos con descripciones/codigos maximos, sincronizacion Sandbox, rollback y validacion de relaciones |

## 19. Priorizacion por modulo OneData

1. Financial Flow: C-06 y la cobertura AC0010 tecnica son los candidatos mas
   acotados; no cambian calculos ni snapshots.
2. Activos inmobiliarios: C-01 y C-09; el segundo necesita prueba de asistente.
3. Contratos/facturacion: C-02, PC0034 y parte de PC0022; validar navegacion y
   creacion de diarios antes de tocar contratos.
4. Incidencias: PC0028 y AC0010 dependen de politica de datos y roles.
5. API y despliegue: contrato externo y subscriber; tratar al final y con
   propietario funcional/tecnico.

## 20. Propuesta Sprint C.2

Autorizar C.2-A para C-01. Autorizar C.2-B solo para C-03 parcial, C-05
parcial, C-06 y C-08 con la matriz de pruebas anterior. Mantener C-02, claves
de C-03, C-04, C-07, C-09 y `id` de API bloqueados hasta resolver las
decisiones siguientes.

# DECISIONES NECESARIAS

## DEC-01

Estado: resuelta el 2026-09-04 mediante la opcion A.

Implementacion: el lookup de factura de alquiler usa `FRE Jnl. Template List`,
la pagina valida `FRE Jnl. Template` y `FRE Jnl. Batch`, las tablas de
publicaciones y lineas de factura apuntan a paginas OneData compatibles, y se
anadio Page 96046 `FRE Publication Registers` para las publicaciones.

Situacion actual: la factura de alquiler abre una pagina estandar de plantillas
para seleccionar una plantilla FRE, y dos tablas OneData apuntan a paginas de
tablas distintas. ALCops recomienda que los records y paginas sean compatibles.

Opciones: A. crear/usar paginas propias OneData; B. redirigir los flujos al
modelo estandar; C. retirar navegacion no usada. Recomendacion tecnica: A,
preservando los datos OneData. Impacto: cambia navegacion, no esquema.
Pregunta concreta: que pagina debe usar el usuario para seleccionar plantilla,
lote, publicacion y linea de factura de alquiler?

## DEC-02

Estado: resuelta el 2026-09-04 mediante la opcion A.

Implementacion: las claves y descripciones de diarios FRE, los valores por
defecto de configuracion de incidencias, el caption de factura y las
descripciones importadas validan la longitud antes de escribir y generan error
si exceden el campo destino. Las rutas de importacion de activos validan antes
de crear el registro, por lo que el `TryFunction` devuelve el error al lote sin
truncar la descripcion. La extension del adjunto se normaliza antes de acotarse,
manteniendo el resultado existente sin desbordamiento.

Situacion actual: claves de diario de 10 caracteres y descripcion de activos de
50 pueden recibir textos mas largos. ALCops recomienda evitar desbordamiento.

Opciones: A. rechazar con mensaje; B. acortar con aviso; C. ampliar campos.
Recomendacion tecnica: A para claves, A o B para descripciones tras confirmar
requisito. Impacto: C es cambio de esquema y upgrade; B puede perder texto.
Pregunta concreta: deben conservarse completas las descripciones importadas y
que identificadores FRE son parte de un contrato estable?

## DEC-03

Estado: resuelta el 2026-09-04 mediante la opcion A.

Implementacion: se cubrieron los 21 objetos AC0010 con los Permission Sets
existentes, sin propiedades `Permissions` en objetos ni nuevos privilegios
`tabledata`. `ODPM READ/USER/ADMIN` cubren los resultados de validacion segun
su acceso actual; asistentes e importacion se limitan a `ODPM USER/ADMIN`;
FactBoxes de activos se incluyen en las cuatro extensiones OD AM; Financial
Flow se cubre en `OD FF User/Admin`; incidencias se limita a `ODPM USER/ADMIN`;
el informe anual y el subscriber de despliegue quedan en `ODPM ADMIN`.

Situacion actual: 21 objetos nuevos no aparecen en Permission Sets, aunque
muchas tablas subyacentes si tienen tabledata por rol. ALCops recomienda cubrir
los objetos.

Opciones: A. dar acceso por rol existente; B. crear rol especializado; C.
mantener internos los subscribers/buffers. Recomendacion tecnica: A para
FactBoxes/subpages y B para wizard, importacion y validacion. Impacto: seguridad
y separacion de funciones.
Pregunta concreta: que roles pueden crear contratos, importar contratos,
vincular incidencias y exportar ingresos?

## DEC-04

Estado: resuelta el 2026-09-04 mediante la opcion A.

Implementacion: la API v1 conserva `systemId` para compatibilidad y publica de
forma aditiva `id` (`SystemId`) y `lastModifiedDateTime`
(`SystemModifiedAt`). Tambien se retiro `ApplicationArea`, que no aplica a una
API Page. Pendiente de validar en Sandbox un cliente OData existente con los
campos nuevos y el contrato v1 actual.

Situacion actual: la API publica v1 expone `systemId`, pero no el nombre
estandar `id` ni fecha de modificacion. ALCops recomienda ambos.

Opciones: A. anadir `id` y `lastModifiedDateTime` sin retirar `systemId`; B.
versionar API; C. conservar el contrato actual. Recomendacion tecnica: A solo
si se valida que no crea ambiguedad; si hay consumidores, versionar. Impacto:
contrato externo y sincronizacion.
Pregunta concreta: hay clientes externos de `onedata/operations/v1.0` y cual es
su campo clave esperado?

## DEC-05

Estado: resuelta el 2026-09-04 mediante la opcion A.

Implementacion: `Fixed Real Estate Images.Description` se amplio de `Text[50]`
a `Text[80]`, y `Incident Assets Real Estate.Capture Medium Code` de `Code[10]`
a `Code[20]`, alineandolos con sus respectivos campos relacionados. El
repositorio no contiene datos de produccion para medir valores existentes; antes
de desplegar se debe sincronizar en Sandbox y probar valores de 80 y 20
caracteres, respectivamente.

Situacion actual: dos relaciones permiten seleccionar valores mas largos que el
campo destino de imagen/incidencia. ALCops recomienda alinear longitudes.

Opciones: A. ampliar campos; B. restringir catalogos/relaciones; C. mantener
limite y validar con mensaje. Recomendacion tecnica: medir datos existentes y
preferir A si el dominio funcional admite esos valores. Impacto: A exige sync y
prueba de upgrade; B/C restringen usuarios.
Pregunta concreta: pueden existir descripciones documentales de mas de 50 y
medios de captura de mas de 10 caracteres?

## DEC-06

Estado: resuelta el 2026-09-04 mediante la opcion A.

Implementacion: Page 96944 ya no recibe un `Record` temporal. Ahora mantiene
el enum en la variable `SelectedAssetType` y expone `SetAssetType`/
`GetAssetType`; Page 96940 pasa el valor inicial `Undefined` y recupera solo el
tipo seleccionado tras confirmar. La cancelacion sigue saliendo antes de crear
el activo, por lo que no deja solicitudes ni borradores persistentes.

Situacion actual: el dialogo de nuevo activo recibe un record temporal para no
persistir solicitud hasta confirmar. ALCops no admite ese patron en `SetRecord`.

Opciones: A. redisenar dialogo con variables/parametros; B. persistir borrador
y limpiar al cancelar; C. aceptar el warning. Recomendacion tecnica: A, pero es
un cambio de UI que requiere pruebas exhaustivas. Impacto: riesgo de borradores
residuales o cambio de comportamiento de cancelacion.
Pregunta concreta: debe seguir siendo imposible que un usuario deje solicitudes
de nuevo activo sin confirmar?

## Estado final

`SPRINT C.1 ANALIZADO — REQUIERE DECISIONES`
