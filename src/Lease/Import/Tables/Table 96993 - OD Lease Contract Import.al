table 96993 "OD Lease Contract Import"
{
    Caption = 'OD Lease Contract Import';
    DataClassification = CustomerContent;

    fields
    {
        field(1; "Import Batch ID"; Guid)
        {
            Caption = 'Import Batch ID';
            DataClassification = SystemMetadata;
        }
        field(2; "Excel Row No."; Integer)
        {
            Caption = 'Excel Row No.';
            DataClassification = SystemMetadata;
        }
        field(3; "Contract No."; Code[20])
        {
            Caption = 'Contract No.';
            DataClassification = CustomerContent;
        }
        field(4; Description; Text[80])
        {
            Caption = 'Description';
            DataClassification = CustomerContent;
        }
        field(5; "Customer No."; Code[20])
        {
            Caption = 'Customer No.';
            DataClassification = CustomerContent;
            TableRelation = Customer;
        }
        field(6; "Second Customer No."; Code[20])
        {
            Caption = 'Second Customer No.';
            DataClassification = CustomerContent;
            TableRelation = Customer;
        }
        field(7; "Fixed Real Estate No."; Code[20])
        {
            Caption = 'Fixed Real Estate No.';
            DataClassification = CustomerContent;
            TableRelation = "Fixed Real Estate"."No." where(Type = const(Activo));
        }
        field(8; "Contract Date"; Date)
        {
            Caption = 'Contract Date';
            DataClassification = CustomerContent;
        }
        field(9; "Starting Date"; Date)
        {
            Caption = 'Starting Date';
            DataClassification = CustomerContent;
        }
        field(10; "Expiration Date"; Date)
        {
            Caption = 'Expiration Date';
            DataClassification = CustomerContent;
        }
        field(11; "Invoice Period Text"; Text[30])
        {
            Caption = 'Invoice Period';
            DataClassification = CustomerContent;
        }
        field(12; "Annual Amount"; Decimal)
        {
            Caption = 'Annual Amount';
            DataClassification = CustomerContent;
        }
        field(13; "Payment Method Code"; Code[10])
        {
            Caption = 'Payment Method Code';
            DataClassification = CustomerContent;
            TableRelation = "Payment Method";
        }
        field(14; "Payment Terms Code"; Code[10])
        {
            Caption = 'Payment Terms Code';
            DataClassification = CustomerContent;
            TableRelation = "Payment Terms";
        }
        field(15; Status; Enum "OD AM Import Status")
        {
            Caption = 'Status';
            DataClassification = CustomerContent;
        }
        field(16; "Error Message"; Text[250])
        {
            Caption = 'Error Message';
            DataClassification = CustomerContent;
        }
        field(17; "Warning Message"; Text[250])
        {
            Caption = 'Warning Message';
            DataClassification = CustomerContent;
        }
        field(18; "Created Contract No."; Code[20])
        {
            Caption = 'Created Contract No.';
            DataClassification = CustomerContent;
        }
        field(19; Processed; Boolean)
        {
            Caption = 'Processed';
            DataClassification = CustomerContent;
        }
        field(20; "Processed At"; DateTime)
        {
            Caption = 'Processed At';
            DataClassification = CustomerContent;
        }
        field(21; "File Name"; Text[250])
        {
            Caption = 'File Name';
            DataClassification = CustomerContent;
        }
        field(22; "Contract Import Key"; Code[30])
        {
            Caption = 'Contract Import Key';
            DataClassification = CustomerContent;
        }
        field(23; "Line Type Text"; Text[30])
        {
            Caption = 'Line Type';
            DataClassification = CustomerContent;
        }
        field(24; "Line Account No."; Code[20])
        {
            Caption = 'No. Cuenta';
            DataClassification = CustomerContent;
        }
        field(25; "Line Description"; Text[50])
        {
            Caption = 'Descripcion';
            DataClassification = CustomerContent;
        }
        field(26; "Line Value"; Decimal)
        {
            Caption = 'Valor de linea';
            DataClassification = CustomerContent;
        }
        field(27; "Line Starting Date"; Date)
        {
            Caption = 'Line Starting Date';
            DataClassification = CustomerContent;
        }
        field(28; "Line Expiration Date"; Date)
        {
            Caption = 'Line Expiration Date';
            DataClassification = CustomerContent;
        }
        field(29; "Line Service Period Text"; Text[30])
        {
            Caption = 'Line Service Period';
            DataClassification = CustomerContent;
        }
        field(30; "Line VAT Bus. Posting Group"; Code[20])
        {
            Caption = 'Line VAT Bus. Posting Group';
            DataClassification = CustomerContent;
        }
        field(31; "Line VAT Prod. Posting Group"; Code[20])
        {
            Caption = 'Grupo registro IVA producto';
            DataClassification = CustomerContent;
        }
        field(32; "Line Shortcut Dim. 1 Code"; Code[20])
        {
            Caption = 'Line Shortcut Dimension 1 Code';
            DataClassification = CustomerContent;
        }
        field(33; "Line Shortcut Dim. 2 Code"; Code[20])
        {
            Caption = 'Line Shortcut Dimension 2 Code';
            DataClassification = CustomerContent;
        }
        field(34; "Line Apply Increments"; Boolean)
        {
            Caption = 'Line Apply Increments';
            DataClassification = CustomerContent;
        }
        field(35; "Line Apply Taxes"; Boolean)
        {
            Caption = 'Line Apply Taxes';
            DataClassification = CustomerContent;
        }
        field(36; "Line Base Contract"; Boolean)
        {
            Caption = 'Line Base Contract';
            DataClassification = CustomerContent;
        }
    }

    keys
    {
        key(PK; "Import Batch ID", "Excel Row No.")
        {
            Clustered = true;
        }
        key(ContractNo; "Import Batch ID", "Contract No.")
        {
        }
    }
}
