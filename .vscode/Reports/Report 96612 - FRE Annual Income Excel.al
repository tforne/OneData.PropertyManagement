namespace OneData.Property.Asset;

using Microsoft.Sales.Customer;
using OneData.Property.Finance;
using OneData.Property.Lease;
using System.IO;
using System.Utilities;

report 96612 "FRE Annual Income Excel"
{
    ApplicationArea = All;
    Caption = 'Exporta ingressos anuals per actiu';
    ProcessingOnly = true;
    UsageCategory = ReportsAndAnalysis;

    dataset
    {
        dataitem("Fixed Real Estate"; "Fixed Real Estate")
        {
            DataItemTableView = sorting("No.");
            RequestFilterFields = "No.", "Property No.", "Asset Type";

            trigger OnAfterGetRecord()
            begin
                ProcessFixedRealEstate("Fixed Real Estate");
            end;

            trigger OnPreDataItem()
            begin
                ValidateOptions();
                SetRange(Type, Type::Activo);
                InitializeExcel();
            end;
        }
    }

    requestpage
    {
        SaveValues = true;

        layout
        {
            area(content)
            {
                group(Options)
                {
                    Caption = 'Opcions';
                    field(ReportYear; ReportYear)
                    {
                        ApplicationArea = All;
                        Caption = 'Exercici';
                        ToolTip = 'Especifica l''exercici fiscal a exportar.';
                    }
                    field(IncludeEmptyAssets; IncludeEmptyAssets)
                    {
                        ApplicationArea = All;
                        Caption = 'Inclou actius sense moviments';
                        ToolTip = 'Especifica si s''inclouen els actius sense ingressos, despeses o dies de lloguer en l''exercici seleccionat.';
                    }
                }
            }
        }
    }

    trigger OnPostReport()
    begin
        FinalizeExcel();
    end;

    var
        TempExcelBuffer: Record "Excel Buffer" temporary;
        LeaseContract: Record "Lease Contract";
        FRELedgerEntry: Record "FRE Ledger Entry";
        Customer: Record Customer;
        ReportYear: Integer;
        IncludeEmptyAssets: Boolean;
        IncludedAssetCount: Integer;
        TotalIncomeAmount: Decimal;
        TotalExpenseAmount: Decimal;
        ExcelFileName: Label 'Ingressos_Anuals_Actius';
        SheetNameLbl: Label 'Ingressos';
        TitleLbl: Label 'INGRESSOS ANUALS PER ACTIU';
        YearLbl: Label 'Exercici';
        AssetNoHdrLbl: Label 'ACTIU';
        DescriptionHdrLbl: Label 'DESCRIPCIÓ';
        AddressHdrLbl: Label 'ADREÇA FINCA';
        CadastralHdrLbl: Label 'REFERÈNCIA CADASTRAL';
        RentedDaysHdrLbl: Label 'N. DIES LLOGAT';
        OccupancyPctHdrLbl: Label '% OCUPACIÓ';
        TenantHdrLbl: Label 'NOM LLOGATER';
        VatHdrLbl: Label 'NIF';
        IncomeHdrLbl: Label 'INGRESSOS';
        ExpenseHdrLbl: Label 'DESPESES';
        NetIncomeHdrLbl: Label 'NET';
        ContractDateHdrLbl: Label 'DATA CONTRACTE';
        AssetCountLbl: Label 'Actius inclosos';
        GeneratedOnLbl: Label 'Data generació';
        TotalsLbl: Label 'TOTAL';

    local procedure ValidateOptions()
    begin
        if ReportYear = 0 then
            ReportYear := Date2DMY(Today(), 3);

        if (ReportYear < 1900) or (ReportYear > 2200) then
            Error('L''exercici %1 no és vàlid.', ReportYear);
    end;

    local procedure InitializeExcel()
    begin
        Clear(TempExcelBuffer);
        Clear(IncludedAssetCount);
        Clear(TotalIncomeAmount);
        Clear(TotalExpenseAmount);
        TempExcelBuffer.DeleteAll();
        TempExcelBuffer.CreateNewBook(SheetNameLbl);

        TempExcelBuffer.NewRow();
        TempExcelBuffer.AddColumn(TitleLbl, false, '', true, false, false, '', TempExcelBuffer."Cell Type"::Text);

        TempExcelBuffer.NewRow();
        TempExcelBuffer.AddColumn(YearLbl, false, '', true, false, false, '', TempExcelBuffer."Cell Type"::Text);
        TempExcelBuffer.AddColumn(Format(ReportYear), false, '', false, false, false, '', TempExcelBuffer."Cell Type"::Text);

        TempExcelBuffer.NewRow();
        TempExcelBuffer.AddColumn(GeneratedOnLbl, false, '', true, false, false, '', TempExcelBuffer."Cell Type"::Text);
        TempExcelBuffer.AddColumn(Today(), false, 'dd/mm/yyyy', false, false, false, '', TempExcelBuffer."Cell Type"::Date);

        TempExcelBuffer.NewRow();
        AddHeaderRow();
    end;

    local procedure AddHeaderRow()
    begin
        TempExcelBuffer.AddColumn(AssetNoHdrLbl, false, '', true, false, false, '', TempExcelBuffer."Cell Type"::Text);
        TempExcelBuffer.AddColumn(DescriptionHdrLbl, false, '', true, false, false, '', TempExcelBuffer."Cell Type"::Text);
        TempExcelBuffer.AddColumn(AddressHdrLbl, false, '', true, false, false, '', TempExcelBuffer."Cell Type"::Text);
        TempExcelBuffer.AddColumn(CadastralHdrLbl, false, '', true, false, false, '', TempExcelBuffer."Cell Type"::Text);
        TempExcelBuffer.AddColumn(StrSubstNo('%1 %2', RentedDaysHdrLbl, ReportYear), false, '', true, false, false, '', TempExcelBuffer."Cell Type"::Text);
        TempExcelBuffer.AddColumn(OccupancyPctHdrLbl, false, '', true, false, false, '', TempExcelBuffer."Cell Type"::Text);
        TempExcelBuffer.AddColumn(TenantHdrLbl, false, '', true, false, false, '', TempExcelBuffer."Cell Type"::Text);
        TempExcelBuffer.AddColumn(VatHdrLbl, false, '', true, false, false, '', TempExcelBuffer."Cell Type"::Text);
        TempExcelBuffer.AddColumn(IncomeHdrLbl, false, '', true, false, false, '', TempExcelBuffer."Cell Type"::Text);
        TempExcelBuffer.AddColumn(ExpenseHdrLbl, false, '', true, false, false, '', TempExcelBuffer."Cell Type"::Text);
        TempExcelBuffer.AddColumn(NetIncomeHdrLbl, false, '', true, false, false, '', TempExcelBuffer."Cell Type"::Text);
        TempExcelBuffer.AddColumn(ContractDateHdrLbl, false, '', true, false, false, '', TempExcelBuffer."Cell Type"::Text);
    end;

    local procedure ProcessFixedRealEstate(FixedRealEstate: Record "Fixed Real Estate")
    var
        PrimaryLeaseContract: Record "Lease Contract";
        TotalIncome: Decimal;
        TotalExpense: Decimal;
        TotalRentedDays: Integer;
        TenantName: Text[100];
        TenantVatNo: Text[50];
        ContractDate: Date;
    begin
        TotalIncome := GetIncomeAmount(FixedRealEstate."No.");
        TotalExpense := GetExpenseAmount(FixedRealEstate."No.");
        TotalRentedDays := GetPrimaryLeaseContract(FixedRealEstate."No.", PrimaryLeaseContract);

        if PrimaryLeaseContract."Contract No." <> '' then begin
            PrimaryLeaseContract.CalcFields(Name);
            TenantName := PrimaryLeaseContract.Name;
            ContractDate := PrimaryLeaseContract."Contract Date";

            if (PrimaryLeaseContract."Customer No." <> '') and Customer.Get(PrimaryLeaseContract."Customer No.") then
                TenantVatNo := CopyStr(Customer."VAT Registration No.", 1, MaxStrLen(TenantVatNo));
        end;

        if (not IncludeEmptyAssets) and
           (TotalIncome = 0) and
           (TotalExpense = 0) and
           (TotalRentedDays = 0)
        then
            exit;

        AddDataRow(
            FixedRealEstate,
            TotalRentedDays,
            TenantName,
            TenantVatNo,
            TotalIncome,
            TotalExpense,
            ContractDate);
    end;

    local procedure AddDataRow(FixedRealEstate: Record "Fixed Real Estate"; TotalRentedDays: Integer; TenantName: Text[100]; TenantVatNo: Text[50]; TotalIncome: Decimal; TotalExpense: Decimal; ContractDate: Date)
    begin
        IncludedAssetCount += 1;
        TotalIncomeAmount += TotalIncome;
        TotalExpenseAmount += TotalExpense;

        TempExcelBuffer.NewRow();
        TempExcelBuffer.AddColumn(FixedRealEstate."No.", false, '', false, false, false, '', TempExcelBuffer."Cell Type"::Text);
        TempExcelBuffer.AddColumn(FixedRealEstate.Description, false, '', false, false, false, '', TempExcelBuffer."Cell Type"::Text);
        TempExcelBuffer.AddColumn(GetDisplayAddress(FixedRealEstate), false, '', false, false, false, '', TempExcelBuffer."Cell Type"::Text);
        TempExcelBuffer.AddColumn(FixedRealEstate."Cadastral reference", false, '', false, false, false, '', TempExcelBuffer."Cell Type"::Text);
        TempExcelBuffer.AddColumn(TotalRentedDays, false, '', false, false, false, '', TempExcelBuffer."Cell Type"::Number);
        AddPercentageColumn(GetOccupancyPct(TotalRentedDays));
        TempExcelBuffer.AddColumn(TenantName, false, '', false, false, false, '', TempExcelBuffer."Cell Type"::Text);
        TempExcelBuffer.AddColumn(TenantVatNo, false, '', false, false, false, '', TempExcelBuffer."Cell Type"::Text);
        TempExcelBuffer.AddColumn(TotalIncome, false, '#,##0.00 [$EUR]', false, false, false, '', TempExcelBuffer."Cell Type"::Number);
        TempExcelBuffer.AddColumn(TotalExpense, false, '#,##0.00 [$EUR]', false, false, false, '', TempExcelBuffer."Cell Type"::Number);
        AddAmountColumn(TotalIncome - TotalExpense);
        AddDateColumn(ContractDate);
    end;

    local procedure AddDateColumn(ValueDate: Date)
    begin
        if ValueDate = 0D then
            TempExcelBuffer.AddColumn('', false, '', false, false, false, '', TempExcelBuffer."Cell Type"::Text)
        else
            TempExcelBuffer.AddColumn(ValueDate, false, 'dd/mm/yyyy', false, false, false, '', TempExcelBuffer."Cell Type"::Date);
    end;

    local procedure AddAmountColumn(ValueAmount: Decimal)
    begin
        if ValueAmount = 0 then
            TempExcelBuffer.AddColumn('', false, '', false, false, false, '', TempExcelBuffer."Cell Type"::Text)
        else
            TempExcelBuffer.AddColumn(ValueAmount, false, '#,##0.00 [$EUR]', false, false, false, '', TempExcelBuffer."Cell Type"::Number);
    end;

    local procedure AddPercentageColumn(ValuePercentage: Decimal)
    begin
        if ValuePercentage = 0 then
            TempExcelBuffer.AddColumn('', false, '', false, false, false, '', TempExcelBuffer."Cell Type"::Text)
        else
            TempExcelBuffer.AddColumn(ValuePercentage / 100, false, '0.00%', false, false, false, '', TempExcelBuffer."Cell Type"::Number);
    end;

    local procedure GetIncomeAmount(FixedRealEstateNo: Code[20]): Decimal
    var
        FixedRealEstate: Record "Fixed Real Estate";
        TotalIncome: Decimal;
    begin
        FRELedgerEntry.Reset();
        FixedRealEstate.Get(FixedRealEstateNo);
        ApplyFixedRealEstateFilter(FRELedgerEntry, FixedRealEstate);
        FRELedgerEntry.SetRange("Line Type", FRELedgerEntry."Line Type"::Invoice);
        FRELedgerEntry.SetRange("Document Type", FRELedgerEntry."Document Type"::Invoice);
        FRELedgerEntry.SetRange("Posting Date", GetYearStartDate(), GetYearEndDate());
        FRELedgerEntry.SetRange("Company Name", CompanyName);

        if FRELedgerEntry.IsEmpty() then begin
            FRELedgerEntry.SetRange("Company Name");
        end;

        if FRELedgerEntry.FindSet() then
            repeat
                TotalIncome += FRELedgerEntry.Amount;
            until FRELedgerEntry.Next() = 0;

        exit(TotalIncome);
    end;

    local procedure GetExpenseAmount(FixedRealEstateNo: Code[20]): Decimal
    var
        FixedRealEstate: Record "Fixed Real Estate";
        TotalExpense: Decimal;
    begin
        FRELedgerEntry.Reset();
        FixedRealEstate.Get(FixedRealEstateNo);
        ApplyFixedRealEstateFilter(FRELedgerEntry, FixedRealEstate);
        FRELedgerEntry.SetRange("Posting Date", GetYearStartDate(), GetYearEndDate());
        FRELedgerEntry.SetRange("Company Name", CompanyName);

        if FRELedgerEntry.IsEmpty() then begin
            FRELedgerEntry.SetRange("Company Name");
        end;

        if FRELedgerEntry.FindSet() then
            repeat
                if FRELedgerEntry.Amount < 0 then
                    TotalExpense += Abs(FRELedgerEntry.Amount);
            until FRELedgerEntry.Next() = 0;

        exit(TotalExpense);
    end;

    local procedure ApplyFixedRealEstateFilter(var FRELedgerEntryToFilter: Record "FRE Ledger Entry"; FixedRealEstate: Record "Fixed Real Estate")
    begin
        if FixedRealEstate.Type = FixedRealEstate.Type::Propiedad then
            FRELedgerEntryToFilter.SetFilter("Fixed Real Estate No.", FixedRealEstate.Totaling)
        else
            FRELedgerEntryToFilter.SetRange("Fixed Real Estate No.", FixedRealEstate."No.");
    end;

    local procedure GetPrimaryLeaseContract(FixedRealEstateNo: Code[20]; var PrimaryLeaseContract: Record "Lease Contract"): Integer
    var
        DaysRented: Integer;
        BestDays: Integer;
        TotalDays: Integer;
    begin
        Clear(PrimaryLeaseContract);

        LeaseContract.Reset();
        LeaseContract.SetRange("Fixed Real Estate No.", FixedRealEstateNo);
        LeaseContract.SetRange(Status, LeaseContract.Status::Signed);
        LeaseContract.SetFilter("Starting Date", '<=%1', GetYearEndDate());
        LeaseContract.SetFilter("Expiration Date", '%1|>=%2', 0D, GetYearStartDate());

        if LeaseContract.FindSet() then
            repeat
                DaysRented := CalculateRentalDays(LeaseContract);
                if DaysRented > 0 then begin
                    TotalDays += DaysRented;
                    if DaysRented > BestDays then begin
                        BestDays := DaysRented;
                        PrimaryLeaseContract := LeaseContract;
                    end;
                end;
            until LeaseContract.Next() = 0;

        if TotalDays > DaysInYear() then
            TotalDays := DaysInYear();

        exit(TotalDays);
    end;

    local procedure CalculateRentalDays(LeaseContractToMeasure: Record "Lease Contract"): Integer
    var
        EffectiveStartDate: Date;
        EffectiveEndDate: Date;
    begin
        if LeaseContractToMeasure."Starting Date" = 0D then
            exit(0);

        EffectiveStartDate := LeaseContractToMeasure."Starting Date";
        if EffectiveStartDate < GetYearStartDate() then
            EffectiveStartDate := GetYearStartDate();

        EffectiveEndDate := LeaseContractToMeasure."Expiration Date";
        if (EffectiveEndDate = 0D) or (EffectiveEndDate > GetYearEndDate()) then
            EffectiveEndDate := GetYearEndDate();

        if EffectiveEndDate < EffectiveStartDate then
            exit(0);

        exit((EffectiveEndDate - EffectiveStartDate) + 1);
    end;

    local procedure GetDisplayAddress(FixedRealEstate: Record "Fixed Real Estate"): Text[100]
    var
        DisplayAddress: Text[100];
    begin
        DisplayAddress := FixedRealEstate."Composse Address";
        if DisplayAddress = '' then
            DisplayAddress := FixedRealEstate.Address;
        if DisplayAddress = '' then
            DisplayAddress := FixedRealEstate.Description;

        exit(DisplayAddress);
    end;

    local procedure GetYearStartDate(): Date
    begin
        exit(DMY2Date(1, 1, ReportYear));
    end;

    local procedure GetYearEndDate(): Date
    begin
        exit(DMY2Date(31, 12, ReportYear));
    end;

    local procedure DaysInYear(): Integer
    begin
        exit((GetYearEndDate() - GetYearStartDate()) + 1);
    end;

    local procedure GetOccupancyPct(TotalRentedDays: Integer): Decimal
    begin
        if (TotalRentedDays <= 0) or (DaysInYear() = 0) then
            exit(0);

        exit(Round((TotalRentedDays / DaysInYear()) * 100, 0.01));
    end;

    local procedure AddTotalsRow()
    begin
        TempExcelBuffer.NewRow();
        TempExcelBuffer.AddColumn(TotalsLbl, false, '', true, false, false, '', TempExcelBuffer."Cell Type"::Text);
        TempExcelBuffer.AddColumn('', false, '', false, false, false, '', TempExcelBuffer."Cell Type"::Text);
        TempExcelBuffer.AddColumn('', false, '', false, false, false, '', TempExcelBuffer."Cell Type"::Text);
        TempExcelBuffer.AddColumn('', false, '', false, false, false, '', TempExcelBuffer."Cell Type"::Text);
        TempExcelBuffer.AddColumn('', false, '', false, false, false, '', TempExcelBuffer."Cell Type"::Text);
        TempExcelBuffer.AddColumn('', false, '', false, false, false, '', TempExcelBuffer."Cell Type"::Text);
        TempExcelBuffer.AddColumn('', false, '', false, false, false, '', TempExcelBuffer."Cell Type"::Text);
        TempExcelBuffer.AddColumn('', false, '', false, false, false, '', TempExcelBuffer."Cell Type"::Text);
        TempExcelBuffer.AddColumn(TotalIncomeAmount, false, '#,##0.00 [$EUR]', true, false, false, '', TempExcelBuffer."Cell Type"::Number);
        TempExcelBuffer.AddColumn(TotalExpenseAmount, false, '#,##0.00 [$EUR]', true, false, false, '', TempExcelBuffer."Cell Type"::Number);
        TempExcelBuffer.AddColumn(TotalIncomeAmount - TotalExpenseAmount, false, '#,##0.00 [$EUR]', true, false, false, '', TempExcelBuffer."Cell Type"::Number);
        TempExcelBuffer.AddColumn('', false, '', false, false, false, '', TempExcelBuffer."Cell Type"::Text);
        TempExcelBuffer.AddColumn('', false, '', false, false, false, '', TempExcelBuffer."Cell Type"::Text);
        TempExcelBuffer.AddColumn('', false, '', false, false, false, '', TempExcelBuffer."Cell Type"::Text);

        TempExcelBuffer.NewRow();
        TempExcelBuffer.AddColumn(AssetCountLbl, false, '', true, false, false, '', TempExcelBuffer."Cell Type"::Text);
        TempExcelBuffer.AddColumn(IncludedAssetCount, false, '', false, false, false, '', TempExcelBuffer."Cell Type"::Number);
    end;

    local procedure FinalizeExcel()
    var
        TempBlob: Codeunit "Temp Blob";
        FileOutStream: OutStream;
        FileInStream: InStream;
        DownloadFileName: Text;
    begin
        AddTotalsRow();
        TempExcelBuffer.WriteSheet(SheetNameLbl, CompanyName, UserId);
        TempExcelBuffer.CloseBook();
        DownloadFileName := StrSubstNo('%1_%2.xlsx', ExcelFileName, ReportYear);
        TempExcelBuffer.SetFriendlyFilename(DownloadFileName);

        TempBlob.CreateOutStream(FileOutStream);
        TempExcelBuffer.SaveToStream(FileOutStream, true);

        TempBlob.CreateInStream(FileInStream);
        DownloadFromStream(FileInStream, '', '', '', DownloadFileName);
    end;
}
