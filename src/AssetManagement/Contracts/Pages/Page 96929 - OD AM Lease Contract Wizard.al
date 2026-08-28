page 96929 "OD AM Lease Contract Wizard"
{
    ApplicationArea = All;
    Caption = 'Nuevo contrato de alquiler';
    DeleteAllowed = false;
    InsertAllowed = false;
    PageType = NavigatePage;
    SourceTable = "OD AM Lease Wizard Buffer";

    layout
    {
        area(Content)
        {
            group(AssetStep)
            {
                Caption = 'Paso 1 - Activo';
                Visible = Step = 1;
                group(AssetContent)
                {
                    InstructionalText = 'El contrato se crea a partir del activo inmobiliario actual.';
                    field("Fixed Real Estate No."; Rec."Fixed Real Estate No.")
                    {
                        Editable = false;
                    }
                    field("Fixed Real Estate Description"; Rec."Fixed Real Estate Description")
                    {
                        Editable = false;
                    }
                    field("Fixed Real Estate Type"; Rec."Fixed Real Estate Type")
                    {
                        Caption = 'Type';
                        Editable = false;
                    }
                    field("OD Asset Type"; Rec."OD Asset Type")
                    {
                        Caption = 'Asset Type';
                        Editable = false;
                    }
                    field("Property No."; Rec."Property No.")
                    {
                        Editable = false;
                    }
                    field("Property Description"; Rec."Property Description")
                    {
                        Editable = false;
                    }
                }
            }
            group(UnitStep)
            {
                Caption = 'Paso 2 - Unidades';
                Visible = Step = 2;
                group(UnitContent)
                {
                    InstructionalText = 'La unidad principal ya viene precargada. Puede anadir activos adicionales o accesorios compatibles.';
                    part(WizardUnits; "OD AM Lease Wizard Units")
                    {
                        ApplicationArea = All;
                        SubPageLink = "Wizard Id" = field("Wizard Id");
                        UpdatePropagation = Both;
                    }
                }
            }
            group(HeaderStep)
            {
                Caption = 'Paso 3 - Arrendatario y condiciones';
                Visible = Step = 3;
                group(HeaderContent)
                {
                    field(Description; Rec.Description)
                    {
                        ToolTip = 'Especifica la descripcion del contrato de alquiler.';
                    }
                    field("Customer No."; Rec."Customer No.")
                    {
                        ToolTip = 'Especifica el cliente arrendatario del contrato.';
                    }
                    field("Customer Name"; Rec."Customer Name")
                    {
                        Editable = false;
                    }
                    field("Contract Date"; Rec."Contract Date")
                    {
                    }
                    field("Starting Date"; Rec."Starting Date")
                    {
                    }
                    field("Ending Date"; Rec."Ending Date")
                    {
                    }
                    field(Status; Rec.Status)
                    {
                        ToolTip = 'Permite crear el contrato en borrador o firmarlo al finalizar.';
                    }
                    field("Invoice Period"; Rec."Invoice Period")
                    {
                    }
                    field("Payment Method Code"; Rec."Payment Method Code")
                    {
                    }
                    field("Payment Terms Code"; Rec."Payment Terms Code")
                    {
                    }
                }
            }
            group(LinesStep)
            {
                Caption = 'Paso 4 - Lineas del contrato';
                Visible = Step = 4;
                group(LinesContent)
                {
                    InstructionalText = 'Revise y ajuste las lineas economicas que se copiaran al contrato final.';
                    part(WizardLines; "OD AM Lease Wizard Lines")
                    {
                        ApplicationArea = All;
                        SubPageLink = "Wizard Id" = field("Wizard Id");
                        UpdatePropagation = Both;
                    }
                }
            }
            group(ReviewStep)
            {
                Caption = 'Paso 5 - Resumen';
                Visible = Step = 5;
                group(ReviewContent)
                {
                    field(ReviewSummary; ReviewSummary)
                    {
                        ApplicationArea = All;
                        ShowCaption = false;
                        Editable = false;
                        MultiLine = true;
                    }
                    field(PeriodicAmount; PeriodicAmount)
                    {
                        ApplicationArea = All;
                        Caption = 'Importe periodico estimado';
                        Editable = false;
                    }
                    field(AnnualAmount; AnnualAmount)
                    {
                        ApplicationArea = All;
                        Caption = 'Importe anual estimado';
                        Editable = false;
                    }
                }
            }
        }
    }

    actions
    {
        area(Processing)
        {
            action(BackAction)
            {
                ApplicationArea = All;
                Caption = 'Back';
                Enabled = Step > 1;
                Image = PreviousRecord;
                InFooterBar = true;

                trigger OnAction()
                begin
                    Step -= 1;
                    RefreshStep();
                end;
            }
            action(NextAction)
            {
                ApplicationArea = All;
                Caption = 'Next';
                Enabled = Step < 5;
                Image = NextRecord;
                InFooterBar = true;

                trigger OnAction()
                begin
                    CurrPage.SaveRecord();
                    if Step = 3 then
                        WizardMgt.EnsureDefaultContractLines(Rec."Wizard Id");
                    if Step < 5 then
                        Step += 1;
                    RefreshStep();
                end;
            }
            action(FinishAction)
            {
                ApplicationArea = All;
                Caption = 'Finish';
                Enabled = Step = 5;
                Image = Approve;
                InFooterBar = true;

                trigger OnAction()
                begin
                    CurrPage.SaveRecord();
                    CreatedContractNo := WizardMgt.CreateLeaseContract(Rec."Wizard Id");
                    CleanupHandled := true;
                    WizardMgt.DeleteWizardData(Rec."Wizard Id");
                    CurrPage.Close();
                    WizardMgt.OpenLeaseContract(CreatedContractNo);
                end;
            }
            action(CancelAction)
            {
                ApplicationArea = All;
                Caption = 'Cancel';
                Image = Cancel;
                InFooterBar = true;

                trigger OnAction()
                begin
                    CleanupHandled := true;
                    WizardMgt.DeleteWizardData(Rec."Wizard Id");
                    CurrPage.Close();
                end;
            }
        }
    }

    trigger OnOpenPage()
    begin
        if WizardId <> BlankGuid then
            Rec.Get(WizardId);

        Step := 1;
        RefreshStep();
    end;

    trigger OnQueryClosePage(CloseAction: Action): Boolean
    begin
        if not CleanupHandled then
            WizardMgt.DeleteWizardData(Rec."Wizard Id");

        exit(true);
    end;

    var
        WizardMgt: Codeunit "OD AM Lease Wizard Mgt.";
        WizardId: Guid;
        Step: Integer;
        ReviewSummary: Text;
        PeriodicAmount: Decimal;
        AnnualAmount: Decimal;
        CleanupHandled: Boolean;
        CreatedContractNo: Code[20];
        BlankGuid: Guid;

    procedure SetWizard(NewWizardId: Guid)
    begin
        WizardId := NewWizardId;
    end;

    local procedure RefreshStep()
    begin
        if Step = 5 then
            WizardMgt.BuildSummary(Rec."Wizard Id", ReviewSummary, PeriodicAmount, AnnualAmount);

        CurrPage.Update(false);
    end;
}
