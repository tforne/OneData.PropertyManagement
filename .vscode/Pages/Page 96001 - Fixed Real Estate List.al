page 96001 "Fixed Real Estate List"
{
    Caption = 'Fixeds Real Estate';
    CardPageID = "Fixed Real Estate Card";
    PageType = List;
    PopulateAllFields = true;
    SourceTable = "Fixed Real Estate";
    SourceTableView = SORTING("Property Description", "Property No.", Type, Description);
    UsageCategory = Lists;
    ApplicationArea = All;


    layout
    {
        area(content)
        {
            usercontrol(ClipboardHelper; "OD Clipboard Helper")
            {
                ApplicationArea = All;
                Visible = false;

                trigger CopyFailed(ErrorText: Text)
                begin
                    Message(CopyToClipboardErr, ErrorText);
                end;
            }

            repeater(Group)
            {
                FreezeColumn = Description;
                field("No."; rec."No.")
                {
                    Style = Strong;
                    StyleExpr = StyleIsStrong;
                    ToolTip = 'Specifies the number of the involved entry or record, according to the specified number series.';
                    Visible = false;
                }
                field(Type; rec.Type)
                {
                    ColumnSpan = 2;
                    Style = Strong;
                    StyleExpr = StyleIsStrong;
                }
                field(Description; rec.Description)
                {
                    Style = Strong;
                    StyleExpr = StyleIsStrong;
                    ToolTip = 'Specifies a description of the real estate asset.';
                }
                field("Post Code"; rec."Post Code")
                {
                    Style = Strong;
                    StyleExpr = StyleIsStrong;
                }
                field(City; rec.City)
                {

                }
                field("Vendor No."; rec."Vendor No.")
                {
                    ToolTip = 'Specifies the number of the vendor from which you purchased this real estate asset.';
                    Visible = false;
                }
                field("Maintenance Vendor No."; rec."Maintenance Vendor No.")
                {
                    ToolTip = 'Specifies the number of the vendor who performs repairs and maintenance on the real estate asset.';
                    Visible = false;
                }
                field("Responsible Employee"; rec."Responsible Employee")
                {
                    ToolTip = 'Specifies which employee is responsible for the real estate asset.';
                }
                field("Cadastral reference"; rec."Cadastral reference")
                {
                    ToolTip = 'Specifies the cadastral reference of the real estate asset, which is a unique code that identifies the property in the land registry.';
                }
                field(Status; rec.Status)
                {
                    Style = Attention;
                    StyleExpr = StatusStyleIsStrong;
                }
                field(Acquired; rec.Acquired)
                {
                    ToolTip = 'Specifies that the real estate asset has been acquired.';
                }
                field(Managed; rec.Managed)
                {
                }
                field("Val. Catastral Activo"; rec."Val. Catastral Activo")
                {
                    Style = Strong;
                    StyleExpr = StyleIsStrong;
                    BlankZero = true;
                }
                field("Val. Castastral Const. Activo"; rec."Val. Castastral Const. Activo")
                {
                    Style = Strong;
                    StyleExpr = StyleIsStrong;
                    BlankZero = true;
                }
                field("Val. Castastral Actua. Activo"; rec."Val. Castastral Actua. Activo")
                {
                    BlankZero = true;
                }
                field("Sales price"; rec."Sales price")
                {
                    Style = Strong;
                    StyleExpr = StyleIsStrong;
                    Caption = 'Sale Price';
                    ToolTip = 'Specifies the sale price of the real estate asset.';
                }
                field("Minimum Sales Price"; rec."Minimum Sales Price")
                {
                    BlankZero = true;
                    Style = Strong;
                    StyleExpr = StyleIsStrong;

                    Caption = 'Minimum Sale Price';
                    ToolTip = 'Specifies the minimum sale price of the real estate asset.';
                }
                field("Minimum Rental Sales Price"; rec."Minimum Rental Price")
                {
                    BlankZero = true;
                    Style = Strong;
                    StyleExpr = StyleIsStrong;
                    Caption = 'Minimum Rental Sale Price';
                    ToolTip = 'Specifies the minimum rental sale price of the real estate asset including tax.';
                }
                field("Superficie construida"; rec."Superficie construida")
                {
                    BlankZero = true;
                    Style = Strong;
                    StyleExpr = StyleIsStrong;
                    ToolTip = 'Specifies the built area of the real estate asset in square meters.';
                }
                field("Last Reference Price Min."; rec."Last Reference Price Min.")
                {
                    BlankZero = true;
                    ToolTip = 'Specifies the latest active minimum SERPAVI reference rent for the real estate asset.';
                }
                field("Last Reference Price Max."; rec."Last Reference Price Max.")
                {
                    BlankZero = true;
                    ToolTip = 'Specifies the latest active maximum SERPAVI reference rent for the real estate asset.';
                }
                field("Last Price Contract"; rec."Last Price Contract")
                {
                    ToolTip = 'Specifies the last price contract for the real estate asset.';
                    BlankZero = true;
                }
            }

        }
        area(factboxes)
        {
            systempart(Links; Links)
            {
                Visible = false;
            }
            systempart(Notes; Notes)
            {
            }
            part(FixedREAttributesFactbox; 96003)
            {
                ApplicationArea = Basic, Suite;
            }
        }
    }

    actions
    {
        area(processing)
        {
            action(OpenSerpaviReferencePrice)
            {
                Caption = 'Consultar indice alquiler MIVAU';
                Image = PriceWorksheet;
                ToolTip = 'Abrir el portal oficial SERPAVI para consultar el rango de precio de alquiler de referencia del inmueble.';

                trigger OnAction()
                var
                    SerpaviServiceMgt: Codeunit "SERPAVI Service Mgt.";
                    SearchText: Text;
                begin
                    SearchText := SerpaviServiceMgt.GetSearchTextForFixedRealEstate(Rec);
                    CurrPage.ClipboardHelper.CopyText(SearchText);
                    SerpaviServiceMgt.OpenSerpaviForFixedRealEstate(Rec);
                    CurrPage.Update(false);
                end;
            }
            action(CalculateSalesAmount)
            {
                Caption = 'Calculate Sales Amount';
                Image = Calculate;
                RunObject = Report 96011;
                ToolTip = 'Calculate the sales amount for the fixed real estate based on the related lease contracts.';

            }
        }
        area(navigation)
        {
            action("Contratos relacionados")
            {
                Caption = 'Contratos relacionados';
                Image = ContractPayment;
                Promoted = true;
                RunObject = Page "Lease Contract List";
                RunPageLink = "Fixed Real Estate No." = FIELD("No.");
            }
            action(Statistics)
            {
                Caption = 'Statistics';
                Image = Statistics;
                RunObject = Page "Fixed RE Statistics";
                RunPageLink = "No." = FIELD("No.");
                ShortCutKey = 'F7';
                ToolTip = 'View detailed historical information about the real estate asset.';
            }
            action(Incidents)
            {
                Caption = 'Incidents';
                Image = Interaction;
                Promoted = true;
                RunObject = Page "RE Incident Mobile";
                RunPageLink = "Fixed Real Estate No." = FIELD("No.");
                ToolTip = 'View service request cases associated with this fixed real estate.';
            }
            action("Co&mments")
            {
                ApplicationArea = Comments;
                Caption = 'Co&mments';
                Image = ViewComments;
                Promoted = true;
                RunObject = Page "Real Estate Comment Sheet";
                RunPageLink = "Table Name" = CONST("Fixed Real Estate"), "No." = FIELD("No.");
                ToolTip = 'View or add comments for the record.';
            }
            action("Related Contats")
            {
                Caption = 'Related Contats';
                Image = ContactReference;
                Promoted = true;
                RunObject = Page "REF Related Contactos";
                RunPageLink = "Entity Type" = CONST("Fixed Real Estate"), "Source No." = FIELD("No.");
                RunPageView = SORTING("Entity Type", "Source No.");
            }
            action("Precios Indices de referencia")
            {
                Caption = 'Precios Indices de referencia';
                Image = PriceWorksheet;
                RunObject = Page 96052;
                RunPageLink = "Fixed Real Estate No." = FIELD("No.");
                RunPageView = SORTING("Fixed Real Estate No.", "Line No.");
            }
            group(History)
            {
                Caption = 'History';

                action(FRELedgerEntries)
                {
                    ApplicationArea = Basic, Suite;
                    Caption = 'FRE Movs.';
                    Image = LedgerEntries;
                    ToolTip = 'View FRE ledger entries for this real estate asset.';

                    trigger OnAction()
                    var
                        FRELedgerEntry: Record "FRE Ledger Entry";
                    begin
                        FRELedgerEntry.SetRange("Fixed Real Estate No.", Rec."No.");
                        Page.Run(Page::"Movs. FRE", FRELedgerEntry);
                    end;
                }
            }

        }
        area(reporting)
        {
            action("Fixed Real Estate List")
            {
                Caption = 'Fixed Real Estate List';
                Image = "Report";
                Promoted = true;
                PromotedCategory = "Report";
                // RunObject = Report 96000;
                ToolTip = 'View the list of fixed real estate that exist in the system .';
            }
        }
    }

    trigger OnAfterGetRecord()
    begin
        StyleIsStrong := (rec.Type = rec.Type::Propiedad);
        StatusStyleIsStrong := NOT ((rec.Status = rec.Status::Alquilado) OR (rec.Status = rec.Status::Vendido));
        CurrPage.FixedREAttributesFactbox.PAGE.LoadItemAttributesData(rec."No.");
    end;

    var
        StyleIsStrong: Boolean;
        StatusStyleIsStrong: Boolean;
        CopyToClipboardErr: Label 'No se ha podido copiar automáticamente el dato de búsqueda al portapapeles.\%1';
}

