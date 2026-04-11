# Guía de funcionamiento

## Automatización de índices de alquiler en OneData Property Management

## Objetivo

Este documento explica cómo funciona la automatización de índices de alquiler dentro de `OneData Property Management`, qué partes del proceso están automatizadas y qué intervención sigue siendo manual.

La funcionalidad está pensada para:

- consultar índices oficiales aplicables a contratos de alquiler,
- generar una propuesta de revisión de renta,
- dejar trazabilidad del cálculo,
- apoyar la aplicación posterior del incremento dentro de Business Central.

## Alcance funcional

La solución cubre actualmente dos bloques diferenciados:

### 1. Revisión anual de renta del contrato

Se basa en índices oficiales publicados por el `INE`:

- `IPC`
- `IRAV`

Con estos índices, el sistema puede:

- determinar qué índice corresponde al contrato,
- consultar el valor oficial vigente,
- guardar el porcentaje de incremento,
- generar una propuesta de revisión en la tabla de trabajo `Price Increases by Refer index`.

### 2. Índice de referencia del alquiler del inmueble

Se apoya en el portal oficial `SERPAVI / MIVAU`.

En este bloque, el sistema:

- abre el portal oficial desde la ficha del inmueble,
- prepara la búsqueda con la mejor información disponible,
- permite registrar manualmente el rango mínimo y máximo obtenido,
- mantiene un histórico por inmueble.

Esta parte no calcula automáticamente el resultado final desde `SERPAVI`, porque el portal oficial requiere validación interactiva.

## Fuentes oficiales utilizadas

### INE

Para la revisión de rentas, la solución consume información oficial publicada por el `INE`.

- `IPC`: usado para contratos anteriores al `26/05/2023`
- `IRAV`: usado para contratos posteriores al `26/05/2023`

### MIVAU / SERPAVI

Para el rango de referencia del alquiler del inmueble, la solución utiliza el portal oficial del Ministerio:

- apertura directa del portal `SERPAVI`,
- apoyo a la búsqueda,
- registro posterior manual del resultado.

## Criterio de selección del índice

Cuando se lanza la actualización desde un contrato, la solución revisa el campo `Consumer Price Index Category`.

### Si el contrato ya tiene categoría informada

Se respeta la categoría existente:

- `IPC`
- `IRAV`

### Si el contrato no tiene categoría informada

La solución la infiere automáticamente:

- contratos con fecha igual o posterior al `26/05/2023` -> `IRAV`
- contratos anteriores -> `IPC`

La fecha utilizada para decidirlo es:

1. `Contract Date`
2. si no existe, `Starting Date`

## Flujo funcional de revisión de renta

## Paso 1. Abrir la ficha del contrato

Desde la página `Lease Contract Card`, el usuario accede a la acción:

- `Actualizar revisión alquiler`

Esta acción solo está pensada para contratos en estado `Signed`.

## Paso 2. Resolución automática del índice

Al ejecutar la acción, el sistema:

1. valida que existe contrato,
2. garantiza que las categorías oficiales `IPC` e `IRAV` existen en la parametrización,
3. determina qué índice corresponde al contrato,
4. consulta el valor oficial vigente.

## Paso 3. Cálculo de la base

El sistema busca la base sobre la que debe aplicar el incremento.

### Prioridad de cálculo

1. suma de líneas del contrato marcadas con `Aplicar incrementos = true`
2. si no hay líneas aplicables, usa `Amount per Period`

Esto permite trabajar tanto con contratos simples como con contratos con varias líneas repercutibles.

## Paso 4. Generación de la propuesta

La solución crea o actualiza una línea en:

- `Price Increases by Refer index`

La propuesta guarda:

- contrato,
- inmueble,
- cliente,
- contacto,
- categoría del índice,
- año de revisión,
- porcentaje aplicado,
- base de cálculo,
- importe resultante,
- fecha sugerida de inicio del incremento.

Si ya existe una propuesta para el mismo contrato, año y categoría, la línea se actualiza en lugar de duplicarse.

## Paso 5. Revisión por el usuario

Tras generar la propuesta, se abre la worksheet de revisión para que el usuario pueda:

- revisar el porcentaje,
- revisar la base de cálculo,
- ajustar la fecha de inicio del incremento,
- validar el importe resultante.

## Paso 6. Aplicación posterior

La propuesta no sustituye automáticamente el contrato en ese mismo paso.

El flujo previsto es:

1. generar propuesta,
2. revisar,
3. aplicar incremento mediante el proceso estándar de la worksheet y reportes existentes.

## Datos que se guardan en el sistema

## Tabla `Consumer Price Index Categorie`

Mantiene el catálogo de categorías de índice.

Actualmente se usan:

- `IPC`
- `IRAV`

## Tabla `Consumer Price Index`

Guarda el valor porcentual disponible para una categoría y un año.

Ejemplo:

- categoría: `IPC`
- año: `2026`
- porcentaje: `2,3`

## Tabla `Price Increases by Refer index`

Es la tabla operativa donde se genera la propuesta de revisión de renta para contratos.

## Tabla `Reference Index Rental Prices`

Guarda el histórico del rango de referencia del alquiler por inmueble consultado en `SERPAVI`.

## Funcionamiento del bloque SERPAVI

## Desde la ficha del inmueble

En `Fixed Real Estate Card` existe la acción:

- `Consultar indice alquiler MIVAU`

## Qué hace esta acción

La solución:

1. verifica que el inmueble corresponde a España,
2. intenta completar la referencia catastral desde `Catastro` si falta,
3. genera el mejor texto de búsqueda disponible,
4. copia ese texto al portapapeles,
5. abre `SERPAVI` en el navegador.

## Qué sigue siendo manual

El usuario debe:

1. completar o validar la búsqueda en el portal oficial,
2. consultar el rango de referencia,
3. registrar el resultado en `Precios Indices de referencia`.

## Histórico del índice de referencia del inmueble

En la página `Reference Index Rental Prices` se registran:

- fecha,
- superficie,
- precio mínimo por metro cuadrado,
- precio máximo por metro cuadrado,
- precio mínimo total,
- precio máximo total,
- indicador de registro activo,
- comentarios.

### Reglas de funcionamiento

- la superficie puede calcularse automáticamente desde el inmueble,
- el precio total mínimo y máximo se recalcula automáticamente,
- solo debe existir un registro activo por inmueble.

## Qué está automatizado y qué no

## Automatizado

- alta automática de categorías oficiales `IPC` e `IRAV`,
- inferencia automática del índice aplicable al contrato,
- consulta del valor oficial vigente,
- generación o actualización de la propuesta de revisión,
- cálculo del importe sugerido,
- apertura guiada de `SERPAVI`,
- apoyo desde `Catastro` para mejorar la búsqueda del inmueble.

## No automatizado todavía

- lectura directa del resultado individualizado de `SERPAVI`,
- aplicación totalmente desatendida del incremento al contrato,
- integración de índices autonómicos,
- planificación masiva automática por calendario.

## Recomendaciones de uso

- revisar que `Contract Date` o `Starting Date` estén correctamente informados,
- revisar qué líneas del contrato tienen marcado `Aplicar incrementos`,
- validar manualmente la propuesta antes de implantarla,
- mantener actualizado el histórico `SERPAVI` del inmueble cuando se consulte,
- no usar el rango `SERPAVI` como sustituto automático del índice legal de revisión anual del contrato.

## Ejemplo práctico

### Caso

- contrato firmado el `01/07/2024`
- importe base mensual revisable: `850,00`
- categoría vacía

### Resultado esperado

1. la solución infiere `IRAV`,
2. consulta el último valor oficial disponible,
3. guarda ese porcentaje para el año correspondiente,
4. genera una propuesta en la worksheet,
5. calcula el incremento sobre `850,00`,
6. propone la fecha de inicio en el aniversario del contrato.

## Limitaciones conocidas

- el formato de publicación de los organismos oficiales puede cambiar,
- si cambia el contenido público de `INE` o `MIVAU`, puede requerirse ajuste técnico,
- la automatización actual está orientada a España,
- `SERPAVI` sigue siendo un flujo asistido, no cerrado de extremo a extremo.

## Objetos principales implicados

- `Lease Contract`
- `Lease Contract Card`
- `Consumer Price Index`
- `Consumer Price Index Categorie`
- `Price Increases by Refer index`
- `Reference Index Rental Prices`
- `Catastro Service Mgt.`
- `SERPAVI Service Mgt.`
- `INE Rental Index Mgt.`

## Resumen operativo

La funcionalidad separa claramente dos necesidades:

- la revisión legal anual de la renta del contrato, automatizada con `IPC` o `IRAV`,
- el histórico de referencia de mercado del inmueble, asistido mediante `SERPAVI`.

Con ello, OneData Property Management permite reducir trabajo manual, mejorar la trazabilidad y dar un marco operativo más sólido para la actualización de rentas dentro de Business Central.
