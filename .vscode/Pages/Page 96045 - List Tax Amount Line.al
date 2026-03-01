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
                    ApplicationArea = All;
                }

                field("Line Amount"; Rec."Line Amount")
                {
                    ApplicationArea = All;
                }

                field("Tax Base"; Rec."Tax Base")
                {
                    ApplicationArea = All;
                }
                field("Tax %"; Rec."Tax %")
                {
                    ApplicationArea = All;
                }
                field("Tax Amount"; Rec."Tax Amount")
                {
                    ApplicationArea = All;
                }
            }
        }
    }
}
