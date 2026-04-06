page 96035 "Posted Lease Invoice"
{
    Caption = 'Posted Lease Invoice';
    DeleteAllowed = true;
    InsertAllowed = false;
    ModifyAllowed = false;
    PageType = Document;
    RefreshOnActivate = true;
    SourceTable = "Lease Invoice Header";
    ApplicationArea = All;

    layout
    {
        area(content)
        {
            group(General)
            {
                Caption = 'General';
                field("No."; rec."No.")
                {
                    Editable = false;
                    Importance = Promoted;
                    ToolTip = 'Specifies the number of the involved entry or record, according to the specified number series.';
                }
                field("Contract No.";Rec."Contract No.")
                {
                    Editable = false;
                    Importance = Promoted;
                    ToolTip = 'Specifies the contract number associated with the lease invoice.';
                }
                field("Customer No."; rec."Customer No.")
                {
                    Editable = false;
                    Importance = Promoted;
                    ToolTip = 'Specifies the number of the customer who owns the items on the invoice.';
                }
                field("Contact No."; rec."Contact No.")
                {
                    Editable = false;
                    ToolTip = 'Specifies the number of the contact at the customer to whom you shipped the service.';
                }
                group("Sell-to")
                {
                    Caption = 'Sell-to';
                    field(Name; rec.Name)
                    {
                        Editable = false;
                        ToolTip = 'Specifies the name of the customer on the service invoice.';
                    }
                    field(Address; rec.Address)
                    {
                        Editable = false;
                        ToolTip = 'Specifies the address of the customer on the invoice.';
                    }
                    field("Address 2"; rec."Address 2")
                    {
                        Editable = false;
                        ToolTip = 'Specifies additional address information.';
                    }
                    field(City; rec.City)
                    {
                        Editable = false;
                        ToolTip = 'Specifies the city of the address.';
                    }
                    group(group01)
                    {
                        Visible = IsSellToCountyVisible;
                        field(County; rec.County)
                        {
                            Editable = false;
                        }

                    field("Post Code"; rec."Post Code")
                    {
                        Editable = false;
                        ToolTip = 'Specifies the postal code.';
                    }
                    field("Country/Region Code"; rec."Country/Region Code")
                    {
                    }
                    field("Contact Name"; rec."Contact Name")
                    {
                        Editable = false;
                        ToolTip = 'Specifies the name of the contact person at the customer company.';
                    }
                }
                field("Posting Date"; rec."Posting Date")
                {
                    Editable = false;
                    ToolTip = 'Specifies the date when the invoice was posted.';
                }
                group(Group)
                {
                    Visible = DocExchStatusVisible;
                }
                field("Document Date"; rec."Document Date")
                {
                    Editable = false;
                    ToolTip = 'Specifies the date when the related document was created.';
                }
                field("Salesperson Code"; rec."Salesperson Code")
                {
                    Editable = false;
                    ToolTip = 'Specifies the code of the salesperson associated with the invoice.';
                }
                field("Responsibility Center"; rec."Responsibility Center")
                {
                    Editable = false;
                    ToolTip = 'Specifies the code of the responsibility center, such as a distribution hub, that is associated with the involved user, company, customer, or vendor.';
                }
            }
        }
            part(LeaseInvLines; 96036)
            {
                SubPageLink = "Document No."=FIELD("No.");
            }
            group(Cartera)
            {
                Caption = 'Cartera';
                field("Bank Account No."; rec."Bank Account No.")
                {
                }
                field("Bank Account Name"; rec."Bank Account Name")
                {
                }
            }
            group("Foreign Trade")
            {
                Caption = 'Foreign Trade';
                field("Currency Code"; rec."Currency Code")
                {
                    Importance = Promoted;
                    ToolTip = 'Specifies the currency code for the amounts on the invoice.';

                    trigger OnAssistEdit()
                    begin
                        ChangeExchangeRate.SetParameter(rec."Currency Code", rec."Currency Factor", rec."Posting Date");
                        ChangeExchangeRate.EDITABLE(FALSE);
                        IF ChangeExchangeRate.RUNMODAL = ACTION::OK THEN BEGIN
                            rec."Currency Factor" := ChangeExchangeRate.GetParameter;
                            rec.MODIFY;
                        END;
                        CLEAR(ChangeExchangeRate);
                    end;
                }
            }
        }
    }

    actions
    {
        area(navigation)
        {
        }
        area(processing)
        {
            action("&Print")
            {
                Caption = '&Print';
                Ellipsis = true;
                Image = Print;
                Promoted = true;
                PromotedCategory = Process;
                ToolTip = 'Prepare to print the document. A report request window for the document opens where you can specify what to include on the print-out.';

                trigger OnAction()
                var
                    LeaseInvoiceHeader: Record "Lease Invoice Header";
                begin
                    CurrPage.SETSELECTIONFILTER(LeaseInvoiceHeader);
                    LeaseInvoiceHeader.PrintRecords(TRUE);
                end;
            }
            action("Create Bill")
            {
                Caption = 'Create Bill';
                Image = Invoice;

                trigger OnAction()
                var
                    RealEstateMangement: Codeunit  "Real Estate Management";
                begin
                    RealEstateMangement.CreateBills(Rec);
                end;
            }
            group(Notificaciones)
            {
                Caption = 'Notificaciones';
                action(SendCustom)
                {
                    Caption = 'Send';
                    Ellipsis = true;
                    Image = SendToMultiple;
                    Promoted = true;
                    PromotedCategory = Process;
                    PromotedIsBig = true;
                    ToolTip = 'Prepare to send the document according to the customer''s sending profile, such as attached to an email. The Send document to window opens first so you can confirm or select a sending profile.';

                    trigger OnAction()
                    var
                        LeaseInvoiceHeader: Record "Lease Invoice Header";
                        CustomerRENotifybyEmail: Codeunit "Customer RE-Notify by Email";
                    begin
                        CustomerRENotifybyEmail.NotificarPorCorreoDeudaAlquiler(Rec);
                    end;
                }
            }
        }
    }

    trigger OnAfterGetCurrRecord()
    var
        SIIManagement: Codeunit "SII Management";
    begin
    end;

    trigger OnFindRecord(Which: Text): Boolean
    begin
        IF rec.FIND(Which) THEN
            EXIT(TRUE);
        rec.SETRANGE("No.");
        EXIT(rec.FIND(Which));
    end;

    trigger OnOpenPage()
    var
        SIIManagement: Codeunit "SII Management";
    begin
        ActivateFields;
    end;

    var
        FormatAddress: Codeunit "Format Address";
        ChangeExchangeRate: Page "Change Exchange Rate";
        DocExchStatusStyle: Text;
        DocExchStatusVisible: Boolean;
        IsSellToCountyVisible: Boolean;
        IsShipToCountyVisible: Boolean;
        IsBillToCountyVisible: Boolean;
        OperationDescription: Text[500];

    local procedure ActivateFields()
    begin
        IsSellToCountyVisible := FormatAddress.UseCounty(rec."Country/Region Code");
    end;
}

