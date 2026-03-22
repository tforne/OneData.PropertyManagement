page 96730 "FRE Asset Suggestion Rule"
{
    ApplicationArea = All;
    Caption = 'FRE Asset Suggestion Rule';
    PageType = List;
    SourceTable = "FRE Asset Suggestion Rule";
    UsageCategory = Lists;
    
    layout
    {
        area(Content)
        {
            repeater(General)
            {
                field("Entry No."; Rec."Entry No.")
                {
                    ToolTip = 'Specifies the value of the Entry No. field.', Comment = '%';
                }
                field("Fixed Real Estate No."; Rec."Fixed Real Estate No.")
                {
                    ToolTip = 'Specifies the value of the Fixed Real Estate No. field.', Comment = '%';
                }
                field("Hit Count"; Rec."Hit Count")
                {
                    ToolTip = 'Specifies the value of the Hit Count field.', Comment = '%';
                }
                field("Last Used Date"; Rec."Last Used Date")
                {
                    ToolTip = 'Specifies the value of the Last Used Date field.', Comment = '%';
                }
                field(Pattern; Rec.Pattern)
                {
                    ToolTip = 'Specifies the value of the Pattern field.', Comment = '%';
                }
                field(SystemCreatedAt; Rec.SystemCreatedAt)
                {
                    ToolTip = 'Specifies the value of the SystemCreatedAt field.', Comment = '%';
                }
                field(SystemCreatedBy; Rec.SystemCreatedBy)
                {
                    ToolTip = 'Specifies the value of the SystemCreatedBy field.', Comment = '%';
                }
                field(SystemId; Rec.SystemId)
                {
                    ToolTip = 'Specifies the value of the SystemId field.', Comment = '%';
                }
                field(SystemModifiedAt; Rec.SystemModifiedAt)
                {
                    ToolTip = 'Specifies the value of the SystemModifiedAt field.', Comment = '%';
                }
                field(SystemModifiedBy; Rec.SystemModifiedBy)
                {
                    ToolTip = 'Specifies the value of the SystemModifiedBy field.', Comment = '%';
                }
            }
        }
    }
}
