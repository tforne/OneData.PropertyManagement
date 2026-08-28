codeunit 96985 "OD Import Lease Contracts"
{
    trigger OnRun()
    var
        LeaseContract: Record "Lease Contract";
        CopyMgt: Codeunit "OD Copy Lease Contract Mgt.";
    begin
        LeaseContract.Init();
        LeaseContract.Insert(true);
        CopyMgt.RunCopyContract(LeaseContract);
        Page.Run(Page::"Lease Contract Card", LeaseContract);
    end;
}
