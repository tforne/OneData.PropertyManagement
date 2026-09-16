# ALCops Sprint B - Compatibilidad futura

## Baseline

Fecha de análisis: 2026-09-03.

La compilación manual se ejecutó con `alc.exe 17.0.34.45391`, AL Language
`17.0.2273547`, `application 25.0.0.0`, `runtime 15.0` y ALCops `1.1.0`, sin
modificar versiones.

| Métrica | Estado actual |
| --- | ---: |
| AL errors | 0 |
| Warnings | 3.713 |
| Info | 3.094 |
| Total | 6.807 |
| APP generado | Sí |

Notas del baseline actual:

- El total actual (`6.807`) difiere del cierre documentado de Sprint A
  (`6.876`) porque el workspace ya contenía cambios locales previos en
  `app.json`, `Translations`, `src` y `.vscode`.
- La compilación CLI actual no reprodujo `AL0472` como diagnóstico explícito en
  `errorlog`, por lo que el análisis de XLF se hizo por inspección directa de
  `Property Management.g.xlf` y `Property Management.ES.xlf`.

## AL0472

### Muestra representativa analizada

Se revisó una muestra dirigida sobre los casos con IDs presentes en
`Property Management.ES.xlf` pero ausentes en `Property Management.g.xlf`.

| Caso | Clasificación | Evidencia | Acción |
| --- | --- | --- | --- |
| `Codeunit Real Estate Management - NamedType AllocationAccountInvoicingNotSupportedErr` | XLF OBSOLETO SEGURO | El `trans-unit` sigue en `Property Management.ES.xlf` pero no existe ya en `Property Management.g.xlf` ni se encontró símbolo equivalente en el código actual | Eliminado |
| `Page Fixed Real Estate Card - Control Clasificación - Property Caption` | XLF OBSOLETO SEGURO | El caption antiguo desapareció y fue sustituido por `Control ClassificationStructure` con source `Clasificación y estructura` | Eliminado |
| `Page Fixed Real Estate Card - Control Maintenance2 - Property Caption` | XLF OBSOLETO SEGURO | El grupo antiguo fue reemplazado por `Control Maintenance` con source `Gestión y mantenimiento` | Eliminado |
| `Page Fixed Real Estate Card - Control Construcción - Property Caption` | XLF OBSOLETO SEGURO | El grupo antiguo fue reemplazado por `Control ConstructionDetails` con source `Construcción y Catastro` | Eliminado |
| `Page Fixed Real Estate Card - Control Precios - Property Caption` | REQUIERE REVISIÓN | El caption antiguo `Precios` ya no existe; el área actual está fragmentada en `ReferenceIndexes`, `RentalPrices` y `SalesPrices`, sin sustituto único | No migrado |
| `Page Fixed Real Estate Card - Action Attachments - Property ToolTip` | XLF OBSOLETO SEGURO | La acción antigua ya no existe y hoy se usa `UploadAttachments` con tooltip nuevo y source ya localizado en español | Eliminado |
| `Page Fixed Real Estate Card - Action History - Property Caption` | XLF OBSOLETO SEGURO | La acción `History` desapareció y la acción actual equivalente observable es `FRELedgerEntries` con caption `Movimientos del activo`, que no es sustituto literal | Eliminado |
| `Enum Lease Contract Line Type - EnumValue   - Property Caption` | FALSO POSITIVO / OTRO | El caso usa un `source` compuesto solo por espacio en blanco. La inspección XML no es fiable para decidir limpieza automática sin confirmar cómo lo trata AL | No modificado |

### Conclusión

- En el estado actual del repositorio no se confirma el patrón histórico de 69
  entradas homogéneas listas para borrado masivo.
- Sí se confirma una bolsa pequeña de `trans-unit` huérfanas y seguras en
  `Property Management.ES.xlf`.
- Se eliminaron 7 entradas obsoletas claramente ausentes del `.g.xlf`.
- No se aplicó limpieza global adicional porque no hay evidencia suficiente para
  extrapolar el patrón a todos los casos históricos.

## APIs obsoletas

No se detectaron diagnósticos `AL0432` ni mensajes de compilación que
identificaran símbolos estándar Microsoft marcados como `obsolete` o
`deprecated` en el baseline actual.

## Símbolos Microsoft obsoletos

No se identificaron usos explícitos de símbolos estándar Microsoft marcados como
obsoletos a partir de:

- compilación actual;
- búsqueda de mensajes `obsolete`/`deprecated`;
- revisión dirigida de reglas de compatibilidad futura.

Esto no demuestra ausencia absoluta en todas las dependencias, pero sí ausencia
de evidencia activa en el baseline compilado de hoy.

## Símbolos OneData obsoletos

No se encontraron usos de `ObsoleteState`, `ObsoleteReason` ni `ObsoleteTag` en
`src` o `.vscode`.

## PlatformCop de compatibilidad

| Regla | Ocurrencias | Riesgo actualización | Versión afectada | Recomendación |
| --- | ---: | --- | --- | --- |
| `PC0037` | 1.245 | ALTO. Puede ocultar validaciones de negocio y complica futuras refactorizaciones, pero su corrección masiva es funcionalmente arriesgada | Futuras versiones AL/BC | Posponer. Revisar por flujo funcional |
| `PC0022` | 11 | MEDIO. Riesgo de truncamiento real o futura severidad más estricta | Futuras versiones AL/BC | Revisar por caso. No corregir mecánicamente |
| `PC0027` | 2 | ALTO. Uso de `Validate()` sobre temporales puede romper la semántica esperada en plataforma futura | Futuras versiones BC | Revisar por caso con confirmación funcional |
| `PC0028` | 2 | ALTO. Incompatibilidad de longitud en `TableRelation` puede bloquear cambios de esquema | Futuras versiones BC | Documentar y revisar diseño |
| `PC0036` | 1 | MEDIO | Futuras versiones BC | Revisar el patrón con temporal antes de cambiar |
| `PC0026` | 2 | ALTO | Futuras versiones API/BC | No corregir sin revisión de contrato API |
| `PC0034` | 1 | BAJO | Futuras versiones BC | Sigue siendo funcional; requiere decisión de mensaje |
| `PC0001` | 27 | MEDIO | Futuras versiones BC | Mantener fuera de este sprint |
| `PC0017` | 6 | MEDIO | Futuras versiones BC | Mantener fuera de este sprint |

## ApplicationCop de compatibilidad

| Regla | Ocurrencias | Riesgo actualización | Versión afectada | Recomendación |
| --- | ---: | --- | --- | --- |
| `AC0007` | 1 | MEDIO. Un install codeunit público amplía superficie pública innecesaria | Futuras versiones de la extensión | Documentar; no cambiar sin revisar dependencias |
| `AC0024` | 3 | ALTO. Eventos publicadores públicos congelan firma pública y penalizan evolución futura | Futuras versiones de la extensión | Documentar; no cambiar sin revisar contratos |
| `AC0010` | 21 | MEDIO | Seguridad/autorización futura | Excluido del sprint salvo revisión funcional |
| `AC0031` | 971 | ALTO | Evolución de permisos y ejecución | Excluido por volumen y riesgo |

## Correcciones aplicadas

| Regla / Diagnóstico | Antes | Después | Riesgo futuro | Corrección | Estado |
| --- | ---: | ---: | --- | --- | --- |
| `AL0472` / XLF huérfano seguro | 7 casos confirmados por inspección | 0 casos de esa muestra | Medio | Eliminación de 7 `trans-unit` obsoletas en `Property Management.ES.xlf` | CORREGIDA |

## Correcciones no aplicadas

| Regla / Diagnóstico | Antes | Después | Riesgo futuro | Corrección | Estado |
| --- | ---: | ---: | --- | --- | --- |
| `PC0022` | 11 | 11 | Medio | No aplicada: posibles truncamientos requieren intención funcional | REQUIERE REVISIÓN FUNCIONAL |
| `PC0027` | 2 | 2 | Alto | No aplicada: validar temporales puede requerir rediseño del patrón | REQUIERE REVISIÓN FUNCIONAL |
| `PC0028` | 2 | 2 | Alto | No aplicada: afecta esquema/relaciones | REQUIERE REVISIÓN FUNCIONAL |
| `PC0026` | 2 | 2 | Alto | No aplicada: afecta contrato API | REQUIERE REVISIÓN FUNCIONAL |
| `PC0034` | 1 | 1 | Bajo | No aplicada: requiere decisión sobre mensaje | POSPUESTA |
| `PC0036` | 1 | 1 | Medio | No aplicada: patrón con registro temporal | REQUIERE REVISIÓN FUNCIONAL |
| `AC0007` | 1 | 1 | Medio | No aplicada: cambiaría superficie pública | POSPUESTA |
| `AC0024` | 3 | 3 | Alto | No aplicada: cambiaría contratos de eventos públicos | POSPUESTA |
| `AL0472` / enum con espacio en blanco | 1 caso especial | 1 | Bajo | No aplicada: revisar semántica exacta antes de limpiar | REQUIERE REVISIÓN |

## Riesgos para futuras versiones

- El mayor riesgo real del baseline actual no está en volumen, sino en
  compatibilidad de contratos: API (`PC0026`), eventos públicos (`AC0024`) y
  posibles cambios de validación/persistencia (`PC0037`, `PC0027`).
- `PC0028` puede convertirse en bloqueo de actualización si se endurecen más las
  comprobaciones de longitud relacionadas con esquema.
- Las entradas XLF huérfanas no bloquean el runtime, pero sí degradan la
  mantenibilidad de traducciones y aumentan el ruido en futuras regeneraciones.

## Compilaciones

| Grupo | AL errors | APP | Observaciones |
| --- | ---: | --- | --- |
| Baseline actual | 0 | Sí | `6.807` diagnósticos; `AL0472` no reproducido en CLI |
| Tras limpieza XLF | 0 | Sí | `6.807` diagnósticos; sin warnings nuevos en `errorlog` |

## Resultado final

- Archivos AL modificados: 0
- Archivos XLF modificados: 1
- Diagnósticos eliminados: no medibles en CLI actual; 7 entradas XLF
  obsoletas eliminadas por inspección directa
- Diagnósticos nuevos: 0
- Errores finales: 0
- APP generado: Sí

Estado de cierre propuesto:

`SPRINT B COMPLETADO CON OBSERVACIONES`
