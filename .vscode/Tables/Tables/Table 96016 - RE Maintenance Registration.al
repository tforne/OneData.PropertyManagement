// ------------------------------------------------------------------------------------------------
// Copyright (c) Tomàs Forné Martínez. All rights reserved.
// ------------------------------------------------------------------------------------------------

table 96016 "RE Maintenance Registration"
{
    Caption = 'Maintenance Registration';
    DataPerCompany = false;
    DrillDownPageID = 96016;
    LookupPageID = 96016;

    fields
    {
        field(1; "FRE No."; Code[20])
        {
            Caption = 'FA No.';
            NotBlank = true;
            TableRelation = "Fixed Real Estate";
        }
        field(2; "Line No."; Integer)
        {
            Caption = 'Line No.';
        }
        field(3; "Service Date"; Date)
        {
            Caption = 'Service Date';
        }
        field(4; "Maintenance Vendor No."; Code[20])
        {
            Caption = 'Maintenance Vendor No.';
            TableRelation = Vendor;
        }
        field(5; Comment; Text[50])
        {
            Caption = 'Comment';
        }
        field(6; "Service Agent Name"; Text[30])
        {
            Caption = 'Service Agent Name';
        }
        field(7; "Service Agent Phone No."; Text[30])
        {
            Caption = 'Service Agent Phone No.';
            ExtendedDatatype = PhoneNo;
        }
        field(8; "Service Agent Mobile Phone"; Text[30])
        {
            Caption = 'Service Agent Mobile Phone';
            ExtendedDatatype = PhoneNo;
        }
    }

    keys
    {
        key(Key1; "FRE No.", "Line No.")
        {
            Clustered = true;
        }
    }

    fieldgroups
    {
    }

    trigger OnInsert()
    begin
        FRE.LOCKTABLE;
        FRE.GET("FRE No.");
    end;

    var
        FRE: Record "Fixed Real Estate";
}

