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
                field("REF Description";Rec."REF Description")
                {                    
                }
                field("Contract No."; rec."Contract No.")
                {
                }
                field("Contact No"; rec."Contact No")
                {
                }
                field("Contact Name";rec."Contract - Contact Name")
                {
                    Caption = 'Contract - Contact Name';
                    Editable = false;

                }
                field("Contact Phone No."; rec."Contact Phone No.")
                {
                    Caption = 'Contact Phone No.';
                    ExtendedDatatype = PhoneNo;
                    Editable = false;
                }
                field("Contact E-Mail"; rec."Contact E-Mail")
                {
                    Caption = 'Contact E-Mail';
                    ExtendedDatatype = EMail;
                    Editable = false;
                }
                field("Contract Phone No."; rec."Contract - Phone No.")
                {
                    Caption = 'Contract - Phone No.';
                    ExtendedDatatype = PhoneNo;
                }
                field("Contract E-Mail";rec."Contract - EMail")
                {
                    Caption = 'Contract Email';
                    ExtendedDatatype = EMail;
                }
            }
            part(CommentLines; 96058)
            {
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

            group(Insurance)
            {
                Caption = 'Insurance';

                field("Insurance Policy No."; Rec."Insurance Policy No.")
                {
                }
                field("Insurance Policy Description"; Rec."Insurance Policy Description")
                {
                }
                field("Notify Insurance"; Rec."Notify Insurance")
                {
                }
                field("Insurance Notified"; Rec."Insurance Notified")
                {
                }
                field("Insurance Notification Date"; Rec."Insurance Notification Date")
                {
                }
                field("Insurance Claim No."; Rec."Insurance Claim No.")
                {
                }
                field("Insurance Status"; Rec."Insurance Status")
                {
                }
                field("Insurance Claim E-Mail"; Rec."Insurance Claim E-Mail")
                {
                }
                field("Insurance Claim Phone No."; Rec."Insurance Claim Phone No.")
                {
                }
                field("Insurance Notes"; Rec."Insurance Notes")
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
            Caption = 'Process';
            action(StartProgress)
            {
                Caption = 'Start Progress';
                Image = Start;

                trigger OnAction()
                begin
                    SetStatusInProgress();
                end;
            }
            action(SendCustomOpenIncident)
            {
                Caption = 'Send Open Incident';
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
            action(NotifyInsurance)
            {
                Caption = 'Notify Insurance';
                Image = SendToMultiple;

                trigger OnAction()
                var
                    REInsuranceNotifyMgt: Codeunit "RE Insurance Notify Mgt";
                begin
                    REInsuranceNotifyMgt.NotifyInsurance(Rec);
                    CurrPage.Update(false);
                end;
            }
            action(SendCustomStatusIncident)
            {
                Caption = 'Send Status Incident';
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
                    CustomerRENotifybyEmail."NotificarPorCorreoSituaciónIncidencia"(Rec);
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

        }
        action(AttachFile)
        {
            ApplicationArea = Basic, Suite;
            Caption = 'Attach File';
            Promoted = true;
            PromotedCategory = Process;
            PromotedIsBig = true;
            Image = Attach;
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

        ShowInsuranceReminder();
    end;

    var
        Contract : record "Lease Contract";
        Contact : Record "Contact";
        Customer : Record Customer;
        LastInsuranceReminderIncidentId: Guid;
        InsuranceReminderTxt: Label 'Esta incidencia requiere notificación al proveedor del seguro. Revise la póliza y utilice la acción Notify Insurance.';
        InsurancePolicySelectionReminderTxt: Label 'Esta incidencia requiere notificación al proveedor del seguro. Antes de notificar, seleccione la póliza aplicable.';

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
    var
        CustomerRENotifyByEmail : Codeunit "Customer RE-Notify by Email";
    begin
        if rec.StateCode <> rec.StateCode::Resolved then
            Error('The incident must be resolved before closing.');

        if Rec."Notify Insurance" and (not Rec."Insurance Notified") then
            Error('Before closing the incident, you must notify the insurance provider or clear the Notify Insurance option.');

        rec.StateCode := rec.StateCode::Closed;
        rec.Modify(true);
        
        CustomerRENotifyByEmail.NotificarPorCorreoCierreIncidencia(Rec);
    end;

    local procedure ShowInsuranceReminder()
    var
        Notification: Notification;
    begin
        if IsNullGuid(Rec."Incident Id.") then
            exit;

        if LastInsuranceReminderIncidentId = Rec."Incident Id." then
            exit;

        if not Rec."Notify Insurance" then
            exit;

        if Rec."Insurance Notified" then
            exit;

        Notification.Id := CreateGuid();
        if Rec."Insurance Policy No." = '' then
            Notification.Message := InsurancePolicySelectionReminderTxt
        else
            Notification.Message := InsuranceReminderTxt;
        Notification.Scope := NotificationScope::LocalScope;
        Notification.Send();

        LastInsuranceReminderIncidentId := Rec."Incident Id.";
    end;
}
