table 96946 "OD AM Lease Contract Unit"
{
    Caption = 'Activos del contrato';
    DataClassification = ToBeClassified;

    fields
    {
        field(1; "Contract No."; Code[20])
        {
            Caption = 'Contract No.';
            TableRelation = "Lease Contract"."Contract No.";

            trigger OnValidate()
            begin
                ApplyContractDefaults();
            end;
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
            begin
                LoadFixedRealEstateData();
            end;
        }
        field(20; "Property No."; Code[20])
        {
            Caption = 'Property No.';
            TableRelation = "Fixed Real Estate"."No." where(Type = const(Propiedad));
        }
        field(30; "Parent FRE No."; Code[20])
        {
            Caption = 'Parent FRE No.';
            TableRelation = "Fixed Real Estate"."No.";
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

            trigger OnValidate()
            var
                OccupancyMgt: Codeunit "OD AM Occupancy Mgt.";
            begin
                OccupancyMgt.ValidatePeriod("Starting Date", "Ending Date");
                UpdateActiveState();
            end;
        }
        field(70; "Ending Date"; Date)
        {
            Caption = 'Ending Date';

            trigger OnValidate()
            var
                OccupancyMgt: Codeunit "OD AM Occupancy Mgt.";
            begin
                OccupancyMgt.ValidatePeriod("Starting Date", "Ending Date");
                UpdateActiveState();
            end;
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
        key(PK; "Contract No.", "Line No.")
        {
            Clustered = true;
        }
        key(FixedRealEstateDates; "Fixed Real Estate No.", "Starting Date", "Ending Date")
        {
        }
        key(PropertyContract; "Property No.", "Contract No.")
        {
        }
        key(PropertyAssetDates; "Property No.", "Fixed Real Estate No.", "Starting Date", "Ending Date", "Contract No.")
        {
        }
    }

    trigger OnInsert()
    var
        ContractAssetMgt: Codeunit "OD AM Contract Asset Mgt.";
    begin
        if "Line No." = 0 then
            "Line No." := GetNextLineNo();

        ApplyContractDefaults();
        UpdateActiveState();
        ContractAssetMgt.ValidateContractUnit(Rec);
    end;

    trigger OnModify()
    var
        ContractAssetMgt: Codeunit "OD AM Contract Asset Mgt.";
    begin
        ApplyContractDefaults();
        UpdateActiveState();
        ContractAssetMgt.ValidateContractUnit(Rec);
    end;

    procedure IsActiveOnDate(DateToCheck: Date): Boolean
    begin
        if ("Starting Date" <> 0D) and ("Starting Date" > DateToCheck) then
            exit(false);

        if ("Ending Date" <> 0D) and ("Ending Date" < DateToCheck) then
            exit(false);

        exit(true);
    end;

    local procedure ApplyContractDefaults()
    var
        LeaseContract: Record "Lease Contract";
    begin
        if "Contract No." = '' then
            exit;

        if not LeaseContract.Get("Contract No.") then
            exit;

        if "Starting Date" = 0D then
            "Starting Date" := LeaseContract."Starting Date";

        if "Ending Date" = 0D then
            "Ending Date" := LeaseContract."Expiration Date";
    end;

    local procedure LoadFixedRealEstateData()
    var
        FixedRealEstate: Record "Fixed Real Estate";
        AssetStructureMgt: Codeunit "OD AM Asset Structure Mgt.";
    begin
        if "Fixed Real Estate No." = '' then begin
            Clear("Property No.");
            Clear("Parent FRE No.");
            "Asset Type" := "Asset Type"::Undefined;
            Clear(Description);
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
    end;

    local procedure UpdateActiveState()
    begin
        Active := IsActiveOnDate(WorkDate());
    end;

    local procedure GetNextLineNo(): Integer
    var
        ContractUnit: Record "OD AM Lease Contract Unit";
    begin
        if "Contract No." = '' then
            exit(10000);

        ContractUnit.SetRange("Contract No.", "Contract No.");
        if ContractUnit.FindLast() then
            exit(ContractUnit."Line No." + 10000);

        exit(10000);
    end;
}
