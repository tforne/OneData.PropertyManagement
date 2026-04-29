page 96183 "FRE Attribute Translations"
{
    Caption = 'FRE Attribute Translations';
    DataCaptionFields = "Attribute ID";
    PageType = List;
    SourceTable = "FRE Attribute Translation";

    layout
    {
        area(content)
        {
            repeater(Control1)
            {
                ShowCaption = false;
                field("Language Code"; Rec."Language Code")
                {
                    ApplicationArea = Basic, Suite;
                    LookupPageID = Languages;
                    ToolTip = 'Specifies the language that is used when translating specified text on documents to foreign business partner, such as FRE description on an order confirmation.';
                }
                field(Name; Rec.Name)
                {
                    ApplicationArea = Basic, Suite;
                    ToolTip = 'Specifies the translated name of the FRE attribute.';
                }
            }
        }
    }

    actions
    {
    }
}

