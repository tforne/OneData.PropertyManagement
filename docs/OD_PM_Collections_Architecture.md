# OD PM Collections Architecture

## Analysis of installed symbols

The active OneData Property Management profile is `OneData Property Management`. It uses page 96015 `Real Estate Role Center`; the current activity parts are `FRE RC Activities`, `Small Real Estate Act.`, `Incidents Real Estate Act.` and `RE Insurance Activities`.

The current Base Application symbols are version 28.4.53241.53939. Cartera is included in the installed Spanish localization and uses the namespace `Microsoft.Finance.ReceivablesPayables`.

| Functionality | Standard object found | ID | Reuse / develop |
| --- | --- | ---: | --- |
| Customer receivables | `Cust. Ledger Entry` | 21 | Reuse |
| Customer ledger entries | `Customer Ledger Entries` | 25 | Reuse |
| Cash receipt journal | `Cash Receipt Journal` | 255 | Reuse |
| Receivable Cartera documents | `Receivables Cartera Docs` | 7000001 | Reuse |
| All Cartera documents | `Cartera Documents` | 7000003 | Reuse |
| Cartera journal | `Cartera Journal` | 7000036 | Reuse |
| Bill groups / remittances | `Bill Groups` | 7000009 | Reuse |
| Posted bill groups | `Posted Bill Groups` | 7000012 | Reuse |
| Closed bill groups | `Closed Bill Groups` | 7000015 | Reuse |
| Posted Cartera documents | `Posted Cartera Documents` | 7000006 | Reuse |
| Closed Cartera documents | `Closed Cartera Documents` | 7000007 | Reuse |
| Maturity analysis | `Documents Maturity` | 7000029 | Reuse |
| Rejected document status | `Cartera Document Status::Rejected` | 10724 | Reuse |

## OneData objects

| Type | ID | Name | Purpose |
| --- | ---: | --- | --- |
| Table | 96864 | `OD PM Collection Cue` | Temporary UI state for the collection activities. It is not a business or snapshot table. |
| Page | 96865 | `OD PM Collection Activities` | Collection Cues and DrillDown navigation. |
| Query | 96866 | `OD PM Open Receivable Sum` | Aggregates remaining LCY amounts from detailed customer entries. |

## Cues and navigation

| Cue | Source and filter | Calculation | DrillDown |
| --- | --- | --- | --- |
| Pending collection | `Cust. Ledger Entry.Open = true` and non-excluded `Detailed Cust. Ledg. Entry` | Sum `Amount (LCY)` | `Customer Ledger Entries`, open only |
| Overdue collections | Open entries, `Due Date < WorkDate()` | Sum `Amount (LCY)` | Open customer entries due through `WorkDate() - 1D` |
| Next 7 days | Open entries, `Due Date = WorkDate()..WorkDate()+7D` | Sum `Amount (LCY)` | Same range |
| Next 30 days | Open entries, `Due Date = WorkDate()..WorkDate()+30D` | Sum `Amount (LCY)` | Same range |
| Documents in Cartera | `Cartera Doc.` with `Type = Receivable` | Count FlowField | `Receivables Cartera Docs` |
| Unpaid / returned | `Posted Cartera Doc.` with `Type = Receivable`, `Status = Rejected` | Count FlowField | `Posted Cartera Documents` with the same filter |
| Bill groups / remittances | `Bill Group` | Count FlowField, blue Cue | `Bill Groups` |

The seven- and thirty-day ranges intentionally overlap as two planning horizons. Neither range includes overdue entries, avoiding overlap with the overdue Cue.

## Permissions and security

The OneData `ODPM ADMIN`, `ODPM USER`, and `ODPM READ` permission sets grant access only to the new OneData Cue table and page. They do not grant access to Microsoft Cartera, customer ledger, or journal tables/pages.

Users additionally need the applicable standard Business Central permissions for customer ledger entries, cash receipt journals, and the Spanish Cartera objects. The Role Center actions use `AccessByPermission` for Cartera/remittance objects and do not bypass standard security.

## Spanish localization and compatibility

The implementation references the installed BC 28.4 symbol names. The same Cartera object names and IDs are present in the project’s BC 27.3 symbols and are used without obsolete APIs. Sandbox compilation remains the final confirmation for the target environment.

## Future property traceability

The current extension already relates `Lease Contract` to a customer through `Customer No.` and `Second Customer No.`. Lease invoice headers and lines also retain customer numbers. A future navigation path can therefore use:

`Property -> Lease Contract -> Lease Invoice / Posted Sales Invoice -> Cust. Ledger Entry -> Cartera Doc. -> Bill Group -> Posted or rejected Cartera document`.

The customer number is the currently available common relationship. A reliable contract-to-entry drilldown should later be implemented only if the posted sales invoice / customer ledger entry carries a stable contract identifier or a documented source-document relation; this phase does not alter standard tables to add one.
