# OneData VERI*FACTU — POC.0 Gap Analysis

Empresa: **Montornes 08170 SL**. Fecha: 2026-09-10. Análisis estático; ninguna configuración o solución implementada. Evidencias, objetos y líneas en [Discovery](OneData_Verifactu_POC0_Discovery.md).

**Decisión actual: NO-GO para habilitación completa.** No se demuestra que el estándar sea insuficiente: faltan sus paquetes específicos y la validación de la instalación. Sí se demuestra código de modificación de históricos y una rama contractual sin generación de ventas estándar.

`STANDARD` = Microsoft; `ONEDATA` = Property Management y OneData Base Application; `THIRD PARTY` = otros editores (no encontrados en manifiestos disponibles); `UNKNOWN` = componentes/configuración que no pueden confirmarse. Las clasificaciones de desarrollo son candidatas; no autorizan implementación en POC.0.

| Área | Estándar BC | OneData actual | Gap / clasificación | Riesgo | Acción recomendada |
|---|---|---|---|---|---|
| Configuración VERI*FACTU | STANDARD: descrita oficialmente; objetos específicos NOT FOUND localmente | ONEDATA: no motor propio encontrado | **CONFIGURATION** + **VALIDATION REQUIRED**: instalación/versión efectiva desconocida | ALTO R03 | Verificar apps, símbolos, setup, certificado y destino de ensayo; no construir sustituto |
| E-Documents | STANDARD: envío histórico presente; framework moderno NOT FOUND | ONEDATA: importaciones de namespace, sin integración moderna demostrada | **VALIDATION REQUIRED** | ALTO R03 | Obtener paquete y determinar orígenes admitidos, eventos, estados, transacción y workflow |
| Versiones/dependencias | STANDARD: símbolos28.4 ES; dependencias transitivas Microsoft no descargadas | ONEDATA PM4.0.26248.339; Base5.0.26244.190 exige Application28.3 | **VALIDATION REQUIRED** | ALTO | Confirmar despliegue efectivo y coexistencia Withholding Tax/IRPF; app.json no acredita tenant |
| Facturación estándar | STANDARD CU80 / Tables36,37,112,113 disponibles | ONEDATA genera borradores estándar en rama Acquired; no reemplaza CU80 encontrado | **NO GAP** en disponibilidad de primitiva; **VALIDATION REQUIRED** extremo a extremo | MEDIO/ALTO R02 | Registrar manualmente borrador en POC.1 y comprobar identidad histórica y captura fiscal |
| Contratos propios | STANDARD admite origen Sales Header/Line | CU96000 solo crea36/37 si Acquired; fija Posting No. con recibo | **VALIDATION REQUIRED** | ALTO R02/R08 | VF02 con numeración, bill-to y vínculo recibo112; combinación de contratos |
| Contratos no adquiridos | No se acredita soporte estándar de origen96021 | Solo96021/96022 y FRE; no venta estándar en generador | **ARCHITECTURAL RISK**; eventual **DEVELOPMENT REQUIRED** solo tras delimitar emisor/alcance | ALTO R02 | Determinar si es recibo ajeno o emisión fiscal del piloto; NO-GO si se exige facturar por esta ruta sin CU80 |
| IRPF | STANDARD posting/diarios; tratamiento fiscal específico UNKNOWN | CU99500: línea negativa o retención contable/Payment, posible doble movimiento99503 | **VALIDATION REQUIRED** | ALTO R04 | VF03/VF05 en ambos modos; no modificar CU99500 durante discovery |
| Abonos | STANDARD Tables114/115 y CU80 disponibles | CU99500 tiene rama Credit Memo; cancelación de recibo CU96003 no acredita abono estándar | **VALIDATION REQUIRED** | ALTO | VF04/VF05; verificar signo, aplicación y referencias |
| Rectificativas | STANDARD campos/funcionalidad ES; mapeo del servicio ausente | No circuito fiscal rectificativo OneData demostrado | **VALIDATION REQUIRED** | ALTO | VF06 con tipo/método reales soportados; no cambiar histórico |
| Histórico fiscal | STANDARD documentos registrados | CU98004 Rename/Modify de112/114 y cambios en movimientos | **ARCHITECTURAL RISK** | CRÍTICO R01 | Demostrar exclusión de herramientas sobre documentos fiscales y resolver riesgo antes de GO |
| Impresión | STANDARD1306/1307; layout fiscal efectivo pendiente | Report96003 sobre tablas propias; reportextension99500 RDLC sobre1306 | **VALIDATION REQUIRED**; posible **MINOR DEVELOPMENT** para layout de1306; **DEVELOPMENT REQUIRED** si96003 carece de vínculo fiscal | ALTO R05 | Comparar layout estándar y OneData; identificar primero dataset QR estándar |
| QR | STANDARD Barcode2D disponible; QR fiscal específico NOT FOUND | No QR fiscal en AL ni metadata RDLC96003 | **VALIDATION REQUIRED**; eventual **MINOR DEVELOPMENT** de presentación | ALTO R05 | VF12/VF13; consumir QR estándar, sin generar URL/hash propios |
| Document Sending Profile | STANDARD Table60 y envío genérico | Table96021 usa Usage Lease S.Invoice; CU96001 envía avisos directamente | **CONFIGURATION** + **VALIDATION REQUIRED** | MEDIO R07 | Distinguir aviso, PDF y exportación; verificar perfil cliente y workflow |
| Errores | STANDARD mecanismo fiscal concreto UNKNOWN; errores genéricos disponibles | No proyección fiscal propia encontrada | **VALIDATION REQUIRED** | MEDIO/ALTO | VF10; observar error/log estándar sin nueva máquina de estados |
| Reprocesamiento | STANDARD operación concreta UNKNOWN hasta símbolos/BC | No reprocesador fiscal propio encontrado | **VALIDATION REQUIRED** | ALTO | VF11 desde acción estándar real; comprobar no duplicación de emisión, contabilidad ni IRPF |
| Multicompañía | STANDARD permite acceso por empresa; tablas fiscales específicas pendientes | Lecturas Financial Flow y copias/replicación; CU99402 escribe tablas configurables | **ARCHITECTURAL RISK** para replicación; **VALIDATION REQUIRED** para lectura | ALTO R06 | Acreditar segregación, permisos y mappings; no diseñar consola aún |
| Monitor | STANDARD vistas específicas NOT FOUND localmente | No monitor VERI*FACTU encontrado | **VALIDATION REQUIRED**; eventual **MINOR DEVELOPMENT** de navegación/proyección | MEDIO | Evaluar suficiencia de páginas estándar antes de proponer UI; no crear estado paralelo |
| Readiness | STANDARD setup efectivo UNKNOWN | No checklist fiscal automatizada encontrada | **CONFIGURATION** manual; eventual **MINOR DEVELOPMENT** | MEDIO | Completar checklist del Discovery y justificar luego automatización de solo lectura |

## Priorización y evidencia necesaria

| Orden | Condición de salida | Evidencia | Responsable funcional sugerido |
|---|---|---|---|
| 1 | Motor y framework disponibles en empresa sandbox | Lista de apps/versiones/símbolos, objetos reales y destino de servicio | Administración BC |
| 2 | Preservación de histórico y segregación | Accesos/uso98004, mappings99402, inventario de permisos; no ejecutar herramientas de modificación en la PoC | Administración y responsable OneData Base |
| 3 | Alcance de emisor y contratos | Acquired y titularidad/emisor de rentas de Montornes, trazabilidad hasta112 | Responsable de facturación |
| 4 | Emisión estándar controlada | VF01 con histórico, E-Document, resultado de servicio y ausencia de doble envío | Consultoría BC |
| 5 | Compatibilidad IRPF y contractual | VF02/VF03/VF05 y variantes; conciliación de importes/movimientos | Consultoría BC + responsable IRPF |
| 6 | Documento entregable y recuperación | VF04–VF13, QR visible y reintento estándar sin duplicados | Consultoría BC |

Las responsabilidades son propuestas documentales; no se ha enviado ningún mensaje ni asignado tareas externamente.

## Límites de la decisión

No hay gap demostrado que obligue a generar XML/hash/cadena, almacenar certificados OneData, llamar AEAT directamente, duplicar E-Document o sustituir el servicio estándar. Tampoco hay fundamento para corregir fiscalmente112–115 después del registro. Si las pruebas demuestran esa necesidad, se mantiene **NO-GO** y se revisa el alcance/versión.

Solo se podrá pasar a **CONDITIONAL GO** cuando queden gaps de configuración o pequeñas extensiones con esfuerzo y comportamiento demostrados. Un motor faltante en caché, una dependencia transitiva ausente o un flujo fiscal no trazado no deben reclasificarse automáticamente como desarrollo menor.
