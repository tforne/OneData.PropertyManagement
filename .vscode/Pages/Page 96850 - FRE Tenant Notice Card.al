page 96850 "FRE Tenant Notice Card"
{
    PageType = Card;
    SourceTable = "FRE Tenant Notice Header";
    Caption = 'Tenant Notice';
    ApplicationArea = All;
    UsageCategory = None;
    
    layout
    {
        area(Content)
        {
            group(General)
            {
                field("No."; Rec."No.") { ApplicationArea = All; }
                field(Title; Rec.Title) { ApplicationArea = All; }
                field("Notice Type"; Rec."Notice Type") { ApplicationArea = All; }
                field(Priority; Rec.Priority) { ApplicationArea = All; }
                field(Status; Rec.Status) { ApplicationArea = All; Editable = false; }
                field(Description; Rec.Description) { ApplicationArea = All; MultiLine = true; }
            }

            group(Publication)
            {
                field("Show In Portal"; Rec."Show In Portal") { ApplicationArea = All; }
                field("Send Email"; Rec."Send Email") { ApplicationArea = All; }
                field("Publish From"; Rec."Publish From") { ApplicationArea = All; }
                field("Publish Until"; Rec."Publish Until") { ApplicationArea = All; }
                field("Requires Read Confirmation"; Rec."Requires Read Confirmation") { ApplicationArea = All; }
            }

            group(Relation)
            {
                field("Company Name"; Rec."Company Name") { ApplicationArea = All; }
                field("Asset No."; Rec."Asset No.") { ApplicationArea = All; }
                field("Contract No."; Rec."Contract No.") { ApplicationArea = All; }
                field("Incident Id."; Rec."Incident Id.") { ApplicationArea = All; }
            }

            part(Recipients; "FRE Tenant Notice Recipients")
            {
                ApplicationArea = All;
                SubPageLink = "Notice Id." = field("Notice Id.");
            }
        }

        area(FactBoxes)
        {
            part(NoticeStats; "FRE Tenant Notice FactBox")
            {
                ApplicationArea = All;
                SubPageLink = "Notice Id." = field("Notice Id.");
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

            action(CloseNotice)
            {
                Caption = 'Close';
                Image = Close;
                ApplicationArea = All;

                trigger OnAction()
                var
                    TenantNoticeMgt: Codeunit "FRE Tenant Notice Mgt.";
                begin
                    TenantNoticeMgt.CloseNotice(Rec);
                end;
            }

            action(CancelNotice)
            {
                Caption = 'Cancel';
                Image = Cancel;
                ApplicationArea = All;

                trigger OnAction()
                var
                    TenantNoticeMgt: Codeunit "FRE Tenant Notice Mgt.";
                begin
                    TenantNoticeMgt.CancelNotice(Rec);
                end;
            }
            action(AddRecipientsFromContracts)
            {
                Caption = 'Añadir destinatarios desde contratos';
                ApplicationArea = All;
                Image = AddContacts;
                Promoted = true;
                PromotedCategory = Process;

                trigger OnAction()
                var
                    TenantNoticeSourceMgt: Codeunit "FRE Tenant Notice Source Mgt.";
                begin
                    CurrPage.SetSelectionFilter(Rec);
                    TenantNoticeSourceMgt.AddRecipientsFromNoticeFilters(Rec);
                    CurrPage.Update(false);
                end;
            }

            action(AddIncidentComment)
            {
                Caption = 'Añadir comentario a incidencia';
                ApplicationArea = All;
                Image = Comment;
                Promoted = true;
                PromotedCategory = Process;

                trigger OnAction()
                var
                    TenantNoticeSourceMgt: Codeunit "FRE Tenant Notice Source Mgt.";
                begin
                    TenantNoticeSourceMgt.AddIncidentSystemComment(Rec, '');
                end;
            }
        }

    }
}
