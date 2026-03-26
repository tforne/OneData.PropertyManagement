// ------------------------------------------------------------------------------------------------
// Copyright (c) Tomàs Forné Martínez. All rights reserved.
// ------------------------------------------------------------------------------------------------

table 96721 "FRE Detailed Ledg. Entry"
{
    Caption = 'FRE Detailed Ledger Entry';
    DataClassification = CustomerContent;
    DataPerCompany = false;

    fields
    {
        field(1; "Entry No."; Integer)
        {
            Caption = 'Entry No.';
        }
        field(2; "FRE Ledger Entry No."; Integer)
        {
            Caption = 'FRE Ledger Entry No.';
            TableRelation = "FRE Ledger Entry"."Entry No.";
        }
        field(3; "Applied FRE Ledger Entry No."; Integer)
        {
            Caption = 'Applied FRE Ledger Entry No.';
            TableRelation = "FRE Ledger Entry"."Entry No.";
        }
        field(4; "Application Date"; Date)
        {
            Caption = 'Application Date';
        }
        field(5; "Posting Date"; Date)
        {
            Caption = 'Posting Date';
        }
        field(6; "Document No."; Code[20])
        {
            Caption = 'Document No.';
        }
        field(7; "Document Type"; Enum "Gen. Journal Document Type")
        {
            Caption = 'Document Type';
        }
        field(8; Amount; Decimal)
        {
            Caption = 'Amount Applied';
            AutoFormatType = 1;
        }
        field(9; Unapplied; Boolean)
        {
            Caption = 'Unapplied';
        }
        field(10; "Unapplied by Entry No."; Integer)
        {
            Caption = 'Unapplied by Entry No.';
            TableRelation = "FRE Detailed Ledg. Entry"."Entry No.";
        }
        field(11; "Fixed Real Estate No."; Code[20])
        {
            Caption = 'Fixed Real Estate No.';
            TableRelation = "Fixed Real Estate"."No.";
        }
        field(12; "Source Type"; Enum "FRE Journal Source Type")
        {
            Caption = 'Source Type';
        }
        field(13; "Source No."; Code[20])
        {
            Caption = 'Source No.';
            TableRelation = if ("Source Type" = const(Customer)) Customer
                            else if ("Source Type" = const(Vendor)) Vendor
                            else if ("Source Type" = const("Bank Account")) "Bank Account"
                            else if ("Source Type" = const("Fixed Asset")) "Fixed Asset"
                            else if ("Source Type" = const("Real Estate Asset")) "Fixed Real Estate"
                            else if ("Source Type" = const(Employee)) Employee;
        }
        field(14; "User ID"; Code[50])
        {
            Caption = 'User ID';
            DataClassification = EndUserIdentifiableInformation;
        }
        field(15; "Transaction No."; Integer)
        {
            Caption = 'Transaction No.';
        }
        field(16; "Reason Code"; Code[10])
        {
            Caption = 'Reason Code';
            TableRelation = "Reason Code";
        }
        field(17; "External Document No."; Code[35])
        {
            Caption = 'External Document No.';
        }
        field(18; "Ledger Entry No."; Integer)
        {
            Caption = 'G/L Entry No.';
            BlankZero = true;
            TableRelation = "G/L Entry"."Entry No.";
        }
        field(19; "Initial Entry Amount"; Decimal)
        {
            Caption = 'Initial Entry Amount';
            AutoFormatType = 1;
        }
        field(20; "Applied Entry Amount"; Decimal)
        {
            Caption = 'Applied Entry Amount';
            AutoFormatType = 1;
        }
    }

    keys
    {
        key(PK; "Entry No.")
        {
            Clustered = true;
        }
        key(Key2; "FRE Ledger Entry No.", "Posting Date")
        {
        }
        key(Key3; "Applied FRE Ledger Entry No.", "Posting Date")
        {
        }
        key(Key4; "Application Date")
        {
        }
        key(Key5; "Document No.")
        {
        }
        key(Key6; "Fixed Real Estate No.", "Posting Date")
        {
        }
        key(Key7; "Transaction No.")
        {
        }
    }

    trigger OnInsert()
    begin
        if "Entry No." = 0 then
            "Entry No." := GetNextEntryNo();
    end;

    local procedure GetNextEntryNo(): Integer
    var
        FREDetailedLedgEntry: Record "FRE Detailed Ledg. Entry";
    begin
        if FREDetailedLedgEntry.FindLast() then
            exit(FREDetailedLedgEntry."Entry No." + 1);

        exit(1);
    end;
}
