pageextension 96979 "OD AM FRE Card Ext" extends "Fixed Real Estate Card"
{
    layout
    {
        addafter("Property Description")
        {
            field("OD Asset Type"; Rec."OD Asset Type")
            {
                ApplicationArea = All;
                Caption = 'Tipo de activo';
                ToolTip = 'Permite clasificar el activo inmobiliario como vivienda, habitacion, parking, trastero u otro tipo operativo de Asset Management.';
                Editable = Rec.Type <> Rec.Type::Propiedad;
            }
            field("OD Parent FRE No."; Rec."OD Parent FRE No.")
            {
                ApplicationArea = All;
                Caption = 'Activo padre';
                ToolTip = 'Indica el activo padre inmediato dentro de la jerarquia de Asset Management.';
                Editable = Rec.Type <> Rec.Type::Propiedad;
            }
        }
    }
}
