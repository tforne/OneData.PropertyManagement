page 96040 "Fixed Real Estate Avatar"
{
    Caption = 'Fixed Asset Picture';
    DeleteAllowed = false;
    InsertAllowed = false;
    LinksAllowed = false;
    PageType = Card;
    SourceTable = "Fixed Real Estate";

    layout
    {
        area(content)
        {
            field("Avatar Picture"; rec."Avatar Picture")
            {
                ApplicationArea = All;
                ShowCaption = false;
                ToolTip = 'Specifies the picture that has been inserted for the fixed asset.';
            }
        }
    }

    actions
    {
    }

    var
        OverrideImageQst: Label 'The existing picture will be replaced. Do you want to continue?';
        DeleteImageQst: Label 'Are you sure you want to delete the picture?';
        SelectPictureTxt: Label 'Select a picture to upload';
}

