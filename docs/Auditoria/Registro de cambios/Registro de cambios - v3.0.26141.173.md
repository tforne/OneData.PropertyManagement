# Registro de cambios y versiones

## Datos generales

- Aplicacion: Property Management
- Publisher: OneData
- Version: 3.0.26141.173
- Fecha del registro: 2026-05-22
- Tipo de cambio: Evolutivo y correctivo
- Entorno: Pendiente de completar
- Responsable: Pendiente de completar

## Resumen ejecutivo

Documento de control y trazabilidad de cambios correspondiente a la version `3.0.26141.173`.

La version incorpora una evolucion relevante sobre la gestion de contratos de arrendamiento, la preparacion de datos para Allocation Account, la mejora de la experiencia de gestion documental en contratos y una nueva base funcional para avisos al inquilino. Tambien incluye cambios de upgrade, permisos, traducciones y ajustes de interfaz asociados.

## Detalle de cambios

| ID | Tipo | Descripcion funcional/tecnica | Objeto o area afectada | Motivo | Riesgo/impacto |
| --- | --- | --- | --- | --- | --- |
| 1 | Evolutivo | Se anade el campo `Type` en las lineas de contrato de arrendamiento y se habilita la seleccion de `G/L Account`, `Allocation Account` y textos estandar, incluyendo logica de validacion, lookup y carga automatica de descripcion/datos relacionados. | Tabla `Lease Contract Line`, subpagina de lineas de contrato, enums `Lease Contract Line Type`. | Preparar el modelo de lineas de contrato para soportar nuevas tipologias contables y ampliar la flexibilidad funcional. | Impacto medio-alto en la edicion de lineas, datos existentes y procesos de facturacion. Requiere validacion funcional y regresion en contratos. |
| 2 | Correctivo/Evolutivo | Se incorporan rutinas de instalacion y upgrade para inicializar el nuevo `Type` de las lineas historicas de contrato con valor `G/L Account` cuando proceda. | Codeunits `Install` y `Upgrade`. | Garantizar compatibilidad con datos ya existentes tras introducir el nuevo enum/tipo en lineas de contrato. | Riesgo medio si existen lineas antiguas con casuisticas no previstas. Recomendable probar upgrade con copia de datos real. |
| 3 | Evolutivo | Se ajusta la generacion de facturas de contratos para construir una descripcion de documento mas explicita por periodo, propagar `Allocation Account No.` a la linea de venta y bloquear la facturacion de lineas cuyo `Type` sea `Allocation Account`. | Codeunit `Real Estate Management`, report `Create Lease Contract Invoices`. | Mejorar trazabilidad de las facturas y controlar el alcance real del soporte de Allocation Account en la emision. | Impacto alto en facturacion. Evita errores de uso no soportado, pero introduce una restriccion funcional que debe comunicarse a negocio. |
| 4 | Evolutivo | Se amplian las fichas de activo y contrato con nueva informacion comercial y de seguimiento: titulo del activo, ultimo precio de alquiler, importes de referencia, dimensiones, tipo de propietario de distribucion y codigo de Allocation Account. Tambien se anade acceso directo a Allocation Accounts desde el activo. | Tablas y paginas `Fixed Real Estate` y `Lease Contract Card`, enum `Distribution Owner Type`. | Mejorar la gestion comercial, contable y de consulta desde los activos inmobiliarios y los contratos asociados. | Impacto medio en interfaz y mantenimiento de datos maestros. Requiere validacion visual y de permisos. |
| 5 | Evolutivo | Se mejora la gestion documental de contratos permitiendo cargar multiples ficheros desde la lista y la ficha del contrato, y se habilita la copia de adjuntos desde el activo inmobiliario al contrato evitando duplicados. | Paginas `Lease Contract List` y `Lease Contract Card`, codeunit `Real Estate Management`. | Facilitar la gestion operativa de documentacion contractual y reutilizar anexos ya existentes en el activo. | Impacto medio. Debe revisarse en escenarios con alto volumen de adjuntos y permisos de documentos. |
| 6 | Evolutivo | Se incorporan totales visibles en la subpagina de lineas de contrato para importe base IVA, importe IVA e importe de impuestos calculados, con refresco en carga y cambio de registro. | Pagina `Lease Contract Subform`. | Mejorar la visibilidad del importe acumulado de las lineas durante la edicion del contrato. | Riesgo bajo-medio. Conviene validar rendimiento en contratos con muchas lineas. |
| 7 | Evolutivo | Se crea una nueva funcionalidad de avisos al inquilino con cabecera, destinatarios, estados, prioridades, tipos, publicacion, simulacion de envio por correo, control de lectura en portal y relacion con activo, contrato e incidencia. | Nuevas tablas, paginas, enums y codeunits `FRE Tenant Notice*`. | Disponer de una base funcional para comunicar avisos a inquilinos desde Business Central y relacionarlos con contratos e incidencias. | Impacto alto por alta funcional nueva. Requiere pruebas funcionales completas, seguridad y validacion del flujo de publicacion/envio. |
| 8 | Evolutivo | Se anade logica para cargar destinatarios desde contratos activos/filtrados y registrar comentarios de sistema en incidencias vinculadas al publicar o comunicar avisos. | Codeunit `FRE Tenant Notice Source Mgt.`, comentarios de incidencias. | Integrar los avisos con la operativa real de contratos e incidencias para mejorar trazabilidad. | Impacto medio-alto sobre procesos relacionados entre modulos. Revisar consistencia de filtros de contratos y comentarios generados. |
| 9 | Tecnico | Se actualizan permisos de lectura/ejecucion y metadatos de extension para cubrir nuevos objetos funcionales, atributos, equipos, superficies y avisos al inquilino, junto con actualizacion de traducciones y versionado de la app. | `PermissionSet`, `extensionsPermissionSet.xml`, `Translations`, `app.json`. | Asegurar despliegue coherente de la nueva funcionalidad y disponibilidad de etiquetas/traducciones. | Riesgo medio si algun rol queda corto o sobredimensionado. Recomendable revisar seguridad por perfil. |

## Validacion y pruebas

| Prueba | Descripcion | Resultado | Evidencia |
| --- | --- | --- | --- |
| 1 | Upgrade de datos sobre base con contratos existentes, verificando inicializacion de `Type` en `Lease Contract Line`. | Pendiente | Pendiente de completar |
| 2 | Alta y edicion de lineas de contrato con `G/L Account`, `Allocation Account` y texto estandar. | Pendiente | Pendiente de completar |
| 3 | Generacion de factura de contrato con descripcion por periodo y validacion del bloqueo para lineas `Allocation Account`. | Pendiente | Pendiente de completar |
| 4 | Carga de adjuntos en contrato, copia de adjuntos desde activo y comprobacion de no duplicidad. | Pendiente | Pendiente de completar |
| 5 | Revision visual y funcional de nuevos campos en ficha de activo, ficha de contrato y totales de lineas. | Pendiente | Pendiente de completar |
| 6 | Flujo completo de aviso a inquilino: alta, destinatarios, publicacion, simulacion de envio y seguimiento de lectura. | Pendiente | Pendiente de completar |
| 7 | Validacion de permisos sobre nuevos objetos y textos traducidos en interfaz. | Pendiente | Pendiente de completar |

## Aprobaciones

| Rol | Responsable | Fecha | Estado |
| --- | --- | --- | --- |
| Desarrollo | Pendiente de completar | Pendiente de completar | Pendiente de completar |
| Negocio/Funcional | Pendiente de completar | Pendiente de completar | Pendiente de completar |
| Auditoria/Calidad | Pendiente de completar | Pendiente de completar | Pendiente de completar |

## Observaciones

- La version introduce funcionalidad nueva todavia no completamente soportada en facturacion para lineas de tipo `Allocation Account`; el comportamiento actual bloquea expresamente ese escenario.
- Existen cambios amplios de traducciones y permisos asociados a nuevos objetos que deben revisarse en el despliegue final.
- Conviene completar este registro con entorno objetivo, responsable de liberacion y evidencias de prueba antes del cierre formal de la version.
