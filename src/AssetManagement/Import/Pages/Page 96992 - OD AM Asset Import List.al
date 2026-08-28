page 96992 "OD AM Asset Import List"
{
    Caption = 'Importar estructura de activos';
    ApplicationArea = All;
    Editable = true;
    PageType = List;
    SourceTable = "OD AM Asset Import";
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
                field("External Asset ID"; Rec."External Asset ID")
                {
                    ApplicationArea = All;
                }
                field("Parent External Asset ID"; Rec."Parent External Asset ID")
                {
                    ApplicationArea = All;
                }
                field("Property No."; Rec."Property No.")
                {
                    ApplicationArea = All;
                }
                field("FA No."; Rec."FA No.")
                {
                    ApplicationArea = All;
                }
                field("Main Property Line"; Rec."Main Property Line")
                {
                    ApplicationArea = All;
                }
                field("Parent Asset No."; Rec."Parent Asset No.")
                {
                    ApplicationArea = All;
                }
                field(Description; Rec.Description)
                {
                    ApplicationArea = All;
                }
                field("Asset Type Text"; Rec."Asset Type Text")
                {
                    ApplicationArea = All;
                }
                field("Resolved Asset Type"; Rec."Resolved Asset Type")
                {
                    ApplicationArea = All;
                    Editable = false;
                }
                field("Parent Resolved No."; Rec."Parent Resolved No.")
                {
                    ApplicationArea = All;
                    Editable = false;
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
                field("Created Asset No."; Rec."Created Asset No.")
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
                    ImportMgt: Codeunit "OD AM Asset Import Mgt.";
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
                    ImportMgt: Codeunit "OD AM Asset Import Mgt.";
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
                    ImportMgt: Codeunit "OD AM Asset Import Mgt.";
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
                    ImportMgt: Codeunit "OD AM Asset Import Mgt.";
                begin
                    ImportMgt.ValidateSingleLine(Rec);
                    CurrPage.Update(false);
                end;
            }
            action(ProcessBatch)
            {
                ApplicationArea = All;
                Caption = 'Crear activos';
                Image = CreateLinesFromJob;

                trigger OnAction()
                var
                    ImportMgt: Codeunit "OD AM Asset Import Mgt.";
                begin
                    ImportMgt.ProcessBatch(Rec."Import Batch ID");
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
                    ImportMgt: Codeunit "OD AM Asset Import Mgt.";
                begin
                    ImportMgt.DeleteBatch(Rec."Import Batch ID");
                    CurrPage.Update(false);
                end;
            }
            action(OpenCreatedAsset)
            {
                ApplicationArea = All;
                Caption = 'Ver activo creado';
                Image = FixedAssets;

                trigger OnAction()
                var
                    FixedRealEstate: Record "Fixed Real Estate";
                begin
                    if (Rec."Created Asset No." <> '') and FixedRealEstate.Get(Rec."Created Asset No.") then
                        Page.Run(Page::"Fixed Real Estate Card", FixedRealEstate);
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

    procedure SetBatchFilter(BatchId: Guid)
    begin
        Rec.Reset();
        Rec.SetRange("Import Batch ID", BatchId);
    end;
}
