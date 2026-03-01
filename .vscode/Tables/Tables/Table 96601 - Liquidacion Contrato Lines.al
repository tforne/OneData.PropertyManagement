table 96601 "Liquidacion Contrato Lines"
{
    Caption = 'Liquidación de Contrato Lines';
    DataClassification = CustomerContent;

    fields
    {
        field(1; "Contract No."; Code[20])
        {
            TableRelation = "Lease Contract"."Contract No.";
            Editable = false;
        }
        field(2; "Line No."; Integer)
        {
            Caption = 'Line No.';
        }

        field(3; Description; Text[50]) 
        { 
            Editable = true ;
        }
        field(11; Amount; Decimal) 
        { 
            Editable = true; 
        }
    }

    keys
    {
        key(PK; "Contract No.", "Line No.") { Clustered = true; }
    }

    trigger OnInsert()
    begin
    end;
}