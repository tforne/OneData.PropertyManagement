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
                field("Customer No."; rec."Customer No.")
                {
                    ToolTip = 'Specifies the number of the customer who owns the items on the invoice.';
                }
                field(Name; rec.Name)
                {
                    ToolTip = 'Specifies the name of the customer on the service invoice.';
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
            action(SendCustom)
            {
                ApplicationArea = Basic, Suite;
                Caption = 'Send';
                Ellipsis = true;
                Image = SendToMultiple;
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
                Visible = not IsOfficeAddin;

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
                    ToolTip = 'Reverse this posted invoice. A credit memo will be created and matched with the invoice, and the invoice will be canceled. Shipments for the invoice will be reversed. To create a new invoice with the same information, use the Copy function. When you copy an invoice, remember to post shipments for the new invoice.';
                    // Visible = not Rec.Cancelled;

                    trigger OnAction()
                    begin
                        CODEUNIT.Run(CODEUNIT::"Correct PstdSalesInv (Yes/No)", Rec);
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
                    // Visible = not Rec.Cancelled;

                    trigger OnAction()
                    begin
                        CODEUNIT.Run(CODEUNIT::"Cancel PstdSalesInv (Yes/No)", Rec);
                    end;
                }
                action("Crear efecto")
                {

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
        }
    }

    trigger OnAfterGetRecord()
    var
        SIIManagement: Codeunit "SII Management";
    begin
    end;

    trigger OnOpenPage()
    var
        SIISetup: Record "SII Setup";
        OfficeMgt: Codeunit "Office Management";
    begin
        IsOfficeAddin := OfficeMgt.IsAvailable();
        HasPostedLeaseInvoices := true;
    end;

    var
        DocExchStatusStyle: Text;
        DocExchStatusVisible: Boolean;
        StyleText: Text;
        SIIStateVisible: Boolean;
        IsOfficeAddin: Boolean;
        HasPostedLeaseInvoices: Boolean;
}

