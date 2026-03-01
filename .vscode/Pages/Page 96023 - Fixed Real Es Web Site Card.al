page 96023 "Fixed Real Es. Web Site Card"
{
    PageType = Card;
    SourceTable = "Fixed Real Estate Web Site";

    layout
    {
        area(content)
        {
            group(General)
            {
                field(Code; rec.Code)
                {
                    ApplicationArea = All;
                }
                field(Description; rec.Description)
                {
                    ApplicationArea = All;
                }
                field(URL; rec.URL)
                {
                    ApplicationArea = All;
                }
                field("Real Estate Id."; rec."Real Estate Id.")
                {
                    ApplicationArea = All;
                }
            }
            part(ElementsXMLLines; 96028)
            {
                SubPageLink = "Web Site Code"=FIELD(Code);
                    UpdatePropagation = Both;
                ApplicationArea = All;
            }
            group(Publication)
            {
                Caption = 'Publicación';
                field("Preserve Non-Latin Characters"; rec."Preserve Non-Latin Characters")
                {
                    ApplicationArea = All;
                }
                field("Processing Codeunit ID"; rec."Processing Codeunit ID")
                {
                    ApplicationArea = All;
                }
                field("Processing Codeunit Name"; rec."Processing Codeunit Name")
                {
                    ApplicationArea = All;
                }
                field("Processing XMLport ID"; rec."Processing XMLport ID")
                {
                    ApplicationArea = All;
                }
                field("Processing XMLport Name"; rec."Processing XMLport Name")
                {
                    ApplicationArea = All;
                }
            }
        }
    }

    actions
    {
        area(navigation)
        {
            action("Published Assets")
            {
                Caption = 'Published Assets';
                Image = TransmitElectronicDoc;
                ApplicationArea = All;
                Promoted = true;
                PromotedCategory = Process;
                PromotedIsBig = true;
                RunObject = Page "Published Fixed Real Estate";
                RunPageLink = "Web Site Code"=FIELD(Code);
                ToolTip = 'Published Assets';
            }
        }
        area(processing)
        {
            action(Publish)
            {
                Caption = 'Published Assets';
                Image = TransmitElectronicDoc;
                ApplicationArea = All;
                Promoted = true;
                PromotedCategory = Process;
                PromotedIsBig = true;
                ToolTip = 'Published Assets';

                trigger OnAction()
                var
                    PublishWebSiteManagement: Codeunit "Publish Web Site Management";
                begin
                    PublishWebSiteManagement.RUN(Rec);
                end;
            }
        }
    }
}

