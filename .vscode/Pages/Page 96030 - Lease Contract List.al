page 96030 "Lease Contract List"
{
    Caption = 'Lease Contract List';
    CardPageID = "Lease Contract Card";
    Editable = false;
    PageType = List;
    SourceTable = "Lease Contract";
    ApplicationArea = All;
    UsageCategory = Lists;

    layout
    {
        area(content)
        {
            repeater(Group)
            {
                field("Contract No."; rec."Contract No.")
                {
                }
                field(Description; rec.Description)
                {
                }
                field("Description Fixed Real Estate"; rec."Description Fixed Real Estate")
                {
                    Caption = 'Descripción activo inmobiliario';
                }
                field("Fixed Real Estate No."; rec."Fixed Real Estate No.")
                {
                }
                field("FRE Property No."; rec."FRE Property No.")
                {
                }
                field(Name; rec.Name)
                {
                }
                field(Status; rec.Status)
                {
                }
                field("Contract Date"; rec."Contract Date")
                {
                }
                field("Starting Date"; rec."Starting Date")
                {
                }
                field("Expiration Date"; rec."Expiration Date")
                {
                }
                field("Amount per Period"; rec."Amount per Period")
                {
                }
                field("Phone No."; rec."Phone No.")
                {
                }
                field("Fax No."; rec."Fax No.")
                {
                }
                field("E-Mail"; rec."E-Mail")
                {
                }
                field("Contacts Related"; rec."Contacts Related")
                {
                }
                field("Preferred Bank Account Code"; rec."Preferred Bank Account Code")
                {
                }
            }
        }
        area(factboxes)
        {
            systempart(Outlook; Outlook)
            {
                Visible = false;
            }
            systempart(Notes; Notes)
            {
                Visible = false;
            }
            systempart(MyNotes; MyNotes)
            {
                Visible = false;
            }
            systempart(Links; Links)
            {
                Visible = false;
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

