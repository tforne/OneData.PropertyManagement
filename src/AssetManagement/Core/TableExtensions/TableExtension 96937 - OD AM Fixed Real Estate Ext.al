tableextension 96937 "OD AM Fixed Real Estate Ext" extends "Fixed Real Estate"
{
    fields
    {
        field(96936; "OD Asset Type"; Enum "OD Asset Type")
        {
            Caption = 'Tipo de activo';
            DataClassification = ToBeClassified;
        }
        field(96937; "OD Parent FRE No."; Code[20])
        {
            Caption = 'Activo padre';
            DataClassification = ToBeClassified;
            TableRelation = "Fixed Real Estate"."No.";

            trigger OnValidate()
            var
                AssetStructureMgt: Codeunit "OD AM Asset Structure Mgt.";
            begin
                AssetStructureMgt.ValidateParentAsset(Rec);
            end;
        }
        field(96938; "OD Hierarchy Sort Key"; Text[250])
        {
            Caption = 'Clave orden jerarquico';
            DataClassification = SystemMetadata;
            Editable = false;
        }
    }

    trigger OnBeforeInsert()
    begin
        EnsureAssetManagementConsistency();
        UpdateHierarchySortKey();
    end;

    trigger OnBeforeModify()
    begin
        EnsureAssetManagementConsistency();
        UpdateHierarchySortKey();
    end;

    trigger OnAfterInsert()
    var
        AssetStructureMgt: Codeunit "OD AM Asset Structure Mgt.";
    begin
        AssetStructureMgt.RefreshHierarchySortKeysForRecord(Rec);
    end;

    trigger OnAfterModify()
    var
        AssetStructureMgt: Codeunit "OD AM Asset Structure Mgt.";
    begin
        AssetStructureMgt.RefreshHierarchySortKeysForRecord(Rec);
    end;

    local procedure EnsureAssetManagementConsistency()
    var
        AssetStructureMgt: Codeunit "OD AM Asset Structure Mgt.";
        ParentRootPropertyNo: Code[20];
    begin
        if Rec.Type = Rec.Type::Propiedad then begin
            Rec."OD Parent FRE No." := '';
            Rec."OD Asset Type" := Rec."OD Asset Type"::Undefined;
            exit;
        end;

        if Rec."OD Parent FRE No." <> '' then begin
            ParentRootPropertyNo := AssetStructureMgt.GetRootProperty(Rec."OD Parent FRE No.");
            if (Rec."Property No." <> '') and (ParentRootPropertyNo <> '') and (Rec."Property No." <> ParentRootPropertyNo) then
                Rec."OD Parent FRE No." := ''
            else
                AssetStructureMgt.ValidateParentAsset(Rec);
        end;

        if (Rec."Property No." <> '') and (Rec."OD Parent FRE No." = '') then
            UpdateInheritedPropertyData();
    end;

    local procedure UpdateInheritedPropertyData()
    var
        PropertyFixedRealEstate: Record "Fixed Real Estate";
    begin
        if PropertyFixedRealEstate.Get(Rec."Property No.") then
            Rec.InheritPropertyToFREData(PropertyFixedRealEstate)
        else
            Clear(Rec."Property Description");
    end;

    local procedure UpdateHierarchySortKey()
    var
        AssetStructureMgt: Codeunit "OD AM Asset Structure Mgt.";
    begin
        Rec."OD Hierarchy Sort Key" := AssetStructureMgt.BuildHierarchySortKey(Rec);
    end;
}
