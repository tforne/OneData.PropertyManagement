# Roadmap

## OneData Property Management

Este roadmap organiza la evolución funcional y técnica de la solución con un enfoque orientado a producto, valor de negocio y entregas incrementales.

## Cómo leer este roadmap

- `Now`: trabajo inmediato o de corto plazo
- `Next`: trabajo previsto tras estabilizar el bloque actual
- `Later`: evolución estratégica o de medio plazo
- `Done`: capacidades ya incorporadas o cerradas recientemente

## Principios de priorización

- Impacto directo en la operativa diaria
- Trazabilidad financiera por activo inmobiliario
- Reducción de trabajo manual
- Capacidad de integración con Business Central estándar
- Escalabilidad funcional para carteras más complejas

## Líneas estratégicas

- Activos inmobiliarios
- Contratos y facturación
- Finanzas FRE
- Integración con diario general y contabilidad
- Incidencias, mantenimiento y seguros
- Fiscalidad y reporting
- Seguridad, permisos y administración
- APIs, portal e integraciones externas
- Producto, documentación y experiencia

## Now

### Finanzas FRE

- Estabilizar la integración `Gen. Journal` -> `FRE Ledger Entry`
- Completar la integración automática de amortización de activos fijos con FRE
- Parametrizar filas y categorías FRE para escenarios contables recurrentes
- Validar signos, distribución y trazabilidad entre `G/L Entry` y `FRE Ledger Entry`
- Consolidar la carga desde extracto bancario al diario general

### Importación y extractos

- Mejorar la importación desde Excel a `FRE Journal` y `Gen. Journal`
- Mantener vista previa, validación y sugerencias de activo
- Consolidar diarios y secciones por defecto para extractos bancarios
- Reducir pasos redundantes cuando la importación se lanza desde el diario actual

### Incidencias y seguros

- Cerrar la fase 1 de pólizas por activo inmobiliario
- Mantener selección de póliza desde la incidencia
- Permitir notificación manual al seguro
- Guardar estado básico del siniestro y fecha de comunicación

### Seguridad y administración

- Crear y revisar permisos `ODPM ADMIN`
- Definir permisos `ODPM USER`
- Definir permisos `ODPM READ`
- Definir permisos `ODPM SETUP`
- Revisar acceso a objetos de importación, incidencias, seguros y finanzas FRE

### Producto y documentación

- Mantener README funcional alineado con la realidad de la solución
- Mejorar la landing pública de la solución
- Documentar flujos clave: extractos, integración FRE, incidencias y seguros

## Next

### Activos y contratos

- Mejorar la experiencia de ficha del activo inmobiliario
- Ampliar trazabilidad entre inmueble, contrato, incidencia y movimiento
- Reforzar la copia y reutilización de contratos
- Mejorar resúmenes y vistas consolidadas de contrato

### Finanzas y explotación

- KPIs financieros por activo inmobiliario
- Indicadores de rentabilidad, ocupación e histórico de movimientos
- Mayor detalle analítico por tipo de ingreso o gasto
- Mejora de dashboards de `FRE RC` y role centers

### Seguros e incidencias

- Fase 2 del expediente de siniestro
- Gestión más completa de estados del siniestro
- Notificación automática cuando proceda
- Plantillas de correo por aseguradora
- Adjuntos automáticos al comunicar incidencias al seguro

### Fiscalidad

- Consolidar escenarios de IRPF ligados al alquiler
- Mejorar trazabilidad entre movimientos y reporting fiscal
- Preparar la integración funcional con soluciones fiscales del ecosistema OneData

### Integración estándar Business Central

- Mejorar integración con activos fijos
- Revisar integración con procesos de posting estándar
- Reducir dependencias de procesos manuales para imputación FRE
- Añadir más automatismos desde diarios y procesos batch estándar

## Later

### Ecosistema digital

- Portal del inquilino
- Portal del propietario
- Integraciones móviles para incidencias y visitas
- Sincronización documental avanzada con SharePoint y Microsoft 365

### Automatización avanzada

- Sugerencias inteligentes de clasificación económica
- Sugerencias automáticas de activo inmobiliario más precisas
- Automatización de conciliación y cobros
- Reglas avanzadas de imputación por inmueble o cartera

### Reporting y portfolio management

- Cuadro de mando por cartera
- Rentabilidad comparada por activo
- Seguimiento de evolución de rentas y gastos
- Indicadores para family office, patrimonialistas y gestores

### Arquitectura producto

- Revisión modular por dominios funcionales
- Separación progresiva entre core inmobiliario, finanzas FRE y portal
- Estrategia multiempresa y multicartera

## Done

### Finanzas FRE e importación

- Importación desde Excel al `FRE Journal`
- Importación desde Excel al `Gen. Journal`
- Vista previa de importación
- Importación desde extracto bancario
- Configuración de diarios por defecto en extractos bancarios
- Integración desde `Gen. Journal` hacia `FRE Ledger Entry`

### Incidencias y seguros

- Tabla de pólizas de seguro
- Páginas de pólizas y subpágina en el activo inmobiliario
- Campos de seguro en incidencias
- Acción de notificación manual al seguro

### UX y documentación

- README ampliado con nuevas funcionalidades
- Landing de solución actualizada
- Mejora visual de bloques funcionales de la landing

## Formato recomendado para seguimiento detallado

Cada iniciativa puede desglosarse después en una tabla como esta:

| Iniciativa | Área | Valor | Complejidad | Dependencias | Estado | Versión objetivo |
|---|---|---|---|---|---|---|
| Integración amortización -> FRE | Finanzas FRE | Alta | Media | REF Setup, FA Links | In Progress | 3.1 |
| Permisos ODPM USER | Seguridad | Alta | Baja | Inventario de objetos | Planned | 3.1 |
| Fase 2 siniestros | Seguros | Media | Media | Pólizas, incidencias | Planned | 3.2 |

## Próxima revisión sugerida

- Revisar este roadmap al cierre de cada versión
- Mover iniciativas entre `Now`, `Next` y `Later` según validación funcional
- Mantener separado el backlog técnico de bajo nivel del roadmap de producto
