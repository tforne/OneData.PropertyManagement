page 96031 "Lease Contract Card"
{
    PageType = Card;
    SourceTable = "Lease Contract";
    Caption = 'Lease Contract';
    ApplicationArea = All;

    layout
    {
        area(content)
        {
            part(SumaryLeaseContract; 96053)
            {
                SubPageLink = "Contract No." = field("Contract No.");

            }
            group(General)
            {
                field("Contract No."; rec."Contract No.")
                {
                }
                field(Description; rec.Description)
                {
                }
                group("Activo inmobiliario")
                {
                    Caption = 'Activo inmobiliario';
                    field("Fixed Real Estate No."; rec."Fixed Real Estate No.")
                    {
                    }
                    field("Description Fixed Real Estate"; rec."Description Fixed Real Estate")
                    {
                        Caption = 'Descripción activo inmobiliario';
                    }
                }
                group("Activo inmobiliario 2")
                {
                    Caption = 'Estado';
                    field("Salesperson Code"; rec."Salesperson Code")
                    {
                        ToolTip = 'Specifies the code of the salesperson assigned to this lease contract.';
                    }
                    field(Status; rec.Status)
                    {
                        Importance = Promoted;
                        Editable = false;
                        ToolTip = 'Specifies the status of the lease contract or contract quote.';
                    }
                }
                group("Activo inmobiliario 3")
                {
                    Caption = 'Dirección';
                    field("Types Street Numbering Id."; rec."Types Street Numbering Id.")
                    {
                    }
                    field("Street Name"; rec."Street Name")
                    {
                    }
                    field("Number On Street"; rec."Number On Street")
                    {
                    }
                    field("Location Height Floor"; rec."Location Height Floor")
                    {
                    }
                    field("FRE Address"; rec."FRE Address")
                    {
                    }
                    field("FRE City"; rec."FRE City")
                    {
                        ToolTip = 'Specifies the customer''s city.';
                    }
                    field("FRE County"; rec."FRE County")
                    {
                        ToolTip = 'Specifies the state, province or county as a part of the address.';
                    }
                    field("FRE Post Code"; rec."FRE Post Code")
                    {
                        Importance = Promoted;
                        ToolTip = 'Specifies the postal code.';
                    }
                    field("FRE Country/Region Code"; rec."FRE Country/Region Code")
                    {
                        ToolTip = 'Specifies the country/region of the address.';
                    }
                    field(ShowMap; ShowMapLbl)
                    {
                        Editable = false;
                        ShowCaption = false;
                        Style = StrongAccent;
                        StyleExpr = TRUE;
                        ToolTip = 'Specifies the customer''s address on your preferred map website.';

                        trigger OnDrillDown()
                        begin
                            CurrPage.UPDATE(TRUE);
                            // DisplayMap;
                        end;
                    }
                    field("Google URL"; rec."Google URL")
                    {
                        Editable = true;
                        ToolTip = 'Specifies the URL to display the address on Google Maps.';
                    }
                }
            }
            group(Arrendadores)
            {
                Caption = 'Arrendadores';
                group("1er. arrendador")
                {
                    Caption = '1er. arrendador';
                    field("Customer No."; rec."Customer No.")
                    {
                        Importance = Promoted;
                        ToolTip = 'Specifies the number of the customer who owns in the lease contract.';

                        trigger OnValidate()
                        begin
                            CustomerNoOnAfterValidate;
                        end;
                    }
                    field("Contact No."; rec."Contact No.")
                    {
                        ToolTip = 'Specifies the number of the contact who will receive the service delivery.';
                    }
                    field(Name; rec.Name)
                    {
                        DrillDown = false;
                        ToolTip = 'Specifies the name of the customer in the lease contract.';
                    }
                    field(Address; rec.Address)
                    {
                        DrillDown = false;
                        ToolTip = 'Specifies the customer''s address.';
                    }
                    field("Address 2"; rec."Address 2")
                    {
                        DrillDown = false;
                        ToolTip = 'Specifies additional address information.';
                    }
                    field(City; rec.City)
                    {
                        DrillDown = false;
                        ToolTip = 'Specifies the name of the city in where the customer is located.';
                    }
                    field(County; rec.County)
                    {
                    }
                    field("Post Code"; rec."Post Code")
                    {
                        DrillDown = false;
                        ToolTip = 'Specifies the postal code.';
                    }
                    field("Country/Region Code"; rec."Country/Region Code")
                    {
                    }
                    field("Contact Name"; rec."Contact Name")
                    {
                        DrillDown = false;
                        ToolTip = 'Specifies the name of the person you regularly contact when you do business with the customer in this lease contract.';
                    }
                    field("Phone No."; rec."Phone No.")
                    {
                        ToolTip = 'Specifies the customer phone number.';
                    }
                    field("E-Mail"; rec."E-Mail")
                    {
                        ExtendedDatatype = EMail;
                        ToolTip = 'Specifies the customer''s email address.';
                    }
                    field("Notify Customer"; rec."Notify Customer")
                    {
                    }
                }
                group("2o. arrendador")
                {
                    Caption = '2o. arrendador';
                    Visible = true;

                    field("Second Customer No."; rec."Second Customer No.")
                    {
                        Importance = Promoted;
                        ToolTip = 'Specifies the number of the customer who owns the service items in the lease contract/contract quote.';

                        trigger OnValidate()
                        begin
                            CustomerNoOnAfterValidate;
                        end;
                    }
                    field("Second Contact No."; rec."Second Contact No.")
                    {
                        ToolTip = 'Specifies the number of the contact who will receive the service delivery.';
                    }
                    field("Second Name"; rec."Second Name")
                    {
                        DrillDown = false;
                        ToolTip = 'Specifies the name of the customer in the lease contract.';
                    }
                    field("Second Address"; rec."Second Address")
                    {
                        DrillDown = false;
                        ToolTip = 'Specifies the customer''s address.';
                    }
                    field("Second Address 2"; rec."Second Address 2")
                    {
                        DrillDown = false;
                        ToolTip = 'Specifies additional address information.';
                    }
                    field("Second City"; rec."Second City")
                    {
                        DrillDown = false;
                        ToolTip = 'Specifies the name of the city in where the customer is located.';
                    }
                    field("Second County"; rec."Second County")
                    {
                    }
                    field("Second Post Code"; rec."Second Post Code")
                    {
                        DrillDown = false;
                        ToolTip = 'Specifies the postal code.';
                    }
                    field("Second Country/Region Code"; rec."Second Country/Region Code")
                    {
                    }
                    field("Second Name 2"; rec."Second Name 2")
                    {
                        DrillDown = false;
                        ToolTip = 'Specifies the name of the person you regularly contact when you do business with the customer in this lease contract.';
                    }
                    field("Phone No. 2"; rec."Phone No. 2")
                    {
                        ToolTip = 'Specifies the customer phone number.';
                    }
                    field("E-Mail 2"; rec."E-Mail 2")
                    {
                        ExtendedDatatype = EMail;
                        ToolTip = 'Specifies the customer''s email address.';
                    }
                    field("Notify Customer 2"; rec."Notify Customer 2")
                    {
                    }
                }
            }
            group(Alquiler)
            {
                field("Invoice Period"; rec."Invoice Period")
                {
                }
                field("Contract Date"; rec."Contract Date")
                {
                }
                field("Starting Date"; rec."Starting Date")
                {
                }
                field("Lease Period"; rec."Lease Period")
                {
                }
                field("Expiration Date"; rec."Expiration Date")
                {
                }
                field(CurrentContractAmount; CurrentContractAmount)
                {
                    Caption = 'Contrato actual';
                    BlankZero = true;
                    Editable = false;
                }
                field(LastRentalPrice; LastRentalPrice)
                {
                    Caption = 'Último precio de alquiler';
                    BlankZero = true;
                    Editable = false;
                }
                field(ReferencePriceMin; ReferencePriceMin)
                {
                    Caption = 'Índice de referencia mínimo';
                    BlankZero = true;
                    Editable = false;
                }
                field(ReferencePriceMax; ReferencePriceMax)
                {
                    Caption = 'Índice de referencia máximo';
                    BlankZero = true;
                    Editable = false;
                }
                field("Payment Method Code"; rec."Payment Method Code")
                {
                }
                field("Payment Terms Code"; rec."Payment Terms Code")
                {
                }
                field("Grupo IRPF"; Rec."Grupo IRPF")
                {
                }
                group("Detalle Factura")
                {
                    field("Amount per Period"; rec."Amount per Period")
                    {
                        Editable = true;
                    }
                    field("Lease Manag. Amount per Period"; rec."Lease Manag. Amount per Period")
                    {
                    }
                    field("Prices Services Including VAT"; rec."Prices Services Including VAT")
                    {
                    }
                    field("Generic Prod. Posting Gr."; Rec."Generic Prod. Posting Gr.")
                    {
                    }
                    field("Customer Template Code"; rec."Customer Template Code")
                    {
                    }
                }
                group(Fianzas)
                {
                    Caption = 'Comentarios';
                    field(BailDescription; BailDescription)
                    {
                        Importance = Standard;
                        MultiLine = true;
                        ShowCaption = false;
                        ToolTip = 'Specifies the comments';

                        trigger OnValidate()
                        begin
                            rec.SetBailDescription(BailDescription);
                        end;
                    }
                    field("Consumer Price Index Category"; Rec."Consumer Price Index Category")
                    {
                    }
                }
            }
            part(LeaseContractLines; 96032)
            {
                SubPageLink = "Contract No." = FIELD("Contract No.");
            }
            group(Pagos)
            {
                Caption = 'Pagos';
                field("Preferred Bank Account Code"; rec."Preferred Bank Account Code")
                {
                }
            }
        }
        area(factboxes)
        {
            part(LiquidacionFactBox; "Liquidacion Contrato FactBox")
            {
                Caption = 'Liquidación';
                UpdatePropagation = Both;
                SubPageLink = "Contract No." = field("Contract No.");
            }
            part("Attached Documents List"; "Doc. Attachment List Factbox")
            {
                Caption = 'Documents';
                UpdatePropagation = Both;
                SubPageLink = "Table ID" = const(Database::"Lease Contract"),
                            "No." = field("Contract No.");
                Visible = ShowAttachmentFactbox;
            }
        }
    }

    actions
    {
        area(navigation)
        {
            group(Related)
            {
                Caption = 'Related';
                action("Co&mments")
                {
                    Caption = 'Co&mments';
                    Image = ViewComments;
                    RunObject = Page 96033;
                    RunPageLink = "Table Name" = CONST("Lease Contract"),
                                    "No." = FIELD("Contract No."),
                                    "Table Line No." = CONST(0);
                    ToolTip = 'View or add comments for the record.';
                }
                action("Rentals Deposit")
                {
                    Caption = 'Rentals Deposit';
                    Image = Prepayment;
                    RunObject = Page 96054;
                    RunPageLink = "Contract No." = FIELD("Contract No.");
                    ToolTip = 'View and manage rental deposits for this lease contract.';
                }
                action("Related Contats")
                {
                    Caption = 'Related contacts';
                    Image = ContactReference;
                    RunObject = Page 96013;
                    RunPageLink = "Entity Type" = CONST(Contract),
                                    "Source No." = FIELD("Contract No.");
                }
                action(PagePostedLeaseInvoiceLines)
                {
                    Caption = 'Posted Lease Invoice Lines';
                    Image = PostDocument;
                    ShortCutKey = 'Ctrl+F7';
                    ToolTip = 'View a list of posted lease invoice lines related to this document.';
                    RunObject = Page 96057;
                    RunPageLink = "Contract No." = FIELD("Contract No.");
                }
                action(Visualizar2oArrendador)
                {
                    Caption = 'Show';
                    Image = ContactReference;
                    Visible = true;

                    trigger OnAction()
                    begin
                        Visible2Arrendador := true;
                        CurrPage.Update(false);
                    end;
                }
            }
            group(Adjuntos)
            {
                Caption = 'Adjuntos';
                action(Attachments)
                {
                    Caption = 'Attachments';
                    Image = Attach;
                    ToolTip = 'Add a file as an attachment. You can attach images as well as documents.';
                    Enabled = ShowAttachmentActions;

                    trigger OnAction()
                    var
                        DocumentAttachmentDetails: Page "Document Attachment Details";
                        RecRef: RecordRef;
                    begin
                        GetAttachmentRecRef(RecRef);
                        DocumentAttachmentDetails.OpenForRecRef(RecRef);
                        DocumentAttachmentDetails.RUNMODAL;
                    end;
                }
                fileuploadaction(UploadAttachments)
                {
                    Caption = 'Upload files';
                    Image = Import;
                    ApplicationArea = Basic, Suite;
                    AllowMultipleFiles = true;
                    Enabled = ShowAttachmentActions;
                    ToolTip = 'Upload one or more files and attach them to this lease contract.';

                    trigger OnAction(files: List of [FileUpload])
                    var
                        DocumentAttachment: Record "Document Attachment";
                        RecRef: RecordRef;
                    begin
                        GetAttachmentRecRef(RecRef);
                        DocumentAttachment.SaveAttachment(files, RecRef);
                        CurrPage.UPDATE(false);
                    end;
                }
                action(CopyAttachmentsFromFRE)
                {
                    Caption = 'Copiar adjuntos desde inmueble';
                    Image = CopyDocument;
                    Enabled = ShowAttachmentActions;
                    ToolTip = 'Copia a este contrato los archivos adjuntos del activo inmobiliario relacionado.';

                    trigger OnAction()
                    begin
                        CurrPage.SAVERECORD;
                        RealEstateMangement.CopyContractAttachmentsFromFixedRealEstate(Rec);
                        CurrPage.UPDATE(false);
                    end;
                }
            }
        }
        area(processing)
        {
            group(Contract)
            {
                Caption = 'Contract';
                action(SignContract)
                {
                    Caption = 'Si&gn Contract';
                    Image = Signature;
                    ToolTip = 'Confirm the contract.';

                    trigger OnAction()
                    var
                    begin
                        CurrPage.UPDATE;
                        RealEstateMangement.SignContract(Rec);
                        CurrPage.UPDATE;
                    end;
                }
                action(CancelContract)
                {
                    Caption = '&Cancel Contract';
                    Image = Lock;
                    ToolTip = 'Make sure that the changes will be part of the contract.';

                    trigger OnAction()
                    begin
                        CurrPage.UPDATE;
                        RealEstateMangement.CancelContract(Rec);
                        CurrPage.UPDATE
                    end;
                }
                action(CheckLeaseContract)
                {
                    Caption = 'Comprobar contrato';
                    Image = CheckRulesSyntax;
                    ToolTip = 'Revisa si el contrato tiene datos obligatorios, líneas válidas e importes coherentes antes de firmarlo o facturarlo.';

                    trigger OnAction()
                    var
                        ValidationMgt: Codeunit 96986;
                        TempValidationBuffer: Record 96044 temporary;
                        ValidationResultsPage: Page 96074;
                    begin
                        CurrPage.SAVERECORD;
                        ValidationMgt.BuildLeaseContractValidationBuffer(Rec, TempValidationBuffer);
                        if TempValidationBuffer.IsEmpty() then begin
                            Message(ContractValidationOkMsg, Rec."Contract No.");
                            exit;
                        end;

                        ValidationResultsPage.LoadResults(TempValidationBuffer);
                        ValidationResultsPage.RunModal();
                    end;
                }
                action(LiquidarContrato)
                {
                    Caption = 'Liquidar contrato';
                    Image = Close;
                    ToolTip = 'Cierra definitivamente el contrato y realiza la liquidación final.';
                    Enabled = Rec.Status = Rec.Status::Signed;

                    trigger OnAction()
                    var
                        LiquidacionContrato: Record "Liquidacion Contrato Header";
                        Wizard: Page "Liquidacion Contrato Card";
                    begin
                        if not Confirm(
                            'Esta acción cerrará definitivamente el contrato.\' +
                            '¿Desea continuar?',
                            false)
                        then
                            exit;
                        if not LiquidacionContrato.Get(rec."Contract No.") then begin
                            LiquidacionContrato."Contract No." := rec."Contract No.";
                            if LiquidacionContrato.Insert() then;
                        end;
                        commit;
                        Wizard.SetContrato(Rec."Contract No.");
                        Wizard.RunModal();
                        CurrPage.Update();
                    end;
                }
            }
            group(RentReview)
            {
                Caption = 'Rent review';
                action(UpdateRentReviewFromINE)
                {
                    Caption = 'Actualizar revisión alquiler';
                    Image = CalculateLines;
                    ToolTip = 'Consulta el índice oficial vigente del INE según la categoría del contrato y genera o actualiza la propuesta de revisión de renta.';
                    AccessByPermission = tabledata "Price Increases by Refer index" = IMD;
                    Enabled = Rec.Status = Rec.Status::Signed;

                    trigger OnAction()
                    var
                        INERentalIndexMgt: Codeunit "INE Rental Index Mgt.";
                        PriceIncreaseWorksheet: Record "Price Increases by Refer index";
                        PriceIncreaseWorksheetPage: Page "Price Increases by Refer index";
                    begin
                        CurrPage.Update(true);
                        INERentalIndexMgt.PrepareContractRentalReview(Rec, PriceIncreaseWorksheet);
                        PriceIncreaseWorksheet.SetRange("Contract No.", Rec."Contract No.");
                        PriceIncreaseWorksheet.SetRange("Line No.", PriceIncreaseWorksheet."Line No.");
                        PriceIncreaseWorksheetPage.SetTableView(PriceIncreaseWorksheet);
                        PriceIncreaseWorksheetPage.RunModal();
                        CurrPage.Update(false);
                    end;
                }
            }
            group(DataManagement)
            {
                Caption = 'Data management';
                action(CopyFromAnotherCompany)
                {
                    Caption = 'Copiar desde otra empresa';
                    Image = CopyDocument;
                    ToolTip = 'Copia cabecera y/o líneas desde un contrato de otra empresa.';

                    trigger OnAction()
                    var
                        CopyMgt: Codeunit "OD Copy Lease Contract Mgt.";
                    begin
                        CopyMgt.RunCopyContract(Rec);
                    end;
                }
                action(OpenLeaseContractCopyLog)
                {
                    Caption = 'Log copia contratos';
                    Image = Log;
                    RunObject = page "OD Lease Contract Copy Log";
                    ToolTip = 'Muestra el histórico de copias de contratos entre empresas.';
                }
                action("Copy owner from FRE")
                {
                    Caption = 'Copy owner from FRE';
                    Image = Copy;

                    trigger OnAction()
                    begin
                        rec.CopyContactsOwnerFromFRE();
                        CurrPage.UPDATE(TRUE);
                    end;
                }
            }
        }
        area(reporting)
        {
            action("&Print")
            {
                Caption = '&Print';
                Ellipsis = true;
                Image = Print;
                ToolTip = 'Prepare to print the document. A report request window for the document opens where you can specify what to include on the print-out.';

                trigger OnAction()
                var
                    LeaseContract: Record "Lease Contract";
                begin

                    LeaseContract.RESET;
                    LeaseContract.SETRANGE("Contract No.", rec."Contract No.");
                    REPORT.RUNMODAL(96005, TRUE, TRUE, LeaseContract);
                    CurrPage.UPDATE;
                end;
            }
        }
    }

    trigger OnAfterGetCurrRecord()
    begin
        LoadFixedRealEstateRentInfo();
        BailDescription := rec.GetBailDescription;
        Visible2Arrendador := Obligar2Arrendador or (rec."Second Name" <> '');
        ShowAttachmentFactbox := IsRecordPersisted;
        ShowAttachmentActions := ShowAttachmentFactbox;
    end;

    trigger OnNewRecord(BelowxRec: Boolean)
    begin
        LoadFixedRealEstateRentInfo();
        Visible2Arrendador := true;
        ShowAttachmentFactbox := false;
        ShowAttachmentActions := false;
    end;

    trigger OnInsertRecord(BelowxRec: Boolean): Boolean
    begin
        Visible2Arrendador := true;
        exit(true);
    end;

    var
        FixedRealEstate: Record "Fixed Real Estate";
        RealEstateMangement: Codeunit "Real Estate Management";
        CurrentContractAmount: Decimal;
        LastRentalPrice: Decimal;
        ReferencePriceMin: Decimal;
        ReferencePriceMax: Decimal;
        ShowAttachmentFactbox: Boolean;
        ShowAttachmentActions: Boolean;
        ShowMapLbl: Label 'Show on Map';
        BailDescription: Text;
        Visible2Arrendador: Boolean;
        Obligar2Arrendador: Boolean;
        ContractValidationOkMsg: Label 'El contrato %1 no presenta deficiencias de información en la comprobación actual.';

    local procedure LoadFixedRealEstateRentInfo()
    begin
        Clear(CurrentContractAmount);
        Clear(LastRentalPrice);
        Clear(ReferencePriceMin);
        Clear(ReferencePriceMax);

        if Rec."Fixed Real Estate No." = '' then
            exit;

        if not FixedRealEstate.Get(Rec."Fixed Real Estate No.") then
            exit;

        FixedRealEstate.CalcFields("Last Price Contract", "Last Reference Price Min.", "Last Reference Price Max.");
        CurrentContractAmount := FixedRealEstate."Last Price Contract";
        LastRentalPrice := FixedRealEstate."Last Rental Price";
        ReferencePriceMin := FixedRealEstate."Last Reference Price Min.";
        ReferencePriceMax := FixedRealEstate."Last Reference Price Max.";
    end;

    local procedure CustomerNoOnAfterValidate()
    begin
        // CurrPage.UPDATE;
    end;

    local procedure IsRecordPersisted(): Boolean
    var
        LeaseContract: Record "Lease Contract";
    begin
        if Rec."Contract No." = '' then
            exit(false);

        LeaseContract.SetRange("Contract No.", Rec."Contract No.");
        exit(LeaseContract.FindFirst());
    end;

    local procedure GetAttachmentRecRef(var RecRef: RecordRef)
    var
        LeaseContract: Record "Lease Contract";
    begin
        CurrPage.SAVERECORD;

        if Rec."Contract No." = '' then
            Error('The contract must be saved before attaching files.');

        LeaseContract.Get(Rec."Contract No.");
        RecRef.GetTable(LeaseContract);
    end;
}

