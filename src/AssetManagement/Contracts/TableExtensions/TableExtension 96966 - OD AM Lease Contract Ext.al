tableextension 96966 "OD AM Lease Contract Ext" extends "Lease Contract"
{
    fields
    {
        modify("Fixed Real Estate No.")
        {
            trigger OnAfterValidate()
            var
                ContractAssetMgt: Codeunit "OD AM Contract Asset Mgt.";
            begin
                if Rec."Contract No." <> '' then begin
                    ContractAssetMgt.SyncPrincipalAsset(Rec);
                    ContractAssetMgt.SyncLeaseContractLinesFixedRealEstate(Rec."Contract No.", Rec."Fixed Real Estate No.", xRec."Fixed Real Estate No.");
                end;
            end;
        }

        modify("Starting Date")
        {
            trigger OnAfterValidate()
            var
                ContractAssetMgt: Codeunit "OD AM Contract Asset Mgt.";
            begin
                if (Rec."Contract No." <> '') and (Rec."Fixed Real Estate No." <> '') then
                    ContractAssetMgt.SyncPrincipalAsset(Rec);
            end;
        }

        modify("Expiration Date")
        {
            trigger OnAfterValidate()
            var
                ContractAssetMgt: Codeunit "OD AM Contract Asset Mgt.";
            begin
                if (Rec."Contract No." <> '') and (Rec."Fixed Real Estate No." <> '') then
                    ContractAssetMgt.SyncPrincipalAsset(Rec);
            end;
        }
    }

    trigger OnInsert()
    var
        ContractAssetMgt: Codeunit "OD AM Contract Asset Mgt.";
    begin
        if (Rec."Contract No." <> '') and (Rec."Fixed Real Estate No." <> '') then begin
            ContractAssetMgt.SyncPrincipalAsset(Rec);
            ContractAssetMgt.SyncLeaseContractLinesFixedRealEstate(Rec."Contract No.", Rec."Fixed Real Estate No.", '');
        end;
    end;

    trigger OnModify()
    var
        ContractAssetMgt: Codeunit "OD AM Contract Asset Mgt.";
    begin
        if Rec."Contract No." = '' then
            exit;

        if (Rec."Fixed Real Estate No." <> xRec."Fixed Real Estate No.") or
           (Rec."Starting Date" <> xRec."Starting Date") or
           (Rec."Expiration Date" <> xRec."Expiration Date")
        then begin
            ContractAssetMgt.SyncPrincipalAsset(Rec);
            if Rec."Fixed Real Estate No." <> xRec."Fixed Real Estate No." then
                ContractAssetMgt.SyncLeaseContractLinesFixedRealEstate(Rec."Contract No.", Rec."Fixed Real Estate No.", xRec."Fixed Real Estate No.");
        end;
    end;

    trigger OnDelete()
    var
        ContractAssetMgt: Codeunit "OD AM Contract Asset Mgt.";
    begin
        if Rec."Contract No." <> '' then
            ContractAssetMgt.DeleteAllUnitsForContract(Rec."Contract No.");
    end;
}
