page 96034 "Posted Lease Invoices"
{
    ApplicationArea = All;
    Caption = 'Posted Lease Invoices';
    CardPageID = "Posted Lease Invoice";
    Editable = true;
    PageType = List;
    SourceTable = "Lease Invoice Header";
    UsageCategory = History;

    layout
    {
        area(content)
        {
            repeater(Group)
            {
                field("Posting Date"; rec."Posting Date")
                {
                }
                field("No."; rec."No.")
                {
                    ToolTip = 'Specifies the number of the involved entry or record, according to the specified number series.';
                }
                field(Status;Rec.Status)
                {
                    ToolTip = 'Specifies the status of the invoice.';
                }
                field("Customer No."; rec."Customer No.")
                {
                    ToolTip = 'Specifies the number of the customer who owns the items on the invoice.';
                }
                field(Name; rec.Name)
                {
                    ToolTip = 'Specifies the name of the customer on the service invoice.';
                }
                field("Contract No."; rec."Contract No.")
                {
                    ToolTip = 'Specifies the number of the lease contract related to this invoice.';
                }
                field("Real Estate No."; rec."Fixed Real Estate No.")
                {
                    ToolTip = 'Specifies the number of the fixed real estate related to this invoice.';
                }
                field("VAT Registration No."; rec."VAT Registration No.")
                {
                }
                field("Due Date"; rec."Due Date")
                {
                    ToolTip = 'Specifies when the related invoice must be paid.';
                }
                field("Currency Code"; rec."Currency Code")
                {
                    ToolTip = 'Specifies the currency code for the amounts on the invoice.';
                }
                field(Amount; rec.Amount)
                {
                    ToolTip = 'Specifies the total invoice amount excluding VAT.';
                }
                field("Amount Including VAT"; rec."Amount Including VAT")
                {
                    ToolTip = 'Specifies the total invoice amount including VAT.';
                }
                field(VAT; rec."Amount Including VAT" - rec.Amount)
                {
                }
                field("Post Code"; rec."Post Code")
                {
                    ToolTip = 'Specifies the postal code.';
                    Visible = false;
                }
                field("Country/Region Code"; rec."Country/Region Code")
                {
                    ToolTip = 'Specifies the country/region of the address.';
                    Visible = false;
                }
                field("Contact Name"; rec."Contact Name")
                {
                    ToolTip = 'Specifies the name of the contact person at the customer company.';
                    Visible = false;
                }
                field("Salesperson Code"; rec."Salesperson Code")
                {
                    ToolTip = 'Specifies the code of the salesperson associated with the invoice.';
                    Visible = false;
                }
                field("Shortcut Dimension 1 Code"; rec."Shortcut Dimension 1 Code")
                {
                    ToolTip = 'Specifies the code for Shortcut Dimension 1, which is one of two global dimension codes that you set up in the General Ledger Setup window.';
                    Visible = false;
                }
                field("Shortcut Dimension 2 Code"; rec."Shortcut Dimension 2 Code")
                {
                    ToolTip = 'Specifies the code for Shortcut Dimension 2, which is one of two global dimension codes that you set up in the General Ledger Setup window.';
                    Visible = false;
                }
                field("Document Date"; rec."Document Date")
                {
                    ToolTip = 'Specifies the date when the related document was created.';
                    Visible = false;
                }
            }
        }
        area(factboxes)
        {
            systempart(Links; Links)
            {
                Visible = false;
            }
            systempart(Notes; Notes)
            {
                Visible = true;
            }
        }
    }

    actions
    {
       area(processing)
        {
            action("Create Payment")
                {
                    ApplicationArea = Basic, Suite;
                    Caption = 'Create Payment';
                    Image = SuggestVendorPayments;
                    ToolTip = 'Create a payment journal based on the selected invoices.';
                    visible = IsNotCanceled;

                    trigger OnAction()
                    var
                        LeaseInvoices: Record "Lease Invoice Header";
                        GenJournalBatch: Record "FRE Jnl. Batch";
                        GenJnlManagement: Codeunit "FRE Journals Management";
                        CreatePayment: Page "Create Payment Lease Invoice";
                    begin
                        CurrPage.SetSelectionFilter(LeaseInvoices);
                        if CreatePayment.RunModal() = ACTION::OK then begin
                            CreatePayment.MakeGenJnlLines(LeaseInvoices);
                            GetBatchRecord(GenJournalBatch, CreatePayment);
                            GenJnlManagement.TemplateSelectionFromBatch(GenJournalBatch);
                            Clear(CreatePayment);
                        end else
                            Clear(CreatePayment);
                    end;
                }

            action(SendCustom)
            {
                ApplicationArea = Basic, Suite;
                Caption = 'Send';
                Ellipsis = true;
                Image = SendToMultiple;
                Visible = IsNotCanceled;
                ToolTip = 'Prepare to send the document according to the customer''s sending profile, such as attached to an email. The Send document to window opens where you can confirm or select a sending profile.';

                trigger OnAction()
                var
                    LeaseInvHeader: Record "Lease Invoice Header";
                begin
                    LeaseInvHeader := Rec;
                    CurrPage.SetSelectionFilter(LeaseInvHeader);
                    LeaseInvHeader.SendRecords();
                end;
            }
            action(Print)
            {
                ApplicationArea = Basic, Suite;
                Caption = '&Print';
                Ellipsis = true;
                Image = Print;
                ToolTip = 'Prepare to print the document. A report request window for the document opens where you can specify what to include on the print-out.';
                Visible = IsNotCanceled;

                trigger OnAction()
                var
                    LeaseInvHeader: Record "Lease Invoice Header";
                begin
                    LeaseInvHeader := Rec;
                    CurrPage.SetSelectionFilter(LeaseInvHeader);
                    LeaseInvHeader.PrintRecords(true);
                end;
            }
            action(Email)
            {
                ApplicationArea = Basic, Suite;
                Caption = 'Send by &Email';
                Image = Email;
                Promoted = true;
                Visible = IsNotCanceled;
                ToolTip = 'Prepare to send the document by email. The Send Email window opens prefilled for the customer where you can add or change information before you send the email.';

                trigger OnAction()
                var
                    LeaseInvHeader: Record "Lease Invoice Header";
                begin
                    LeaseInvHeader := Rec;
                    CurrPage.SetSelectionFilter(LeaseInvHeader);
                    LeaseInvHeader.EmailRecords(true);
                end;
            }
            action(AttachAsPDF)
            {
                ApplicationArea = Basic, Suite;
                Caption = 'Attach as PDF';
                Image = PrintAttachment;
                ToolTip = 'Create a PDF file and attach it to the document.';
                Visible = IsNotCanceled;

                trigger OnAction()
                var
                    LeaseInvHeader: Record "Lease Invoice Header";
                begin
                    LeaseInvHeader := Rec;
                    CurrPage.SetSelectionFilter(LeaseInvHeader);
                    Rec.PrintToDocumentAttachment(LeaseInvHeader);
                end;
            }
            action(ActivityLog)
            {
                ApplicationArea = Basic, Suite;
                Caption = 'Activity Log';
                Image = Log;
                ToolTip = 'View the status and any errors if the document was sent as an electronic document or OCR file through the document exchange service.';
                Visible = IsNotCanceled;

                trigger OnAction()
                var
                    ActivityLog: Record "Activity Log";
                begin
                    ActivityLog.ShowEntries(Rec.RecordId);
                end;
            }
            group(Correct)
            {
                Caption = 'Correct';
                action(CorrectInvoice)
                {
                    ApplicationArea = Basic, Suite;
                    Caption = 'Correct';
                    Enabled = HasPostedLeaseInvoices;
                    Image = Undo;
                    Scope = Repeater;
                    Visible = false;
                    ToolTip = 'Reverse this posted invoice. A credit memo will be created and matched with the invoice, and the invoice will be canceled. Shipments for the invoice will be reversed. To create a new invoice with the same information, use the Copy function. When you copy an invoice, remember to post shipments for the new invoice.';
                    // Visible = IsNotCanceled;

                    trigger OnAction()
                    begin
                        CODEUNIT.Run(CODEUNIT::"Correct Lease Invoice (Yes/No)", Rec);
                    end;
                }
                action(CancelInvoice)
                {
                    ApplicationArea = Basic, Suite;
                    Caption = 'Cancel';
                    Enabled = HasPostedLeaseInvoices;
                    Image = Cancel;
                    Scope = Repeater;
                    ToolTip = 'Create and post a sales credit memo that reverses this posted sales invoice. This posted sales invoice will be canceled.';
                    Visible = isnotCanceled;

                    trigger OnAction()
                    begin
                        CODEUNIT.Run(CODEUNIT::"Cancel Lease Invoice (Yes/No)", Rec);
                    end;
                }
                action("Crear efecto")
                {
                    ApplicationArea = Basic, Suite;
                    Caption = 'Crear Efecto';
                    Enabled = HasPostedLeaseInvoices;
                    Image = CashFlow;
                    ToolTip = 'Create and post a sales credit memo that reverses this posted sales invoice. This posted sales invoice will be canceled.';
                    Visible = isnotCanceled;

                    trigger OnAction()
                    var
                        RealEstateMangement: Codeunit "Real Estate Management";
                    begin
                        RealEstateMangement.CreateBills(Rec);
                    end;
                }

            }
        }
        area(navigation)
        {
            action(FixedRealState)
            {
                ApplicationArea = Basic, Suite;
                Caption = 'Fixed Real Estate';
                Image = FixedAssets;
                Promoted = true;
                ToolTip = 'View the fixed real estate related to this invoice.';

                trigger OnAction()
                var
                    FixedRealEstate: Record "Fixed Real Estate";
                    FixedRealEstateCard: Page "Fixed Real Estate Card";
                begin
                    if FixedRealEstate.get(Rec."Fixed Real Estate No.") then begin
                        FixedRealEstateCard.SetRecord(FixedRealEstate);
                        FixedRealEstateCard.SetSelectionFilter(FixedRealEstate);
                        FixedRealEstateCard.Run();
                    end;
                end;
            }
            action(LeaseDetails)
            {
                ApplicationArea = Basic, Suite;
                Caption = 'Lease Details';
                Image = ContractPayment;
                promoted = true;
                ToolTip = 'View details of the lease related to this invoice.';

                trigger OnAction()
                var
                    LeaseContract: Record "Lease Contract";
                    LeaseContractCard: Page "Lease Contract Card";
                begin
                    if LeaseContract.get(Rec."Contract No.") then begin
                        LeaseContractCard.SetRecord(LeaseContract);
                        LeaseContractCard.SetSelectionFilter(LeaseContract);
                        leasecontractCard.run();
                    end;
                end;
            }
            
        }
    }


    trigger OnAfterGetRecord()
    begin
        IsNotCanceled := not (rec.Status = "Status Lease Invoice"::Canceled);
    end;

    trigger OnOpenPage()
    begin
        HasPostedLeaseInvoices := true;
    end;

    var
        DocExchStatusStyle: Text;
        DocExchStatusVisible: Boolean;
        StyleText: Text;
        HasPostedLeaseInvoices: Boolean;
        IsNotCanceled: Boolean;

    local procedure GetBatchRecord(var FREJournalBatch: Record "FRE Jnl. Batch"; CreatePayment: Page "Create Payment Lease Invoice")
    var
        FREJournalTemplate: Record "FRE Jnl. Template";
        JournalTemplateName: Code[10];
        JournalBatchName: Code[10];
    begin
        JournalTemplateName := CreatePayment.GetTemplateName();
        JournalBatchName := CreatePayment.GetBatchNumber();

        FREJournalTemplate.Get(JournalTemplateName);
        FREJournalBatch.Get(JournalTemplateName, JournalBatchName);
    end;
}

