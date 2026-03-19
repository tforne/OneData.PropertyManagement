table 96726 "FRE Import Preview"
{
    Caption = 'FRE Import Preview';
    DataClassification = ToBeClassified;

    fields
    {
        field(1; "Row No."; Integer)
        {
            Caption = 'Row No.';
        }

        field(2; Date; Date)
        {
            Caption = 'Date';
        }

        field(3; "Document Type"; Text[30])
        {
            Caption = 'Document Type';
        }

        field(4; "Document No."; Code[20])
        {
            Caption = 'Document No.';
        }

        field(5; "Line Type"; Text[50])
        {
            Caption = 'Line Type';
        }

        field(6; "Fixed Real Estate No."; Code[20])
        {
            Caption = 'Fixed Real Estate No.';
        }

        field(7; Description; Text[100])
        {
            Caption = 'Description';
        }

        field(8; "Row No. Value"; Code[10])
        {
            Caption = 'Row No. Value';
        }

        field(9; "Description Row No. Value"; Text[100])
        {
            Caption = 'Description Row No. Value';
        }

        field(10; "Source Type"; Text[30])
        {
            Caption = 'Source Type';
        }

        field(11; "Source No."; Code[20])
        {
            Caption = 'Source No.';
        }

        field(12; Amount; Decimal)
        {
            Caption = 'Amount';
            AutoFormatType = 1;
        }

        field(13; "Amount Including VAT"; Decimal)
        {
            Caption = 'Amount Including VAT';
            AutoFormatType = 1;
        }

        field(14; Error; Text[250])
        {
            Caption = 'Error';
        }

        field(20; "Fixed Real Estate Description"; Text[100])
        {
            Caption = 'Fixed Real Estate Description';
        }

        field(21; "Description Row No. Text"; Text[100])
        {
            Caption = 'Description Row No. Text';
        }

        field(22; "Suggestion Confidence"; Decimal)
        {
            Caption = 'Suggestion Confidence';
        }

        field(23; "Suggestion Explanation"; Text[250])
        {
            Caption = 'Suggestion Explanation';
        }

        field(24; "Accept Suggestion"; Boolean)
        {
            Caption = 'Accept Suggestion';
        }
    }

    keys
    {
        key(PK; "Row No.")
        {
            Clustered = true;
        }
    }
}