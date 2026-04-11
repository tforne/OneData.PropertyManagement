codeunit 96824 "INE Rental Index Mgt."
{
    Permissions = tabledata "Consumer Price Index" = rimd,
                  tabledata "Consumer Price Index Categorie" = rimd,
                  tabledata "Price Increases by Refer index" = rimd;

    procedure EnsureOfficialCategories()
    begin
        EnsureCategory('IPC', 'IPC');
        EnsureCategory('IRAV', 'IRAV');
    end;

    procedure PrepareContractRentalReview(var LeaseContract: Record "Lease Contract"; var PriceIncreaseWorksheet: Record "Price Increases by Refer index")
    var
        IncrementPct: Decimal;
        ReviewYear: Integer;
        ReviewPeriodText: Text;
        BaseAmount: Decimal;
    begin
        LeaseContract.TestField("Contract No.");

        EnsureOfficialCategories();
        EnsureOrInferContractCategory(LeaseContract);
        RefreshOfficialIndexValue(LeaseContract."Consumer Price Index Category", IncrementPct, ReviewYear, ReviewPeriodText);

        BaseAmount := GetContractBaseAmount(LeaseContract);
        if BaseAmount = 0 then
            Error(NoBaseAmountErr, LeaseContract."Contract No.");

        UpsertConsumerPriceIndex(LeaseContract."Consumer Price Index Category", ReviewYear, IncrementPct);
        UpsertWorksheetSuggestion(LeaseContract, ReviewYear, ReviewPeriodText, IncrementPct, BaseAmount, PriceIncreaseWorksheet);
    end;

    local procedure RefreshOfficialIndexValue(CategoryCode: Code[10]; var IncrementPct: Decimal; var ReviewYear: Integer; var ReviewPeriodText: Text)
    begin
        case UpperCase(CategoryCode) of
            'IPC':
                FetchLatestIpc(IncrementPct, ReviewYear, ReviewPeriodText);
            'IRAV':
                FetchLatestIrav(IncrementPct, ReviewYear, ReviewPeriodText);
            else
                Error(UnsupportedCategoryErr, CategoryCode);
        end;
    end;

    local procedure EnsureOrInferContractCategory(var LeaseContract: Record "Lease Contract")
    var
        InferredCategory: Code[10];
        ReferenceDate: Date;
    begin
        if LeaseContract."Consumer Price Index Category" <> '' then
            exit;

        ReferenceDate := LeaseContract."Contract Date";
        if ReferenceDate = 0D then
            ReferenceDate := LeaseContract."Starting Date";

        if (ReferenceDate <> 0D) and (ReferenceDate >= DMY2Date(26, 5, 2023)) then
            InferredCategory := 'IRAV'
        else
            InferredCategory := 'IPC';

        LeaseContract.Validate("Consumer Price Index Category", InferredCategory);
        LeaseContract.Modify();
    end;

    local procedure FetchLatestIpc(var IncrementPct: Decimal; var ReviewYear: Integer; var ReviewPeriodText: Text)
    var
        ResponseText: Text;
        ExtractedText: Text;
        PivotPos: Integer;
        ValueText: Text;
    begin
        ResponseText := DownloadText(IpcSourceUrl);
        ExtractedText := GetTextBetweenCaseInsensitive(ResponseText, 'se situó en ', '% de variación interanual');
        if ExtractedText = '' then
            Error(IpcFormatErr);

        PivotPos := GetLastCaseInsensitivePosition(ExtractedText, ' en el ');
        if PivotPos = 0 then
            Error(IpcFormatErr);

        ReviewPeriodText := CopyStr(ExtractedText, 1, PivotPos - 1);
        ValueText := CopyStr(ExtractedText, PivotPos + StrLen(' en el '));

        if not TryParseDecimalFlexible(ValueText, IncrementPct) then
            Error(IpcValueErr, ValueText);

        ReviewYear := ExtractYearFromText(ReviewPeriodText);
        if ReviewYear = 0 then
            ReviewYear := Date2DMY(WorkDate(), 3);
    end;

    local procedure FetchLatestIrav(var IncrementPct: Decimal; var ReviewYear: Integer; var ReviewPeriodText: Text)
    var
        ResponseText: Text;
        StartPos: Integer;
        NextPos: Integer;
        ValueText: Text;
    begin
        ResponseText := DownloadText(IravCsvUrl);
        StartPos := GetCaseInsensitivePosition(ResponseText, 'Total Variación anual;');
        if StartPos = 0 then
            Error(IravFormatErr);

        StartPos += StrLen('Total Variación anual;');
        ReviewPeriodText := ReadToken(ResponseText, StartPos, ';', NextPos);
        ValueText := ReadToken(ResponseText, NextPos + 1, ';', NextPos);

        if (ReviewPeriodText = '') or (ValueText = '') then
            Error(IravFormatErr);
        if not TryParseDecimalFlexible(ValueText, IncrementPct) then
            Error(IravValueErr, ValueText);

        ReviewYear := ExtractYearFromText(ReviewPeriodText);
        if ReviewYear = 0 then
            ReviewYear := Date2DMY(WorkDate(), 3);
    end;

    local procedure DownloadText(Url: Text): Text
    var
        Client: HttpClient;
        Response: HttpResponseMessage;
        ResponseText: Text;
    begin
        if not Client.Get(Url, Response) then
            Error(ConnectionErr, Url);
        if not Response.IsSuccessStatusCode() then
            Error(HttpStatusErr, Url, Response.HttpStatusCode());

        Response.Content().ReadAs(ResponseText);
        if ResponseText = '' then
            Error(EmptyResponseErr, Url);

        exit(ResponseText);
    end;

    local procedure EnsureCategory(CategoryCode: Code[10]; Description: Text[30])
    var
        Category: Record "Consumer Price Index Categorie";
    begin
        if Category.Get(CategoryCode) then begin
            if Category.Description <> Description then begin
                Category.Description := Description;
                Category.Modify();
            end;
            exit;
        end;

        Category.Init();
        Category."Con. Price Index Category Code" := CategoryCode;
        Category.Description := Description;
        Category.Insert();
    end;

    local procedure UpsertConsumerPriceIndex(CategoryCode: Code[10]; ReviewYear: Integer; IncrementPct: Decimal)
    var
        ConsumerPriceIndex: Record "Consumer Price Index";
    begin
        if ConsumerPriceIndex.Get(CategoryCode, ReviewYear) then begin
            if ConsumerPriceIndex."% Increment" <> IncrementPct then begin
                ConsumerPriceIndex."% Increment" := IncrementPct;
                ConsumerPriceIndex.Modify();
            end;
            exit;
        end;

        ConsumerPriceIndex.Init();
        ConsumerPriceIndex."Consumer Price Index Category" := CategoryCode;
        ConsumerPriceIndex.Year := ReviewYear;
        ConsumerPriceIndex."% Increment" := IncrementPct;
        ConsumerPriceIndex.Insert();
    end;

    local procedure GetContractBaseAmount(LeaseContract: Record "Lease Contract"): Decimal
    var
        LeaseContractLine: Record "Lease Contract Line";
        BaseAmount: Decimal;
    begin
        LeaseContractLine.Reset();
        LeaseContractLine.SetRange("Contract No.", LeaseContract."Contract No.");
        LeaseContractLine.SetRange("Aplicar incrementos", true);
        if LeaseContractLine.FindSet() then
            repeat
                BaseAmount += LeaseContractLine.Amount;
            until LeaseContractLine.Next() = 0;

        if BaseAmount = 0 then
            BaseAmount := LeaseContract."Amount per Period";

        exit(BaseAmount);
    end;

    local procedure UpsertWorksheetSuggestion(LeaseContract: Record "Lease Contract"; ReviewYear: Integer; ReviewPeriodText: Text; IncrementPct: Decimal; BaseAmount: Decimal; var PriceIncreaseWorksheet: Record "Price Increases by Refer index")
    var
        ExistingWorksheet: Record "Price Increases by Refer index";
    begin
        ExistingWorksheet.Reset();
        ExistingWorksheet.SetRange("Contract No.", LeaseContract."Contract No.");
        ExistingWorksheet.SetRange(Year, ReviewYear);
        ExistingWorksheet.SetRange("Consumer Price Index Category", LeaseContract."Consumer Price Index Category");
        if ExistingWorksheet.FindFirst() then begin
            PriceIncreaseWorksheet := ExistingWorksheet;
        end else begin
            PriceIncreaseWorksheet.Init();
            PriceIncreaseWorksheet."Contract No." := LeaseContract."Contract No.";
            PriceIncreaseWorksheet."Line No." := GetNextWorksheetLineNo(LeaseContract."Contract No.");
            PriceIncreaseWorksheet.Insert();
        end;

        if LeaseContract."Customer No." <> '' then
            PriceIncreaseWorksheet."Customer No." := LeaseContract."Customer No.";
        if LeaseContract."Contact No." <> '' then
            PriceIncreaseWorksheet."Contact No." := LeaseContract."Contact No.";
        PriceIncreaseWorksheet."Fixed Real Estate No." := LeaseContract."Fixed Real Estate No.";
        PriceIncreaseWorksheet."Starting Date" := LeaseContract."Starting Date";
        PriceIncreaseWorksheet."Contract Expiration Date" := LeaseContract."Expiration Date";
        PriceIncreaseWorksheet."Consumer Price Index Category" := LeaseContract."Consumer Price Index Category";
        PriceIncreaseWorksheet.Year := ReviewYear;
        PriceIncreaseWorksheet."Current Unit Price" := LeaseContract."Amount per Period";
        PriceIncreaseWorksheet."Payment Method Code" := LeaseContract."Payment Method Code";
        PriceIncreaseWorksheet."CPI calculation amount" := BaseAmount;
        PriceIncreaseWorksheet."Amount Charged Last Periode" := BaseAmount;
        PriceIncreaseWorksheet."% Increment" := IncrementPct;
        PriceIncreaseWorksheet.Amount := Round(BaseAmount * IncrementPct / 100, 0.01);
        PriceIncreaseWorksheet."Starting Date Increment" := GetAnniversaryDate(LeaseContract."Starting Date", ReviewYear);
        PriceIncreaseWorksheet.Description := CopyStr(StrSubstNo('Actualización %1 %2', LeaseContract."Consumer Price Index Category", ReviewPeriodText), 1, MaxStrLen(PriceIncreaseWorksheet.Description));
        PriceIncreaseWorksheet.Modify();
    end;

    local procedure GetNextWorksheetLineNo(ContractNo: Code[20]): Integer
    var
        Worksheet: Record "Price Increases by Refer index";
    begin
        Worksheet.Reset();
        Worksheet.SetRange("Contract No.", ContractNo);
        if Worksheet.FindLast() then
            exit(Worksheet."Line No." + 10000);

        exit(10000);
    end;

    local procedure GetAnniversaryDate(StartingDate: Date; ReviewYear: Integer): Date
    var
        ReviewMonth: Integer;
        ReviewDay: Integer;
        DaysInTargetMonth: Integer;
    begin
        if StartingDate = 0D then
            exit(WorkDate());

        ReviewMonth := Date2DMY(StartingDate, 2);
        ReviewDay := Date2DMY(StartingDate, 1);
        DaysInTargetMonth := Date2DMY(CalcDate('<1M-1D>', DMY2Date(1, ReviewMonth, ReviewYear)), 1);
        if ReviewDay > DaysInTargetMonth then
            ReviewDay := DaysInTargetMonth;

        exit(DMY2Date(ReviewDay, ReviewMonth, ReviewYear));
    end;

    local procedure GetTextBetweenCaseInsensitive(SourceText: Text; StartMarker: Text; EndMarker: Text): Text
    var
        LowerSourceText: Text;
        LowerStartMarker: Text;
        LowerEndMarker: Text;
        StartPos: Integer;
        ValueStartPos: Integer;
        EndPos: Integer;
    begin
        LowerSourceText := LowerCase(SourceText);
        LowerStartMarker := LowerCase(StartMarker);
        LowerEndMarker := LowerCase(EndMarker);

        StartPos := StrPos(LowerSourceText, LowerStartMarker);
        if StartPos = 0 then
            exit('');

        ValueStartPos := StartPos + StrLen(StartMarker);
        EndPos := StrPos(CopyStr(LowerSourceText, ValueStartPos), LowerEndMarker);
        if EndPos = 0 then
            exit('');

        exit(CopyStr(SourceText, ValueStartPos, EndPos - 1));
    end;

    local procedure GetCaseInsensitivePosition(SourceText: Text; SearchText: Text): Integer
    begin
        exit(StrPos(LowerCase(SourceText), LowerCase(SearchText)));
    end;

    local procedure GetLastCaseInsensitivePosition(SourceText: Text; SearchText: Text): Integer
    var
        SearchFromPos: Integer;
        RelativePos: Integer;
        FoundPos: Integer;
    begin
        SearchFromPos := 1;
        repeat
            RelativePos := StrPos(CopyStr(LowerCase(SourceText), SearchFromPos), LowerCase(SearchText));
            if RelativePos > 0 then begin
                FoundPos := SearchFromPos + RelativePos - 1;
                SearchFromPos := FoundPos + 1;
            end;
        until RelativePos = 0;

        exit(FoundPos);
    end;

    local procedure ReadToken(SourceText: Text; StartPos: Integer; Separator: Text[1]; var EndPos: Integer): Text
    var
        SeparatorPos: Integer;
    begin
        if StartPos <= 0 then begin
            EndPos := 0;
            exit('');
        end;

        SeparatorPos := StrPos(CopyStr(SourceText, StartPos), Separator);
        if SeparatorPos = 0 then begin
            EndPos := StrLen(SourceText);
            exit(CopyStr(SourceText, StartPos));
        end;

        EndPos := StartPos + SeparatorPos - 1;
        exit(CopyStr(SourceText, StartPos, SeparatorPos - 1));
    end;

    local procedure TryParseDecimalFlexible(ValueText: Text; var DecimalValue: Decimal): Boolean
    var
        SanitizedText: Text;
    begin
        SanitizedText := DelChr(ValueText, '=', ' %');
        if Evaluate(DecimalValue, SanitizedText) then
            exit(true);

        SanitizedText := ConvertStr(SanitizedText, '.', ',');
        if Evaluate(DecimalValue, SanitizedText) then
            exit(true);

        SanitizedText := ConvertStr(SanitizedText, ',', '.');
        exit(Evaluate(DecimalValue, SanitizedText));
    end;

    local procedure ExtractYearFromText(SourceText: Text): Integer
    var
        CandidateText: Text[4];
        Index: Integer;
        YearValue: Integer;
    begin
        if StrLen(SourceText) < 4 then
            exit(0);

        for Index := StrLen(SourceText) - 3 downto 1 do begin
            CandidateText := CopyStr(SourceText, Index, 4);
            if Evaluate(YearValue, CandidateText) then
                if (YearValue >= 2000) and (YearValue <= 2100) then
                    exit(YearValue);
        end;

        exit(0);
    end;

    var
        IpcSourceUrl: Label 'https://www.mivau.gob.es/vivienda/calculadora-precio-alquiler';
        IravCsvUrl: Label 'https://www.ine.es/jaxiT3/files/t/csv_bdsc/72975.csv';
        ConnectionErr: Label 'No se ha podido conectar con el servicio oficial: %1.';
        HttpStatusErr: Label 'El servicio oficial %1 devolvió el código %2.';
        EmptyResponseErr: Label 'El servicio oficial %1 no ha devuelto contenido.';
        UnsupportedCategoryErr: Label 'La categoría de índice %1 no está soportada por la automatización oficial. Usa IPC o IRAV.';
        NoBaseAmountErr: Label 'No se ha encontrado base de cálculo para generar la revisión del contrato %1.';
        IpcFormatErr: Label 'No se ha podido interpretar la respuesta oficial del IPC.';
        IpcValueErr: Label 'No se ha podido convertir el valor oficial del IPC "%1".';
        IravFormatErr: Label 'No se ha podido interpretar la respuesta oficial del IRAV.';
        IravValueErr: Label 'No se ha podido convertir el valor oficial del IRAV "%1".';
}
