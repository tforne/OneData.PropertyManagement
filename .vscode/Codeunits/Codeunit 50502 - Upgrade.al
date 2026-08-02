// codeunit 50502 GeneralManagementUpgrade
// {
//     Subtype = Upgrade;
//     Permissions = TableData "Lease Contract Line" = rimd;

//     trigger OnUpgradePerCompany()
//     begin
//         InitializeLeaseContractLineType();
//     end;

//     local procedure InitializeLeaseContractLineType()
//     var
//         LeaseContractLine: Record "Lease Contract Line";
//     begin
//         LeaseContractLine.SetFilter("Account No.", '<>%1', '');
//         LeaseContractLine.SetRange(Type, LeaseContractLine.Type::" ");

//         if LeaseContractLine.FindSet(true) then
//             repeat
//                 LeaseContractLine.Type := LeaseContractLine.Type::"G/L Account";
//                 LeaseContractLine.Modify();
//             until LeaseContractLine.Next() = 0;
//     end;
// }
