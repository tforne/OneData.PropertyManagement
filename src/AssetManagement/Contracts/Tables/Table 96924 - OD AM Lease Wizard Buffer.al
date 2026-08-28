table 96924 "OD AM Lease Wizard Buffer"
{
    Caption = 'Lease Contract Wizard Buffer';
    DataClassification = ToBeClassified;

    fields
    {
        field(1; "Wizard Id"; Guid)
        {
            Caption = 'Wizard Id';
        }
        field(10; "Fixed Real Estate No."; Code[20])
        {
            Caption = 'Fixed Real Estate No.';
            TableRelation = "Fixed Real Estate"."No.";

            trigger OnValidate()
            var
                FixedRealEstate: Record "Fixed Real Estate";
            begin
                if "Fixed Real Estate No." = '' then
                    exit;

                FixedRealEstate.Get("Fixed Real Estate No.");
                "Fixed Real Estate Description" := CopyStr(FixedRealEstate.Description, 1, MaxStrLen("Fixed Real Estate Description"));
                "Fixed Real Estate Type" := FixedRealEstate.Type;
                "OD Asset Type" := FixedRealEstate."OD Asset Type";
                "Property No." := FixedRealEstate."Property No.";
                "Property Description" := CopyStr(FixedRealEstate."Property Description", 1, MaxStrLen("Property Description"));
            end;
        }
        field(20; "Fixed Real Estate Description"; Text[100])
        {
            Caption = 'Asset Description';
        }
        field(30; "Fixed Real Estate Type"; Option)
        {
            Caption = 'Fixed Real Estate Type';
            OptionCaption = ' ,Propiedad,Activo';
            OptionMembers = " ",Propiedad,Activo;
        }
        field(40; "OD Asset Type"; Enum "OD Asset Type")
        {
            Caption = 'Asset Type';
        }
        field(50; "Property No."; Code[20])
        {
            Caption = 'Property No.';
        }
        field(60; "Property Description"; Text[100])
        {
            Caption = 'Property Description';
        }
        field(100; Description; Text[80])
        {
            Caption = 'Description';
        }
        field(110; "Customer No."; Code[20])
        {
            Caption = 'Customer No.';
            TableRelation = Customer;

            trigger OnValidate()
            var
                Customer: Record Customer;
            begin
                if "Customer No." = '' then begin
                    Clear("Customer Name");
                    exit;
                end;

                Customer.Get("Customer No.");
                "Customer Name" := CopyStr(Customer.Name, 1, MaxStrLen("Customer Name"));
            end;
        }
        field(120; "Customer Name"; Text[100])
        {
            Caption = 'Customer Name';
            Editable = false;
        }
        field(130; "Starting Date"; Date)
        {
            Caption = 'Starting Date';
        }
        field(140; "Ending Date"; Date)
        {
            Caption = 'Ending Date';
        }
        field(150; "Contract Date"; Date)
        {
            Caption = 'Contract Date';
        }
        field(160; Status; Option)
        {
            Caption = 'Status';
            OptionCaption = ' ,Signed';
            OptionMembers = " ",Signed;
        }
        field(170; "Invoice Period"; Option)
        {
            Caption = 'Invoice Period';
            OptionCaption = 'Month,Two Months,Quarter,Half Year,Year,None';
            OptionMembers = Month,"Two Months",Quarter,"Half Year",Year,"None";
        }
        field(180; "Payment Method Code"; Code[10])
        {
            Caption = 'Payment Method Code';
            TableRelation = "Payment Method";
        }
        field(190; "Payment Terms Code"; Code[10])
        {
            Caption = 'Payment Terms Code';
            TableRelation = "Payment Terms";
        }
        field(200; "Created Contract No."; Code[20])
        {
            Caption = 'Created Contract No.';
        }
    }

    keys
    {
        key(PK; "Wizard Id")
        {
            Clustered = true;
        }
    }
}
