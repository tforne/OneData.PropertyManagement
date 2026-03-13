table 96001 "Fixed Real Estate Images"
{
    Caption = 'Fixed Real Estate Images';
    DataCaptionFields = "Fixed Real Estate No.", Description;
    //DrillDownPageID = 96005;
    //LookupPageID = 96005;
    Permissions = TableData 5629 = r;

    fields
    {
        field(1; "Entry No."; Integer)
        {
            AutoIncrement = true;
            Caption = 'Entry No.';
            DataClassification = ToBeClassified;
        }
        field(2; "Fixed Real Estate No."; Code[20])
        {
            Caption = 'No.';
        }
        field(3; Description; Text[50])
        {
            DataClassification = ToBeClassified;
            Editable = true;
            TableRelation = "Description Documents Class".Description;
        }
        field(4; URL; Text[250])
        {
            Caption = 'Description 2';
            ExtendedDatatype = URL;
        }
        field(16; "Create Date"; Date)
        {
            Caption = 'Fecha creación';
            DataClassification = ToBeClassified;
        }
        field(18; "Last Date Modified"; Date)
        {
            Caption = 'Last Date Modified';
            DataClassification = ToBeClassified;
            Editable = false;
        }
        field(92; Picture; MediaSet)
        {
            Caption = 'Picture';
            DataClassification = ToBeClassified;
        }
        field(93; Extension; Code[10])
        {
            DataClassification = ToBeClassified;
        }
        field(200; "Long Description"; BLOB)
        {
            Caption = 'Work Description';
            DataClassification = ToBeClassified;
        }
    }

    keys
    {
        key(Key1; "Entry No.")
        {
            Clustered = true;
        }
    }

    fieldgroups
    {
        fieldgroup(DropDown; "Entry No.", "Fixed Real Estate No.")
        {
        }
        fieldgroup(Brick; Description, "Fixed Real Estate No.", Picture)
        {
        }
    }

    trigger OnDelete()
    var
    begin
    end;

    trigger OnModify()
    begin
        "Last Date Modified" := TODAY;
    end;

    trigger OnRename()
    var
    begin
        "Last Date Modified" := TODAY;
    end;

    var
        Text000: Label 'A main asset cannot be deleted.';
        Text001: Label 'You cannot delete %1 %2 because it has associated depreciation books.';
        UnexpctedSubclassErr: Label 'This real estate asset subclass belongs to a different real estate asset class.';
        DontAskAgainActionTxt: Label 'Don''t ask again';
        NotificationNameTxt: Label 'real estate asset Acquisition Wizard', Locked = true;
        NotificationDescriptionTxt: Label 'Notify when ready to acquire the real estate asset.', Locked = true;
        ReadyToAcquireMsg: Label 'You are ready to acquire the real estate asset.';
        AcquireActionTxt: Label 'Acquire';
}

