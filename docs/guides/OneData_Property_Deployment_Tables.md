# OneData Property Management Deployment

## Architecture

`OneData Base Application` sigue siendo el unico motor de deployment.

`OneData Property Management` solo aporta definiciones mediante:

- `codeunit 99415 "OD Deployment Package Mgt."`
- event subscriber `OnAddDefaultDeploymentTables()`
- API publica `AddDeploymentTable(...)`
- event subscriber `OnBeforeIsExplicitlyExcludedField(...)`

Property Management no manipula directamente:

- `Config. Package`
- `Config. Package Table`
- `Config. Package Field`

## OD-05-ACTIVOS

| Order | Table ID | Table Name | Classification | Include | DataPerCompany | Dependencies | Reason |
|---|---:|---|---|---|---|---|---|
| `100` | `96012` | `Type Fixed Real Estate` | `Master` | `true` | `false` | `OD-04-MAESTROS` | Maestro de tipos de activos inmobiliarios utilizado por `Fixed Real Estate`. |
| `110` | `96013` | `Street Type` | `Master` | `true` | `false` | `OD-04-MAESTROS` | Maestro de direccion estructurada usado por activos y contratos. |
| `120` | `96014` | `Types Street Numbering` | `Master` | `true` | `false` | `OD-04-MAESTROS` | Maestro complementario de numeracion de calle. |
| `130` | `96056` | `Estancia` | `Master` | `true` | `false` | `OD-04-MAESTROS` | Catalogo usado por `FRE Equipment`. |
| `140` | `96166` | `FRE Attribute` | `Master` | `true` | `false` | `OD-04-MAESTROS` | Definicion de atributos inmobiliarios. |
| `150` | `96167` | `FRE Attribute Value` | `Master` | `true` | `false` | `FRE Attribute` | Valores permitidos de atributos. |
| `160` | `96169` | `FRE Attr. Value Translation` | `Master` | `true` | `false` | `FRE Attribute Value` | Traducciones de valores de atributo. |
| `170` | `96170` | `FRE Attribute Translation` | `Master` | `true` | `false` | `FRE Attribute` | Traducciones de atributos. |
| `180` | `96004` | `REF Income & Expense Template` | `Setup` | `true` | `false` | `G/L Account` | Plantilla economica utilizada por `REF Setup`. |
| `190` | `96700` | `FRE Jnl. Template` | `Setup` | `true` | `true` | `OD-02-CONTAB` | Plantillas de diario inmobiliario. |
| `200` | `96701` | `FRE Jnl. Batch` | `Setup` | `true` | `true` | `FRE Jnl. Template` | Lotes de diario inmobiliario. |
| `210` | `96003` | `REF Setup` | `Setup` | `true` | `true` | `G/L Account`, `No. Series`, `Business Relation`, `FRE Jnl. Template`, `FRE Jnl. Batch`, `REF Income Expense Template` | Configuracion principal del modulo inmobiliario. |
| `300` | `96000` | `Fixed Real Estate` | `Master` | `true` | `false` | `FA Class`, `FA Subclass`, `Dimension Value`, `Type Fixed Real Estate`, `Vendor`, `Employee`, `No. Series`, `Territory`, `Country/Region`, `Street Type`, `Types Street Numbering`, `Allocation Account` | Maestro principal de propiedades y activos inmobiliarios. |
| `400` | `96005` | `REF Income & Expense Lines` | `Master` | `true` | `false` | `Fixed Real Estate`, `G/L Account` | Configuracion economica por inmueble. |
| `410` | `96026` | `FRE Superficies` | `Master` | `true` | `false` | `Fixed Real Estate` | Detalle estructural de superficies. |
| `420` | `96054` | `FRE Equipment` | `Master` | `true` | `false` | `Fixed Real Estate`, `Estancia` | Equipamiento del inmueble. |
| `430` | `96168` | `FRE Attribute Value Mapping` | `Master` | `true` | `false` | `FRE Attribute`, `FRE Attribute Value`, `Fixed Real Estate` cuando `Table ID` corresponda | Asignacion efectiva de atributos y valores. |
| `440` | `96790` | `OD RE FA Link` | `Master` | `true` | `true` | `Fixed Real Estate`, `Fixed Asset` | Relacion funcional entre inmueble y activo fijo. |

## OD-07-CONTRATOS

| Order | Table ID | Table Name | Classification | Include | DataPerCompany | Dependencies | Reason |
|---|---:|---|---|---|---|---|---|
| `100` | `96051` | `Consumer Price Index Categorie` | `Master` | `true` | `false` | `OD-04-MAESTROS` | Maestro IPC referenciado por contrato y lineas. |
| `110` | `96050` | `Consumer Price Index` | `Master` | `true` | `false` | `Consumer Price Index Categorie` | Datos IPC para revision de rentas. |
| `300` | `96018` | `Lease Contract` | `Document` | `true` | `true` | `Customer`, `Second Customer`, `Salesperson/Purchaser`, `No. Series`, `Fixed Real Estate`, `Payment Method`, `Language`, `Reason Code`, `Payment Terms`, `Responsibility Center`, `Contact`, `Street Type`, `Types Street Numbering`, `Country/Region`, `Consumer Price Index Categorie`, `Gen. Product Posting Group`, `Customer Template`, `OneData Grupos IRPF` | Contrato operativo vigente necesario para Go-Live. |
| `400` | `96025` | `Lease Bank Account` | `Document` | `false` | `true` | `Lease Contract`, `Currency`, `Language`, `Country/Region`, `Bank Clearing Standard` | Tabla opcional con dependencia circular respecto a `Lease Contract`. |
| `500` | `96019` | `Lease Contract Line` | `Document` | `true` | `true` | `Lease Contract`, `Customer`, `Standard Text`, `G/L Account`, `Allocation Account`, `Unit of Measure`, `Dimension Value`, `Dimension Set Entry`, `Gen. Business Posting Group`, `Gen. Product Posting Group`, `VAT Business Posting Group`, `VAT Product Posting Group`, `Consumer Price Index Categorie` | Lineas economicas estructurales del contrato vigente. |
| `600` | `96946` | `OD AM Lease Contract Unit` | `Document` | `true` | `true` | `Lease Contract`, `Fixed Real Estate` | Persistencia contrato-activo para contratos multi-activo. |
| `700` | `96053` | `Rental Deposit` | `Document` | `true` | `true` | `Lease Contract` | Fianza asociada al estado economico vigente del contrato. |
| `710` | `96027` | `Tax Amount Line` | `Document` | `false` | `true` | `Lease Contract Line`, `Tax Group` | Tabla opcional hasta confirmar uso real en cliente. |
| `800` | `96020` | `Lease Comment Line` | `Document` | `false` | `true` | `Lease Contract` | Comentarios complementarios no criticos para reconstruccion base. |
| `900` | `96006` | `REF Related Contactos` | `Master` | `true` | `true` | `Contact`, `Fixed Real Estate`, `Lease Contract` | Relacion persistente entre contactos y entidades Property Management. |

## Global Tables / DataPerCompany

Las tablas con `DataPerCompany = false` son globales al entorno Business Central y no a una empresa concreta.

Impacto:

- crear una empresa nueva dentro del mismo sandbox no demuestra migracion real de estas tablas;
- los datos pueden aparecer ya compartidos entre empresas del mismo entorno;
- la validacion de OD-05 y parte de OD-07 requiere prueba entre entornos o revision equivalente de base de datos.

Tablas globales incluidas en OD-05:

- `96012 Type Fixed Real Estate`
- `96013 Street Type`
- `96014 Types Street Numbering`
- `96056 Estancia`
- `96166 FRE Attribute`
- `96167 FRE Attribute Value`
- `96168 FRE Attribute Value Mapping`
- `96169 FRE Attr. Value Translation`
- `96170 FRE Attribute Translation`
- `96004 REF Income & Expense Template`
- `96000 Fixed Real Estate`
- `96005 REF Income & Expense Lines`
- `96026 FRE Superficies`
- `96054 FRE Equipment`

Tablas globales incluidas en OD-07:

- `96050 Consumer Price Index`
- `96051 Consumer Price Index Categorie`

Tablas incluidas en estos paquetes con `DataPerCompany = true` o propiedad no redefinida:

- `96003 REF Setup`
- `96700 FRE Jnl. Template`
- `96701 FRE Jnl. Batch`
- `96790 OD RE FA Link`
- `96006 REF Related Contactos`
- `96018 Lease Contract`
- `96019 Lease Contract Line`
- `96020 Lease Comment Line`
- `96025 Lease Bank Account`
- `96027 Tax Amount Line`
- `96053 Rental Deposit`
- `96946 OD AM Lease Contract Unit`

## Dependencies

Orden funcional global:

1. `OD-01-BASE`
2. `OD-02-CONTAB`
3. `OD-03-DIM`
4. `OD-04-MAESTROS`
5. `OD-04B-DEFAULT-DIM`
6. `OD-05-ACTIVOS`
7. `OD-06-FISCAL`
8. `OD-07-CONTRATOS`
9. `OD-08-ONEDATA`

Notas clave:

- `OD-05` debe ejecutarse despues de contabilidad, dimensiones, maestros y activos fijos porque `Fixed Real Estate` depende de esas estructuras.
- `OD-07` debe ejecutarse despues de `OD-05` y `OD-06` porque los contratos dependen de activos y de `OneData Grupos IRPF`.
- `REF Related Contactos` se deja al final de `OD-07` para evitar referencias a contratos o activos no creados aun.

## Processing Order

### OD-05-ACTIVOS

`100`, `110`, `120`, `130`, `140`, `150`, `160`, `170`, `180`, `190`, `200`, `210`, `300`, `400`, `410`, `420`, `430`, `440`

### OD-07-CONTRATOS

`100`, `110`, `300`, `400`, `500`, `600`, `700`, `710`, `800`, `900`

## Fixed Real Estate Hierarchy

La jerarquia real se implementa sobre `Fixed Real Estate` mediante:

- `Property No.`
- `OD Parent FRE No.`
- `OD Asset Type`
- campo derivado `OD Hierarchy Sort Key`

Decision actual:

- se incluye la jerarquia funcional (`Property No.`, `OD Parent FRE No.`, `OD Asset Type`);
- se excluye `OD Hierarchy Sort Key` porque es derivado y se recalcula por triggers;
- no se modifica la logica funcional de validacion de jerarquia.

Riesgo documentado:

- `Processing Order` solo ordena tablas, no registros dentro de `Fixed Real Estate`;
- `OD Parent FRE No.` exige que el padre exista antes que el hijo;
- con el codigo visible en este repositorio no puede demostrarse que RapidStart garantice ese orden para cualquier numeracion.

Tratamiento:

- mantener la implementacion actual;
- validar en Business Central una estructura real `Property -> Asset padre -> Child Asset/Unit`;
- si la prueba falla, la solucion preferida sigue siendo una aplicacion en dos fases en el motor Base, no un cambio de logica funcional en Property Management.

## Lease Bank Account Circular Dependency

Dependencia circular real detectada:

- `Lease Contract."Preferred Bank Account Code"` -> `Lease Bank Account`
- `Lease Bank Account."Lease No."` -> `Lease Contract`

Decision actual:

- `Lease Bank Account` se registra en `OD-07` como tabla opcional (`Include = false`);
- se excluye `Lease Contract."Preferred Bank Account Code"` del package por defecto;
- no se desactiva `ValidateTableRelation` ni se altera la logica del contrato.

Consecuencia:

- el paquete base reconstruye el contrato sin romper la aplicacion;
- si el cliente usa cuentas bancarias por contrato, hace falta prueba funcional especifica o soporte adicional del motor para una fase 2/3.

Solucion preferida si Base la soporta en futuro:

1. crear `Lease Contract` sin `Preferred Bank Account Code`;
2. importar `Lease Bank Account`;
3. actualizar `Preferred Bank Account Code` en una fase posterior.

## Dimension Set ID

Hallazgo:

- `Lease Contract Line` contiene `Shortcut Dimension 1 Code`, `Shortcut Dimension 2 Code` y `Dimension Set ID`;
- `Dimension Set ID` no es portable de forma segura entre entornos porque los IDs pueden diferir.

Decision actual:

- se incluyen `Shortcut Dimension 1 Code` y `Shortcut Dimension 2 Code`;
- se excluye `Lease Contract Line."Dimension Set ID"` del package;
- no se copia literalmente ese identificador entre entornos.

Razon:

- la propia tabla usa `DimensionManagement` para reconstruir o validar el set desde shortcuts;
- copiar el entero sin garantizar equivalencia podria enlazar dimensiones incorrectas.

## System IDs / Guid

`Lease Contract.Id` es un campo aplicativo `Guid` propio de la tabla, distinto de `SystemId`.

Decision actual:

- no se excluye `Lease Contract.Id`;
- no se copian system fields.

Justificacion:

- no se ha encontrado logica de regeneracion obligatoria en la tabla;
- es un dato aplicativo persistente y no un metadato tecnico del sistema.

## Media / BLOB

No se incluyen como parte del alcance principal de OD-05:

- `96001 Fixed Real Estate Images`
- imagenes/documentos/adjuntos separados

Observaciones:

- `Fixed Real Estate` contiene campos `BLOB` y `Media`;
- `Lease Contract` contiene `Important Comments` como `BLOB`;
- el tratamiento exacto de esos campos depende de las reglas del motor Base y debe validarse en sandbox antes de considerar cerrado el alcance de contenido binario.

## Excluded Tables

OD-05 excluye por ahora:

- `96001 Fixed Real Estate Images`
- `96002 Real Estate Comment Line`
- `96010 Fixed Real Estate Web Site`
- `96011 FRE Publicacions Register`
- `96016 RE Maintenance Registration`
- `96017 Published Fixed Real Estate`
- `96023 Active Valuation`
- `96052 Reference Index Rental Prices`
- `96100 Incident Assets Real Estate`
- `96101 Incident Attachment`
- `96156 RE Insurance Policy`
- `96165 RE Insurance Policy Asset`
- `96171 FRE Attribute Value Selection`
- `96200 Capture Medium`
- `96720 FRE Ledger Entry`
- `96721 FRE Detailed Ledger Entry`

OD-07 excluye:

- `96021 Lease Invoice Header`
- `96022 Lease Invoice Line`
- `96040 OD Copy Lease Contract Request`
- `96041 OD Lease Contract Buffer`
- `96042 OD Lease Contract Copy Log`
- `96043 OD Lease Invoice Test Buffer`
- `96044 OD Lease Contract Validation Buffer`
- `96500 Price Increases by Refer index`
- `96600 Liquidacion Contrato Header`
- `96601 Liquidacion Contrato Lines`

Tambien permanecen fuera los buffers internos de Asset Management y Financial Flow.

## Optional Tables

Tablas registradas pero desactivadas por defecto:

- `96025 Lease Bank Account`
- `96027 Tax Amount Line`
- `96020 Lease Comment Line`

## Explicitly Excluded Fields

Subscriber `OnBeforeIsExplicitlyExcludedField(...)`:

- `Fixed Real Estate."OD Hierarchy Sort Key"`
- `Lease Contract."Preferred Bank Account Code"`
- `Lease Contract Line."Dimension Set ID"`
- `OD AM Lease Contract Unit.Active`
- `OD AM Lease Contract Unit."Annual Rent"`

## Migration Test Plan

1. Instalar Base sin Property Management y ejecutar `Create Default Setup`.
2. Confirmar que `OD-05-ACTIVOS` y `OD-07-CONTRATOS` existen sin tablas del modulo.
3. Instalar Property Management y volver a ejecutar `Create Default Setup`.
4. Confirmar que no se duplican lineas `Package Code + Table ID`.
5. Verificar que `OD-05` contiene todas las tablas listadas en esta guia.
6. Verificar que `OD-07` contiene todas las tablas listadas en esta guia.
7. Generar packages y revisar exclusiones explicitas de campo.
8. Probar OD-05 entre entornos distintos con datos globales, no solo con una nueva empresa en el mismo sandbox.
9. Probar jerarquia `Property -> Asset padre -> Child Asset/Unit`.
10. Probar OD-07 con contratos simples y multi-activo.
11. Validar que `Shortcut Dimension 1/2 Code` reconstruyen correctamente las dimensiones de `Lease Contract Line`.
12. Si el cliente usa cuentas bancarias por contrato, ejecutar prueba especifica para `Lease Bank Account` y la fase posterior de `Preferred Bank Account Code`.
13. Confirmar que no se trasladan movimientos, facturas registradas, historicos, logs ni buffers.
