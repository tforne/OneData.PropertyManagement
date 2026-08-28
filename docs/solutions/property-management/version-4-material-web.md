# Version 4 - base documental para publicacion web

## Objetivo del documento

Este documento resume la funcionalidad nueva implementada en `src` con un enfoque reutilizable para:

- preparar la publicacion de la solucion en la web,
- redactar textos comerciales sin perder rigor funcional,
- alinear mensaje de producto, casos de uso y alcance real.

La informacion de este documento esta contrastada con los bloques:

- `src/AssetManagement`
- `src/FinancialFlow`
- `src/Incidents`

## Mensaje principal de la version

La version 4 incorpora una evolucion funcional relevante para la gestion inmobiliaria en Business Central en tres planos conectados:

1. estructuracion avanzada de activos inmobiliarios,
2. analisis financiero consolidado de contratos y cartera,
3. operativa de incidencias vinculada al contrato vigente.

No se trata solo de añadir pantallas nuevas. La solucion mejora la capacidad de:

- representar mejor inmuebles complejos,
- interpretar con mas claridad la rentabilidad y el riesgo,
- convertir una desviacion detectada en una accion operativa inmediata.

## Resumen ejecutivo para web

OneData Property Management Version 4 anade una nueva capa de control sobre la cartera inmobiliaria:

- organiza propiedades, viviendas, habitaciones, parkings y trasteros dentro de una estructura jerarquica,
- analiza contratos y activos en varias empresas desde un unico mapa financiero,
- detecta riesgo, vencimientos y diferencias de cobro,
- permite guardar snapshots historicos y compararlos,
- conecta el analisis financiero con la gestion de incidencias.

## Bloque 1 - Asset Management

### Que resuelve

Muchas carteras necesitan representar una propiedad como un conjunto de unidades relacionadas. La vista clasica del inmueble no siempre permite trabajar con suficiente claridad cuando existen viviendas, habitaciones, parkings, trasteros u otros subactivos.

### Que incorpora la version 4

Sobre la tabla maestra `Fixed Real Estate`, la version 4 introduce dos nuevos ejes:

- clasificacion del activo mediante `OD Asset Type`,
- relacion jerarquica entre activos mediante `OD Parent FRE No.`.

Con esto, una propiedad puede modelarse como estructura:

`Propiedad -> Activo principal -> Subactivo`

### Capacidades funcionales

- vista especifica de estructura de activos,
- lista operativa de activos,
- creacion guiada de viviendas, habitaciones, parkings, trasteros y activos genericos,
- factbox de apoyo contextual,
- apertura de la ficha clasica del inmueble desde la nueva estructura.

### Reglas de consistencia

La solucion valida automaticamente:

- que una propiedad no tenga padre,
- que un activo no se asigne a si mismo como padre,
- que no existan ciclos en la jerarquia,
- que padre e hijo pertenezcan a la misma propiedad raiz,
- que el activo herede la informacion base de la propiedad cuando corresponde.

### Beneficio para el cliente

- mejor organizacion del inventario inmobiliario,
- lectura mas clara de inmuebles complejos,
- alta mas rapida de nuevas unidades,
- menos dependencia de convenciones manuales.

### Mensajes reutilizables para web

- "Estructure cada propiedad como una jerarquia real de activos y subactivos."
- "Gestione viviendas, habitaciones, parkings y trasteros desde una vista unificada."
- "Mantenga la compatibilidad con su maestro actual de inmuebles."

## Bloque 2 - Financial Flow

### Que resuelve

La gestion de cartera necesita una vista consolidada que combine contratos, rentas, valor del activo y riesgo, incluso cuando la operacion se reparte entre varias empresas de Business Central.

### Que incorpora la version 4

La nueva pagina `OD FF Map` actua como centro de analisis financiero multicompañia. El proceso recorre empresas, lee contratos de alquiler, normaliza importes, calcula indicadores y guarda el resultado en un buffer de trabajo por usuario.

### Configuracion disponible

La configuracion `OD FF Setup` permite ajustar criterios como:

- inclusion de empresas inactivas o bloqueadas,
- inclusion de contratos vencidos, futuros o cancelados,
- exclusion de empresas de prueba,
- origen de valor por defecto,
- porcentaje de costes de venta,
- mantenimiento anual,
- vacancia,
- gestion,
- tasa de descuento,
- yield objetivo minimo,
- concentracion maxima por cliente,
- dias de aviso antes del vencimiento.

### Indicadores calculados

Entre los calculos implementados destacan:

- renta mensual normalizada,
- renta anual,
- meses restantes de contrato,
- ingreso restante,
- previsiones a 12, 24 y 60 meses,
- costes operativos,
- ingreso neto anual,
- yield bruto,
- yield neto,
- ROI,
- cap rate,
- plusvalia estimada,
- cash flow,
- concentracion por cliente,
- nivel de riesgo y motivo del riesgo.

### Riesgos que detecta

El analisis actual puede marcar riesgo por situaciones como:

- contrato proximo a vencer,
- contrato sin fecha final,
- importe pendiente elevado,
- concentracion excesiva en un cliente,
- activo sin valor de mercado,
- activo sin referencia catastral,
- rentabilidad por debajo del objetivo,
- ausencia de fianza o garantia,
- datos contractuales incompletos.

### Acciones disponibles

Desde el mapa financiero el usuario puede:

- lanzar el analisis,
- refrescarlo,
- abrir un resumen del contrato,
- abrir el activo en su empresa de origen,
- guardar snapshots,
- ver historico,
- comparar snapshots,
- exportar a Excel,
- filtrar riesgos,
- filtrar proximos vencimientos,
- crear una incidencia por diferencia de cobro.

### Beneficio para el cliente

- vision consolidada de la cartera,
- mayor capacidad de control financiero,
- deteccion temprana de contratos sensibles,
- base objetiva para priorizar acciones comerciales y operativas.

### Mensajes reutilizables para web

- "Analice contratos, rentas, valor de activo y riesgo desde una unica vista."
- "Consolide informacion de varias empresas de Business Central sin salir del entorno."
- "Convierta datos dispersos en decisiones operativas y financieras."

## Bloque 3 - Incidencias conectadas con contratos

### Que resuelve

En la gestion diaria, una incidencia necesita quedar vinculada no solo al activo, sino tambien al contrato vigente que realmente esta afectado.

### Que incorpora la version 4

La ficha de incidencia sustituye la seleccion basica del contrato por una busqueda guiada:

- parte del activo informado en la incidencia,
- busca contratos vigentes en las empresas disponibles,
- muestra solo opciones seleccionables,
- rellena automaticamente los datos de cliente y contacto al elegir contrato.

### Datos sincronizados

Al seleccionar un contrato se completan automaticamente:

- numero de contrato,
- cliente,
- contacto,
- nombre del contacto,
- telefonos,
- correos electronicos.

### Reglas funcionales

La seleccion excluye:

- contratos futuros,
- contratos vencidos,
- contratos cancelados, finalizados o cerrados.

Ademas, si cambia el activo de la incidencia, la informacion contractual se limpia para evitar inconsistencias.

### Beneficio para el cliente

- menos errores manuales,
- mas contexto dentro de cada incidencia,
- respuesta mas rapida,
- mejor trazabilidad entre activo, contrato y problema detectado.

### Mensajes reutilizables para web

- "Relacione cada incidencia con el contrato vigente correcto."
- "Reduzca errores manuales en la asignacion de cliente y contacto."
- "Gane trazabilidad entre operacion, activo y arrendatario."

## Punto diferencial - de analisis a accion

Uno de los elementos mas potentes de la version 4 es la conexion entre `Financial Flow` e `Incidents`.

Cuando el analisis detecta una diferencia de cobro, el usuario puede crear una incidencia directamente desde la linea analizada. La incidencia nace ya contextualizada con:

- activo,
- contrato,
- cliente,
- contacto,
- descripcion orientada a la desviacion,
- observaciones con datos economicos relevantes.

Este punto es especialmente valioso para el discurso web porque muestra que la solucion no se queda en el reporting: ayuda a actuar.

## Propuesta de enfoque comercial para la web

### Titular posible

`Mas control sobre la cartera, mas claridad financiera y mas capacidad de accion.`

### Subtitular posible

`La Version 4 de OneData Property Management incorpora estructura jerarquica de activos, analisis financiero consolidado e incidencias conectadas con contratos vigentes dentro de Business Central.`

### Tres mensajes de valor

- `Estructure mejor su cartera`: represente propiedades y unidades con jerarquia real.
- `Analice mejor su rentabilidad`: consolide contratos, rentas, valor y riesgo en una sola vista.
- `Actue antes`: transforme desviaciones de cobro en incidencias operativas con contexto completo.

## Casos de uso para la pagina web

### Family office o patrimonialista

Necesita ver la cartera consolidada, identificar rentabilidades por debajo de objetivo y seguir la evolucion en el tiempo con snapshots.

### Gestor de alquiler residencial

Necesita estructurar inmuebles por viviendas y habitaciones, detectar contratos proximos a vencer y reducir errores en incidencias.

### Operador multicompañia

Necesita analizar contratos en varias empresas, mantener una vista comun y trabajar sin romper la organizacion societaria existente.

## Alcance real y limites observables

Para que la publicacion web sea rigurosa, conviene mantener estas precisiones:

- la estructura jerarquica se visualiza con indentacion, no con un arbol expandible nativo,
- el detalle del inmueble sigue apoyandose en la ficha clasica `Fixed Real Estate Card`,
- el analisis financiero requiere ejecucion previa para cargar el buffer del usuario,
- la calidad del resultado depende de la calidad de los datos maestros y contractuales,
- la apertura del activo en otra empresa se resuelve abriendo la lista de activos de la empresa de origen.

## Recomendacion para la siguiente fase

Este documento ya permite construir la publicacion web. El siguiente paso natural seria derivarlo a:

1. estructura de secciones para la pagina,
2. copy final orientado a cliente,
3. bloques visuales con capturas o mockups,
4. tabla comparativa entre version anterior y version 4.
