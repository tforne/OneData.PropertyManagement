table 96990 "OD AM Asset Import"
{
    Caption = 'OD AM Asset Import';
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
        field(3; "External Asset ID"; Code[50])
        {
            Caption = 'External Asset ID';
            DataClassification = CustomerContent;
        }
        field(4; "Parent External Asset ID"; Code[50])
        {
            Caption = 'Parent External Asset ID';
            DataClassification = CustomerContent;
        }
        field(5; "Property No."; Code[20])
        {
            Caption = 'Property No.';
            DataClassification = CustomerContent;
            TableRelation = "Fixed Real Estate"."No." where(Type = const(Propiedad));
        }
        field(6; "Parent Asset No."; Code[20])
        {
            Caption = 'Parent Asset No.';
            DataClassification = CustomerContent;
            TableRelation = "Fixed Real Estate"."No.";
        }
        field(7; Description; Text[100])
        {
            Caption = 'Description';
            DataClassification = CustomerContent;
        }
        field(8; "Asset Type Text"; Text[50])
        {
            Caption = 'Asset Type';
            DataClassification = CustomerContent;
        }
        field(9; "Resolved Asset Type"; Enum "OD Asset Type")
        {
            Caption = 'Resolved Asset Type';
            DataClassification = CustomerContent;
        }
        field(10; Status; Enum "OD AM Import Status")
        {
            Caption = 'Status';
            DataClassification = CustomerContent;
        }
        field(11; "Error Message"; Text[250])
        {
            Caption = 'Error Message';
            DataClassification = CustomerContent;
        }
        field(12; "Warning Message"; Text[250])
        {
            Caption = 'Warning Message';
            DataClassification = CustomerContent;
        }
        field(13; "Created Asset No."; Code[20])
        {
            Caption = 'Created Asset No.';
            DataClassification = CustomerContent;
        }
        field(14; Processed; Boolean)
        {
            Caption = 'Processed';
            DataClassification = CustomerContent;
        }
        field(15; "Processed At"; DateTime)
        {
            Caption = 'Processed At';
            DataClassification = CustomerContent;
        }
        field(16; "File Name"; Text[250])
        {
            Caption = 'File Name';
            DataClassification = CustomerContent;
        }
        field(17; "Parent Resolved No."; Code[20])
        {
            Caption = 'Parent Resolved No.';
            DataClassification = CustomerContent;
            TableRelation = "Fixed Real Estate"."No.";
        }
        field(18; "FA No."; Code[20])
        {
            Caption = 'FA No.';
            DataClassification = CustomerContent;
            TableRelation = "Fixed Asset"."No.";
        }
        field(19; "Main Property Line"; Boolean)
        {
            Caption = 'Main Property Line';
            DataClassification = CustomerContent;
        }
    }

    keys
    {
        key(PK; "Import Batch ID", "Excel Row No.")
        {
            Clustered = true;
        }
        key(ExternalAsset; "Import Batch ID", "External Asset ID")
        {
        }
    }
}
