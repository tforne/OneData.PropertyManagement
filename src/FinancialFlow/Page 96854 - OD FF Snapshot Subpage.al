page 96954 "OD FF Snapshot Subpage"
{
    PageType = ListPart;
    SourceTable = "OD FF Snapshot Line";
    ApplicationArea = All;
    Caption = 'Líneas snapshot';

    layout
    {
        area(Content)
        {
            repeater(Lines)
            {
                field("Company Name"; Rec."Company Name")
                {
                    ToolTip = 'Indica la empresa de la línea.';
                }
                field("Property No."; Rec."Property No.")
                {
                    ToolTip = 'Indica el activo de la línea.';
                }
                field("Contract No."; Rec."Contract No.")
                {
                    ToolTip = 'Indica el contrato de la línea.';
                }
                field("Customer Name"; Rec."Customer Name")
                {
                    ToolTip = 'Indica el arrendatario.';
                }
                field("Annual Rent"; Rec."Annual Rent")
                {
                    ToolTip = 'Muestra la renta anual guardada.';
                }
                field("Market Value"; Rec."Market Value")
                {
                    ToolTip = 'Muestra el valor utilizado.';
                }
                field("Gross Yield Percentage"; Rec."Gross Yield Percentage")
                {
                    ToolTip = 'Muestra el yield bruto guardado.';
                }
                field("Net Yield Percentage"; Rec."Net Yield Percentage")
                {
                    ToolTip = 'Muestra el yield neto guardado.';
                }
                field("Risk Level"; Rec."Risk Level")
                {
                    ToolTip = 'Muestra el riesgo guardado.';
                }
            }
        }
    }
}
