page 96030 "Lease Contract List"
{
    Caption = 'Lease Contract List';
    CardPageID = "Lease Contract Card";
    Editable = false;
    PageType = List;
    SourceTable = "Lease Contract";
    ApplicationArea = All;

    layout
    {
        area(content)
        {
            repeater(Group)
            {
                field("Contract No."; rec."Contract No.")
                {
                    ApplicationArea = All;
                }
                field(Description; rec.Description)
                {
                    ApplicationArea = All;
                }
                field("Description Fixed Real Estate"; rec."Description Fixed Real Estate")
                {
                    Caption = 'Descripción activo inmobiliario';
                    ApplicationArea = All;
                }
                field("Fixed Real Estate No."; rec."Fixed Real Estate No.")
                {
                    ApplicationArea = All;
                }
                field("FRE Property No."; rec."FRE Property No.")
                {
                    ApplicationArea = All;
                }
                field(Name; rec.Name)
                {
                    ApplicationArea = All;
                }
                field(Status; rec.Status)
                {
                    ApplicationArea = All;
                }
                field("Contract Date"; rec."Contract Date")
                {
                    ApplicationArea = All;
                }
                field("Starting Date"; rec."Starting Date")
                {
                    ApplicationArea = All;
                }
                field("Expiration Date"; rec."Expiration Date")
                {
                    ApplicationArea = All;
                }
                field("Amount per Period"; rec."Amount per Period")
                {
                    ApplicationArea = All;
                }
                field("Phone No."; rec."Phone No.")
                {
                    ApplicationArea = All;
                }
                field("Fax No."; rec."Fax No.")
                {
                    ApplicationArea = All;
                }
                field("E-Mail"; rec."E-Mail")
                {
                    ApplicationArea = All;
                }
                field("Contacts Related"; rec."Contacts Related")
                {
                    ApplicationArea = All;
                }
                field("Preferred Bank Account Code"; rec."Preferred Bank Account Code")
                {
                    ApplicationArea = All;
                }
            }
        }
        area(factboxes)
        {
            systempart(Outlook; Outlook)
            {
                Visible = false;
                ApplicationArea = all;
            }
            systempart(Notes; Notes)
            {
                Visible = false;
                ApplicationArea = all;
            }
            systempart(MyNotes; MyNotes)
            {
                Visible = false;
                ApplicationArea = all;
            }
            systempart(Links; Links)
            {
                Visible = false;
                ApplicationArea = all;
            }
        }
    }

    actions
    {
        area(processing)
        {
            group("F&unctions")
            {
                Caption = 'F&unctions';
                Image = "Action";
                action(Attachments)
                {
                    ApplicationArea = All;
                    Caption = 'Attachments';
                    Image = Attach;
                    ToolTip = 'Add a file as an attachment. You can attach images as well as documents.';

                    trigger OnAction()
                    var
                        DocumentAttachmentDetails: Page "Document Attachment Details";
                        RecRef: RecordRef;
                    begin
                        RecRef.GETTABLE(Rec);
                        DocumentAttachmentDetails.OpenForRecRef(RecRef);
                        DocumentAttachmentDetails.RUNMODAL;
                    end;
                }
            }
        }
    }
}

