codeunit 96013 "FRE Jnl.-Post Batch"
{
    procedure RunCheck(var FREJnlLine: Record "FRE Jnl. Line")
    var
        BatchLine: Record "FRE Jnl. Line";
        FREJnlCheckLine: Codeunit "FRE Jnl.-Check Line";
    begin
        BatchLine.Reset();
        BatchLine.SetRange("Journal Template Name", FREJnlLine."Journal Template Name");
        BatchLine.SetRange("Journal Batch Name", FREJnlLine."Journal Batch Name");

        if not BatchLine.FindSet() then
            Error('No hay líneas para validar.');

        repeat
            FREJnlCheckLine.RunCheck(BatchLine);
        until BatchLine.Next() = 0;

        Message('Validación completada correctamente.');
    end;

    procedure RunPost(var FREJnlLine: Record "FRE Jnl. Line")
    var
        BatchLine: Record "FRE Jnl. Line";
        FREJnlCheckLine: Codeunit "FRE Jnl.-Check Line";
        FREJnlPostLine: Codeunit "FRE Jnl.-Post Line";
        CountPosted: Integer;
    begin
        BatchLine.Reset();
        BatchLine.SetRange("Journal Template Name", FREJnlLine."Journal Template Name");
        BatchLine.SetRange("Journal Batch Name", FREJnlLine."Journal Batch Name");

        if not BatchLine.FindSet(true) then
            Error('No hay líneas para registrar.');

        // 1. Validar todas primero
        repeat
            FREJnlCheckLine.RunCheck(BatchLine);
        until BatchLine.Next() = 0;

        // 2. Registrar
        BatchLine.Reset();
        BatchLine.SetRange("Journal Template Name", FREJnlLine."Journal Template Name");
        BatchLine.SetRange("Journal Batch Name", FREJnlLine."Journal Batch Name");

        if BatchLine.FindSet(true) then
            repeat
                FREJnlPostLine.PostLine(BatchLine);
                CountPosted += 1;
            until BatchLine.Next() = 0;

        Message('Registro completado correctamente. Se han registrado %1 líneas.', CountPosted);
    end;
}