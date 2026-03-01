page 96001 "Fixed Real Estate List"
{
    Caption = 'Fixed Real Estate';
    CardPageID = "Fixed Real Estate Card";
    PageType = List;
    PopulateAllFields = true;
    SourceTable = "Fixed Real Estate";
    SourceTableView = SORTING ("Property Description", "Property No.", Type, Description);
    UsageCategory = Lists;
    ApplicationArea = All;

    layout
    {
        area(content)
        {
            repeater(Group)
            {
                field("No."; rec."No.")
                {
                    ApplicationArea = All;
                    Style = Strong;
                    StyleExpr = StyleIsStrong;
                    ToolTip = 'Specifies the number of the involved entry or record, according to the specified number series.';
                    Visible = false;
                }
                field(Type; rec.Type)
                {
                    ApplicationArea = All;
                    ColumnSpan = 2;
                    Style = Strong;
                    StyleExpr = StyleIsStrong;
                }
                field(Description; rec.Description)
                {
                    ApplicationArea = All;
                    Style = Strong;
                    StyleExpr = StyleIsStrong;
                    ToolTip = 'Specifies a description of the fixed asset.';
                }
                field(City; rec.City)
                {
                    ApplicationArea = All;

                }
                field("Vendor No."; rec."Vendor No.")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the number of the vendor from which you purchased this fixed asset.';
                    Visible = false;
                }
                field("Maintenance Vendor No."; rec."Maintenance Vendor No.")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the number of the vendor who performs repairs and maintenance on the fixed asset.';
                    Visible = false;
                }
                field("Responsible Employee"; rec."Responsible Employee")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies which employee is responsible for the fixed asset.';
                }
                field("Cadastral reference"; rec."Cadastral reference")
                {
                }
                field(Status; rec.Status)
                {
                    ApplicationArea = All;
                    Style = Attention;
                    StyleExpr = StatusStyleIsStrong;
                }
                field(Acquired; rec.Acquired)
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies that the fixed asset has been acquired.';
                }
                field(Managed; rec.Managed)
                {
                    ApplicationArea = All;
                }
                field("Val. Catastral Activo"; rec."Val. Catastral Activo")
                {
                    ApplicationArea = All;
                }
                field("Val. Castastral Const. Activo"; rec."Val. Castastral Const. Activo")
                {
                    ApplicationArea = All;
                }
                field("Val. Castastral Actua. Activo"; rec."Val. Castastral Actua. Activo")
                {
                    ApplicationArea = All;
                }
                field("Superficie construida"; rec."Superficie construida")
                {
                    ApplicationArea = All;
                }
                field("Last Reference Price"; rec."Last Reference Price")
                {
                    ApplicationArea = All;
                }
                field("Last Price Contract"; rec."Last Price Contract")
                {
                    ApplicationArea = All;
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
        area(navigation)
        {
            action("Contratos relacionados")
            {
                Caption = 'Contratos relacionados';
                Image = ContractPayment;
                Promoted = true;
                RunObject = Page "Lease Contract List";
                RunPageLink = "Fixed Real Estate No."=FIELD("No.");
            }
            action(Statistics)
            {
                ApplicationArea = All;
                Caption = 'Statistics';
                Image = Statistics;
                RunObject = Page "Fixed Asset Statistics";
                                RunPageLink = "FA No."=FIELD("No.");
                ShortCutKey = 'F7';
                ToolTip = 'View detailed historical information about the fixed asset.';
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
            action("Co&mments")
            {
                ApplicationArea = Comments;
                Caption = 'Co&mments';
                Image = ViewComments;
                Promoted = true;
                RunObject = Page "Real Estate Comment Sheet";
                RunPageLink = "Table Name"=CONST("Fixed Real Estate"),"No."=FIELD("No.");
                ToolTip = 'View or add comments for the record.';
            }
            action("Related Contats")
            {
                ApplicationArea = All;
                Caption = 'Related Contats';
                Image = ContactReference;
                Promoted = true;
                RunObject = Page "REF Related Contactos";
                RunPageLink = "Entity Type" = CONST("Fixed Real Estate"),"Source No."=FIELD("No.");
                RunPageView = SORTING("Entity Type","Source No.");
            }
            action("Precios Indices de referencia")
            {
                ApplicationArea = All;
                Caption = 'Precios Indices de referencia';
                Image = PriceWorksheet;
                RunObject = Page 96052;
                RunPageLink = "Fixed Real Estate No."=FIELD("No.");
                RunPageView = SORTING("Fixed Real Estate No.","Line No.");
            }
        }
        area(reporting)
        {
            action("Fixed Real Estate List")
            {
                ApplicationArea = All;
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
}

