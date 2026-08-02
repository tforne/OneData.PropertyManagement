page 96853 "FRE Tenant Notice Recipients"
{
    PageType = ListPart;
    SourceTable = "FRE Tenant Notice Recipient";
    Caption = 'Recipients';
    ApplicationArea = All;
    AutoSplitKey = true;

    layout
    {
        area(Content)
        {
            repeater(General)
            {
                field("Customer No."; Rec."Customer No.") { ApplicationArea = All; }
                field("Contact No."; Rec."Contact No.") { ApplicationArea = All; }
                field(Name; Rec.Name) { ApplicationArea = All; }
                field(Email; Rec.Email) { ApplicationArea = All; }
                field("Contract No."; Rec."Contract No.") { ApplicationArea = All; }
                field("Asset No."; Rec."Asset No.") { ApplicationArea = All; }
                field("Portal Visible"; Rec."Portal Visible") { ApplicationArea = All; }
                field("Email Sent"; Rec."Email Sent") { ApplicationArea = All; }
                field("Read In Portal"; Rec."Read In Portal") { ApplicationArea = All; }
                field("Read DateTime"; Rec."Read DateTime") { ApplicationArea = All; }
            }
        }
    }

    actions
    {
        area(Processing)
        {
            action(MarkAsRead)
            {
                Caption = 'Mark as Read';
                Image = Approve;
                ApplicationArea = All;

                trigger OnAction()
                var
                    TenantNoticeMgt: Codeunit "FRE Tenant Notice Mgt.";
                begin
                    TenantNoticeMgt.MarkRecipientAsRead(Rec);
                end;
            }
        }
    }
}
