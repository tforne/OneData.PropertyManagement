// table 95000 "BBVA Movements list"
// {

//     fields
//     {
//         field(1; "No. Entry."; Integer)
//         {
//             Caption = 'No. Mov.';
//             DataClassification = ToBeClassified;
//         }
//         field(2; "Posting Date"; Date)
//         {
//             Caption = 'Fecha registro';
//             DataClassification = ToBeClassified;
//         }
//         field(3; "Value Date"; Date)
//         {
//             Caption = 'Fecha valor';
//             DataClassification = ToBeClassified;
//         }
//         field(4; "Transaction No."; Code[20])
//         {
//             Caption = 'Código';
//             DataClassification = ToBeClassified;
//             // TableRelation = "Transactions Bank";
//             // ValidateTableRelation = false;
//         }
//         field(5; "Transaction Description"; Text[150])
//         {
//             Caption = 'Concepto';
//             DataClassification = ToBeClassified;
//         }
//         field(6; Observations; Text[150])
//         {
//             Caption = 'Observaciones';
//             DataClassification = ToBeClassified;
//         }
//         field(7; Amount; Decimal)
//         {
//             Caption = 'Importe';
//             DataClassification = ToBeClassified;
//         }
//         field(8; Balance; Decimal)
//         {
//             Caption = 'Saldo';
//             DataClassification = ToBeClassified;
//         }
//         field(9; "Currency Code"; Code[10])
//         {
//             Caption = 'Currency Code';
//             DataClassification = ToBeClassified;
//         }
//         field(10; "CCC Bank Branch No."; Text[4])
//         {
//             Caption = 'CCC Bank Branch No.';
//             DataClassification = ToBeClassified;
//             Numeric = true;
//         }
//         field(20; "Bank Account No."; Code[20])
//         {
//             Caption = 'Bank Account No.';
//             DataClassification = ToBeClassified;
//             TableRelation = "Bank Account";
//         }
//         field(21; "Statement No."; Code[20])
//         {
//             Caption = 'Statement No.';
//             DataClassification = ToBeClassified;
//             TableRelation = "Bank Acc. Reconciliation"."Statement No." WHERE ("Bank Account No."=FIELD("Bank Account No."));
//         }
//     }

//     keys
//     {
//         key(Key1; "Bank Account No.", "Statement No.", "No. Entry.")
//         {
//             Clustered = true;
//         }
//     }

//     fieldgroups
//     {
//     }

//     trigger OnInsert()
//     begin
//         "Bank Account No." := CurrBankAccountNo;
//         "Statement No." := CurrStatementNo;
//     end;

//     var
//         BankAccount: Record "Bank Account";
//         BankAccReconciliationLine: Record "Bank Acc. Reconciliation Line";
//         LineNo: Integer;
//         CurrBankAccountNo: Code[20];
//         CurrStatementNo: Code[20];
//         Text001: Label 'Imported %1 moviments';

//     procedure CreateBankAccReconciliationLine()
//     begin
//         LineNo := 1;
//         IF FINDFIRST THEN
//             REPEAT
//                 BankAccReconciliationLine."Statement Type" := BankAccReconciliationLine."Statement Type"::"Bank Reconciliation";
//                 BankAccReconciliationLine."Bank Account No." := CurrBankAccountNo;
//                 BankAccReconciliationLine."Statement No." := CurrStatementNo;
//                 BankAccReconciliationLine."Statement Line No." := LineNo;
//                 BankAccReconciliationLine.INSERT;
//                 LineNo := LineNo + 1;
//                 BankAccReconciliationLine."Transaction Date" := "Posting Date";
//                 BankAccReconciliationLine."Value Date" := "Value Date";
//                 BankAccReconciliationLine."Transaction Text" := COPYSTR("Transaction Description", 1, 50);
//                 IF "Transaction Description" <> '' THEN
//                     BankAccReconciliationLine.Description := COPYSTR("Transaction Description", 1, 50)
//                 ELSE
//                     BankAccReconciliationLine.Description := COPYSTR(Observations, 1, 50);
//                 BankAccReconciliationLine.VALIDATE("Statement Amount", Amount);
//                 BankAccReconciliationLine.MODIFY;
//             UNTIL NEXT = 0;
//         MESSAGE(Text001, COUNT);
//     end;

//     procedure SetBankAccReconciliationLine(_BankAccountNo: Code[20]; _StatementNo: Code[20])
//     begin
//         CurrBankAccountNo := _BankAccountNo;
//         CurrStatementNo := _StatementNo;
//     end;
// }

