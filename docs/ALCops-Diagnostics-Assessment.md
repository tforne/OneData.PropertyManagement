# ALCops Diagnostic Assessment

## 1. Resumen ejecutivo

El baseline contiene 6.879 diagnósticos: 2.731 de ApplicationCop, 2.463 de
LinterCop, 1.614 de PlatformCop y 71 del compilador AL. La compilación termina
sin errores y genera el paquete. El volumen procede mayoritariamente del código
legacy bajo `.vscode`; no es un motivo para corregir en masa.

Los grupos que requieren atención primero son los que pueden omitir validación de
campos, perder permisos, romper relaciones o contratos de API. Naming, ToolTips,
traducciones y convenciones se mantienen como backlog de normalización.

## 2. Baseline

| Métrica | Resultado |
| --- | ---: |
| AL errors | 0 |
| ApplicationCop | 2.731 |
| LinterCop | 2.463 |
| PlatformCop | 1.614 |
| AL0472 | 69 |
| AL1025 | 2 |
| Total | 6.879 |

La compilación usó AL Compiler `17.0.34.45391`, AL Language `17.0.2273547` y
ALCops `1.1.0`.

## 3. Diagnósticos por Cop

`F/O` expresa archivos y objetos afectados. `S/V` expresa archivos bajo `src` y
`.vscode`. El título de la regla resume el problema que detecta.

| Cop | Regla | Diagnóstico | Sev. | Ocurr. | F/O | S/V |
| --- | --- | --- | --- | ---: | ---: | ---: |
| ApplicationCop | AC0001 | Lookup/DrillDown no definidos para tablas usadas en listas | Info | 27 | 25/25 | 4/21 |
| ApplicationCop | AC0002 | PK de un campo sin `NotBlank` | Warning | 19 | 19/19 | 2/17 |
| ApplicationCop | AC0004 | `Confirm()` sin Confirm Management | Info | 34 | 13/13 | 0/13 |
| ApplicationCop | AC0006 | `Page.Run` sin Page Management | Warning | 3 | 3/3 | 0/3 |
| ApplicationCop | AC0007 | Install/Upgrade sin `Access = Internal` | Warning | 1 | 1/1 | 0/1 |
| ApplicationCop | AC0009 | Caption de permission set demasiado largo | Warning | 7 | 7/7 | 2/5 |
| ApplicationCop | AC0010 | Objeto sin cobertura de PermissionSet | Warning | 21 | 21/21 | 18/3 |
| ApplicationCop | AC0011 | Caption ausente en UI | Info | 246 | 86/86 | 3/83 |
| ApplicationCop | AC0014 | ToolTip sin puntuación final | Info | 9 | 7/7 | 0/7 |
| ApplicationCop | AC0015 | ToolTip sin “Specifies” inicial | Info | 230 | 24/24 | 18/6 |
| ApplicationCop | AC0017 | ToolTip demasiado largo | Info | 4 | 4/4 | 0/4 |
| ApplicationCop | AC0019 | Valor 0 de enum no reservado para vacío | Info | 19 | 19/19 | 7/12 |
| ApplicationCop | AC0024 | Publicador de evento público | Warning | 3 | 1/1 | 0/1 |
| ApplicationCop | AC0026 | `AllowInCustomizations` no explícito | Info | 441 | 69/69 | 15/54 |
| ApplicationCop | AC0028 | Campo de tabla sin ToolTip | Info | 478 | 54/54 | 16/38 |
| ApplicationCop | AC0029 | ToolTip duplicado entre página y tabla | Info | 3 | 2/2 | 0/2 |
| ApplicationCop | AC0030 | Valor de retorno no usado | Info | 206 | 65/65 | 17/48 |
| ApplicationCop | AC0031 | Acceso a tabla sin permiso explícito | Info | 971 | 118/118 | 27/91 |
| ApplicationCop | AC0032 | Permiso declarado sin uso | Info | 9 | 4/4 | 0/4 |
| LinterCop | LC0003 | IDs de objeto como referencias | Warning | 160 | 52/52 | 0/52 |
| LinterCop | LC0008 | Índice de mantenibilidad bajo | Warning | 1 | 1/1 | 0/1 |
| LinterCop | LC0010 | Complejidad ciclomática alta | Warning | 107 | 41/41 | 13/28 |
| LinterCop | LC0019 | DataClassification de campo redundante | Warning | 53 | 4/4 | 2/2 |
| LinterCop | LC0020 | ApplicationArea de control redundante | Warning | 208 | 29/29 | 8/21 |
| LinterCop | LC0028 | Suscriptor con sintaxis literal, no identificador | Warning | 14 | 6/6 | 1/5 |
| LinterCop | LC0031 | `LockTable` en vez de ReadIsolation | Info | 8 | 6/6 | 0/6 |
| LinterCop | LC0040 | RunTrigger implícito | Warning | 218 | 72/72 | 13/59 |
| LinterCop | LC0048 | `Error` con Text sin ErrorInfo/Label | Warning | 97 | 33/33 | 3/30 |
| LinterCop | LC0052 | Método interno no usado | Warning | 1 | 1/1 | 0/1 |
| LinterCop | LC0063 | Nombre de campo poco descriptivo | Info | 2 | 1/1 | 0/1 |
| LinterCop | LC0081 | Comprobación de existencia sin `IsEmpty` | Warning | 1 | 1/1 | 0/1 |
| LinterCop | LC0082 | Búsqueda de un registro mejorable | Info | 1 | 1/1 | 1/0 |
| LinterCop | LC0083 | API moderna para partes de fecha/hora | Warning | 21 | 7/7 | 3/4 |
| LinterCop | LC0086 | Literales de estilo en vez de PageStyle | Warning | 29 | 9/9 | 3/6 |
| LinterCop | LC0088 | Option en vez de Enum | Info | 69 | 35/35 | 4/31 |
| LinterCop | LC0090 | Complejidad cognitiva alta | Warning | 35 | 22/22 | 7/15 |
| LinterCop | LC0091 | Texto traducible sin traducción | Warning | 1.088 | 82/82 | 71/11 |
| LinterCop | LC0092 | Nombre fuera de convención | Warning | 284 | 130/130 | 8/122 |
| LinterCop | LC0095 | Parámetro no usado | Warning | 19 | 8/8 | 1/7 |
| LinterCop | LC0096 | Parámetro Record innecesario | Warning | 20 | 11/11 | 0/11 |
| LinterCop | LC0098 | Nombre de suscriptor fuera de plantilla | Info | 14 | 6/6 | 1/5 |
| LinterCop | LC0099 | Parámetro de suscriptor no usado | Info | 13 | 3/3 | 0/3 |
| PlatformCop | PC0001 | FlowField editable | Warning | 27 | 5/5 | 0/5 |
| PlatformCop | PC0017 | Record de página no coincide con SourceTable | Warning | 6 | 3/3 | 0/3 |
| PlatformCop | PC0022 | Posible truncamiento de Text | Warning | 11 | 5/5 | 1/4 |
| PlatformCop | PC0024 | ApplicationArea en API | Info | 1 | 1/1 | 0/1 |
| PlatformCop | PC0026 | Campo obligatorio no expuesto en API | Warning | 2 | 1/1 | 0/1 |
| PlatformCop | PC0027 | Lógica de tabla sobre temporal | Warning | 2 | 1/1 | 1/0 |
| PlatformCop | PC0028 | Longitud incompatible en TableRelation | Warning | 2 | 2/2 | 0/2 |
| PlatformCop | PC0030 | Lectura sin partial records | Info | 302 | 85/85 | 24/61 |
| PlatformCop | PC0034 | Número de placeholders no coincide | Warning | 1 | 1/1 | 0/1 |
| PlatformCop | PC0035 | CalcFields dentro de bucle | Warning | 7 | 6/6 | 0/6 |
| PlatformCop | PC0036 | `SetRecord` sobre temporal | Warning | 1 | 1/1 | 1/0 |
| PlatformCop | PC0037 | Asignación directa sin `Validate` | Warning | 1.245 | 71/71 | 14/57 |
| PlatformCop | PC0038 | No todos los caminos devuelven valor | Info | 7 | 7/7 | 1/6 |
| AL Compiler | AL0472 | Source XLF no coincide con label; traducción ignorada | Warning | 69 | n/a | n/a |
| AL Compiler | AL1025 | Archivo sin definición AL coincidente | Warning | 2 | n/a | n/a |

## 4. Clasificación de reglas

| Prioridad | Cop | Regla | Severidad | Ocurrencias | Impacto | Coste | Recomendación |
| --- | --- | --- | --- | ---: | --- | --- | --- |
| P1 | PlatformCop | PC0001 | Warning | 27 | Integridad de datos | Medio | Revisar antes de corregir |
| P1 | PlatformCop | PC0017 | Warning | 6 | Comportamiento de página | Medio | Corregir en siguiente sprint |
| P1 | PlatformCop | PC0022 | Warning | 11 | Truncamiento/pérdida de datos | Medio | Corregir ahora por casos |
| P1 | PlatformCop | PC0026 | Warning | 2 | Contrato API | Medio | Corregir ahora por casos |
| P1 | PlatformCop | PC0027 | Warning | 2 | Lógica y persistencia | Medio | Revisar antes de corregir |
| P1 | PlatformCop | PC0028 | Warning | 2 | Relación e integridad | Medio | Corregir ahora por casos |
| P1 | PlatformCop | PC0034 | Warning | 1 | Mensaje incorrecto en ejecución | Bajo | Corregir ahora |
| P1 | PlatformCop | PC0036 | Warning | 1 | Uso no soportado de temporal | Medio | Corregir ahora por caso |
| P1 | PlatformCop | PC0037 | Warning | 1.245 | Validación e integridad | Alto | Revisar antes de corregir |
| P1 | ApplicationCop | AC0010 | Warning | 21 | Seguridad y autorización | Medio | Revisar antes de corregir |
| P1 | ApplicationCop | AC0031 | Info | 971 | Permisos en ejecución | Alto | Revisar antes de corregir |
| P2 | PlatformCop | PC0035 | Warning | 7 | Rendimiento | Medio | Siguiente sprint |
| P2 | PlatformCop | PC0030 | Info | 302 | Rendimiento potencial | Alto | Posponer |
| P2 | ApplicationCop | AC0002 | Warning | 19 | Calidad de claves | Medio | Siguiente sprint |
| P2 | ApplicationCop | AC0004/AC0006 | Info/Warning | 37 | UX y API estándar | Medio | Siguiente sprint |
| P2 | ApplicationCop | AC0007/AC0024 | Warning | 4 | Encapsulación de API | Medio | Revisar antes de corregir |
| P2 | ApplicationCop | AC0030 | Info | 206 | Manejo explícito de errores | Alto | Revisar antes de corregir |
| P2 | LinterCop | LC0010/LC0090 | Warning | 142 | Complejidad y regresión | Alto | Siguiente sprint, por objeto |
| P2 | LinterCop | LC0031 | Info | 8 | Concurrencia | Alto | Revisar antes de corregir |
| P2 | LinterCop | LC0040 | Warning | 218 | Semántica de triggers | Alto | Revisar antes de corregir |
| P2 | LinterCop | LC0048 | Warning | 97 | Telemetría y soporte | Medio | Siguiente sprint |
| P2 | LinterCop | LC0083/LC0086 | Warning | 50 | Compatibilidad y APIs modernas | Medio | Siguiente sprint |
| P2 | LinterCop | LC0088 | Info | 69 | Contrato extensible de tipos | Alto | Revisar antes de corregir |
| P2 | AL Compiler | AL0472 | Warning | 69 | Calidad de traducciones y actualización | Medio | Siguiente sprint |
| P3 | ApplicationCop | AC0001/AC0019 | Info | 46 | UX y diseño | Medio | Posponer |
| P3 | ApplicationCop | AC0026/AC0028 | Info | 919 | Metadatos de extensibilidad/UI | Alto | No corregir masivamente |
| P3 | ApplicationCop | AC0032 | Info | 9 | Permisos redundantes | Bajo | Quick win tras revisar |
| P3 | LinterCop | LC0003/LC0028 | Warning | 174 | Mantenibilidad y sintaxis moderna | Alto | Posponer |
| P3 | LinterCop | LC0019/LC0020 | Warning | 261 | Redundancia de metadatos | Medio | Quick win limitado |
| P3 | LinterCop | LC0052/LC0081/LC0082 | Warning/Info | 3 | Mantenibilidad/rendimiento menor | Bajo | Quick win por caso |
| P3 | LinterCop | LC0095/LC0096/LC0099 | Warning/Info | 52 | Firmas y limpieza | Medio | Posponer |
| P3 | LinterCop | LC0091/LC0092/LC0098 | Warning/Info | 1.386 | Localización y naming | Alto | No corregir masivamente |
| P3 | PlatformCop | PC0024/PC0038 | Info | 8 | Contrato API/control de flujo | Bajo | Quick win por caso |
| P4 | ApplicationCop | AC0009/AC0011/AC0014/AC0015/AC0017/AC0029 | Warning/Info | 499 | Texto y presentación | Alto | No corregir masivamente |
| P4 | LinterCop | LC0063 | Info | 2 | Naming | Bajo | Posponer |
| P4 | AL Compiler | AL1025 | Warning | 2 | Organización del proyecto | Bajo | Posponer |

## 5. P0

No hay diagnósticos P0: el compilador termina sin errores y no hay un indicio
automático de corrupción o pérdida de datos confirmada.

## 6. P1

Priorizar `PC0001`, `PC0017`, `PC0022`, `PC0026`, `PC0027`, `PC0028`, `PC0034`,
`PC0036`, `PC0037`, `AC0010` y `AC0031`. Son reglas que pueden afectar
validaciones, relaciones, APIs o autorización. Cada cambio debe revisarse y
probarse funcionalmente, especialmente `PC0037` y `AC0031` por su alcance.

## 7. P2

El segundo bloque es compatibilidad, concurrencia, complejidad, telemetría y
rendimiento: `AL0472`, `PC0030`, `PC0035`, `AC0002`, `AC0004`, `AC0006`,
`AC0007`, `AC0024`, `AC0030`, `LC0010`, `LC0031`, `LC0040`, `LC0048`,
`LC0083`, `LC0086`, `LC0088` y `LC0090`.

## 8. P3/P4

Metadatos, ToolTips, captions, localización no aplicada, nomenclatura y
redundancias son P3/P4. Aportan valor de normalización, pero no justifican ruido
masivo ni cambios de comportamiento en el estado actual.

## 9. Quick Wins

| Regla | Ocurr. | Beneficio | Riesgo | Corrección propuesta |
| --- | ---: | --- | --- | --- |
| PC0034 | 1 | Evita mensajes con argumentos erróneos | Bajo | Ajustar argumentos de placeholder y probar el mensaje |
| PC0024 | 1 | Contrato API limpio | Bajo | Retirar ApplicationArea de la API tras revisar consumo |
| LC0052 | 1 | Elimina código muerto | Bajo | Confirmar que no hay uso externo y retirar método |
| LC0081 | 1 | Consulta más clara/eficiente | Bajo | Sustituir patrón por `IsEmpty` y probar resultado |
| LC0019 | 53 | Reduce metadato redundante | Bajo | Eliminar solo cuando el valor coincide exactamente con tabla |
| LC0020 | 208 | Reduce metadato redundante | Bajo | Eliminar solo cuando hereda exactamente de la página |
| AC0032 | 9 | Limpia permisos sin uso | Bajo | Confirmar cobertura antes de retirar |

## 10. Requieren revisión manual

No corregir masivamente `PC0001`, `PC0017`, `PC0022`, `PC0026`, `PC0027`,
`PC0028`, `PC0035`, `PC0036`, `PC0037`, `AC0010`, `AC0031`, `AC0030`,
`LC0031`, `LC0040`, `LC0048` ni `LC0088`. Pueden modificar validación,
transacciones, claves, APIs, permisos, telemetría o persistencia.

## 11. Grandes grupos de diagnósticos

- `PC0037` (1.245) es el grupo con mayor riesgo real: una asignación directa
  puede omitir OnValidate y suscriptores. Debe abordarse por flujo funcional,
  nunca mediante sustitución global.
- `AC0031` (971) señala permisos explícitos ausentes. Es importante para
  seguridad, pero su corrección depende de la intención de cada objeto.
- `LC0091` (1.088) es principalmente una deuda de localización, no un defecto
  funcional; programar un proyecto de traducciones separado.
- `AC0026` (441), `AC0028` (478), `AC0011` (246), `AC0015` (230) y `AC0030`
  (206) son principalmente convención de UI/metadatos o manejo explícito de
  retornos; no priorizarlos por volumen.
- `PC0030` (302) es una oportunidad de rendimiento que requiere perfiles de
  lectura para justificar cada cambio.
- `LC0092` (284), `LC0040` (218), `LC0020` (208) y `LC0003` (160) son deuda de
  convenciones/modernización. `LC0040` queda fuera de automatización por el
  efecto potencial sobre triggers.

## 12. AL0472

Las 69 advertencias indican que el source de un elemento XLF no coincide con el
valor actual del label, por lo que el compilador ignora esa traducción. Es deuda
de localización y un riesgo P2 para actualizaciones: puede dejar textos sin
traducir. El compilador actual lo mantiene como Warning; no se identifica una
versión publicada en la que pase obligatoriamente a Error. Revisar tras cada
actualización de AL Language y corregir por lote de traducción validado.

## 13. Distribución src vs .vscode

| Ubicación | Diagnósticos con localización |
| --- | ---: |
| `src/` | 2.571 |
| `.vscode/` | 4.237 |
| Compilador/sin fuente AL | 71 |

La concentración en `.vscode` confirma que es código de producto legacy activo,
no una carpeta de configuración prescindible. Su reorganización debe ser una
fase independiente; los dos objetos de test identificados en el inventario se
deberán extraer a una app de pruebas.

## 14. Top 10 reglas recomendadas para corregir

| Prioridad | Regla | Ocurr. | Motivo, beneficio y dificultad |
| ---: | --- | ---: | --- |
| 1 | PC0034 | 1 | Riesgo funcional concreto, corrección pequeña y verificable |
| 2 | PC0022 | 11 | Previene truncamiento; revisar límites y datos por caso |
| 3 | PC0026 | 2 | Protege contratos API; bajo volumen, revisión funcional media |
| 4 | PC0028 | 2 | Evita relaciones con longitudes incompatibles |
| 5 | PC0036 | 1 | Evita uso no soportado de temporales |
| 6 | PC0017 | 6 | Asegura que la página recibe el record de SourceTable correcto |
| 7 | AC0010 | 21 | Mejora seguridad; requiere validar el modelo de permisos |
| 8 | PC0001 | 27 | Protege FlowFields; revisar comportamiento de cada página |
| 9 | PC0037 | 1.245 | Alto beneficio de integridad, pero solo por flujo y con pruebas |
| 10 | AL0472 | 69 | Recupera traducciones y reduce riesgo de actualización |

## 15. Plan de saneamiento por sprints

1. **Sprint A - Integridad y contratos**: PC0034, PC0022, PC0026, PC0028,
   PC0036, PC0017 y una muestra revisada de PC0001/PC0037.
2. **Sprint B - Seguridad y compatibilidad**: AC0010, AC0031, AL0472,
   PC0027, AC0007, AC0024, LC0083 y LC0086.
3. **Sprint C - Mantenibilidad y rendimiento**: complejidad, LC0048, LC0031,
   PC0035, PC0030 y retorno no comprobado, priorizados por uso real.
4. **Sprint D - Estructura**: migración `.vscode` a `src` y app de pruebas.
5. **Sprint E - Normalización opcional**: ToolTips, captions, naming,
   traducciones LC0091 y redundancias de metadatos.

## 16. Qué NO recomiendo corregir

No iniciar una campaña global de `PC0037`, `AC0031`, `LC0040`, `LC0088`,
`PC0030`, `LC0091`, `LC0092`, ToolTips, captions o naming. El volumen no mide
el riesgo, y esos cambios masivos aumentarían la probabilidad de regresión y el
ruido de revisión.

## 17. Estado final

`FASE 2 ANALIZADA`
