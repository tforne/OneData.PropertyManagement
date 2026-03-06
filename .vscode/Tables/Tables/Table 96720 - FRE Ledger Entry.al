table 96720 "FRE Ledger Entry"
{
    Caption = 'FRE Ledger Entry';
    DrillDownPageID = "Movs. FRE";
    LookupPageID = "Movs. FRE";

    fields
    {
        field(1; "Entry No."; Integer)
        {
            Caption = 'Entry No.';
        }
        field(2; "Journal Template Name"; Code[10])
        {
            Caption = 'Journal Template Name';
            TableRelation = "FRE Jnl. Template";
        }
        field(3; "Journal Batch Name"; Code[10])
        {
            Caption = 'Journal Batch Name';
            TableRelation = "FRE Jnl. Batch".Name WHERE ("Journal Template Name"=FIELD("Journal Template Name"));
        }
        field(4; "Posting Date"; Date)
        {
            Caption = 'Posting Date';
        }
        field(5; "Line Type"; Enum "FRE Line Type")
        {
            Caption = 'Line Type';
        }
        field(6; "No. Fixed Real Estate"; Code[20])
        {
            Caption = 'No.';
        }
        field(7; "No."; Code[20])
        {
            Caption = 'No.';
            TableRelation =  "G/L Account"."No.";
        }
        field(8; Description; Text[100])
        {
            Caption = 'Description';
        }
        field(9; "Row No."; Code[10])
        {
            Caption = 'Row No.';
            TableRelation = "REF Income & Expense Template"."Row No.";
            DataClassification = ToBeClassified;
        }
        field(10; "Description Row No."; Code[10])
        {
            Caption = 'Description Row No.';
            DataClassification = ToBeClassified;
        }
        field(13; "Total Cost"; Decimal)
        {
            AutoFormatType = 1;
            Caption = 'Total Cost';
            Editable = false;
        }
        field(15; "Total Price"; Decimal)
        {
            AutoFormatType = 1;
            Caption = 'Total Price';
            Editable = false;
        }
        field(17; "Unit of Measure Code"; Code[10])
        {
            Caption = 'Unit of Measure Code';
            TableRelation = "Item Unit of Measure".Code;
        }
        field(18; "Document Type"; Enum "Gen. Journal Document Type")
        {
            Caption = 'Document Type';
            DataClassification = ToBeClassified;
        }
        field(19; "Document No."; Code[20])
        {
            Caption = 'Document No.';
        }
        field(57;"Source Type"; Enum "Gen. Journal Source Type")
        {
            Caption = 'Source Type';
            DataClassification = ToBeClassified;
        }
        field(58;"Source No.";Code[20])
        {
            Caption = 'Source No.';
            DataClassification = ToBeClassified;
            TableRelation = IF ("Source Type"=CONST(Customer)) Customer
                            ELSE IF ("Source Type"=CONST(Vendor)) Vendor
                            ELSE IF ("Source Type"=CONST("Bank Account")) "Bank Account"
                            ELSE IF ("Source Type"=CONST("Fixed Asset")) "Fixed Asset"
                            ELSE IF ("Source Type"=CONST(Employee)) Employee;
        }
        field(62;"Source Name";Text[50])
        {
            Caption = 'Source Name';
            DataClassification = ToBeClassified;
        }
        field(1018; "Ledger Entry No."; Integer)
        {
            BlankZero = true;
            Caption = 'Ledger Entry No.';
            TableRelation = "G/L Entry"."Entry No.";
        }
    }

    keys
    {
        key(Key1; "Entry No.")
        {
        }
    }

    fieldgroups
    {
    }
}
