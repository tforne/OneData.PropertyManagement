pageextension 96986 "OD FF RE RC Ext" extends "Real Estate Role Center"
{
    layout
    {
        addafter(RECashFlowChart)
        {
            part(ODTrialBalance; "Trial Balance")
            {
                AccessByPermission = TableData "G/L Entry" = R;
                ApplicationArea = Basic, Suite;
                Caption = 'Balance comprobacion';
            }
        }
    }

    actions
    {
        addlast(Setup)
        {
            action("OD FF Setup")
            {
                ApplicationArea = All;
                Caption = 'OD FF Setup';
                Image = Setup;
                RunObject = page "OD FF Setup";
                ToolTip = 'Abre la configuración de OneData Financial Flow Map.';
            }
        }
    }
}
