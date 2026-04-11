# Manual de configuracion del agente de recepcion de incidencias

## 1. Objetivo
Este documento explica como configurar el agente de recepcion de incidencias de OneData Property Management para que lea correos desde un buzon compartido y los procese mediante Power Automate.

Pagina principal del producto:
[`/docs/solutions/property-management`](../solutions/property-management/index.html)

## 2. Requisitos previos
Antes de iniciar la configuracion conviene disponer de lo siguiente:

- Un buzon compartido de Microsoft 365 para recibir incidencias.
- Permisos de acceso a ese buzon para la cuenta que creara o ejecutara el flujo.
- Acceso a Power Automate.
- Acceso a Business Central.
- Si se va a usar IA, el servicio o endpoint de IA definido aparte.

## 3. Significado de los campos del asistente
En la pantalla de configuracion aparecen estos campos:

### Buzon compartido
Es la direccion del buzon de Office 365 que recibira los correos de incidencias.

Ejemplo:
`incidencias@empresa.com`

### Carpeta de correo entrante
Es la carpeta del buzon que Power Automate debe supervisar.

Ejemplos:
- `Inbox`
- `Inbox/Incidencias`

### Nombre del flujo de Power Automate
Es el nombre visible del flujo que se mostrara a los usuarios.

Ejemplo:
`ODPM - Recepcion de incidencias`

### URL del flujo de Power Automate
Es la URL del flujo que Business Central guarda como referencia para abrirlo o identificarlo.

## 4. Como crear el buzon compartido
En Microsoft 365 Admin Center:

1. Ir a la seccion de buzones compartidos.
2. Crear un nuevo buzon.
3. Asignar una direccion de correo especifica para incidencias.
4. Conceder acceso a los usuarios o cuentas que deban administrarlo.

Ejemplo recomendado:
`incidencias@empresa.com`

## 5. Como definir la carpeta a supervisar
Dentro del buzon compartido se debe decidir que carpeta vigilar:

- Si se quiere una configuracion simple, usar `Inbox`.
- Si se quiere separar estos correos de otros mensajes, crear una subcarpeta como `Incidencias` y usar una ruta equivalente a `Inbox/Incidencias`.

La carpeta indicada en Business Central debe coincidir con la que use el trigger del flujo en Power Automate.

## 6. Como crear el flujo en Power Automate
En Power Automate:

1. Entrar en `https://make.powerautomate.com`.
2. Seleccionar el entorno correcto.
3. Ir a `Create` o `Crear`.
4. Crear un flujo automatizado.
5. Asignar un nombre claro, por ejemplo `ODPM - Recepcion de incidencias`.
6. Elegir un disparador de Outlook para buzon compartido, por ejemplo `When a new email arrives in a shared mailbox (V2)`.
7. Configurar el trigger con el buzon compartido y la carpeta a vigilar.

## 7. Que debe hacer el flujo
Como minimo el flujo deberia:

1. Leer el correo nuevo.
2. Obtener remitente, asunto, cuerpo y adjuntos si existen.
3. Enviar esos datos al proceso de Business Central o al endpoint definido para la recepcion.
4. Crear o registrar la entrada para su revision.
5. Marcar el correo como procesado si el diseno lo requiere.

## 8. De donde se obtiene la URL del flujo de Power Automate
La URL del flujo se consigue directamente desde Power Automate, abriendo el flujo ya creado.

Pasos:

1. Entrar en `https://make.powerautomate.com`.
2. Seleccionar el entorno correcto.
3. Ir a `Mis flujos`.
4. Abrir el flujo que se usara para incidencias.
5. Copiar la URL que aparece en la barra del navegador.

Ejemplo de formato:
`https://make.powerautomate.com/environments/<entorno>/flows/<id-del-flujo>/details`

Que URL conviene pegar en este campo:
- Si el objetivo es abrir el flujo desde Business Central, pegar la URL de la pagina del flujo en Power Automate.
- Si la integracion esta construida con un trigger HTTP, podria usarse la URL del endpoint HTTP generado por ese trigger, pero eso depende de la implementacion.

Recomendacion:
Usar la URL de la pagina del flujo en Power Automate, obtenida desde `Mis flujos > abrir flujo > copiar URL del navegador`.

## 9. Valores de ejemplo para el asistente
Ejemplo completo:

- Buzon compartido: `incidencias@empresa.com`
- Carpeta de correo entrante: `Inbox`
- Nombre del flujo de Power Automate: `ODPM - Recepcion de incidencias`
- URL del flujo de Power Automate: `https://make.powerautomate.com/environments/xxxx/flows/yyyy/details`

## 10. Validacion recomendada
Despues de guardar la configuracion:

1. Enviar un correo de prueba al buzon compartido.
2. Confirmar que entra en la carpeta esperada.
3. Verificar que el flujo se ejecuta.
4. Confirmar que Business Central recibe o registra la entrada.
5. Revisar errores de permisos, carpeta o conectividad si algo falla.

## 11. Problemas habituales
- El flujo no se ejecuta: revisar permisos sobre el buzon y el trigger configurado.
- La carpeta no coincide: validar el nombre exacto de la carpeta en Outlook y en el flujo.
- La URL no sirve: asegurarse de copiar la URL del flujo abierto en Power Automate.
- No llega informacion a Business Central: revisar el paso del flujo que llama al destino final.

## 12. Configuracion minima recomendada
Para una primera puesta en marcha:

- Buzon compartido dedicado para incidencias.
- Carpeta `Inbox`.
- Flujo sencillo que lea asunto, remitente y cuerpo.
- Revision humana antes de automatizaciones mas agresivas.
