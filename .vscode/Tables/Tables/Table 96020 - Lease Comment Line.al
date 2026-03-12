table 96020 "Lease Comment Line"
{
    Caption = 'FE Comment Line';
    DataCaptionFields = Type, "No.";
    DrillDownPageID = 96033;
    LookupPageID = 96033;

    fields
    {
        field(1; Type; Option)
        {
            Caption = 'Type';
            OptionCaption = 'General,Fault,Resolution,Accessory,Internal,Service Item Loaner';
            OptionMembers = General,Fault,Resolution,Accessory,Internal,"Service Item Loaner";
        }
        field(2; "No."; Code[20])
        {
            Caption = 'No.';
            NotBlank = true;
            // TableRelation = IF ("Table Name"=CONST('Service Contract')) "Lease Contract"."Contract No.";
        }
        field(3; "Table Line No."; Integer)
        {
            Caption = 'Table Line No.';
        }
        field(4; "Line No."; Integer)
        {
            Caption = 'Line No.';
        }
        field(6; Comment; Text[80])
        {
            Caption = 'Comment';
        }
        field(7; Date; Date)
        {
            Caption = 'Date';
        }
        field(8; "Table Subtype"; Option)
        {
            Caption = 'Table Subtype';
            OptionCaption = '0,1,2,3';
            OptionMembers = "0","1","2","3";
        }
        field(9; "Table Name"; Option)
        {
            Caption = 'Table Name';
            OptionCaption = 'Lease Contract,Lease Header,Lease Invoice Header,Lease Cr.Memo Header';
            OptionMembers = "Lease Contract","Lease Header","Lease Invoice Header","Lease Cr.Memo Header";
        }
    }

    keys
    {
        key(Key1; "Table Name", "Table Subtype", "No.", Type, "Table Line No.", "Line No.")
        {
            Clustered = true;
        }
    }

    fieldgroups
    {
    }

    trigger OnInsert()
    begin
        IF Type IN [1, 2, 3, 4] THEN
            TESTFIELD("Table Line No.");
    end;

    var
        ServCommentLine: Record "Service Comment Line";

    procedure SetUpNewLine()
    begin
        ServCommentLine.RESET;
        ServCommentLine.SETRANGE("Table Name", "Table Name");
        ServCommentLine.SETRANGE("Table Subtype", "Table Subtype");
        ServCommentLine.SETRANGE("No.", "No.");
        ServCommentLine.SETRANGE(Type, Type);
        ServCommentLine.SETRANGE("Table Line No.", "Table Line No.");
        ServCommentLine.SETRANGE(Date, WORKDATE);
        IF NOT ServCommentLine.FINDFIRST THEN
            Date := WORKDATE;
    end;
}

