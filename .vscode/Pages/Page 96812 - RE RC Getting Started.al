page 96812 "RE RC Getting Started"
{
    PageType = CardPart;
    SourceTable = "Company Information";
    Caption = 'Comenzar con FRE';
    ApplicationArea = All;
    RefreshOnActivate = true;

    layout
    {
        area(content)
        {
            group(Welcome)
            {
                Caption = 'Comenzar';

                field(SetupStatusTxt; SetupStatusTxt)
                {
                    Caption = '1. Configurar REF Setup';
                    ApplicationArea = All;
                    Editable = false;
                    Style = Favorable;
                    StyleExpr = SetupReady;
                    ToolTip = 'Abrir la configuración base del módulo inmobiliario.';

                    trigger OnDrillDown()
                    begin
                        Page.Run(Page::"Real Estate Fixed Setup");
                    end;
                }

                field(TemplateStatusTxt; TemplateStatusTxt)
                {
                    Caption = '2. Cargar plantilla Excel FRE';
                    ApplicationArea = All;
                    Editable = false;
                    Style = Favorable;
                    StyleExpr = TemplateReady;
                    ToolTip = 'Subir o revisar la plantilla Excel utilizada para la importación FRE.';

                    trigger OnDrillDown()
                    begin
                        Page.Run(Page::"FRE Excel Template Setup");
                    end;
                }

                field(JournalTemplateStatusTxt; JournalTemplateStatusTxt)
                {
                    Caption = '3. Configurar plantillas de diario FRE';
                    ApplicationArea = All;
                    Editable = false;
                    Style = Favorable;
                    StyleExpr = JournalTemplateReady;
                    ToolTip = 'Revisar las plantillas y lotes de diario FRE.';

                    trigger OnDrillDown()
                    begin
                        Page.Run(Page::"FRE Jnl. Template List");
                    end;
                }
            }
        }
    }

    trigger OnOpenPage()
    begin
        EnsureCompanyInfo();
        LoadData();
    end;

    trigger OnAfterGetRecord()
    begin
        LoadData();
    end;

    local procedure EnsureCompanyInfo()
    begin
        if not Rec.Get() then begin
            Rec.Init();
            Rec.Insert();
        end;
    end;

    local procedure LoadData()
    var
        REFSetup: Record "REF Setup";
        ExcelTemplateSetup: Record "FRE Excel Template Setup";
        FREJnlTemplate: Record "FRE Jnl. Template";
    begin
        SetupReady := false;
        if REFSetup.Get() then
            SetupReady :=
                (REFSetup."Journal Template Name" <> '') and
                (REFSetup."Journal Batch Name" <> '') and
                (REFSetup."Default Income Row No" <> '');
        SetupStatusTxt := GetStatusText(SetupReady);

        TemplateReady := false;
        if ExcelTemplateSetup.Get('SETUP') then begin
            ExcelTemplateSetup.CalcFields("Journal Template File");
            TemplateReady := ExcelTemplateSetup."Journal Template File".HasValue;
        end;
        TemplateStatusTxt := GetStatusText(TemplateReady);

        JournalTemplateReady := FREJnlTemplate.Count > 0;
        JournalTemplateStatusTxt := GetStatusText(JournalTemplateReady);
    end;

    local procedure GetStatusText(IsReady: Boolean): Text[30]
    begin
        if IsReady then
            exit('Completado');

        exit('Pendiente');
    end;

    var
        SetupReady: Boolean;
        TemplateReady: Boolean;
        JournalTemplateReady: Boolean;
        SetupStatusTxt: Text[30];
        TemplateStatusTxt: Text[30];
        JournalTemplateStatusTxt: Text[30];
}
