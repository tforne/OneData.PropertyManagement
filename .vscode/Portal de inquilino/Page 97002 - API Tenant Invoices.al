// page 97002 "Tenant Invoices API"
// {
//     PageType = API;
//     APIPublisher = 'onedata';
//     APIGroup = 'tenant';
//     APIVersion = 'v1.0';
//     EntityName = 'invoice';
//     EntitySetName = 'invoices';
//     SourceTable = "Lease Invoice Header";
//     ODataKeyFields = "No.";
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
//                 field(no; rec."No.") {}
//                 field(postingDate; rec."Posting Date") {}
//                 field(amount; rec."Amount Including VAT") {}
//             }
//         }
//     }

//    trigger OnOpenPage()
//     var
//         Sec: Codeunit "Tenant Security";
//         RecRef: RecordRef;
//     begin
//         RecRef.GetTable(Rec);
//         Sec.ApplyTenantFilter(RecRef);
//         RecRef.SetTable(Rec);
//     end;
// }