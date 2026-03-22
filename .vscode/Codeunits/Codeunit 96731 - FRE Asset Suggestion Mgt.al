codeunit 96731 "FRE Asset Suggestion Mgt."
{
    procedure SuggestFixedRealEstate(var PreviewRec: Record "FRE Import Preview v2")
    var
        Rule: Record "FRE Asset Suggestion Rule";
        FixedRealEstate: Record "Fixed Real Estate";
        Pattern: Text[250];
    begin
        Pattern := NormalizeText(PreviewRec.Description);

        PreviewRec."Suggested FRE No." := '';
        PreviewRec."Suggested FRE Desc." := '';
        PreviewRec."Suggestion Confidence" := 0;
        PreviewRec."Suggestion Explanation" := '';

        if Pattern = '' then
            exit;

        // 1. Coincidencia exacta histórica
        Rule.Reset();
        Rule.SetRange(Pattern, Pattern);
        if Rule.FindFirst() then begin
            PreviewRec."Suggested FRE No." := Rule."Fixed Real Estate No.";
            if FixedRealEstate.Get(Rule."Fixed Real Estate No.") then
                PreviewRec."Suggested FRE Desc." := FixedRealEstate.Description;

            PreviewRec."Suggestion Confidence" := 100;
            PreviewRec."Suggestion Explanation" := 'Coincidencia exacta histórica';
            PreviewRec."Accept FRE Suggestion" := true;
            exit;
        end;

        // 2. Coincidencia directa con descripción del inmueble
        FixedRealEstate.Reset();
        if FixedRealEstate.FindSet() then
            repeat
                if (StrPos(NormalizeText(FixedRealEstate.Description), Pattern) > 0) or
                   (StrPos(Pattern, NormalizeText(FixedRealEstate.Description)) > 0) then begin
                    PreviewRec."Suggested FRE No." := FixedRealEstate."No.";
                    PreviewRec."Suggested FRE Desc." := FixedRealEstate.Description;
                    PreviewRec."Suggestion Confidence" := 70;
                    PreviewRec."Suggestion Explanation" := 'Coincidencia parcial con descripción de inmueble';
                    exit;
                end;
            until FixedRealEstate.Next() = 0;
    end;

    procedure LearnFromPreview(PreviewRec: Record "FRE Import Preview v2")
    var
        Rule: Record "FRE Asset Suggestion Rule";
        Pattern: Text[250];
        FRENo: Code[20];
    begin
        Pattern := NormalizeText(PreviewRec.Description);

        if Pattern = '' then
            exit;

        FRENo := PreviewRec."Fixed Real Estate No.";
        if FRENo = '' then
            FRENo := PreviewRec."Suggested FRE No.";

        if FRENo = '' then
            exit;

        Rule.Reset();
        Rule.SetRange(Pattern, Pattern);

        if Rule.FindFirst() then begin
            Rule."Fixed Real Estate No." := FRENo;
            Rule."Hit Count" += 1;
            Rule."Last Used Date" := Today;
            Rule.Modify();
        end else begin
            Rule.Init();
            Rule.Pattern := Pattern;
            Rule."Fixed Real Estate No." := FRENo;
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
        exit(Result);
    end;
}