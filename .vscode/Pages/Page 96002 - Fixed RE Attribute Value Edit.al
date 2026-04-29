page 96002 "Fixed RE Attribute Value Edit."
{
    Caption = 'FRE Attribute Values';
    PageType = List;
    SourceTable = "Fixed Real Estate";
    ApplicationArea = All;

    layout
    {
        area(content)
        {
            part(ItemAttributeValueList; "FRE Attribute Value List")
            {
                ApplicationArea = Basic, Suite;
            }
        }
    }

    actions
    {
        area(processing)
        {
            action("Load attributes by asset type")
            {
                Caption = 'Cargar atibutos por tipo de activo';
                Image = MoveUp;
                // Promoted = true;

                trigger OnAction()
                begin
                    CurrPage.ItemAttributeValueList.PAGE.LoadAttributeForTypeFixeRealEstate(rec."No.");
                end;
            }
        }
    }

    trigger OnOpenPage()
    begin
        CurrPage.ItemAttributeValueList.PAGE.LoadAttributes(rec."No.");
    end;
}

