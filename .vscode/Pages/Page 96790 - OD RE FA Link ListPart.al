page 96790 "OD RE FA Link ListPart"
{
    PageType = ListPart;
    SourceTable = "OD RE FA Link";
    ApplicationArea = All;

    layout
    {
        area(content)
        {
            repeater(Group)
            {
                field("FA No."; Rec."FA No.") 
                { 
                    ApplicationArea = all;
                }
                field("FA Description"; Rec."FA Description") 
                { 
                    ApplicationArea = all;
                }
                field("Link Type"; Rec."Link Type") 
                { 
                    ApplicationArea = all;
                }
                field("Primary Link"; Rec."Primary Link") 
                { 
                    ApplicationArea = all;
                }
                field("Allocation %"; Rec."Allocation %") 
                { 
                    ApplicationArea = all;
                }
                field(Active; Rec.Active) 
                { 
                    ApplicationArea = all;
                }
            }
        }
    }
}