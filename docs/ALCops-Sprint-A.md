# ALCops Sprint A

## Baseline

| Métrica | Antes |
| --- | ---: |
| AL errors | 0 |
| ApplicationCop | 2.731 |
| LinterCop | 2.463 |
| PlatformCop | 1.614 |
| Total | 6.879 |
| APP generado | Sí |

## Reglas analizadas

| Regla | Ocurr. | Patrón e impacto | Clasificación |
| --- | ---: | --- | --- |
| PC0034 | 1 | Label con `%1` invocado sin argumento; el texto correcto requiere decisión funcional | REQUIERE REVISIÓN FUNCIONAL |
| PC0024 | 1 | `ApplicationArea` en página API | NO CORREGIR EN ESTE SPRINT: altera metadato de API |
| LC0052 | 1 | Método `internal` no referenciado | SEGURO PARA CORREGIR |
| LC0081 | 1 | `Count > 0` como prueba de existencia | SEGURO PARA CORREGIR |
| PC0001 | 27 | FlowFields editables; 5 casos revisados en tablas legacy | REQUIERE REVISIÓN INDIVIDUAL |
| PC0017 | 6 | Record pasado a página no coincide con SourceTable | REQUIERE REVISIÓN FUNCIONAL |
| PC0022 | 11 | Asignaciones Text/Label que pueden truncar | REQUIERE REVISIÓN INDIVIDUAL |
| PC0026 | 2 | API sin `id` y `lastModifiedDateTime` | REQUIERE REVISIÓN FUNCIONAL |
| PC0027 | 2 | Validación o trigger sobre temporal | REQUIERE REVISIÓN FUNCIONAL |
| PC0028 | 2 | Longitud de TableRelation incompatible | REQUIERE REVISIÓN FUNCIONAL |
| PC0036 | 1 | `SetRecord` sobre temporal | REQUIERE REVISIÓN FUNCIONAL |
| AC0010 | 21 | Objeto sin cobertura de PermissionSet | REQUIERE REVISIÓN FUNCIONAL |

## Reglas corregidas

### LC0052

Se eliminó `ImportAttachment(..., Encoding, ...)` de `Codeunit 96006 Management - Incident`. Era `internal`, no tenía referencias estáticas y su implementación no usaba `Encoding`. No se cambió ningún contrato externo ni flujo ejecutable. La eliminación también retiró un `LC0095` asociado al parámetro no usado.

### LC0081

En `Page 96812 RE RC Getting Started`, `FREJnlTemplate.Count > 0` se sustituyó por `not FREJnlTemplate.IsEmpty()`. Ambos respetan los filtros activos y devuelven el mismo resultado de existencia; `IsEmpty` evita contar registros.

## Reglas descartadas

No se corrigieron reglas cosméticas, grandes grupos ni candidatos adicionales `LC0019`, `LC0020` y `AC0032`. Se mantienen fuera para evitar una limpieza masiva no necesaria en este sprint.

## Reglas pendientes de revisión

`PC0034` requiere definir el mensaje de `DisplayMap`: el label reutilizado pide un nombre de campo, pero el método se ejecuta cuando falta configuración de mapa. Pasar un argumento arbitrario eliminaría el warning pero cambiaría el mensaje al usuario.

`PC0001`, `PC0017`, `PC0022`, `PC0026`, `PC0027`, `PC0028`, `PC0036` y `AC0010` se posponen. Afectan editabilidad de FlowFields, SourceTable, posibles pérdidas de texto, contrato API, tablas temporales, estructura de tablas o permisos.

## Muestras PC0037 y AC0031

Se revisaron diez muestras de cada regla sin modificar código.

- `PC0037`: las muestras asignan directamente campos de incidencias, fechas, comentarios, estados y datos generados por IA. Cambiar a `Validate` podría ejecutar OnValidate y suscriptores, alterando cálculos o persistencia. Es código legacy activo; la estrategia futura es revisar por flujo funcional con pruebas.
- `AC0031`: las muestras son reports que leen tablas sin declarar permiso de lectura explícito. Añadir permisos cambia el modelo de autorización efectiva; primero se debe decidir si los permisos pertenecen al objeto, al PermissionSet o al contexto de ejecución.

## Cambios por objeto

| Objeto | Regla | Cambio |
| --- | --- | --- |
| Codeunit 96006 Management - Incident | LC0052 | Eliminado método internal no usado |
| Page 96812 RE RC Getting Started | LC0081 | `Count > 0` por `not IsEmpty()` |

## Compilaciones realizadas

| Grupo | AL errors | Regla objetivo | Total | APP |
| --- | ---: | ---: | ---: | --- |
| Baseline | 0 | LC0052: 1, LC0081: 1 | 6.879 | Sí |
| Tras LC0052 | 0 | LC0052: 0, LC0081: 1 | 6.877 | Sí |
| Tras LC0081 | 0 | LC0052: 0, LC0081: 0 | 6.876 | Sí |

## Diagnósticos antes/después

| Regla | Antes | Después | Archivos modificados | Riesgo | Estado |
| --- | ---: | ---: | --- | --- | --- |
| PC0034 | 1 | 1 | 0 | Funcional | REQUIERE REVISIÓN FUNCIONAL |
| PC0024 | 1 | 1 | 0 | API | POSPUESTA |
| LC0052 | 1 | 0 | 1 | Bajo | CORREGIDA |
| LC0081 | 1 | 0 | 1 | Bajo | CORREGIDA |
| PC0001 | 27 | 27 | 0 | Datos/UI | REQUIERE REVISIÓN FUNCIONAL |
| PC0017 | 6 | 6 | 0 | Funcional | REQUIERE REVISIÓN FUNCIONAL |
| PC0022 | 11 | 11 | 0 | Datos | REQUIERE REVISIÓN FUNCIONAL |
| PC0026 | 2 | 2 | 0 | API | REQUIERE REVISIÓN FUNCIONAL |
| PC0027 | 2 | 2 | 0 | Temporales | REQUIERE REVISIÓN FUNCIONAL |
| PC0028 | 2 | 2 | 0 | Esquema | REQUIERE REVISIÓN FUNCIONAL |
| PC0036 | 1 | 1 | 0 | Temporal/UI | REQUIERE REVISIÓN FUNCIONAL |
| AC0010 | 21 | 21 | 0 | Permisos | REQUIERE REVISIÓN FUNCIONAL |

No se introdujeron diagnósticos nuevos. ApplicationCop permanece en 2.731, PlatformCop en 1.614, AL0472 en 69 y LinterCop baja de 2.463 a 2.460.

## Riesgos detectados

El principal riesgo es aplicar cambios mecánicos a validaciones, permisos, APIs, tablas temporales o relaciones. El volumen de PC0037 y AC0031 exige revisiones por proceso, no sustituciones globales.

## Regresiones

No se detectaron regresiones de compilación: AL errors permanece en cero y el paquete se genera tras cada corrección.

## Recomendación siguiente sprint

Abordar los casos únicos `PC0034`, `PC0022`, `PC0026`, `PC0028` y `PC0036` con propietario funcional y pruebas del flujo. Mantener PC0037 y AC0031 como líneas de trabajo separadas, con una muestra ampliada y estrategia de pruebas.
