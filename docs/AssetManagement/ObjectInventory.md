| Type | ID | Name | File | Purpose |
| ---- | -: | ---- | ---- | ------- |
| Enum | 96936 | OD Asset Type | `src/AssetManagement/Core/Enums/Enum 96936 - OD Asset Type.al` | Clasifica activos dentro de Asset Management |
| TableExtension | 96937 | OD AM Fixed Real Estate Ext | `src/AssetManagement/Core/TableExtensions/TableExtension 96937 - OD AM Fixed Real Estate Ext.al` | Anade tipo y padre jerarquico a `Fixed Real Estate` |
| Codeunit | 96938 | OD AM Asset Structure Mgt. | `src/AssetManagement/Core/Codeunits/Codeunit 96938 - OD AM Asset Structure Mgt.al` | Centraliza validaciones y construccion de jerarquia |
| Table | 96939 | OD AM Asset Structure Buffer | `src/AssetManagement/Structure/Tables/Table 96939 - OD AM Asset Structure Buffer.al` | Buffer temporal para la vista jerarquica |
| Page | 96940 | OD AM Asset Structure | `src/AssetManagement/Structure/Pages/Page 96940 - OD AM Asset Structure.al` | Vista principal de la estructura de activos |
| Page | 96941 | OD AM Asset List | `src/AssetManagement/Structure/Pages/Page 96941 - OD AM Asset List.al` | Lista moderna editable de activos |
| Page | 96942 | OD AM Property Asset FactBox | `src/AssetManagement/Structure/Pages/Page 96942 - OD AM Property Asset FactBox.al` | Resumen opcional de activos por propiedad |
| Table | 96943 | OD AM Asset Create Req. | `src/AssetManagement/Structure/Tables/Table 96943 - OD AM Asset Create Req.al` | Soporte temporal para seleccionar tipo de activo al crear |
| Page | 96944 | OD AM New Asset | `src/AssetManagement/Structure/Pages/Page 96944 - OD AM New Asset.al` | Dialogo para seleccionar el tipo de activo nuevo |
| PermissionSetExtension | 96960 | OD AM Admin Ext | `src/AssetManagement/Setup/PermissionSetExtensions/PermissionSetExtension 96960 - OD AM Admin Ext.al` | Expone Asset Management a `ODPM ADMIN` |
| PermissionSetExtension | 96961 | OD AM Read Ext | `src/AssetManagement/Setup/PermissionSetExtensions/PermissionSetExtension 96961 - OD AM Read Ext.al` | Expone Asset Management a `ODPM READ` |
| PermissionSetExtension | 96962 | OD AM Setup Ext | `src/AssetManagement/Setup/PermissionSetExtensions/PermissionSetExtension 96962 - OD AM Setup Ext.al` | Expone Asset Management a `ODPM SETUP` |
| PermissionSetExtension | 96963 | OD AM User Ext | `src/AssetManagement/Setup/PermissionSetExtensions/PermissionSetExtension 96963 - OD AM User Ext.al` | Expone Asset Management a `ODPM USER` |
| Enum | 96945 | OD Contract Unit Role | `src/AssetManagement/Contracts/Enums/Enum 96945 - OD Contract Unit Role.al` | Distingue activo principal, adicional y accesorio dentro del contrato |
| Table | 96946 | OD AM Lease Contract Unit | `src/AssetManagement/Contracts/Tables/Table 96946 - OD AM Lease Contract Unit.al` | Relaciona contratos de alquiler con multiples activos |
| Codeunit | 96947 | OD AM Contract Asset Mgt. | `src/AssetManagement/Contracts/Codeunits/Codeunit 96947 - OD AM Contract Asset Mgt.al` | Centraliza sincronizacion, validacion y consulta de activos contractuales |
| Page | 96948 | OD AM Lease Contract Units | `src/AssetManagement/Contracts/Pages/Page 96948 - OD AM Lease Contract Units.al` | Subpagina list part con activos vinculados al contrato |
| Page | 96949 | OD AM Contract Asset FactBox | `src/AssetManagement/Contracts/Pages/Page 96949 - OD AM Contract Asset FactBox.al` | Resume conteo, principal y tipos de activos del contrato |
| Page | 96964 | OD AM Lease Contract Card | `src/AssetManagement/Contracts/Pages/Page 96964 - OD AM Lease Contract Card.al` | Vista Asset Management del contrato con parte multi-activo |
| Page | 96965 | OD AM Lease Contract List | `src/AssetManagement/Contracts/Pages/Page 96965 - OD AM Lease Contract List.al` | Lista alternativa de contratos orientada a Asset Management |
| TableExtension | 96966 | OD AM Lease Contract Ext | `src/AssetManagement/Contracts/TableExtensions/TableExtension 96966 - OD AM Lease Contract Ext.al` | Sincroniza el activo principal legacy con la tabla multi-activo |
| Codeunit | 96967 | OD AM Contract Unit Upgrade | `src/AssetManagement/Contracts/Codeunits/Codeunit 96967 - OD AM Contract Unit Upgrade.al` | Inicializa lineas principales para contratos legacy |
| PageExtension | 96968 | OD AM Asset Struct Contracts | `src/AssetManagement/Structure/PageExtensions/PageExtension 96968 - OD AM Asset Structure Contracts.al` | Anade acceso a contratos relacionados desde la estructura de activos |
| Enum | 96969 | OD AM Occupancy Status | `src/AssetManagement/Occupancy/Enums/Enum 96969 - OD AM Occupancy Status.al` | Define estados de disponibilidad y ocupacion |
| Table | 96975 | OD AM Occupancy Buffer | `src/AssetManagement/Occupancy/Tables/Table 96975 - OD AM Occupancy Buffer.al` | Buffer temporal para vistas de ocupacion y disponibilidad |
| Codeunit | 96976 | OD AM Occupancy Mgt. | `src/AssetManagement/Occupancy/Codeunits/Codeunit 96976 - OD AM Occupancy Mgt.al` | Centraliza conflictos, estados y validacion de disponibilidad |
| Page | 96977 | OD AM Occupancy View | `src/AssetManagement/Occupancy/Pages/Page 96977 - OD AM Occupancy View.al` | Muestra ocupacion jerarquica por propiedad y fecha |
| Page | 96978 | OD AM Asset Availability | `src/AssetManagement/Occupancy/Pages/Page 96978 - OD AM Asset Availability.al` | Busca activos disponibles por propiedad, tipo y periodo |
