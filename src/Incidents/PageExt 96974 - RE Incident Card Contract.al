pageextension 96974 "RE Incident Card Contract" extends "RE Incident Card"
{
    layout
    {
        modify("Contract No.")
        {
            Visible = false;
        }

        addafter("Contract No.")
        {
            field(ODContractLookup; Rec."Contract No.")
            {
                ApplicationArea = All;
                Caption = 'Contrato';

                trigger OnLookup(var Text: Text): Boolean
                var
                    ContractMgt: Codeunit "RE Incident Contract Mgt.";
                begin
                    if ContractMgt.OpenContractLookup(Rec) then begin
                        Text := Rec."Contract No.";
                        CurrPage.SaveRecord();
                        CurrPage.Update(false);
                    end;

                    exit(true);
                end;

                trigger OnValidate()
                var
                    ContractMgt: Codeunit "RE Incident Contract Mgt.";
                begin
                    ContractMgt.SyncContractFields(Rec);
                end;
            }
        }
    }
}
