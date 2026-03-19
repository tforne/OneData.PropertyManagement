table 96729 "FRE Import Preview v2"
{
    Caption = 'FRE Import Preview';
    DataClassification = ToBeClassified;

    fields
    {
        field(1; "Excel Row No."; Integer)
        {
            Caption = 'Excel Row No.';
        }

        field(2; Date; Date)
        {
            Caption = 'Date';
        }

        field(3; "Document Type Text"; Text[30])
        {
            Caption = 'Document Type';
        }

        field(4; "Document No."; Code[20])
        {
            Caption = 'Document No.';
        }

        field(5; "Line Type Text"; Text[50])
        {
            Caption = 'Line Type';
        }

        field(6; "Fixed Real Estate Description"; Text[100])
        {
            Caption = 'Fixed Real Estate Description';
        }

        field(7; "Fixed Real Estate No."; Code[20])
        {
            Caption = 'Fixed Real Estate No.';
            TableRelation = "Fixed Real Estate"."No.";
            trigger OnValidate()
            var
                RE : Record "Fixed Real Estate";
            begin
                "Fixed Real Estate Description" := '';
                if re.get("Fixed Real Estate No.") then
                    "Fixed Real Estate Description" := re.Description;
            end;
        }

        field(8; Description; Text[100])
        {
            Caption = 'Description';
        }

        field(9; "Description Row No. Text"; Text[100])
        {
            Caption = 'Description Row No.';
        }

        field(10; "Row No."; Code[10])
        {
            Caption = 'Row No.';
            TableRelation = "REF Income & Expense Template"."Row No.";
            trigger OnValidate()
            var
                RefIETemplante : Record "REF Income & Expense Template";
            begin
                "Description Row No. Text" := '';
                RefIETemplante.reset;
                RefIETemplante.SetRange("Row No.","Row No.");
                if RefIETemplante.FindFirst() then
                    "Description Row No. Text" := RefIETemplante.Description;
            end;
        }

        field(11; Amount; Decimal)
        {
            Caption = 'Amount';
            AutoFormatType = 1;
        }

        field(12; "Amount Including VAT"; Decimal)
        {
            Caption = 'Amount Including VAT';
            AutoFormatType = 1;
        }

        field(13; Error; Text[250])
        {
            Caption = 'Error';
        }
        field(20; "Suggested Source Type"; Enum "FRE Journal Source Type") {}
        field(21; "Suggested Source No."; Code[20]) {}
        field(22; "Suggestion Confidence"; Decimal) {}
        field(23; "Suggestion Explanation"; Text[250]) {}
        field(24; "Accept Suggestion"; Boolean) {}
    }

    keys
    {
        key(PK; "Excel Row No.")
        {
            Clustered = true;
        }
    }
}