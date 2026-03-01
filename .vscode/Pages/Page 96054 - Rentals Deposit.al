page 96054 "Rentals Deposit"
{
    ApplicationArea = All;
    Caption = 'Rentals Deposit';
    PageType = List;
    SourceTable = "Rental Deposit";
    UsageCategory = Lists;
    AutoSplitKey = true;
    
    layout
    {
        area(Content)
        {
            repeater(General)
            {
                field(Description; Rec.Description)
                {
                    ToolTip = 'Specifies the value of the Description field.', Comment = '%';
                }
                field(Amount; Rec.Amount)
                {
                    ToolTip = 'Specifies the value of the Line Amount field.', Comment = '%';
                }
            }
        }
    }
}
