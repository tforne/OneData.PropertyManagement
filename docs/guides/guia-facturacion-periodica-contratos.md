# Guía de facturación periódica de contratos

## Introducción

Esta guía describe el procedimiento para facturar contratos de arrendamiento de manera mensual dentro de OneData Property Management.

## Alcance

Aplica a contratos que se facturan periódicamente, generalmente con ciclos mensuales, donde la ficha de contrato y sus líneas determinan el importe a facturar.

## Requisitos previos

- Contrato creado con cliente y fechas correctamente definidos.
- Líneas de contrato registradas, con importes y datos fiscales.
- `Amount per Period` calculado y revisado.
- El proceso de facturación debe tener acceso a los datos del contrato y a las líneas de contrato.

## Flujo de facturación mensual

1. **Preparar la ficha de contrato**
   - Verificar `Customer No.`.
   - Confirmar `Starting Date` y `Expiration Date`.
   - Asegurarse de que `Lease Period` / `Invoice Period` representan facturación mensual.
   - Revisar `Amount per Period` y `Annual Amount`.

2. **Revisar las líneas de contrato**
   - Confirmar `Amount`, `Value`, `VAT %`, `VAT Amount` y `VAT Base Amount`.
   - Asegurarse de que cada línea tenga fechas válidas y no esté ya facturada fuera del periodo.
   - `Invoiced to Date` debe evidenciar si la línea ya ha sido facturada.

3. **Calcular el importe mensual**
   - El importe mensual se define en `Amount per Period`.
   - Si las líneas cambian, el contrato debe recalcularse automáticamente con la lógica de negocio, por ejemplo `RealEstateManagement.CalcContractAmount`.

4. **Generar la factura**
   - Ejecutar el proceso de facturación de contratos desde el contrato o el reporte correspondiente.
   - Seleccionar el intervalo mensual que se desea facturar.
   - Generar la factura.

5. **Verificar la factura**
   - Comprobar el documento generado en `Posted Lease Invoices`.
   - Validar que el importe coincide con `Amount per Period` y que el IVA está bien aplicado.

## Buenas prácticas

- Mantener el contrato con `Status` correcto, preferiblemente `Signed` para facturación.
- Actualizar siempre `Amount per Period` antes de facturar si cambian las líneas.
- Revisar `Invoiced to Date` para evitar facturar dos veces el mismo periodo.
- Usar el campo `Contract Expiration Date` para no facturar más allá del fin del contrato.

## Notas técnicas

- Si la solución usa un proceso automático, debe garantizar que los cambios en líneas de contrato actualicen la cabecera.
- En la tabla `Lease Contract`, `Amount per Period` suele calcularse con `RealEstateManagement.CalcContractAmount`.
- En la tabla `Lease Contract Line`, los cambios en `Amount` o `VAT Base Amount` deben disparar la recalculación de la cabecera para evitar inconsistencias.

## Resultado esperado

- Factura mensual generada correctamente.
- `Posted Lease Invoices` con el contrato asociado.
- Cabecera de contrato reflejando el importe mensual actual.
