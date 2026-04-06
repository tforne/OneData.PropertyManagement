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
                }
                field("Fecha Registro"; rec."Posting Date")
                {
                }
                field("Tipo Línea"; rec."Line Type")
                {
                }
                field("Fixed Real Estate No."; rec."Fixed Real Estate No.")
                {
                }
                field("Descripción"; rec.Description)
                {
                }
                field("Document Type";Rec."Document Type")
                {
                }
                field("Document No.";Rec."Document No.")
                {
                }
                field("Source Type";Rec."Source Type")
                {
                }
                field("Source No.";Rec."Source No.")
                {
                }
                field("Source Name";Rec."Source Name")
                {
                }
                field("Row No.";Rec."Row No.")
                {
                }
                field("Description Row No.";Rec."Description Row No.")
                {
                }
                field("Entry Category";Rec."Entry Category")
                {
                }
                field(Amount;Rec.Amount)
                {
                }
                field("Amount Including VAT";Rec."Amount Including VAT")
                {
                }
                field("Company Name";Rec."Company Name")
                {
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

