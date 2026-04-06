page 96016 "RE Maintenance Registration"
{
    AutoSplitKey = true;
    Caption = 'Maintenance Registration';
    DataCaptionFields = "FRE No.";
    PageType = List;
    SourceTable = "RE Maintenance Registration";
    ApplicationArea = All;

    layout
    {
        area(content)
        {
            repeater(Group)
            {
                field("FRE No."; rec."FRE No.")
                {
                    ToolTip = 'Specifies the number of the related real estate asset. ';
                    Visible = false;
                }
                field("Service Date"; rec."Service Date")
                {
                    ToolTip = 'Specifies the date when the real estate asset is being serviced.';
                }
                field("Maintenance Vendor No."; rec."Maintenance Vendor No.")
                {
                    ToolTip = 'Specifies the number of the vendor who services the real estate asset for this entry.';
                }
                field(Comment; rec.Comment)
                {
                    ToolTip = 'Specifies a comment for the service, repairs or maintenance to be performed on the real estate asset.';
                }
                field("Service Agent Name"; rec."Service Agent Name")
                {
                    ToolTip = 'Specifies the name of the service agent who is servicing the real estate asset.';
                }
                field("Service Agent Phone No."; rec."Service Agent Phone No.")
                {
                    ToolTip = 'Specifies the phone number of the service agent who is servicing the real estate asset.';
                }
                field("Service Agent Mobile Phone"; rec."Service Agent Mobile Phone")
                {
                    ToolTip = 'Specifies the mobile phone number of the service agent who is servicing the real estate asset.';
                    Visible = false;
                }
            }
        }
        area(factboxes)
        {
            systempart(Links; Links)
            {
                Visible = false;
            }
            systempart(Notes; Notes)
            {
                Visible = true;
            }
        }
    }

    actions
    {
    }

    trigger OnInsertRecord(BelowxRec: Boolean): Boolean
    var
    begin
    end;
}

