// ------------------------------------------------------------------------------------------------
// Copyright (c) Tomàs Forné Martínez. All rights reserved.
// ------------------------------------------------------------------------------------------------

table 96720 "FRE Ledger Entry"
{
    Caption = 'FRE Ledger Entry';
    DrillDownPageID = "Movs. FRE";
    LookupPageID = "Movs. FRE";
    DataPerCompany = false;

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
            TableRelation = "FRE Jnl. Batch".Name WHERE("Journal Template Name" = FIELD("Journal Template Name"));
        }
        field(4; "Posting Date"; Date)
        {
            Caption = 'Posting Date';
        }
        field(5; "Line Type"; Enum "FRE Line Type")
        {
            Caption = 'Line Type';
        }
        field(6; "Fixed Real Estate No."; Code[20])
        {
            Caption = 'No.';
            TableRelation = "Fixed Real Estate"."No.";
        }
        field(8; Description; Text[100])
        {
            Caption = 'Description';
        }
        field(9; "Row No."; Code[10])
        {
            Caption = 'Row No.';
            TableRelation = "REF Income & Expense Template"."Row No.";
            ValidateTableRelation = false;
            DataClassification = ToBeClassified;
        }
        field(10; "Description Row No."; text[100])
        {
            Caption = 'Description Row No.';
            DataClassification = ToBeClassified;
        }
        field(13; Amount; Decimal)
        {
            AutoFormatType = 1;
            Caption = 'Amount';
            Editable = false;
        }
        field(15; "Amount Including VAT"; Decimal)
        {
            AutoFormatType = 1;
            Caption = 'Amount Including VAT';
            Editable = false;
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
        field(20; Open; Boolean)
        {
            Caption = 'Open';
        }
        field(21; "Due Date"; Date)
        {
            Caption = 'Due Date';
        }
        field(22; "Closed at Date"; Date)
        {
            Caption = 'Closed at Date';
        }
        field(23; "Closed by Entry No."; Integer)
        {
            Caption = 'Closed by Entry No.';
        }
        field(24; "Remaining Amount"; Decimal)
        {
            Caption = 'Remaining Amount';
            AutoFormatType = 1;
        }
        field(25; "Remaining Amt. Incl. VAT"; Decimal)
        {
            Caption = 'Remaining Amt. Incl. VAT';
            AutoFormatType = 1;
        }
        field(27; "Entry Category"; Enum "FRE Entry Category")
        {
            Caption = 'Entry Category';
        }
        field(57; "Source Type"; Enum "FRE Journal Source Type")
        {
            Caption = 'Source Type';
            DataClassification = ToBeClassified;
        }
        field(58; "Source No."; Code[20])
        {
            Caption = 'Source No.';
            DataClassification = ToBeClassified;
            TableRelation = IF ("Source Type" = CONST(Customer)) Customer
            ELSE IF ("Source Type" = CONST(Vendor)) Vendor
            ELSE IF ("Source Type" = CONST("Bank Account")) "Bank Account"
            ELSE IF ("Source Type" = CONST("Fixed Asset")) "Fixed Asset"
            ELSE IF ("Source Type" = CONST("Real Estate Asset")) "Fixed Real Estate"
            ELSE IF ("Source Type" = CONST(Employee)) Employee;
        }
        field(62; "Source Name"; Text[50])
        {
            Caption = 'Source Name';
            DataClassification = ToBeClassified;
        }
        field(100; "Company Name"; Text[30])
        {
            Editable = false;
            Caption = 'Company Name';
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
        key(Key2; "Fixed Real Estate No.", "Posting Date")
        {
        }
        key(Key3; "Document No.")
        {
        }
        key(Key4; "Source Type", "Source No.")
        {
        }
        key(Key5; "Row No.", "Posting Date")
        {
        }
        key(Key6; Open, "Due Date")
        {
        }
    }

    fieldgroups
    {
    }
}
