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
            group(General)
            {
                Caption = 'General';
                field(Type; rec.Type)
                {
                    ApplicationArea = All;

                    trigger OnValidate()
                    begin
                        UpdatesNoFieldVisible()
                    end;
                }
                field("Property No."; rec."Property No.")
                {
                    Editable = VisiblePropertyNo;
                    ApplicationArea = All;
                }
                field("Property Description"; rec."Property Description")
                {
                    Editable = false;
                    applicationArea = All;
                }
                field("No."; rec."No.")
                {
                    ApplicationArea = All;
                    Importance = Additional;
                    ToolTip = 'Specifies the number of the involved entry or record, according to the specified number series.';

                    trigger OnAssistEdit()
                    begin
                    end;

                    trigger OnValidate()
                    begin
                        ShowAcquireNotification
                    end;
                }
                field(Description; rec.Description)
                {
                    ApplicationArea = All;
                    Importance = Promoted;
                    ShowMandatory = true;
                    ToolTip = 'Specifies a description of the fixed asset.';

                    trigger OnValidate()
                    begin
                        ShowAcquireNotification
                    end;
                }
                field("Phone No."; rec."Phone No.")
                {
                    ApplicationArea = Service;
                    ToolTip = 'Specifies the customer phone number.';
                }
                field(Status; rec.Status)
                {
                    ApplicationArea = All;
                    Importance = Promoted;
                    ToolTip = 'Specifies the status of the fixed asset.';
                }
                group("Clasificación")
                {
                    Caption = 'Clasificación';
                    field("FRE Class Code"; rec."FRE Class Code")
                    {
                        ApplicationArea = All;
                        Caption = 'Class Code';
                        Importance = Promoted;
                        ToolTip = 'Specifies the class that the fixed asset belongs to.';
                    }
                    field("FRE Subclass Code"; rec."FRE Subclass Code")
                    {
                        ApplicationArea = All;
                        Caption = 'Subclass Code';
                        Importance = Promoted;
                        ShowMandatory = true;
                        ToolTip = 'Specifies the subclass of the class that the fixed asset belongs to.';

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
                            ShowAcquireNotification;
                        end;
                    }
                }
                field("Cadastral reference"; rec."Cadastral reference")
                {
                    ApplicationArea = All;
                    Importance = Promoted;
                    ToolTip = 'Specifies the fixed asset''s serial number.';
                }
                field("Search Description"; rec."Search Description")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies a search description for the fixed asset.';
                }
                field("Responsible Employee"; rec."Responsible Employee")
                {
                    ApplicationArea = All;
                    Importance = Promoted;
                    ToolTip = 'Specifies which employee is responsible for the fixed asset.';
                }
                field(Blocked; rec.Blocked)
                {
                    ApplicationArea = All;
                    Importance = Additional;
                    ToolTip = 'Specifies that the related record is blocked from being posted in transactions, for example a customer that is declared insolvent or an item that is placed in quarantine.';
                }
                field(Acquired; rec.Acquired)
                {
                    ApplicationArea = All;
                    Importance = Additional;
                    ToolTip = 'Specifies if the fixed asset has been acquired.';
                }
                field(Managed; rec.Managed)
                {
                }
                field("Last Date Modified"; rec."Last Date Modified")
                {
                    ApplicationArea = All;
                    Importance = Additional;
                    ToolTip = 'Specifies when the fixed asset card was last modified.';
                }
                field(Totaling; rec.Totaling)
                {
                    Visible = VisiblePropertyNo;
                }
            }
            group(Maintenance2)
            {
                Caption = 'Maintenance';
                group(AddressDetails)
                {
                    Caption = 'Address';
                    field(Address; rec.Address)
                    {
                        ApplicationArea = Basic, Suite;
                        ToolTip = 'Specifies the customer''s address. This address will appear on all sales documents for the customer.';
                    }
                    field("Address 2"; rec."Address 2")
                    {
                        ApplicationArea = Basic, Suite;
                        ToolTip = 'Specifies additional address information.';
                    }
                    field(City; rec.City)
                    {
                        ApplicationArea = Basic, Suite;
                        ToolTip = 'Specifies the customer''s city.';
                    }
                    field(County; rec.County)
                    {
                        ApplicationArea = Basic, Suite;
                        ToolTip = 'Specifies the state, province or county as a part of the address.';
                    }
                    field("Post Code"; rec."Post Code")
                    {
                        ApplicationArea = Basic, Suite;
                        Importance = Promoted;
                        ToolTip = 'Specifies the postal code.';
                    }
                    field("Country/Region Code"; rec."Country/Region Code")
                    {
                        ApplicationArea = Basic, Suite;
                        ToolTip = 'Specifies the country/region of the address.';
                    }
                    field(ShowMap; ShowMapLbl)
                    {
                        ApplicationArea = Basic, Suite;
                        Editable = false;
                        ShowCaption = false;
                        Style = StrongAccent;
                        StyleExpr = TRUE;
                        ToolTip = 'Specifies the customer''s address on your preferred map website.';

                        trigger OnDrillDown()
                        begin
                            CurrPage.UPDATE(TRUE);
                            rec.DisplayMap;
                        end;
                    }
                    field("Google URL"; rec."Google URL")
                    {
                        ApplicationArea = All;
                    }
                }
                group("Construcción")
                {
                    Caption = 'Construcción';
                    field("Year of construction"; rec."Year of construction")
                    {
                        ApplicationArea = All;
                    }
                    field("Superficie construida"; rec."Superficie construida")
                    {
                        ApplicationArea = All;
                    }
                    field(ShowURL; ShowURLLbl)
                    {
                        ApplicationArea = Basic, Suite;
                        Editable = false;
                        ShowCaption = false;
                        Style = StrongAccent;
                        StyleExpr = TRUE;
                        ToolTip = 'Specifies the customer''s address on your preferred map website.';

                        trigger OnDrillDown()
                        begin
                            CurrPage.UPDATE(TRUE);
                            HYPERLINK(rec."URL Sede electrónica catastro");
                        end;
                    }
                    field("URL Sede electrónica catastro"; rec."URL Sede electrónica catastro")
                    {
                        ApplicationArea = All;
                    }
                }
            }
            group(Precios)
            {
                Caption = 'Precios';
                Visible = VisiblePropertyNo;
                field("Sales price"; rec."Sales price")
                {
                    ApplicationArea = All;
                }
                field("Minimum Sales Price"; rec."Minimum Sales Price")
                {
                    ApplicationArea = All;
                }
                field("Rental Price"; rec."Rental Price")
                {
                    ApplicationArea = All;
                }
                field("Minimum Rental Price"; rec."Minimum Rental Price")
                {
                    ApplicationArea = All;
                }
                group("Descripción comercial")
                {
                    Caption = 'Descripción comercial';
                    //The GridLayout property is only supported on controls of type Grid
                    //GridLayout = Columns;
                    Visible = VisiblePropertyNo;
                    field(FAEDescription; FAEDescription)
                    {
                        ApplicationArea = Basic, Suite;
                        Importance = Additional;
                        MultiLine = true;
                        ShowCaption = false;
                        ToolTip = 'Specifies the products or service being offered.';

                        trigger OnValidate()
                        begin
                            rec.SetFREDescription(FAEDescription);
                        end;
                    }
                }
            }
            part(Lines; 96010)
            {
                ApplicationArea = Basic, Suite;
                SubPageLink = "No. Fixed Real Estate" = FIELD("No.");
                UpdatePropagation = Both;
                Visible = VisiblePropertyNo;
                }
                group(Maintenance)
                {
                    Caption = 'Maintenance';
                    field("Vendor No."; rec."Vendor No.")
                    {
                        ApplicationArea = All;
                        Importance = Promoted;
                        ToolTip = 'Specifies the number of the vendor from which you purchased this fixed asset.';
                    }
                    field("Maintenance Vendor No."; rec."Maintenance Vendor No.")
                    {
                        ApplicationArea = All;
                        Importance = Promoted;
                        ToolTip = 'Specifies the number of the vendor who performs repairs and maintenance on the fixed asset.';
                    }
                    field("Under Maintenance"; rec."Under Maintenance")
                    {
                        ApplicationArea = All;
                        ToolTip = 'Specifies if the fixed asset is currently being repaired.';
                    }
                    field(Insured; rec.Insured)
                    {
                        ApplicationArea = All;
                        ToolTip = 'Specifies that the fixed asset is linked to an insurance policy.';
                    }
                }
            }
        area(factboxes)
        {

            part("Attached Documents"; "Doc. Attachment List Factbox")
            {
                ApplicationArea = All;
                Caption = 'Attachments';
                SubPageLink = "Table ID"=CONST(5600),
                              "No."=FIELD("No.");
            }
            systempart("Links"; Links)
            {
                ApplicationArea = All;
                Visible = false;
            }
            systempart("Notes"; Notes)
            {
                ApplicationArea = All;
            }
            part(FixedREAttributesFactbox; 96003)
            {
                ApplicationArea = aLL;
                Visible = false;
            }
        }
    }

    actions
    {
        area(navigation)
        {
            action(Attributes)
            {
                AccessByPermission = TableData 7500 = R;
                ApplicationArea = Basic, Suite;
                Caption = 'Attributes';
                Image = Category;
                Promoted = false;
                //The property 'PromotedOnly' can only be set if the property 'Promoted' is set to 'true'
                //PromotedOnly = false;
                ToolTip = 'View or edit the item''s attributes, such as color, size, or other characteristics that help to describe the item.';

                trigger OnAction()
                begin
                    PAGE.RUNMODAL(PAGE::"Fixed RE Attribute Value Edit.", Rec);
                    CurrPage.SAVERECORD;
                    CurrPage.FixedREAttributesFactbox.PAGE.LoadItemAttributesData(rec."No.");
                end;
            }
            action(Statistics)
            {
                ApplicationArea = All;
                Caption = 'Statistics';
                Image = Statistics;
                Promoted = true;
                RunObject = Page "Fixed RE Statistics";
                RunPageLink = "No."=FIELD("No.");
                ShortCutKey = 'F7';
                ToolTip = 'View detailed historical information about the fixed asset.';
            }
            action(Dimensions)
            {
                ApplicationArea = Dimensions;
                Caption = 'Dimensions';
                Image = Dimensions;
                RunObject = Page 540;
                            RunPageLink = "Table ID"=CONST(96000),
                            "No."=FIELD("No.");
                ShortCutKey = 'Shift+Ctrl+D';
                ToolTip = 'View or edit dimensions, such as area, project, or department, that you can assign to sales and purchase documents to distribute costs and analyze transaction history.';
            }
            action("Maintenance &Registration")
            {
                ApplicationArea = All;
                Caption = 'Maintenance &Registration';
                Image = MaintenanceRegistrations;
                RunObject = Page 96016;
                        RunPageLink = "FRE No."=FIELD("No.");
                ToolTip = 'View or edit maintenance codes for the various types of maintenance, repairs, and services performed on your fixed assets. You can then enter the code in the Maintenance Code field on journals.';
            }
            action("Co&mments")
            {
                ApplicationArea = Comments;
                Caption = 'Co&mments';
                Image = ViewComments;
                RunObject = Page 96008;
                //RunPageLink = "Table Name"=CONST('Fixed Real Estate'),
                //            "No."=FIELD("No.");
                ToolTip = 'View or add comments for the record.';
            }
            action(Incidents)
            {
                ApplicationArea = All;
                Caption = 'Incidents';
                Image = Interaction;
                Promoted = true;
                RunObject = Page "RE Incident Mobile";
                RunPageLink = "Fixed Real Estate No."=FIELD("No.");
                ToolTip = 'View service request cases associated with this fixed real estate.';
            }
            action("Related Contats")
            {
                ApplicationArea = All;
                Caption = 'Related Contats';
                Image = ContactReference;
                RunObject = Page "REF Related Contactos";
                RunPageLink = "Entity Type"=CONST("Fixed Real Estate"),
                            "Source No."=FIELD("No.");
            }
            action("Precios Indices de referencia")
            {
                Caption = 'Precios Indices de referencia';
                Image = PriceWorksheet;
                RunObject = Page "Reference Index Rental Prices";
                RunPageLink = "Fixed Real Estate No."=FIELD("No.");
                RunPageView = SORTING("Fixed Real Estate No.","Line No.");
            }
            action("Equipamientos")
            {
                Caption = 'Equipamientos';
                Image = FixedAssets;
                RunObject = Page "FRE Equipments";
                RunPageLink = "FRE No."=FIELD("No.");
                RunPageView = SORTING("FRE No.","Line No.");
            }
            action(Attachments)
            {
                ApplicationArea = All;
                Caption = 'Attachments';
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
            action(Contratos)
            {
                Image = ContractPayment;
                RunObject = Page "Lease Contract List";
                Promoted = true;
                RunPageLink = "Fixed Real Estate No." = FIELD("No.");
                RunPageView = SORTING("Contract No.")
                              WHERE(Status=CONST(Signed));
            }
            action("FacturasAlquiler")
            {
                ApplicationArea = All;
                Caption = 'Facturas alquiler';
                Image = Invoice;
                RunObject = Page "Posted Lease Invoices";
                RunPageLink = "Fixed Real Estate No."=FIELD("No.");
                ToolTip = 'View the posted lease invoices';
                Promoted = true;
            }
            action(Avatar)
            {
                Image = Picture;
                RunObject = Page "Fixed Real Estate Avatar";
                RunPageLink = "No."=FIELD("No.");
            }
        }
        area(processing)
        {
            action("Calculate Totaling")
            {
                ApplicationArea = All;
                Caption = 'Calcular sumatorio';
                Image = CalculateLines;

                trigger OnAction()
                begin
                    rec.CalculateTotaling;
                end;
            }
            action(Publish)
            {
                ApplicationArea = Basic,Suite;
                Caption = 'Publish';
                Image = ExportFile;
                ToolTip = 'Export a file with the payment information on the lines.';

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
                ApplicationArea = All;
                Caption = 'G/L Analysis';
                Image = "Report";
                //RunObject = Report 5610;
                //ToolTip = 'View an analysis of your fixed assets with various types of data for individual fixed assets and/or groups of fixed assets.';
            }
            action(Etiqueta)
            {
                Image = "Report";

                trigger OnAction()
                var
                    FixedRealEstate: Record "Fixed Real Estate";
                begin
                    FixedRealEstate.RESET;
                    FixedRealEstate.SETRANGE("No.",rec."No.");
                    REPORT.RUN(96007,TRUE,TRUE,FixedRealEstate);
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

        FAEDescription := rec.GetFREDescription;
    end;

    trigger OnNewRecord(BelowxRec: Boolean)
    begin
        CurrPage.UPDATE(FALSE);
    end;

    trigger OnOpenPage()
    begin
        Simple := TRUE;
        SetNoFieldVisible;
    end;

    var
        FAAcquireWizardNotificationId: Guid;
        Simple: Boolean;
        Acquirable: Boolean;
        FAEDescription: Text;
        ShowMapLbl: Label 'Show on Map';
        VisiblePropertyNo: Boolean;
        ShowURLLbl: Label 'Show on URL';

    local procedure ShowAcquireNotification()
    var
        ShowAcquireNotification: Boolean;
    begin
        ShowAcquireNotification :=
          (NOT rec.Acquired) AND rec.FieldsForAcquitionInGeneralGroupAreCompleted;
        IF ShowAcquireNotification AND ISNULLGUID(FAAcquireWizardNotificationId) THEN BEGIN
          Acquirable := TRUE;
          rec.ShowAcquireWizardNotification;
        END;
    end;

    local procedure SetDefaultPostingGroup()
    var
        FASubclass: Record "FA Subclass";
    begin
        IF FASubclass.GET(rec."FRE Subclass Code") THEN;
    end;

    local procedure SetNoFieldVisible()
    begin
        VisiblePropertyNo := FALSE;
    end;

    local procedure UpdatesNoFieldVisible()
    var
    begin
        VisiblePropertyNo := (rec.Type <> rec.Type::Propiedad);
    end;
}

