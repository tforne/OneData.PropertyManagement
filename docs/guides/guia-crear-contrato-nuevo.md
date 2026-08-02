# Guía funcional para crear un contrato nuevo

## 1. Objetivo del documento

Esta guía explica cómo crear un contrato nuevo dentro de `OneData Property Management`, qué información debe introducirse en la cabecera, cómo registrar correctamente las líneas del contrato y qué validaciones conviene revisar antes de firmarlo.

El objetivo es que el contrato quede:

- correctamente identificado,
- vinculado al activo inmobiliario adecuado,
- asociado al arrendador o arrendadores correctos,
- preparado para facturación,
- y listo para pasar a estado firmado sin errores funcionales.

## 2. Alcance funcional

Esta guía cubre:

- creación manual de un contrato nuevo,
- cumplimentación de la cabecera del contrato,
- alta de líneas de facturación,
- revisión previa a la firma,
- acciones complementarias disponibles en la ficha,
- y errores frecuentes durante el proceso.

No cubre en detalle:

- facturación periódica del contrato,
- liquidación final del contrato,
- revisiones automáticas de renta,
- contabilización posterior,
- ni procesos avanzados de copia entre empresas más allá de una referencia funcional.

## 3. Cuándo debe crearse un contrato

Conviene crear el contrato cuando ya existe una relación operativa o jurídica suficientemente definida entre el inmueble y el cliente o arrendador correspondiente, y se necesita dejar preparada la información para gestión, seguimiento y facturación.

En términos prácticos, el contrato debería darse de alta cuando:

- el activo inmobiliario ya existe en el sistema,
- el cliente vinculado está dado de alta,
- se conocen las fechas básicas del contrato,
- y ya se dispone de los conceptos que se van a facturar mediante líneas.

## 4. Prerrequisitos

Antes de comenzar, conviene verificar:

1. El `activo inmobiliario` ya existe y está correctamente identificado.
2. El `cliente` o arrendador principal ya existe en Business Central.
3. Se dispone de las fechas clave del contrato:
   - fecha de contrato,
   - fecha de inicio,
   - duración o fecha de vencimiento.
4. Se conoce el comercial o responsable que se informará en `Salesperson Code`.
5. Se dispone de los conceptos contables o cuentas que se utilizarán en las líneas del contrato.
6. La configuración general de la solución está correctamente creada, especialmente la serie de numeración de contratos.

## 5. Resultado esperado

Al finalizar el proceso, el usuario debería obtener:

- un `Contract No.` generado automáticamente,
- una cabecera de contrato completa,
- una o varias líneas con importe y fiscalidad informados,
- un estado listo para firma,
- y un contrato preparado para facturación y seguimiento posterior.

## 6. Acceso al proceso

El alta se realiza desde la lista de contratos, normalmente identificada como:

- `Lease Contract List`
- o `Contratos`

Desde esa lista se accede a la ficha `Lease Contract Card`, que es la pantalla principal de mantenimiento del contrato.

## 7. Procedimiento para crear un contrato nuevo

### 7.1. Crear el registro

1. Abrir la lista de contratos.
2. Pulsar `Nuevo`.
3. Guardar el registro para que el sistema genere automáticamente el `Contract No.`.

Observación funcional:

- Si el número de contrato no se informa manualmente, el sistema lo asigna automáticamente usando la serie configurada para contratos.

### 7.2. Cumplimentar la cabecera general

Una vez creado el registro, completar la información básica del contrato.

Campos recomendados:

- `Description`
- `Fixed Real Estate No.`
- `Customer No.`
- `Salesperson Code`
- `Contract Date`
- `Starting Date`
- `Lease Period`
- `Expiration Date`
- `Invoice Period`
- `Payment Method Code`
- `Payment Terms Code`
- `Grupo IRPF`, si aplica
- `Preferred Bank Account Code`, si aplica

Recomendación funcional:

- Introducir primero el inmueble y el cliente principal, porque varios datos de contexto del contrato dependen de ellos.

### 7.3. Informar el activo inmobiliario

En el campo `Fixed Real Estate No.` se selecciona el inmueble al que corresponde el contrato.

Al informar este campo, el sistema arrastra automáticamente información relacionada, como por ejemplo:

- descripción del activo,
- dirección,
- ciudad,
- código postal,
- país o región,
- enlace de mapa o `Google URL`,
- y determinados contactos relacionados.

Buenas prácticas:

- Verificar que el inmueble seleccionado es el correcto antes de continuar.
- Revisar que la dirección mostrada en la ficha coincide con el activo esperado.

### 7.4. Informar el arrendador principal

En el campo `Customer No.` se selecciona el cliente principal del contrato.

Cuando se informa este campo, el sistema muestra o calcula datos relacionados como:

- nombre,
- dirección,
- ciudad,
- código postal,
- país,
- y otros datos vinculados al cliente.

Además, el contrato puede completar información de contacto asociada al cliente.

Recomendación funcional:

- Validar que el cliente seleccionado es realmente la entidad que debe figurar como arrendador principal.

### 7.5. Informar contactos

Si el contrato requiere un contacto operativo, deben revisarse estos campos:

- `Contact No.`
- `Contact Name`
- `Phone No.`
- `E-Mail`

Si se selecciona un contacto, conviene confirmar que está relacionado con el cliente correcto.

Esto es importante porque la solución valida la coherencia entre contacto y cliente.

### 7.6. Informar un segundo arrendador si aplica

Si el contrato tiene un segundo arrendador:

1. Usar la acción `Show` para mostrar la sección del segundo arrendador cuando no esté visible.
2. Informar:
   - `Second Customer No.`
   - `Second Contact No.`
   - y, si corresponde, revisar sus datos derivados.

Buenas prácticas:

- No completar el segundo arrendador salvo que realmente forme parte del contrato.
- Si existe, validar también sus datos de contacto y comunicación.

### 7.7. Informar fechas del contrato

Las fechas más relevantes son:

- `Contract Date`
- `Starting Date`
- `Lease Period`
- `Expiration Date`

Criterio recomendado:

- Informar siempre `Starting Date`.
- Usar `Lease Period` cuando la duración se gestione mediante fórmula.
- Revisar que `Expiration Date` quede bien calculada o bien informada manualmente.

Importancia funcional:

- `Starting Date` es obligatoria para poder trabajar correctamente con las líneas y para poder firmar el contrato.

### 7.8. Informar condiciones de pago y facturación

Completar, como mínimo:

- `Invoice Period`
- `Payment Method Code`
- `Payment Terms Code`

Dependiendo de la forma de pago, el sistema puede completar automáticamente condiciones de pago relacionadas.

Recomendación funcional:

- Confirmar que el `Invoice Period` refleja el ciclo real del contrato:
  - mensual,
  - bimestral,
  - trimestral,
  - semestral,
  - anual,
  - o sin facturación periódica.

### 7.9. Informar datos fiscales y complementarios

Según el caso, revisar también:

- `Grupo IRPF`
- `Prices Services Including VAT`
- `Consumer Price Index Category`
- `Generic Prod. Posting Gr.`
- `Customer Template Code`

Estos campos pueden influir en:

- retenciones,
- grupos contables,
- revisiones futuras de renta,
- o generación de líneas complementarias.

## 8. Alta de líneas del contrato

Una vez completada la cabecera, el siguiente paso es introducir las líneas del contrato.

Cada línea representa un concepto económico o facturable asociado al contrato.

### 8.1. Crear una línea

En la subpágina de líneas:

1. Insertar una nueva línea.
2. Completar como mínimo:
   - `Account No.`
   - `Description`
   - `Amount`
   - `VAT Prod. Posting Group`

El sistema también puede completar información contable y fiscal derivada de la cuenta seleccionada.

### 8.2. Datos recomendados por línea

Además de los mínimos anteriores, conviene revisar:

- `Value`
- `VAT %`
- `VAT Amount`
- `VAT Base Amount`
- `Shortcut Dimension 1 Code`
- `Aplicar incrementos`
- `Aplicar Impuestos`
- `Contract Expiration Date`
- `Credit Memo Date`

### 8.3. Comportamiento automático de una línea nueva

Cuando se crea una línea nueva, la solución hereda por defecto datos desde la cabecera, entre ellos:

- `Customer No.`
- `Contract Status`
- `Contract Expiration Date`
- `Credit Memo Date`
- `Service Period`

Esto ayuda a que la línea nazca alineada con el contrato, aunque siempre debe revisarse antes de guardar.

### 8.4. Validaciones importantes en líneas

Para que una línea pueda insertarse correctamente, el contrato debe tener informados:

- `Contract No.`
- `Customer No.`
- `Starting Date`

Además:

- la línea debe tener `Description`,
- la fecha de expiración de la línea no puede ser anterior a su fecha de inicio,
- y no debería quedar con importe cero si el contrato va a firmarse.

## 9. Revisión previa a la firma

Antes de firmar el contrato, conviene hacer una comprobación funcional completa.

### 9.1. Revisión de cabecera

Confirmar al menos:

- `Fixed Real Estate No.` correcto
- `Customer No.` correcto
- `Salesperson Code` informado
- `Starting Date` informada
- `Invoice Period` correcto
- `Payment Method Code` correcto
- `Payment Terms Code` correcto

### 9.2. Revisión de líneas

Confirmar:

- que existen líneas,
- que todas tienen `Description`,
- que todas tienen importe informado,
- que no hay líneas con `Amount = 0`,
- y que la fiscalidad es coherente.

### 9.3. Qué ocurre al firmar

Al ejecutar la acción `Sign Contract`, la solución:

- valida el estado del contrato,
- revisa datos obligatorios,
- cambia el estado de las líneas a `Signed`,
- calcula `Amount per Period`,
- calcula `Annual Amount`,
- y deja el contrato en estado `Signed`.

Si existe facturación periódica y corresponde facturar el período inicial, el sistema puede preguntar si debe generar la facturación de ese intervalo.

## 10. Firma del contrato

Cuando todo esté revisado:

1. Pulsar `Sign Contract`.
2. Confirmar la operación.
3. Revisar que el estado pase a `Signed`.
4. Comprobar que `Amount per Period` y `Annual Amount` quedan calculados.

Recomendación funcional:

- No firmar el contrato hasta haber validado cabecera y líneas, porque a partir de ese momento el contrato entra en un estado operativo más controlado.

## 11. Acciones complementarias útiles

Dentro de la ficha del contrato existen varias acciones que pueden ayudar durante la gestión:

### 11.1. `Rentals Deposit`

Permite registrar y consultar fianzas asociadas al contrato.

### 11.2. `Attachments` y `Upload files`

Permiten adjuntar documentación, por ejemplo:

- borrador del contrato,
- contrato firmado,
- anexos o addendas,
- inventario inicial, si aplica,
- documento de fianza o resguardo relacionado,
- comunicaciones relevantes entre las partes,
- documentación legal o administrativa de soporte.

Observación:

- para adjuntar archivos, el contrato debe estar previamente guardado.

Recomendación funcional:

- Adjuntar al menos la versión firmada del contrato cuando ya esté formalizado.
- Si existen anexos económicos o cláusulas adicionales, dejarlos en el mismo registro para mantener la trazabilidad documental completa.

### 11.3. `Related contacts`

Permite revisar contactos relacionados con el contrato.

### 11.4. `Copy owner from FRE`

Permite copiar propietarios relacionados desde el activo inmobiliario al contrato.

Esto puede ser útil cuando el contrato debe reutilizar relaciones ya definidas en la ficha del inmueble.

### 11.5. `Copiar desde otra empresa`

Permite copiar cabecera y/o líneas desde un contrato existente en otra empresa.

Su uso es recomendable cuando:

- el contrato destino todavía no está firmado,
- existe la misma estructura contractual en otra sociedad,
- y se quiere acelerar la carga evitando introducir datos manualmente.

## 12. Errores frecuentes y cómo resolverlos

### 12.1. No se genera el número de contrato

Posibles causas:

- falta configuración general,
- no existe la serie `Lease Contract Nos.`,
- o la configuración no está inicializada.

Acción recomendada:

- revisar la configuración de `REF Setup`.

### 12.2. No deja insertar una línea

Posibles causas:

- falta `Customer No.` en la cabecera,
- falta `Starting Date`,
- falta `Description` en la línea.

Acción recomendada:

- completar primero la cabecera básica y después volver a insertar la línea.

### 12.3. El contacto no corresponde con el cliente

Posible causa:

- el contacto seleccionado pertenece a otra empresa o no está relacionado con el cliente del contrato.

Acción recomendada:

- seleccionar un contacto vinculado al cliente correcto.

### 12.4. No deja firmar el contrato

Posibles causas:

- falta `Starting Date`,
- falta `Salesperson Code`,
- existen líneas con `Amount = 0`,
- el contrato está cancelado.

Acción recomendada:

- revisar cabecera y líneas antes de volver a intentar la firma.

### 12.5. Los importes del contrato no coinciden con lo esperado

Posibles causas:

- líneas mal informadas,
- IVA o base imponible incorrectos,
- retención o impuestos aplicados de forma no prevista.

Acción recomendada:

- revisar cada línea y confirmar que `Amount`, `VAT %`, `VAT Base Amount` y fiscalidad estén correctos antes de firmar.

## 13. Buenas prácticas operativas

- Crear primero el contrato y guardar antes de adjuntar documentación.
- Informar siempre el inmueble antes de completar el resto de datos contextuales.
- Validar cliente y contacto antes de cargar líneas.
- No firmar contratos incompletos.
- Revisar que las líneas representan exactamente los conceptos que se van a facturar.
- Usar comentarios y adjuntos cuando exista información contractual relevante que no deba quedar solo fuera del sistema.

## 14. Resumen operativo

El flujo recomendado es el siguiente:

1. Crear contrato.
2. Guardar para generar número.
3. Informar inmueble.
4. Informar cliente principal.
5. Completar fechas y condiciones.
6. Añadir líneas.
7. Revisar fiscalidad e importes.
8. Validar datos obligatorios.
9. Firmar contrato.

## 15. Resultado esperado

Si el proceso se realiza correctamente, el contrato quedará:

- correctamente identificado,
- relacionado con el inmueble y el cliente adecuados,
- con líneas preparadas para facturación,
- con importes calculables por período,
- y disponible para su operativa posterior dentro de la solución.
