# Guía funcional para introducir seguros y vincularlos a los activos inmobiliarios

## 1. Objetivo del documento

Esta guía explica cómo dar de alta una póliza de seguro dentro de `OneData Property Management`, cómo relacionarla con un activo inmobiliario y cómo dejarla preparada para su uso posterior en la gestión de incidencias.

El objetivo no es solo registrar datos administrativos, sino conseguir que la información aseguradora:

- quede centralizada en la ficha del inmueble,
- pueda consultarse rápidamente por el equipo de gestión,
- se reutilice cuando una incidencia deba notificarse al seguro,
- mantenga una trazabilidad mínima de cobertura, vigencia y contacto.

## 2. Alcance funcional

Esta guía cubre:

- alta de la póliza vinculada al activo inmobiliario,
- vinculación de una misma póliza a varios activos inmobiliarios,
- datos mínimos recomendados para una carga correcta,
- criterios para decidir a qué inmueble asociar cada póliza,
- validaciones funcionales antes de cerrar el registro,
- uso posterior de la póliza desde una incidencia.

No cubre en detalle:

- contabilización de primas o recibos del seguro,
- automatización avanzada del siniestro,
- integración externa con aseguradoras o brokers,
- flujos automáticos de correo o Power Automate.

## 3. Cuándo conviene registrar un seguro

Conviene registrar la póliza cuando el inmueble ya forma parte de la operativa y se quiere asegurar alguno de estos escenarios:

- protección general del activo,
- cobertura de continente o contenido,
- responsabilidad civil,
- daños por agua, incendio u otras coberturas operativas,
- necesidad de comunicar incidencias al seguro sin buscar la información fuera del sistema.

La recomendación funcional es no esperar al primer siniestro. La póliza debería estar dada de alta desde el momento en que el activo entra en explotación o gestión.

## 4. Prerrequisitos

Antes de introducir el seguro conviene validar:

1. El `activo inmobiliario` ya existe y está correctamente identificado.
2. La ficha del inmueble tiene informados al menos su código, descripción y dirección.
3. Se dispone de la documentación mínima de la póliza.
4. Se conoce quién será el contacto operativo en caso de siniestro:
   - aseguradora,
   - mediador,
   - o ambos.

## 5. Información mínima que conviene recopilar

Antes de empezar la carga, reúne como mínimo estos datos:

- `N.º de póliza`
- `Aseguradora`
- `Mediador` o corredor, si aplica
- `Fecha inicio vigencia`
- `Fecha fin vigencia`
- `Tipo de cobertura`
- `Capital asegurado` o importe cubierto
- `Franquicia`
- `Teléfono o email de siniestros`
- `Activo inmobiliario` o conjunto de activos a los que corresponde

Si el usuario dispone de más detalle, también es útil recoger:

- referencia interna del expediente,
- observaciones operativas,
- contacto de renovación,
- documentación adjunta,
- limitaciones relevantes de cobertura.

## 6. Criterio para vincular la póliza al activo correcto

La póliza debe relacionarse con el inmueble que realmente soporta el riesgo asegurado.

Criterios recomendados:

### Regla especial para activos de tipo Propiedad

Cuando la póliza se vincula a un activo inmobiliario de tipo `Propiedad`, también debe vincularse a los activos inmobiliarios de tipo `Activo` relacionados con esa propiedad.

Esta regla es importante para que la cobertura no quede solo en el nivel patrimonial superior y también pueda localizarse desde los activos operativos que dependen de esa `Propiedad`.

En términos prácticos:

1. se registra la póliza sobre la `Propiedad`,
2. se revisan los activos de tipo `Activo` relacionados,
3. se replica o completa la vinculación para que la póliza quede visible y utilizable también desde esos activos.

El objetivo funcional es evitar que una incidencia abierta sobre un activo de tipo `Activo` quede sin acceso a la póliza que realmente cubre el riesgo.

### Una póliza para varios activos

La solución permite que una misma póliza quede vinculada a varios activos inmobiliarios.

Esto resulta especialmente útil cuando:

- una póliza cubre una propiedad completa y sus unidades o activos dependientes,
- existe una cobertura común para varios activos de la misma propiedad,
- se quiere reutilizar la misma información aseguradora sin duplicar fichas de póliza.

En este modelo, la póliza se mantiene como registro único y la relación con los inmuebles se gestiona mediante vínculos por activo.

### Un inmueble, una póliza

Usa este modelo cuando la póliza cubre de forma clara un único activo inmobiliario.

Es el escenario más simple y el más recomendable para:

- viviendas individuales,
- locales concretos,
- oficinas independientes,
- activos con gestión operativa autónoma.

### Un inmueble con varias pólizas

Puede darse cuando un mismo activo tiene varias coberturas diferenciadas, por ejemplo:

- multirriesgo,
- responsabilidad civil,
- cobertura específica de daños,
- póliza complementaria.

En ese caso conviene registrar cada póliza por separado para que, al abrir una incidencia, pueda elegirse la póliza aplicable.

### Una póliza que cubre varios inmuebles

Si existe una póliza global para varios activos, la recomendación funcional es revisar cómo queréis operar:

1. Si la gestión del siniestro se hace por inmueble, conviene reflejar la relación de forma que el usuario pueda identificar fácilmente qué activo queda cubierto.
2. Si la póliza maestra se usa solo a nivel corporativo, puede requerir una convención interna adicional para no perder trazabilidad.

En términos operativos, el principio clave es este: el usuario que registra una incidencia debe poder identificar sin duda qué póliza aplicar al inmueble afectado.

## 7. Flujo recomendado de alta

## Paso 1. Abrir la ficha del activo inmobiliario

Accede al `activo inmobiliario` desde la lista o desde su ficha.

La alta del seguro debería iniciarse desde el propio inmueble para asegurar que la póliza queda vinculada al activo correcto desde el primer momento.

## Paso 2. Crear la póliza de seguro

Dentro del bloque o acción de `seguros`, crea una nueva póliza asociada al inmueble.

La guía funcional recomienda que el alta incluya como mínimo:

- activo inmobiliario,
- número de póliza,
- aseguradora,
- mediador,
- vigencia,
- cobertura,
- franquicia,
- datos de contacto para siniestros.

Si la póliza debe cubrir más de un inmueble, en este paso se crea la póliza como cabecera y después se completan los vínculos con todos los activos que deban quedar cubiertos.

Si el inmueble seleccionado es de tipo `Propiedad`, la solución debe extender también la vinculación a los activos inmobiliarios de tipo `Activo` relacionados con esa propiedad.

En términos operativos, esto significa que no hace falta crear una póliza distinta por cada activo si realmente todos están cubiertos por la misma póliza.

## Paso 3. Informar los datos de identificación

Completa primero los datos que permiten reconocer la póliza:

- `N.º de póliza`
- nombre de la `aseguradora`
- nombre del `mediador`, si existe
- descripción corta o texto identificativo

Esta parte es importante porque será la que el usuario verá después al buscar o seleccionar la póliza desde una incidencia.

## Paso 4. Informar cobertura y condiciones básicas

Registra los datos que ayudan a decidir si una incidencia debe notificarse o no al seguro:

- tipo de cobertura,
- capital o importe cubierto,
- franquicia,
- limitaciones relevantes,
- observaciones si el equipo necesita contexto adicional.

La recomendación es priorizar la información útil para operación diaria y no intentar reproducir toda la póliza en el sistema.

## Paso 5. Informar vigencia

Revisa cuidadosamente:

- `fecha de inicio`,
- `fecha de fin`,
- y, si trabajáis así, el estado operativo de la póliza.

Una póliza mal fechada genera errores posteriores al seleccionar cobertura en incidencias.

## Paso 6. Informar contacto de siniestros

Introduce los datos de contacto que se reutilizarán cuando haya que comunicar una incidencia:

- email,
- teléfono,
- persona o departamento,
- observaciones de uso.

Este paso tiene mucho valor operativo porque evita buscar correos o teléfonos fuera de Business Central.

## Paso 7. Revisar y guardar

Antes de cerrar el alta, verifica:

1. La póliza está vinculada al inmueble correcto.
2. Si la póliza cubre varios activos, todos los vínculos necesarios están creados.
3. Si la póliza parte de una `Propiedad`, también se ha extendido a los activos `Activo` dependientes.
4. El número de póliza coincide con el documento original.
5. La vigencia está bien informada.
6. Existe al menos un contacto útil para siniestros.
7. La cobertura y la franquicia son comprensibles para el equipo.

## 8. Validaciones funcionales recomendadas

Después del alta, conviene hacer una revisión funcional rápida:

- abrir de nuevo la ficha del inmueble,
- comprobar que la póliza aparece en su contexto,
- comprobar que la póliza aparece también en los demás activos vinculados si es una póliza multi-activo,
- validar que no haya duplicados,
- revisar si hay otra póliza vigente para el mismo riesgo,
- confirmar que el usuario de incidencias podrá distinguirlas.

Se recomienda especialmente evitar estos errores:

- pólizas con número incompleto,
- vigencias solapadas sin explicación,
- contactos de siniestros vacíos,
- textos demasiado genéricos como `seguro edificio` sin más detalle.

### Sincronización automática con incidencias existentes

Cuando se asigna una póliza a un activo inmobiliario, la solución debe comprobar si ya existen incidencias relacionadas con ese activo.

Si existen incidencias abiertas o no cerradas, la solución puede completar automáticamente la información de seguro en la incidencia, por ejemplo:

- `Insurance Policy No.`
- descripción de la póliza
- datos de contacto del seguro
- marca de `Notify Insurance`
- estado `Pending` si corresponde

Esto es especialmente importante cuando la póliza se vincula después de que la incidencia ya exista, porque evita que el expediente se quede sin contexto asegurador.

Si la vinculación se hace sobre una `Propiedad`, esta sincronización también puede alcanzar a las incidencias de los activos `Activo` que heredan esa póliza.

## 9. Uso posterior desde incidencias

Una vez creada la póliza y vinculada al activo, su valor principal aparece cuando se registra una `incidencia`.

Flujo operativo esperado:

1. Se registra la incidencia sobre el inmueble.
2. Si el inmueble tiene póliza activa, la incidencia queda marcada para notificación al seguro.
3. Si solo existe una póliza activa para ese activo, la póliza se propone automáticamente.
4. El usuario revisa la póliza aplicable y completa la selección si hay varias opciones.
5. Reutiliza datos de contacto y contexto asegurador.
6. Ejecuta la notificación al seguro.
7. Deja trazabilidad de la notificación y del estado del siniestro.

Si la póliza se asigna al activo después de haberse creado la incidencia, la solución puede actualizar la incidencia existente con la nueva información aseguradora, siempre que no se esté sustituyendo otra póliza distinta ya seleccionada.

Esto evita duplicar información y reduce errores al comunicar:

- número de póliza,
- aseguradora correcta,
- canal de contacto,
- contexto del inmueble afectado.

### Comportamiento esperado al abrir la incidencia

Cuando la incidencia tiene un `activo inmobiliario` asociado con póliza activa, la solución debe recordar al usuario que existe una gestión pendiente con el seguro.

Comportamiento funcional esperado:

- la incidencia queda marcada con `Notify Insurance`,
- el estado del seguro puede quedar en `Pending` mientras no se haya comunicado,
- al abrir la ficha se muestra un aviso recordando que debe notificarse al proveedor del seguro,
- si todavía no hay póliza seleccionada, el aviso debe orientar al usuario a elegir la póliza aplicable antes de notificar.

Este comportamiento no sustituye la revisión del usuario, pero sí reduce el riesgo de que una incidencia asegurable se cierre sin iniciar la comunicación al seguro.

### Cuándo debe notificarse al proveedor del seguro

La guía funcional recomienda notificar cuando concurren estas condiciones:

- la incidencia afecta a un inmueble con póliza activa,
- el tipo de daño o incidencia encaja con la cobertura esperada,
- existe intención real de abrir o preparar un siniestro,
- el equipo ya dispone de información mínima para comunicar.

No todas las incidencias deben notificarse automáticamente en sentido operativo. La propuesta automática debe entenderse como una llamada de atención y una ayuda al proceso.

### Qué debe revisar el usuario antes de lanzar la notificación

Antes de usar la acción de notificación, conviene revisar:

- póliza seleccionada,
- email o teléfono de siniestros,
- descripción de la incidencia,
- fecha de incidencia,
- activo afectado,
- observaciones relevantes para la aseguradora.

### Control antes del cierre de la incidencia

Si una incidencia sigue marcada con `Notify Insurance`, no debería cerrarse mientras la notificación al seguro siga pendiente.

La recomendación funcional es mantener este control:

1. si procede comunicar al seguro, el usuario debe ejecutar la notificación,
2. si finalmente no procede, el usuario debe desmarcar la obligación de notificar,
3. solo después debería poder cerrarse la incidencia.

Este control ayuda a evitar cierres prematuros y mejora la trazabilidad del siniestro.

## 10. Recomendaciones de implantación

Para una puesta en marcha ordenada, conviene seguir estas pautas:

### Empezar por activos vigentes

Carga primero las pólizas de los inmuebles que están actualmente en explotación o generan más incidencias.

### Unificar criterio de nombres

Usad un criterio estable para describir pólizas, por ejemplo combinando:

- inmueble,
- tipo de seguro,
- número de póliza,
- aseguradora.

### No sobrecargar el registro

La ficha del seguro debe servir para operar, no para copiar íntegramente el condicionado contractual.

### Revisar vencimientos periódicamente

Aunque la guía se centra en el alta, conviene incluir una revisión periódica de pólizas próximas a vencimiento o ya vencidas.

### Definir criterio de notificación

Conviene acordar internamente qué tipos de incidencia deben abrir una gestión con el seguro y cuáles no, para que el equipo use `Notify Insurance` con un criterio homogéneo.

### Revisar calidad de datos de contacto

La automatización del recordatorio tiene valor solo si la póliza contiene datos válidos de comunicación de siniestros. Por eso conviene revisar periódicamente:

- `Claim E-Mail`,
- `Claim Phone No.`,
- vigencia de la póliza,
- correspondencia entre activo y póliza.

### Revisar vínculos multi-activo

Si una póliza cubre varios inmuebles, conviene revisar periódicamente que los vínculos entre póliza y activos sigan siendo correctos y completos, especialmente cuando:

- se crean nuevos activos dentro de una `Propiedad`,
- cambia la composición de los activos dependientes,
- una póliza deja de cubrir parte del conjunto.

## 11. Checklist rápido para el usuario

Antes de dar por completada la carga de un seguro, confirma:

- `Activo inmobiliario` correcto
- `N.º de póliza` informado
- `Aseguradora` informada
- `Mediador` informado si aplica
- `Vigencia` completa
- `Cobertura` comprensible
- `Franquicia` informada
- `Contacto de siniestros` disponible
- si la póliza está en una `Propiedad`, vínculo completado también en sus activos tipo `Activo`
- si la póliza cubre varios inmuebles, vínculos creados en todos los activos necesarios
- posibilidad real de seleccionar esa póliza desde una incidencia
- posibilidad real de notificar al seguro desde la incidencia si el caso lo requiere

## 12. Checklist rápido para incidencias con seguro

Cuando una incidencia puede derivar en comunicación al seguro, conviene confirmar:

- `Fixed Real Estate No.` informado
- póliza activa disponible para ese activo
- `Notify Insurance` revisado
- póliza seleccionada si existen varias
- datos de contacto del seguro informados
- información de seguro actualizada si la póliza se vinculó después de crear la incidencia
- incidencia todavía no cerrada sin notificación pendiente
- `Insurance Notified` actualizado cuando ya se ha comunicado

## 13. Resultado esperado

Si el proceso se ha hecho correctamente, el resultado funcional debería ser este:

- cada inmueble tiene visible su contexto asegurador,
- una misma póliza puede quedar vinculada a varios activos sin duplicar su ficha,
- las pólizas asignadas a una `Propiedad` quedan también accesibles desde sus activos de tipo `Activo`,
- el equipo sabe qué póliza corresponde a cada activo,
- las incidencias pueden vincularse a la póliza adecuada,
- las incidencias existentes se completan automáticamente cuando se asigna una póliza al activo,
- las incidencias con póliza activa recuerdan la necesidad de notificar al seguro,
- el cierre de incidencias evita dejar notificaciones pendientes sin revisar,
- la comunicación al seguro es más rápida,
- la trazabilidad del siniestro mejora dentro de `OneData Property Management`.
