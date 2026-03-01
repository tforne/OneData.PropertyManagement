// page 97001 "Tenant Incidents API"
// {
//     PageType = API;
//     APIPublisher = 'onedata';
//     APIGroup = 'tenant';
//     APIVersion = 'v1.0';
//     EntityName = 'incident';
//     EntitySetName = 'incidents';
//     SourceTable = "Incident Assets Real Estate";
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
//                 field("IncidentId"; rec."Incident Id.") {}
//                 field(date; rec."Incident Date") {}
//                 field(description; rec.Description) {}
//                 field(status; rec.StatusCode) {}
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

//     trigger OnInsertRecord(BelowxRec: Boolean): Boolean
//     var
//         Sec: Codeunit "Tenant Security";
//         RecRef: RecordRef;
//     begin
//         RecRef.GetTable(Rec);
//         Sec.SetTenantDefaults(RecRef);
//         RecRef.SetTable(Rec);
//         exit(true);
//     end;
// }