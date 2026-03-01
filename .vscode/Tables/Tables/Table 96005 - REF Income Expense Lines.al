table 96005 "REF Income & Expense Lines"
{
    Caption = 'REF Income & Expenses Template';
    DrillDownPageID = 96011;
    LookupPageID = 96011;

    fields
    {
        field(1; "No. Fixed Real Estate"; Code[20])
        {
            Caption = 'No.';
        }
        field(2; "No. Entry"; Integer)
        {
            Caption = 'Line No.';
        }
        field(4; "Row No."; Code[10])
        {
            Caption = 'No. columna';
            DataClassification = ToBeClassified;
        }
        field(5; Type; Option)
        {
            Caption = 'Tipo';
            DataClassification = ToBeClassified;
            OptionCaption = 'Income,Expense';
            OptionMembers = Income,Expense;
        }
        field(6; "Account No."; Code[20])
        {
            Caption = 'Account No.';
            DataClassification = ToBeClassified;
            TableRelation = "G/L Account";
        }
        field(7; Description; Text[50])
        {
            Caption = 'Description';
        }
        field(8; Quantity; Decimal)
        {
            Caption = 'Cantidad';
            DataClassification = ToBeClassified;
            DecimalPlaces = 3 : 3;

            trigger OnValidate()
            begin
                CalculateAmount
            end;
        }
        field(9; Price; Decimal)
        {
            Caption = 'Precio';
            DataClassification = ToBeClassified;

            trigger OnValidate()
            begin
                CalculateAmount
            end;
        }
        field(10; Amount; Decimal)
        {
            Caption = 'Importe';
            DataClassification = ToBeClassified;
        }
    }

    keys
    {
        key(Key1; "No. Fixed Real Estate", "No. Entry")
        {
            Clustered = true;
        }
    }

    fieldgroups
    {
    }

    trigger OnInsert()
    begin
        Quantity := 1;
    end;

    var
        Text001: Label 'No se pueden asignar numero de columna';

    local procedure CalculateAmount()
    begin
        Amount := Price * Quantity;
    end;
}

