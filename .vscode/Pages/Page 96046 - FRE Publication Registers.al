namespace OneData.Property.Publication;

page 96046 "FRE Publication Registers"
{
    ApplicationArea = All;
    Caption = 'FRE Publication Registers';
    Editable = false;
    PageType = List;
    SourceTable = "FRE Publicacions Register";
    UsageCategory = Lists;

    layout
    {
        area(Content)
        {
            repeater(Registers)
            {
                field("No."; Rec."No.")
                {
                }
                field(Identifier; Rec.Identifier)
                {
                }
                field("Created Date-Time"; Rec."Created Date-Time")
                {
                }
                field("Created by User"; Rec."Created by User")
                {
                }
                field(Status; Rec.Status)
                {
                }
                field("No. of Transfers"; Rec."No. of Transfers")
                {
                }
            }
        }
    }
}
