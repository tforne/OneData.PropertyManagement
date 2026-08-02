page 96851 "FRE Tenant Notice FactBox"
{
    PageType = CardPart;
    SourceTable = "FRE Tenant Notice Header";
    Caption = 'Notice Statistics';
    ApplicationArea = All;

    layout
    {
        area(Content)
        {
            group(Statistics)
            {
                field("Total Recipients"; Rec."Total Recipients") { ApplicationArea = All; }
                field("Emails Sent"; Rec."Emails Sent") { ApplicationArea = All; }
                field("Portal Reads"; Rec."Portal Reads") { ApplicationArea = All; }
                field(Status; Rec.Status) { ApplicationArea = All; }
                field(Priority; Rec.Priority) { ApplicationArea = All; }
                field("Created By"; Rec."Created By") { ApplicationArea = All; }
                field("Created DateTime"; Rec."Created DateTime") { ApplicationArea = All; }
                field("Published DateTime"; Rec."Published DateTime") { ApplicationArea = All; }
                field("Sent DateTime"; Rec."Sent DateTime") { ApplicationArea = All; }
            }
        }
    }
}
