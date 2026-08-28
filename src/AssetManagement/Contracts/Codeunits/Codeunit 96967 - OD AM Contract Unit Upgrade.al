codeunit 96967 "OD AM Contract Unit Upgrade"
{
    procedure EnsurePrincipalUnitsForAllContracts(): Integer
    var
        LeaseContract: Record "Lease Contract";
        ContractAssetMgt: Codeunit "OD AM Contract Asset Mgt.";
        CreatedCount: Integer;
    begin
        if LeaseContract.FindSet() then
            repeat
                if ContractAssetMgt.EnsurePrincipalUnitForContract(LeaseContract) then
                    CreatedCount += 1;
            until LeaseContract.Next() = 0;

        exit(CreatedCount);
    end;

    procedure EnsurePrincipalUnitForContract(var LeaseContract: Record "Lease Contract"): Boolean
    var
        ContractAssetMgt: Codeunit "OD AM Contract Asset Mgt.";
    begin
        exit(ContractAssetMgt.EnsurePrincipalUnitForContract(LeaseContract));
    end;
}
