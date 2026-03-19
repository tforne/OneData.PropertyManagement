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

        Rule.Reset();
        Rule.SetRange(Pattern, Pattern);

        if Rule.FindFirst() then begin
            PreviewRec."Row No." := Rule."Row No.";
            PreviewRec."Suggested Source Type" := Rule."Source Type";
            PreviewRec."Suggested Source No." := Rule."Source No.";
            PreviewRec."Suggestion Confidence" := 100;
            PreviewRec."Suggestion Explanation" := 'Coincidencia exacta histórica';
            exit;
        end;

        // búsqueda por coincidencia parcial
        Rule.Reset();
        if Rule.FindSet() then
            repeat
                if StrPos(Pattern, Rule.Pattern) > 0 then begin
                    PreviewRec."Row No." := Rule."Row No.";
                    PreviewRec."Suggested Source Type" := Rule."Source Type";
                    PreviewRec."Suggested Source No." := Rule."Source No.";
                    PreviewRec."Suggestion Confidence" := 70;
                    PreviewRec."Suggestion Explanation" := 'Coincidencia parcial';
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

        Rule.Reset();
        Rule.SetRange(Pattern, Pattern);

        if Rule.FindFirst() then begin
            Rule."Hit Count" += 1;
            Rule."Last Used Date" := Today;
            Rule.Modify();
        end else begin
            Rule.Init();
            Rule.Pattern := Pattern;
            Rule."Row No." := PreviewRec."Row No.";
            Rule."Source Type" := PreviewRec."Suggested Source Type";
            Rule."Source No." := PreviewRec."Suggested Source No.";
            Rule."Hit Count" := 1;
            Rule."Last Used Date" := Today;
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