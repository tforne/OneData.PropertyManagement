page 96980 "OD AM Secondary Units FB"
{
    PageType = ListPart;
    SourceTable = "Fixed Real Estate";
    Caption = 'Unidades secundarias';
    ApplicationArea = All;
    Editable = false;

    layout
    {
        area(Content)
        {
            repeater(Units)
            {
                field("No."; Rec."No.")
                {
                    ToolTip = 'Muestra el codigo de la unidad secundaria.';
                }
                field(Description; Rec.Description)
                {
                    ToolTip = 'Muestra la descripcion de la unidad secundaria.';
                }
                field("OD Asset Type"; Rec."OD Asset Type")
                {
                    Caption = 'Asset Type';
                    ToolTip = 'Muestra si la unidad es habitacion, parking o trastero.';
                }
                field("OD Parent FRE No."; Rec."OD Parent FRE No.")
                {
                    Caption = 'Parent FRE No.';
                    ToolTip = 'Muestra el activo padre inmediato dentro de la estructura.';
                }
                field(Status; Rec.Status)
                {
                    ToolTip = 'Muestra el estado actual de la unidad secundaria.';
                }
            }
        }
    }

    var
        ContextPropertyNo: Code[20];

    procedure SetContext(FixedRealEstateNo: Code[20])
    var
        FixedRealEstate: Record "Fixed Real Estate";
        AssetStructureMgt: Codeunit "OD AM Asset Structure Mgt.";
    begin
        Clear(ContextPropertyNo);

        if (FixedRealEstateNo <> '') and FixedRealEstate.Get(FixedRealEstateNo) then begin
            if FixedRealEstate.Type = FixedRealEstate.Type::Propiedad then
                ContextPropertyNo := FixedRealEstate."No."
            else
                if FixedRealEstate."Property No." <> '' then
                    ContextPropertyNo := FixedRealEstate."Property No."
                else
                    ContextPropertyNo := AssetStructureMgt.GetRootProperty(FixedRealEstate."No.");
        end;

        ApplyFilters();
        CurrPage.Update(false);
    end;

    trigger OnOpenPage()
    begin
        ApplyFilters();
    end;

    local procedure ApplyFilters()
    begin
        Rec.Reset();
        Rec.SetRange(Type, Rec.Type::Activo);
        if ContextPropertyNo <> '' then
            Rec.SetRange("Property No.", ContextPropertyNo)
        else
            Rec.SetRange("Property No.");

        Rec.SetFilter("OD Asset Type", '%1|%2|%3',
          Rec."OD Asset Type"::Room,
          Rec."OD Asset Type"::Parking,
          Rec."OD Asset Type"::Storage);
    end;
}
