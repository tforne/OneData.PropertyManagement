page 96927 "OD AM Lease Wizard Units"
{
    PageType = ListPart;
    SourceTable = "OD AM Lease Wizard Unit";
    Caption = 'Unidades del contrato';
    ApplicationArea = All;
    AutoSplitKey = true;
    DelayedInsert = true;

    layout
    {
        area(Content)
        {
            repeater(ContractUnits)
            {
                field("Fixed Real Estate No."; Rec."Fixed Real Estate No.")
                {
                    ToolTip = 'Muestra el activo inmobiliario vinculado al contrato.';
                }
                field(Description; Rec.Description)
                {
                    ToolTip = 'Muestra la descripcion del activo.';
                }
                field("Asset Type"; Rec."Asset Type")
                {
                    ToolTip = 'Muestra el tipo de activo.';
                }
                field(Role; Rec.Role)
                {
                    ToolTip = 'Indica si el activo es principal, adicional o accesorio.';
                }
                field("Property No."; Rec."Property No.")
                {
                    ToolTip = 'Muestra la propiedad raiz del activo.';
                }
                field("Parent FRE No."; Rec."Parent FRE No.")
                {
                    ToolTip = 'Muestra el activo padre dentro de la estructura.';
                }
                field("Starting Date"; Rec."Starting Date")
                {
                    ToolTip = 'Muestra la fecha de inicio de vigencia del activo dentro del contrato.';
                }
                field("Ending Date"; Rec."Ending Date")
                {
                    ToolTip = 'Muestra la fecha de fin de vigencia del activo dentro del contrato.';
                }
                field(Active; Rec.Active)
                {
                    Editable = false;
                    ToolTip = 'Indica si la linea esta activa en la fecha de trabajo.';
                }
                field("Monthly Rent"; Rec."Monthly Rent")
                {
                    ToolTip = 'Muestra la renta mensual informativa del activo contractual.';
                }
            }
        }
    }
}
