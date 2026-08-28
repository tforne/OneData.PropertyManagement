pageextension 96981 "OD AM FRE List Ext" extends "Fixed Real Estate List"
{
    layout
    {
        addlast(FactBoxes)
        {
            part(ODAMSecondaryUnitsFactBox; "OD AM Secondary Units FB")
            {
                ApplicationArea = All;
            }
        }
    }

    actions
    {
        addlast(Processing)
        {
            action(HideSecondaryUnits)
            {
                Caption = 'Ocultar secundarios';
                Image = FilterLines;
                ApplicationArea = All;

                trigger OnAction()
                begin
                    HideSecondaryAssetTypes := true;
                    ApplySecondaryAssetFilter();
                end;
            }
            action(ShowSecondaryUnits)
            {
                Caption = 'Mostrar secundarios';
                Image = RemoveFilterLines;
                ApplicationArea = All;

                trigger OnAction()
                begin
                    HideSecondaryAssetTypes := false;
                    ApplySecondaryAssetFilter();
                end;
            }
        }
    }

    trigger OnOpenPage()
    begin
        Rec.SetCurrentKey("Property No.");
        Rec.Ascending(true);
        HideSecondaryAssetTypes := true;
        ApplySecondaryAssetFilter();
    end;

    trigger OnAfterGetCurrRecord()
    begin
        CurrPage.ODAMSecondaryUnitsFactBox.Page.SetContext(Rec."No.");
    end;

    var
        HideSecondaryAssetTypes: Boolean;

    local procedure ApplySecondaryAssetFilter()
    begin
        if HideSecondaryAssetTypes then
            Rec.SetFilter("OD Asset Type", '<>%1&<>%2&<>%3',
              Rec."OD Asset Type"::Room,
              Rec."OD Asset Type"::Parking,
              Rec."OD Asset Type"::Storage)
        else
            Rec.SetRange("OD Asset Type");

        CurrPage.Update(false);
    end;
}
