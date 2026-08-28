table 96044 "OD Lease Ctr. Val. Buffer"
{
    Caption = 'Lease Contract Validation Buffer';
    DataClassification = SystemMetadata;

    fields
    {
        field(1; "Line No."; Integer)
        {
            Caption = 'Line No.';
        }
        field(2; "Contract No."; Code[20])
        {
            Caption = 'Contract No.';
        }
        field(3; "Issue Type"; Option)
        {
            Caption = 'Issue Type';
            OptionCaption = 'General,Header,Line,Amount';
            OptionMembers = General,Header,Line,Amount;
        }
        field(4; "Related Line No."; Integer)
        {
            Caption = 'Related Line No.';
        }
        field(5; Message; Text[250])
        {
            Caption = 'Message';
        }
    }

    keys
    {
        key(PK; "Line No.")
        {
            Clustered = true;
        }
    }
}
