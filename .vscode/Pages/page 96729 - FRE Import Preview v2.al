page 96729 "FRE Import Preview v2"
{
    PageType = List;
    SourceTable = "FRE Import Preview v2";
    Caption = 'Import Preview';
    ApplicationArea = All;
    UsageCategory = Tasks;

    layout
    {
        area(content)
        {
            repeater(Group)
            {
                field("Excel Row No."; Rec."Excel Row No.") 
                {
                    trigger OnValidate()
                    begin
                        FREImportJnlLines.ValidatePreview(rec);
                    end;
                }
                field(Date; Rec.Date) 
                {
                    trigger OnValidate()
                    begin
                        FREImportJnlLines.ValidatePreview(rec);
                    end;
                }
                field("Document No."; Rec."Document No.") 
                {
                    trigger OnValidate()
                    begin
                        FREImportJnlLines.ValidatePreview(rec);
                    end;
                }
                field(Description;Rec.Description)
                {
                    trigger OnValidate()
                    begin
                        FREImportJnlLines.ValidatePreview(rec);
                    end;

                }
                field("Fixed Real Estate No."; Rec."Fixed Real Estate No.") 
                {
                    trigger OnValidate()
                    begin
                        FREImportJnlLines.ValidatePreview(rec);
                    end;
                }
                field("Fixed Real Estate Description"; Rec."Fixed Real Estate Description") 
                {
                    Editable = false;
                }
                field("Row No."; Rec."Row No.") 
                {
                    trigger OnValidate()
                    begin
                        FREImportJnlLines.ValidatePreview(rec);
                    end;
                }
                field("Description Row No. Text"; Rec."Description Row No. Text") 
                {
                    Editable = false;
                }
                field("Entry Category"; rec."Entry Category")
                {
                    ApplicationArea = All;
                }
                field(Amount; Rec.Amount) 
                {
                    trigger OnValidate()
                    begin
                        FREImportJnlLines.ValidatePreview(rec);
                    end;
                }
                field("Amount Including VAT"; Rec."Amount Including VAT") 
                {
                    Visible = false;
                }
                field(Error; Rec.Error)
                {
                    Style = Unfavorable;
                    StyleExpr = Rec.Error <> '';
                    Editable = false;
                }
                field("Suggested Fixed Real Estate No."; Rec."Suggested FRE No.") { Editable = false; }
                field("Suggested FRE Description"; Rec."Suggested FRE Desc.") { Editable = false; }                               
                field("Accept Suggestion"; Rec."Accept Suggestion") {}
            }
        }
    }    
    actions
    {
        area(Navigation)
        {
            action(Suggestions)
            {
                Caption = 'Suggestions';
                Image = Import;
                Promoted = true;
                PromotedCategory = Process;
                RunObject = page 96730;
            }
        }
    }
    var
    FREImportJnlLines : Codeunit "FRE Import Jnl. Lines";
}