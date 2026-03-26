// ------------------------------------------------------------------------------------------------
// Copyright (c) Tomàs Forné Martínez. All rights reserved.
// ------------------------------------------------------------------------------------------------

table 96055 "Incident Comment Line"
{
    Caption = 'Incident Comment Line';
    DataCaptionFields = "Incident Id.";
    DataPerCompany = false;
    DrillDownPageID = 96058;
    LookupPageID = 96058;

    fields
    {
        field(1; "Incident Id."; Guid)
        {
            Caption = 'Incident Id.';
        }
        field(2; "Line No."; Integer)
        {
            Caption = 'Line No.';
        }
        field(6; Comment; Text[250])
        {
            Caption = 'Comment';
        }
        field(7; Date; Date)
        {
            Caption = 'Date';
        }
    }

    keys
    {
        key(Key1; "Incident Id.", "Line No.")
        {
            Clustered = true;
        }
    }

    fieldgroups
    {
    }

    trigger OnInsert()
    begin
    end;

    var
        ServCommentLine: Record "Service Comment Line";

    procedure SetUpNewLine()
    begin
            Date := WORKDATE;
    end;
}

