page 96061 "Simple Fixed Real Estate List"
{
    Caption = 'Fixed Real Estate List';
    CardPageID = "Fixed Real Estate Card";
    PageType = List;
    PopulateAllFields = true;
    SourceTable = "Fixed Real Estate";
    SourceTableView = SORTING("Property Description", "Property No.", Type, Description) where (Type = const(1));
    UsageCategory = Lists;
    ApplicationArea = All;


    layout
    {
        area(content)
        {
            repeater(Group)
            {
                FreezeColumn = Description;
                field("No."; rec."No.")
                {
                    ApplicationArea = All;
                    Style = Strong;
                    ToolTip = 'Specifies the number of the involved entry or record, according to the specified number series.';
                    Visible = true;
                }
                field(Description; rec.Description)
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies a description of the real estate asset.';
                }
                field("Post Code"; rec."Post Code")
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
                RunPageLink = "Fixed Real Estate No." = FIELD("No.");
            }
            action(Statistics)
            {
                ApplicationArea = All;
                Caption = 'Statistics';
                Image = Statistics;
                RunObject = Page "Fixed RE Statistics";
                RunPageLink = "No." = FIELD("No.");
                ShortCutKey = 'F7';
                ToolTip = 'View detailed historical information about the real estate asset.';
            }
            action(Incidents)
            {
                ApplicationArea = All;
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
                ApplicationArea = All;
                Caption = 'Related Contats';
                Image = ContactReference;
                Promoted = true;
                RunObject = Page "REF Related Contactos";
                RunPageLink = "Entity Type" = CONST("Fixed Real Estate"), "Source No." = FIELD("No.");
                RunPageView = SORTING("Entity Type", "Source No.");
            }
            action("Precios Indices de referencia")
            {
                ApplicationArea = All;
                Caption = 'Precios Indices de referencia';
                Image = PriceWorksheet;
                RunObject = Page 96052;
                RunPageLink = "Fixed Real Estate No." = FIELD("No.");
                RunPageView = SORTING("Fixed Real Estate No.", "Line No.");
            }
        }

    }

    trigger OnAfterGetRecord()
    begin
    end;

}

