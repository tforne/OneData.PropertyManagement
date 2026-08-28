# OneData Financial Flow Map

## Objetivo

OneData Financial Flow Map aporta una visión global y consolidada de los ingresos recurrentes generados por contratos de alquiler vigentes en todas las empresas del mismo entorno de Business Central.

La primera versión implementada en esta rama prioriza:

- consolidación multicompañía con `ChangeCompany`
- separación entre adaptación a ODPM real, cálculo financiero, persistencia y presentación
- histórico de snapshots
- comparación básica de snapshots
- exportación a Excel

## Arquitectura

La solución se divide en cuatro capas:

- Adaptación: `codeunit 96880 "OD FF Contract Adapter"`
- Cálculo: `codeunit 96881 "OD FF Analyzer"`
- Orquestación: `codeunit 96882 "OD FF Management"`
- Persistencia histórica: `codeunit 96883 "OD FF Snapshot Mgt"`

### Objetos creados

- Enums:
  - `96920 "OD FF Status"`
  - `96921 "OD FF Risk"`
  - `96922 "OD FF Value Source"`
- Tables:
  - `96930 "OD FF Setup"`
  - `96931 "OD FF Buffer"`
  - `96932 "OD FF Snapshot Header"`
  - `96933 "OD FF Snapshot Line"`
  - `96934 "OD FF Compare Buffer"`
- Pages:
  - `96950 "OD FF Setup"`
  - `96951 "OD FF Map"`
  - `96952 "OD FF Snapshot List"`
  - `96953 "OD FF Snapshot Card"`
  - `96954 "OD FF Snapshot Subpage"`
  - `96955 "OD FF Compare"`
- Codeunits:
  - `96980 "OD FF Contract Adapter"`
  - `96981 "OD FF Analyzer"`
  - `96982 "OD FF Management"`
  - `96983 "OD FF Snapshot Mgt"`
  - `96984 "OD FF Excel Export"`
- Otros:
  - `96985 "OD FF FRE Finance RC Ext"`
  - `96986 "OD FF RE RC Ext"`
  - `96987 "OD FF User"`
  - `96988 "OD FF Admin"`

## Integración con tablas reales

La solución se apoya en objetos reales de ODPM ya identificados:

- `table 96000 "Fixed Real Estate"`
- `table 96018 "Lease Contract"`
- `table 96019 "Lease Contract Line"`

## Uso de ChangeCompany

El análisis se ejecuta desde cualquier empresa y recorre `Company`.

- La empresa activa del usuario no cambia.
- Cada contrato y activo se lee en contexto de su empresa origen.
- Los errores por empresa deben registrarse sin detener el conjunto del análisis.

## Fórmulas financieras

- `Annual Rent = Monthly Rent * 12`
- `Remaining Contract Income = Monthly Rent * Remaining Months`
- `Gross Yield % = Annual Rent / Property Value * 100`
- `Net Yield % = Annual Net Income / Property Value * 100`
- `ROI % = Annual Net Income / Purchase Price * 100`
- `Cap Rate % = Annual Net Income / Property Value * 100`
- `Estimated Capital Gain = Estimated Selling Price - Purchase Price - Selling Costs`
- `Cash Flow = Annual Rent - Annual Operating Costs`

## Limitaciones actuales

- La relación exacta `contrato -> activo` sigue encapsulada en el adaptador con heurísticas por nombre de campo.
- La clasificación exacta de líneas de renta frente a depósitos, garantías y otros conceptos necesita confirmación funcional.
- La apertura directa del registro concreto en otra empresa se resuelve por ahora abriendo la lista de destino y mostrando el identificador objetivo.
- La comparación histórica implementada compara automáticamente los dos últimos snapshots.
- La extensión del Role Center añade la acción principal; los cues basados en snapshot quedan como siguiente iteración.

## Configuración necesaria

1. Abrir `OD FF Setup`.
2. Revisar porcentajes de mantenimiento, vacancia, gestión y rentabilidad objetivo.
3. Definir exclusión de empresas de prueba si aplica.
4. Configurar serie de snapshots si se desea sustituir la numeración interna.

## Seguridad

- `OD FF User`: análisis, consulta, histórico y exportación.
- `OD FF Admin`: permisos anteriores más configuración y gestión completa.

Además, el usuario debe tener lectura sobre contratos, líneas de contrato y activos inmobiliarios de las empresas analizadas.

## Instalación

1. Publicar la extensión.
2. Verificar sincronización de tablas nuevas.
3. Asignar permission set correspondiente.
4. Abrir `OneData Financial Flow Map` desde Tell Me o desde el Role Center financiero.

## Evolución recomendada

- cerrar mapeos reales en el adaptador
- añadir cues de Role Center basados en último snapshot
- enriquecer telemetría y logging por empresa/contrato
- soportar selección explícita de dos snapshots para comparación
- añadir API de consulta y capa predictiva futura
