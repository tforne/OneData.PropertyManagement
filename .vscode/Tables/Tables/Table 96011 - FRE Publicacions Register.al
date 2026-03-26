// ------------------------------------------------------------------------------------------------
// Copyright (c) Tomàs Forné Martínez. All rights reserved.
// ------------------------------------------------------------------------------------------------

table 96011 "FRE Publicacions Register"
{
    Caption = 'Credit Transfer Register';
    DataCaptionFields = Identifier, "Created Date-Time";
    DataPerCompany = false;
    DrillDownPageID = 1205;
    LookupPageID = 1205;

    fields
    {
        field(1; "No."; Integer)
        {
            Caption = 'No.';
        }
        field(2; Identifier; Code[20])
        {
            Caption = 'Identifier';
        }
        field(3; "Created Date-Time"; DateTime)
        {
            Caption = 'Created Date-Time';
        }
        field(4; "Created by User"; Code[50])
        {
            Caption = 'Created by User';
            DataClassification = EndUserIdentifiableInformation;
            TableRelation = User."User Name";
        }
        field(5; Status; Option)
        {
            Caption = 'Status';
            Editable = false;
            OptionCaption = 'Canceled,File Created,File Re-exported';
            OptionMembers = Canceled,"File Created","File Re-exported";
        }
        field(6; "No. of Transfers"; Integer)
        {
            CalcFormula = Count ("Credit Transfer Entry" WHERE ("Credit Transfer Register No."=FIELD("No.")));
            Caption = 'No. of Transfers';
            FieldClass = FlowField;
        }
        field(9;"Exported File";BLOB)
        {
            Caption = 'Exported File';
        }
    }

    keys
    {
        key(Key1;"No.")
        {
            Clustered = true;
        }
    }

    fieldgroups
    {
    }

    var
        PaymentsFileNotFoundErr: Label 'The original payment file was not found.\Export a new file from the Payment Journal window.';
        ExportToServerFile: Boolean;

    procedure CreateNew(NewIdentifier: Code[20];NewBankAccountNo: Code[20])
    begin
        RESET;
        LOCKTABLE;
        IF FINDLAST THEN;
        INIT;
        "No." += 1;
        Identifier := NewIdentifier;
        "Created Date-Time" := CURRENTDATETIME;
        "Created by User" := USERID;
        INSERT;
    end;

    procedure SetStatus(NewStatus: Option)
    begin
        LOCKTABLE;
        FIND;
        Status := NewStatus;
        MODIFY;
    end;

    procedure SetFileContent(var DataExch: Record "Data Exch.")
    begin
        LOCKTABLE;
        FIND;
        DataExch.CALCFIELDS("File Content");
        "Exported File" := DataExch."File Content";
        MODIFY;
    end;

    procedure EnableExportToServerFile()
    begin
        ExportToServerFile := TRUE;
    end;
}

