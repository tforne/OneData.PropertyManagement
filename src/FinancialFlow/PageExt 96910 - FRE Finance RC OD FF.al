pageextension 96985 "OD FF FRE Finance RC Ext" extends "FRE Finance Role Center"
{
    actions
    {
        addlast(Sections)
        {
            group("OD Financial Flow")
            {
                Caption = 'OD Financial Flow';

                action("OneData Financial Flow Map")
                {
                    ApplicationArea = All;
                    Caption = 'OneData Financial Flow Map';
                    Image = AnalysisView;
                    RunObject = page "OD FF Map";
                    ToolTip = 'Abre el mapa consolidado de flujos financieros de alquiler.';
                }
            }
        }
    }
}
