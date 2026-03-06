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
            TableRelation = "OneData IRPF Jnl. Template";
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
        field(14; "Periode Code"; Code[10])
        {
            Caption = 'Periode Code';
            TableRelation = "OneData IRPF Periode".Code;
            trigger OnValidate()
            begin
            end;
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
        IRPFJnlLine.SETRANGE("Journal Template Name", "Journal Template Name");
        IRPFJnlLine.SETRANGE("Journal Batch Name", Name);
        IRPFJnlLine.DELETEALL;
    end;

    trigger OnInsert()
    begin
        LOCKTABLE;
        IRPFJnlTemplate.GET("Journal Template Name");
    end;

    trigger OnRename()
    begin
        IRPFJnlLine.SETRANGE("Journal Template Name", xRec."Journal Template Name");
        IRPFJnlLine.SETRANGE("Journal Batch Name", xRec.Name);
        WHILE IRPFJnlLine.FINDFIRST DO
            IRPFJnlLine.RENAME("Journal Template Name", Name, IRPFJnlLine."Line No.");
    end;

    var
        Text000: Label '%1 must be 4 characters, for example, 9410 for October, 1994.';
        Text001: Label 'Please check the month number.';
        IRPFJnlTemplate: Record "OneData IRPF Jnl. Template";
        IRPFJnlLine: Record "OneData IRPF Jnl. Line";
        Month: Integer;

    procedure GetStartDate(): Date
    var
        IRPFPeriode : Record "OneData IRPF Periode";
    begin
        TESTFIELD("Periode Code");
        IRPFPeriode.GET("Periode Code");
        EXIT(IRPFPeriode."Starting Date");
    end;
    procedure GetEndDate(): Date
    var
        IRPFPeriode : Record "OneData IRPF Periode";
    begin
        TESTFIELD("Periode Code");
        IRPFPeriode.GET("Periode Code");
        EXIT(IRPFPeriode."Ending Date");
    end;

}

