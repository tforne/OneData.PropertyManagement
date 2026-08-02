page 96852 "FRE Tenant Notice List"
{
    PageType = List;
    SourceTable = "FRE Tenant Notice Header";
    Caption = 'Tenant Notices';
    ApplicationArea = All;
    UsageCategory = Lists;
    CardPageId = "FRE Tenant Notice Card";

    layout
    {
        area(Content)
        {
            repeater(General)
            {
                field("No."; Rec."No.") { ApplicationArea = All; }
                field(Title; Rec.Title) { ApplicationArea = All; }
                field("Notice Type"; Rec."Notice Type") { ApplicationArea = All; }
                field(Priority; Rec.Priority) { ApplicationArea = All; }
                field(Status; Rec.Status) { ApplicationArea = All; }
                field("Show In Portal"; Rec."Show In Portal") { ApplicationArea = All; }
                field("Send Email"; Rec."Send Email") { ApplicationArea = All; }
                field("Publish From"; Rec."Publish From") { ApplicationArea = All; }
                field("Publish Until"; Rec."Publish Until") { ApplicationArea = All; }
                field("Total Recipients"; Rec."Total Recipients") { ApplicationArea = All; }
                field("Emails Sent"; Rec."Emails Sent") { ApplicationArea = All; }
                field("Portal Reads"; Rec."Portal Reads") { ApplicationArea = All; }
            }
        }
    }

    actions
    {
        area(Processing)
        {
            action(Publish)
            {
                Caption = 'Publish';
                Image = ReleaseDoc;
                ApplicationArea = All;
                Promoted = true;
                PromotedCategory = Process;

                trigger OnAction()
                var
                    TenantNoticeMgt: Codeunit "FRE Tenant Notice Mgt.";
                begin
                    TenantNoticeMgt.PublishNotice(Rec);
                end;
            }

            action(SimulateSendEmail)
            {
                Caption = 'Simulate Send Email';
                Image = Email;
                ApplicationArea = All;
                Promoted = true;
                PromotedCategory = Process;

                trigger OnAction()
                var
                    TenantNoticeMgt: Codeunit "FRE Tenant Notice Mgt.";
                begin
                    TenantNoticeMgt.SimulateSendEmail(Rec);
                end;
            }
        }
    }
}
