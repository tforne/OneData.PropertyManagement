codeunit 96821 "SERPAVI Service Mgt."
{
    procedure OpenSerpaviForFixedRealEstate(var FixedRealEstate: Record "Fixed Real Estate")
    var
        SearchText: Text;
    begin
        EnsureSpanishRealEstate(FixedRealEstate);
        EnsureCadastralReference(FixedRealEstate);

        FixedRealEstate.CalcFields("Superficie construida");
        SearchText := GetPreferredSearchText(FixedRealEstate);

        HyperLink(GetConsultUrl());
        Message(
          SerpaviOpenedMsg,
          SearchText,
          Format(FixedRealEstate."Superficie construida"),
          FixedRealEstate."No.");
    end;

    local procedure EnsureSpanishRealEstate(FixedRealEstate: Record "Fixed Real Estate")
    begin
        if (FixedRealEstate."Country/Region Code" <> '') and (FixedRealEstate."Country/Region Code" <> 'ES') then
            Error(OnlySpainErr);
    end;

    local procedure EnsureCadastralReference(var FixedRealEstate: Record "Fixed Real Estate")
    begin
        if FixedRealEstate."Cadastral reference" <> '' then
            exit;

        if not TryUpdateFromCatastro(FixedRealEstate) then
            exit;
    end;

    [TryFunction]
    local procedure TryUpdateFromCatastro(var FixedRealEstate: Record "Fixed Real Estate")
    var
        CatastroServiceMgt: Codeunit "Catastro Service Mgt.";
    begin
        CatastroServiceMgt.UpdateFixedRealEstateFromCatastro(FixedRealEstate);
    end;

    local procedure GetPreferredSearchText(FixedRealEstate: Record "Fixed Real Estate"): Text
    begin
        if FixedRealEstate."Cadastral reference" <> '' then
            exit(FixedRealEstate."Cadastral reference");

        exit(ComposeAddressSearchText(FixedRealEstate));
    end;

    local procedure ComposeAddressSearchText(FixedRealEstate: Record "Fixed Real Estate"): Text
    begin
        exit(DelChr(
          StrSubstNo(
            '%1 %2 %3 %4',
            FixedRealEstate.Address,
            FixedRealEstate."Post Code",
            FixedRealEstate.City,
            FixedRealEstate.County),
          '<>',
          ' '));
    end;

    local procedure GetConsultUrl(): Text
    begin
        exit('https://serpavi.mivau.gob.es/serpavi/consultar');
    end;

    var
        OnlySpainErr: Label 'La consulta del índice oficial de alquiler solo está disponible para inmuebles en España.';
        SerpaviOpenedMsg: Label 'Se ha abierto SERPAVI en el navegador.\Dato recomendado para la búsqueda: %1\Superficie construida actual: %2 m2.\El portal oficial requiere validación interactiva, por lo que el resultado debe registrarse manualmente en "Precios índices de referencia" del inmueble %3.';
}
