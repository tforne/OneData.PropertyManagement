page 96953 "OD FF Snapshot Card"
{
    PageType = Card;
    SourceTable = "OD FF Snapshot Header";
    ApplicationArea = All;
    Caption = 'OD Financial Flow Snapshot';

    layout
    {
        area(Content)
        {
            group(General)
            {
                Caption = 'General';

                field("Snapshot No."; Rec."Snapshot No.")
                {
                    Editable = false;
                    ToolTip = 'Indica el número del snapshot.';
                }
                field(Description; Rec.Description)
                {
                    Editable = false;
                    ToolTip = 'Describe el snapshot.';
                }
                field("Analysis DateTime"; Rec."Analysis DateTime")
                {
                    Editable = false;
                    ToolTip = 'Muestra la fecha y hora del snapshot.';
                }
                field("User ID"; Rec."User ID")
                {
                    Editable = false;
                    ToolTip = 'Indica el usuario que generó el snapshot.';
                }
                field("Version No."; Rec."Version No.")
                {
                    Editable = false;
                    ToolTip = 'Muestra la versión del algoritmo utilizada.';
                }
            }
            group(Totals)
            {
                Caption = 'Totales';

                field("No. of Companies"; Rec."No. of Companies")
                {
                    Editable = false;
                    ToolTip = 'Muestra el número de empresas analizadas.';
                }
                field("No. of Properties"; Rec."No. of Properties")
                {
                    Editable = false;
                    ToolTip = 'Muestra el número de activos analizados.';
                }
                field("No. of Contracts"; Rec."No. of Contracts")
                {
                    Editable = false;
                    ToolTip = 'Muestra el número de contratos analizados.';
                }
                field("Total Monthly Rent"; Rec."Total Monthly Rent")
                {
                    Editable = false;
                    ToolTip = 'Muestra la renta mensual total.';
                }
                field("Total Annual Rent"; Rec."Total Annual Rent")
                {
                    Editable = false;
                    ToolTip = 'Muestra la renta anual total.';
                }
                field("Weighted Gross Yield %"; Rec."Weighted Gross Yield %")
                {
                    Editable = false;
                    ToolTip = 'Muestra el yield bruto ponderado.';
                }
                field("Weighted Net Yield %"; Rec."Weighted Net Yield %")
                {
                    Editable = false;
                    ToolTip = 'Muestra el yield neto ponderado.';
                }
            }
            part(Lines; "OD FF Snapshot Subpage")
            {
                ApplicationArea = All;
                SubPageLink = "Snapshot No." = field("Snapshot No.");
            }
        }
    }
}
