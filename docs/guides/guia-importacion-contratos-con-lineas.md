# Guía de importación de contratos de alquiler con líneas

## Objetivo

La funcionalidad `OD Lease Contract Import List` permite importar contratos de alquiler desde Excel.

Ahora soporta dos modalidades:

1. Importación de solo cabecera de contrato.
2. Importación de cabecera y líneas económicas del contrato en el mismo lote.

La importación reutiliza la estructura real del módulo:

- Cabecera: `Lease Contract` (`Table 96018`)
- Líneas: `Lease Contract Line` (`Table 96019`)

No crea una estructura contractual paralela para el contrato final.

---

## Objetos implicados

### Importación

- `Table 96993 "OD Lease Contract Import"`
- `Page 96995 "OD Lease Contract Import List"`
- `Codeunit 96994 "OD Lease Contract Import Mgt."`

### Contratos reales

- `Table 96018 "Lease Contract"`
- `Table 96019 "Lease Contract Line"`
- `Page 96031 "Lease Contract Card"`
- `Page 96032 "Lease Contract Subform"`

---

## Flujo general

El proceso trabaja en este orden:

1. Descargar plantilla Excel.
2. Rellenar una o varias filas.
3. Importar Excel.
4. Validar lote.
5. Corregir errores si existen.
6. Crear contratos.
7. Abrir el contrato creado para revisión.

---

## Dos escenarios soportados

## 1. Solo cabecera

Si una fila contiene únicamente datos de cabecera y no informa columnas de línea, el sistema:

- crea un contrato;
- no crea líneas económicas;
- deja el contrato preparado para completar posteriormente desde la UI.

## 2. Cabecera + líneas

Si las filas contienen también columnas de línea, el sistema:

- agrupa las filas que pertenecen al mismo contrato;
- crea una sola cabecera;
- crea después todas las líneas del contrato usando la tabla real `Lease Contract Line`.

---

## Agrupación de filas

Para saber qué filas pertenecen al mismo contrato, el proceso usa este criterio:

1. Si existe `Contract Import Key`, agrupa por ese valor.
2. Si no existe `Contract Import Key`, pero sí `Contract No.`, agrupa por `Contract No.`.
3. Si no existe ninguno de los dos, la fila se trata como contrato independiente.

### Recomendación

Cuando se importen varias líneas para un contrato nuevo cuyo número definitivo todavía no existe, se debe informar `Contract Import Key`.

Ejemplo:

- Fila 2: `Contract Import Key = CT-001`
- Fila 3: `Contract Import Key = CT-001`
- Fila 4: `Contract Import Key = CT-001`

Las tres filas crearán una sola cabecera de contrato con tres líneas.

---

## Columnas de cabecera

Las columnas de cabecera soportadas son:

- `Contract No.`
- `Description`
- `Customer No.`
- `Second Customer No.`
- `Fixed Real Estate No.`
- `Contract Date`
- `Starting Date`
- `Expiration Date`
- `Invoice Period`
- `Annual Amount`
- `Payment Method Code`
- `Payment Terms Code`
- `Contract Import Key`

### Campos mínimos de cabecera

Como mínimo, deben existir:

- `Description`
- `Customer No.`
- `Fixed Real Estate No.`
- `Starting Date`

---

## Columnas de línea

Las columnas de línea soportadas son:

- `Line Type`
- `No. Cuenta`
- `Descripcion`
- `Valor de linea`
- `Line Starting Date`
- `Line Expiration Date`
- `Line Service Period`
- `Line VAT Bus. Posting Group`
- `Grupo registro IVA producto`
- `Line Shortcut Dim. 1 Code`
- `Line Shortcut Dim. 2 Code`
- `Line Apply Increments`
- `Line Apply Taxes`
- `Line Base Contract`

### Campos mínimos de línea

Si una fila incluye datos de línea, como mínimo debe informar:

- `Line Type`
- `Line Account No.`

`Line Description` es recomendable. Si no se informa, el proceso intentará crear la línea con una descripción derivada.

---

## Tipos de línea soportados

Actualmente se admiten los tipos reales de `Lease Contract Line Type`:

- `G/L Account`
- `Allocation Account`
- `Standard Text`

La importación traduce el texto recibido en Excel a esos tipos reales.

Ejemplos válidos:

- `G/L Account`
- `Allocation Account`
- `Standard Text`

---

## Validaciones de cabecera

Durante la validación del lote se comprueba, entre otros:

- que exista descripción;
- que exista cliente;
- que exista activo inmobiliario;
- que el activo exista y sea de tipo `Activo`;
- que la fecha de inicio exista;
- que la fecha fin no sea anterior a la de inicio;
- que la forma de pago exista;
- que los términos de pago existan;
- que el período de facturación sea válido;
- que el número de contrato no exista previamente si viene informado.

---

## Validaciones de línea

Si la fila contiene datos de línea, se comprueba además:

- que `Line Type` sea válido;
- que `Line Account No.` exista para ese tipo;
- que las fechas de línea sean coherentes;
- que el `Line Service Period` pueda evaluarse correctamente.

---

## Validación de consistencia por grupo

Si varias filas pertenecen al mismo contrato, el sistema verifica que los datos de cabecera coincidan entre ellas.

Ejemplos de conflicto:

- misma `Contract Import Key`, pero distinto `Customer No.`;
- misma `Contract Import Key`, pero distinta `Starting Date`;
- misma `Contract Import Key`, pero distinto `Fixed Real Estate No.`

Si hay conflicto, el grupo se marca con error porque no puede crear una cabecera única coherente.

---

## Creación del contrato

Cuando se procesa el lote:

1. Se crea la cabecera real en `Lease Contract`.
2. Se aplican las validaciones reales de cabecera mediante `Validate(...)`.
3. Si el grupo contiene líneas, se crean las líneas reales en `Lease Contract Line`.

Las líneas finales:

- no se guardan en una tabla intermedia contractual;
- se crean directamente en la tabla real del contrato;
- respetan la lógica existente del módulo.

---

## Cómo se crean las líneas finales

Por cada fila de importación con datos de línea, el sistema:

1. calcula el siguiente `Line No.`;
2. crea la línea en `Lease Contract Line`;
3. aplica `Validate(Type, ...)`;
4. aplica `Validate("Account No.", ...)`;
5. aplica `Validate(Description, ...)` cuando corresponda;
6. aplica `Validate(Value, ...)`;
7. informa fechas, VAT, dimensiones y flags adicionales.

Esto hace que la línea resultante tenga el mismo destino funcional que una línea creada desde la ficha del contrato.

---

## Compatibilidad hacia atrás

La importación existente de solo cabeceras sigue funcionando.

Si no se informan columnas de línea:

- no hay obligación de usar `Contract Import Key`;
- no se crean líneas;
- el contrato se genera como antes.

---

## Ejemplo de uso

## Caso 1. Un contrato con una sola línea

Tres columnas clave:

- `Contract Import Key = CT-001`
- `Customer No. = C00010`
- `Fixed Real Estate No. = FRE-0001`

Y una línea:

- `Line Type = G/L Account`
- `Line Account No. = 70500000`
- `Line Description = Renta mensual`
- `Line Value = 950`

Resultado:

- 1 contrato creado
- 1 línea económica creada

## Caso 2. Un contrato con tres líneas

Tres filas con la misma `Contract Import Key = CT-002`:

- línea 1: renta
- línea 2: gastos de comunidad
- línea 3: servicios adicionales

Resultado:

- 1 contrato creado
- 3 líneas económicas creadas

---

## Recomendaciones de uso

- Usar siempre `Contract Import Key` cuando un contrato ocupe varias filas.
- Mantener exactamente la misma cabecera en todas las filas del mismo grupo.
- Validar el lote antes de procesarlo.
- Revisar los contratos creados desde la acción `Ver contrato creado`.

---

## Limitaciones actuales

- La importación ampliada incorpora líneas económicas, pero no crea todavía unidades contractuales en `OD AM Lease Contract Unit`.
- Si se necesita importar también activos adicionales, parkings o trasteros, será necesaria una segunda ampliación del proceso.

---

## Resumen

La importación rediseñada permite:

- importar contratos simples sin líneas;
- importar contratos completos con varias líneas;
- agrupar varias filas en una sola cabecera contractual;
- crear las líneas finales usando la estructura real de `Lease Contract Line`.

Esto mejora la mantenibilidad y evita duplicar la lógica contractual del sistema.
