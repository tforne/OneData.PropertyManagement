// page 97000 "Tenant Contracts API"
// {
//     PageType = API;
//     APIPublisher = 'onedata';
//     APIGroup = 'tenant';
//     APIVersion = 'v1.0';
//     EntityName = 'contract';
//     EntitySetName = 'contracts';
//     SourceTable = "Lease Contract";
//     // ODataKeyFields = "Contract No.";
//     Editable = false;
//     InsertAllowed = false;
//     ModifyAllowed = false;
//     DeleteAllowed = false;
    
//     layout
//     {
//         area(content)
//         {
//             repeater(Group)
//             {
//                 field(ContractNo; rec."Contract No.") {}
//                 // field(Description; rec.Description) {}
//                 // field(StartDate; rec."Contract Date") {}
//             }
//         }
//     }

//     trigger OnOpenPage()
//     var
//         Sec: Codeunit "Tenant Security";
//         RecRef: RecordRef;
//     begin
//         RecRef.GetTable(Rec);
//         Sec.ApplyTenantFilter(RecRef);
//         RecRef.SetTable(Rec);
//     end;
// }
