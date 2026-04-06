page 96045 "List Tax Amount Line"
{
    ApplicationArea = All;
    Caption = 'List Tax Amount Line';
    PageType = List;
    SourceTable = "Tax Amount Line";
    UsageCategory = Lists;
    
    layout
    {
        area(Content)
        {
            repeater(General)
            {
                field("Tax Group Code";Rec."Tax Group Code")
                {
                }

                field("Line Amount"; Rec."Line Amount")
                {
                }

                field("Tax Base"; Rec."Tax Base")
                {
                }
                field("Tax %"; Rec."Tax %")
                {
                }
                field("Tax Amount"; Rec."Tax Amount")
                {
                }
            }
        }
    }
}
