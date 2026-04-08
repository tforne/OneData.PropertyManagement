# OneData Property Management

OneData Property Management es una extensión para Microsoft Dynamics 365 Business Central orientada a la gestión integral de activos inmobiliarios, contratos de alquiler y control financiero por inmueble.

La solución conecta la operativa diaria del negocio inmobiliario con la contabilidad y la analítica financiera en un único entorno, permitiendo trabajar con procesos más automatizados, trazables y escalables.

## Qué aporta la solución

- Gestión centralizada de activos inmobiliarios
- Administración completa de contratos de alquiler
- Facturación recurrente y liquidaciones contractuales
- Actualización de rentas mediante índices de referencia
- Control de depósitos, garantías e incidencias
- Registro de ingresos y gastos por activo
- Integración con Activos Fijos y procesos financieros de Business Central
- Preparación para integraciones externas mediante APIs

## Áreas funcionales

### Gestión de activos

La solución permite mantener una ficha avanzada del inmueble con su información operativa, documental y financiera.

- Clasificación y tipologías
- Imágenes y documentación asociada
- Datos técnicos y comerciales
- Control de disponibilidad
- Publicación en portales externos

### Gestión de contratos

Permite administrar todo el ciclo contractual del alquiler.

- Alta y mantenimiento de contratos
- Configuración flexible de líneas de alquiler
- Renovaciones y prórrogas
- Gestión de depósitos y garantías
- Liquidación automática al finalizar el contrato
- Histórico completo del arrendamiento

### Automatización financiera

La extensión incorpora capacidades para automatizar la operativa económica vinculada al inmueble.

- Facturación periódica de contratos
- Control de ingresos y gastos asociados
- Visión financiera en tiempo real
- Trazabilidad por activo inmobiliario

### Actualización de rentas

- Cálculo automático por IPC u otros índices oficiales
- Propuesta y aplicación masiva de incrementos
- Seguimiento histórico de revisiones de precio
- Registro histórico del índice de referencia de alquiler por inmueble
- Gestión de rangos mínimo y máximo de referencia

### Índice de referencia de alquiler

La solución permite mantener un histórico de precios índice de referencia de alquiler por inmueble, pensado para trabajar con consultas manuales al portal oficial `SERPAVI / MIVAU` y conservar una referencia vigente operativa dentro de Business Central.

- Apertura directa del portal oficial de consulta desde la ficha del inmueble
- Registro por fecha del precio de referencia mínimo y máximo
- Cálculo automático de la superficie construida del inmueble al informar el índice
- Cálculo automático del precio total mínimo y máximo a partir del valor por metro cuadrado y la superficie
- Marcado de una única referencia activa por inmueble
- Consulta del último precio de referencia mínimo y máximo activo desde la ficha y la lista del activo inmobiliario

### Incidencias y mantenimiento

- Registro estructurado de incidencias
- Seguimiento por estado
- Adjuntos y documentación técnica
- Histórico por inmueble o contrato

## Gestión financiera por activo

OneData Property Management incorpora un modelo específico para registrar, validar y contabilizar movimientos económicos asociados a cada activo inmobiliario.

Esto permite trabajar con:

- Cobros de alquiler
- Pagos a proveedores
- Gastos de mantenimiento
- Ajustes financieros
- Movimientos extraordinarios
- Imputación económica por inmueble

### FRE Journal

El `FRE Journal` es el punto de entrada de los movimientos financieros del activo inmobiliario.

Permite:

- Registro manual de líneas
- Importación masiva desde Excel
- Validación previa de datos
- Revisión y corrección antes del registro
- Asociación del movimiento a un activo inmobiliario
- Clasificación económica de cada línea

Cada línea puede incluir, entre otros:

- Fecha
- Tipo y número de documento
- Tipo de línea
- Activo inmobiliario
- Descripción
- Clasificación económica
- Importe
- Origen del movimiento

### Importación desde Excel

La solución permite cargar movimientos financieros mediante plantillas Excel estructuradas.

- Plantilla estándar configurable
- Hojas auxiliares con valores válidos
- Importación directa al diario FRE
- Vista previa antes del registro
- Validación de cabeceras, importes y campos obligatorios
- Detección de errores por línea

Este enfoque facilita la integración con extractos bancarios, gestores de fincas y otros sistemas externos.

### Sugerencias inteligentes de inmueble

Durante la importación y la revisión del diario, el sistema puede proponer automáticamente el `Fixed Real Estate No.` a partir de:

- La descripción del movimiento
- La información informada en la plantilla Excel
- Coincidencias con el catálogo de inmuebles
- Patrones históricos

Con ello se reduce trabajo manual y se mejora la imputación económica por activo.

### Validación y registro

Antes del registro definitivo, el sistema valida la coherencia de la información:

- Campos obligatorios
- Coherencia documental
- Existencia del activo inmobiliario
- Coherencia de clasificación
- Control de importes

Una vez validado, el diario se registra siguiendo una lógica alineada con los diarios estándar de Business Central:

- Procesamiento del lote
- Generación de movimientos históricos
- Registro en el libro FRE
- Limpieza de líneas del diario
- Trazabilidad completa

### FRE Ledger

El `FRE Ledger` constituye el histórico financiero del activo inmobiliario y permite:

- Seguimiento de ingresos y gastos por inmueble
- Auditoría financiera
- Consulta histórica de movimientos
- Acceso directo desde la ficha del activo

## Flujo funcional

| Fase 1 | Fase 2 | Fase 3 | Fase 4 | Fase 5 |
|---|---|---|---|---|
| **Entrada manual o Excel** | **FRE Journal** | **Sugerencias automáticas de activo** | **Validación de datos** | **Registro del diario** |

**Ruta principal**

`Entrada manual o Excel` → `FRE Journal` → `Sugerencias automáticas de activo` → `Validación de datos` → `Registro del diario` → `FRE Ledger`

**Si existen errores**

`Validación de datos` → `Corrección de líneas` → `FRE Journal`

**Resultado final**

- `FRE Ledger`
- `Consulta desde la ficha del inmueble`
- `Integración contable y financiera`
- `Informes y análisis por activo`

## Integración con Business Central

OneData Property Management trabaja de forma integrada con procesos estándar de Business Central:

- Gestión financiera
- Clientes
- Facturación
- Contabilidad general
- Documentos registrados
- Informes financieros

### Integración con Activos Fijos

El modelo contempla la relación entre inmuebles y activos fijos.

- Vínculo exclusivo: `1 activo inmobiliario ↔ 1 activo fijo`
- Vínculo compartido controlado: `varios inmuebles ↔ 1 activo fijo`
- Definición de activo principal
- Control de porcentajes de distribución hasta `100%`

## Arquitectura funcional

| Capa | Elementos principales | Propósito |
|---|---|---|
| **Operación inmobiliaria** | `Activos inmobiliarios` y `Contratos de alquiler` | Gestionar inmuebles, contratos y contexto operativo |
| **Procesos de negocio** | `Facturación recurrente` y `FRE Journal / FRE Ledger` | Ejecutar el ciclo económico y registrar movimientos |
| **Core financiero** | `Finanzas de Business Central` | Integrar contabilidad, documentos registrados y control financiero |
| **Explotación del dato** | `Reporting y análisis` | Obtener visibilidad financiera y operativa por activo |

**Relación entre capas**

`Activos inmobiliarios` → `Contratos de alquiler` → `Facturación recurrente`

`Activos inmobiliarios` + `Contratos de alquiler` → `FRE Journal / FRE Ledger`

`Facturación recurrente` + `FRE Journal / FRE Ledger` → `Finanzas de Business Central`

`Finanzas de Business Central` → `Reporting y análisis`

## Plataforma y requisitos

- Producto: `OneData Property Management`
- Publisher: `OneData`
- Versión actual: `3.0.26099.86`
- Plataforma objetivo: `Microsoft Dynamics 365 Business Central`
- Aplicación: `25.0.0.0`
- Runtime: `15.0`
- Versión mínima recomendada: `Business Central 24`
- Modalidad: `SaaS` y `On-Premise`

## Recursos

- Ayuda: <https://tforne.github.io/OneData.PropertyManagement/>
- Solución: <https://tforne.github.io/OneData.PropertyManagement/docs/solutions/property-management/>

## Tecnología

- Desarrollo en `AL`
- Arquitectura modular y escalable
- APIs REST nativas
- Seguridad basada en `Permission Sets`
- Diseño orientado a entornos de alta exigencia operativa

## Beneficios

- Automatización del ciclo completo del alquiler
- Control financiero centralizado por activo
- Registro estructurado de cobros y pagos
- Importación masiva de movimientos
- Validación previa al registro
- Trazabilidad histórica por inmueble
- Escalabilidad para carteras de gran volumen

## OneData

OneData desarrolla soluciones verticales sobre Microsoft Dynamics 365 Business Central con foco en procesos empresariales complejos, integración financiera y escalabilidad operativa.
