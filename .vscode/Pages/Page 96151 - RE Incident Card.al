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
                field("Contract No."; rec."Contract No.")
                {
                }
                field("Contact No"; rec."Contact No")
                {
                }
                field("Fixed Real Estate No."; rec."Fixed Real Estate No.")
                {
                }
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
            part(IncomingDocAttachFactBox; "Incident Attach. FactBox")
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
        }
        action(AttachFile)
        {
            ApplicationArea = Basic, Suite;
            Caption = 'Attach File';
            Promoted = true;
            Image = Attach;
            Scope = Repeater;
            ToolTip = 'Attach a file to the incoming document record.';

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
    end;

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
