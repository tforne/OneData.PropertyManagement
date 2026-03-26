// ------------------------------------------------------------------------------------------------
// Copyright (c) Tomàs Forné Martínez. All rights reserved.
// ------------------------------------------------------------------------------------------------

table 96004 "REF Income & Expense Template"
{
    Caption = 'REF Income & Expenses Template';
    DataPerCompany = false;

    fields
    {
        field(1; "No. Template"; Code[20])
        {
            Caption = 'No.';
        }
        field(2; "No. Entry"; Integer)
        {
            Caption = 'Line No.';
        }
        field(3; Date; Date)
        {
            Caption = 'Date';
        }
        field(4; "Row No."; Code[10])
        {
            Caption = 'No. columna';
            DataClassification = ToBeClassified;

            trigger OnValidate()
            begin
                IF (Type = Type::Title) THEN
                    ERROR(Text001);
            end;
        }
        field(5; Type; Option)
        {
            Caption = 'Tipo';
            DataClassification = ToBeClassified;
            OptionCaption = 'Income,Expense,Title';
            OptionMembers = Income,Expense,Title;
        }
        field(6; "Account No."; Code[20])
        {
            Caption = 'Account No.';
            DataClassification = ToBeClassified;
            TableRelation = "G/L Account";
        }
        field(7; Description; Text[50])
        {
            Caption = 'Description';
        }
        field(8; Identation; Integer)
        {
            DataClassification = ToBeClassified;
        }
        field(27; "Entry Category"; Enum "FRE Entry Category")
        {
            Caption = 'Entry Category';
        }
    }

    keys
    {
        key(Key1; "No. Template", "No. Entry")
        {
            Clustered = true;
        }
        key(key2; Type, "Row No.")
        {
        }
    }

    fieldgroups
    {
        fieldgroup(DropDown; Description, Type, "Row No.")
        {
        }

    }

    trigger OnInsert()
    begin
        Identation := 1;
    end;

    var
        Text001: Label 'No se pueden asignar numero de columna';
}

