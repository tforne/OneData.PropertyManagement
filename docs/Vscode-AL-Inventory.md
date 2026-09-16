# Inventario de AL en .vscode

Este inventario se generó durante la Fase 1.1. `alc.exe /project:.` incluye estos archivos porque compila recursivamente el directorio del proyecto.

No se movió ningún archivo en esta fase. Los dos objetos con `Subtype = Test` o `TestRunner` se recomiendan para una futura aplicación de pruebas separada. El resto se clasifica como producto activo porque se declara como objeto AL funcional y participa en la compilación actual; su migración a `src/` requiere una fase de reorganización dedicada.

| Archivo | Objeto | Finalidad aparente | Debe compilar con producto | Recomendación |
| --- | --- | --- | --- | --- |
| `.vscode/Codeunits/Codeunit 50501 - Install.al` | codeunit 50501 GeneralManagementInstall | Producto activo | Sí | Conservar; migrar a `src/` en una fase dedicada |
| `.vscode/Codeunits/Codeunit 50502 - Upgrade.al` | Unknown declaration | Producto activo | Sí | Conservar; migrar a `src/` en una fase dedicada |
| `.vscode/Codeunits/Codeunit 96000 - Real Estate Management.al` | codeunit 96000 "Real Estate Management" | Producto activo | Sí | Conservar; migrar a `src/` en una fase dedicada |
| `.vscode/Codeunits/Codeunit 96001 - Customer RE-Notify by Email.al` | codeunit 96001 "Customer RE-Notify by Email" | Producto activo | Sí | Conservar; migrar a `src/` en una fase dedicada |
| `.vscode/Codeunits/Codeunit 96002 - Correct Lease Invoice (YesNo).al` | codeunit 96002 "Correct Lease Invoice (Yes/No)" | Producto activo | Sí | Conservar; migrar a `src/` en una fase dedicada |
| `.vscode/Codeunits/Codeunit 96003 - Correct Lease Invoice.al` | codeunit 96003 "Correct Lease Invoice" | Producto activo | Sí | Conservar; migrar a `src/` en una fase dedicada |
| `.vscode/Codeunits/Codeunit 96004 - Cancel Lease Invoice (YesNo).al` | codeunit 96004 "Cancel Lease Invoice (Yes/No)" | Producto activo | Sí | Conservar; migrar a `src/` en una fase dedicada |
| `.vscode/Codeunits/Codeunit 96005 - Publish Web Site Management.al` | codeunit 96005 "Publish Web Site Management" | Producto activo | Sí | Conservar; migrar a `src/` en una fase dedicada |
| `.vscode/Codeunits/Codeunit 96006 - Import Attachment - Incident.al` | codeunit 96006 "Management - Incident" | Producto activo | Sí | Conservar; migrar a `src/` en una fase dedicada |
| `.vscode/Codeunits/Codeunit 96007 - Journals Management.al` | codeunit 96007 "FRE Journals Management" | Producto activo | Sí | Conservar; migrar a `src/` en una fase dedicada |
| `.vscode/Codeunits/Codeunit 96008 - FRE Jnl.-Post Line.al` | codeunit 96008 "FRE Jnl.-Post Line" | Producto activo | Sí | Conservar; migrar a `src/` en una fase dedicada |
| `.vscode/Codeunits/Codeunit 96011 - FRE Jnl.-Check Line.al` | codeunit 96011 "FRE Jnl.-Check Line" | Producto activo | Sí | Conservar; migrar a `src/` en una fase dedicada |
| `.vscode/Codeunits/Codeunit 96012 - FRE Import Jnl Lines.al` | codeunit 96012 "FRE Import Jnl. Lines" | Producto activo | Sí | Conservar; migrar a `src/` en una fase dedicada |
| `.vscode/Codeunits/Codeunit 96013 - FRE Jnl.-Post Batch.al` | codeunit 96013 "FRE Jnl.-Post Batch" | Producto activo | Sí | Conservar; migrar a `src/` en una fase dedicada |
| `.vscode/Codeunits/Codeunit 96040 - OD Lease Contract Lookup Mgt.al` | codeunit 96040 "OD Lease Contract Lookup Mgt." | Producto activo | Sí | Conservar; migrar a `src/` en una fase dedicada |
| `.vscode/Codeunits/Codeunit 96041 - OD Lease Contract Copy Helper.al` | codeunit 96041 "OD Lease Contract Copy Helper" | Producto activo | Sí | Conservar; migrar a `src/` en una fase dedicada |
| `.vscode/Codeunits/Codeunit 96042 - OD Copy Lease Contract Mgt.al` | codeunit 96042 "OD Copy Lease Contract Mgt." | Producto activo | Sí | Conservar; migrar a `src/` en una fase dedicada |
| `.vscode/Codeunits/Codeunit 96043 - OD Lease Contract Copy Subscribers.al` | codeunit 96043 "OD Lease Contract Copy Subsc." | Producto activo | Sí | Conservar; migrar a `src/` en una fase dedicada |
| `.vscode/Codeunits/Codeunit 96044 - OD Lease Contract Lookup.al` | codeunit 96044 "OD Lease Contract Lookup" | Producto activo | Sí | Conservar; migrar a `src/` en una fase dedicada |
| `.vscode/Codeunits/Codeunit 96090 - Create Lease Invoice Report Tests.al` | codeunit 96090 "Create Lease Invoice Rep Tests" | Test (Test) | No en la app principal | `tests/` en una app de pruebas separada |
| `.vscode/Codeunits/Codeunit 96091 - Create Lease Invoice Test Runner.al` | codeunit 96091 "Create Lease Inv Test Runner" | Test (TestRunner) | No en la app principal | `tests/` en una app de pruebas separada |
| `.vscode/Codeunits/Codeunit 96092 - Lease Invoice Report Summary.al` | codeunit 96092 "Lease Invoice Report Summary" | Producto activo | Sí | Conservar; migrar a `src/` en una fase dedicada |
| `.vscode/Codeunits/Codeunit 96101 - RE Incident Management.al` | codeunit 96101 "RE Incident Management" | Producto activo | Sí | Conservar; migrar a `src/` en una fase dedicada |
| `.vscode/Codeunits/Codeunit 96102 - RE Insurance Notify Mgt.al` | codeunit 96102 "RE Insurance Notify Mgt" | Producto activo | Sí | Conservar; migrar a `src/` en una fase dedicada |
| `.vscode/Codeunits/Codeunit 96103 - AI Incident Intake Mgt.al` | codeunit 96103 "AI Incident Intake Mgt." | Producto activo | Sí | Conservar; migrar a `src/` en una fase dedicada |
| `.vscode/Codeunits/Codeunit 96104 - ODPM Incident Agent Setup Mgt.al` | codeunit 96104 "ODPM Incident Agent Setup Mgt." | Producto activo | Sí | Conservar; migrar a `src/` en una fase dedicada |
| `.vscode/Codeunits/Codeunit 96200 - GoLandingPage.al` | codeunit 96200 "GoLandingPage" | Producto activo | Sí | Conservar; migrar a `src/` en una fase dedicada |
| `.vscode/Codeunits/Codeunit 96201 - GoDocumentation.al` | codeunit 96201 "GoDocumentation" | Producto activo | Sí | Conservar; migrar a `src/` en una fase dedicada |
| `.vscode/Codeunits/Codeunit 96600 - Contrato Liquidacion Mgt.al` | codeunit 96600 "Contrato Liquidacion Mgt." | Producto activo | Sí | Conservar; migrar a `src/` en una fase dedicada |
| `.vscode/Codeunits/Codeunit 96728 - FRE Import Suggestion Mgt..al` | codeunit 96728 "FRE Import Suggestion Mgt." | Producto activo | Sí | Conservar; migrar a `src/` en una fase dedicada |
| `.vscode/Codeunits/Codeunit 96731 - FRE Asset Suggestion Mgt.al` | codeunit 96731 "FRE Asset Suggestion Mgt." | Producto activo | Sí | Conservar; migrar a `src/` en una fase dedicada |
| `.vscode/Codeunits/Codeunit 96790 - OD RE FA Link Mgt..al` | codeunit 96790 "OD RE FA Link Mgt." | Producto activo | Sí | Conservar; migrar a `src/` en una fase dedicada |
| `.vscode/Codeunits/Codeunit 96798 - OD RE FA Link.al` | codeunit 96798 "FRE Journal Integration Mgt." | Producto activo | Sí | Conservar; migrar a `src/` en una fase dedicada |
| `.vscode/Codeunits/Codeunit 96801 - Gen Journal Import Mgt.al` | codeunit 96801 "Gen Journal Import Mgt." | Producto activo | Sí | Conservar; migrar a `src/` en una fase dedicada |
| `.vscode/Codeunits/Codeunit 96802 - Preview Load Mgt.al` | codeunit 96802 "Preview Load Mgt." | Producto activo | Sí | Conservar; migrar a `src/` en una fase dedicada |
| `.vscode/Codeunits/Codeunit 96803 - Gen Journal FRE Subscribers.al` | codeunit 96803 "Gen Journal FRE Subscribers" | Producto activo | Sí | Conservar; migrar a `src/` en una fase dedicada |
| `.vscode/Codeunits/Codeunit 96820 - Catastro Service Mgt.al` | codeunit 96820 "Catastro Service Mgt." | Producto activo | Sí | Conservar; migrar a `src/` en una fase dedicada |
| `.vscode/Codeunits/Codeunit 96821 - SERPAVI Service Mgt.al` | codeunit 96821 "SERPAVI Service Mgt." | Producto activo | Sí | Conservar; migrar a `src/` en una fase dedicada |
| `.vscode/Codeunits/Codeunit 96824 - INE Rental Index Mgt.al` | codeunit 96824 "INE Rental Index Mgt." | Producto activo | Sí | Conservar; migrar a `src/` en una fase dedicada |
| `.vscode/Codeunits/Codeunit 96825 - FRE Tenant Notice Mgt.al` | codeunit 96825 "FRE Tenant Notice Mgt." | Producto activo | Sí | Conservar; migrar a `src/` en una fase dedicada |
| `.vscode/Codeunits/Codeunit 96826 - FRE Tenant Notice Source Mgt.al` | codeunit 96826 "FRE Tenant Notice Source Mgt." | Producto activo | Sí | Conservar; migrar a `src/` en una fase dedicada |
| `.vscode/Codeunits/Codeunit 96986 - OD Lease Ctr. Val. Mgt.al` | codeunit 96986 "OD Lease Ctr. Val. Mgt." | Producto activo | Sí | Conservar; migrar a `src/` en una fase dedicada |
| `.vscode/ControlAddIns/ControlAddIn 96822 - OD Clipboard Helper.al` | controladdin "OD Clipboard Helper" | Producto activo | Sí | Conservar; migrar a `src/` en una fase dedicada |
| `.vscode/Enums/EnumExtension 96150 - ODPM Assisted Setup Group.al` | enumextension 96150 "ODPM Assisted Setup Group" extends "Assisted Setup Group" | Producto activo | Sí | Conservar; migrar a `src/` en una fase dedicada |
| `.vscode/Enums/EnumExtension 96151 - ODPM Manual Setup Category.al` | enumextension 96151 "ODPM Manual Setup Category" extends "Manual Setup Category" | Producto activo | Sí | Conservar; migrar a `src/` en una fase dedicada |
| `.vscode/Enums/Enums Extensions/Enums Extensions - Report Selection Usage.al` | enumextension 96000 ReportSelectionUsageExt | Producto activo | Sí | Conservar; migrar a `src/` en una fase dedicada |
| `.vscode/Enums/Enums/Enum 96600 - MotivoLiquidacion.al` | enum 96600 "Motivo Liquidacion Contrato" | Producto activo | Sí | Conservar; migrar a `src/` en una fase dedicada |
| `.vscode/Enums/Enums/Enum 96601 - DocumentsPropertyManagement.al` | enum 96601 "Enum_DocsPropertyManagement" | Producto activo | Sí | Conservar; migrar a `src/` en una fase dedicada |
| `.vscode/Enums/Enums/Enum 96602 - FRE Line Type.al` | enum 96602 "FRE Line Type" | Producto activo | Sí | Conservar; migrar a `src/` en una fase dedicada |
| `.vscode/Enums/Enums/Enum 96603 - Status Lease Invoice.al` | enum 96603 "Status Lease Invoice" | Producto activo | Sí | Conservar; migrar a `src/` en una fase dedicada |
| `.vscode/Enums/Enums/Enum 96604 - FRE Journal Source Type.al` | enum 96604 "FRE Journal Source Type" | Producto activo | Sí | Conservar; migrar a `src/` en una fase dedicada |
| `.vscode/Enums/Enums/Enum 96605 - FRE Entry Category .al` | enum 96605 "FRE Entry Category" | Producto activo | Sí | Conservar; migrar a `src/` en una fase dedicada |
| `.vscode/Enums/Enums/Enum 96606 - OD RE FA Link Type.al` | enum 96606 "OD RE FA Link Type" | Producto activo | Sí | Conservar; migrar a `src/` en una fase dedicada |
| `.vscode/Enums/Enums/Enum 96607 - OD Tenant Notice Priority.al` | enum 96101 "OD Tenant Notice Priority" | Producto activo | Sí | Conservar; migrar a `src/` en una fase dedicada |
| `.vscode/Enums/Enums/Enum 96608 - OD Tenant Notice Status.al` | enum 96608 "OD Tenant Notice Status" | Producto activo | Sí | Conservar; migrar a `src/` en una fase dedicada |
| `.vscode/Enums/Enums/Enum 96609 - OD Tenant Notice Type.al` | enum 96609 "OD Tenant Notice Type" | Producto activo | Sí | Conservar; migrar a `src/` en una fase dedicada |
| `.vscode/Enums/Enums/Enum 96620 - Lease Contract Line Type.al` | enum 96620 "Lease Contract Line Type" | Producto activo | Sí | Conservar; migrar a `src/` en una fase dedicada |
| `.vscode/Enums/Enums/Enum 96630 - Distribution Owner Type.al` | enum 96630 "Distribution Owner Type" | Producto activo | Sí | Conservar; migrar a `src/` en una fase dedicada |
| `.vscode/Pages/Page 96000 - Fixed Real Estate Card.al` | page 96000 "Fixed Real Estate Card" | Producto activo | Sí | Conservar; migrar a `src/` en una fase dedicada |
| `.vscode/Pages/Page 96001 - Fixed Real Estate List.al` | page 96001 "Fixed Real Estate List" | Producto activo | Sí | Conservar; migrar a `src/` en una fase dedicada |
| `.vscode/Pages/Page 96002 - Fixed RE Attribute Value Edit.al` | page 96002 "Fixed RE Attribute Value Edit." | Producto activo | Sí | Conservar; migrar a `src/` en una fase dedicada |
| `.vscode/Pages/Page 96003 - Fixed RE Attrib Factbox.al` | page 96003 "Fixed RE Attrib. Factbox" | Producto activo | Sí | Conservar; migrar a `src/` en una fase dedicada |
| `.vscode/Pages/Page 96004 - Fixed RE Statistic.al` | page 96004 "Fixed RE Statistics" | Producto activo | Sí | Conservar; migrar a `src/` en una fase dedicada |
| `.vscode/Pages/Page 96007 - Real Estate Fixed Setup.al` | page 96007 "Real Estate Fixed Setup" | Producto activo | Sí | Conservar; migrar a `src/` en una fase dedicada |
| `.vscode/Pages/Page 96008 - Real Estate Comment Sheet.al` | page 96008 "Real Estate Comment Sheet" | Producto activo | Sí | Conservar; migrar a `src/` en una fase dedicada |
| `.vscode/Pages/Page 96009 - REF Income and Expenses Template.al` | page 96009 "REF Income & Expenses Template" | Producto activo | Sí | Conservar; migrar a `src/` en una fase dedicada |
| `.vscode/Pages/Page 96010 - REF Income and Expenses Subform.al` | page 96010 "REF Income & Expenses Subform" | Producto activo | Sí | Conservar; migrar a `src/` en una fase dedicada |
| `.vscode/Pages/Page 96011 - REF Income and Expenses List.al` | page 96011 "REF Income & Expenses List" | Producto activo | Sí | Conservar; migrar a `src/` en una fase dedicada |
| `.vscode/Pages/Page 96012 - REF Related Contactos List.al` | page 96012 "REF Related Contactos List" | Producto activo | Sí | Conservar; migrar a `src/` en una fase dedicada |
| `.vscode/Pages/Page 96013 - REF Related Contactos.al` | page 96013 "REF Related Contactos" | Producto activo | Sí | Conservar; migrar a `src/` en una fase dedicada |
| `.vscode/Pages/Page 96014 - Small Real Estate Act.al` | page 96014 "Small Real Estate Act." | Producto activo | Sí | Conservar; migrar a `src/` en una fase dedicada |
| `.vscode/Pages/Page 96015 - Real Estate Role Center.al` | page 96015 "Real Estate Role Center" | Producto activo | Sí | Conservar; migrar a `src/` en una fase dedicada |
| `.vscode/Pages/Page 96016 - RE Maintenance Registration.al` | page 96016 "RE Maintenance Registration" | Producto activo | Sí | Conservar; migrar a `src/` en una fase dedicada |
| `.vscode/Pages/Page 96017 - Description Documents  Class.al` | page 96017 "Description Documents Class" | Producto activo | Sí | Conservar; migrar a `src/` en una fase dedicada |
| `.vscode/Pages/Page 96019 - RE Cash Flow Chart.al` | page 96019 "RE Analisis Ingresos y Gastos" | Producto activo | Sí | Conservar; migrar a `src/` en una fase dedicada |
| `.vscode/Pages/Page 96020 - Descrip. Docs. Classified List.al` | page 96020 "Descrip. Docs. Classified List" | Producto activo | Sí | Conservar; migrar a `src/` en una fase dedicada |
| `.vscode/Pages/Page 96021 - FRE Attribute Value List.al` | page 96021 "FRE Attribute Value List" | Producto activo | Sí | Conservar; migrar a `src/` en una fase dedicada |
| `.vscode/Pages/Page 96022 - Fixed Real Es Web Site List.al` | page 96022 "Fixed Real Es. Web Site List" | Producto activo | Sí | Conservar; migrar a `src/` en una fase dedicada |
| `.vscode/Pages/Page 96023 - Fixed Real Es Web Site Card.al` | page 96023 "Fixed Real Es. Web Site Card" | Producto activo | Sí | Conservar; migrar a `src/` en una fase dedicada |
| `.vscode/Pages/Page 96024 - Type Fixed Real Estate List.al` | page 96024 "Type Fixed Real Estate List" | Producto activo | Sí | Conservar; migrar a `src/` en una fase dedicada |
| `.vscode/Pages/Page 96025 - Street Type List.al` | page 96025 "Street Type List" | Producto activo | Sí | Conservar; migrar a `src/` en una fase dedicada |
| `.vscode/Pages/Page 96026 - Types Street Numbering List.al` | page 96026 "Types Street Numbering List" | Producto activo | Sí | Conservar; migrar a `src/` en una fase dedicada |
| `.vscode/Pages/Page 96027 - Compose address.al` | page 96027 "Compose address" | Producto activo | Sí | Conservar; migrar a `src/` en una fase dedicada |
| `.vscode/Pages/Page 96028 - Rel XML Elem to Attrib Item.al` | page 96028 "Rel. XML Elem. to Attrib. Item" | Producto activo | Sí | Conservar; migrar a `src/` en una fase dedicada |
| `.vscode/Pages/Page 96029 - Published Fixed Real Estate.al` | page 96029 "Published Fixed Real Estate" | Producto activo | Sí | Conservar; migrar a `src/` en una fase dedicada |
| `.vscode/Pages/Page 96030 - Lease Contract List.al` | page 96030 "Lease Contract List" | Producto activo | Sí | Conservar; migrar a `src/` en una fase dedicada |
| `.vscode/Pages/Page 96031 - Lease Contrac Card.al` | page 96031 "Lease Contract Card" | Producto activo | Sí | Conservar; migrar a `src/` en una fase dedicada |
| `.vscode/Pages/Page 96032 - Lease Contract Subform.al` | page 96032 "Lease Contract Subform" | Producto activo | Sí | Conservar; migrar a `src/` en una fase dedicada |
| `.vscode/Pages/page 96033 - Lease Comment Sheet.al` | page 96033 "Lease Comment Sheet" | Producto activo | Sí | Conservar; migrar a `src/` en una fase dedicada |
| `.vscode/Pages/Page 96034 - Posted Lease Invoices.al` | page 96034 "Posted Lease Invoices" | Producto activo | Sí | Conservar; migrar a `src/` en una fase dedicada |
| `.vscode/Pages/Page 96035 - Posted Lease Invoice.al` | page 96035 "Posted Lease Invoice" | Producto activo | Sí | Conservar; migrar a `src/` en una fase dedicada |
| `.vscode/Pages/Page 96036 - Posted Lease Invoice Subform.al` | page 96036 "Posted Lease Invoice Subform" | Producto activo | Sí | Conservar; migrar a `src/` en una fase dedicada |
| `.vscode/Pages/Page 96037 - Compose address Opp.al` | page 96037 "Compose address Opp" | Producto activo | Sí | Conservar; migrar a `src/` en una fase dedicada |
| `.vscode/Pages/Page 96038 - Active Valuation.al` | page 96038 "Active Valuation" | Producto activo | Sí | Conservar; migrar a `src/` en una fase dedicada |
| `.vscode/Pages/Page 96039 - Compose address Contract Lease.al` | page 96039 "Compose address Contract Lease" | Producto activo | Sí | Conservar; migrar a `src/` en una fase dedicada |
| `.vscode/Pages/Page 96040 - Fixed Real Estate Avatar.al` | page 96040 "Fixed Real Estate Avatar" | Producto activo | Sí | Conservar; migrar a `src/` en una fase dedicada |
| `.vscode/Pages/Page 96041 - FRE Superficies.al` | page 96041 "FRE Superficies" | Producto activo | Sí | Conservar; migrar a `src/` en una fase dedicada |
| `.vscode/Pages/Page 96042 - Lease Bank Account List.al` | page 96042 "Lease Bank Account List" | Producto activo | Sí | Conservar; migrar a `src/` en una fase dedicada |
| `.vscode/Pages/Page 96043 - Lease Bank Account Card.al` | page 96043 "Lease Bank Account Card" | Producto activo | Sí | Conservar; migrar a `src/` en una fase dedicada |
| `.vscode/Pages/Page 96044 - Headline FFO Manager.al` | page 96044 "Headline FFO Manager" | Producto activo | Sí | Conservar; migrar a `src/` en una fase dedicada |
| `.vscode/Pages/Page 96045 - List Tax Amount Line.al` | page 96045 "List Tax Amount Line" | Producto activo | Sí | Conservar; migrar a `src/` en una fase dedicada |
| `.vscode/Pages/Page 96050 - Consumer Price Index.al` | page 96050 "Consumer Price Index" | Producto activo | Sí | Conservar; migrar a `src/` en una fase dedicada |
| `.vscode/Pages/Page 96051 - Consumer Price Index Categorie.al` | page 96051 "Consumer Price Index Categorie" | Producto activo | Sí | Conservar; migrar a `src/` en una fase dedicada |
| `.vscode/Pages/Page 96052 - Reference Index Rental Prices.al` | page 96052 "Reference Index Rental Prices" | Producto activo | Sí | Conservar; migrar a `src/` en una fase dedicada |
| `.vscode/Pages/Page 96053 - Summary Lease Contract.al` | page 96053 "Sumary Lease Contract" | Producto activo | Sí | Conservar; migrar a `src/` en una fase dedicada |
| `.vscode/Pages/Page 96054 - Rentals Deposit.al` | page 96054 "Rentals Deposit" | Producto activo | Sí | Conservar; migrar a `src/` en una fase dedicada |
| `.vscode/Pages/Page 96055 - FRE Equipments.al` | page 96055 "FRE Equipments" | Producto activo | Sí | Conservar; migrar a `src/` en una fase dedicada |
| `.vscode/Pages/Page 96056 - Incidents Real Estate Act.al` | page 96056 "Incidents Real Estate Act." | Producto activo | Sí | Conservar; migrar a `src/` en una fase dedicada |
| `.vscode/Pages/Page 96057 - Posted Lease Invoices Lines.al` | page 96057 "Posted Lease Invoices Lines" | Producto activo | Sí | Conservar; migrar a `src/` en una fase dedicada |
| `.vscode/Pages/Page 96058 - Incident Comment Subform.al` | page 96058 "Incident Comment Subform" | Producto activo | Sí | Conservar; migrar a `src/` en una fase dedicada |
| `.vscode/Pages/Page 96059 - Estancias.al` | page 96059 "Estancias" | Producto activo | Sí | Conservar; migrar a `src/` en una fase dedicada |
| `.vscode/Pages/Page 96060 - Real Estate Incident RC.al` | page 96060 "Real Estate Incident RC" | Producto activo | Sí | Conservar; migrar a `src/` en una fase dedicada |
| `.vscode/Pages/Page 96061 - Simple Fixed Real Estate List.al` | page 96061 "Simple Fixed Real Estate List" | Producto activo | Sí | Conservar; migrar a `src/` en una fase dedicada |
| `.vscode/Pages/Page 96070 - OD Lease Contract Lookup.al` | page 96070 "OD Lease Contract Lookup" | Producto activo | Sí | Conservar; migrar a `src/` en una fase dedicada |
| `.vscode/Pages/Page 96071 - OD Copy Lease Contract Request.al` | page 96071 "OD Copy Lease Contract Req." | Producto activo | Sí | Conservar; migrar a `src/` en una fase dedicada |
| `.vscode/Pages/Page 96072 - OD Lease Contract Copy Log.al` | page 96072 "OD Lease Contract Copy Log" | Producto activo | Sí | Conservar; migrar a `src/` en una fase dedicada |
| `.vscode/Pages/Page 96073 - OD Lease Invoice Test Results.al` | page 96073 "OD Lease Invoice Test Results" | Producto activo | Sí | Conservar; migrar a `src/` en una fase dedicada |
| `.vscode/Pages/Page 96074 - OD Lease Contract Validation Results.al` | page 96074 "OD Lease Ctr. Val. Results" | Producto activo | Sí | Conservar; migrar a `src/` en una fase dedicada |
| `.vscode/Pages/Page 96150 - RE Incident Mobile.al` | page 96150 "RE Incident Mobile" | Producto activo | Sí | Conservar; migrar a `src/` en una fase dedicada |
| `.vscode/Pages/Page 96151 - RE Incident Card.al` | page 96151 "RE Incident Card" | Producto activo | Sí | Conservar; migrar a `src/` en una fase dedicada |
| `.vscode/Pages/Page 96152 - RE Incidents List.al` | page 96152 "Incidents List" | Producto activo | Sí | Conservar; migrar a `src/` en una fase dedicada |
| `.vscode/Pages/Page 96153 - Incident Attanch FactBox.al` | page 96153 "Incident Attach. FactBox" | Producto activo | Sí | Conservar; migrar a `src/` en una fase dedicada |
| `.vscode/Pages/Page 96154 - O365 Incident Att. Pict..al` | page 96154 "O365 Incident Att. Pict." | Producto activo | Sí | Conservar; migrar a `src/` en una fase dedicada |
| `.vscode/Pages/Page 96155 - Incident Attach List.al` | page 96155 "Incident Attach List" | Producto activo | Sí | Conservar; migrar a `src/` en una fase dedicada |
| `.vscode/Pages/Page 96156 - RE Insurance Policies.al` | page 96156 "RE Insurance Policies" | Producto activo | Sí | Conservar; migrar a `src/` en una fase dedicada |
| `.vscode/Pages/Page 96157 - RE Insurance Policy ListPart.al` | page 96157 "RE Insurance Policy ListPart" | Producto activo | Sí | Conservar; migrar a `src/` en una fase dedicada |
| `.vscode/Pages/Page 96158 - AI Incident Intake Buffers.al` | page 96158 "AI Incident Intake Buffers" | Producto activo | Sí | Conservar; migrar a `src/` en una fase dedicada |
| `.vscode/Pages/Page 96159 - ODPM Incident Agent Setup.al` | page 96159 "ODPM Incident Agent Setup" | Producto activo | Sí | Conservar; migrar a `src/` en una fase dedicada |
| `.vscode/Pages/Page 96160 - ODPM Incident Agent Setup Wizard.al` | page 96160 "ODPM Incid. Agent Setup Wizard" | Producto activo | Sí | Conservar; migrar a `src/` en una fase dedicada |
| `.vscode/Pages/Page 96164 - RE Insurance Activities.al` | page 96164 "RE Insurance Activities" | Producto activo | Sí | Conservar; migrar a `src/` en una fase dedicada |
| `.vscode/Pages/Page 96166 - RE Insurance Policy Assets.al` | page 96166 "RE Insurance Policy Assets" | Producto activo | Sí | Conservar; migrar a `src/` en una fase dedicada |
| `.vscode/Pages/Page 96167 - RE Insurance Asset ListPart.al` | page 96167 "RE Insurance Asset ListPart" | Producto activo | Sí | Conservar; migrar a `src/` en una fase dedicada |
| `.vscode/Pages/Page 96180 - FRE Attributes.al` | page 96180 "FRE Attributes" | Producto activo | Sí | Conservar; migrar a `src/` en una fase dedicada |
| `.vscode/Pages/Page 96181 - FRE Attribute Values.al` | page 96181 "FRE Attribute Values" | Producto activo | Sí | Conservar; migrar a `src/` en una fase dedicada |
| `.vscode/Pages/Page 96182 - FRE Attribute.al` | page 96182 "FRE Attribute" | Producto activo | Sí | Conservar; migrar a `src/` en una fase dedicada |
| `.vscode/Pages/Page 96183 - FRE Attribute Translations.al` | page 96183 "FRE Attribute Translations" | Producto activo | Sí | Conservar; migrar a `src/` en una fase dedicada |
| `.vscode/Pages/Page 96200 - Capture Medium.al` | page 96200 "Capture Medium" | Producto activo | Sí | Conservar; migrar a `src/` en una fase dedicada |
| `.vscode/Pages/Page 96500 - Price Increases by Refer index.al` | page 96500 "Price Increases by Refer index" | Producto activo | Sí | Conservar; migrar a `src/` en una fase dedicada |
| `.vscode/Pages/Page 96600 - Liquidacion Contrato Card.al` | page 96600 "Liquidacion Contrato Card" | Producto activo | Sí | Conservar; migrar a `src/` en una fase dedicada |
| `.vscode/Pages/Page 96601 - Liquidacion Contrato FactBox.al` | page 96601 "Liquidacion Contrato FactBox" | Producto activo | Sí | Conservar; migrar a `src/` en una fase dedicada |
| `.vscode/Pages/Page 96602 - Liquidacion Contrato Subform.al` | page 96602 "Liquidacion Contrato Subform" | Producto activo | Sí | Conservar; migrar a `src/` en una fase dedicada |
| `.vscode/Pages/Page 96700 - FRE Jnl Template List.al` | page 96700 "FRE Jnl. Template List" | Producto activo | Sí | Conservar; migrar a `src/` en una fase dedicada |
| `.vscode/Pages/Page 96701 - FRE Journal Templates.al` | page 96701 "FRE Journal Templates" | Producto activo | Sí | Conservar; migrar a `src/` en una fase dedicada |
| `.vscode/Pages/Page 96702 - FRE Jnl Batches.al` | page 96702 "FRE Jnl. Batches" | Producto activo | Sí | Conservar; migrar a `src/` en una fase dedicada |
| `.vscode/Pages/Page 96703 - FRE Journal Line.al` | page 96703 "FRE Journal Line" | Producto activo | Sí | Conservar; migrar a `src/` en una fase dedicada |
| `.vscode/Pages/Page 96704 - Create Payment Lease Invoice.al` | page 96704 "Create Payment Lease Invoice" | Producto activo | Sí | Conservar; migrar a `src/` en una fase dedicada |
| `.vscode/Pages/Page 96720 - FRE Movs.al` | page 96720 "Movs. FRE" | Producto activo | Sí | Conservar; migrar a `src/` en una fase dedicada |
| `.vscode/Pages/page 96725 - FRE Excel Template Setup.al` | page 96725 "FRE Excel Template Setup" | Producto activo | Sí | Conservar; migrar a `src/` en una fase dedicada |
| `.vscode/Pages/page 96726 - FRE Import Preview.al` | page 96726 "FRE Import Preview old" | Producto activo | Sí | Conservar; migrar a `src/` en una fase dedicada |
| `.vscode/Pages/page 96729 - FRE Import Preview v2.al` | page 96729 "FRE Import Preview v2" | Producto activo | Sí | Conservar; migrar a `src/` en una fase dedicada |
| `.vscode/Pages/Page 96730 - FRE Asset Suggestion Rule.al` | page 96730 "FRE Asset Suggestion Rule" | Producto activo | Sí | Conservar; migrar a `src/` en una fase dedicada |
| `.vscode/Pages/Page 96732 - FRE Import Destination.al` | page 96732 "FRE Import Destination" | Producto activo | Sí | Conservar; migrar a `src/` en una fase dedicada |
| `.vscode/Pages/Page 96750 - FRE Bank Statements.al` | page 96750 "FRE Bank Statements" | Producto activo | Sí | Conservar; migrar a `src/` en una fase dedicada |
| `.vscode/Pages/Page 96751 - FRE Bank Statement Card.al` | page 96751 "FRE Bank Statement Card" | Producto activo | Sí | Conservar; migrar a `src/` en una fase dedicada |
| `.vscode/Pages/Page 96760 - FRE Bank Statement API.al` | page 96761 "FRE Bank Statement API" | Producto activo | Sí | Conservar; migrar a `src/` en una fase dedicada |
| `.vscode/Pages/Page 96780 - FRE Finance Role Center.al` | page 96780 "FRE Finance Role Center" | Producto activo | Sí | Conservar; migrar a `src/` en una fase dedicada |
| `.vscode/Pages/Page 96781 - FRE RC Headline.al` | page 96781 "FRE RC Headline" | Producto activo | Sí | Conservar; migrar a `src/` en una fase dedicada |
| `.vscode/Pages/Page 96782 - FRE RC Activities.al` | page 96782 "FRE RC Activities" | Producto activo | Sí | Conservar; migrar a `src/` en una fase dedicada |
| `.vscode/Pages/Page 96783 - FRE Journal Line Listpart.al` | page 96783 "FRE Journal Line ListPart" | Producto activo | Sí | Conservar; migrar a `src/` en una fase dedicada |
| `.vscode/Pages/page 96784 - FRE Ledger Entry ListPart.al` | page 96784 "FRE Ledger Entry ListPart" | Producto activo | Sí | Conservar; migrar a `src/` en una fase dedicada |
| `.vscode/Pages/Page 96786 - FRE Bank Statements ListPart.al` | page 96786 "FRE Bank Statements ListPart" | Producto activo | Sí | Conservar; migrar a `src/` en una fase dedicada |
| `.vscode/Pages/Page 96790 - OD RE FA Link ListPart.al` | page 96790 "OD RE FA Link ListPart" | Producto activo | Sí | Conservar; migrar a `src/` en una fase dedicada |
| `.vscode/Pages/Page 96810 - Gen Journal Import Preview.al` | page 96810 "Gen Journal Import Preview" | Producto activo | Sí | Conservar; migrar a `src/` en una fase dedicada |
| `.vscode/Pages/Page 96811 - OD FA RE Link ListPart.al` | page 96811 "OD FA RE Link ListPart" | Producto activo | Sí | Conservar; migrar a `src/` en una fase dedicada |
| `.vscode/Pages/Page 96812 - RE RC Getting Started.al` | page 96812 "RE RC Getting Started" | Producto activo | Sí | Conservar; migrar a `src/` en una fase dedicada |
| `.vscode/Pages/Page 96850 - FRE Tenant Notice Card.al` | page 96850 "FRE Tenant Notice Card" | Producto activo | Sí | Conservar; migrar a `src/` en una fase dedicada |
| `.vscode/Pages/Page 96851 - FRE Tenant Notice Fact Box.al` | page 96851 "FRE Tenant Notice FactBox" | Producto activo | Sí | Conservar; migrar a `src/` en una fase dedicada |
| `.vscode/Pages/Page 96852 - FRE Tenant Notice List.al` | page 96852 "FRE Tenant Notice List" | Producto activo | Sí | Conservar; migrar a `src/` en una fase dedicada |
| `.vscode/Pages/Page 96853 - FRE Tenant Notice Recipients.al` | page 96853 "FRE Tenant Notice Recipients" | Producto activo | Sí | Conservar; migrar a `src/` en una fase dedicada |
| `.vscode/Pages/Pages Extension/Page Extension 96797 - Gen Journal FRE Ext.al` | pageextension 96797 "Gen Journal FRE Ext" extends "General Journal" | Producto activo | Sí | Conservar; migrar a `src/` en una fase dedicada |
| `.vscode/Pages/Pages Extension/Page Extension 96800 - Doc Attachment List Factbox Ext.al` | pageextension 96800 "Doc Att List Factbox Ext" extends "Doc. Attachment List Factbox" | Producto activo | Sí | Conservar; migrar a `src/` en una fase dedicada |
| `.vscode/Pages/Pages Extension/Page Extension 96861 - FRE Annual Income Export.al` | pageextension 96861 "FRE Annual Income Export" extends "Simple Fixed Real Estate List" | Producto activo | Sí | Conservar; migrar a `src/` en una fase dedicada |
| `.vscode/Pages/Pages Extension/Page Extension 96862 - Lease Contract Selected Invoice.al` | pageextension 96862 "Lease Contract Selected Inv." extends "Lease Contract List" | Producto activo | Sí | Conservar; migrar a `src/` en una fase dedicada |
| `.vscode/Pages/Pages Extension/Page Extension 96863 - Lease Contract Card Invoice.al` | pageextension 96863 "Lease Contract Card Invoice" extends "Lease Contract Card" | Producto activo | Sí | Conservar; migrar a `src/` en una fase dedicada |
| `.vscode/Pages/Pages Extension/Page Extension. 96798 - FE Card RE Links.al` | pageextension 96798 "FA Card RE Links" extends "Fixed Asset Card" | Producto activo | Sí | Conservar; migrar a `src/` en una fase dedicada |
| `.vscode/PermissionSets/PermissionSet 96810 - Gen Journal Import Buffer.al` | permissionset 96810 "Gen Journal Import Buffer" | Producto activo | Sí | Conservar; migrar a `src/` en una fase dedicada |
| `.vscode/PermissionSets/PermissionSet 96850 - ODPM Admin.al` | permissionset 96850 "ODPM ADMIN" | Producto activo | Sí | Conservar; migrar a `src/` en una fase dedicada |
| `.vscode/PermissionSets/PermissionSet 96851 - ODPM Read.al` | permissionset 96851 "ODPM READ" | Producto activo | Sí | Conservar; migrar a `src/` en una fase dedicada |
| `.vscode/PermissionSets/PermissionSet 96852 - ODPM Setup.al` | permissionset 96852 "ODPM SETUP" | Producto activo | Sí | Conservar; migrar a `src/` en una fase dedicada |
| `.vscode/PermissionSets/PermissionSet 96853 - ODPM User.al` | permissionset 96853 "ODPM USER" | Producto activo | Sí | Conservar; migrar a `src/` en una fase dedicada |
| `.vscode/Profiles/Profiles Real Estate.al` | profile "OneData Property Management" | Producto activo | Sí | Conservar; migrar a `src/` en una fase dedicada |
| `.vscode/Reports/Report 96001 - Create Lease Contract Invoices.al` | report 96001 "Create Lease Contract Invoices" | Producto activo | Sí | Conservar; migrar a `src/` en una fase dedicada |
| `.vscode/Reports/Report 96003 - Lease Sales Invoice.al` | report 96003 "Lease Sales - Invoice" | Producto activo | Sí | Conservar; migrar a `src/` en una fase dedicada |
| `.vscode/Reports/Report 96005 - RE Contract Detail.al` | report 96005 "RE Contract-Detail" | Producto activo | Sí | Conservar; migrar a `src/` en una fase dedicada |
| `.vscode/Reports/Report 96007 - Fixed Real Estate Label.al` | report 96007 "Fixed Real Estate - Label" | Producto activo | Sí | Conservar; migrar a `src/` en una fase dedicada |
| `.vscode/Reports/Report 96008 - Implement Increased Price.al` | report 96008 "Implement Increased Price" | Producto activo | Sí | Conservar; migrar a `src/` en una fase dedicada |
| `.vscode/Reports/Report 96009 - Suggest Increases Prices.al` | report 96009 "Sugg. Incr. Prices Refer Index" | Producto activo | Sí | Conservar; migrar a `src/` en una fase dedicada |
| `.vscode/Reports/Report 96010 - Generate Movs. FRE.al` | report 96010 "Generate FRE Movs." | Producto activo | Sí | Conservar; migrar a `src/` en una fase dedicada |
| `.vscode/Reports/Report 96011 - Calculate Sales Amount.al` | report 96011 "Calculate Sales Amount" | Producto activo | Sí | Conservar; migrar a `src/` en una fase dedicada |
| `.vscode/Reports/Report 96600 - Liquidación Contrato.al` | report 96600 "Liquidación Contrato" | Producto activo | Sí | Conservar; migrar a `src/` en una fase dedicada |
| `.vscode/Reports/Report 96610 - Liquidación Contrato.al` | report 96610 "Liquidacion Contrato" | Producto activo | Sí | Conservar; migrar a `src/` en una fase dedicada |
| `.vscode/Reports/Report 96611 - Entrega llaves y posesion.al` | report 96611 "Entrega Llaves y Posesion" | Producto activo | Sí | Conservar; migrar a `src/` en una fase dedicada |
| `.vscode/Reports/Report 96612 - FRE Annual Income Excel.al` | report 96612 "FRE Annual Income Excel" | Producto activo | Sí | Conservar; migrar a `src/` en una fase dedicada |
| `.vscode/Tables/Tables Extension/TableExtension 96001.al` | tableextension 50685 NewFieldTable5077 extends "Segment Line" | Producto activo | Sí | Conservar; migrar a `src/` en una fase dedicada |
| `.vscode/Tables/Tables Extension/TableExtension 96796 - Gen Journal Line FRE Ext.al` | tableextension 96796 "Gen. Journal Line FRE Ext" extends "Gen. Journal Line" | Producto activo | Sí | Conservar; migrar a `src/` en una fase dedicada |
| `.vscode/Tables/Tables Extension/Tables Extension.al` | tableextension 50023 NewFieldTable36 extends "Sales Header" | Producto activo | Sí | Conservar; migrar a `src/` en una fase dedicada |
| `.vscode/Tables/Tables/Table 96000 - Fixed Real Estate.al` | table 96000 "Fixed Real Estate" | Producto activo | Sí | Conservar; migrar a `src/` en una fase dedicada |
| `.vscode/Tables/Tables/Table 96001 - Fixed Real Estate Images.al` | table 96001 "Fixed Real Estate Images" | Producto activo | Sí | Conservar; migrar a `src/` en una fase dedicada |
| `.vscode/Tables/Tables/Table 96002 - Real Estate Comment Line.al` | table 96002 "Real Estate Comment Line" | Producto activo | Sí | Conservar; migrar a `src/` en una fase dedicada |
| `.vscode/Tables/Tables/Table 96003 - REF Setup.al` | table 96003 "REF Setup" | Producto activo | Sí | Conservar; migrar a `src/` en una fase dedicada |
| `.vscode/Tables/Tables/Table 96004 - REF Income Expense Template.al` | table 96004 "REF Income & Expense Template" | Producto activo | Sí | Conservar; migrar a `src/` en una fase dedicada |
| `.vscode/Tables/Tables/Table 96005 - REF Income Expense Lines.al` | table 96005 "REF Income & Expense Lines" | Producto activo | Sí | Conservar; migrar a `src/` en una fase dedicada |
| `.vscode/Tables/Tables/Table 96006 - REF Related Contactos.al` | table 96006 "REF Related Contactos" | Producto activo | Sí | Conservar; migrar a `src/` en una fase dedicada |
| `.vscode/Tables/Tables/Table 96007 - RE Owner Cue.al` | table 96007 "RE Owner Cue" | Producto activo | Sí | Conservar; migrar a `src/` en una fase dedicada |
| `.vscode/Tables/Tables/Table 96008 - Description Documents Class.al` | table 96008 "Description Documents Class" | Producto activo | Sí | Conservar; migrar a `src/` en una fase dedicada |
| `.vscode/Tables/Tables/Table 96010 - Fixed Real Estate Web Site.al` | table 96010 "Fixed Real Estate Web Site" | Producto activo | Sí | Conservar; migrar a `src/` en una fase dedicada |
| `.vscode/Tables/Tables/Table 96011 - FRE Publicacions Register.al` | table 96011 "FRE Publicacions Register" | Producto activo | Sí | Conservar; migrar a `src/` en una fase dedicada |
| `.vscode/Tables/Tables/Table 96012 - Type Fixed Real Estate.al` | table 96012 "Type Fixed Real Estate" | Producto activo | Sí | Conservar; migrar a `src/` en una fase dedicada |
| `.vscode/Tables/Tables/Table 96013 - Street Type.al` | table 96013 "Street Type" | Producto activo | Sí | Conservar; migrar a `src/` en una fase dedicada |
| `.vscode/Tables/Tables/Table 96014 - Types Street Numbering.al` | table 96014 "Types Street Numbering" | Producto activo | Sí | Conservar; migrar a `src/` en una fase dedicada |
| `.vscode/Tables/Tables/Table 96015 - Rel XML Elem to AttribItem.al` | table 96015 "Rel. XML Elem. to Attrib. Item" | Producto activo | Sí | Conservar; migrar a `src/` en una fase dedicada |
| `.vscode/Tables/Tables/Table 96016 - RE Maintenance Registration.al` | table 96016 "RE Maintenance Registration" | Producto activo | Sí | Conservar; migrar a `src/` en una fase dedicada |
| `.vscode/Tables/Tables/Table 96017 - Published Fixed Real Estate.al` | table 96017 "Published Fixed Real Estate" | Producto activo | Sí | Conservar; migrar a `src/` en una fase dedicada |
| `.vscode/Tables/Tables/Table 96018 - Lease Contract.al` | table 96018 "Lease Contract" | Producto activo | Sí | Conservar; migrar a `src/` en una fase dedicada |
| `.vscode/Tables/Tables/Table 96019 - Lease Contract Line.al` | table 96019 "Lease Contract Line" | Producto activo | Sí | Conservar; migrar a `src/` en una fase dedicada |
| `.vscode/Tables/Tables/Table 96020 - Lease Comment Line.al` | table 96020 "Lease Comment Line" | Producto activo | Sí | Conservar; migrar a `src/` en una fase dedicada |
| `.vscode/Tables/Tables/Table 96021 - Lease Invoice Header.al` | table 96021 "Lease Invoice Header" | Producto activo | Sí | Conservar; migrar a `src/` en una fase dedicada |
| `.vscode/Tables/Tables/Table 96022 - Lease Invoice Line.al` | table 96022 "Lease Invoice Line" | Producto activo | Sí | Conservar; migrar a `src/` en una fase dedicada |
| `.vscode/Tables/Tables/Table 96023 - Active Valuation.al` | table 96023 "Active Valuation" | Producto activo | Sí | Conservar; migrar a `src/` en una fase dedicada |
| `.vscode/Tables/Tables/Table 96025 - Lease Bank Acount.al` | table 96025 "Lease Bank Account" | Producto activo | Sí | Conservar; migrar a `src/` en una fase dedicada |
| `.vscode/Tables/Tables/Table 96026 - FRE Superficies.al` | table 96026 "FRE Superficies" | Producto activo | Sí | Conservar; migrar a `src/` en una fase dedicada |
| `.vscode/Tables/Tables/Table 96027 - Tax Amount Line.al` | table 96027 "Tax Amount Line" | Producto activo | Sí | Conservar; migrar a `src/` en una fase dedicada |
| `.vscode/Tables/Tables/Table 96039 - Compose address Contract Lease.al` | Unknown declaration | Producto activo | Sí | Conservar; migrar a `src/` en una fase dedicada |
| `.vscode/Tables/Tables/Table 96040 - OD Copy Lease Contract Request.al` | table 96040 "OD Copy Lease Contract Request" | Producto activo | Sí | Conservar; migrar a `src/` en una fase dedicada |
| `.vscode/Tables/Tables/Table 96041 - OD Lease Contract Buffer.al` | table 96041 "OD Lease Contract Buffer" | Producto activo | Sí | Conservar; migrar a `src/` en una fase dedicada |
| `.vscode/Tables/Tables/Table 96042 - OD Lease Contract Copy Log.al` | table 96042 "OD Lease Contract Copy Log" | Producto activo | Sí | Conservar; migrar a `src/` en una fase dedicada |
| `.vscode/Tables/Tables/Table 96043 - OD Lease Invoice Test Buffer.al` | table 96043 "OD Lease Invoice Test Buffer" | Producto activo | Sí | Conservar; migrar a `src/` en una fase dedicada |
| `.vscode/Tables/Tables/Table 96044 - OD Lease Contract Validation Buffer.al` | table 96044 "OD Lease Ctr. Val. Buffer" | Producto activo | Sí | Conservar; migrar a `src/` en una fase dedicada |
| `.vscode/Tables/Tables/Table 96050 - Consumer Price Index.al` | table 96050 "Consumer Price Index" | Producto activo | Sí | Conservar; migrar a `src/` en una fase dedicada |
| `.vscode/Tables/Tables/Table 96051 - Consumer Price Index Categorie.al` | table 96051 "Consumer Price Index Categorie" | Producto activo | Sí | Conservar; migrar a `src/` en una fase dedicada |
| `.vscode/Tables/Tables/Table 96052 - Reference Index Rental Prices.al` | table 96052 "Reference Index Rental Prices" | Producto activo | Sí | Conservar; migrar a `src/` en una fase dedicada |
| `.vscode/Tables/Tables/Table 96053 - Rental Deposit.al` | table 96053 "Rental Deposit" | Producto activo | Sí | Conservar; migrar a `src/` en una fase dedicada |
| `.vscode/Tables/Tables/Table 96054 - FRE Equipment.al` | table 96054 "FRE Equipment" | Producto activo | Sí | Conservar; migrar a `src/` en una fase dedicada |
| `.vscode/Tables/Tables/Table 96055 - Incident Comment Line.al` | table 96055 "Incident Comment Line" | Producto activo | Sí | Conservar; migrar a `src/` en una fase dedicada |
| `.vscode/Tables/Tables/Table 96056 - Estancia.al` | table 96056 "Estancia" | Producto activo | Sí | Conservar; migrar a `src/` en una fase dedicada |
| `.vscode/Tables/Tables/Table 96100 - Incident Assets Real Estate.al` | table 96100 "Incident Assets Real Estate" | Producto activo | Sí | Conservar; migrar a `src/` en una fase dedicada |
| `.vscode/Tables/Tables/Table 96101 - Incident Attachment.al` | table 96101 "Incident Attachment" | Producto activo | Sí | Conservar; migrar a `src/` en una fase dedicada |
| `.vscode/Tables/Tables/Table 96102 - Incident Attachement Overview.al` | table 96102 "Incident Attachment Overview" | Producto activo | Sí | Conservar; migrar a `src/` en una fase dedicada |
| `.vscode/Tables/Tables/Table 96156 - RE Insurance Policy.al` | table 96156 "RE Insurance Policy" | Producto activo | Sí | Conservar; migrar a `src/` en una fase dedicada |
| `.vscode/Tables/Tables/Table 96158 - AI Incident Intake Buffer.al` | table 96158 "AI Incident Intake Buffer" | Producto activo | Sí | Conservar; migrar a `src/` en una fase dedicada |
| `.vscode/Tables/Tables/Table 96159 - ODPM Incident Agent Setup.al` | table 96159 "ODPM Incident Agent Setup" | Producto activo | Sí | Conservar; migrar a `src/` en una fase dedicada |
| `.vscode/Tables/Tables/Table 96163 - RE Insurance Cue.al` | table 96163 "RE Insurance Cue" | Producto activo | Sí | Conservar; migrar a `src/` en una fase dedicada |
| `.vscode/Tables/Tables/Table 96165 - RE Insurance Policy Asset.al` | table 96165 "RE Insurance Policy Asset" | Producto activo | Sí | Conservar; migrar a `src/` en una fase dedicada |
| `.vscode/Tables/Tables/Table 96166 - FRE Attribue.al` | table 96166 "FRE Attribute" | Producto activo | Sí | Conservar; migrar a `src/` en una fase dedicada |
| `.vscode/Tables/Tables/Table 96167 - FRE Attribute Value.al` | table 96167 "FRE Attribute Value" | Producto activo | Sí | Conservar; migrar a `src/` en una fase dedicada |
| `.vscode/Tables/Tables/Table 96168 - FRE Attribute Value Mapping.al` | table 96168 "FRE Attribute Value Mapping" | Producto activo | Sí | Conservar; migrar a `src/` en una fase dedicada |
| `.vscode/Tables/Tables/Table 96169 - FRE Attr. Value Translation.al` | table 96169 "FRE Attr. Value Translation" | Producto activo | Sí | Conservar; migrar a `src/` en una fase dedicada |
| `.vscode/Tables/Tables/Table 96170 - FRE Attribute Translation.al` | table 96170 "FRE Attribute Translation" | Producto activo | Sí | Conservar; migrar a `src/` en una fase dedicada |
| `.vscode/Tables/Tables/Table 96171 - FRE Attribute Value Selection.al` | table 96171 "FRE Attribute Value Selection" | Producto activo | Sí | Conservar; migrar a `src/` en una fase dedicada |
| `.vscode/Tables/Tables/Table 96200 - Capture Medium.al` | table 96200 "Capture Medium" | Producto activo | Sí | Conservar; migrar a `src/` en una fase dedicada |
| `.vscode/Tables/Tables/Table 96500 - Price Increases by Refer index.al` | table 96500 "Price Increases by Refer index" | Producto activo | Sí | Conservar; migrar a `src/` en una fase dedicada |
| `.vscode/Tables/Tables/Table 96600 - Liquidacion Contrato Header.al` | table 96600 "Liquidacion Contrato Header" | Producto activo | Sí | Conservar; migrar a `src/` en una fase dedicada |
| `.vscode/Tables/Tables/Table 96601 - Liquidacion Contrato Lines.al` | table 96601 "Liquidacion Contrato Lines" | Producto activo | Sí | Conservar; migrar a `src/` en una fase dedicada |
| `.vscode/Tables/Tables/Table 96700 - FRE Jnl Template.al` | table 96700 "FRE Jnl. Template" | Producto activo | Sí | Conservar; migrar a `src/` en una fase dedicada |
| `.vscode/Tables/Tables/Table 96701 - FRE Jnl Batch.al` | table 96701 "FRE Jnl. Batch" | Producto activo | Sí | Conservar; migrar a `src/` en una fase dedicada |
| `.vscode/Tables/Tables/Table 96702 - FRE Jnl Line.al` | table 96702 "FRE Jnl. Line" | Producto activo | Sí | Conservar; migrar a `src/` en una fase dedicada |
| `.vscode/Tables/Tables/Table 96720 - FRE Ledger Entry.al` | table 96720 "FRE Ledger Entry" | Producto activo | Sí | Conservar; migrar a `src/` en una fase dedicada |
| `.vscode/Tables/Tables/Table 96721 - FRE Detailed Ledger Entry.al` | table 96721 "FRE Detailed Ledg. Entry" | Producto activo | Sí | Conservar; migrar a `src/` en una fase dedicada |
| `.vscode/Tables/Tables/Table 96725 - FRE Excel Template Setup.al` | table 96725 "FRE Excel Template Setup" | Producto activo | Sí | Conservar; migrar a `src/` en una fase dedicada |
| `.vscode/Tables/Tables/Table 96726 - FRE Import Preview.al` | table 96726 "FRE Import Preview" | Producto activo | Sí | Conservar; migrar a `src/` en una fase dedicada |
| `.vscode/Tables/Tables/Table 96727 - FRE Import Suggestion Rule.al` | table 96727 "FRE Import Suggestion Rule" | Producto activo | Sí | Conservar; migrar a `src/` en una fase dedicada |
| `.vscode/Tables/Tables/Table 96729 - FRE Import Preview v2.al` | table 96729 "FRE Import Preview v2" | Producto activo | Sí | Conservar; migrar a `src/` en una fase dedicada |
| `.vscode/Tables/Tables/Table 96730 - FRE Asset Suggestion Rule.al` | table 96730 "FRE Asset Suggestion Rule" | Producto activo | Sí | Conservar; migrar a `src/` en una fase dedicada |
| `.vscode/Tables/Tables/Table 96750 - FRE Bank Statement.al` | table 96750 "FRE Bank Statement" | Producto activo | Sí | Conservar; migrar a `src/` en una fase dedicada |
| `.vscode/Tables/Tables/Table 96781 - FRE RC Cue.al` | table 96781 "FRE RC Cue" | Producto activo | Sí | Conservar; migrar a `src/` en una fase dedicada |
| `.vscode/Tables/Tables/Table 96783 - FRE RC Process Buffer.al` | table 96783 "FRE RC Process Buffer" | Producto activo | Sí | Conservar; migrar a `src/` en una fase dedicada |
| `.vscode/Tables/Tables/Table 96790 - OD RE FA Link.al` | table 96790 "OD RE FA Link" | Producto activo | Sí | Conservar; migrar a `src/` en una fase dedicada |
| `.vscode/Tables/Tables/Table 96810 - Gen Journal Import Buffer.al` | table 96810 "Gen Journal Import Buffer" | Producto activo | Sí | Conservar; migrar a `src/` en una fase dedicada |
| `.vscode/Tables/Tables/Table 96850 - FRE Tenant Notice Header.al` | table 96850 "FRE Tenant Notice Header" | Producto activo | Sí | Conservar; migrar a `src/` en una fase dedicada |
| `.vscode/Tables/Tables/Table 96851 - FRE Tenant Notice Recipient.al` | table 96851 "FRE Tenant Notice Recipient" | Producto activo | Sí | Conservar; migrar a `src/` en una fase dedicada |

