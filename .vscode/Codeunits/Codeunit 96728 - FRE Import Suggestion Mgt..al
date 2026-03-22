codeunit 96728 "FRE Import Suggestion Mgt."
{

    procedure SuggestValues(var PreviewRec: Record "FRE Import Preview v2")
    var
        Pattern: Text[250];
        Rule: Record "FRE Import Suggestion Rule";
    begin
        Pattern := NormalizeText(PreviewRec.Description);

        if Pattern = '' then
            exit;

        // Limpiar sugerencias previas
        Clear(PreviewRec."Suggested Source Type");
        PreviewRec."Suggested Source No." := '';
        PreviewRec."Suggestion Confidence" := 0;
        PreviewRec."Suggestion Explanation" := '';

        Rule.Reset();
        Rule.SetRange(Pattern, Pattern);

        if Rule.FindFirst() then begin
            PreviewRec."Suggested Source Type" := Rule."Source Type";
            PreviewRec."Suggested Source No." := Rule."Source No.";
            PreviewRec."Suggestion Confidence" := 100;
            PreviewRec."Suggestion Explanation" := 'Coincidencia exacta histórica';

            if PreviewRec."Suggested Source No." <> '' then
                PreviewRec."Accept Suggestion" := true;

            exit;
        end;

        Rule.Reset();
        if Rule.FindSet() then
            repeat
                if (StrPos(Pattern, Rule.Pattern) > 0) or (StrPos(Rule.Pattern, Pattern) > 0) then begin
                    PreviewRec."Suggested Source Type" := Rule."Source Type";
                    PreviewRec."Suggested Source No." := Rule."Source No.";
                    PreviewRec."Suggestion Confidence" := 70;
                    PreviewRec."Suggestion Explanation" := 'Coincidencia parcial';

                    if PreviewRec."Suggested Source No." <> '' then
                        PreviewRec."Accept Suggestion" := true;

                    exit;
                end;
            until Rule.Next() = 0;
    end;
    
    procedure LearnFromLine(PreviewRec: Record "FRE Import Preview v2")
    var
        Rule: Record "FRE Import Suggestion Rule";
        Pattern: Text[250];
    begin
        Pattern := NormalizeText(PreviewRec.Description);

        if Pattern = '' then
            exit;

        if (PreviewRec."Suggested Source No." = '') and (PreviewRec."Source No." = '') then
            exit;

        Rule.Reset();
        Rule.SetRange(Pattern, Pattern);

        if Rule.FindFirst() then begin
            Rule."Hit Count" += 1;
            Rule."Last Used Date" := Today;

            if PreviewRec."Source No." <> '' then begin
                Rule."Source Type" := PreviewRec."Suggested Source Type";
                Rule."Source No." := PreviewRec."Source No.";
            end else begin
                Rule."Source Type" := PreviewRec."Suggested Source Type";
                Rule."Source No." := PreviewRec."Suggested Source No.";
            end;

            Rule.Modify();
        end else begin
            Rule.Init();
            Rule.Pattern := Pattern;
            Rule."Hit Count" := 1;
            Rule."Last Used Date" := Today;

            if PreviewRec."Source No." <> '' then begin
                Rule."Source Type" := PreviewRec."Suggested Source Type";
                Rule."Source No." := PreviewRec."Source No.";
            end else begin
                Rule."Source Type" := PreviewRec."Suggested Source Type";
                Rule."Source No." := PreviewRec."Suggested Source No.";
            end;

            Rule.Insert();
        end;
    end;

    local procedure NormalizeText(InputText: Text[250]): Text[250]
    var
        Result: Text[250];
    begin
        Result := UpperCase(InputText);

        Result := DelChr(Result, '=', '.,;:-_/\()[]{}');

        // eliminar palabras comunes (muy básico)
        Result := ConvertStr(Result, '  ', ' ');

        exit(Result);
    end;
}