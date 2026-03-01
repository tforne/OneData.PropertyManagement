table 96027 "Tax Amount Line"
{
    Caption = 'Tax Amount Line';
    DataClassification = CustomerContent;
    LookupPageId = "List Tax Amount Line";
    DrillDownPageId = "List Tax Amount Line";

    fields
    {
        field(1; "Document Type"; Enum Enum_DocsPropertyManagement)
        {
            Caption = 'Document Type';
        }
        field(2; "Document No."; Code[20])
        {
            Caption = 'Document No.';
        }
        field(3; "Line No."; Integer)
        {
            Caption = 'Line No.';
        }
        field(4; "Tax Group Code"; Code[20])
        {
            Caption = 'Tax Group Code';
            Editable = true;
            TableRelation = "Tax Group";
        }

        field(10; "Tax %"; Decimal)
        {
            Caption = 'Tax %';
            DecimalPlaces = 0 : 5;
            Editable = false;
        }
        field(11; "Tax Base"; Decimal)
        {
            AutoFormatType = 1;
            Caption = 'Tax Base';
            Editable = false;
        }
        field(12; "Tax Amount"; Decimal)
        {
            AutoFormatType = 1;
            Caption = 'Tax Amount';

            trigger OnValidate()
            begin
                TestField("Tax %");
                TestField("Tax Base");
            end;
        }
        field(13; "Line Amount"; Decimal)
        {
            AutoFormatType = 1;
            Caption = 'Line Amount';
            Editable = false;
            CalcFormula = Sum("Lease Contract Line".Amount WHERE ("Contract No."=FIELD("Document No."),"Line No."=FIELD("Line No.")));
            FieldClass = FlowField;
        }
        field(14; "Use Tax"; Boolean)
        {
            Caption = 'Use Tax';
        }
        field(15; "Calculated Tax Amount"; Decimal)
        {
            AutoFormatType = 1;
            Caption = 'Calculated Tax Amount';
            Editable = false;
        }
        field(19; "Tax Category"; Code[10])
        {
            Caption = 'Tax Category';
        }
    }

    keys
    {
        key(Key1; "Document Type", "Document No.", "Line No.", "Tax Group Code")
        {
            Clustered = true;
        }
        key(Key2; "Tax Group Code", "Tax %")
        {
        }
    }

    fieldgroups
    {
    }
}
