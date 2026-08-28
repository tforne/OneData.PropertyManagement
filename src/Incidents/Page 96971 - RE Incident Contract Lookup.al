page 96971 "RE Incident Contract Lookup"
{
    Caption = 'Contratos vigentes del activo';
    PageType = List;
    SourceTable = "RE Incident Contract Lookup";
    SourceTableTemporary = true;
    Editable = false;
    ApplicationArea = All;
    UsageCategory = None;

    layout
    {
        area(content)
        {
            repeater(Contracts)
            {
                field("Company Name"; Rec."Company Name")
                {
                    ApplicationArea = All;
                }
                field("Contract No."; Rec."Contract No.")
                {
                    ApplicationArea = All;
                }
                field("Customer No."; Rec."Customer No.")
                {
                    ApplicationArea = All;
                }
                field("Contact No."; Rec."Contact No.")
                {
                    ApplicationArea = All;
                }
                field("Contract Contact Name"; Rec."Contract Contact Name")
                {
                    Caption = 'Contrato - Nombre contacto';
                    ApplicationArea = All;
                }
                field("Contact Phone No."; Rec."Contact Phone No.")
                {
                    Caption = 'Contacto no. telf.';
                    ApplicationArea = All;
                }
                field("Contact E-Mail"; Rec."Contact E-Mail")
                {
                    Caption = 'Contacto E-Mail';
                    ApplicationArea = All;
                }
                field("Starting Date"; Rec."Starting Date")
                {
                    ApplicationArea = All;
                }
                field("Expiration Date"; Rec."Expiration Date")
                {
                    ApplicationArea = All;
                }
            }
        }
    }

    procedure SetTempSource(var TempContractLookup: Record "RE Incident Contract Lookup" temporary)
    begin
        Rec.Reset();
        Rec.DeleteAll();
        Rec.Copy(TempContractLookup, true);
    end;

    procedure GetSelectedRecord(var TempContractLookup: Record "RE Incident Contract Lookup" temporary)
    begin
        TempContractLookup := Rec;
    end;
}
