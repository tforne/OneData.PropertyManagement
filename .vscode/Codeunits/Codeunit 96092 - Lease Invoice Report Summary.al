codeunit 96092 "Lease Invoice Report Summary"
{
    procedure BuildValidationSummary(ReviewedContracts: Integer; ValidatedContracts: Integer; SkippedContracts: Integer; FailedContracts: Integer; ErrorSummary: Text): Text
    var
        SummaryText: Text;
    begin
        SummaryText := StrSubstNo(
            ValidationSummaryLbl,
            ReviewedContracts,
            ValidatedContracts,
            SkippedContracts,
            FailedContracts);

        exit(AppendErrorSummary(SummaryText, ErrorSummary));
    end;

    procedure BuildCreateSummary(ReviewedContracts: Integer; ProcessedContracts: Integer; SkippedContracts: Integer; CreatedInvoices: Integer; ErrorSummary: Text): Text
    var
        SummaryText: Text;
    begin
        SummaryText := StrSubstNo(
            CreateSummaryLbl,
            ReviewedContracts,
            ProcessedContracts,
            SkippedContracts,
            CreatedInvoices);

        exit(AppendErrorSummary(SummaryText, ErrorSummary));
    end;

    local procedure AppendErrorSummary(SummaryText: Text; ErrorSummary: Text): Text
    begin
        if ErrorSummary <> '' then
            SummaryText += StrSubstNo(ErrorSummaryLbl, ErrorSummary);

        exit(SummaryText);
    end;

    var
        ValidationSummaryLbl: Label 'Test Only summary\\Contracts reviewed: %1\\Contracts validated: %2\\Contracts skipped by amount 0: %3\\Contracts with errors: %4';
        CreateSummaryLbl: Label 'Create Invoices summary\\Contracts reviewed: %1\\Contracts processed: %2\\Contracts skipped by amount 0: %3\\Invoices created: %4';
        ErrorSummaryLbl: Label '\\Errors by contract:\\%1';
}
