table 96925 "OD AM Lease Wizard Unit"
{
    Caption = 'Lease Contract Wizard Unit';
    DataClassification = ToBeClassified;

    fields
    {
        field(1; "Wizard Id"; Guid)
        {
            Caption = 'Wizard Id';
        }
        field(2; "Line No."; Integer)
        {
            Caption = 'Line No.';
        }
        field(10; "Fixed Real Estate No."; Code[20])
        {
            Caption = 'Fixed Real Estate No.';
            TableRelation = "Fixed Real Estate"."No." where(Type = const(Activo));

            trigger OnValidate()
            var
                FixedRealEstate: Record "Fixed Real Estate";
                AssetStructureMgt: Codeunit "OD AM Asset Structure Mgt.";
            begin
                if "Fixed Real Estate No." = '' then begin
                    Clear("Property No.");
                    Clear("Parent FRE No.");
                    "Asset Type" := "Asset Type"::Undefined;
                    Clear(Description);
                    Clear("Monthly Rent");
                    Clear("Annual Rent");
                    exit;
                end;

                FixedRealEstate.Get("Fixed Real Estate No.");
                FixedRealEstate.TestField(Type, FixedRealEstate.Type::Activo);

                "Property No." := FixedRealEstate."Property No.";
                if "Property No." = '' then
                    "Property No." := AssetStructureMgt.GetRootProperty(FixedRealEstate."No.");

                "Parent FRE No." := FixedRealEstate."OD Parent FRE No.";
                "Asset Type" := FixedRealEstate."OD Asset Type";
                Description := CopyStr(FixedRealEstate.Description, 1, MaxStrLen(Description));
                Validate("Monthly Rent", FixedRealEstate."Last Rental Price");
            end;
        }
        field(20; "Property No."; Code[20])
        {
            Caption = 'Property No.';
        }
        field(30; "Parent FRE No."; Code[20])
        {
            Caption = 'Parent FRE No.';
        }
        field(40; "Asset Type"; Enum "OD Asset Type")
        {
            Caption = 'Asset Type';
        }
        field(50; Role; Enum "OD Contract Unit Role")
        {
            Caption = 'Role';
        }
        field(60; "Starting Date"; Date)
        {
            Caption = 'Starting Date';
        }
        field(70; "Ending Date"; Date)
        {
            Caption = 'Ending Date';
        }
        field(80; Active; Boolean)
        {
            Caption = 'Active';
        }
        field(90; Description; Text[100])
        {
            Caption = 'Description';
        }
        field(100; "Monthly Rent"; Decimal)
        {
            Caption = 'Monthly Rent';

            trigger OnValidate()
            begin
                "Annual Rent" := "Monthly Rent" * 12;
            end;
        }
        field(110; "Annual Rent"; Decimal)
        {
            Caption = 'Annual Rent';
            Editable = false;
        }
    }

    keys
    {
        key(PK; "Wizard Id", "Line No.")
        {
            Clustered = true;
        }
    }

    trigger OnInsert()
    begin
        if "Line No." = 0 then
            "Line No." := GetNextLineNo();

        UpdateActiveState();
    end;

    trigger OnModify()
    begin
        UpdateActiveState();
    end;

    local procedure GetNextLineNo(): Integer
    var
        WizardUnit: Record "OD AM Lease Wizard Unit";
    begin
        WizardUnit.SetRange("Wizard Id", "Wizard Id");
        if WizardUnit.FindLast() then
            exit(WizardUnit."Line No." + 10000);

        exit(10000);
    end;

    local procedure UpdateActiveState()
    begin
        Active := true;

        if ("Starting Date" <> 0D) and ("Starting Date" > WorkDate()) then
            Active := false;

        if ("Ending Date" <> 0D) and ("Ending Date" < WorkDate()) then
            Active := false;
    end;
}
