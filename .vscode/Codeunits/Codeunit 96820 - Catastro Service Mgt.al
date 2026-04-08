codeunit 96820 "Catastro Service Mgt."
{
    procedure UpdateFixedRealEstateFromCatastro(var FixedRealEstate: Record "Fixed Real Estate")
    var
        ResponseJson: JsonObject;
    begin
        if FixedRealEstate."Cadastral reference" <> '' then
            ResponseJson := QueryByReference(FixedRealEstate)
        else
            ResponseJson := QueryByAddress(FixedRealEstate);

        ApplyCatastroData(FixedRealEstate, ResponseJson);
    end;

    local procedure QueryByReference(FixedRealEstate: Record "Fixed Real Estate"): JsonObject
    var
        Url: Text;
    begin
        Url := StrSubstNo(
            '%1/Consulta_DNPRC?RefCat=%2',
            GetReferenceBaseUrl(),
            DelChr(FixedRealEstate."Cadastral reference", '=', ' '));

        exit(ExecuteGet(Url, 'consulta_dnprcResult'));
    end;

    local procedure QueryByAddress(FixedRealEstate: Record "Fixed Real Estate"): JsonObject
    var
        ProvinceCode: Code[10];
        MunicipalityCode: Code[10];
        StreetCode: Code[20];
        StreetNumber: Text[20];
        Url: Text;
    begin
        ProvinceCode := GetProvinceCode(FixedRealEstate);
        MunicipalityCode := GetMunicipalityCode(FixedRealEstate, ProvinceCode);
        StreetCode := GetStreetCode(FixedRealEstate, ProvinceCode, MunicipalityCode);
        StreetNumber := GetStreetNumber(FixedRealEstate);

        Url := StrSubstNo(
            '%1/Consulta_DNPLOC_Codigos?CodigoProvincia=%2&CodigoMunicipio=%3&CodigoVia=%4&Numero=%5',
            GetBaseUrl(),
            ProvinceCode,
            MunicipalityCode,
            StreetCode,
            StreetNumber);

        exit(ExecuteGet(Url, 'consulta_dnplocResult'));
    end;

    local procedure ExecuteGet(Url: Text; RootName: Text): JsonObject
    var
        Client: HttpClient;
        ResponseMessage: HttpResponseMessage;
        ResponseText: Text;
        RootJson: JsonObject;
        ResultJson: JsonObject;
    begin
        if not Client.Get(Url, ResponseMessage) then
            Error('No se ha podido conectar con el servicio del Catastro.');

        if not ResponseMessage.IsSuccessStatusCode() then
            Error('El servicio del Catastro devolvió el código %1.', ResponseMessage.HttpStatusCode());

        ResponseMessage.Content().ReadAs(ResponseText);
        RootJson.ReadFrom(ResponseText);

        if not TryGetObject(RootJson, RootName, ResultJson) then
            Error('Respuesta no válida del servicio del Catastro.');

        RaiseServiceErrors(ResultJson);
        exit(ResultJson);
    end;

    local procedure ApplyCatastroData(var FixedRealEstate: Record "Fixed Real Estate"; ResponseJson: JsonObject)
    var
        BicoJson: JsonObject;
        BiJson: JsonObject;
        IdBiJson: JsonObject;
        RcJson: JsonObject;
        DtJson: JsonObject;
        FincaJson: JsonObject;
        InfoGrafJson: JsonObject;
        LocsJson: JsonObject;
        LousJson: JsonObject;
        LourbJson: JsonObject;
        DirJson: JsonObject;
        FullReference: Text;
        StreetType: Text;
        StreetName: Text;
        StreetNumber: Text;
        PostCodeTxt: Text;
        CityTxt: Text;
        CountyTxt: Text;
        CatastroUrl: Text;
    begin
        if not TryGetObject(ResponseJson, 'bico', BicoJson) then
            Error('El Catastro no ha devuelto datos del inmueble.');
        if not TryGetObject(BicoJson, 'bi', BiJson) then
            Error('El Catastro no ha devuelto datos del bien.');
        if not TryGetObject(BiJson, 'idbi', IdBiJson) then
            Error('El Catastro no ha devuelto la identificación del bien.');
        if not TryGetObject(IdBiJson, 'rc', RcJson) then
            Error('El Catastro no ha devuelto la referencia catastral.');

        FullReference :=
            GetText(RcJson, 'pc1') +
            GetText(RcJson, 'pc2') +
            GetText(RcJson, 'car') +
            GetText(RcJson, 'cc1') +
            GetText(RcJson, 'cc2');

        if TryGetObject(BiJson, 'dt', DtJson) and
           TryGetObject(DtJson, 'locs', LocsJson) and
           TryGetObject(LocsJson, 'lous', LousJson) and
           TryGetObject(LousJson, 'lourb', LourbJson) and
           TryGetObject(LourbJson, 'dir', DirJson) then begin
            StreetType := GetText(DirJson, 'tv');
            StreetName := GetText(DirJson, 'nv');
            StreetNumber := GetText(DirJson, 'pnp');
            PostCodeTxt := GetText(LourbJson, 'dp');
            CityTxt := GetText(DtJson, 'nm');
            CountyTxt := GetText(DtJson, 'np');
        end;

        if TryGetObject(BicoJson, 'finca', FincaJson) and
           TryGetObject(FincaJson, 'infgraf', InfoGrafJson) then
            CatastroUrl := GetText(InfoGrafJson, 'igraf');

        if FullReference <> '' then
            FixedRealEstate.Validate("Cadastral reference", CopyStr(FullReference, 1, MaxStrLen(FixedRealEstate."Cadastral reference")));

        if (StreetType <> '') or (StreetName <> '') or (StreetNumber <> '') then begin
            FixedRealEstate.Address := CopyStr(ComposeAddressText(StreetType, StreetName, StreetNumber), 1, MaxStrLen(FixedRealEstate.Address));
            if FixedRealEstate."Street Name" = '' then
                FixedRealEstate."Street Name" := CopyStr(StreetName, 1, MaxStrLen(FixedRealEstate."Street Name"));
            if FixedRealEstate."Number On Street" = '' then
                FixedRealEstate."Number On Street" := CopyStr(StreetNumber, 1, MaxStrLen(FixedRealEstate."Number On Street"));
        end;

        if FixedRealEstate."Country/Region Code" = '' then
            FixedRealEstate.Validate("Country/Region Code", 'ES');
        if PostCodeTxt <> '' then
            FixedRealEstate.Validate("Post Code", CopyStr(PostCodeTxt, 1, MaxStrLen(FixedRealEstate."Post Code")));
        if CityTxt <> '' then
            FixedRealEstate.Validate(City, CopyStr(CityTxt, 1, MaxStrLen(FixedRealEstate.City)));
        if CountyTxt <> '' then
            FixedRealEstate.County := CopyStr(CountyTxt, 1, MaxStrLen(FixedRealEstate.County));
        if CatastroUrl <> '' then
            FixedRealEstate."URL Sede electrónica catastro" := CopyStr(CatastroUrl, 1, MaxStrLen(FixedRealEstate."URL Sede electrónica catastro"));

        FixedRealEstate.Modify(true);
    end;

    local procedure GetProvinceCode(FixedRealEstate: Record "Fixed Real Estate"): Code[10]
    begin
        if StrLen(FixedRealEstate."Post Code") >= 2 then
            exit(CopyStr(FixedRealEstate."Post Code", 1, 2));

        Error('Debe informar el código postal del inmueble para consultar el Catastro.');
    end;

    local procedure GetMunicipalityCode(FixedRealEstate: Record "Fixed Real Estate"; ProvinceCode: Code[10]): Code[10]
    var
        ResponseJson: JsonObject;
        MunicipalityArray: JsonArray;
        MunicipalityToken: JsonToken;
        MunicipalityJson: JsonObject;
        CandidateName: Text;
        SearchName: Text;
    begin
        SearchName := NormalizeText(FixedRealEstate.City);
        if SearchName = '' then
            Error('Debe informar la ciudad del inmueble para consultar el Catastro.');

        ResponseJson := ExecuteGet(
            StrSubstNo('%1/ObtenerMunicipiosCodigos?CodigoProvincia=%2', GetBaseUrl(), ProvinceCode),
            'consulta_municipieroResult');

        if not TryGetArrayFromObjectPath(ResponseJson, 'municipiero', 'muni', MunicipalityArray) then
            Error('No se han podido obtener los municipios del Catastro.');

        foreach MunicipalityToken in MunicipalityArray do begin
            MunicipalityJson := MunicipalityToken.AsObject();
            CandidateName := NormalizeText(GetText(MunicipalityJson, 'nm'));
            if CandidateName = SearchName then
                exit(GetNestedText(MunicipalityJson, 'locat', 'cmc'));
        end;

        Error('No se ha encontrado un municipio del Catastro que coincida con "%1".', FixedRealEstate.City);
    end;

    local procedure GetStreetCode(FixedRealEstate: Record "Fixed Real Estate"; ProvinceCode: Code[10]; MunicipalityCode: Code[10]): Code[20]
    var
        ResponseJson: JsonObject;
        StreetArray: JsonArray;
        StreetToken: JsonToken;
        StreetJson: JsonObject;
        DirJson: JsonObject;
        SearchStreetName: Text;
        CandidateStreetName: Text;
    begin
        SearchStreetName := GetStreetSearchName(FixedRealEstate);
        if SearchStreetName = '' then
            Error('Debe informar la calle del inmueble para consultar el Catastro.');

        ResponseJson := ExecuteGet(
            StrSubstNo('%1/ObtenerCallejeroCodigos?CodigoProvincia=%2&CodigoMunicipio=%3', GetBaseUrl(), ProvinceCode, MunicipalityCode),
            'consulta_callejeroResult');

        if not TryGetArrayFromObjectPath(ResponseJson, 'callejero', 'calle', StreetArray) then
            Error('No se han podido obtener las calles del Catastro.');

        foreach StreetToken in StreetArray do begin
            StreetJson := StreetToken.AsObject();
            if not TryGetObject(StreetJson, 'dir', DirJson) then
                continue;

            CandidateStreetName := NormalizeText(GetText(DirJson, 'nv'));
            if (CandidateStreetName = SearchStreetName) or
               (StrPos(CandidateStreetName, SearchStreetName) > 0) or
               (StrPos(SearchStreetName, CandidateStreetName) > 0) then
                exit(GetText(DirJson, 'cv'));
        end;

        Error('No se ha encontrado una vía del Catastro que coincida con "%1".', GetStreetSearchName(FixedRealEstate));
    end;

    local procedure GetStreetNumber(FixedRealEstate: Record "Fixed Real Estate"): Text[20]
    begin
        if FixedRealEstate."Number On Street" = '' then
            Error('Debe informar el número de la calle del inmueble para consultar el Catastro.');

        exit(CopyStr(DelChr(FixedRealEstate."Number On Street", '=', ' '), 1, 20));
    end;

    local procedure RaiseServiceErrors(ResponseJson: JsonObject)
    var
        ErrorArray: JsonArray;
        ErrorToken: JsonToken;
        ErrorJson: JsonObject;
        ErrorText: Text;
    begin
        if TryGetArray(ResponseJson, 'lerr', ErrorArray) then
            foreach ErrorToken in ErrorArray do begin
                ErrorJson := ErrorToken.AsObject();
                ErrorText := GetText(ErrorJson, 'des');
                if ErrorText <> '' then
                    Error('Catastro: %1', ErrorText);
            end;
    end;

    local procedure GetBaseUrl(): Text
    begin
        exit('https://ovc.catastro.meh.es/OVCServWeb/OVCWcfCallejero/COVCCallejeroCodigos.svc/json');
    end;

    local procedure GetReferenceBaseUrl(): Text
    begin
        exit('https://ovc.catastro.meh.es/OVCServWeb/OVCWcfCallejero/COVCCallejero.svc/json');
    end;

    local procedure GetStreetSearchName(FixedRealEstate: Record "Fixed Real Estate"): Text
    begin
        if FixedRealEstate."Street Name" <> '' then
            exit(NormalizeText(FixedRealEstate."Street Name"));

        exit(NormalizeText(FixedRealEstate.Address));
    end;

    local procedure ComposeAddressText(StreetType: Text; StreetName: Text; StreetNumber: Text): Text
    begin
        exit(DelChr(StrSubstNo('%1 %2 %3', StreetType, StreetName, StreetNumber), '<>', ' '));
    end;

    local procedure NormalizeText(InputText: Text): Text
    begin
        InputText := UpperCase(InputText);
        InputText := ConvertStr(InputText, 'ÁÀÄÂÉÈËÊÍÌÏÎÓÒÖÔÚÙÜÛÑÇ', 'AAAAEEEEIIIIOOOOUUUUNC');
        InputText := DelChr(InputText, '=', '.,-/()[]{}''"');
        InputText := DelChr(InputText, '<>', ' ');
        exit(InputText);
    end;

    local procedure TryGetObject(ParentJson: JsonObject; PropertyName: Text; var ChildJson: JsonObject): Boolean
    var
        Token: JsonToken;
    begin
        if not ParentJson.Get(PropertyName, Token) then
            exit(false);
        if not Token.IsObject() then
            exit(false);
        ChildJson := Token.AsObject();
        exit(true);
    end;

    local procedure TryGetArray(ParentJson: JsonObject; PropertyName: Text; var ChildArray: JsonArray): Boolean
    var
        Token: JsonToken;
    begin
        if not ParentJson.Get(PropertyName, Token) then
            exit(false);
        if not Token.IsArray() then
            exit(false);
        ChildArray := Token.AsArray();
        exit(true);
    end;

    local procedure TryGetArrayFromObjectPath(ParentJson: JsonObject; ObjectPropertyName: Text; ArrayPropertyName: Text; var ChildArray: JsonArray): Boolean
    var
        ChildObject: JsonObject;
    begin
        if not TryGetObject(ParentJson, ObjectPropertyName, ChildObject) then
            exit(false);
        exit(TryGetArray(ChildObject, ArrayPropertyName, ChildArray));
    end;

    local procedure GetText(ParentJson: JsonObject; PropertyName: Text): Text
    var
        Token: JsonToken;
    begin
        if not ParentJson.Get(PropertyName, Token) then
            exit('');
        if not Token.IsValue() then
            exit('');
        exit(Token.AsValue().AsText());
    end;

    local procedure GetNestedText(ParentJson: JsonObject; ObjectPropertyName: Text; PropertyName: Text): Text
    var
        ChildObject: JsonObject;
    begin
        if not TryGetObject(ParentJson, ObjectPropertyName, ChildObject) then
            exit('');
        exit(GetText(ChildObject, PropertyName));
    end;
}
