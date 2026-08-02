codeunit 96090 "Create Lease Invoice Rep Tests"
{
    Subtype = Test;
    TestPermissions = Disabled;

    [Test]
    procedure ValidationModeIsFalseForCreateInvoices()
    var
        CreateLeaseInvoicesReport: Report "Create Lease Contract Invoices";
    begin
        SetValidationOnlyMode(CreateLeaseInvoicesReport, false);
        AssertFalse(CreateLeaseInvoicesReport.GetIsValidationOnlyMode(), 'Create Invoices should not run in validation-only mode.');
    end;

    [Test]
    procedure ValidationModeIsTrueForTestOnly()
    var
        CreateLeaseInvoicesReport: Report "Create Lease Contract Invoices";
    begin
        SetValidationOnlyMode(CreateLeaseInvoicesReport, true);
        AssertTrue(CreateLeaseInvoicesReport.GetIsValidationOnlyMode(), 'Test Only should run in validation-only mode.');
    end;

    [Test]
    procedure ValidationModeCanSwitchBackToCreateInvoices()
    var
        CreateLeaseInvoicesReport: Report "Create Lease Contract Invoices";
    begin
        SetValidationOnlyMode(CreateLeaseInvoicesReport, true);
        SetValidationOnlyMode(CreateLeaseInvoicesReport, false);

        AssertFalse(CreateLeaseInvoicesReport.GetIsValidationOnlyMode(), 'The report should switch back to Create Invoices mode.');
    end;

    [Test]
    procedure ValidationModeSetterUpdatesUnderlyingOption()
    var
        CreateLeaseInvoicesReport: Report "Create Lease Contract Invoices";
    begin
        SetValidationOnlyMode(CreateLeaseInvoicesReport, true);
        AssertEqualInteger(1, CreateLeaseInvoicesReport.GetCreateInvoicesOptionAsInteger(), 'The underlying option should point to Test Only.');

        SetValidationOnlyMode(CreateLeaseInvoicesReport, false);
        AssertEqualInteger(0, CreateLeaseInvoicesReport.GetCreateInvoicesOptionAsInteger(), 'The underlying option should point to Create Invoices.');
    end;

    [Test]
    procedure StopOnFirstErrorCanBeEnabled()
    var
        CreateLeaseInvoicesReport: Report "Create Lease Contract Invoices";
    begin
        CreateLeaseInvoicesReport.SetStopOnFirstError(true);

        AssertTrue(CreateLeaseInvoicesReport.GetStopOnFirstError(), 'Stop on first error should be enabled.');
    end;

    [Test]
    procedure StopOnFirstErrorCanBeDisabled()
    var
        CreateLeaseInvoicesReport: Report "Create Lease Contract Invoices";
    begin
        CreateLeaseInvoicesReport.SetStopOnFirstError(true);
        CreateLeaseInvoicesReport.SetStopOnFirstError(false);

        AssertFalse(CreateLeaseInvoicesReport.GetStopOnFirstError(), 'Stop on first error should be disabled.');
    end;

    [Test]
    procedure StopOnFirstErrorIsDisabledByDefault()
    var
        CreateLeaseInvoicesReport: Report "Create Lease Contract Invoices";
    begin
        AssertFalse(CreateLeaseInvoicesReport.GetStopOnFirstError(), 'Stop on first error should be disabled by default.');
    end;

    [Test]
    procedure ShouldCreateNewInvoiceWhenCombineInvoicesIsFalse()
    var
        CreateLeaseInvoicesReport: Report "Create Lease Contract Invoices";
    begin
        AssertTrue(CreateLeaseInvoicesReport.EvaluateShouldCreateNewInvoice('CUST1', false, 'CUST1', true), 'A new invoice must be created when Combine Invoices is false.');
    end;

    [Test]
    procedure ShouldReuseInvoiceWhenCustomerMatchesAndPreviousWasCombined()
    var
        CreateLeaseInvoicesReport: Report "Create Lease Contract Invoices";
    begin
        AssertFalse(CreateLeaseInvoicesReport.EvaluateShouldCreateNewInvoice('CUST1', true, 'CUST1', true), 'The invoice should be reused for the same customer when the previous contract was combined.');
    end;

    [Test]
    procedure ShouldCreateNewInvoiceWhenCustomerChanges()
    var
        CreateLeaseInvoicesReport: Report "Create Lease Contract Invoices";
    begin
        AssertTrue(CreateLeaseInvoicesReport.EvaluateShouldCreateNewInvoice('CUST2', true, 'CUST1', true), 'A new invoice must be created when the customer changes.');
    end;

    [Test]
    procedure ShouldCreateNewInvoiceWhenPreviousWasNotCombined()
    var
        CreateLeaseInvoicesReport: Report "Create Lease Contract Invoices";
    begin
        AssertTrue(CreateLeaseInvoicesReport.EvaluateShouldCreateNewInvoice('CUST1', true, 'CUST1', false), 'A new invoice must be created when the previous contract was not combined.');
    end;

    [Test]
    procedure ShouldCreateNewInvoiceWhenPreviousCustomerIsBlank()
    var
        CreateLeaseInvoicesReport: Report "Create Lease Contract Invoices";
    begin
        AssertTrue(CreateLeaseInvoicesReport.EvaluateShouldCreateNewInvoice('CUST1', true, '', true), 'A new invoice must be created when there is no previous customer.');
    end;

    [Test]
    procedure ContractResultDescriptionIncludesContractNo()
    var
        CreateLeaseInvoicesReport: Report "Create Lease Contract Invoices";
        DescriptionText: Text;
    begin
        DescriptionText := CreateLeaseInvoicesReport.GetContractResultDescription('CONT001', DMY2Date(1, 1, 2026), DMY2Date(31, 1, 2026));

        AssertTrue(StrPos(DescriptionText, 'CONT001') > 0, 'The generated description should contain the contract number.');
    end;

    [Test]
    procedure ContractResultDescriptionIncludesInvoicePeriodDates()
    var
        CreateLeaseInvoicesReport: Report "Create Lease Contract Invoices";
        DescriptionText: Text;
    begin
        DescriptionText := CreateLeaseInvoicesReport.GetContractResultDescription('CONT001', DMY2Date(1, 2, 2026), DMY2Date(28, 2, 2026));

        AssertTrue(StrPos(DescriptionText, Format(DMY2Date(1, 2, 2026))) > 0, 'The generated description should contain the invoice start date.');
        AssertTrue(StrPos(DescriptionText, Format(DMY2Date(28, 2, 2026))) > 0, 'The generated description should contain the invoice end date.');
    end;

    [Test]
    procedure ValidationSummaryIncludesValidationCounters()
    var
        LeaseInvoiceReportSummary: Codeunit "Lease Invoice Report Summary";
        SummaryText: Text;
    begin
        SummaryText := LeaseInvoiceReportSummary.BuildValidationSummary(10, 7, 2, 1, '');

        AssertTrue(StrPos(SummaryText, 'Test Only summary') > 0, 'The summary should indicate test mode.');
        AssertTrue(StrPos(SummaryText, 'Contracts reviewed: 10') > 0, 'The summary should include reviewed contracts.');
        AssertTrue(StrPos(SummaryText, 'Contracts validated: 7') > 0, 'The summary should include validated contracts.');
        AssertTrue(StrPos(SummaryText, 'Contracts skipped by amount 0: 2') > 0, 'The summary should include skipped contracts.');
        AssertTrue(StrPos(SummaryText, 'Contracts with errors: 1') > 0, 'The summary should include contracts with errors.');
    end;

    [Test]
    procedure CreateInvoicesSummaryIncludesProcessingCounters()
    var
        LeaseInvoiceReportSummary: Codeunit "Lease Invoice Report Summary";
        SummaryText: Text;
    begin
        SummaryText := LeaseInvoiceReportSummary.BuildCreateSummary(8, 6, 2, 4, '');

        AssertTrue(StrPos(SummaryText, 'Create Invoices summary') > 0, 'The summary should indicate create mode.');
        AssertTrue(StrPos(SummaryText, 'Contracts reviewed: 8') > 0, 'The summary should include reviewed contracts.');
        AssertTrue(StrPos(SummaryText, 'Contracts processed: 6') > 0, 'The summary should include processed contracts.');
        AssertTrue(StrPos(SummaryText, 'Contracts skipped by amount 0: 2') > 0, 'The summary should include skipped contracts.');
        AssertTrue(StrPos(SummaryText, 'Invoices created: 4') > 0, 'The summary should include created invoices.');
    end;

    [Test]
    procedure SummaryIncludesErrorBreakdownWhenPresent()
    var
        LeaseInvoiceReportSummary: Codeunit "Lease Invoice Report Summary";
        SummaryText: Text;
    begin
        SummaryText := LeaseInvoiceReportSummary.BuildValidationSummary(3, 2, 0, 1, 'CONT001: Missing setup');

        AssertTrue(StrPos(SummaryText, 'Errors by contract:') > 0, 'The summary should include the error breakdown header.');
        AssertTrue(StrPos(SummaryText, 'CONT001: Missing setup') > 0, 'The summary should include the contract error details.');
    end;

    local procedure SetValidationOnlyMode(var CreateLeaseInvoicesReport: Report "Create Lease Contract Invoices"; ValidationOnly: Boolean)
    begin
        CreateLeaseInvoicesReport.SetValidationOnlyMode(ValidationOnly);
    end;

    local procedure AssertTrue(Condition: Boolean; FailureMessage: Text)
    begin
        if not Condition then
            Error(FailureMessage);
    end;

    local procedure AssertFalse(Condition: Boolean; FailureMessage: Text)
    begin
        if Condition then
            Error(FailureMessage);
    end;

    local procedure AssertEqualInteger(ExpectedValue: Integer; ActualValue: Integer; FailureMessage: Text)
    begin
        if ExpectedValue <> ActualValue then
            Error('%1 Expected: %2 Actual: %3', FailureMessage, ExpectedValue, ActualValue);
    end;
}
