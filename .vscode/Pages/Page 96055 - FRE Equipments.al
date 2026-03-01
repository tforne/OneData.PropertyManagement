page 96055 "FRE Equipments"
{
    ApplicationArea = All;
    Caption = 'FRE Equipments';
    PageType = List;
    SourceTable = "FRE Equipment";
    UsageCategory = Lists;
    
    layout
    {
        area(Content)
        {
            repeater(General)
            {
                field(Quantity;Rec.Quantity)
                {
                    ToolTip = 'Specifies the value of the Quantity field.', Comment = '%';
                }
                field(Description; Rec.Description)
                {
                    ToolTip = 'Specifies the value of the Description field.', Comment = '%';
                }
                field("Acquisition Date"; Rec."Acquisition Date")
                {
                    ToolTip = 'Specifies the value of the Acquisition Date field.', Comment = '%';
                }
                field("Equipment Warranty Period"; Rec."Equipment Warranty Period")
                {
                    ToolTip = 'Specifies the value of the Equipment Warranty Period field.', Comment = '%';
                }
                field("Model No."; Rec."Model No.")
                {
                    ToolTip = 'Specifies the value of the Model No. field.', Comment = '%';
                }
                field("Serial No."; Rec."Serial No.")
                {
                    ToolTip = 'Specifies the value of the Serial No. field.', Comment = '%';
                }
                field("Acquisition Cost"; Rec."Acquisition Cost")
                {
                    ToolTip = 'Specifies the value of the Acquisition Cost field.', Comment = '%';
                }
            }
        }
    }
}
