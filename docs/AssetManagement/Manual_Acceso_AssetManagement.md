# Manual de acceso y uso - OneData Asset Management

## Objetivo

Este manual explica como acceder y utilizar la funcionalidad incluida en:

`src/AssetManagement`

El modulo `OneData Asset Management` permite trabajar con una vista jerarquica de activos inmobiliarios sobre la misma tabla maestra `Fixed Real Estate`, sin sustituir la operativa clasica existente.

## Alcance funcional

La funcionalidad incorpora principalmente:

- una estructura jerarquica de activos,
- una lista operativa de activos,
- un factbox de resumen por propiedad,
- un dialogo guiado para crear nuevos activos.

La jerarquia permite representar escenarios como:

`Propiedad -> Vivienda -> Habitacion`

o bien:

`Propiedad -> Parking`

## Requisitos de acceso

Para utilizar esta funcionalidad, el usuario debe disponer de permisos sobre OneData Property Management compatibles con `Asset Management`.

En la implementacion actual existen extensiones de permisos para perfiles como:

- `ODPM ADMIN`
- `ODPM READ`
- `ODPM SETUP`
- `ODPM USER`

Si el usuario no ve las paginas indicadas en este manual, conviene revisar primero sus permisos asignados en Business Central.

## Pantallas disponibles

La carpeta `src/AssetManagement` incorpora estas pantallas principales:

- `OD AM Asset Structure`
- `OD AM Asset List`
- `OD AM Property Asset FactBox`
- `OD AM New Asset`

## Como acceder a la funcionalidad

### Opcion 1 - Desde Buscar en Business Central

1. Abrir Business Central.
2. Usar la busqueda global `Tell Me`.
3. Buscar una de estas opciones:
   - `Estructura de activos`
   - `Activos`
4. Abrir la pagina deseada.

### Opcion 2 - Desde navegacion funcional interna

Si la solucion incorpora accesos directos en menus o perfiles del cliente, se puede entrar desde esos puntos de navegacion. Aun asi, el acceso mas directo y fiable para esta version es mediante `Tell Me`.

## Pagina 1 - Estructura de activos

### Finalidad

La pagina `Estructura de activos` es la vista principal del modulo. Permite seleccionar una propiedad raiz y visualizar los activos relacionados en forma jerarquica.

### Que muestra

La pagina presenta:

- estructura jerarquica,
- tipo de activo,
- estado,
- propiedad raiz,
- activo padre,
- indicador de hijos,
- ultima renta registrada.

Ademas, incorpora un `FactBox` de resumen con conteos de:

- activos,
- viviendas,
- habitaciones,
- parkings,
- trasteros.

### Como usarla

1. Abrir `Estructura de activos`.
2. En el filtro `Property No.`, buscar y seleccionar una propiedad.
3. Revisar la descripcion de la propiedad mostrada en `Descripcion propiedad`.
4. Consultar la estructura generada en la rejilla principal.

### Interpretacion de la estructura

- La propiedad raiz aparece en el primer nivel.
- Los activos hijos se muestran con indentacion visual.
- Si un activo cuelga de otro activo, aparecera con un nivel adicional de indentacion.

Importante: en esta version la jerarquia se representa mediante indentacion visual, no mediante un arbol expandible nativo.

### Acciones disponibles

Desde esta pagina se puede:

- crear una nueva vivienda,
- crear una nueva habitacion,
- crear un nuevo parking,
- crear un nuevo trastero,
- crear un nuevo activo generico,
- abrir la ficha clasica del inmueble,
- actualizar la estructura.

## Alta de activos desde la estructura

### Nueva vivienda

Utilice `Nueva vivienda` cuando necesite crear una unidad principal bajo la propiedad seleccionada.

Flujo:

1. Seleccionar la propiedad raiz.
2. Pulsar `Nueva vivienda`.
3. Se abrira la `Fixed Real Estate Card`.
4. Completar los datos del nuevo activo.
5. Guardar el registro.
6. Volver a la estructura y revisar la nueva linea.

### Nueva habitacion

Utilice `Nueva habitacion` cuando necesite crear una habitacion debajo de una vivienda existente.

Condicion importante:

- esta accion solo funciona cuando la linea seleccionada es un activo de tipo `Vivienda`.

Flujo:

1. Abrir la estructura de la propiedad.
2. Seleccionar una vivienda existente.
3. Pulsar `Nueva habitacion`.
4. Completar la ficha clasica del nuevo activo.
5. Guardar.
6. Verificar que la habitacion aparece debajo de la vivienda seleccionada.

Si se intenta usar esta accion sobre una propiedad, un parking, un trastero u otro activo no valido, el sistema mostrara error.

### Nuevo parking

Utilice `Nuevo parking` para dar de alta una plaza de garaje bajo la propiedad raiz seleccionada.

Flujo:

1. Seleccionar la propiedad.
2. Pulsar `Nuevo parking`.
3. Completar la ficha clasica.
4. Guardar.

### Nuevo trastero

Utilice `Nuevo trastero` para crear un trastero bajo la propiedad raiz.

Flujo:

1. Seleccionar la propiedad.
2. Pulsar `Nuevo trastero`.
3. Completar la ficha clasica.
4. Guardar.

### Nuevo activo

Utilice `Nuevo activo` cuando necesite crear un activo con tipo elegido manualmente.

El dialogo permite seleccionar tipos como:

- vivienda,
- habitacion,
- plaza de garaje,
- trastero,
- local comercial,
- oficina,
- nave industrial,
- solar / terreno,
- otro.

Flujo:

1. Situarse en la estructura.
2. Pulsar `Nuevo activo`.
3. Elegir el `Tipo de activo`.
4. Confirmar.
5. Completar la ficha clasica del nuevo registro.
6. Guardar.

Si hay una linea seleccionada, el sistema intentara usarla como referencia para el alta. Si no, tomara como referencia la propiedad raiz seleccionada.

## Pagina 2 - Activos

### Finalidad

La pagina `Activos` ofrece una lista operativa moderna centrada exclusivamente en registros de tipo activo.

### Que muestra

La lista incluye, entre otros, estos campos:

- numero,
- descripcion,
- `Property No.`,
- `OD Parent FRE No.`,
- `OD Asset Type`,
- estado,
- precio de venta,
- ultima renta,
- renta minima.

### Cuando usar esta pagina

Esta vista es util para:

- consultar activos sin navegar por propiedad,
- revisar clasificacion y jerarquia,
- mantener informacion operativa de los activos.

## FactBox - Resumen de activos

### Finalidad

El `FactBox` asociado resume rapidamente la composicion de la propiedad seleccionada.

### Indicadores mostrados

- total de activos,
- total de viviendas,
- total de habitaciones,
- total de parkings,
- total de trasteros.

Este resumen ayuda a validar que la estructura de una propiedad tenga sentido y a detectar rapidamente si faltan unidades por clasificar.

## Ficha clasica del inmueble

### Relacion con Asset Management

Aunque la funcionalidad introduce una nueva forma de visualizar y crear activos, el mantenimiento detallado del registro sigue realizandose sobre la ficha clasica:

`Fixed Real Estate Card`

Esto significa que:

- Asset Management no sustituye la ficha clasica,
- la ficha clasica sigue siendo el punto principal de edicion de detalle,
- las altas creadas desde la estructura terminan en esa ficha.

## Campos nuevos relevantes

La extension añade dos campos al maestro `Fixed Real Estate`:

### `OD Asset Type`

Clasifica el activo. Algunos tipos disponibles son:

- sin definir,
- vivienda,
- habitacion,
- plaza de garaje,
- trastero,
- local comercial,
- oficina,
- nave industrial,
- solar / terreno,
- otro.

### `OD Parent FRE No.`

Indica el activo padre dentro de la jerarquia.

## Reglas de negocio

El sistema aplica validaciones para proteger la consistencia de la estructura:

- una propiedad no puede tener activo padre,
- un activo no puede ser padre de si mismo,
- no se permiten ciclos en la jerarquia,
- el padre y el hijo deben pertenecer a la misma propiedad raiz,
- cuando corresponde, el activo hereda informacion de la propiedad raiz.

## Escenarios recomendados de uso

### Escenario 1 - Crear estructura de propiedad residencial

1. Seleccionar la propiedad.
2. Crear una o varias viviendas.
3. Seleccionar cada vivienda y crear sus habitaciones.
4. Crear parkings y trasteros vinculados a la misma propiedad.
5. Revisar el resumen del `FactBox`.

### Escenario 2 - Revisar activos existentes

1. Abrir `Activos`.
2. Filtrar por `Property No.` o por `OD Asset Type`.
3. Revisar si los activos tienen clasificacion correcta.
4. Validar si el activo padre esta informado cuando debe estarlo.

### Escenario 3 - Consultar una propiedad compleja

1. Abrir `Estructura de activos`.
2. Buscar la propiedad raiz.
3. Revisar visualmente la composicion del inmueble.
4. Abrir ficha clasica de cualquier linea si se necesita mayor detalle.

## Limitaciones actuales

Segun la implementacion actual:

- la estructura usa indentacion visual y no nodos expandibles,
- no existe una ficha nueva especifica de Asset Management,
- la ficha clasica sigue siendo la referencia de detalle,
- los activos legacy pueden seguir existiendo con campos nuevos en blanco.

## Recomendaciones de uso

- usar `Estructura de activos` para construir y revisar la jerarquia,
- usar `Activos` para mantenimiento masivo o consulta operativa,
- mantener bien informado el `Tipo de activo`,
- revisar que cada activo tenga el padre correcto cuando aplique,
- evitar altas manuales fuera del flujo si se quiere preservar una estructura coherente.

## Resumen final

`OneData Asset Management` aporta una capa estructurada para organizar activos inmobiliarios complejos sin romper la base actual de `Fixed Real Estate`.

La mejor forma de trabajar con esta funcionalidad en la version actual es:

1. acceder por `Tell Me`,
2. usar `Estructura de activos` como pantalla principal,
3. crear activos desde las acciones guiadas,
4. completar el detalle en la `Fixed Real Estate Card`,
5. utilizar `Activos` para consulta y mantenimiento operativo.
