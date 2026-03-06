codeunit 96007 "Journals Management"
{

    var
        GLSetup: Record "General Ledger Setup";
        NextEntryNo: integer;
        PostLineGenJnl: Codeunit "Gen. Jnl.-Post Line";
        OpenFromBatch : Boolean;
        Text000	: Label	'FRE';
        Text001	 :Label 'Diario FRE';
        Text002	: label 'GENERICO';
        Text003	: label 'Diario genérico';


    procedure OpenJnlBatch(var FREJnlBatch: Record "FRE Jnl. Batch")
    var
        FREJnlTemplate: Record "FRE Jnl. Template";
        FREJnlLine: Record "FRE Jnl. Line";
        JnlSelected: Boolean;
    begin
        IF FREJnlBatch.GETFILTER("Journal Template Name") <> '' THEN
            EXIT;
        FREJnlBatch.FILTERGROUP(2);
        IF FREJnlBatch.GETFILTER("Journal Template Name") <> '' THEN BEGIN
            FREJnlBatch.FILTERGROUP(0);
            EXIT;
        END;
        FREJnlBatch.FILTERGROUP(0);

        IF NOT FREJnlBatch.FIND('-') THEN BEGIN
            IF NOT FREJnlTemplate.FINDFIRST THEN
                TemplateSelection(0, FREJnlLine, JnlSelected);
            IF FREJnlTemplate.FINDFIRST THEN
                CheckTemplateName(FREJnlTemplate.Name, FREJnlBatch.Name);
        END;
        FREJnlBatch.FIND('-');
        JnlSelected := TRUE;
        IF FREJnlBatch.GETFILTER("Journal Template Name") <> '' THEN
            FREJnlTemplate.SETRANGE(Name, FREJnlBatch.GETFILTER("Journal Template Name"));
        CASE FREJnlTemplate.COUNT OF
            1:
                FREJnlTemplate.FINDFIRST;
            ELSE
                JnlSelected := PAGE.RUNMODAL(0, FREJnlTemplate) = ACTION::LookupOK;
        END;
        IF NOT JnlSelected THEN
            ERROR('');

        FREJnlBatch.FILTERGROUP(2);
        FREJnlBatch.SETRANGE("Journal Template Name", FREJnlTemplate.Name);
        FREJnlBatch.FILTERGROUP(0);
    end;
    procedure TemplateSelectionFromBatch(var FREJnlBatch: Record "FRE Jnl. Batch")
    var
        FREJnlLine: Record "FRE Jnl. Line";
        FREJnlTemplate: Record "FRE Jnl. Template";
    begin
        OpenFromBatch := TRUE;
        FREJnlTemplate.GET(FREJnlBatch."Journal Template Name");
        FREJnlTemplate.TESTFIELD("Page ID");
        FREJnlBatch.TESTFIELD(Name);

        FREJnlLine.FILTERGROUP := 2;
        FREJnlLine.SETRANGE("Journal Template Name", FREJnlTemplate.Name);
        FREJnlLine.FILTERGROUP := 0;

        FREJnlLine."Journal Template Name" := '';
        FREJnlLine."Journal Batch Name" := FREJnlBatch.Name;
        PAGE.RUN(FREJnlTemplate."Page ID", FREJnlLine);
    end;

    procedure TemplateSelection(PageID: Integer; var FREJnlLine: Record "FRE Jnl. Line"; var JnlSelected: Boolean)
    var
        FREJnlTemplate: Record "FRE Jnl. Template";
    begin
        JnlSelected := TRUE;

        FREJnlTemplate.RESET;
        FREJnlTemplate.SETRANGE("Page ID", PageID);

        CASE FREJnlTemplate.COUNT OF
            0:
                BEGIN
                    FREJnlTemplate.INIT;
                    FREJnlTemplate.Name := Text000;
                    FREJnlTemplate.Description := Text001;
                    FREJnlTemplate.VALIDATE("Page ID");
                    if FREJnlTemplate.INSERT then;
                    COMMIT;
                END;
            1:
                FREJnlTemplate.FINDFIRST;
            ELSE
                JnlSelected := PAGE.RUNMODAL(0, FREJnlTemplate) = ACTION::LookupOK;
        END;
        IF JnlSelected THEN BEGIN
            FREJnlLine.FILTERGROUP(2);
            FREJnlLine.SETRANGE("Journal Template Name", FREJnlTemplate.Name);
            FREJnlLine.FILTERGROUP(0);
            IF OpenFromBatch THEN BEGIN
                FREJnlLine."Journal Template Name" := '';
                PAGE.RUN(FREJnlTemplate."Page ID", FREJnlLine);
            END;
        END;
    end;
    local procedure CheckTemplateName(CurrentJnlTemplateName: Code[10]; var CurrentJnlBatchName: Code[10])
    var
        FREJnlTemplate: Record "FRE Jnl. Template";
        FREJnlBatch: Record "FRE Jnl. Batch";
    begin
        FREJnlBatch.SETRANGE("Journal Template Name", CurrentJnlTemplateName);
        IF NOT FREJnlBatch.GET(CurrentJnlTemplateName, CurrentJnlBatchName) THEN BEGIN
            IF NOT FREJnlBatch.FINDFIRST THEN BEGIN
                FREJnlTemplate.GET(CurrentJnlTemplateName);
                FREJnlBatch.INIT;
                FREJnlBatch."Journal Template Name" := FREJnlTemplate.Name;
                FREJnlBatch.Name := Text002;
                FREJnlBatch.Description := Text003;
                FREJnlBatch.INSERT;
                COMMIT;
            END;
            CurrentJnlBatchName := FREJnlBatch.Name;
        END;
    end;
    procedure LookupName(CurrentJnlTemplateName: Code[10]; CurrentJnlBatchName: Code[10]; var EntrdJnlBatchName: Text[10]): Boolean
    var
        FREJnlBatch: Record "FRE Jnl. Batch";
    begin
        FREJnlBatch."Journal Template Name" := CurrentJnlTemplateName;
        FREJnlBatch.Name := CurrentJnlBatchName;
        FREJnlBatch.FILTERGROUP(2);
        FREJnlBatch.SETRANGE("Journal Template Name", CurrentJnlTemplateName);
        FREJnlBatch.FILTERGROUP(0);
        IF PAGE.RUNMODAL(0, FREJnlBatch) <> ACTION::LookupOK THEN
            EXIT(FALSE);

        EntrdJnlBatchName := FREJnlBatch.Name;
        EXIT(TRUE);
    end;
    procedure CheckName(CurrentJnlBatchName: Code[10]; var FREJnlLine: Record "FRE Jnl. Line")
    var
        FREJnlBatch: Record "FRE Jnl. Batch";
    begin
        FREJnlBatch.GET(FREJnlLine.GETRANGEMAX("Journal Template Name"), CurrentJnlBatchName);
    end;

    procedure SetName(CurrentJnlBatchName: Code[10]; var FREJnlLine: Record "FRE Jnl. Line")
    begin
        FREJnlLine.FILTERGROUP(2);
        FREJnlLine.SETRANGE("Journal Batch Name", CurrentJnlBatchName);
        FREJnlLine.FILTERGROUP(0);
        IF FREJnlLine.FIND('-') THEN;
    end;
    procedure OpenJnl(var CurrentJnlBatchName: Code[10]; var FREJnlLine: Record "FRE Jnl. Line")
    begin
        CheckTemplateName(FREJnlLine.GETRANGEMAX("Journal Template Name"), CurrentJnlBatchName);
        FREJnlLine.FILTERGROUP(2);
        FREJnlLine.SETRANGE("Journal Batch Name", CurrentJnlBatchName);
        FREJnlLine.FILTERGROUP(0);
    end;

}