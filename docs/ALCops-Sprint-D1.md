# ALCops Sprint D.1 - Deuda tecnica

Fecha de reanalisis: 2026-09-04. Alcance: analisis, clasificacion y priorizacion. No se modifica codigo AL, configuracion, permisos, esquema, API ni tests.

## 1. Resumen ejecutivo

El baseline actualizado contiene 5.638 diagnosticos, `AL errors = 0` y la APP se genera. Frente al analisis anterior se reducen 1.095 avisos: `LC0091` queda a cero despues de completar las traducciones. Diez reglas concentran 4.620 casos (81,94 %); el trabajo de mayor valor sigue siendo robustez y rendimiento, no reduccion indiscriminada del contador.

Se recomienda un D.2 acotado a quick wins seguros y un D.3 por flujos criticos. No se recomienda emprender una migracion masiva de Options, ToolTips, naming o texto legacy.

## 2. Baseline de compilacion

| Metrica | Resultado |
| --- | ---: |
| AL errors | 0 |
| APP generada | Si |
| Diagnosticos | 5.638 |
| Informacion | 3.091 |
| Warnings | 2.547 |
| Reduccion desde D.1 anterior | 1.095 (`LC0091`) |

Compilacion con AL Language `17.0.2273547`, AL Compiler `17.0.34.45391` y ALCops `1.1.0`; ApplicationCop, LinterCop y PlatformCop activos.

## 3. Distribucion por Cop

| Cop | Casos | % |
| --- | ---: | ---: |
| ApplicationCop | 2.708 | 48,03 % |
| PlatformCop | 1.561 | 27,69 % |
| LinterCop | 1.367 | 24,25 % |
| AL Compiler | 2 | 0,04 % |

## 4. Distribucion por regla

| Regla | Casos | % | Prioridad | Recomendacion |
| --- | ---: | ---: | --- | --- |
| PC0037 | 1.245 | 22,08 % | P1 | Analizar por trigger y campo; no reemplazo masivo. |
| AC0031 | 971 | 17,22 % | P1 | Matriz RBAC por flujo; no permisos globales. |
| AC0028 | 477 | 8,46 % | P4 | Backlog UX por tabla o pagina. |
| AC0026 | 440 | 7,80 % | P3 | Clasificar campos internos antes de declarar. |
| PC0030 | 302 | 5,36 % | P2 | Priorizar bucles y lecturas repetidas. |
| LC0092 | 284 | 5,04 % | P4 | Aceptar legacy; exigir nuevos captions traducibles. |
| AC0011 | 246 | 4,36 % | P4 | UX/localizacion opcional. |
| AC0015 | 230 | 4,08 % | P4 | Aceptar texto legacy existente. |
| LC0040 | 217 | 3,85 % | P2 | Explicitar `RunTrigger` despues de revisar semantica. |
| LC0020 | 208 | 3,69 % | P4 | Quick win mecanico solo con revision de paginas. |
| AC0030 | 206 | 3,65 % | P1 | Revisar ausencia/error individualmente. |
| LC0003 | 156 | 2,77 % | P3 | Sustituir referencias no ambiguas por nombre. |
| LC0010 | 107 | 1,90 % | P2 | Refactorizar hotspots de complejidad alta. |
| LC0048 | 97 | 1,72 % | P2 | Migrar errores criticos a `Label`/`ErrorInfo`. |
| LC0088 | 69 | 1,22 % | ACCEPT | Options legacy: migracion con riesgo de datos/API. |
| LC0019 | 53 | 0,94 % | P4 | Eliminar redundancia mecanicamente. |
| LC0090 | 35 | 0,62 % | P2 | Abordar con `LC0010` por hotspot. |
| AC0004 | 34 | 0,60 % | P2 | Revisar confirmaciones con contexto UI. |
| LC0086 | 29 | 0,51 % | P3 | Cambio de `PageStyle`, probar UI. |
| AC0001 | 27 | 0,48 % | P3 | Revisar navegacion y tablas de lista. |
| Otras 23 reglas | 205 | 3,64 % | P2-P4 | Tratar por riesgo, no por volumen. |

`LC0091` no aparece porque su contador actual es cero.

## 5. Distribucion por ubicacion

| Ubicacion | Casos | % |
| --- | ---: | ---: |
| `.vscode/` | 4.078 | 72,33 % |
| `src/` | 1.558 | 27,63 % |
| Otros | 2 | 0,04 % |

La mayor parte de la deuda esta en objetos legacy bajo `.vscode/`; una correccion global tendria radio de impacto elevado.

## 6. Distribucion por modulo

Clasificacion aproximada por ruta, util para priorizar y no como limite arquitectonico.

| Modulo | Casos |
| --- | ---: |
| Legacy `.vscode` | 2.889 |
| Gestion de activos | 667 |
| Facturacion y diarios | 661 |
| Flujo financiero | 630 |
| Incidencias | 419 |
| Contratos | 221 |
| Instalacion y upgrade | 124 |
| APIs | 15 |
| Otros, permisos y `src` | 12 |

## 7. Top 20 y acumulado

| Regla | Casos | Acumulado |
| --- | ---: | ---: |
| PC0037 | 1.245 | 22,08 % |
| AC0031 | 971 | 39,30 % |
| AC0028 | 477 | 47,77 % |
| AC0026 | 440 | 55,57 % |
| PC0030 | 302 | 60,93 % |
| LC0092 | 284 | 65,96 % |
| AC0011 | 246 | 70,33 % |
| AC0015 | 230 | 74,41 % |
| LC0040 | 217 | 78,25 % |
| LC0020 | 208 | 81,94 % |
| AC0030 | 206 | 85,60 % |
| LC0003 | 156 | 88,36 % |
| LC0010 | 107 | 90,26 % |
| LC0048 | 97 | 91,98 % |
| LC0088 | 69 | 93,21 % |
| LC0019 | 53 | 94,15 % |
| LC0090 | 35 | 94,77 % |
| AC0004 | 34 | 95,37 % |
| LC0086 | 29 | 95,89 % |
| AC0001 | 27 | 96,36 % |

## 8. Lectura 80/20

Las diez primeras reglas ya superan el 80 %. Sin embargo, cuatro son principalmente UX, nomenclatura o texto (`AC0028`, `LC0092`, `AC0011`, `AC0015`) y no deben desplazar a rendimiento, integridad o seguridad. La unidad de trabajo debe ser el flujo funcional, no la regla completa.

## 9. PC0037 - Validacion de campos

`PC0037` representa 1.245 casos. Se concentra en legacy (589), Flujo financiero (205), Gestion de activos (119), Incidencias (110) y Facturacion/diarios (103). El aviso puede proteger reglas de negocio incluidas en `OnValidate`; sustituirlo a ciegas por asignaciones directas cambia comportamiento.

Accion propuesta: inventariar por flujo los casos dentro de bucles o importaciones, identificar validaciones costosas o innecesarias y medir antes/despues. No convertir todos los casos en una tarea mecanica.

## 10. AC0031 - Permisos demasiado amplios

`AC0031` representa 971 casos: legacy 485, Gestion de activos 191, Facturacion/diarios 117, Incidencias 53, Contratos 51 y Flujo financiero 45. Es deuda de seguridad y mantenibilidad, pero reducir permisos sin una matriz RBAC puede romper procesos.

Accion propuesta: definir roles y operaciones permitidas por proceso, separar lectura, escritura, borrado e indirecto, y validar con usuarios de negocio en Sandbox.

## 11. LC0091 y LC0092 - Localizacion

`LC0091` queda resuelto en este baseline: 0 avisos, frente a 1.095 en la medicion anterior. `LC0092` mantiene 284 casos y se refiere a texto no traducible/gestionado segun la regla. Se acepta el legacy restante y se exige cumplimiento para objetos nuevos o modificados significativamente.

## 12. LC0040 - RunTrigger explicito

Hay 217 llamadas que deben explicitar `RunTrigger`. Es un quick win solo cuando se confirme el efecto del trigger de tabla: declarar `false` puede omitir logica de negocio; declarar `true` preserva el comportamiento esperado pero debe verificarse en el flujo afectado.

## 13. LC0088 - Options legacy

Los 69 avisos de `Option` se aceptan como deuda legacy. La migracion a `enum` tiene posibles efectos sobre datos almacenados, extensiones y contratos API. Solo se justifica al tocar funcionalmente el objeto o al crear una nueva superficie publica.

## 14. PC0030 - Rendimiento de registros

`PC0030` presenta 302 casos. Priorizar lecturas repetidas, `Find` dentro de bucles y bucles de facturacion, diarios, activos e incidencias. Cada cambio requiere caso funcional y medicion simple de volumen/tiempo, pues algunas lecturas protegen consistencia del proceso.

## 15. Quick wins candidatos

| Frente | Criterio | Guardarrail |
| --- | --- | --- |
| LC0019, LC0028, LC0095, LC0096, LC0099 | Cambios locales de bajo riesgo | Compilar y revisar subscribers/eventos. |
| LC0040 | Semantica conocida por llamada | Prueba funcional de triggers. |
| AC0026 | Campo no expuesto ni parte de contrato | Confirmar uso externo y API. |
| LC0003 | Referencia no ambigua | Compilar y revisar legibilidad. |

## 16. Alto valor, alto analisis

| Frente | Valor | Condicion de entrada |
| --- | --- | --- |
| PC0037 | Rendimiento e integridad | Mapa de validaciones por flujo. |
| PC0030 y PC0035 | Rendimiento | Medicion y datos representativos. |
| AC0031 y AC0032 | Minimo privilegio | Matriz RBAC aprobada. |
| AC0030 y LC0048 | Errores operativos | Contrato de errores y pruebas negativas. |
| LC0010 y LC0090 | Mantenibilidad | Hotspot con complejidad real. |

## 17. Deuda aceptable a corto plazo

Aceptar temporalmente `LC0088`, `AC0011`, `AC0015`, `AC0014`, `AC0017`, `AC0029`, `LC0098` y la mayor parte de `AC0028`/`LC0092`. La aceptacion no aplica a codigo nuevo: las nuevas implementaciones deben nacer conformes.

## 18. Matriz valor/esfuerzo

| Valor / esfuerzo | Iniciativas |
| --- | --- |
| Alto / bajo | Redundancias y parametros no usados revisados; captions en objetos nuevos. |
| Alto / medio | Hotspots PC0030/PC0035; manejo de errores de flujos criticos. |
| Alto / alto | RBAC AC0031/AC0032; validaciones PC0037 con pruebas de regresion. |
| Bajo / alto | Migracion masiva de Options, ToolTips y UX legacy. |

## 19. Escenarios de trabajo

1. **D.2 - Quick wins controlados:** lotes pequenos, una familia de reglas por PR, compilacion y prueba del flujo afectado.
2. **D.3 - Robustez y rendimiento:** seleccionar dos o tres procesos de negocio y tratar PC0037, PC0030/35, AC0030 y LC0048 conjuntamente.
3. **D.4 - Seguridad:** ejecutar la matriz RBAC, ajustar permisos y validar cada rol en Sandbox.

## 20. Ruleset futuro

Mantener los analizadores activos. Para legacy, usar supresiones justificadas, limitadas a regla/objeto/linea y con fecha de revision; no desactivar reglas globalmente. Revisar trimestralmente las reglas aceptadas y elevar severidad gradualmente solo despues de reducir su backlog.

## 21. Politica para codigo nuevo

- Sin nuevos `LC0091`; las traducciones deben estar completas.
- No introducir `Option`; usar `enum` cuando no exista un contrato compatible.
- Evitar permisos amplios y validar RBAC antes de publicar permisos nuevos.
- Explicitar `RunTrigger` y documentar las asignaciones que eviten `Validate`.
- Evaluar acceso a registros dentro de bucles y usar Labels para mensajes localizables.

## 22. CI/CD futuro

Publicar el JSON de diagnosticos como artefacto, bloquear siempre `AL errors`, y aplicar presupuestos de deuda por familia de regla para codigo nuevo. El baseline legacy debe ser informativo al principio; cualquier umbral bloqueante debe introducirse despues de una fase de estabilizacion y con excepciones versionadas.

## 23. Hoja de ruta D.2+

| Sprint | Objetivo | Salida esperada |
| --- | --- | --- |
| D.2 | Quick wins con bajo radio de impacto | Reduccion verificable sin regresiones. |
| D.3 | Flujos de rendimiento y errores | Medicion, pruebas y decisiones documentadas. |
| D.4 | Permisos por rol | Matriz RBAC y validacion Sandbox. |
| D.5 | Gobierno continuo | Baseline en CI/CD y politica de nueva deuda. |

## 24. Recomendacion final y decisiones

| Prioridad | Actuacion | Resultado esperado |
| --- | --- | --- |
| P1 | Aprobar D.2 de quick wins acotados | Reduccion segura y repetible. |
| P1 | Elegir flujos para PC0037/PC0030 | Mejor rendimiento sin perder reglas de negocio. |
| P1 | Aprobar alcance RBAC | Reduccion de permisos con validacion funcional. |
| P2 | Establecer baseline CI/CD | Evitar que la deuda vuelva a crecer. |
| P4 | Mantener UX/Options legacy aceptados | Foco en riesgo real. |

- **DEC-D01:** confirmar si D.2 puede incluir cambios mecanicos de `LC0040`, `LC0019`, parametros no usados y `LC0003`, con prueba de regresion por lote.
- **DEC-D02:** escoger los flujos de negocio prioritarios para D.3: facturacion/diarios, importacion de activos, contratos o incidencias.
- **DEC-D03:** designar responsables de negocio y tecnico para aprobar la matriz RBAC antes de modificar `AC0031`/`AC0032`.
- **DEC-D04:** confirmar la politica CI/CD inicial: solo impedir nuevos errores o tambien impedir nuevos avisos P1/P2.

**Estado final: SPRINT D.1 ANALIZADO - REQUIERE DECISIONES.**
