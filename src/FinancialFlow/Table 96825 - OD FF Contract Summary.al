table 96935 "OD FF Contract Summary"
{
    Caption = 'OD FF Contract Summary';
    DataClassification = CustomerContent;

    fields
    {
        field(1; "Entry No."; Integer)
        {
            Caption = 'Entry No.';
        }
        field(10; "Company Name"; Text[30])
        {
            Caption = 'Empresa';
        }
        field(20; "Contract No."; Code[20])
        {
            Caption = 'Nº contrato';
        }
        field(30; Description; Text[100])
        {
            Caption = 'Descripción contrato';
        }
        field(40; "Customer No."; Code[20])
        {
            Caption = 'Nº cliente';
        }
        field(50; "Customer Name"; Text[100])
        {
            Caption = 'Nombre cliente';
        }
        field(60; Status; Text[50])
        {
            Caption = 'Estado';
        }
        field(70; "Starting Date"; Date)
        {
            Caption = 'Fecha inicio';
        }
        field(80; "Expiration Date"; Date)
        {
            Caption = 'Fecha vencimiento';
        }
        field(90; "Invoice Period"; Text[50])
        {
            Caption = 'Periodicidad';
        }
        field(100; "Amount per Period"; Decimal)
        {
            Caption = 'Importe por periodo';
        }
        field(110; "Annual Amount"; Decimal)
        {
            Caption = 'Importe anual';
        }
        field(120; "Property No."; Code[20])
        {
            Caption = 'Nº activo';
        }
        field(130; "Property Description"; Text[100])
        {
            Caption = 'Descripción activo';
        }
        field(140; "Contact Name"; Text[100])
        {
            Caption = 'Contacto';
        }
        field(150; "Payment Method Code"; Code[20])
        {
            Caption = 'Forma de pago';
        }
        field(160; "Payment Terms Code"; Code[20])
        {
            Caption = 'Términos de pago';
        }
        field(170; "Last Invoice Date"; Date)
        {
            Caption = 'Última factura';
        }
        field(180; "Next Invoice Date"; Date)
        {
            Caption = 'Próxima factura';
        }
    }

    keys
    {
        key(PK; "Entry No.")
        {
            Clustered = true;
        }
    }
}
