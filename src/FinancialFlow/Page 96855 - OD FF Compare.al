page 96955 "OD FF Compare"
{
    PageType = List;
    SourceTable = "OD FF Compare Buffer";
    ApplicationArea = All;
    UsageCategory = History;
    Caption = 'OD Financial Flow Compare';

    layout
    {
        area(Content)
        {
            repeater(Lines)
            {
                field("Snapshot No. 1"; Rec."Snapshot No. 1")
                {
                    ToolTip = 'Indica el snapshot base.';
                }
                field("Snapshot No. 2"; Rec."Snapshot No. 2")
                {
                    ToolTip = 'Indica el snapshot comparado.';
                }
                field("Company Name"; Rec."Company Name")
                {
                    ToolTip = 'Indica la empresa comparada.';
                }
                field("Property No."; Rec."Property No.")
                {
                    ToolTip = 'Indica el activo comparado.';
                }
                field("Contract No."; Rec."Contract No.")
                {
                    ToolTip = 'Indica el contrato comparado.';
                }
                field("Change Type"; Rec."Change Type")
                {
                    ToolTip = 'Indica el tipo de cambio detectado.';
                }
                field("Monthly Rent Delta"; Rec."Monthly Rent Delta")
                {
                    ToolTip = 'Muestra la variación de renta mensual.';
                }
                field("Annual Rent Delta"; Rec."Annual Rent Delta")
                {
                    ToolTip = 'Muestra la variación de renta anual.';
                }
                field("Market Value Delta"; Rec."Market Value Delta")
                {
                    ToolTip = 'Muestra la variación del valor de mercado.';
                }
                field("Gross Yield Delta"; Rec."Gross Yield Delta")
                {
                    ToolTip = 'Muestra la variación de yield bruto.';
                }
                field("Net Yield Delta"; Rec."Net Yield Delta")
                {
                    ToolTip = 'Muestra la variación de yield neto.';
                }
                field("Cash Flow Delta"; Rec."Cash Flow Delta")
                {
                    ToolTip = 'Muestra la variación de cash flow.';
                }
            }
        }
    }

    trigger OnOpenPage()
    begin
        Rec.SetRange("User ID", CopyStr(UserId(), 1, 50));
    end;
}
