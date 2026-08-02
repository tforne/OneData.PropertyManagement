report 96001 "Create Lease Contract Invoices"
{
    ApplicationArea = Service;
    Caption = 'Create Lease Contract Invoices';
    ProcessingOnly = true;
    UsageCategory = Tasks;

    dataset
    {
        dataitem("Lease Contract"; "Lease Contract")
        {
            DataItemTableView = WHERE (Status = CONST (Signed));
            RequestFilterFields = "Customer No.", "Contract No.";

            trigger OnAfterGetRecord()
            begin
                UpdateProgress();

                LeaseContract := "Lease Contract";
                PrepareLeaseContract(LeaseContract);
                NoOfContractsReviewed := NoOfContractsReviewed + 1;

                IF InvoicedAmount = 0 THEN BEGIN
                    NoOfContractsSkipped := NoOfContractsSkipped + 1;
                    AddValidationResult(LeaseContract, ValidationResultBuffer.Status::Skipped, 'Skipped because invoiced amount is 0.');
                    CurrReport.SKIP;
                END;

                IF IsValidationOnlyMode() THEN BEGIN
                    HandleValidationMode(LeaseContract);
                    CurrReport.SKIP;
                END;

                ProcessLeaseContract(LeaseContract);
                NoOfContractsProcessed := NoOfContractsProcessed + 1;
            end;

            trigger OnPostDataItem()
            begin
                IF IsValidationOnlyMode() THEN
                    FlushPendingValidationGroup();

                IF NOT HideDialog THEN
                    Window.CLOSE;

                IF NOT HideDialog THEN
                    MESSAGE(BuildSummaryMessage());

                if IsValidationOnlyMode() then
                    ShowValidationResults();
            end;

            trigger OnPreDataItem()
            begin

                IF PostingDate = 0D THEN
                    ERROR(Text000);

                IF NOT HideDialog THEN
                    IF PostingDate > WORKDATE THEN
                        IF NOT CONFIRM(Text001) THEN
                            ERROR(Text002);

                IF InvoiceToDate = 0D THEN
                    ERROR(Text003);

                IF NOT HideDialog THEN
                    IF InvoiceToDate > WORKDATE THEN
                        IF NOT CONFIRM(Text004) THEN
                            ERROR(Text002);

                SETRANGE("Next Invoice Date", 0D, InvoiceToDate);
                SETRANGE("Starting Date", 0D, InvoiceToDate);
                LastCustomer := '';
                LastContractCombined := FALSE;

                IF NOT HideDialog THEN
                    Window.OPEN(
                      Text005 +
                      '@1@@@@@@@@@@@@@@@@@@@@@@@@@@@@@');

                CounterTotal := COUNT;
                Counter1 := 0;
                Counter2 := 0;
                CounterBreak := 1;
                IF CounterTotal > 0 THEN
                    CounterBreak := ROUND(CounterTotal / 100, 1, '>');
                Currency.InitRoundingPrecision;
            end;
        }
    }

    requestpage
    {

        layout
        {
            area(content)
            {
                group(Options)
                {
                    Caption = 'Options';
                    field(PostingDate; PostingDate)
                    {
                        ApplicationArea = all;
                        Caption = 'Posting Date';
                        ToolTip = 'Specifies the date that you want to use as the posting date on the service invoices created.';
                    }
                    field(InvoiceToDate; InvoiceToDate)
                    {
                        ApplicationArea = all;
                        Caption = 'Invoice to Date';
                        ToolTip = 'Specifies the date up to which you want to invoice contracts. The batch job includes contracts with next invoice dates on or before this date.';
                    }
                    field(CreateInvoices; CreateInvoices)
                    {
                        ApplicationArea = all;
                        Caption = 'Action';
                        OptionCaption = 'Create Invoices,Test Only';
                        ToolTip = 'Specifies whether the report creates invoices or only validates the contracts without creating invoices, history entries, or ledger entries.';
                    }
                    field(StopOnFirstError; StopOnFirstError)
                    {
                        ApplicationArea = All;
                        Caption = 'Stop on first error';
                        ToolTip = 'Specifies whether the process stops as soon as an error is found.';
                    }
                }
            }
        }

        actions
        {
        }
    }

    labels
    {
    }

    trigger OnInitReport()
    begin
        IF NOT SetOptionsCalled THEN
            PostingDate := WORKDATE;
        NoOfInvoices := 0;
        NoOfContractsReviewed := 0;
        NoOfContractsProcessed := 0;
        NoOfContractsValidated := 0;
        NoOfContractsSkipped := 0;
        NoOfContractsFailed := 0;
        ValidationResultLineNo := 0;
        Clear(ErrorSummary);
        Clear(PendingValidationCustomerNo);
        Clear(PendingValidationContractNos);
        ValidationResultBuffer.Reset();
        ValidationResultBuffer.DeleteAll();
    end;

    var
        Text000: Label 'You have not filled in the posting date.';
        Text001: Label 'The posting date is later than the work date.\\Confirm that this is the correct date.';
        Text002: Label 'The program has stopped the batch job at your request.';
        Text003: Label 'You must fill in the Invoice-to Date field.';
        Text004: Label 'The Invoice-to Date is later than the work date.\\Confirm that this is the correct date.';
        Text005: Label 'Creating contract invoices...\\';
        TestSimulationRollbackErr: Label '__ODPM_TEST_ROLLBACK__';
        Cust: Record Customer;
        LeaseContract: Record "Lease Contract";
        LeaseContractLine: Record "Lease Contract Line";
        FixedRealEstate: Record "Fixed Real Estate";
        Currency: Record Currency;
        InvoiceHeader: Record "Sales Header";
        LeaseInvoiceHeader: Record "Lease Invoice Header";
        PaymentMethod: Record "Payment Method";
        PaymentTerms: Record "Payment Terms";
        REFSetup: Record "REF Setup";
        VATPostingSetup: Record "VAT Posting Setup";
        ValidationResultBuffer: Record "OD Lease Invoice Test Buffer" temporary;
        RealEstateMangement: Codeunit "Real Estate Management";
        FREJnlPostLine: Codeunit "FRE Jnl.-Post Line";
        LeaseInvoiceReportSummary: Codeunit "Lease Invoice Report Summary";
        Window: Dialog;
        InvoicedAmount: Decimal;
        NoOfInvoices: Integer;
        NoOfContractsReviewed: Integer;
        NoOfContractsProcessed: Integer;
        NoOfContractsValidated: Integer;
        NoOfContractsSkipped: Integer;
        NoOfContractsFailed: Integer;
        ValidationResultLineNo: Integer;
        CounterTotal: Integer;
        Counter1: Integer;
        Counter2: Integer;
        CounterBreak: Integer;
        ErrorSummary: Text;
        PendingValidationCustomerNo: Code[20];
        PendingValidationContractNos: List of [Code[20]];
        ResultDescription: Text[80];
        InvoiceNo: Code[20];
        LastCustomer: Code[20];
        InvoiceFrom: Date;
        InvoiceTo: Date;
        PostingDate: Date;
        InvoiceToDate: Date;
        LastContractCombined: Boolean;
        CreateInvoices: Option "Create Invoices","Test Only";
        StopOnFirstError: Boolean;
        HideDialog: Boolean;
        SetOptionsCalled: Boolean;

    procedure SetOptions(NewPostingDate: Date; NewInvoiceToDate: Date; NewCreateInvoices: Option "Create Invoices","Test Only")
    begin
        SetOptionsCalled := TRUE;
        PostingDate := NewPostingDate;
        InvoiceToDate := NewInvoiceToDate;
        CreateInvoices := NewCreateInvoices;
    end;

    procedure SetHideDialog(NewHideDialog: Boolean)
    begin
        HideDialog := NewHideDialog;
    end;

    procedure SetStopOnFirstError(NewStopOnFirstError: Boolean)
    begin
        StopOnFirstError := NewStopOnFirstError;
    end;

    internal procedure GetStopOnFirstError(): Boolean
    begin
        exit(StopOnFirstError);
    end;

    internal procedure SetValidationOnlyMode(NewValidationOnly: Boolean)
    begin
        if NewValidationOnly then
            CreateInvoices := CreateInvoices::"Test Only"
        else
            CreateInvoices := CreateInvoices::"Create Invoices";
    end;

    internal procedure GetCreateInvoicesOptionAsInteger(): Integer
    begin
        exit(CreateInvoices);
    end;

    internal procedure GetIsValidationOnlyMode(): Boolean
    begin
        exit(IsValidationOnlyMode());
    end;

    internal procedure EvaluateShouldCreateNewInvoice(CustomerNo: Code[20]; CombineInvoices: Boolean; PreviousCustomerNo: Code[20]; PreviousWasCombined: Boolean): Boolean
    begin
        exit(
            (not CombineInvoices) or
            (PreviousCustomerNo <> CustomerNo) or
            (not PreviousWasCombined));
    end;

    internal procedure GetContractResultDescription(ContractNo: Code[20]; FromDate: Date; ToDate: Date): Text
    begin
        exit(StrSubstNo('Segun contrato %1 periodo :%2 %3', ContractNo, FromDate, ToDate));
    end;

    local procedure UpdateProgress()
    begin
        IF HideDialog THEN
            exit;

        Counter1 := Counter1 + 1;
        Counter2 := Counter2 + 1;
        IF Counter2 >= CounterBreak THEN BEGIN
            Counter2 := 0;
            Window.UPDATE(1, ROUND(Counter1 / CounterTotal * 10000, 1));
        END;
    end;

    local procedure PrepareLeaseContract(var LeaseContractToProcess: Record "Lease Contract")
    begin
        Cust.GET(LeaseContractToProcess."Customer No.");
        ResultDescription := '';
        RealEstateMangement.GetNextInvoicePeriod(LeaseContractToProcess, InvoiceFrom, InvoiceTo);
        InvoicedAmount := ROUND(
            RealEstateMangement.CalcContractAmount(LeaseContractToProcess, InvoiceFrom, InvoiceTo),
            Currency."Amount Rounding Precision");
    end;

    local procedure ProcessLeaseContract(var LeaseContractToProcess: Record "Lease Contract")
    begin
        IF ShouldCreateNewInvoice(LeaseContractToProcess) THEN BEGIN
            InvoiceNo := RealEstateMangement.CreateInvoiceLeaseContract(LeaseContractToProcess, PostingDate, FALSE, InvoiceHeader, LeaseInvoiceHeader);
            NoOfInvoices := NoOfInvoices + 1;
        END;

        ResultDescription := CopyStr(
            BuildContractResultDescription(LeaseContractToProcess, InvoiceFrom, InvoiceTo),
            1,
            MaxStrLen(ResultDescription));
        RealEstateMangement.CreateAllLeaseContractLines(InvoiceNo, LeaseContractToProcess, InvoiceHeader, LeaseInvoiceHeader, ResultDescription);
        LeaseInvoiceHeader.RecalculateIRPFLeaseInvoice(LeaseInvoiceHeader);
        LastCustomer := LeaseContractToProcess."Customer No.";
        LastContractCombined := LeaseContractToProcess."Combine Invoices";
        FREJnlPostLine.PostFRELedgerEntryFromLeaseInvoice(LeaseInvoiceHeader);
    end;

    local procedure ShouldCreateNewInvoice(LeaseContractToProcess: Record "Lease Contract"): Boolean
    begin
        exit(
            EvaluateShouldCreateNewInvoice(
                LeaseContractToProcess."Customer No.",
                LeaseContractToProcess."Combine Invoices",
                LastCustomer,
                LastContractCombined));
    end;

    local procedure IsValidationOnlyMode(): Boolean
    begin
        EXIT(CreateInvoices <> CreateInvoices::"Create Invoices");
    end;

    local procedure BuildContractResultDescription(var LeaseContractToDescribe: Record "Lease Contract"; FromDate: Date; ToDate: Date): Text
    begin
        exit(GetContractResultDescription(LeaseContractToDescribe."Contract No.", FromDate, ToDate));
    end;

    local procedure HandleValidationMode(var LeaseContractToValidate: Record "Lease Contract")
    begin
        if LeaseContractToValidate."Combine Invoices" then begin
            if HasPendingValidationGroup() and IsSamePendingValidationGroup(LeaseContractToValidate) then
                AddPendingValidationContract(LeaseContractToValidate)
            else begin
                FlushPendingValidationGroup();
                StartPendingValidationGroup(LeaseContractToValidate);
            end;
        end else begin
            FlushPendingValidationGroup();
            if SimulateLeaseContractForTest(LeaseContractToValidate) then
                RegisterValidationSuccess(LeaseContractToValidate)
            else
                NoOfContractsFailed := NoOfContractsFailed + 1;
        end;
    end;

    local procedure HasPendingValidationGroup(): Boolean
    begin
        exit(PendingValidationContractNos.Count() > 0);
    end;

    local procedure IsSamePendingValidationGroup(var LeaseContractToValidate: Record "Lease Contract"): Boolean
    begin
        exit(PendingValidationCustomerNo = LeaseContractToValidate."Customer No.");
    end;

    local procedure StartPendingValidationGroup(var LeaseContractToValidate: Record "Lease Contract")
    begin
        Clear(PendingValidationContractNos);
        PendingValidationCustomerNo := LeaseContractToValidate."Customer No.";
        AddPendingValidationContract(LeaseContractToValidate);
    end;

    local procedure AddPendingValidationContract(var LeaseContractToValidate: Record "Lease Contract")
    begin
        PendingValidationContractNos.Add(LeaseContractToValidate."Contract No.");
    end;

    local procedure FlushPendingValidationGroup()
    var
        PendingCount: Integer;
    begin
        PendingCount := PendingValidationContractNos.Count();
        if PendingCount = 0 then
            exit;

        if SimulatePendingValidationGroup() then
            RegisterPendingValidationSuccess()
        else
            NoOfContractsFailed := NoOfContractsFailed + PendingCount;

        Clear(PendingValidationContractNos);
        Clear(PendingValidationCustomerNo);
    end;

    local procedure ValidateLeaseContractForTest(var LeaseContractToValidate: Record "Lease Contract")
    var
        BillToCustomer: Record Customer;
    begin
        FixedRealEstate.GET(LeaseContractToValidate."Fixed Real Estate No.");
        REFSetup.GET();
        REFSetup.TESTFIELD("Contract Lease Invoice Nos.");
        REFSetup.TESTFIELD("Journal Template Name");
        REFSetup.TESTFIELD("Journal Batch Name");
        REFSetup.TESTFIELD("Default Income Row No");

        LeaseContractToValidate.TESTFIELD("Customer No.");
        Cust.GET(LeaseContractToValidate."Customer No.");
        Cust.TESTFIELD("Gen. Bus. Posting Group");
        Cust.TESTFIELD("VAT Bus. Posting Group");
        Cust.CheckBlockedCustOnDocs(Cust, InvoiceHeader."Document Type"::Invoice, FALSE, FALSE);

        IF LeaseContractToValidate."Second Customer No." <> '' THEN BEGIN
            BillToCustomer.GET(LeaseContractToValidate."Second Customer No.");
            BillToCustomer.TESTFIELD("VAT Bus. Posting Group");
        END ELSE
            BillToCustomer := Cust;

        IF LeaseContractToValidate."Payment Terms Code" <> '' THEN
            PaymentTerms.GET(LeaseContractToValidate."Payment Terms Code");

        IF LeaseContractToValidate."Payment Method Code" <> '' THEN
            PaymentMethod.GET(LeaseContractToValidate."Payment Method Code");

        IF FixedRealEstate.Acquired THEN
            REFSetup.TESTFIELD("Contract Invoice Nos.");

        LeaseContractLine.RESET;
        LeaseContractLine.SETRANGE("Contract No.", LeaseContractToValidate."Contract No.");
        IF LeaseContractLine.FINDSET() THEN
            REPEAT
                if LeaseContractLine.Type = LeaseContractLine.Type::" " then
                    continue;

                LeaseContractLine.TESTFIELD("Account No.");
                LeaseContractLine.TESTFIELD("VAT Prod. Posting Group");
                VATPostingSetup.GET(
                    BillToCustomer."VAT Bus. Posting Group",
                    LeaseContractLine."VAT Prod. Posting Group");
                IF LeaseContractLine.Type = LeaseContractLine.Type::"Allocation Account" THEN
                    ERROR(
                        'The lease contract line %1 uses type %2. Invoice generation only supports G/L Account lines.',
                        LeaseContractLine."Line No.",
                        FORMAT(LeaseContractLine.Type));
            UNTIL LeaseContractLine.NEXT() = 0;
    end;

    local procedure SimulateLeaseContractForTest(var LeaseContractToValidate: Record "Lease Contract"): Boolean
    var
        ErrorText: Text;
    begin
        ClearLastError();
        if TrySimulateLeaseContractForTest(LeaseContractToValidate) then
            exit(true);

        ErrorText := GetLastErrorText();
        if ErrorText = TestSimulationRollbackErr then
            exit(true);

        RegisterValidationError(LeaseContractToValidate, ErrorText);
        AppendContractError(LeaseContractToValidate."Contract No.", ErrorText);
        IF StopOnFirstError THEN
            Error(ErrorText);
        exit(false);
    end;

    local procedure SimulatePendingValidationGroup(): Boolean
    var
        ErrorText: Text;
    begin
        ClearLastError();
        if TrySimulatePendingValidationGroup() then
            exit(true);

        ErrorText := GetLastErrorText();
        if ErrorText = TestSimulationRollbackErr then
            exit(true);

        RegisterPendingValidationError(ErrorText);
        AppendContractError(BuildPendingValidationContractList(), ErrorText);
        IF StopOnFirstError THEN
            Error(ErrorText);
        exit(false);
    end;

    [TryFunction]
    local procedure TrySimulateLeaseContractForTest(var LeaseContractToValidate: Record "Lease Contract")
    var
        TestInvoiceHeader: Record "Sales Header";
        TestLeaseInvoiceHeader: Record "Lease Invoice Header";
        TestInvoiceNo: Code[20];
        TestResultDescription: Text[80];
        TestInvoiceFrom: Date;
        TestInvoiceTo: Date;
    begin
        ValidateLeaseContractForTest(LeaseContractToValidate);
        RealEstateMangement.GetNextInvoicePeriod(LeaseContractToValidate, TestInvoiceFrom, TestInvoiceTo);

        TestInvoiceNo := RealEstateMangement.CreateInvoiceLeaseContract(
            LeaseContractToValidate,
            PostingDate,
            FALSE,
            TestInvoiceHeader,
            TestLeaseInvoiceHeader);

        TestResultDescription := CopyStr(
            BuildContractResultDescription(LeaseContractToValidate, TestInvoiceFrom, TestInvoiceTo),
            1,
            MaxStrLen(TestResultDescription));
        RealEstateMangement.CreateAllLeaseContractLines(
            TestInvoiceNo,
            LeaseContractToValidate,
            TestInvoiceHeader,
            TestLeaseInvoiceHeader,
            TestResultDescription);
        TestLeaseInvoiceHeader.RecalculateIRPFLeaseInvoice(TestLeaseInvoiceHeader);
        FREJnlPostLine.PostFRELedgerEntryFromLeaseInvoice(TestLeaseInvoiceHeader);

        Error(TestSimulationRollbackErr);
    end;

    [TryFunction]
    local procedure TrySimulatePendingValidationGroup()
    var
        GroupLeaseContract: Record "Lease Contract";
        TestInvoiceHeader: Record "Sales Header";
        TestLeaseInvoiceHeader: Record "Lease Invoice Header";
        TestInvoiceNo: Code[20];
        TestResultDescription: Text[80];
        GroupInvoiceFrom: Date;
        GroupInvoiceTo: Date;
        PendingContractNo: Code[20];
        IsFirstContract: Boolean;
    begin
        IsFirstContract := true;

        foreach PendingContractNo in PendingValidationContractNos do begin
            GroupLeaseContract.Get(PendingContractNo);
            ValidateLeaseContractForTest(GroupLeaseContract);
            RealEstateMangement.GetNextInvoicePeriod(GroupLeaseContract, GroupInvoiceFrom, GroupInvoiceTo);

            if IsFirstContract then begin
                TestInvoiceNo := RealEstateMangement.CreateInvoiceLeaseContract(
                    GroupLeaseContract,
                    PostingDate,
                    FALSE,
                    TestInvoiceHeader,
                    TestLeaseInvoiceHeader);
                IsFirstContract := false;
            end;

            TestResultDescription := CopyStr(
                BuildContractResultDescription(GroupLeaseContract, GroupInvoiceFrom, GroupInvoiceTo),
                1,
                MaxStrLen(TestResultDescription));
            RealEstateMangement.CreateAllLeaseContractLines(
                TestInvoiceNo,
                GroupLeaseContract,
                TestInvoiceHeader,
                TestLeaseInvoiceHeader,
                TestResultDescription);
            TestLeaseInvoiceHeader.RecalculateIRPFLeaseInvoice(TestLeaseInvoiceHeader);
            FREJnlPostLine.PostFRELedgerEntryFromLeaseInvoice(TestLeaseInvoiceHeader);
        end;

        Error(TestSimulationRollbackErr);
    end;

    local procedure AppendContractError(ContractNo: Code[20]; ErrorText: Text)
    begin
        if ErrorSummary <> '' then
            ErrorSummary += '\\';
        ErrorSummary += StrSubstNo('%1: %2', ContractNo, ErrorText);
    end;

    local procedure BuildPendingValidationContractList(): Text
    var
        PendingContractNo: Code[20];
        ContractList: Text;
    begin
        foreach PendingContractNo in PendingValidationContractNos do begin
            if ContractList <> '' then
                ContractList += ', ';
            ContractList += PendingContractNo;
        end;

        exit(ContractList);
    end;

    local procedure BuildSummaryMessage(): Text
    begin
        if IsValidationOnlyMode() then
            exit(LeaseInvoiceReportSummary.BuildValidationSummary(
                NoOfContractsReviewed,
                NoOfContractsValidated,
                NoOfContractsSkipped,
                NoOfContractsFailed,
                ErrorSummary));

        exit(LeaseInvoiceReportSummary.BuildCreateSummary(
                NoOfContractsReviewed,
                NoOfContractsProcessed,
                NoOfContractsSkipped,
                NoOfInvoices,
                ErrorSummary));
    end;

    local procedure AddValidationResult(var LeaseContractToLog: Record "Lease Contract"; ResultStatus: Option Validated,Skipped,Error; ResultMessage: Text[250])
    begin
        ValidationResultLineNo += 1;
        ValidationResultBuffer.Init();
        ValidationResultBuffer."Line No." := ValidationResultLineNo;
        ValidationResultBuffer."Contract No." := LeaseContractToLog."Contract No.";
        ValidationResultBuffer."Customer No." := LeaseContractToLog."Customer No.";
        ValidationResultBuffer.PostingDate := PostingDate;
        ValidationResultBuffer.InvoiceFrom := InvoiceFrom;
        ValidationResultBuffer.InvoiceTo := InvoiceTo;
        ValidationResultBuffer.TestAmount := InvoicedAmount;
        ValidationResultBuffer.Status := ResultStatus;
        ValidationResultBuffer."Combined Invoice Group" := LeaseContractToLog."Combine Invoices";
        ValidationResultBuffer.Message := ResultMessage;
        ValidationResultBuffer.Insert();
    end;

    local procedure RegisterValidationSuccess(var LeaseContractToLog: Record "Lease Contract")
    begin
        NoOfContractsValidated := NoOfContractsValidated + 1;
        AddValidationResult(LeaseContractToLog, ValidationResultBuffer.Status::Validated, 'Validated successfully.');
    end;

    local procedure RegisterValidationError(var LeaseContractToLog: Record "Lease Contract"; ErrorText: Text)
    begin
        AddValidationResult(LeaseContractToLog, ValidationResultBuffer.Status::Error, CopyStr(ErrorText, 1, MaxStrLen(ValidationResultBuffer.Message)));
    end;

    local procedure RegisterPendingValidationSuccess()
    var
        LeaseContractToLog: Record "Lease Contract";
        PendingContractNo: Code[20];
        PendingInvoiceFrom: Date;
        PendingInvoiceTo: Date;
    begin
        foreach PendingContractNo in PendingValidationContractNos do begin
            LeaseContractToLog.Get(PendingContractNo);
            RealEstateMangement.GetNextInvoicePeriod(LeaseContractToLog, PendingInvoiceFrom, PendingInvoiceTo);
            InvoiceFrom := PendingInvoiceFrom;
            InvoiceTo := PendingInvoiceTo;
            InvoicedAmount := ROUND(
                RealEstateMangement.CalcContractAmount(LeaseContractToLog, PendingInvoiceFrom, PendingInvoiceTo),
                Currency."Amount Rounding Precision");
            RegisterValidationSuccess(LeaseContractToLog);
        end;
    end;

    local procedure RegisterPendingValidationError(ErrorText: Text)
    var
        LeaseContractToLog: Record "Lease Contract";
        PendingContractNo: Code[20];
        PendingInvoiceFrom: Date;
        PendingInvoiceTo: Date;
    begin
        foreach PendingContractNo in PendingValidationContractNos do begin
            LeaseContractToLog.Get(PendingContractNo);
            RealEstateMangement.GetNextInvoicePeriod(LeaseContractToLog, PendingInvoiceFrom, PendingInvoiceTo);
            InvoiceFrom := PendingInvoiceFrom;
            InvoiceTo := PendingInvoiceTo;
            InvoicedAmount := ROUND(
                RealEstateMangement.CalcContractAmount(LeaseContractToLog, PendingInvoiceFrom, PendingInvoiceTo),
                Currency."Amount Rounding Precision");
            RegisterValidationError(LeaseContractToLog, ErrorText);
        end;
    end;

    local procedure ShowValidationResults()
    var
        ValidationResultsPage: Page "OD Lease Invoice Test Results";
    begin
        if ValidationResultBuffer.IsEmpty() then
            exit;

        Clear(ValidationResultsPage);
        ValidationResultsPage.LoadResults(ValidationResultBuffer);
        ValidationResultsPage.RunModal();
    end;
}

