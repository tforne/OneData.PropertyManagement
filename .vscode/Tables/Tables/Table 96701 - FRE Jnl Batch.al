table 96701 "FRE Jnl. Batch"
{
    Caption = 'FRE Jnl. Batch';
    DataCaptionFields = Name, Description;
    LookupPageID = "FRE Jnl. Batches";

    fields
    {
        field(1; "Journal Template Name"; Code[10])
        {
            Caption = 'Journal Template Name';
            NotBlank = true;
            TableRelation = "FRE Jnl. Template";
        }
        field(2; Name; Code[10])
        {
            Caption = 'Name';
            NotBlank = true;
        }
        field(3; Description; Text[50])
        {
            Caption = 'Description';
        }
    }

    keys
    {
        key(Key1; "Journal Template Name", Name)
        {
            Clustered = true;
        }
    }

    fieldgroups
    {
    }

    trigger OnDelete()
    begin
        FREJnlLine.SETRANGE("Journal Template Name", "Journal Template Name");
        FREJnlLine.SETRANGE("Journal Batch Name", Name);
        FREJnlLine.DELETEALL;
    end;

    trigger OnInsert()
    begin
        LOCKTABLE;
        FREJnlTemplate.GET("Journal Template Name");
    end;

    trigger OnRename()
    begin
        FREJnlLine.SETRANGE("Journal Template Name", xRec."Journal Template Name");
        FREJnlLine.SETRANGE("Journal Batch Name", xRec.Name);
        WHILE FREJnlLine.FINDFIRST DO
            FREJnlLine.RENAME("Journal Template Name", Name, FREJnlLine."Line No.");
    end;

    var
        Text000: Label '%1 must be 4 characters, for example, 9410 for October, 1994.';
        Text001: Label 'Please check the month number.';
        FREJnlTemplate: Record "FRE Jnl. Template";
        FREJnlLine: Record "FRE Jnl. Line";

}

