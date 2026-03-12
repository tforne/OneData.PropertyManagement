page 96704 "Create Payment Lease Invoice"
{
    Caption = 'Create Payment Lease Invoice';
    PageType = StandardDialog;
    SaveValues = true;

    layout
    {
        area(content)
        {
            group(Control6)
            {
                ShowCaption = false;
                field("Template Name"; JournalTemplateName)
                {
                    ApplicationArea = Basic, Suite;
                    Caption = 'Template Name';
                    ShowMandatory = true;
                    TableRelation = "FRE Jnl. Template".Name;
                    ToolTip = 'Specifies the name of the journal template.';

                    trigger OnLookup(var Text: Text): Boolean
                    var
                        FREJnlTemplate: Record "FRE Jnl. Template";
                        GeneralJournalTemplates: Page "General Journal Templates";
                    begin
                        FREJnlTemplate.FilterGroup(2);
                        FREJnlTemplate.FilterGroup(0);
                        GeneralJournalTemplates.SetTableView(FREJnlTemplate);
                        GeneralJournalTemplates.LookupMode := true;
                        if GeneralJournalTemplates.RunModal() = ACTION::LookupOK then begin
                            GeneralJournalTemplates.GetRecord(FREJnlTemplate);
                            JournalTemplateName := FREJnlTemplate.Name;
                            BatchSelection(JournalTemplateName, JournalBatchName, false);
                        end;
                    end;

                    trigger OnValidate()
                    var
                        FREJnlTemplate: Record "FRE Jnl. Template";
                    begin
                        FREJnlTemplate.Get(JournalTemplateName);
                        BatchSelection(JournalTemplateName, JournalBatchName, false);
                    end;
                }
                field("Batch Name"; JournalBatchName)
                {
                    ApplicationArea = Basic, Suite;
                    Caption = 'Batch Name';
                    ShowMandatory = true;
                    TableRelation = "FRE Jnl. Batch".Name;
                    ToolTip = 'Specifies the name of the journal batch.';

                    trigger OnLookup(var Text: Text): Boolean
                    var
                        FREJournalBatch: Record "FRE Jnl. Batch";
                        FREJournalBatches: Page "FRE Jnl. Batches";
                    begin
                        FREJournalBatch.FilterGroup(2);
                        FREJournalBatch.SetRange("Journal Template Name", JournalTemplateName);
                        FREJournalBatch.FilterGroup(0);

                        FREJournalBatches.SetTableView(FREJournalBatch);
                        FREJournalBatches.LookupMode := true;
                        if FREJournalBatches.RunModal() = ACTION::LookupOK then begin
                            FREJournalBatches.GetRecord(FREJournalBatch);
                            JournalBatchName := FREJournalBatch.Name;
                            BatchSelection(JournalTemplateName, JournalBatchName, false);
                        end;
                    end;

                    trigger OnValidate()
                    begin
                        if JournalBatchName <> '' then
                            BatchSelection(JournalTemplateName, JournalBatchName, false);
                    end;
                }
                field("Posting Date"; PostingDate)
                {
                    ApplicationArea = Basic, Suite;
                    Caption = 'Posting Date';
                    ShowMandatory = true;
                    ToolTip = 'Specifies the entry''s posting date.';

                    trigger OnValidate()
                    begin
                        if JournalBatchName <> '' then
                            BatchSelection(JournalTemplateName, JournalBatchName, false);
                    end;
                }
                field("Starting Document No."; NextDocNo)
                {
                    ApplicationArea = Basic, Suite;
                    Caption = 'Starting Document No.';
                    ShowMandatory = true;
                    ToolTip = 'Specifies a document number for the journal line.';

                    trigger OnValidate()
                    begin
                        if NextDocNo <> '' then
                            if IncStr(NextDocNo) = '' then
                                Error(StartingDocumentNoErr);
                    end;
                }
                field("Bank Account"; BalAccountNo)
                {
                    ApplicationArea = Basic, Suite;
                    Caption = 'Bank Account';
                    TableRelation = "Bank Account";
                    ToolTip = 'Specifies the bank account to which a balancing entry for the journal line will be posted.';
                }
                field("Payment Type"; BankPaymentType)
                {
                    ApplicationArea = Basic, Suite;
                    Caption = 'Payment Type';
                    ToolTip = 'Specifies the code for the payment type to be used for the entry on the payment journal line.';
                }
            }
        }
    }

    actions
    {
    }

    trigger OnOpenPage()
    var
        GenJournalTemplate: Record "Gen. Journal Template";
        GenJournalBatch: Record "Gen. Journal Batch";
        GenJnlManagement: Codeunit GenJnlManagement;
    begin
        PostingDate := WorkDate();

        if not GenJournalTemplate.Get(JournalTemplateName) then
            Clear(JournalTemplateName);
        if not GenJournalBatch.Get(JournalTemplateName, JournalBatchName) then
            Clear(JournalBatchName);

        // if JournalTemplateName = '' then
        //     if GenJnlManagement.TemplateSelectionSimple(GenJournalTemplate, GenJournalTemplate.Type::Payments, false) then
        //         JournalTemplateName := GenJournalTemplate.Name;

        BatchSelection(JournalTemplateName, JournalBatchName, true);
    end;

    trigger OnQueryClosePage(CloseAction: Action): Boolean
    begin
        if CloseAction = ACTION::OK then begin
            if JournalBatchName = '' then
                Error(BatchNumberNotFilledErr);
            if Format(PostingDate) = '' then
                Error(PostingDateNotFilledErr);
            if NextDocNo = '' then
                Error(SpecifyStartingDocNumErr);
        end;
    end;

    var
        PostingDate: Date;
        BalAccountNo: Code[20];
        StartingDocumentNoErr: Label 'The value in the Starting Document No. field must have a number so that we can assign the next number in the series.';
        BatchNumberNotFilledErr: Label 'You must fill the Batch Name field.';
        PostingDateNotFilledErr: Label 'You must fill the Posting Date field.';
        SpecifyStartingDocNumErr: Label 'In the Starting Document No. field, specify the first document number to be used.';
        MessageToRecipientMsg: Label 'Payment of %1 %2 ', Comment = '%1 document type, %2 Document No.';
        EarlierPostingDateErr: Label 'You cannot create a payment with an earlier posting date for %1 %2.', Comment = '%1 - Document Type, %2 - Document No.. You cannot create a payment with an earlier posting date for Invoice INV-001.';
        DocToApplyLbl: Label '%1 %2', Locked = true, Comment = '%1=Document Type;%2=Vendor No.';

    protected var
        NextDocNo: Code[20];
        JournalBatchName: Code[10];
        JournalTemplateName: Code[10];
        BankPaymentType: Enum "Bank Payment Type";

    procedure GetPostingDate(): Date
    begin
        exit(PostingDate);
    end;

    procedure GetBankAccount(): Text
    begin
        exit(Format(BalAccountNo));
    end;

    procedure GetBankPaymentType(): Integer
    begin
        exit(BankPaymentType.AsInteger());
    end;

    procedure GetBatchNumber(): Code[10]
    begin
        exit(JournalBatchName);
    end;

    procedure GetTemplateName(): Code[10]
    begin
        exit(JournalTemplateName);
    end;

    procedure MakeGenJnlLines(var LeaseInvoiceHeader: Record "Lease Invoice Header")
    var
        FREJnlLine: Record "FRE Jnl. Line";
        PaymentAmt: Decimal;
        LeaseInvoicesHeaderView: Text;
        GenJournalDocType: Enum "Gen. Journal Document Type";
        ThereAreNoPaymentsToProccesErr: Label 'There are no payments to process for the selected entries.';
        PaymentApplicationInProcessErr: Label 'A payment application process ''%1'' is in progress for the selected entry no. %2. Make sure you have not applied this entry in ongoing journals or payment reconciliation journals.', Comment = '%1 - A code for the payment application process, %2 - The entry no. that has an ongoing application process';
    begin

        LeaseInvoicesHeaderView := LeaseInvoiceHeader.GetView();
        LeaseInvoiceHeader.SetCurrentKey("No.");
    
        if LeaseInvoiceHeader.Find('-') then
            repeat
                if PostingDate < LeaseInvoiceHeader."Posting Date" then
                    Error(EarlierPostingDateErr, 'Factura alquiler', LeaseInvoiceHeader."No.");
                    if LeaseInvoiceHeader.Open then begin
                        LeaseInvoiceHeader."Applies-to ID" := LeaseInvoiceHeader."No.";
                        CopyLeaseInvoiceHeaderToGenJournalLines(LeaseInvoiceHeader, FREJnlLine);
                    end;
            until LeaseInvoiceHeader.Next() = 0;

        LeaseInvoiceHeader.SetView(LeaseInvoicesHeaderView);
    end;

    local procedure CopyLeaseInvoiceHeaderToGenJournalLines(LeaseInvoiceHeader: Record "Lease Invoice Header"; var FREJnlLine: Record "FRE Jnl. Line")
    var
        Vendor: Record Vendor;
        FREJournalTemplate: Record "FRE Jnl. Template";
        FREJournalBatch: Record "FRE Jnl. Batch";
        REFSetup: record "REF Setup";
        LastLineNo: Integer;
    begin
        FREJnlLine.LockTable();
        FREJournalBatch.Get(JournalTemplateName, JournalBatchName);
        FREJournalTemplate.Get(JournalTemplateName);
        FREJnlLine.SetRange("Journal Template Name", JournalTemplateName);
        FREJnlLine.SetRange("Journal Batch Name", JournalBatchName);
        if FREJnlLine.FindLast() then begin
            LastLineNo := FREJnlLine."Line No.";
            FREJnlLine.Init();
        end;

        FREJnlLine.Init();
        FREJnlLine.Validate("Journal Template Name", JournalTemplateName);
        FREJnlLine.Validate("Journal Batch Name", JournalBatchName);
        LastLineNo += 10000;
        FREJnlLine."Line No." := LastLineNo;
        FREJnlLine."Line Type" := FREJnlLine."Line Type"::Invoice;       
        FREJnlLine."Document Type" := FREJnlLine."Document Type"::Payment;
        FREJnlLine."Fixed Real Estate No." := LeaseInvoiceHeader."Fixed Real Estate No.";

        FREJnlLine."Document No." := LeaseInvoiceHeader."No.";
        FREJnlLine.Validate("Date", LeaseInvoiceHeader."Posting Date");
        FREJnlLine.Description := LeaseInvoiceHeader.Description;
        FREJnlLine.Validate(Amount, LeaseInvoiceHeader.Amount);

        FREJnlLine."Source Type" := FREJnlLine."Source Type"::Customer;
        FREJnlLine."Source No." := LeaseInvoiceHeader."Customer No.";
        FREJnlLine."Source Name" := LeaseInvoiceHeader.Name;
        FREJnlLine."Document Type" := FREJnlLine."Document Type"::Invoice;
        FREJnlLine."Document No." := LeaseInvoiceHeader."No.";
        FREJnlLine."Row No." := REFSetup."Default Income Row No";
        FREJnlLine."Description Row No." := REFSetup."Default Income Row No";
        FREJnlLine.Description := StrSubstNo('%1 %2',FREJnlLine."Document Type",LeaseInvoiceHeader."No.");

        LeaseInvoiceHeader.calcfields(Amount,"Amount Including VAT");
        FREJnlLine.Amount := LeaseInvoiceHeader."Amount";
        FREJnlLine."Amount Including VAT" := LeaseInvoiceHeader."Amount Including VAT";
        FREJnlLine."Ledger Entry No." := 0;
        FREJnlLine.Insert();

    end;



    protected procedure SetNextNo(FREJournalBatchNoSeries: Code[20]; KeepSavedDocumentNo: Boolean)
    var
        FREJnlLine: Record "FRE Jnl. Line";
        NoSeriesBatch: Codeunit "No. Series - Batch";
    begin
        if (FREJournalBatchNoSeries = '') then begin
            if not KeepSavedDocumentNo then
                NextDocNo := ''
        end else begin
            FREJnlLine.SetRange("Journal Template Name", JournalTemplateName);
            FREJnlLine.SetRange("Journal Batch Name", JournalBatchName);
            if FREJnlLine.FindLast() then
                NextDocNo := IncStr(FREJnlLine."Document No.")
            else
                NextDocNo := NoSeriesBatch.GetNextNo(FREJournalBatchNoSeries, PostingDate, true);
        end;
    end;


    local procedure GetMessageToRecipient(LeaseInvoiceHeader: record "Lease Invoice Header"): Text[140]
    var
        VendorLedgerEntry: Record "Vendor Ledger Entry";
        CompanyInformation: Record "Company Information";
        IsHandled: Boolean;
        MessageToRecipient: Text[140];
    begin
        MessageToRecipient := '';
        IsHandled := false;
        if IsHandled then
            exit(MessageToRecipient);

            CompanyInformation.Get();
            exit(CompanyInformation.Name);
    end;

    local procedure BatchSelection(CurrentJnlTemplateName: Code[10]; var CurrentJnlBatchName: Code[10]; KeepSaveDocumentNo: Boolean)
    var
        FREJournalBatch: Record "FRE Jnl. Batch";
        GeJnlManagement: Codeunit "FRE Journals Management";
    begin
        // GenJnlManagement.CheckTemplateName(CurrentJnlTemplateName, CurrentJnlBatchName);
        // FREJournalBatch.Get(CurrentJnlTemplateName, CurrentJnlBatchName);
        // SetNextNo(FREJournalBatch."No. Series", KeepSaveDocumentNo);
        SetNextNo('', KeepSaveDocumentNo);

    end;

}
