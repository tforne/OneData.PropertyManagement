page 96952 "OD FF Snapshot List"
{
    PageType = List;
    SourceTable = "OD FF Snapshot Header";
    ApplicationArea = All;
    UsageCategory = History;
    CardPageId = "OD FF Snapshot Card";
    Caption = 'OD Financial Flow Snapshots';

    layout
    {
        area(Content)
        {
            repeater(Lines)
            {
                field("Snapshot No."; Rec."Snapshot No.")
                {
                    ToolTip = 'Indica el número del snapshot.';
                }
                field(Description; Rec.Description)
                {
                    ToolTip = 'Describe el snapshot guardado.';
                }
                field("Analysis DateTime"; Rec."Analysis DateTime")
                {
                    ToolTip = 'Muestra cuándo se guardó el snapshot.';
                }
                field("No. of Companies"; Rec."No. of Companies")
                {
                    ToolTip = 'Muestra cuántas empresas se incluyeron.';
                }
                field("No. of Properties"; Rec."No. of Properties")
                {
                    ToolTip = 'Muestra cuántos activos se incluyeron.';
                }
                field("No. of Contracts"; Rec."No. of Contracts")
                {
                    ToolTip = 'Muestra cuántos contratos se incluyeron.';
                }
                field("Total Annual Rent"; Rec."Total Annual Rent")
                {
                    ToolTip = 'Muestra la renta anual total del snapshot.';
                }
                field("Weighted Gross Yield %"; Rec."Weighted Gross Yield %")
                {
                    ToolTip = 'Muestra el yield bruto ponderado.';
                }
                field("Weighted Net Yield %"; Rec."Weighted Net Yield %")
                {
                    ToolTip = 'Muestra el yield neto ponderado.';
                }
                field(Status; Rec.Status)
                {
                    ToolTip = 'Muestra el estado del snapshot.';
                }
            }
        }
    }
}
