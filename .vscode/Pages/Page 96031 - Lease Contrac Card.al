page 96031 "Lease Contract Card"
{
    PageType = Card;
    SourceTable = "Lease Contract";
    Caption = 'Lease Contract';

    layout
    {
        area(content)
        {
            part(SumaryLeaseContract; 96053)
            {
                ApplicationArea = All;
                SubPageLink = "Contract No." = field("Contract No.");

            }            
            group(General)
            {
                field("Contract No."; rec."Contract No.")
                {
                    ApplicationArea = All;
                }
                field(Description; rec.Description)
                {
                    ApplicationArea = All;
                }
                group("Activo inmobiliario")
                {
                    Caption = 'Activo inmobiliario';
                    field("Fixed Real Estate No."; rec."Fixed Real Estate No.")
                    {
                        ApplicationArea = All;
                    }
                    field("Description Fixed Real Estate"; rec."Description Fixed Real Estate")
                    {
                        Caption = 'Descripción activo inmobiliario';
                        ApplicationArea = All;
                    }
                }
                group("Activo inmobiliario 2")
                {
                    Caption = 'Estado';
                    field("Salesperson Code"; rec."Salesperson Code")
                    {
                        ApplicationArea = All;
                        ToolTip = 'Specifies the code of the salesperson assigned to this service contract.';
                    }
                    field(Status; rec.Status)
                    {
                        ApplicationArea = All;
                        Importance = Promoted;
                        Editable = false;
                        ToolTip = 'Specifies the status of the service contract or contract quote.';
                    }
                }
                group("Activo inmobiliario 3")
                {
                    Caption = 'Dirección';
                    field("Types Street Numbering Id."; rec."Types Street Numbering Id.")
                    {
                        ApplicationArea = All;
                    }
                    field("Street Name"; rec."Street Name")
                    {
                        ApplicationArea = All;
                    }
                    field("Number On Street"; rec."Number On Street")
                    {
                        ApplicationArea = All;
                    }
                    field("Location Height Floor"; rec."Location Height Floor")
                    {
                        ApplicationArea = All;
                    }
                    field("FRE Address"; rec."FRE Address")
                    {
                        ApplicationArea = All;
                    }
                    field("FRE City"; rec."FRE City")
                    {
                        ApplicationArea = All;
                        ToolTip = 'Specifies the customer''s city.';
                    }
                    field("FRE County"; rec."FRE County")
                    {
                        ApplicationArea = All;
                        ToolTip = 'Specifies the state, province or county as a part of the address.';
                    }
                    field("FRE Post Code"; rec."FRE Post Code")
                    {
                        ApplicationArea = All;
                        Importance = Promoted;
                        ToolTip = 'Specifies the postal code.';
                    }
                    field("FRE Country/Region Code"; rec."FRE Country/Region Code")
                    {
                        ApplicationArea = All;
                        ToolTip = 'Specifies the country/region of the address.';
                    }
                    field(ShowMap; ShowMapLbl)
                    {
                        ApplicationArea = All;
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
                        ApplicationArea = All;
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
                        ApplicationArea = All;
                        Importance = Promoted;
                        ToolTip = 'Specifies the number of the customer who owns the service items in the service contract/contract quote.';

                        trigger OnValidate()
                        begin
                            CustomerNoOnAfterValidate;
                        end;
                    }
                    field("Contact No."; rec."Contact No.")
                    {
                        ApplicationArea = All;
                        ToolTip = 'Specifies the number of the contact who will receive the service delivery.';
                    }
                    field(Name; rec.Name)
                    {
                        ApplicationArea = All;
                        DrillDown = false;
                        ToolTip = 'Specifies the name of the customer in the service contract.';
                    }
                    field(Address; rec.Address)
                    {
                        ApplicationArea = All;
                        DrillDown = false;
                        ToolTip = 'Specifies the customer''s address.';
                    }
                    field("Address 2"; rec."Address 2")
                    {
                        ApplicationArea = All;
                        DrillDown = false;
                        ToolTip = 'Specifies additional address information.';
                    }
                    field(City; rec.City)
                    {
                        ApplicationArea = All;
                        DrillDown = false;
                        ToolTip = 'Specifies the name of the city in where the customer is located.';
                    }
                    field(County; rec.County)
                    {
                        ApplicationArea = All;
                    }
                    field("Post Code"; rec."Post Code")
                    {
                        ApplicationArea = All;
                        DrillDown = false;
                        ToolTip = 'Specifies the postal code.';
                    }
                    field("Country/Region Code"; rec."Country/Region Code")
                    {
                        ApplicationArea = All;
                    }
                    field("Contact Name"; rec."Contact Name")
                    {
                        ApplicationArea = All;
                        DrillDown = false;
                        ToolTip = 'Specifies the name of the person you regularly contact when you do business with the customer in this service contract.';
                    }
                    field("Phone No."; rec."Phone No.")
                    {
                        ApplicationArea = All;
                        ToolTip = 'Specifies the customer phone number.';
                    }
                    field("E-Mail"; rec."E-Mail")
                    {
                        ApplicationArea = All;
                        ExtendedDatatype = EMail;
                        ToolTip = 'Specifies the customer''s email address.';
                    }
                    field("Notify Customer"; rec."Notify Customer")
                    {
                        ApplicationArea = All;
                    }
                }
                group("2o. arrendador")
                {
                    Caption = '2o. arrendador';
                    Visible = Visible2Arrendador;

                    field("Second Customer No."; rec."Second Customer No.")
                    {
                        ApplicationArea = All;
                        Importance = Promoted;
                        ToolTip = 'Specifies the number of the customer who owns the service items in the service contract/contract quote.';

                        trigger OnValidate()
                        begin
                            CustomerNoOnAfterValidate;
                        end;
                    }
                    field("Second Contact No."; rec."Second Contact No.")
                    {
                        ApplicationArea = All;
                        ToolTip = 'Specifies the number of the contact who will receive the service delivery.';
                    }
                    field("Second Name"; rec."Second Name")
                    {
                        ApplicationArea = All;
                        DrillDown = false;
                        ToolTip = 'Specifies the name of the customer in the service contract.';
                    }
                    field("Second Address"; rec."Second Address")
                    {
                        ApplicationArea = All;
                        DrillDown = false;
                        ToolTip = 'Specifies the customer''s address.';
                    }
                    field("Second Address 2"; rec."Second Address 2")
                    {
                        ApplicationArea = All;
                        DrillDown = false;
                        ToolTip = 'Specifies additional address information.';
                    }
                    field("Second City"; rec."Second City")
                    {
                        ApplicationArea = All;
                        DrillDown = false;
                        ToolTip = 'Specifies the name of the city in where the customer is located.';
                    }
                    field("Second County"; rec."Second County")
                    {
                        ApplicationArea = All;
                    }
                    field("Second Post Code"; rec."Second Post Code")
                    {
                        ApplicationArea = All;
                        DrillDown = false;
                        ToolTip = 'Specifies the postal code.';
                    }
                    field("Second Country/Region Code"; rec."Second Country/Region Code")
                    {
                        ApplicationArea = All;
                    }
                    field("Second Name 2"; rec."Second Name 2")
                    {
                        ApplicationArea = All;
                        DrillDown = false;
                        ToolTip = 'Specifies the name of the person you regularly contact when you do business with the customer in this service contract.';
                    }
                    field("Phone No. 2"; rec."Phone No. 2")
                    {
                        ApplicationArea = All;
                        ToolTip = 'Specifies the customer phone number.';
                    }
                    field("E-Mail 2"; rec."E-Mail 2")
                    {
                        ApplicationArea = All;
                        ExtendedDatatype = EMail;
                        ToolTip = 'Specifies the customer''s email address.';
                    }
                    field("Notify Customer 2"; rec."Notify Customer 2")
                    {
                        ApplicationArea = All;
                    }
                }
            }
            group(Alquiler)
            {
                field("Invoice Period"; rec."Invoice Period")
                {
                    ApplicationArea = All;
                }
                field("Contract Date"; rec."Contract Date")
                {
                    ApplicationArea = All;
                }
                field("Starting Date"; rec."Starting Date")
                {
                    ApplicationArea = All;
                }
                field("Lease Period"; rec."Lease Period")
                {
                    ApplicationArea = All;
                }
                field("Expiration Date"; rec."Expiration Date")
                {
                    ApplicationArea = All;
                }
                field("Payment Method Code"; rec."Payment Method Code")
                {
                    ApplicationArea = All;
                }
                field("Payment Terms Code"; rec."Payment Terms Code")
                {
                    ApplicationArea = All;
                }
                field("Grupo IRPF";Rec."Grupo IRPF")
                {
                    ApplicationArea = All;
                }
                group("Detalle Factura")
                {
                    field("Amount per Period"; rec."Amount per Period")
                    {
                        Editable = true;
                        ApplicationArea = All;
                    }
                    field("Lease Manag. Amount per Period"; rec."Lease Manag. Amount per Period")
                    {
                        ApplicationArea = All;
                    }
                    field("Prices Services Including VAT"; rec."Prices Services Including VAT")
                    {
                        ApplicationArea = All;
                    }
                    field("Generic Prod. Posting Gr.";Rec."Generic Prod. Posting Gr.")
                    {
                        ApplicationArea = All;
                    }
                    field("Customer Template Code"; rec."Customer Template Code")
                    {
                        ApplicationArea = All;
                    }
                }
                group(Fianzas)
                {
                    Caption = 'Fianzas';
                    field(BailDescription; BailDescription)
                    {
                        ApplicationArea = All;
                        Importance = Standard;
                        MultiLine = true;
                        ShowCaption = false;
                        ToolTip = 'Specifies the products or service being offered';

                        trigger OnValidate()
                        begin
                            rec.SetBailDescription(BailDescription);
                        end;
                    }
                    field("Consumer Price Index Category";Rec."Consumer Price Index Category")
                    {
                        ApplicationArea = All;
                    }
                }
            }
            part(LeaseContractLines; 96032)
            {
                ApplicationArea = All;
                SubPageLink = "Contract No."=FIELD("Contract No.");
            }
            group(Pagos)
            {
                Caption = 'Pagos';
                field("Preferred Bank Account Code"; rec."Preferred Bank Account Code")
                {
                    ApplicationArea = All;
                }
            }
        }
        area(factboxes)
        {
            part(LiquidacionFactBox; "Liquidacion Contrato FactBox")
            {
                ApplicationArea = All;
                Caption = 'Liquidación';
                UpdatePropagation = Both;
                SubPageLink = "Contract No." = field("Contract No.");
            }
            part("Attached Documents List"; "Doc. Attachment List Factbox")
            {
                ApplicationArea = All;
                Caption = 'Documents';
                UpdatePropagation = Both;
                SubPageLink = "Table ID" = const(Database::"Lease Contract"),
                            "No." = field("Contract No.");
            }
        }
    }

    actions
    {
        area(navigation)
        {
            action("Filed Contracts")
            {
                ApplicationArea = All;
                Caption = 'Filed Contracts';
                Image = Agreement;
                RunObject = Page 6073;
                Promoted = true;
                RunPageLink = "Contract No. Relation"=FIELD("Contract No.");
                RunPageView = SORTING("Entry No.")
                              ORDER(Descending);
                ToolTip = 'View service contracts that are filed.';
            }
            action("Co&mments")
            {
                ApplicationArea = All;
                Caption = 'Co&mments';
                Image = ViewComments;
                Promoted = true;
                RunObject = Page 96033;
                RunPageLink = "Table Name"=CONST("Lease Contract"),
                              "No."=FIELD("Contract No."),
                              "Table Line No."=CONST(0);
                            ToolTip = 'View or add comments for the record.';
            }
            action("Rentals Deposit")
            {
                ApplicationArea = All;
                Caption = 'Rentals Deposit';
                Image = Prepayment;
                RunObject = Page 96054;
                RunPageLink = "Contract No."=FIELD("Contract No.");
                ToolTip = 'View and manage rental deposits for this lease contract.';
            }
            action("&Gain/Loss Entries")
            {
                ApplicationArea = All;
                Caption = '&Gain/Loss Entries';
                Image = GainLossEntries;
                RunObject = Page 6064;
                                RunPageLink = "Contract No."=FIELD("Contract No.");
                RunPageView = SORTING("Contract No.","Change Date")
                              ORDER(Descending);
                ToolTip = 'View the contract number, reason code, contract group code, responsibility center, customer number, ship-to code, customer name, and type of change, as well as the contract gain and loss. You can print all your service contract gain/loss entries.';
            }
            action("Related Contats")
            {
                ApplicationArea = All;
                Caption = 'Related Contats';
                Image = ContactReference;
                Promoted = true;
                RunObject = Page 96013;
                RunPageLink = "Entity Type"=CONST(Contract),
                              "Source No."=FIELD("Contract No.");
            }
            action(Attachments)
            {
                ApplicationArea = All;
                Caption = 'Attachments';
                Promoted = true;
                Image = Attach;
                ToolTip = 'Add a file as an attachment. You can attach images as well as documents.';

                trigger OnAction()
                var
                    DocumentAttachmentDetails: Page "Document Attachment Details";
                    RecRef: RecordRef;
                begin
                    RecRef.GETTABLE(Rec);
                    DocumentAttachmentDetails.OpenForRecRef(RecRef);
                    DocumentAttachmentDetails.RUNMODAL;
                end;
            }
            group(History)
            {
                Caption = 'History';
                action(PagePostedLeaseInvoiceLines)
                {
                    ApplicationArea = All;
                    Caption = 'Posted Lease Invoice Lines';
                    Image = PostDocument;
                    Promoted = true;
                    //The property 'PromotedCategory' can only be set if the property 'Promoted' is set to 'true'
                    //PromotedCategory = New;
                    ShortCutKey = 'Ctrl+F7';
                    ToolTip = 'View a list of posted lease invoice lines related to this document.';
                    RunObject = Page 96057;
                    RunPageLink = "Contract No." = FIELD("Contract No.");
                }
            }
        }
        area(processing)
        {
            group(Sign)
            {
                Caption = 'Sign';
                action(SignContract)
                {
                    ApplicationArea = All;
                    Caption = 'Si&gn Contract';
                    Image = Signature;
                    Promoted = true;
                    PromotedCategory = Process;
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
                    ApplicationArea = All;
                    Caption = '&Cancel Contract';
                    Image = Lock;
                    Promoted = true;
                    PromotedCategory = Process;
                    ToolTip = 'Make sure that the changes will be part of the contract.';

                    trigger OnAction()
                    begin
                        CurrPage.UPDATE;
                        RealEstateMangement.CancelContract(Rec);
                        CurrPage.UPDATE
                    end;
                }            
            }
            action(LiquidarContrato)
            {
                Caption = 'Liquidar contrato';
                Image = Close;
                ToolTip = 'Cierra definitivamente el contrato y realiza la liquidación final.';
                Enabled = Rec.Status = Rec.Status::Signed;
                ApplicationArea = All;

                trigger OnAction()
                var
                    LiquidacionContrato: Record "Liquidacion Contrato Header";
                    Wizard: Page "Liquidacion Contrato Card";
                begin
                    // Confirmación explícita (buena práctica)
                    if not Confirm(
                        'Esta acción cerrará definitivamente el contrato.\' +
                        '¿Desea continuar?',
                        false)
                    then
                        exit;
                    if not LiquidacionContrato.Get(rec."Contract No.") then begin
                        LiquidacionContrato."Contract No." := rec."Contract No.";
                        if LiquidacionContrato.Insert() then ;
                    end;
                    commit;
                    // Lanza el asistente de liquidación
                    Wizard.SetContrato(Rec."Contract No.");
                    Wizard.RunModal();

                    // Refresca la página tras la liquidación
                    CurrPage.Update();
                end;
            }

            group("F&unctions")
            {
                Caption = 'F&unctions';
                Image = "Action";

                action("Create &Interaction")
                {
                    ApplicationArea = RelationshipMgmt;
                    Caption = 'Create &Interaction';
                    Image = CreateInteraction;
                    promoted = true;
                    ToolTip = 'Create an interaction with a specified contact.';

                    trigger OnAction()
                    var
                        SegmentLine: Record "Segment Line" temporary;
                    begin
                        SegmentLine.CreateInteractionFromLeaseContract(Rec);
                    end;
                }
            }
        }
        area(reporting)
        {
            action("&Print")
            {
                ApplicationArea = All;
                Caption = '&Print';
                Ellipsis = true;
                Image = Print;
                Promoted = true;
                PromotedCategory = Process;
                ToolTip = 'Prepare to print the document. A report request window for the document opens where you can specify what to include on the print-out.';

                trigger OnAction()
                var
                    LeaseContract: Record "Lease Contract";
                begin

                    LeaseContract.RESET;
                    LeaseContract.SETRANGE("Contract No.",rec."Contract No.");
                    REPORT.RUNMODAL(96005,TRUE,TRUE,LeaseContract);
                    CurrPage.UPDATE;
                end;
            }
        }
    }

    trigger OnAfterGetCurrRecord()
    begin
        BailDescription := rec.GetBailDescription;
        Visible2Arrendador := rec."Second Name" <> '';
    end;
    trigger OnNewRecord(BelowxRec: Boolean)
    begin
        Visible2Arrendador := true;
    end;
    trigger OnInsertRecord(BelowxRec: Boolean): Boolean
    begin
        Visible2Arrendador := true;
        exit(true);
    end;

    var
        RealEstateMangement: Codeunit "Real Estate Management";
        ShowMapLbl: Label 'Show on Map';
        BailDescription: Text;
        Visible2Arrendador: Boolean;

    local procedure CustomerNoOnAfterValidate()
    begin
        // CurrPage.UPDATE;
    end;
}

