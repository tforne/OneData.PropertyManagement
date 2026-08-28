codeunit 96980 "OD FF Contract Adapter"
{
    procedure IsCompanyIncluded(CompanyName: Text[30]; Setup: Record "OD FF Setup"): Boolean
    begin
        if (not Setup."Include Inactive Companies") and IsCompanyInactive(CompanyName) then
            exit(false);

        if (not Setup."Include Blocked Companies") and IsCompanyBlocked(CompanyName) then
            exit(false);

        if Setup."Exclude Test Companies" and MatchesTestCompanyFilter(CompanyName, Setup."Test Company Filter") then
                exit(false);

        exit(true);
    end;

    procedure IsContractIncluded(var LeaseContract: Record "Lease Contract"; Setup: Record "OD FF Setup"; WorkDate: Date): Boolean
    var
        StartDate: Date;
        EndDate: Date;
        StatusTxt: Text;
    begin
        StartDate := LeaseContract."Starting Date";
        EndDate := LeaseContract."Expiration Date";
        StatusTxt := UpperCase(Format(LeaseContract.Status));

        if IsCancelledStatus(StatusTxt) and (not Setup."Include Cancelled Contracts") then
            exit(false);

        if IsCancelledStatus(StatusTxt) and Setup."Include Cancelled Contracts" then
            exit(true);

        if IsExpiredStatus(StatusTxt) and (not Setup."Include Expired Contracts") then
            exit(false);

        if IsExpiredStatus(StatusTxt) and Setup."Include Expired Contracts" then
            exit(true);

        if IsSignedStatus(StatusTxt) then
            exit(true);

        if (StartDate <> 0D) and (StartDate > WorkDate) and (not Setup."Include Future Contracts") then
            exit(false);

        if (EndDate <> 0D) and (EndDate < WorkDate) and (not Setup."Include Expired Contracts") then
            exit(false);

        if (StartDate = 0D) or (StartDate <= WorkDate) then
            if (EndDate = 0D) or (EndDate >= WorkDate) then
                exit(true);

        exit(false);
    end;

    procedure FillBufferFromContract(CompanyName: Text[30]; var LeaseContract: Record "Lease Contract"; var Buffer: Record "OD FF Buffer")
    var
        RecRef: RecordRef;
        PropertyNo: Code[20];
        CustomerNo: Code[20];
    begin
        RecRef.GetTable(LeaseContract);

        Buffer."Company Name" := CompanyName;
        Buffer."Company Display Name" := CompanyName;
        Buffer."Contract No." := CopyStr(GetTextByNames(RecRef, 'No.', 'Contract No.', 'Code'), 1, MaxStrLen(Buffer."Contract No."));
        Buffer."Contract Description" := CopyStr(GetTextByNames(RecRef, 'Description', 'Name', ''), 1, MaxStrLen(Buffer."Contract Description"));
        CustomerNo := CopyStr(GetTextByNames(RecRef, 'Customer No.', 'Sell-to Customer No.', 'Tenant No.'), 1, MaxStrLen(Buffer."Customer No."));
        Buffer."Customer No." := CustomerNo;
        Buffer."Customer Name" := CopyStr(GetCustomerName(CompanyName, CustomerNo, RecRef), 1, MaxStrLen(Buffer."Customer Name"));
        Buffer."Contract Status" := CopyStr(GetTextByNames(RecRef, 'Status', 'Contract Status', ''), 1, MaxStrLen(Buffer."Contract Status"));
        Buffer."Contract Start Date" := LeaseContract."Starting Date";
        Buffer."Contract End Date" := LeaseContract."Expiration Date";
        Buffer."Billing Frequency" := CopyStr(GetTextByNames(RecRef, 'Invoice Period', 'Billing Frequency', 'Service Period'), 1, MaxStrLen(Buffer."Billing Frequency"));
        Buffer."Next Billing Date" := GetDateByNames(RecRef, 'Next Billing Date', 'Posting Date', '');
        Buffer."Property Address" := CopyStr(GetTextByNames(RecRef, 'Address', 'Property Address', ''), 1, MaxStrLen(Buffer."Property Address"));
        Buffer."Postal Code" := CopyStr(GetTextByNames(RecRef, 'Post Code', 'Postal Code', ''), 1, MaxStrLen(Buffer."Postal Code"));
        Buffer.City := CopyStr(GetTextByNames(RecRef, 'City', 'Property City', ''), 1, MaxStrLen(Buffer.City));
        Buffer."Deposit Amount" := GetDecimalByNames(RecRef, 'Deposit Amount', 'Deposit', 'Fianza');
        Buffer."Guarantee Amount" := GetDecimalByNames(RecRef, 'Guarantee Amount', 'Guarantee', 'Garantía');
        Buffer."Outstanding Amount" := GetDecimalByNames(RecRef, 'Outstanding Amount', 'Pending Amount', 'Balance');
        Buffer."Indexed Rent" := GetDecimalByNames(RecRef, 'Indexed Rent', 'Last Rental Price', '');
        Buffer."CPI Percentage" := GetDecimalByNames(RecRef, 'CPI Percentage', '% Increment', '');

        PropertyNo := LeaseContract."Fixed Real Estate No.";
        if PropertyNo = '' then
            PropertyNo := CopyStr(GetTextByNames(RecRef, 'Property No.', 'Fixed Real Estate No.', 'Real Estate No.'), 1, MaxStrLen(Buffer."Property No."));
        if PropertyNo = '' then
            PropertyNo := LeaseContract."FRE Property No.";
        if PropertyNo = '' then
            PropertyNo := CopyStr(GetTextByNames(RecRef, 'Asset No.', 'No. Property', ''), 1, MaxStrLen(Buffer."Property No."));

        Buffer."Property No." := PropertyNo;
        Buffer."Contract Page Id" := Page::"Lease Contract List";
        Buffer."Property Page Id" := Page::"Simple Fixed Real Estate List";
    end;

    procedure FillBufferFromProperty(CompanyName: Text[30]; PropertyNo: Code[20]; var Buffer: Record "OD FF Buffer")
    var
        Property: Record "Fixed Real Estate";
        RecRef: RecordRef;
        ParentProperty: Record "Fixed Real Estate";
    begin
        if PropertyNo = '' then
            exit;

        Property.ChangeCompany(CompanyName);
        if not TryGetPropertyByNo(Property, PropertyNo) then
            exit;

        Property.CalcFields("Superficie construida", "Last Reference Price", "Last Reference Price Max.");
        RecRef.GetTable(Property);
        Buffer."Property Description" := CopyStr(GetTextByNames(RecRef, 'Description', 'Property Description', ''), 1, MaxStrLen(Buffer."Property Description"));
        Buffer."Property Address" := CopyStr(GetTextByNames(RecRef, 'Address', 'Street Name', ''), 1, MaxStrLen(Buffer."Property Address"));
        Buffer."Postal Code" := CopyStr(GetTextByNames(RecRef, 'Post Code', 'Postal Code', ''), 1, MaxStrLen(Buffer."Postal Code"));
        Buffer.City := CopyStr(GetTextByNames(RecRef, 'City', 'Property City', ''), 1, MaxStrLen(Buffer.City));
        Buffer."Cadastral Reference" := CopyStr(GetTextByNames(RecRef, 'Cadastral reference', 'Reference Cadastral', ''), 1, MaxStrLen(Buffer."Cadastral Reference"));
        Buffer."Cadastral Value" := GetDecimalByNames(RecRef, 'Total Val. Catastral Activo', 'Val. Catastral Activo', 'Cadastral Value');
        Buffer."Purchase Price" := GetDecimalByNames(RecRef, 'Purchase Price', 'Acquisition Cost', '');
        Buffer."Estimated Selling Price" := GetEstimatedSellingPrice(Property);
        Buffer."Market Value" := GetMarketValue(Property);
        Buffer."Acquisition Date" := GetDateByNames(RecRef, 'Acquisition Date', 'Last Date Modified', '');
        Buffer."Surface Area" := Property."Superficie construida";

        if (Buffer."Estimated Selling Price" = 0) or (Buffer."Market Value" = 0) or (Buffer."Purchase Price" = 0) or (Buffer."Cadastral Value" = 0) then
            if TryGetParentProperty(Property, ParentProperty) then begin
                if Buffer."Estimated Selling Price" = 0 then
                    Buffer."Estimated Selling Price" := GetEstimatedSellingPrice(ParentProperty);
                if Buffer."Market Value" = 0 then
                    Buffer."Market Value" := GetMarketValue(ParentProperty);
                if Buffer."Purchase Price" = 0 then
                    Buffer."Purchase Price" := ParentProperty."Sales price";
                if Buffer."Cadastral Value" = 0 then
                    Buffer."Cadastral Value" := ParentProperty."Total Val. Catastral Activo";
                if Buffer."Property Description" = '' then
                    Buffer."Property Description" := CopyStr(ParentProperty.Description, 1, MaxStrLen(Buffer."Property Description"));
            end;
    end;

    procedure GetContractMonthlyRent(CompanyName: Text[30]; var LeaseContract: Record "Lease Contract"): Decimal
    var
        AnnualAmount: Decimal;
        AmountPerPeriod: Decimal;
        InvoicePeriodTxt: Text;
        RealEstateManagement: Codeunit "Real Estate Management";
    begin
        AnnualAmount := LeaseContract."Annual Amount";
        if AnnualAmount <> 0 then
            exit(Round(AnnualAmount / 12, 0.01));

        AmountPerPeriod := LeaseContract."Amount per Period";
        if AmountPerPeriod = 0 then
            AmountPerPeriod := LeaseContract."Lease Manag. Amount per Period";

        InvoicePeriodTxt := Format(LeaseContract."Invoice Period");
        if AmountPerPeriod = 0 then
            AmountPerPeriod := RealEstateManagement.CalcContractAmount(LeaseContract, LeaseContract."Starting Date", LeaseContract."Expiration Date");

        if AmountPerPeriod <> 0 then
            exit(NormalizePeriodAmountToMonthly(AmountPerPeriod, InvoicePeriodTxt));

        exit(0);
    end;

    procedure GetPropertyValue(var Buffer: Record "OD FF Buffer"; Setup: Record "OD FF Setup"): Decimal
    begin
        case Setup."Default Market Value Source" of
            Setup."Default Market Value Source"::MarketValue:
                if Buffer."Market Value" <> 0 then begin
                    Buffer."Value Source" := Buffer."Value Source"::MarketValue;
                    exit(Buffer."Market Value");
                end;
            Setup."Default Market Value Source"::EstimatedSellingPrice:
                if Buffer."Estimated Selling Price" <> 0 then begin
                    Buffer."Value Source" := Buffer."Value Source"::EstimatedSellingPrice;
                    exit(Buffer."Estimated Selling Price");
                end;
            Setup."Default Market Value Source"::PurchasePrice:
                if Buffer."Purchase Price" <> 0 then begin
                    Buffer."Value Source" := Buffer."Value Source"::PurchasePrice;
                    exit(Buffer."Purchase Price");
                end;
            Setup."Default Market Value Source"::CadastralValue:
                if Buffer."Cadastral Value" <> 0 then begin
                    Buffer."Value Source" := Buffer."Value Source"::CadastralValue;
                    exit(Buffer."Cadastral Value");
                end;
        end;

        if Buffer."Market Value" <> 0 then begin
            Buffer."Value Source" := Buffer."Value Source"::MarketValue;
            exit(Buffer."Market Value");
        end;
        if Buffer."Estimated Selling Price" <> 0 then begin
            Buffer."Value Source" := Buffer."Value Source"::EstimatedSellingPrice;
            exit(Buffer."Estimated Selling Price");
        end;
        if Buffer."Purchase Price" <> 0 then begin
            Buffer."Value Source" := Buffer."Value Source"::PurchasePrice;
            exit(Buffer."Purchase Price");
        end;
        if Buffer."Cadastral Value" <> 0 then begin
            Buffer."Value Source" := Buffer."Value Source"::CadastralValue;
            exit(Buffer."Cadastral Value");
        end;

        Buffer."Value Source" := Buffer."Value Source"::NotAvailable;
        exit(0);
    end;

    local procedure TryGetPropertyByNo(var Property: Record "Fixed Real Estate"; PropertyNo: Code[20]): Boolean
    var
        RecRef: RecordRef;
        PropertyByNo: Record "Fixed Real Estate";
    begin
        PropertyByNo.ChangeCompany(Property.CurrentCompany);
        if PropertyByNo.Get(PropertyNo) then begin
            Property := PropertyByNo;
            exit(true);
        end;

        Property.Reset();
        if not Property.FindSet() then
            exit(false);

        repeat
            RecRef.GetTable(Property);
            if (CopyStr(GetTextByNames(RecRef, 'No.', 'Property No.', ''), 1, 20) = PropertyNo) or
               (CopyStr(GetTextByNames(RecRef, 'Property No.', 'No.', ''), 1, 20) = PropertyNo)
            then
                exit(true);
        until Property.Next() = 0;

        exit(false);
    end;

    local procedure TryGetParentProperty(Property: Record "Fixed Real Estate"; var ParentProperty: Record "Fixed Real Estate"): Boolean
    begin
        if Property."Property No." = '' then
            exit(false);

        ParentProperty.ChangeCompany(Property.CurrentCompany);
        if ParentProperty.Get(Property."Property No.") then begin
            ParentProperty.CalcFields("Superficie construida", "Last Reference Price", "Last Reference Price Max.");
            exit(true);
        end;

        exit(false);
    end;

    local procedure GetEstimatedSellingPrice(Property: Record "Fixed Real Estate"): Decimal
    begin
        if Property."Sales price" <> 0 then
            exit(Property."Sales price");
        if Property."Minimum Sales Price" <> 0 then
            exit(Property."Minimum Sales Price");
        exit(0);
    end;

    local procedure GetMarketValue(Property: Record "Fixed Real Estate"): Decimal
    begin
        if Property."Last Reference Price" <> 0 then
            exit(Property."Last Reference Price");
        if Property."Last Reference Price Max." <> 0 then
            exit(Property."Last Reference Price Max.");
        if Property."Sales price" <> 0 then
            exit(Property."Sales price");
        if Property."Minimum Sales Price" <> 0 then
            exit(Property."Minimum Sales Price");
        exit(0);
    end;

    local procedure GetCustomerName(CompanyName: Text[30]; CustomerNo: Code[20]; ContractRecRef: RecordRef): Text
    var
        Customer: Record Customer;
        CustomerName: Text;
    begin
        if CustomerNo <> '' then begin
            Customer.ChangeCompany(CompanyName);
            if Customer.Get(CustomerNo) then begin
                CustomerName := Customer.Name;
                if CustomerName <> '' then
                    exit(CustomerName);
            end;
        end;

        CustomerName := GetTextByNames(ContractRecRef, 'Customer Name', 'Tenant Name', '');
        if CustomerName <> '' then
            exit(CustomerName);

        exit(GetTextByNames(ContractRecRef, 'Name', '', ''));
    end;

    local procedure NormalizePeriodAmountToMonthly(Amount: Decimal; BillingFrequency: Text): Decimal
    var
        FrequencyTxt: Text;
    begin
        FrequencyTxt := UpperCase(BillingFrequency);

        if (FrequencyTxt = '') or (StrPos(FrequencyTxt, 'MONTH') > 0) or (StrPos(FrequencyTxt, 'MES') > 0) then
            exit(Amount);
        if (StrPos(FrequencyTxt, 'TWO MONTHS') > 0) or (StrPos(FrequencyTxt, 'BIM') > 0) then
            exit(Amount / 2);
        if (StrPos(FrequencyTxt, 'QUART') > 0) or (StrPos(FrequencyTxt, 'TRIM') > 0) then
            exit(Amount / 3);
        if (StrPos(FrequencyTxt, 'HALF YEAR') > 0) or (StrPos(FrequencyTxt, 'SEM') > 0) then
            exit(Amount / 6);
        if (StrPos(FrequencyTxt, 'YEAR') > 0) or (StrPos(FrequencyTxt, 'AN') > 0) then
            exit(Amount / 12);
        if (StrPos(FrequencyTxt, 'NONE') > 0) then
            exit(Amount);

        exit(Amount);
    end;

    local procedure IsCompanyBlocked(CompanyName: Text[30]): Boolean
    begin
        exit(false);
    end;

    local procedure IsCompanyInactive(CompanyName: Text[30]): Boolean
    begin
        exit(false);
    end;

    local procedure GetTextByNames(RecRef: RecordRef; Name1: Text; Name2: Text; Name3: Text): Text
    var
        Value: Text;
    begin
        Value := GetTextFieldValue(RecRef, Name1);
        if Value <> '' then
            exit(Value);
        Value := GetTextFieldValue(RecRef, Name2);
        if Value <> '' then
            exit(Value);
        exit(GetTextFieldValue(RecRef, Name3));
    end;

    local procedure GetDateByNames(RecRef: RecordRef; Name1: Text; Name2: Text; Name3: Text): Date
    var
        Value: Date;
    begin
        Value := GetDateFieldValue(RecRef, Name1);
        if Value <> 0D then
            exit(Value);
        Value := GetDateFieldValue(RecRef, Name2);
        if Value <> 0D then
            exit(Value);
        exit(GetDateFieldValue(RecRef, Name3));
    end;

    local procedure GetDecimalByNames(RecRef: RecordRef; Name1: Text; Name2: Text; Name3: Text): Decimal
    var
        Value: Decimal;
    begin
        Value := GetDecimalFieldValue(RecRef, Name1);
        if Value <> 0 then
            exit(Value);
        Value := GetDecimalFieldValue(RecRef, Name2);
        if Value <> 0 then
            exit(Value);
        exit(GetDecimalFieldValue(RecRef, Name3));
    end;

    local procedure GetFieldRefByName(RecRef: RecordRef; FieldName: Text; var FieldRef: FieldRef): Boolean
    var
        i: Integer;
        CurrentFieldRef: FieldRef;
    begin
        if FieldName = '' then
            exit(false);

        for i := 1 to RecRef.FieldCount do begin
            CurrentFieldRef := RecRef.FieldIndex(i);
            if UpperCase(CurrentFieldRef.Name) = UpperCase(FieldName) then begin
                FieldRef := CurrentFieldRef;
                exit(true);
            end;
        end;

        exit(false);
    end;

    local procedure GetTextFieldValue(RecRef: RecordRef; FieldName: Text): Text
    var
        FieldRef: FieldRef;
    begin
        if not GetFieldRefByName(RecRef, FieldName, FieldRef) then
            exit('');

        exit(Format(FieldRef.Value));
    end;

    local procedure GetDateFieldValue(RecRef: RecordRef; FieldName: Text): Date
    var
        FieldRef: FieldRef;
        ValueTxt: Text;
        ValueDate: Date;
    begin
        if not GetFieldRefByName(RecRef, FieldName, FieldRef) then
            exit(0D);

        ValueTxt := Format(FieldRef.Value, 0, 9);
        if not Evaluate(ValueDate, ValueTxt) then
            exit(0D);

        exit(ValueDate);
    end;

    local procedure GetDecimalFieldValue(RecRef: RecordRef; FieldName: Text): Decimal
    var
        FieldRef: FieldRef;
        ValueTxt: Text;
        ValueDecimal: Decimal;
    begin
        if not GetFieldRefByName(RecRef, FieldName, FieldRef) then
            exit(0);

        ValueTxt := Format(FieldRef.Value, 0, 9);
        if not Evaluate(ValueDecimal, ValueTxt) then
            exit(0);

        exit(ValueDecimal);
    end;

    local procedure ContainsAny(SourceText: Text; Token1: Text; Token2: Text; Token3: Text): Boolean
    begin
        if (Token1 <> '') and (StrPos(SourceText, UpperCase(Token1)) > 0) then
            exit(true);
        if (Token2 <> '') and (StrPos(SourceText, UpperCase(Token2)) > 0) then
            exit(true);
        if (Token3 <> '') and (StrPos(SourceText, UpperCase(Token3)) > 0) then
            exit(true);
        exit(false);
    end;

    local procedure IsCancelledStatus(StatusTxt: Text): Boolean
    begin
        exit(
          ContainsAny(StatusTxt, 'CANCEL', 'CANCELL', 'ANUL') or
          ContainsAny(StatusTxt, 'VOID', 'RESCIND', 'TERMINAT'));
    end;

    local procedure IsExpiredStatus(StatusTxt: Text): Boolean
    begin
        exit(
          ContainsAny(StatusTxt, 'FINAL', 'FINISH', 'EXPIR') or
          ContainsAny(StatusTxt, 'VENC', 'ENDED', 'END '));
    end;

    local procedure IsSignedStatus(StatusTxt: Text): Boolean
    begin
        exit(
          ContainsAny(StatusTxt, 'SIGN', 'FIRMAD', 'FIRMADO') or
          ContainsAny(StatusTxt, 'ACTIV', 'VIGENT', 'EN CURSO'));
    end;

    local procedure MatchesTestCompanyFilter(CompanyName: Text; FilterText: Text): Boolean
    var
        UpperCompanyName: Text;
        RemainingFilterText: Text;
        FilterToken: Text;
    begin
        UpperCompanyName := UpperCase(CompanyName);
        RemainingFilterText := FilterText;

        if RemainingFilterText = '' then
            exit(false);

        repeat
            FilterToken := UpperCase(SelectNextFilterToken(RemainingFilterText));
            if (FilterToken <> '') and MatchesCompanyToken(UpperCompanyName, FilterToken) then
                exit(true);
        until RemainingFilterText = '';

        exit(false);
    end;

    local procedure SelectNextFilterToken(var FilterText: Text): Text
    var
        SeparatorPosition: Integer;
        Token: Text;
    begin
        SeparatorPosition := StrPos(FilterText, '|');
        if SeparatorPosition = 0 then begin
            Token := DelChr(FilterText, '<>', ' ');
            FilterText := '';
            exit(Token);
        end;

        Token := DelChr(CopyStr(FilterText, 1, SeparatorPosition - 1), '<>', ' ');
        FilterText := CopyStr(FilterText, SeparatorPosition + 1);
        exit(Token);
    end;

    local procedure MatchesCompanyToken(UpperCompanyName: Text; UpperFilterToken: Text): Boolean
    var
        WildcardPosition: Integer;
        PrefixToken: Text;
        SuffixToken: Text;
    begin
        if UpperFilterToken = '' then
            exit(false);

        if UpperFilterToken = '*' then
            exit(true);

        WildcardPosition := StrPos(UpperFilterToken, '*');
        if WildcardPosition = 0 then
            exit(UpperCompanyName = UpperFilterToken);

        PrefixToken := CopyStr(UpperFilterToken, 1, WildcardPosition - 1);
        SuffixToken := CopyStr(UpperFilterToken, WildcardPosition + 1);

        if (PrefixToken <> '') and (CopyStr(UpperCompanyName, 1, StrLen(PrefixToken)) <> PrefixToken) then
            exit(false);

        if SuffixToken = '' then
            exit(true);

        if StrLen(UpperCompanyName) < StrLen(SuffixToken) then
            exit(false);

        exit(CopyStr(UpperCompanyName, StrLen(UpperCompanyName) - StrLen(SuffixToken) + 1) = SuffixToken);
    end;
}
