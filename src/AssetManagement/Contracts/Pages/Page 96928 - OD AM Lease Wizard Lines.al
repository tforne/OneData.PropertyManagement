page 96928 "OD AM Lease Wizard Lines"
{
    PageType = ListPart;
    SourceTable = "OD AM Lease Wizard Line";
    Caption = 'Lineas del contrato';
    ApplicationArea = All;
    AutoSplitKey = true;
    DelayedInsert = true;
    MultipleNewLines = true;

    layout
    {
        area(Content)
        {
            repeater(Group)
            {
                field(Type; Rec.Type)
                {
                }
                field("Account No."; Rec."Account No.")
                {
                }
                field(Description; Rec.Description)
                {
                }
                field("Unit of Measure Code"; Rec."Unit of Measure Code")
                {
                }
                field(Value; Rec.Value)
                {
                }
                field(Amount; Rec.Amount)
                {
                }
                field("VAT Prod. Posting Group"; Rec."VAT Prod. Posting Group")
                {
                }
                field("VAT %"; Rec."VAT %")
                {
                }
                field("VAT Base Amount"; Rec."VAT Base Amount")
                {
                    Editable = false;
                }
                field("VAT Amount"; Rec."VAT Amount")
                {
                    Editable = false;
                }
                field("Service Period"; Rec."Service Period")
                {
                }
                field("Starting Date"; Rec."Starting Date")
                {
                }
                field("Contract Expiration Date"; Rec."Contract Expiration Date")
                {
                }
                field("Credit Memo Date"; Rec."Credit Memo Date")
                {
                }
                field("Shortcut Dimension 1 Code"; Rec."Shortcut Dimension 1 Code")
                {
                }
                field("Shortcut Dimension 2 Code"; Rec."Shortcut Dimension 2 Code")
                {
                }
                field("Aplicar incrementos"; Rec."Aplicar incrementos")
                {
                }
                field("Aplicar Impuestos"; Rec."Aplicar Impuestos")
                {
                }
            }
        }
    }
}
