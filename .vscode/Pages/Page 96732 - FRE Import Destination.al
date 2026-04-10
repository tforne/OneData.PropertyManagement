page 96732 "FRE Import Destination"
{
    PageType = StandardDialog;
    Caption = 'Destino de carga';
    ApplicationArea = All;

    layout
    {
        area(content)
        {
            group(FREJournalGroup)
            {
                Caption = 'FRE Journal';
                Visible = IsFREJournal;

                field(FREJournalTemplateName; FREJournalTemplateName)
                {
                    Caption = 'Libro';
                    ApplicationArea = All;

                    trigger OnLookup(var Text: Text): Boolean
                    var
                        FREJnlTemplate: Record "FRE Jnl. Template";
                    begin
                        if Page.RunModal(0, FREJnlTemplate) = Action::LookupOK then begin
                            Text := FREJnlTemplate.Name;
                            FREJournalTemplateName := FREJnlTemplate.Name;
                            FREJournalBatchName := '';
                            exit(true);
                        end;

                        exit(false);
                    end;

                    trigger OnValidate()
                    var
                        FREJnlTemplate: Record "FRE Jnl. Template";
                    begin
                        if FREJournalTemplateName = '' then
                            exit;

                        FREJnlTemplate.Get(FREJournalTemplateName);
                        FREJournalBatchName := '';
                    end;
                }

                field(FREJournalBatchName; FREJournalBatchName)
                {
                    Caption = 'Sección';
                    ApplicationArea = All;

                    trigger OnLookup(var Text: Text): Boolean
                    var
                        FREJnlBatch: Record "FRE Jnl. Batch";
                    begin
                        if FREJournalTemplateName = '' then
                            Error(SelectFREBookFirstErr);

                        FREJnlBatch.SetRange("Journal Template Name", FREJournalTemplateName);
                        if Page.RunModal(0, FREJnlBatch) = Action::LookupOK then begin
                            Text := FREJnlBatch.Name;
                            FREJournalBatchName := FREJnlBatch.Name;
                            exit(true);
                        end;

                        exit(false);
                    end;

                    trigger OnValidate()
                    var
                        FREJnlBatch: Record "FRE Jnl. Batch";
                    begin
                        if FREJournalBatchName = '' then
                            exit;

                        FREJnlBatch.Get(FREJournalTemplateName, FREJournalBatchName);
                    end;
                }
            }

            group(GenJournalGroup)
            {
                Caption = 'Gen. Journal';
                Visible = not IsFREJournal;

                field(GenJournalTemplateName; GenJournalTemplateName)
                {
                    Caption = 'Libro';
                    ApplicationArea = All;

                    trigger OnLookup(var Text: Text): Boolean
                    var
                        GenJournalTemplate: Record "Gen. Journal Template";
                    begin
                        if Page.RunModal(0, GenJournalTemplate) = Action::LookupOK then begin
                            Text := GenJournalTemplate.name;
                            GenJournalTemplateName := GenJournalTemplate.Name;
                            GenJournalBatchName := '';
                            exit(true);
                        end;

                        exit(false);
                    end;

                    trigger OnValidate()
                    var
                        GenJournalTemplate: Record "Gen. Journal Template";
                    begin
                        if GenJournalTemplateName = '' then
                            exit;

                        GenJournalTemplate.Get(GenJournalTemplateName);
                        GenJournalBatchName := '';
                    end;
                }

                field(GenJournalBatchName; GenJournalBatchName)
                {
                    Caption = 'Sección';
                    ApplicationArea = All;

                    trigger OnLookup(var Text: Text): Boolean
                    var
                        GenJournalBatch: Record "Gen. Journal Batch";
                    begin
                        if GenJournalTemplateName = '' then
                            Error(SelectGenBookFirstErr);

                        GenJournalBatch.SetRange("Journal Template Name", GenJournalTemplateName);
                        if Page.RunModal(0, GenJournalBatch) = Action::LookupOK then begin
                            Text := GenJournalBatch.Name;
                            GenJournalBatchName := GenJournalBatch.Name;
                            exit(true);
                        end;

                        exit(false);
                    end;

                    trigger OnValidate()
                    var
                        GenJournalBatch: Record "Gen. Journal Batch";
                    begin
                        if GenJournalBatchName = '' then
                            exit;

                        GenJournalBatch.Get(GenJournalTemplateName, GenJournalBatchName);
                    end;
                }
            }
        }
    }

    trigger OnQueryClosePage(CloseAction: Action): Boolean
    begin
        if CloseAction <> Action::OK then
            exit(true);

        if IsFREJournal then begin
            if FREJournalTemplateName = '' then
                Error(FREBookRequiredErr);
            if FREJournalBatchName = '' then
                Error(FRESectionRequiredErr);
        end else begin
            if GenJournalTemplateName = '' then
                Error(GenBookRequiredErr);
            if GenJournalBatchName = '' then
                Error(GenSectionRequiredErr);
        end;

        exit(true);
    end;

    var
        IsFREJournal: Boolean;
        FREJournalTemplateName: Code[10];
        FREJournalBatchName: Code[10];
        GenJournalTemplateName: Code[10];
        GenJournalBatchName: Code[10];
        SelectFREBookFirstErr: Label 'Debes indicar antes el libro del diario FRE.';
        SelectGenBookFirstErr: Label 'Debes indicar antes el libro del diario general.';
        FREBookRequiredErr: Label 'Debes indicar el libro del diario FRE.';
        FRESectionRequiredErr: Label 'Debes indicar la sección del diario FRE.';
        GenBookRequiredErr: Label 'Debes indicar el libro del diario general.';
        GenSectionRequiredErr: Label 'Debes indicar la sección del diario general.';

    procedure SetFREJournalMode()
    begin
        IsFREJournal := true;
    end;

    procedure SetGenJournalMode()
    begin
        IsFREJournal := false;
    end;

    procedure GetTemplateName(): Code[10]
    begin
        if IsFREJournal then
            exit(FREJournalTemplateName);

        exit(GenJournalTemplateName);
    end;

    procedure GetBatchName(): Code[10]
    begin
        if IsFREJournal then
            exit(FREJournalBatchName);

        exit(GenJournalBatchName);
    end;
}
