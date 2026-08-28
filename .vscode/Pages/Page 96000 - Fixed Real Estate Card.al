page 96000 "Fixed Real Estate Card"
{
    Caption = 'Fixed Real Estate Card';
    PageType = Document;
    Permissions = TableData 5612 = rim;
    RefreshOnActivate = true;
    SourceTable = "Fixed Real Estate";
    ApplicationArea = All;

    layout
    {
        area(content)
        {
            usercontrol(ClipboardHelper; "OD Clipboard Helper")
            {
                ApplicationArea = All;
                Visible = true;

                trigger CopyFailed(ErrorText: Text)
                begin
                    Message(CopyToClipboardErr, ErrorText);
                end;
            }

            group(General)
            {
                Caption = 'General';
                group(Identification)
                {
                    Caption = 'Identificación';
                    field("No."; rec."No.")
                    {
                        Importance = Promoted;
                        ToolTip = 'Especifica el número identificador principal del activo inmobiliario.';

                        trigger OnAssistEdit()
                        begin
                        end;

                        trigger OnValidate()
                        begin

                        end;
                    }
                    field(Description; rec.Description)
                    {
                        Importance = Promoted;
                        ShowMandatory = true;
                        ToolTip = 'Especifica la descripción principal del activo inmobiliario.';

                        trigger OnValidate()
                        begin

                        end;
                    }
                    field(Type; rec.Type)
                    {
                        ShowMandatory = true;
                        Importance = Promoted;
                        ToolTip = 'Especifica el tipo de activo inmobiliario.';

                        trigger OnValidate()
                        begin
                            UpdatesNoFieldVisible();
                            UpdatesEditableField();
                        end;
                    }
                    field(Status; rec.Status)
                    {
                        Importance = Promoted;
                        Editable = EditableField;
                        ToolTip = 'Especifica el estado actual del activo inmobiliario.';
                    }
                    field("Asset Type"; Rec."Asset Type")
                    {
                        Caption = 'Tipo de activo';
                        Importance = Promoted;
                        ShowMandatory = true;
                        ToolTip = 'Especifica la tipología del activo inmobiliario.';
                    }
                    field("Responsible Employee"; rec."Responsible Employee")
                    {
                        Importance = Promoted;
                        ToolTip = 'Especifica el empleado responsable del activo inmobiliario.';
                    }
                    field("Phone No."; rec."Phone No.")
                    {
                        ApplicationArea = Service;
                        Editable = EditableField;
                        ToolTip = 'Especifica el número de teléfono relacionado con el activo inmobiliario, cuando corresponda.';
                    }
                    field("Search Description"; rec."Search Description")
                    {
                        Importance = Additional;
                        ToolTip = 'Especifica una descripción de búsqueda para localizar el activo inmobiliario.';
                    }
                }
            }

            group("ClassificationStructure")
            {
                Caption = 'Clasificación y estructura';
                field("Property No."; rec."Property No.")
                {
                    Editable = VisiblePropertyNo and EditableField;
                    Importance = Promoted;
                    ToolTip = 'Especifica el inmueble principal relacionado con este registro.';
                }
                field("Property Description"; rec."Property Description")
                {
                    Editable = false;
                    ToolTip = 'Muestra la descripción del inmueble principal relacionado.';
                }
                field("FRE Class Code"; rec."FRE Class Code")
                {
                    Caption = 'Código clase';
                    Importance = Promoted;
                    ToolTip = 'Especifica la clase a la que pertenece el activo inmobiliario.';
                }
                field("FRE Subclass Code"; rec."FRE Subclass Code")
                {
                    Caption = 'Código subclase';
                    Importance = Promoted;
                    ShowMandatory = true;
                    ToolTip = 'Especifica la subclase a la que pertenece el activo inmobiliario.';

                    trigger OnLookup(var Text: Text): Boolean
                    var
                        FASubclass: Record "FA Subclass";
                    begin
                        IF rec."FRE Class Code" <> '' THEN
                            FASubclass.SETFILTER("FA Class Code", '%1|%2', '', rec."FRE Class Code");

                        IF FASubclass.GET(rec."FRE Subclass Code") THEN;
                        IF PAGE.RUNMODAL(0, FASubclass) = ACTION::LookupOK THEN BEGIN
                            Text := FASubclass.Code;
                            EXIT(TRUE);
                        END;
                    end;

                    trigger OnValidate()
                    begin
                        SetDefaultPostingGroup;
                    end;
                }
                field(Totaling; Rec.Totaling)
                {
                    Editable = false;
                    ToolTip = 'Especifica el código de agrupación utilizado para informes y análisis del activo inmobiliario.';
                }
            }

            group(PropertyDetails)
            {
                Caption = 'Ubicación y construcción';
                group(AddressDetails)
                {
                    Caption = 'Dirección';
                    field(Address; rec.Address)
                    {
                        ApplicationArea = Basic, Suite;
                        ShowMandatory = true;
                        ToolTip = 'Dirección postal del activo inmobiliario.';
                    }
                    field("Address 2"; rec."Address 2")
                    {
                        ApplicationArea = Basic, Suite;
                        ToolTip = 'Especifica información adicional de la dirección del activo inmobiliario.';
                    }
                    field("Post Code"; rec."Post Code")
                    {
                        ApplicationArea = Basic, Suite;
                        Importance = Promoted;
                        ToolTip = 'Especifica el código postal del activo inmobiliario.';
                    }
                    field(City; rec.City)
                    {
                        ApplicationArea = Basic, Suite;
                        ToolTip = 'Especifica la ciudad del activo inmobiliario.';
                    }
                    field(County; rec.County)
                    {
                        ApplicationArea = Basic, Suite;
                        ToolTip = 'Especifica la provincia, estado o condado del activo inmobiliario.';
                    }
                    field("Country/Region Code"; rec."Country/Region Code")
                    {
                        ApplicationArea = Basic, Suite;
                        ToolTip = 'Especifica el país o región del activo inmobiliario.';
                    }
                    field(ShowMap; ShowMapLbl)
                    {
                        ApplicationArea = Basic, Suite;
                        Editable = false;
                        ShowCaption = false;
                        Style = StrongAccent;
                        StyleExpr = TRUE;
                        ToolTip = 'Abre la ubicación del activo inmobiliario en el mapa.';

                        trigger OnDrillDown()
                        begin
                            CurrPage.UPDATE(TRUE);
                            rec.DisplayMap;
                        end;
                    }
                    field("Google URL"; rec."Google URL")
                    {
                        Importance = Additional;
                        ToolTip = 'Especifica la URL de mapa asociada al activo inmobiliario.';
                    }
                }
                group(ConstructionDetails)
                {
                    Caption = 'Construcción y Catastro';
                    field("Cadastral reference"; rec."Cadastral reference")
                    {
                        Importance = Promoted;
                        ShowMandatory = true;
                        ToolTip = 'Referencia catastral oficial asociada al inmueble.';
                    }
                    field("Year of construction"; rec."Year of construction")
                    {
                        ToolTip = 'Especifica el año de construcción del activo inmobiliario.';
                    }
                    field("Superficie construida"; rec."Superficie construida")
                    {
                        ToolTip = 'Especifica la superficie construida del activo inmobiliario.';
                    }
                    field(ShowURL; ShowURLLbl)
                    {
                        ApplicationArea = Basic, Suite;
                        Editable = false;
                        ShowCaption = false;
                        Style = StrongAccent;
                        StyleExpr = TRUE;
                        ToolTip = 'Abre la sede electrónica del Catastro asociada al inmueble.';

                        trigger OnDrillDown()
                        begin
                            CurrPage.UPDATE(TRUE);
                            HYPERLINK(rec."URL Sede electrónica catastro");
                        end;
                    }
                    field("URL Sede electrónica catastro"; rec."URL Sede electrónica catastro")
                    {
                        Importance = Additional;
                        ToolTip = 'Especifica la URL oficial de la sede electrónica del Catastro para este inmueble.';
                    }
                }
            }

            group(CommercialPrices)
            {
                Caption = 'Información comercial y precios';
                Visible = VisiblePropertyNo;
                Editable = EditableField;
                group(SalesPrices)
                {
                    Caption = 'Venta';
                    field("Sales price"; rec."Sales price")
                    {
                        ToolTip = 'Especifica el precio de venta del activo inmobiliario.';
                    }
                    field("Minimum Sales Price"; rec."Minimum Sales Price")
                    {
                        ToolTip = 'Especifica el precio mínimo de venta del activo inmobiliario.';
                    }
                }
                group(RentalPrices)
                {
                    Caption = 'Alquiler';
                    field("Minimum Rental Price"; rec."Minimum Rental Price")
                    {
                        ToolTip = 'Especifica el precio mínimo de alquiler del activo inmobiliario.';
                    }
                    field("Last Rental Price"; Rec."Last Rental Price")
                    {
                        ToolTip = 'Especifica el último precio de alquiler registrado para el activo inmobiliario.';
                    }
                    field("Last Rental Sales Price"; Rec."Last Rental Price Modified")
                    {
                        ToolTip = 'Muestra la fecha de modificación del último precio de alquiler registrado.';
                    }
                    field("Last Rental Price Modified"; rec."Last Rental Price Modified")
                    {
                        ToolTip = 'Especifica la fecha de modificación del último precio de alquiler.';
                    }
                }
                group(ReferenceIndexes)
                {
                    Caption = 'Índices de referencia';
                    field("Last Reference Price Min."; Rec."Last Reference Price Min.")
                    {
                        ToolTip = 'Especifica el valor mínimo del índice de referencia de alquiler.';
                    }
                    field("Last Reference Price Max."; Rec."Last Reference Price Max.")
                    {
                        ToolTip = 'Especifica el valor máximo del índice de referencia de alquiler.';
                    }
                }
                group("Descripción comercial")
                {
                    Caption = 'Descripción comercial';
                    Visible = VisiblePropertyNo;
                    field(Title; Rec.Title)
                    {
                        ApplicationArea = Basic, Suite;
                        Importance = Promoted;
                        ToolTip = 'Especifica el título comercial utilizado en ofertas y publicaciones.';
                    }
                    field(FAEDescription; FAEDescription)
                    {
                        ApplicationArea = Basic, Suite;
                        Importance = Additional;
                        Caption = 'Descripción comercial';
                        MultiLine = true;
                        ToolTip = 'Especifica la descripción comercial del activo inmobiliario.';

                        trigger OnValidate()
                        begin
                            rec.SetFREDescription(FAEDescription);
                        end;
                    }
                }
            }

            group(Maintenance)
            {
                Caption = 'Gestión y mantenimiento';
                field("Vendor No."; rec."Vendor No.")
                {
                    Importance = Promoted;
                    ToolTip = 'Especifica el proveedor principal asociado al activo inmobiliario.';
                }
                field("Maintenance Vendor No."; rec."Maintenance Vendor No.")
                {
                    Importance = Promoted;
                    ToolTip = 'Especifica el proveedor encargado del mantenimiento del activo inmobiliario.';
                }
                field("Under Maintenance"; rec."Under Maintenance")
                {
                    ToolTip = 'Especifica si el activo inmobiliario se encuentra actualmente en mantenimiento.';
                }
                field(Insured; rec.Insured)
                {
                    ToolTip = 'Especifica si el activo inmobiliario está vinculado a una póliza de seguro.';
                }
            }

            group(Posting)
            {
                Caption = 'Contabilidad y dimensiones';
                field("Global Dimension 1 Code"; Rec."Global Dimension 1 Code")
                {
                    ApplicationArea = Dimensions;
                    Editable = true;
                    ToolTip = 'Especifica la dimensión global 1 asociada al activo inmobiliario.';
                }
                field("Global Dimension 2 Code"; Rec."Global Dimension 2 Code")
                {
                    ApplicationArea = Dimensions;
                    Editable = true;
                    ToolTip = 'Especifica la dimensión global 2 asociada al activo inmobiliario.';
                }
                field("Distribution Owner Type"; Rec."Distribution Owner Type")
                {
                    ApplicationArea = Basic, Suite;
                    Editable = true;
                    ToolTip = 'Especifica si el titular de distribución es un miembro o una entidad para la imputación contable del activo.';
                }
                field("Allocation Account Code"; rec."Allocation Account Code")
                {
                    ApplicationArea = Basic, Suite;
                    Editable = true;
                    ToolTip = 'Especifica el código de cuentas de reparto asociado al activo inmobiliario.';
                }
            }

            part(Lines; 96010)
            {
                ApplicationArea = Basic, Suite;
                Caption = 'Detalle económico del activo';
                SubPageLink = "No. Fixed Real Estate" = FIELD("No.");
                UpdatePropagation = Both;
                Visible = VisiblePropertyNo;
            }

            part(REInsurancePolicies; "RE Insurance Asset ListPart")
            {
                ApplicationArea = All;
                Caption = 'Pólizas de seguro';
                SubPageLink = "Fixed Real Estate No." = field("No.");
            }

            part(RealEstates; "OD RE FA Link ListPart")
            {
                Caption = 'Activos fijos relacionados';
                SubPageLink = "Real Estate No." = field("No.");
            }

            group(Control)
            {
                Caption = 'Control';
                field(Blocked; rec.Blocked)
                {
                    Importance = Additional;
                    Editable = EditableField;
                    ToolTip = 'Especifica si el activo inmobiliario está bloqueado para determinadas operaciones.';
                }
                field(Acquired; rec.Acquired)
                {
                    Importance = Additional;
                    Editable = EditableField;
                    ToolTip = 'Especifica si el activo inmobiliario ya ha sido adquirido.';
                }
                field(Managed; rec.Managed)
                {
                    Importance = Additional;
                    Editable = EditableField;
                    ToolTip = 'Especifica si el activo inmobiliario se gestiona desde el sistema.';
                }
                field("Last Date Modified"; rec."Last Date Modified")
                {
                    Importance = Additional;
                    ToolTip = 'Especifica la última fecha en la que se modificó la ficha del activo inmobiliario.';
                }
            }
        }
        area(factboxes)
        {
            part("Attached Documents"; "Doc. Attachment List Factbox")
            {
                Caption = 'Adjuntos';
                UpdatePropagation = Both;
                SubPageLink = "Table ID" = CONST(96000),
                              "No." = FIELD("No.");
                Visible = ShowAttachmentFactbox;
            }
            systempart("Links"; Links)
            {
                Visible = false;
            }
            systempart("Notes"; Notes)
            {
            }
            part(FixedREAttributesFactbox; 96003)
            {
                Visible = false;
            }
        }
    }

    actions
    {
        area(navigation)
        {
            group(LeaseContracts)
            {
                Caption = 'Contratos y alquiler';
                action(CreateLeaseContractWizard)
                {
                    Caption = 'Nuevo contrato de alquiler';
                    ApplicationArea = All;
                    Image = NewDocument;
                    Promoted = true;
                    PromotedCategory = Process;
                    ToolTip = 'Crea un nuevo contrato de alquiler a partir del activo inmobiliario actual.';

                    trigger OnAction()
                    var
                        LeaseWizardMgt: Codeunit "OD AM Lease Wizard Mgt.";
                    begin
                        LeaseWizardMgt.RunWizard(Rec);
                    end;
                }
                action(Contratos)
                {
                    Caption = 'Contratos';
                    Image = ContractPayment;
                    Promoted = true;
                    RunObject = Page "Lease Contract List";
                    RunPageLink = "Fixed Real Estate No." = FIELD("No.");
                    RunPageView = SORTING("Contract No.")
                                  WHERE(Status = CONST(Signed));
                }
                action("FacturasAlquiler")
                {
                    Caption = 'Facturas alquiler';
                    Image = Invoice;
                    Promoted = true;
                    RunObject = Page "Posted Lease Invoices";
                    RunPageLink = "Fixed Real Estate No." = FIELD("No.");
                    ToolTip = 'Muestra las facturas de alquiler registradas del activo inmobiliario.';
                }
                action("Precios Indices de referencia")
                {
                    Caption = 'Precios índices de referencia';
                    Image = PriceWorksheet;
                    RunObject = Page "Reference Index Rental Prices";
                    RunPageLink = "Fixed Real Estate No." = FIELD("No.");
                    RunPageView = SORTING("Fixed Real Estate No.", "Line No.");
                    ToolTip = 'Muestra el histórico de índices de referencia de alquiler del activo inmobiliario.';
                }
            }
            group(PropertyManagement)
            {
                Caption = 'Gestión del inmueble';
                action(Statistics)
                {
                    Caption = 'Estadísticas';
                    Image = Statistics;
                    Promoted = true;
                    RunObject = Page "Fixed RE Statistics";
                    RunPageLink = "No." = FIELD("No.");
                    ShortCutKey = 'F7';
                    ToolTip = 'Muestra información histórica y estadística del activo inmobiliario.';
                }
                action(Incidents)
                {
                    Caption = 'Incidencias';
                    Image = Interaction;
                    Promoted = true;
                    RunObject = Page "RE Incident Mobile";
                    RunPageLink = "Fixed Real Estate No." = FIELD("No.");
                    ToolTip = 'Muestra las incidencias o solicitudes de servicio asociadas al activo inmobiliario.';
                }
                action("Maintenance &Registration")
                {
                    Caption = 'Mantenimiento y registros';
                    Image = MaintenanceRegistrations;
                    RunObject = Page 96016;
                    RunPageLink = "FRE No." = FIELD("No.");
                    ToolTip = 'Muestra los mantenimientos, reparaciones y registros asociados al activo inmobiliario.';
                }
                action(OpenInsurancePolicies)
                {
                    Caption = 'Pólizas de seguro';
                    Image = Insurance;
                    RunObject = Page "RE Insurance Policy Assets";
                    RunPageLink = "Fixed Real Estate No." = FIELD("No.");
                    ToolTip = 'Muestra las pólizas de seguro vinculadas al activo inmobiliario.';
                }
                action("Equipamientos")
                {
                    Caption = 'Equipamientos';
                    Image = FixedAssets;
                    RunObject = Page "FRE Equipments";
                    RunPageLink = "FRE No." = FIELD("No.");
                    RunPageView = SORTING("FRE No.", "Line No.");
                }
                action("Related Contats")
                {
                    Caption = 'Contactos relacionados';
                    Image = ContactReference;
                    RunObject = Page "REF Related Contactos";
                    RunPageLink = "Entity Type" = CONST("Fixed Real Estate"),
                                "Source No." = FIELD("No.");
                }
                action("Co&mments")
                {
                    ApplicationArea = Comments;
                    Caption = 'Co&mments';
                    Image = ViewComments;
                    RunObject = Page 96008;
                    ToolTip = 'Muestra o permite registrar comentarios del activo inmobiliario.';
                }
            }
            group(ExternalData)
            {
                Caption = 'Datos externos';
                action(UpdateFromCatastro)
                {
                    Caption = 'Actualizar Catastro';
                    Image = UpdateDescription;
                    Promoted = true;
                    ToolTip = 'Consulta los servicios oficiales del Catastro para actualizar la referencia catastral y la URL oficial del inmueble.';

                    trigger OnAction()
                    var
                        CatastroServiceMgt: Codeunit "Catastro Service Mgt.";
                    begin
                        CatastroServiceMgt.UpdateFixedRealEstateFromCatastro(Rec);
                        CurrPage.Update(true);
                    end;
                }
                action(OpenSerpaviReferencePrice)
                {
                    Caption = 'Consultar índice alquiler MIVAU';
                    Image = PriceWorksheet;
                    Promoted = true;
                    ToolTip = 'Abre el portal oficial SERPAVI para consultar el rango de precio de alquiler de referencia del inmueble.';

                    trigger OnAction()
                    var
                        SerpaviServiceMgt: Codeunit "SERPAVI Service Mgt.";
                        SearchText: Text;
                    begin
                        SearchText := SerpaviServiceMgt.GetSearchTextForFixedRealEstate(Rec);
                        CurrPage.ClipboardHelper.CopyText(SearchText);
                        SerpaviServiceMgt.OpenSerpaviForFixedRealEstate(Rec);
                        CurrPage.Update(true);
                    end;
                }
            }
            group(Accounting)
            {
                Caption = 'Contabilidad';
                action(Dimensions)
                {
                    ApplicationArea = Dimensions;
                    Caption = 'Dimensiones';
                    Image = Dimensions;
                    RunObject = Page 540;
                    RunPageLink = "Table ID" = CONST(96000),
                                "No." = FIELD("No.");
                    ShortCutKey = 'Shift+Ctrl+D';
                    ToolTip = 'Muestra o permite editar las dimensiones asociadas al activo inmobiliario.';
                }
                action(AllocationAccounts)
                {
                    Caption = 'Cuentas de reparto';
                    Image = ChartOfAccounts;
                    ToolTip = 'Muestra las cuentas de reparto relacionadas con este activo inmobiliario.';

                    trigger OnAction()
                    var
                        AllocationAccount: Record "Allocation Account";
                    begin
                        Rec.TestField("No.");
                        AllocationAccount.SetRange("No.", Rec."No.");
                        Page.Run(0, AllocationAccount);
                    end;
                }
                action(FRELedgerEntries)
                {
                    ApplicationArea = Basic, Suite;
                    Caption = 'Movimientos del activo';
                    Image = LedgerEntries;
                    ToolTip = 'Muestra los movimientos contables del activo inmobiliario.';

                    trigger OnAction()
                    var
                        FRELedgerEntry: Record "FRE Ledger Entry";
                    begin
                        FRELedgerEntry.SetRange("Fixed Real Estate No.", Rec."No.");
                        Page.Run(Page::"Movs. FRE", FRELedgerEntry);
                    end;
                }
                action(CreateExclusiveFA)
                {
                    Caption = 'Crear Activo Fijo';

                    trigger OnAction()
                    var
                        Mgt: Codeunit "OD RE FA Link Mgt.";
                    begin
                        Mgt.CreateExclusiveFAForRealEstate(Rec);
                    end;
                }
            }
            group(Documents)
            {
                Caption = 'Documentos';
                action(Attachments)
                {
                    Caption = 'Adjuntos';
                    Image = Attach;
                    Promoted = true;

                    trigger OnAction()
                    var
                        DocumentAttachmentDetails: Page "Document Attachment Details";
                        RecRef: RecordRef;
                    begin
                        CurrPage.SAVERECORD;

                        RecRef.GETTABLE(Rec);
                        DocumentAttachmentDetails.OpenForRecRef(RecRef);
                        DocumentAttachmentDetails.RUNMODAL;
                    end;
                }
                fileuploadaction(UploadAttachments)
                {
                    Caption = 'Subir archivos';
                    Image = Import;
                    ApplicationArea = Basic, Suite;
                    AllowMultipleFiles = true;
                    ToolTip = 'Permite subir uno o varios archivos y adjuntarlos a este activo inmobiliario.';

                    trigger OnAction(files: List of [FileUpload])
                    var
                        DocumentAttachment: Record "Document Attachment";
                        RecRef: RecordRef;
                    begin
                        CurrPage.SAVERECORD;

                        RecRef.GETTABLE(Rec);
                        DocumentAttachment.SaveAttachment(files, RecRef);

                        CurrPage.UPDATE;
                    end;
                }
                action(Avatar)
                {
                    Caption = 'Avatar';
                    Image = Picture;
                    RunObject = Page "Fixed Real Estate Avatar";
                    RunPageLink = "No." = FIELD("No.");
                }
            }
            action(Attributes)
            {
                AccessByPermission = TableData 7500 = R;
                ApplicationArea = Basic, Suite;
                Caption = 'Atributos';
                Image = Category;
                ToolTip = 'Muestra o permite editar los atributos descriptivos del activo inmobiliario.';

                trigger OnAction()
                begin
                    PAGE.RUNMODAL(PAGE::"Fixed RE Attribute Value Edit.", Rec);
                    CurrPage.SAVERECORD;
                    CurrPage.FixedREAttributesFactbox.PAGE.LoadItemAttributesData(rec."No.");
                end;
            }
        }
        area(processing)
        {
            action("Calculate Totaling")
            {
                Caption = 'Calcular sumatorio';
                Image = CalculateLines;

                trigger OnAction()
                begin
                    rec.CalculateTotaling;
                    rec.CalculateAmounts();
                    CurrPage.UPDATE(TRUE);
                end;
            }
            action(Publish)
            {
                ApplicationArea = Basic, Suite;
                Caption = 'Publicar';
                Image = ExportFile;
                ToolTip = 'Publica la información del activo inmobiliario en la web.';

                trigger OnAction()
                begin
                    rec.PublicToWebSite;
                end;
            }
        }
        area(reporting)
        {
            action("G/L Analysis")
            {
                Caption = 'G/L Analysis';
                Image = "Report";
                //RunObject = Report 5610;
                //ToolTip = 'View an analysis of your real estate assets with various types of data for individual real estate assets and/or groups of real estate assets.';
            }
            action(Etiqueta)
            {
                Image = "Report";

                trigger OnAction()
                var
                    FixedRealEstate: Record "Fixed Real Estate";
                begin
                    FixedRealEstate.RESET;
                    FixedRealEstate.SETRANGE("No.", rec."No.");
                    REPORT.RUN(96007, TRUE, TRUE, FixedRealEstate);
                end;
            }
        }
    }

    trigger OnAfterGetCurrRecord()
    begin
        CurrPage.FixedREAttributesFactbox.PAGE.LoadItemAttributesData(rec."No.");
    end;

    trigger OnAfterGetRecord()
    begin
        UpdatesNoFieldVisible;
        UpdatesEditableField();

        FAEDescription := rec.GetFREDescription;
        ShowAttachmentFactbox := IsRecordPersisted;
    end;

    trigger OnNewRecord(BelowxRec: Boolean)
    begin
        CurrPage.UPDATE(FALSE);
        ShowAttachmentFactbox := false;
    end;

    trigger OnOpenPage()
    begin
        Simple := TRUE;
        SetNoFieldVisible;
        ShowAttachmentFactbox := IsRecordPersisted;
    end;

    var
        FAAcquireWizardNotificationId: Guid;
        Simple: Boolean;
        Acquirable: Boolean;
        FAEDescription: Text;
        ShowAttachmentFactbox: Boolean;
        ShowMapLbl: Label 'Ver en mapa';
        VisiblePropertyNo: Boolean;
        ShowURLLbl: Label 'Abrir Catastro';
        EditableField: Boolean;
        CopyToClipboardErr: Label 'No se ha podido copiar automáticamente el dato de búsqueda al portapapeles.\%1';

    local procedure SetDefaultPostingGroup()
    var
        FASubclass: Record "FA Subclass";
    begin
        IF FASubclass.GET(rec."FRE Subclass Code") THEN;
    end;

    local procedure SetNoFieldVisible()
    begin
        VisiblePropertyNo := FALSE;
        EditableField := TRUE;
    end;

    local procedure UpdatesNoFieldVisible()
    var
    begin
        VisiblePropertyNo := (rec.Type <> rec.Type::Propiedad);
    end;

    local procedure IsRecordPersisted(): Boolean
    var
        FixedRealEstate: Record "Fixed Real Estate";
    begin
        if Rec."No." = '' then
            exit(false);

        FixedRealEstate.SetRange("No.", Rec."No.");
        exit(FixedRealEstate.FindFirst());
    end;

    local procedure UpdatesEditableField()
    begin
        EditableField := (rec.Type <> rec.Type::Propiedad);
    end;
}
