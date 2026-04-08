page 96810 "Gen Journal Import Preview"
{
    PageType = List;
    SourceTable = "Gen Journal Import Buffer";
    ApplicationArea = All;
    Caption = 'Preview importación diario';

    layout
    {
        area(content)
        {
            repeater(Lines)
            {
                field("Posting Date"; Rec."Posting Date") { }
                field("Document No."; Rec."Document No.") { }
                field("Account No."; Rec."Account No.") { }
                field(Description; Rec.Description) { }
                field(Amount; Rec.Amount) { }

                field("FRE Real Estate No."; Rec."FRE Fixed Real Estate No.") { }

                field(Status; Rec.Status) { }
                field(Message; Rec.Message) { }
            }
        }
    }

    actions
    {
        area(processing)
        {
            action(Import)
            {
                Caption = 'Importar';
                Image = Approve;

                trigger OnAction()
                var
                    ImportMgt: Codeunit "Gen Journal Import Mgt.";
                begin
                    ImportMgt.CommitImport(Rec);
                    Message('Importación completada');
                end;
            }
        }
    }
}