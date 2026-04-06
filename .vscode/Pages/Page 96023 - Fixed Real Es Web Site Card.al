page 96023 "Fixed Real Es. Web Site Card"
{
    PageType = Card;
    SourceTable = "Fixed Real Estate Web Site";
    ApplicationArea = All;

    layout
    {
        area(content)
        {
            group(General)
            {
                field(Code; rec.Code)
                {
                }
                field(Description; rec.Description)
                {
                }
                field(URL; rec.URL)
                {
                }
                field("Real Estate Id."; rec."Real Estate Id.")
                {
                }
            }
            part(ElementsXMLLines; 96028)
            {
                SubPageLink = "Web Site Code"=FIELD(Code);
                    UpdatePropagation = Both;
            }
            group(Publication)
            {
                Caption = 'Publicación';
                field("Preserve Non-Latin Characters"; rec."Preserve Non-Latin Characters")
                {
                }
                field("Processing Codeunit ID"; rec."Processing Codeunit ID")
                {
                }
                field("Processing Codeunit Name"; rec."Processing Codeunit Name")
                {
                }
                field("Processing XMLport ID"; rec."Processing XMLport ID")
                {
                }
                field("Processing XMLport Name"; rec."Processing XMLport Name")
                {
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

