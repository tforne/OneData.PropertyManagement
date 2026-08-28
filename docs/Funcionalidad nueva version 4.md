# Nueva funcionalidad de la version 4

## Objetivo

La version 4 incorpora tres bloques funcionales principales dentro de la carpeta `src`:

- `AssetManagement`: nueva gestion jerarquica de activos inmobiliarios sobre la base de `Fixed Real Estate`.
- `FinancialFlow`: nuevo analizador transversal de contratos, rentas, yields, riesgo y snapshots.
- `Incidents`: mejora del proceso de incidencias para vincularlas de forma mas precisa con contratos activos.

El objetivo global de esta version es aportar una capa de analisis y operacion mas moderna sobre la informacion inmobiliaria ya existente, sin sustituir los procesos base actuales y manteniendo compatibilidad con la estructura maestra del sistema.

## Resumen ejecutivo

La version 4 no redefine el modelo principal del inmueble, sino que lo amplía con nuevas capacidades:

- Permite representar una propiedad como una estructura jerarquica compuesta por activos y subactivos.
- Facilita la creacion de viviendas, habitaciones, parkings, trasteros y otros activos desde una vista estructurada.
- Introduce un mapa financiero consolidado para analizar contratos de alquiler entre empresas.
- Calcula indicadores de rendimiento y riesgo de forma automatica.
- Permite guardar snapshots del analisis y compararlos en el tiempo.
- Conecta el analisis financiero con la gestion de incidencias, especialmente en diferencias de cobro.
- Mejora la seleccion de contratos en incidencias mostrando solo contratos vigentes y relevantes para el activo.

## 1. Asset Management

### 1.1 Finalidad

Este bloque introduce una vista paralela de gestion de activos sobre la tabla maestra `Fixed Real Estate`. La idea principal es permitir que una propiedad no se trate solo como un elemento aislado, sino como la raiz de una jerarquia compuesta por activos relacionados.

Ejemplo conceptual:

- Propiedad
- Vivienda
- Habitacion
- Parking
- Trastero

### 1.2 Cambios funcionales principales

Se añaden dos campos al maestro de inmuebles:

- `OD Asset Type`: clasifica el activo.
- `OD Parent FRE No.`: identifica el activo padre dentro de la jerarquia.

Con esto, el sistema puede relacionar activos entre si y construir una estructura tipo:

`Propiedad -> Activo principal -> Subactivo`

### 1.3 Comportamiento de negocio

La funcionalidad valida automaticamente la consistencia de la jerarquia:

- Una propiedad no puede tener padre.
- Un activo no puede apuntarse a si mismo como padre.
- No se permiten ciclos jerarquicos.
- El padre y el hijo deben pertenecer a la misma propiedad raiz.
- Cuando procede, el activo hereda automaticamente informacion base de la propiedad raiz.

Esto reduce errores estructurales y evita configuraciones incoherentes dentro del parque inmobiliario.

### 1.4 Pantallas nuevas

#### `OD AM Asset Structure`

Nueva vista de estructura jerarquica de activos:

- Permite seleccionar una propiedad raiz.
- Muestra la estructura completa de activos asociados.
- Presenta la jerarquia con indentacion visual.
- Permite crear directamente nuevos activos desde la estructura.
- Incluye acceso a la ficha clasica del activo.

Desde esta pantalla se pueden crear:

- Nueva vivienda
- Nueva habitacion
- Nuevo parking
- Nuevo trastero
- Nuevo activo generico

#### `OD AM Asset List`

Nueva lista operativa de activos:

- Muestra solo registros de tipo `Activo`.
- Ofrece una vista moderna centrada en numero, descripcion, propiedad raiz, padre jerarquico, tipo, estado y precios.
- Mantiene como referencia de detalle la ficha clasica `Fixed Real Estate Card`.

#### `OD AM Property Asset FactBox`

FactBox de apoyo para enriquecer la consulta del activo o propiedad seleccionada.

#### `OD AM New Asset`

Dialogo de alta simplificado para crear activos indicando su tipo.

### 1.5 Beneficios operativos

- Mejor representacion de propiedades complejas.
- Mayor claridad en la relacion entre propiedad, activo y subactivo.
- Creacion mas rapida de unidades inmobiliarias.
- Menor dependencia de estructuras manuales o convenciones no controladas.

### 1.6 Alcance y compatibilidad

Esta funcionalidad:

- No sustituye las paginas clasicas existentes.
- Se apoya sobre el maestro actual de `Fixed Real Estate`.
- Mantiene compatibilidad con datos existentes.
- Considera validos los activos anteriores aunque no tengan jerarquia informada.

## 2. Financial Flow

### 2.1 Finalidad

Este bloque incorpora un nuevo mapa financiero consolidado para analizar el comportamiento economico de contratos de alquiler, activos y empresas desde una unica vista.

El objetivo es que el usuario pueda detectar rapidamente:

- rentabilidad,
- riesgo,
- proximidad de vencimientos,
- concentracion por cliente,
- diferencias entre renta esperada y cobro informado.

### 2.2 Configuracion inicial

Se incorpora una nueva configuracion `OD FF Setup` con parametros de analisis.

Entre los parametros disponibles se incluyen:

- inclusion o exclusion de empresas inactivas o bloqueadas,
- inclusion o exclusion de contratos vencidos, futuros o cancelados,
- exclusion de empresas de prueba,
- origen de valoracion por defecto,
- porcentaje de costes de venta,
- porcentaje de mantenimiento,
- porcentaje de vacancia,
- porcentaje de gestion,
- tasa de descuento,
- yield objetivo minimo,
- concentracion maxima por cliente,
- dias de aviso antes del vencimiento,
- serie numerica para snapshots.

Esto permite adaptar el analisis a criterios reales de negocio sin tocar codigo.

### 2.3 Mapa de analisis financiero

La pagina `OD FF Map` actua como centro funcional del modulo.

Muestra:

- empresas analizadas,
- activos incluidos,
- contratos vigentes,
- renta mensual y anual agregada,
- valor total de mercado,
- yield bruto ponderado,
- yield neto ponderado.

Ademas, por cada linea de contrato informa de:

- empresa,
- contrato,
- cliente,
- fechas de inicio y vencimiento,
- renta mensual y anual,
- valor del activo,
- previsiones de ingresos,
- yield bruto y neto,
- cash flow,
- nivel de riesgo,
- diferencia de cobros,
- motivo del riesgo,
- errores detectados.

### 2.4 Analisis automatico

La codeunit de gestion ejecuta un analisis consolidado por empresa y contrato:

- recorre las empresas del entorno,
- aplica los filtros configurados,
- analiza los contratos que entran en alcance,
- obtiene informacion del contrato y del activo,
- calcula indicadores financieros,
- genera un buffer de trabajo por usuario,
- recalcula concentracion de cliente y nivel de riesgo.

Esto significa que cada usuario puede lanzar su propio analisis sin interferir en el de otros usuarios.

### 2.5 Indicadores calculados

La version 4 incorpora, entre otros, los siguientes calculos:

- renta anual,
- meses restantes de contrato,
- ingreso restante del contrato,
- prevision de ingresos a 12, 24 y 60 meses,
- costes operativos anuales,
- ingreso neto anual,
- yield bruto,
- yield neto,
- ROI,
- cap rate,
- plusvalia estimada,
- cash flow,
- concentracion de cliente,
- nivel de riesgo y descripcion del riesgo.

### 2.6 Acciones disponibles

Desde `OD FF Map` el usuario puede:

- ejecutar el analisis,
- refrescar el analisis,
- guardar un snapshot,
- abrir un resumen de contrato,
- abrir el activo en la empresa correspondiente,
- crear una incidencia por diferencia de cobro,
- consultar el historico,
- comparar snapshots,
- exportar a Excel,
- filtrar solo riesgos,
- filtrar proximos vencimientos.

### 2.7 Snapshots e historico

Se incorpora una capa de fotografia historica del analisis:

- permite guardar el estado exacto del analisis en un momento dado,
- registrar el ultimo snapshot generado,
- consultar historico,
- comparar snapshots para identificar cambios.

Esto aporta trazabilidad y seguimiento temporal de la cartera.

### 2.8 Exportacion

El analisis se puede exportar a Excel, incluyendo las lineas visibles y los principales totales, facilitando reporting, revision y distribucion fuera del sistema.

### 2.9 Integracion con Role Centers

La funcionalidad queda accesible desde extensiones sobre:

- `FRE Finance Role Center`
- `Real Estate Role Center`

De esta manera, el acceso al analisis y a la configuracion se integra en la navegacion habitual del usuario.

### 2.10 Beneficios de negocio

- Vision consolidada de la cartera en varias empresas.
- Mayor control sobre rentabilidad real y esperada.
- Deteccion temprana de contratos de riesgo o proximos a vencer.
- Seguimiento de desviaciones de cobro.
- Base objetiva para decisiones comerciales, financieras y operativas.

## 3. Mejora de incidencias con contratos

### 3.1 Finalidad

La version 4 mejora la relacion entre incidencias y contratos de alquiler para que una incidencia no quede vinculada solo al activo, sino tambien al contrato vigente correspondiente cuando exista.

### 3.2 Cambios funcionales

En la ficha de incidencia:

- el campo de contrato se sustituye funcionalmente por una busqueda guiada,
- solo se ofrecen contratos vigentes y seleccionables para el activo,
- al elegir un contrato se rellenan automaticamente los datos derivados.

Los datos que se sincronizan incluyen:

- numero de contrato,
- cliente,
- contacto,
- nombre del contacto del contrato,
- telefonos,
- correos electronicos.

### 3.3 Reglas aplicadas

La seleccion de contratos sigue reglas de negocio:

- el activo debe estar informado,
- se consideran contratos ligados al activo o a la propiedad,
- no se muestran contratos futuros,
- no se muestran contratos vencidos,
- no se muestran contratos cancelados, finalizados o cerrados.

Si cambia el activo de la incidencia, el sistema limpia la informacion contractual para evitar inconsistencias.

### 3.4 Beneficios operativos

- Menos errores manuales en la asociacion de incidencias.
- Mejor contexto comercial y operativo dentro de cada incidencia.
- Mayor rapidez para contactar con la persona adecuada.
- Mejor trazabilidad entre problema detectado, activo y contrato afectado.

## 4. Integracion entre Financial Flow e Incidents

Uno de los puntos mas valiosos de la version 4 es la conexion entre el analisis financiero y la gestion operativa.

Desde `OD FF Map`, cuando existe una diferencia de cobro pendiente, el usuario puede crear una incidencia directamente. La incidencia nace ya contextualizada con:

- activo inmobiliario,
- contrato,
- cliente y contacto,
- descripcion orientada a la diferencia de cobro,
- observaciones con datos economicos relevantes.

Esto transforma un analisis pasivo en una accion operativa inmediata.

## 5. Seguridad y permisos

La carpeta `src` incluye nuevos permisos asociados a los modulos incorporados:

- extensiones de permisos para Asset Management sobre perfiles `ODPM ADMIN`, `ODPM READ`, `ODPM SETUP` y `ODPM USER`,
- permission sets especificos para Financial Flow en perfiles de usuario y administrador.

Esto permite desplegar la funcionalidad de forma controlada segun el rol del usuario.

## 6. Impacto funcional esperado

La version 4 aporta impacto en cuatro planos:

- `Operacion`: mas facilidad para estructurar y mantener el inventario de activos.
- `Control`: mas capacidad para detectar riesgo, vencimientos y desviaciones.
- `Analisis`: mejor lectura financiera de contratos y activos.
- `Seguimiento`: mayor trazabilidad gracias a snapshots e incidencias contextualizadas.

## 7. Limitaciones actuales observables en `src`

Segun la implementacion actual contenida en `src`, hay varios puntos a tener en cuenta:

- la jerarquia de activos se representa con indentacion visual, no con un arbol expandible nativo,
- la ficha clasica sigue siendo la referencia principal para detalle de inmuebles,
- parte del analisis financiero trabaja sobre buffers por usuario y requiere ejecucion previa,
- la calidad del analisis depende de que contratos, valores y datos maestros esten correctamente informados.

## 8. Conclusion

La version 4 introduce una evolucion funcional importante del producto, especialmente en tres frentes: estructura de activos, analisis financiero y gestion operativa de incidencias.

No se trata solo de añadir pantallas nuevas, sino de incorporar una forma mas estructurada de trabajar:

- ver mejor la composicion de una propiedad,
- analizar mejor el rendimiento de la cartera,
- actuar mas rapido ante incidencias o desviaciones.

En conjunto, esta version mejora la capacidad de control, analisis y accion del equipo sobre el patrimonio inmobiliario gestionado en Business Central.
