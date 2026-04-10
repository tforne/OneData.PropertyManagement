page 96729 "FRE Import Preview v2"
{
    PageType = List;
    SourceTable = "FRE Import Preview v2";
    SourceTableTemporary = true;
    Caption = 'Import Preview';
    ApplicationArea = All;
    UsageCategory = Tasks;

    layout
    {
        area(content)
        {
            repeater(Group)
            {
                field("Excel Row No."; Rec."Excel Row No.") 
                {
                    trigger OnValidate()
                    begin
                        FREImportJnlLines.ValidatePreview(rec);
                    end;
                }
                field(Date; Rec.Date) 
                {
                    trigger OnValidate()
                    begin
                        FREImportJnlLines.ValidatePreview(rec);
                    end;
                }
                field("Document No."; Rec."Document No.") 
                {
                    trigger OnValidate()
                    begin
                        FREImportJnlLines.ValidatePreview(rec);
                    end;
                }
                field(Description;Rec.Description)
                {
                    trigger OnValidate()
                    begin
                        FREImportJnlLines.ValidatePreview(rec);
                    end;

                }
                field("Fixed Real Estate No."; Rec."Fixed Real Estate No.") 
                {
                    trigger OnValidate()
                    begin
                        FREImportJnlLines.ValidatePreview(rec);
                    end;
                }
                field("Fixed Real Estate Description"; Rec."Fixed Real Estate Description") 
                {
                    Editable = false;
                }
                field("Row No."; Rec."Row No.") 
                {
                    trigger OnValidate()
                    begin
                        FREImportJnlLines.ValidatePreview(rec);
                    end;
                }
                field("Description Row No. Text"; Rec."Description Row No. Text") 
                {
                    Editable = false;
                }
                field("Entry Category"; rec."Entry Category")
                {
                }
                field(Amount; Rec.Amount) 
                {
                    trigger OnValidate()
                    begin
                        FREImportJnlLines.ValidatePreview(rec);
                    end;
                }
                field("Amount Including VAT"; Rec."Amount Including VAT") 
                {
                    Visible = false;
                }
                field(Error; Rec.Error)
                {
                    Style = Unfavorable;
                    StyleExpr = Rec.Error <> '';
                    Editable = false;
                }
                field("Suggested Fixed Real Estate No."; Rec."Suggested FRE No.") { Editable = false; }
                field("Suggested FRE Description"; Rec."Suggested FRE Desc.") { Editable = false; }                               
                field("Accept Suggestion"; Rec."Accept Suggestion") {}
            }
        }
    }    
    actions
    {
        area(Processing)
        {
            group(Load)
            {
                Caption = 'Carga';
                Image = Import;

                action(LoadToGenJournal)
                {
                    Caption = 'Cargar en Gen. Journal Line';
                    Image = Import;
                    Promoted = true;
                    PromotedCategory = Process;
                    Visible = not FixedGenJournalContext;

                    trigger OnAction()
                    begin
                        if not SelectGenJournalDestination() then
                            exit;

                        CurrPage.Close();
                    end;
                }

                action(LoadToFREJournal)
                {
                    Caption = 'Cargar en FRE Journal Line';
                    Image = Import;
                    Promoted = true;
                    PromotedCategory = Process;
                    Visible = not FixedGenJournalContext;

                    trigger OnAction()
                    begin
                        if not SelectFREJournalDestination() then
                            exit;

                        CurrPage.Close();
                    end;
                }

                action(AcceptPreview)
                {
                    Caption = 'Aceptar';
                    Image = Approve;
                    Promoted = true;
                    PromotedCategory = Process;
                    Visible = FixedGenJournalContext;

                    trigger OnAction()
                    begin
                        CurrPage.Close();
                    end;
                }
            }
        }
        area(Navigation)
        {
            action(Suggestions)
            {
                Caption = 'Suggestions';
                Image = Import;
                Promoted = true;
                PromotedCategory = Process;
                RunObject = page 96730;
            }
        }
    }

    trigger OnOpenPage()
    begin
        Clear(SelectedImportTarget);
        Clear(SelectedJournalTemplateName);
        Clear(SelectedJournalBatchName);
    end;

    var
        FREImportJnlLines: Codeunit "FRE Import Jnl. Lines";
        SelectedImportTarget: Option ,FRE,Gen;
        SelectedJournalTemplateName: Code[10];
        SelectedJournalBatchName: Code[10];
        FixedGenJournalContext: Boolean;

    procedure LoadPreview(var SourcePreview: Record "FRE Import Preview v2" temporary)
    begin
        Rec.Reset();
        Rec.DeleteAll();

        if SourcePreview.FindSet() then
            repeat
                Rec := SourcePreview;
                Rec.Insert();
            until SourcePreview.Next() = 0;
    end;

    procedure SavePreview(var TargetPreview: Record "FRE Import Preview v2" temporary)
    begin
        TargetPreview.Reset();
        TargetPreview.DeleteAll();

        if Rec.FindSet() then
            repeat
                TargetPreview := Rec;
                TargetPreview.Insert();
            until Rec.Next() = 0;
    end;

    procedure GetSelectedImportTarget(): Text[10]
    begin
        case SelectedImportTarget of
            SelectedImportTarget::FRE:
                exit('FRE');
            SelectedImportTarget::Gen:
                exit('GEN');
        end;

        exit('');
    end;

    procedure GetDestinationTemplateName(): Code[10]
    begin
        exit(SelectedJournalTemplateName);
    end;

    procedure GetDestinationBatchName(): Code[10]
    begin
        exit(SelectedJournalBatchName);
    end;

    procedure SetFixedGenJournalContext()
    begin
        FixedGenJournalContext := true;
        SelectedImportTarget := SelectedImportTarget::Gen;
    end;

    local procedure SelectFREJournalDestination(): Boolean
    var
        ImportDestination: Page "FRE Import Destination";
    begin
        Clear(ImportDestination);
        ImportDestination.SetFREJournalMode();

        if ImportDestination.RunModal() <> Action::OK then
            exit(false);

        SelectedImportTarget := SelectedImportTarget::FRE;
        SelectedJournalTemplateName := ImportDestination.GetTemplateName();
        SelectedJournalBatchName := ImportDestination.GetBatchName();
        exit(true);
    end;

    local procedure SelectGenJournalDestination(): Boolean
    var
        ImportDestination: Page "FRE Import Destination";
    begin
        Clear(ImportDestination);
        ImportDestination.SetGenJournalMode();

        if ImportDestination.RunModal() <> Action::OK then
            exit(false);

        SelectedImportTarget := SelectedImportTarget::Gen;
        SelectedJournalTemplateName := ImportDestination.GetTemplateName();
        SelectedJournalBatchName := ImportDestination.GetBatchName();
        exit(true);
    end;
}
