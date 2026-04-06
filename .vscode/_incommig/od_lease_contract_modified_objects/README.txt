Objetos modificados

1) La request page 96041 ya no usa SourceTable. Trabaja con variables internas.
2) La codeunit 96043 añade SourceHeader.Reset() después de ChangeCompany().
3) La codeunit 96042 usa GetValues(CopyRequest) en lugar de SetRecord/GetRecord.

Objetos incluidos:
- Page 96041 "OD Copy Lease Contract Req."
- Codeunit 96043 "OD Lease Contract Lookup"
- Codeunit 96042 "OD Copy Lease Contract Mgt."
