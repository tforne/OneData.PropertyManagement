tableextension 96973 "Incident Assets RE Contract" extends "Incident Assets Real Estate"
{
    fields
    {
        modify("Fixed Real Estate No.")
        {
            trigger OnAfterValidate()
            var
                ContractMgt: Codeunit "RE Incident Contract Mgt.";
            begin
                ContractMgt.HandleFixedRealEstateChange(Rec, xRec);
            end;
        }
        modify("Contract No.")
        {
            trigger OnAfterValidate()
            var
                ContractMgt: Codeunit "RE Incident Contract Mgt.";
            begin
                ContractMgt.SyncContractFields(Rec);
            end;
        }
    }
}
