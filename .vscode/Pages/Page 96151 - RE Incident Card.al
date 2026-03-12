page 96151 "RE Incident Card"
{
    PageType = Card;
    SourceTable = "Incident Assets Real Estate";
    Caption = 'Real Estate Incident';

    UsageCategory = Administration;
    ApplicationArea = All;

    layout
    {
        area(content)
        {
            group(General)
            {
                field("Incident Id."; rec."Incident Id.")
                {
                    Editable = false;
                    Visible = false;
                }

                field(Title; rec.Title)
                {
                }
                field(Description; rec.Description)
                {
                    MultiLine = true;
                }
                field("Incident Type"; rec."Case Type")
                {
                }
                field(Status; rec.StateCode)
                {
                    Editable = true;
                }
                field("Fixed Real Estate No."; rec."Fixed Real Estate No.")
                {
                }
                field("Contract No."; rec."Contract No.")
                {
                }
                field("Contact No"; rec."Contact No")
                {
                }
                field("Contact Name"; ContractContactName)
                {
                    Editable = false;
                }
                field("Contract Phone No."; ContractPhoneNo)
                {
                    Caption = 'Contract Phone No.';
                    ExtendedDatatype = PhoneNo;
                    Editable = false;
                }
                field("Contract E-Mail";ContractEMail)
                {
                    Caption = 'Email';
                    ExtendedDatatype = EMail;
                    Editable = false;
                }
            }
            part(CommentLines; 96058)
            {
                ApplicationArea = All;
                SubPageLink = "Incident Id."=FIELD("Incident Id.");
            }
            group(Management)
            {
                field(Priority; rec.Priority)
                {
                }
                field("Expected Resolution Date"; rec."Expected Resolution Date")
                {
                }
            }

            group(Audit)
            {
                field("Incident Date"; rec."Incident Date")
                {
                    Editable = false;
                }
                field("Resolution Date"; rec."Resolution Date")
                {
                    Editable = false;
                }
            }
        }
        area(factboxes)
        {
            part(IncidentAttachFactBox; "Incident Attach. FactBox")
            {
                ApplicationArea = Basic, Suite;
                ShowFilter = false;
                SubPageLink = "Incident Id." = field("Incident Id.");
            }
            systempart(Control19; Notes)
            {
                ApplicationArea = Notes;
                Visible = false;
            }
            systempart(Control20; MyNotes)
            {
                ApplicationArea = Basic, Suite;
                Visible = false;
            }
            systempart(Control21; Links)
            {
                ApplicationArea = RecordLinks;
                Visible = false;
            }
        }
    }

    actions
    {
        area(processing)
        {
            group(process)
            {
            action(StartProgress)
            {
                Caption = 'Start Progress';
                Image = Start;

                trigger OnAction()
                begin
                    SetStatusInProgress();
                end;
            }

            action(MarkResolved)
            {
                Caption = 'Mark as Resolved';
                Image = Approve;

                trigger OnAction()
                begin
                    SetStatusResolved();
                end;
            }

            action(CloseIncident)
            {
                Caption = 'Close Incident';
                Image = Close;

                trigger OnAction()
                begin
                    CloseIncidentAction();
                end;
            }
            group(Notificaciones)
            {
                Caption = 'Notificaciones';
                action(SendCustom)
                {
                    ApplicationArea = All;
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
                        CustomerRENotifybyEmail."NotificarPorCorreoRecepciónIncidencia"(Rec);
                    end;
                }
            }

        }
        action(AttachFile)
        {
            ApplicationArea = Basic, Suite;
            Caption = 'Attach File';
            Promoted = true;
            Image = Attach;
            Scope = Repeater;
            ToolTip = 'Attach a file to the incident record.';

            trigger OnAction()
            begin
                Rec.ImportAttachment(Rec);
            end;
        }
        }
    }
    trigger OnAfterGetCurrRecord()
    begin
        if rec.StateCode = rec.StateCode::Resolved then
            CurrPage.Editable(false)
        else
            CurrPage.Editable(true);
        
        ContractContactName := '';
        ContractPhoneNo := '';
        ContractEMail := '';
    
        if Contract.get(rec."Contract No.") then begin
            ContractContactName := contract."Contact Name";
            ContractPhoneNo := Contract."Phone No.";
            ContractEMail := Contract."E-Mail";
        end;
    end;

    var
        Contract : record "Lease Contract";
        Contact : Record "Contact";
        Customer : Record Customer;
        ContractContactName : text;
        ContractPhoneNo : Text[30];
        ContractEMail : Text[80];

    local procedure SetStatusInProgress()
    begin
        rec.StateCode := rec.StateCode::Active;
        rec.Modify(true);
    end;

    local procedure SetStatusResolved()
    begin
        rec.StateCode := Rec.StateCode::Resolved;
        rec."Resolution Date" := Today;
        rec.Modify(true);
    end;

    local procedure CloseIncidentAction()
    begin
        if rec.StateCode <> rec.StateCode::Resolved then
            Error('The incident must be resolved before closing.');

        rec.StateCode := rec.StateCode::Resolved;
        rec.Modify(true);
    end;
}
