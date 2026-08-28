page 96995 "OD Lease Contract Import List"
{
    Caption = 'Importar contratos';
    ApplicationArea = All;
    Editable = true;
    PageType = List;
    SourceTable = "OD Lease Contract Import";
    SourceTableView = sorting("Import Batch ID", "Excel Row No.");
    UsageCategory = Administration;

    layout
    {
        area(content)
        {
            repeater(General)
            {
                field("Import Batch ID"; Rec."Import Batch ID")
                {
                    ApplicationArea = All;
                    Editable = false;
                }
                field("Excel Row No."; Rec."Excel Row No.")
                {
                    ApplicationArea = All;
                    Editable = false;
                }
                field("Contract No."; Rec."Contract No.")
                {
                    ApplicationArea = All;
                }
                field(Description; Rec.Description)
                {
                    ApplicationArea = All;
                }
                field("Customer No."; Rec."Customer No.")
                {
                    ApplicationArea = All;
                }
                field("Second Customer No."; Rec."Second Customer No.")
                {
                    ApplicationArea = All;
                }
                field("Fixed Real Estate No."; Rec."Fixed Real Estate No.")
                {
                    ApplicationArea = All;
                }
                field("Contract Date"; Rec."Contract Date")
                {
                    ApplicationArea = All;
                }
                field("Starting Date"; Rec."Starting Date")
                {
                    ApplicationArea = All;
                }
                field("Expiration Date"; Rec."Expiration Date")
                {
                    ApplicationArea = All;
                }
                field("Invoice Period Text"; Rec."Invoice Period Text")
                {
                    ApplicationArea = All;
                }
                field("Annual Amount"; Rec."Annual Amount")
                {
                    ApplicationArea = All;
                }
                field("Payment Method Code"; Rec."Payment Method Code")
                {
                    ApplicationArea = All;
                }
                field("Payment Terms Code"; Rec."Payment Terms Code")
                {
                    ApplicationArea = All;
                }
                field(Status; Rec.Status)
                {
                    ApplicationArea = All;
                    Editable = false;
                    StyleExpr = StatusStyleTxt;
                }
                field("Error Message"; Rec."Error Message")
                {
                    ApplicationArea = All;
                    Editable = false;
                    StyleExpr = StatusStyleTxt;
                }
                field("Warning Message"; Rec."Warning Message")
                {
                    ApplicationArea = All;
                    Editable = false;
                    StyleExpr = WarningStyleTxt;
                }
                field("Created Contract No."; Rec."Created Contract No.")
                {
                    ApplicationArea = All;
                    Editable = false;
                }
                field(Processed; Rec.Processed)
                {
                    ApplicationArea = All;
                    Editable = false;
                }
                field("Processed At"; Rec."Processed At")
                {
                    ApplicationArea = All;
                    Editable = false;
                }
                field("File Name"; Rec."File Name")
                {
                    ApplicationArea = All;
                    Editable = false;
                }
                field("Contract Import Key"; Rec."Contract Import Key")
                {
                    ApplicationArea = All;
                }
                field("Line Type Text"; Rec."Line Type Text")
                {
                    ApplicationArea = All;
                }
                field("Line Account No."; Rec."Line Account No.")
                {
                    ApplicationArea = All;
                }
                field("Line Description"; Rec."Line Description")
                {
                    ApplicationArea = All;
                }
                field("Line Value"; Rec."Line Value")
                {
                    ApplicationArea = All;
                }
                field("Line Starting Date"; Rec."Line Starting Date")
                {
                    ApplicationArea = All;
                }
                field("Line Expiration Date"; Rec."Line Expiration Date")
                {
                    ApplicationArea = All;
                }
                field("Line Service Period Text"; Rec."Line Service Period Text")
                {
                    ApplicationArea = All;
                }
                field("Line VAT Bus. Posting Group"; Rec."Line VAT Bus. Posting Group")
                {
                    ApplicationArea = All;
                }
                field("Line VAT Prod. Posting Group"; Rec."Line VAT Prod. Posting Group")
                {
                    ApplicationArea = All;
                }
                field("Line Shortcut Dim. 1 Code"; Rec."Line Shortcut Dim. 1 Code")
                {
                    ApplicationArea = All;
                }
                field("Line Shortcut Dim. 2 Code"; Rec."Line Shortcut Dim. 2 Code")
                {
                    ApplicationArea = All;
                }
                field("Line Apply Increments"; Rec."Line Apply Increments")
                {
                    ApplicationArea = All;
                }
                field("Line Apply Taxes"; Rec."Line Apply Taxes")
                {
                    ApplicationArea = All;
                }
                field("Line Base Contract"; Rec."Line Base Contract")
                {
                    ApplicationArea = All;
                }
            }
        }
    }

    actions
    {
        area(processing)
        {
            action(DownloadTemplate)
            {
                ApplicationArea = All;
                Caption = 'Descargar plantilla Excel';
                Image = ExportToExcel;

                trigger OnAction()
                var
                    ImportMgt: Codeunit "OD Lease Contract Import Mgt.";
                begin
                    ImportMgt.DownloadTemplate();
                end;
            }
            action(ImportExcel)
            {
                ApplicationArea = All;
                Caption = 'Importar Excel';
                Image = ImportExcel;

                trigger OnAction()
                var
                    ImportMgt: Codeunit "OD Lease Contract Import Mgt.";
                    BatchId: Guid;
                    EmptyGuid: Guid;
                begin
                    BatchId := ImportMgt.ImportExcel();
                    if BatchId <> EmptyGuid then begin
                        Rec.SetRange("Import Batch ID", BatchId);
                        CurrPage.Update(false);
                    end;
                end;
            }
            action(ValidateBatch)
            {
                ApplicationArea = All;
                Caption = 'Validar lote';
                Image = ValidateEmailLoggingSetup;

                trigger OnAction()
                var
                    ImportMgt: Codeunit "OD Lease Contract Import Mgt.";
                begin
                    ImportMgt.ValidateBatch(Rec."Import Batch ID");
                    CurrPage.Update(false);
                end;
            }
            action(ValidateLine)
            {
                ApplicationArea = All;
                Caption = 'Validar linea';
                Image = ValidateEmailLoggingSetup;

                trigger OnAction()
                var
                    ImportMgt: Codeunit "OD Lease Contract Import Mgt.";
                begin
                    ImportMgt.ValidateSingleLine(Rec);
                    CurrPage.Update(false);
                end;
            }
            action(ProcessBatch)
            {
                ApplicationArea = All;
                Caption = 'Crear contratos';
                Image = CreateLinesFromJob;

                trigger OnAction()
                var
                    ImportMgt: Codeunit "OD Lease Contract Import Mgt.";
                begin
                    ImportMgt.ProcessBatch(Rec."Import Batch ID");
                    CurrPage.Update(false);
                end;
            }
            action(ResetBatchForReprocessing)
            {
                ApplicationArea = All;
                Caption = 'Volver a crear contratos';
                Image = ReOpen;
                ToolTip = 'Elimina los contratos creados por este lote y deja las lineas listas para volver a validarlas y crearlas.';

                trigger OnAction()
                var
                    ImportMgt: Codeunit "OD Lease Contract Import Mgt.";
                begin
                    ImportMgt.ResetBatchForReprocessing(Rec."Import Batch ID");
                    CurrPage.Update(false);
                end;
            }
            action(CreateMissingAssetsBatch)
            {
                ApplicationArea = All;
                Caption = 'Crear lote de activos';
                Image = FixedAssets;
                ToolTip = 'Genera un lote de importacion de activos con los activos inmobiliarios que faltan en el lote actual y abre su lista para revision.';

                trigger OnAction()
                var
                    AssetImportMgt: Codeunit "OD AM Asset Import Mgt.";
                    AssetImport: Record "OD AM Asset Import";
                    BatchId: Guid;
                    EmptyGuid: Guid;
                begin
                    BatchId := AssetImportMgt.CreateBatchFromLeaseContractImport(Rec."Import Batch ID");
                    if BatchId = EmptyGuid then
                        exit;

                    AssetImport.SetRange("Import Batch ID", BatchId);
                    Page.Run(Page::"OD AM Asset Import List", AssetImport);
                end;
            }
            action(AssignFixedRealEstateNo)
            {
                ApplicationArea = All;
                Caption = 'Asignar activo inmobiliario';
                Image = Change;
                ToolTip = 'Sustituye el valor del campo activo inmobiliario cuando actualmente contiene un codigo de activo fijo, usando el vinculo activo con el inmueble.';

                trigger OnAction()
                var
                    ImportMgt: Codeunit "OD Lease Contract Import Mgt.";
                begin
                    ImportMgt.AssignFixedRealEstateNoFromFALinks(Rec."Import Batch ID");
                    CurrPage.Update(false);
                end;
            }
            action(DeleteBatch)
            {
                ApplicationArea = All;
                Caption = 'Eliminar lote';
                Image = Delete;

                trigger OnAction()
                var
                    ImportMgt: Codeunit "OD Lease Contract Import Mgt.";
                begin
                    ImportMgt.DeleteBatch(Rec."Import Batch ID");
                    CurrPage.Update(false);
                end;
            }
            action(OpenCreatedContract)
            {
                ApplicationArea = All;
                Caption = 'Ver contrato creado';
                Image = Open;

                trigger OnAction()
                var
                    LeaseContract: Record "Lease Contract";
                begin
                    if (Rec."Created Contract No." <> '') and LeaseContract.Get(Rec."Created Contract No.") then
                        Page.Run(Page::"Lease Contract Card", LeaseContract);
                end;
            }
        }
    }

    trigger OnAfterGetRecord()
    begin
        StatusStyleTxt := GetStatusStyle();
        WarningStyleTxt := GetWarningStyle();
    end;

    var
        StatusStyleTxt: Text;
        WarningStyleTxt: Text;

    local procedure GetStatusStyle(): Text
    begin
        case Rec.Status of
            Rec.Status::Created:
                exit('Favorable');
            Rec.Status::Warning:
                exit('Attention');
            Rec.Status::Error:
                exit('Unfavorable');
            Rec.Status::Pending,
            Rec.Status::Validated:
                exit('Ambiguous');
        end;
        exit('Standard');
    end;

    local procedure GetWarningStyle(): Text
    begin
        if Rec."Warning Message" <> '' then
            exit('Attention');
        exit('Standard');
    end;
}
