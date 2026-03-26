// ------------------------------------------------------------------------------------------------
// Copyright (c) Tomàs Forné Martínez. All rights reserved.
// ------------------------------------------------------------------------------------------------

table 96024 "Lease Contract Gain/Loss Entry"
{
    Caption = 'Contract Gain/Loss Entry';
    DrillDownPageID = 96018;
    LookupPageID = 96018;
    Permissions = TableData 5969 = rimd;

    fields
    {
        field(1; "Entry No."; Integer)
        {
            Caption = 'Entry No.';
        }
        field(2; "Contract No."; Code[20])
        {
            Caption = 'Contract No.';
            TableRelation = "Lease Contract"."Contract No.";
        }
        field(3; "Contract Group Code"; Code[10])
        {
            Caption = 'Contract Group Code';
            TableRelation = "Contract Group";
        }
        field(4; "Change Date"; Date)
        {
            Caption = 'Change Date';
        }
        field(5; "Reason Code"; Code[10])
        {
            Caption = 'Reason Code';
            TableRelation = "Reason Code";
        }
        field(6; "Type of Change"; Option)
        {
            Caption = 'Type of Change';
            OptionCaption = 'Line Added,Line Deleted,Contract Signed,Contract Canceled,Manual Update,Price Update';
            OptionMembers = "Line Added","Line Deleted","Contract Signed","Contract Canceled","Manual Update","Price Update";
        }
        field(8; "Responsibility Center"; Code[10])
        {
            Caption = 'Responsibility Center';
            TableRelation = "Responsibility Center";
        }
        field(9; "Customer No."; Code[20])
        {
            Caption = 'Customer No.';
            TableRelation = Customer;
        }
        field(11; Description; Text[30])
        {
            Caption = 'Description';
            DataClassification = EndUserIdentifiableInformation;
            TableRelation = User."User Name";
            //This property is currently not supported
            //TestTableRelation = false;

            trigger OnLookup()
            var
                UserMgt: Codeunit "User Management";
            begin
            end;
        }
        field(12; Amount; Decimal)
        {
            AutoFormatType = 1;
            Caption = 'Amount';
        }
    }

    keys
    {
        key(Key1; "Entry No.")
        {
            Clustered = true;
        }
        key(Key2; "Contract No.", "Change Date", "Reason Code")
        {
            SumIndexFields = Amount;
        }
        key(Key3; "Contract Group Code", "Change Date")
        {
            SumIndexFields = Amount;
        }
        key(Key4; "Reason Code", "Change Date")
        {
            SumIndexFields = Amount;
        }
        key(Key5; "Responsibility Center", "Change Date")
        {
            SumIndexFields = Amount;
        }
        key(Key6; "Responsibility Center", "Type of Change", "Reason Code")
        {
        }
    }

    fieldgroups
    {
    }


    procedure AddEntry(ChangeStatus: Integer; ContractType: Integer; ContractNo: Code[20]; ChangeAmount: Decimal; ReasonCode: Code[10])
    var
        LeaseContract: Record "Lease Contract";
        NextLine: Integer;
    begin
        RESET;
        LOCKTABLE;
        IF FINDLAST THEN
            NextLine := "Entry No." + 1
        ELSE
            NextLine := 1;

        IF ContractNo <> '' THEN
            LeaseContract.GET(ContractNo)
        ELSE
            CLEAR(LeaseContract);

        INIT;
        "Entry No." := NextLine;
        "Contract No." := ContractNo;
        // "Contract Group Code" := LeaseContract."Contract Group Code";
        "Change Date" := TODAY;
        "Type of Change" := ChangeStatus;
        // "Responsibility Center" := LEaseContract."Responsibility Center";
        "Customer No." := LeaseContract."Customer No.";

        Amount := ChangeAmount;
        "Reason Code" := ReasonCode;
        INSERT;
    end;
}

