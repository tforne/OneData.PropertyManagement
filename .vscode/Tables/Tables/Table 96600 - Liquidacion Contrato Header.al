// ------------------------------------------------------------------------------------------------
// Copyright (c) Tomàs Forné Martínez. All rights reserved.
// ------------------------------------------------------------------------------------------------

table 96600 "Liquidacion Contrato Header"
{
    Caption = 'Liquidación de Contrato Header';
    DataClassification = CustomerContent;

    fields
    {
        field(1; "Contract No."; Code[20])
        {
            TableRelation = "Lease Contract"."Contract No.";
            Editable = false;
        }
        field(2; "Fecha Liquidacion"; Date) 
        { Editable = true; }
        field(3; "Fecha Entrega Llaves"; Date) 
        { Editable = true; }
        field(4; "Motivo Liquidacion"; Enum "Motivo Liquidacion Contrato") 
        { Editable = true; }
        field(5; "Renta Final"; Decimal) 
        { Editable = false; }
        field(6; "Penalizacion"; Decimal) 
        { Editable = false; }
        field(9; "Importe Total Liquidacion"; Decimal) 
        { Editable = false; }
        field(10; "Usuario Liquidacion"; Code[50]) 
        { Editable = false; }
        field(11; "Fecha Creacion"; DateTime) 
        { Editable = false; }
        field(12; "Ciudad Entrega Llaves"; text[100])
        { Editable = true; }
        field(10000;"Amount Rental Deposit";Decimal)
        {
            CalcFormula = Sum("Rental Deposit".Amount WHERE ("Contract No."=FIELD("Contract No.")));
            Caption = 'Amount Rental Deposit';
            Editable = false;
            FieldClass = FlowField;
        }

    }

    keys
    {
        key(PK; "Contract No.") { Clustered = true; }
    }

    trigger OnInsert()
    begin
        "Fecha Creacion" := CurrentDateTime;
        "Usuario Liquidacion" := UserId;
    end;
}