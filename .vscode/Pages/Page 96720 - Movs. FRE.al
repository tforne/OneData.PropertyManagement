page 96720 "Movs. FRE"
{
    PageType = List;
    SourceTable = "FRE Ledger Entry";
    Caption = 'Movs. FRE';
    ApplicationArea = Basic, Suite;
    UsageCategory = Lists;

    layout
    {
        area(content)
        {
            repeater(Group)
            {
                field("Nº Mov."; Rec."Entry No.")
                {
                    ApplicationArea = All;
                }
                field("Fecha Registro"; rec."Posting Date")
                {
                    ApplicationArea = All;
                }
                field("Tipo Línea"; rec."Line Type")
                {
                    ApplicationArea = All;
                }
                field("Fixed Real Estate No."; rec."Fixed Real Estate No.")
                {
                    ApplicationArea = All;
                }
                field("Descripción"; rec.Description)
                {
                    ApplicationArea = All;
                }
                field("Document Type";Rec."Document Type")
                {
                    ApplicationArea = All;
                }
                field("Document No.";Rec."Document No.")
                {
                    ApplicationArea = All;
                }
                field("Source Type";Rec."Source Type")
                {
                    ApplicationArea = All;
                }
                field("Source No.";Rec."Source No.")
                {
                    ApplicationArea = All;
                }
                field("Source Name";Rec."Source Name")
                {
                    ApplicationArea = All;
                }
                field("Row No.";Rec."Row No.")
                {
                    ApplicationArea = All;
                }
                field("Description Row No.";Rec."Description Row No.")
                {
                    ApplicationArea = All;
                }
                field(Amount;Rec.Amount)
                {
                    ApplicationArea = All;
                }
                field("Amount Including VAT";Rec."Amount Including VAT")
                {
                    ApplicationArea = All;
                }
            }
        }
    }
    actions
    {
        area(processing)
        {
            action("&Navigate")
            {
                ApplicationArea = Basic, Suite;
                Caption = 'Find entries...';
                Image = Navigate;
                Scope = Repeater;
                ShortCutKey = 'Ctrl+Alt+Q';
                ToolTip = 'Find entries and documents that exist for the document number and posting date on the selected document. (Formerly this action was named Navigate.)';

                trigger OnAction()
                var
                    Navigate: Page Navigate;
                begin
                    Navigate.SetDoc(Rec."Posting Date", Rec."Document No.");
                    Navigate.Run();
                end;
            }
        }
    }
}

