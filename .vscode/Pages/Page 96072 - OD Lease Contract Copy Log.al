namespace OneData.Property.Lease;

page 96072 "OD Lease Contract Copy Log"
{
    PageType = List;
    SourceTable = "OD Lease Contract Copy Log";
    Caption = 'Lease Contract Copy Log';
    ApplicationArea = All;
    UsageCategory = History;
    Editable = false;

    layout
    {
        area(content)
        {
            repeater(Control1)
            {
                field("Date Time"; Rec."Date Time")
                {
                }
                field("User ID"; Rec."User ID")
                {
                }
                field("Source Company Name"; Rec."Source Company Name")
                {
                }
                field("Source Contract No."; Rec."Source Contract No.")
                {
                }
                field("Target Company Name"; Rec."Target Company Name")
                {
                }
                field("Target Contract No."; Rec."Target Contract No.")
                {
                }
                field("Copy Header"; Rec."Copy Header")
                {
                }
                field("Copy Lines"; Rec."Copy Lines")
                {
                }
                field("Replace Lines"; Rec."Replace Lines")
                {
                }
                field("Copy Comments"; Rec."Copy Comments")
                {
                }
            }
        }
    }
}
