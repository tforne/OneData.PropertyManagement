page 96007 "Real Estate Fixed Setup"
{
    ApplicationArea = FixedAssets;
    Caption = 'Real Estate Fixed Setup';
    DeleteAllowed = false;
    InsertAllowed = false;
    PageType = Card;
    PromotedActionCategories = 'New,Process,Report,General,Depreciation,Posting,Journal Templates';
    SourceTable = "REF Setup";
    UsageCategory = Administration;

    layout
    {
        area(content)
        {
            group(General)
            {
                Caption = 'General';
                field("Service Charge Acc."; rec."Service Charge Acc.")
                {
                }
                field("Bus. Rel. Code for Visits"; rec."Bus. Rel. Code for Visits")
                {
                }
                field("Bus. Rel. Code for Owner"; rec."Bus. Rel. Code for Owner")
                {
                }
                field("Bus. Rel. Code for Partner"; rec."Bus. Rel. Code for Partner")
                {
                }
            }
            group(Numbering)
            {
                Caption = 'Numbering';
                field("real estate asset Nos."; rec."Fixed Asset Nos.")
                {
                    ApplicationArea = FixedAssets;
                    ToolTip = 'Specifies the code for the number series that will be used to assign numbers to real estate assets.';
                }
                field("Insurance Nos."; rec."Insurance Nos.")
                {
                    ApplicationArea = FixedAssets;
                    ToolTip = 'Specifies the number series code that will be used to assign numbers to insurance policies.';
                }
                field("Lease Contract Nos."; rec."Lease Contract Nos.")
                {
                }
                field("Contract Invoice Nos."; rec."Contract Invoice Nos.")
                {
                }
                field("Contract Lease Invoice Nos."; rec."Contract Lease Invoice Nos.")
                {
                }
                field("Statement Bank Nos."; rec."Statement Bank Nos.")
                {
                }
            }
            group(Journal)
            {
                Caption = 'Journal';
                field("Journal Template Name"; rec."Journal Template Name")
                {
                }
                field("Journal Batch Name"; rec."Journal Batch Name")
                {
                }
                field("Default Income Row No"; rec."Default Income Row No")
                {
                }
                field("Default Depreciation Row No"; Rec."Default Depreciation Row No")
                {
                }
            }
            group(CRM)
            {
                Caption = 'CRM';
                field("Interaction Template Filter"; rec."Interaction Template Filter")
                {
                }
            }
            group("Integration Garana")
            {
                Caption = 'Integration Garana';
                field("Repository Contracts Files"; rec."Repository Contracts Files")
                {
                    ApplicationArea = FixedAssets;
                    ToolTip = 'Specifies the code for the number series that will be used to assign numbers to real estate assets.';
                }
                field("Repository Lease Invoices"; rec."Repository Lease Invoices")
                {
                }
            }
        }
        area(factboxes)
        {
            systempart(Links; Links)
            {
                Visible = false;
            }
            systempart(Notes; Notes)
            {
                Visible = false;
            }
        }
    }

    actions
    {
        area(processing)
        {
            action(FASetup)
            {
                ApplicationArea = FixedAssets;
                Caption = 'Configurar REF Setup';
                Image = Setup;
                ToolTip = 'Configure the REF Setup';
                trigger OnAction()
                var
                    InitSetup: Codeunit GeneralManagementInstall;
                begin
                    InitSetup.ConfigurarREFSetup();
                end;
            }
        }
        area(navigation)
        {
            action("Esquema Ingresos y Gastos")
            {
                Image = AnalysisView;
                RunObject = Page "REF Income & Expenses Template";
                RunPageLink = "No. Template" = CONST('');
            }
            action("Descriptions Docs. Classified")
            {
                Image = Description;
                RunObject = Page 96020;
            }
        }
    }

    trigger OnOpenPage()
    begin
        rec.RESET;
        IF NOT rec.GET THEN BEGIN
            rec.INIT;
            rec.INSERT;
        END;
    end;
}

