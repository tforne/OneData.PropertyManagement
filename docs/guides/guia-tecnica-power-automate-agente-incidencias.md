# Guia tecnica de Power Automate para el agente de incidencias

## 1. Objetivo del documento
Esta guia interna describe una configuracion tecnica recomendada para conectar un buzon compartido de Microsoft 365 con OneData Property Management mediante Power Automate, de forma que los correos de incidencias puedan leerse, transformarse y enviarse al flujo de recepcion definido por la solucion.

Pagina principal del producto:
[`/docs/solutions/property-management`](../solutions/property-management/index.html)

## 2. Alcance
Esta guia cubre:

- Configuracion del buzon compartido.
- Configuracion del trigger en Power Automate.
- Datos minimos que debe leer el flujo.
- Formas de integracion con Business Central.
- Obtencion correcta de la URL del flujo.
- Checklist de pruebas tecnicas.
- Errores habituales de configuracion.

No cubre en detalle:

- El diseno interno del endpoint de IA.
- La logica AL que procesa definitivamente la incidencia.
- Seguridad avanzada de Azure o redes privadas.

## 3. Arquitectura recomendada
Arquitectura base recomendada:

1. Un correo llega a un buzon compartido de Microsoft 365.
2. Power Automate detecta el mensaje nuevo en la carpeta configurada.
3. El flujo extrae asunto, remitente, cuerpo, fecha y adjuntos.
4. El flujo transforma esos datos al contrato esperado.
5. El flujo envia la informacion a Business Central o a un endpoint intermedio.
6. Business Central registra la entrada para revision o crea un borrador de incidencia.

## 4. Prerrequisitos tecnicos
Antes de configurar el flujo conviene validar lo siguiente:

- Existe un buzon compartido dedicado a incidencias.
- La cuenta que crea el flujo tiene acceso al buzon compartido.
- El entorno de Power Automate correcto esta identificado.
- Existe decision sobre el destino del flujo:
  - Opcion A: Business Central directamente.
  - Opcion B: Endpoint HTTP intermedio.
  - Opcion C: Flujo con paso adicional de IA antes de Business Central.
- Se conoce la carpeta exacta a monitorizar.
- Se ha decidido si los correos procesados se marcan, mueven o dejan intactos.

## 5. Configuracion del buzon compartido
Configuracion recomendada:

- Direccion dedicada, por ejemplo `incidencias@empresa.com`.
- Uso exclusivo para incidencias, evitando mezclar correo administrativo.
- Permisos de lectura y gestion para la cuenta de Power Automate.
- Carpeta principal de trabajo:
  - `Inbox` para una implantacion simple.
  - `Inbox/Incidencias` si se quiere separar el canal.

Recomendacion tecnica:
La carpeta indicada en Business Central y la carpeta indicada en el trigger del flujo deben coincidir exactamente.

## 6. Creacion del flujo en Power Automate
Ruta general:

1. Entrar en `https://make.powerautomate.com`.
2. Elegir el entorno correcto.
3. Ir a `Create`.
4. Seleccionar `Automated cloud flow`.
5. Asignar un nombre claro.

Nombre recomendado:
`ODPM - Recepcion de incidencias`

## 7. Trigger recomendado
Trigger recomendado para el escenario base:

`When a new email arrives in a shared mailbox (V2)`

Configuracion tecnica sugerida del trigger:

- `Shared mailbox address`: direccion del buzon compartido.
- `Folder`: `Inbox` o la subcarpeta definida.
- `Include attachments`: `Yes` si se quieren procesar adjuntos.
- `Only with attachments`: `No`, salvo que se quiera restringir.
- `Importance`: `Any`.
- `Fetch only unread messages`: segun estrategia operativa.

Recomendacion:
Para la primera version, no filtres en exceso. Es preferible capturar todo y decidir despues en el flujo o en Business Central.

## 8. Datos minimos que debe extraer el flujo
El flujo deberia capturar al menos estos campos:

- `messageId`
- `from`
- `subject`
- `body`
- `receivedDateTime`
- `hasAttachments`
- `attachments`
- `conversationId` si aplica
- `internetMessageId` si aplica

Si hay adjuntos, conviene recoger tambien:

- Nombre del archivo
- Tipo MIME
- Contenido o referencia al contenido

## 9. Estructura logica recomendada del flujo
Secuencia recomendada:

1. Trigger de correo nuevo.
2. Normalizacion de datos basicos.
3. Condicion opcional para descartar correos irrelevantes.
4. Transformacion del cuerpo del correo.
5. Lectura de adjuntos.
6. Llamada al destino final.
7. Registro de resultado.
8. Marcado o movimiento del correo procesado.

## 10. Opciones de integracion con Business Central
### Opcion A. Integracion directa con Business Central
Aplicable si existe una API, web service o interfaz expuesta por la solucion.

Ventajas:
- Menos componentes intermedios.
- Menor latencia.

Riesgos:
- Requiere que el contrato del lado BC este bien definido.
- Puede complicar autenticacion y tratamiento de adjuntos.

### Opcion B. Integracion mediante endpoint HTTP intermedio
Aplicable si un servicio externo recibe el correo, lo enriquece y luego lo reenvia o procesa.

Ventajas:
- Mas flexible para IA, reglas o transformaciones.
- Permite desacoplar Power Automate de Business Central.

Riesgos:
- Mas piezas que mantener.
- Mas puntos de fallo.

### Opcion C. Flujo con paso de IA antes del alta
Aplicable si Power Automate llama a un endpoint de IA y luego manda el resultado a Business Central.

Ventajas:
- Centraliza parte de la orquestacion en Power Automate.
- Facilita prototipos rapidos.

Riesgos:
- Los flujos se vuelven mas complejos.
- Depuracion mas dificil si hay varias llamadas encadenadas.

## 11. Contrato de datos recomendado
Ejemplo de payload minimo recomendado para envio:

```json
{
  "sharedMailbox": "incidencias@empresa.com",
  "folder": "Inbox",
  "messageId": "<id>",
  "from": "cliente@dominio.com",
  "subject": "Fuga de agua en cocina",
  "body": "Texto del correo...",
  "receivedDateTime": "2026-04-10T08:30:00Z",
  "hasAttachments": true,
  "attachments": [
    {
      "name": "foto1.jpg",
      "contentType": "image/jpeg"
    }
  ]
}
```

Si hay IA, la salida intermedia podria incluir:

```json
{
  "summary": "Incidencia por fuga de agua",
  "confidence": 0.92,
  "title": "Fuga de agua en cocina",
  "description": "El cliente informa de una fuga debajo del fregadero",
  "priority": "High"
}
```

## 12. De donde se obtiene la URL del flujo de Power Automate
La URL del flujo se obtiene desde la propia interfaz de Power Automate.

Pasos exactos:

1. Abrir `https://make.powerautomate.com`.
2. Seleccionar el entorno correcto.
3. Ir a `Mis flujos`.
4. Abrir el flujo creado para incidencias.
5. Copiar la URL de la barra del navegador.

Formato habitual:
`https://make.powerautomate.com/environments/<entorno>/flows/<id-del-flujo>/details`

Uso recomendado en Business Central:
- Pegar la URL de la pagina del flujo si el campo se usa para abrir o referenciar el flujo.
- Usar la URL HTTP del trigger solo si la implementacion concreta necesita el endpoint del trigger y no la pagina del flujo.

Criterio practico recomendado:
Para el campo `URL del flujo de Power Automate`, usar la URL visual del flujo en Power Automate, no una URL temporal ni una captura de ejecucion.

## 13. Valores que deben introducirse en el asistente de Business Central
Ejemplo de configuracion:

- `Buzon compartido`: `incidencias@empresa.com`
- `Carpeta de correo entrante`: `Inbox`
- `Nombre del flujo de Power Automate`: `ODPM - Recepcion de incidencias`
- `URL del flujo de Power Automate`: `https://make.powerautomate.com/environments/xxxx/flows/yyyy/details`

## 14. Checklist tecnico de validacion
### Validacion del buzon
- El buzon recibe correos.
- La cuenta del flujo puede acceder al buzon.
- La carpeta configurada existe.

### Validacion del trigger
- El flujo se dispara al recibir un correo.
- El trigger lee el buzon correcto.
- El trigger no apunta a una carpeta equivocada.

### Validacion de datos
- Asunto y remitente llegan correctamente.
- El cuerpo del correo se captura completo.
- Los adjuntos se detectan cuando existen.

### Validacion de integracion
- El destino devuelve respuesta correcta.
- Los errores quedan trazados.
- Business Central recibe o registra la entrada.

### Validacion funcional
- Un correo de prueba simple se procesa bien.
- Un correo con adjuntos se procesa bien.
- Un correo ambiguo no rompe el flujo.

## 15. Errores habituales y diagnostico
### El flujo no se dispara
Posibles causas:
- El trigger esta apuntando al buzon equivocado.
- La cuenta no tiene permisos sobre el buzon compartido.
- La carpeta configurada no coincide con la real.

### La URL guardada en Business Central no sirve
Posibles causas:
- Se ha copiado una URL de ejecucion en vez de la URL del flujo.
- Se ha copiado una URL de otro entorno.
- El usuario no tiene permisos sobre ese flujo.

### Business Central no recibe nada
Posibles causas:
- El paso HTTP o el conector final falla.
- El contrato JSON no coincide con lo esperado.
- La autenticacion del destino no es correcta.

### Los adjuntos no se procesan
Posibles causas:
- El trigger no incluye adjuntos.
- Falta una accion adicional para leerlos o transformarlos.
- El destino final no admite el formato enviado.

## 16. Recomendacion de implantacion inicial
Para arrancar con bajo riesgo:

1. Buzon dedicado para incidencias.
2. Carpeta `Inbox`.
3. Trigger `When a new email arrives in a shared mailbox (V2)`.
4. Captura de asunto, remitente, cuerpo y adjuntos.
5. Registro en Business Central o buffer antes de cualquier automatizacion fuerte.
6. Revision humana antes de crear incidencias definitivas.

## 17. Siguiente ampliacion recomendada
Una vez estabilizado el flujo base, el siguiente paso natural seria:

- Clasificacion previa con IA.
- Priorizacion automatica.
- Deteccion de posible siniestro.
- Creacion de borrador de incidencia con sugerencias.
- Trazabilidad completa entre correo, buffer y registro final.
