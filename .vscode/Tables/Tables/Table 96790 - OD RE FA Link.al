table 96790 "OD RE FA Link"
{
    Caption = 'RE / FA Link';
    DataClassification = CustomerContent;

    fields
    {
        field(1; "Entry No."; Integer)
        {
            AutoIncrement = true;
        }

        field(10; "Real Estate No."; Code[20])
        {
            TableRelation = "Fixed Real Estate"."No." where ( Type = const(1));
        }
        field(20; "FA No."; Code[20])
        {
            TableRelation = "Fixed Asset"."No.";
        }

        field(30; "Link Type"; Enum "OD RE FA Link Type") 
        { 
            InitValue = Shared;
        }

        field(40; "Primary Link"; Boolean) { }

        field(50; "Allocation %"; Decimal)
        {
            DecimalPlaces = 0 : 5;
            MinValue = 0;
            MaxValue = 100;
        }

        field(60; Active; Boolean)
        {
            InitValue = true;
        }

        field(70; "Starting Date"; Date) { }

        field(80; "Ending Date"; Date) { }

        field(90; Comment; Text[100]) { }
        field(100; "Real Estate Description"; Text[100])
        {
            Caption = 'Descripción inmueble';
            FieldClass = FlowField;
            CalcFormula = lookup("Fixed Real Estate".Description where("No." = field("Real Estate No.")));
        }
        field(110; "FA Description"; Text[100])
        {
            Caption = 'Descripción activo fijo';
            FieldClass = FlowField;
            CalcFormula = lookup("Fixed Asset".Description where("No." = field("FA No.")));
        }
    }

    keys
    {
        key(PK; "Entry No.") { Clustered = true; }
        key(RE; "Real Estate No.") { }
        key(FA; "FA No.") { }
    }

    trigger OnInsert()
    var
        Mgt: Codeunit "OD RE FA Link Mgt.";
    begin
        Mgt.ValidateLink("Real Estate No.", "FA No.", "Link Type", "Primary Link", "Allocation %");
    end;
}
