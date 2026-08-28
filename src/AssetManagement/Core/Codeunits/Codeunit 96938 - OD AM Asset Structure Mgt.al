codeunit 96938 "OD AM Asset Structure Mgt."
{
    var
        PropertySortPrefixTok: Label '0000|', Locked = true;
        AssetSortPrefixTok: Label '0001|', Locked = true;
        SortSeparatorTok: Label '|', Locked = true;
        ParentSelfReferenceErr: Label 'El activo %1 no puede ser padre de si mismo.';
        ParentDifferentPropertyErr: Label 'El activo padre %1 debe pertenecer a la misma propiedad raiz que %2.';
        ParentCycleErr: Label 'No se puede crear un ciclo en la jerarquia de activos.';
        PropertyCannotHaveParentErr: Label 'Una propiedad no puede tener activo padre.';
        PropertyNotFoundErr: Label 'No se ha encontrado la propiedad raiz para el registro %1.';
        SelectionRequiredErr: Label 'Debe seleccionar una propiedad o activo valido.';

    procedure ValidateParentAsset(var FixedRealEstate: Record "Fixed Real Estate")
    var
        ParentFixedRealEstate: Record "Fixed Real Estate";
        RootPropertyNo: Code[20];
        RootProperty: Record "Fixed Real Estate";
    begin
        if FixedRealEstate."OD Parent FRE No." = '' then begin
            if FixedRealEstate.Type = FixedRealEstate.Type::Propiedad then
                FixedRealEstate."OD Parent FRE No." := '';
            exit;
        end;

        if FixedRealEstate.Type = FixedRealEstate.Type::Propiedad then
            Error(PropertyCannotHaveParentErr);

        if FixedRealEstate."OD Parent FRE No." = FixedRealEstate."No." then
            Error(ParentSelfReferenceErr, FixedRealEstate."No.");

        ParentFixedRealEstate.Get(FixedRealEstate."OD Parent FRE No.");

        if IsDescendant(FixedRealEstate."No.", ParentFixedRealEstate."No.") then
            Error(ParentCycleErr);

        RootPropertyNo := GetRootProperty(ParentFixedRealEstate."No.");
        if RootPropertyNo = '' then
            Error(PropertyNotFoundErr, ParentFixedRealEstate."No.");

        if (FixedRealEstate."Property No." <> '') and (FixedRealEstate."Property No." <> RootPropertyNo) then
            Error(ParentDifferentPropertyErr, ParentFixedRealEstate."No.", FixedRealEstate."No.");

        if FixedRealEstate."Property No." = '' then begin
            FixedRealEstate."Property No." := RootPropertyNo;
            if RootProperty.Get(RootPropertyNo) then
                FixedRealEstate.InheritPropertyToFREData(RootProperty);
        end;
    end;

    procedure GetRootProperty(FixedRealEstateNo: Code[20]): Code[20]
    var
        CurrentFixedRealEstate: Record "Fixed Real Estate";
        HopGuard: Integer;
    begin
        if FixedRealEstateNo = '' then
            exit('');

        if not CurrentFixedRealEstate.Get(FixedRealEstateNo) then
            exit('');

        if CurrentFixedRealEstate.Type = CurrentFixedRealEstate.Type::Propiedad then
            exit(CurrentFixedRealEstate."No.");

        if CurrentFixedRealEstate."Property No." <> '' then
            exit(CurrentFixedRealEstate."Property No.");

        while CurrentFixedRealEstate."OD Parent FRE No." <> '' do begin
            HopGuard += 1;
            if HopGuard > 100 then
                exit('');

            if not CurrentFixedRealEstate.Get(CurrentFixedRealEstate."OD Parent FRE No.") then
                exit('');

            if CurrentFixedRealEstate.Type = CurrentFixedRealEstate.Type::Propiedad then
                exit(CurrentFixedRealEstate."No.");

            if CurrentFixedRealEstate."Property No." <> '' then
                exit(CurrentFixedRealEstate."Property No.");
        end;

        exit('');
    end;

    procedure IsDescendant(ParentNo: Code[20]; PossibleChildNo: Code[20]): Boolean
    var
        CurrentFixedRealEstate: Record "Fixed Real Estate";
        HopGuard: Integer;
    begin
        if (ParentNo = '') or (PossibleChildNo = '') then
            exit(false);

        if ParentNo = PossibleChildNo then
            exit(true);

        if not CurrentFixedRealEstate.Get(PossibleChildNo) then
            exit(false);

        while CurrentFixedRealEstate."OD Parent FRE No." <> '' do begin
            HopGuard += 1;
            if HopGuard > 100 then
                exit(false);

            if CurrentFixedRealEstate."OD Parent FRE No." = ParentNo then
                exit(true);

            if not CurrentFixedRealEstate.Get(CurrentFixedRealEstate."OD Parent FRE No.") then
                exit(false);
        end;

        exit(false);
    end;

    procedure GetHierarchyLevel(FixedRealEstateNo: Code[20]): Integer
    var
        CurrentFixedRealEstate: Record "Fixed Real Estate";
        Level: Integer;
        HopGuard: Integer;
    begin
        if (FixedRealEstateNo = '') or (not CurrentFixedRealEstate.Get(FixedRealEstateNo)) then
            exit(0);

        if CurrentFixedRealEstate.Type = CurrentFixedRealEstate.Type::Propiedad then
            exit(0);

        if CurrentFixedRealEstate."OD Parent FRE No." = '' then
            exit(1);

        while CurrentFixedRealEstate."OD Parent FRE No." <> '' do begin
            HopGuard += 1;
            if HopGuard > 100 then
                exit(Level);

            Level += 1;
            if not CurrentFixedRealEstate.Get(CurrentFixedRealEstate."OD Parent FRE No.") then
                exit(Level);
        end;

        exit(Level);
    end;

    procedure CreateChildAsset(ParentFixedRealEstate: Record "Fixed Real Estate"; AssetType: Enum "OD Asset Type"): Code[20]
    var
        NewFixedRealEstate: Record "Fixed Real Estate";
        RootPropertyNo: Code[20];
        RootProperty: Record "Fixed Real Estate";
    begin
        if ParentFixedRealEstate."No." = '' then
            Error(SelectionRequiredErr);

        if ParentFixedRealEstate.Type = ParentFixedRealEstate.Type::Propiedad then
            RootPropertyNo := ParentFixedRealEstate."No."
        else
            RootPropertyNo := GetRootProperty(ParentFixedRealEstate."No.");

        if RootPropertyNo = '' then
            Error(PropertyNotFoundErr, ParentFixedRealEstate."No.");

        RootProperty.Get(RootPropertyNo);

        NewFixedRealEstate.Init();
        NewFixedRealEstate.Validate(Type, NewFixedRealEstate.Type::Activo);
        NewFixedRealEstate.Validate("Property No.", RootPropertyNo);
        NewFixedRealEstate."OD Parent FRE No." := ParentFixedRealEstate."No.";
        NewFixedRealEstate."OD Asset Type" := AssetType;
        NewFixedRealEstate.Acquired := true;
        NewFixedRealEstate.Managed := true;
        NewFixedRealEstate.InheritPropertyToFREData(RootProperty);
        NewFixedRealEstate.Insert(true);
        ValidateParentAsset(NewFixedRealEstate);
        NewFixedRealEstate.Modify(true);

        exit(NewFixedRealEstate."No.");
    end;

    procedure BuildHierarchySortKey(FixedRealEstate: Record "Fixed Real Estate"): Text[250]
    var
        ParentFixedRealEstate: Record "Fixed Real Estate";
        RootProperty: Record "Fixed Real Estate";
        ParentSortKey: Text;
        LineSortToken: Text;
        RootPropertyNo: Code[20];
    begin
        LineSortToken := BuildSortToken(FixedRealEstate);

        if FixedRealEstate.Type = FixedRealEstate.Type::Propiedad then
            exit(CopyStr(PropertySortPrefixTok + LineSortToken, 1, 250));

        if FixedRealEstate."OD Parent FRE No." <> '' then
            if ParentFixedRealEstate.Get(FixedRealEstate."OD Parent FRE No.") then begin
                ParentSortKey := ParentFixedRealEstate."OD Hierarchy Sort Key";
                if ParentSortKey = '' then
                    ParentSortKey := BuildHierarchySortKey(ParentFixedRealEstate);

                exit(CopyStr(ParentSortKey + SortSeparatorTok + AssetSortPrefixTok + LineSortToken, 1, 250));
            end;

        RootPropertyNo := GetLinePropertyNo(FixedRealEstate);
        if (RootPropertyNo <> '') and RootProperty.Get(RootPropertyNo) then begin
            ParentSortKey := RootProperty."OD Hierarchy Sort Key";
            if ParentSortKey = '' then
                ParentSortKey := BuildHierarchySortKey(RootProperty);

            exit(CopyStr(ParentSortKey + SortSeparatorTok + AssetSortPrefixTok + LineSortToken, 1, 250));
        end;

        exit(CopyStr(AssetSortPrefixTok + LineSortToken, 1, 250));
    end;

    procedure RefreshHierarchySortKeysForRecord(FixedRealEstate: Record "Fixed Real Estate")
    begin
        if FixedRealEstate."No." = '' then
            exit;

        if FixedRealEstate.Type = FixedRealEstate.Type::Propiedad then begin
            RefreshChildHierarchy(FixedRealEstate, FixedRealEstate."No.");
            exit;
        end;

        RefreshChildHierarchy(FixedRealEstate, GetLinePropertyNo(FixedRealEstate));
    end;

    procedure BuildAssetStructureBuffer(var TempAssetStructureBuffer: Record "OD AM Asset Structure Buffer" temporary; PropertyNo: Code[20])
    var
        PropertyFixedRealEstate: Record "Fixed Real Estate";
        EntryNo: Integer;
        DisplayOrder: Integer;
    begin
        TempAssetStructureBuffer.Reset();
        TempAssetStructureBuffer.DeleteAll();

        if PropertyNo <> '' then begin
            if not PropertyFixedRealEstate.Get(PropertyNo) then
                exit;

            BuildPropertyBranch(TempAssetStructureBuffer, PropertyFixedRealEstate, EntryNo, DisplayOrder);
            exit;
        end;

        PropertyFixedRealEstate.SetRange(Type, PropertyFixedRealEstate.Type::Propiedad);
        if PropertyFixedRealEstate.FindSet() then
            repeat
                BuildPropertyBranch(TempAssetStructureBuffer, PropertyFixedRealEstate, EntryNo, DisplayOrder);
            until PropertyFixedRealEstate.Next() = 0;
    end;

    local procedure BuildPropertyBranch(var TempAssetStructureBuffer: Record "OD AM Asset Structure Buffer" temporary; PropertyFixedRealEstate: Record "Fixed Real Estate"; var EntryNo: Integer; var DisplayOrder: Integer)
    begin
        AddBufferLine(TempAssetStructureBuffer, PropertyFixedRealEstate, 0, EntryNo, DisplayOrder);
        AddChildrenToBuffer(TempAssetStructureBuffer, PropertyFixedRealEstate, PropertyFixedRealEstate."No.", 1, EntryNo, DisplayOrder);
    end;

    local procedure AddChildrenToBuffer(var TempAssetStructureBuffer: Record "OD AM Asset Structure Buffer" temporary; ParentFixedRealEstate: Record "Fixed Real Estate"; PropertyNo: Code[20]; Level: Integer; var EntryNo: Integer; var DisplayOrder: Integer)
    var
        ChildFixedRealEstate: Record "Fixed Real Estate";
    begin
        ChildFixedRealEstate.Reset();
        ChildFixedRealEstate.SetCurrentKey("Property Description", "Property No.", Type, Description);
        ChildFixedRealEstate.SetRange(Type, ChildFixedRealEstate.Type::Activo);
        ChildFixedRealEstate.SetRange("Property No.", PropertyNo);

        if ParentFixedRealEstate.Type = ParentFixedRealEstate.Type::Propiedad then
            ChildFixedRealEstate.SetFilter("OD Parent FRE No.", '%1|%2', '', ParentFixedRealEstate."No.")
        else
            ChildFixedRealEstate.SetRange("OD Parent FRE No.", ParentFixedRealEstate."No.");

        if ChildFixedRealEstate.FindSet() then
            repeat
                AddBufferLine(TempAssetStructureBuffer, ChildFixedRealEstate, Level, EntryNo, DisplayOrder);
                AddChildrenToBuffer(TempAssetStructureBuffer, ChildFixedRealEstate, PropertyNo, Level + 1, EntryNo, DisplayOrder);
            until ChildFixedRealEstate.Next() = 0;
    end;

    local procedure AddBufferLine(var TempAssetStructureBuffer: Record "OD AM Asset Structure Buffer" temporary; FixedRealEstate: Record "Fixed Real Estate"; Level: Integer; var EntryNo: Integer; var DisplayOrder: Integer)
    begin
        EntryNo += 1;
        DisplayOrder += 1;

        TempAssetStructureBuffer.Init();
        TempAssetStructureBuffer."Entry No." := EntryNo;
        TempAssetStructureBuffer."Fixed Real Estate No." := FixedRealEstate."No.";
        TempAssetStructureBuffer."Property No." := GetLinePropertyNo(FixedRealEstate);
        TempAssetStructureBuffer."Parent FRE No." := FixedRealEstate."OD Parent FRE No.";
        TempAssetStructureBuffer.Description := CopyStr(FixedRealEstate.Description, 1, MaxStrLen(TempAssetStructureBuffer.Description));
        TempAssetStructureBuffer."Asset Type" := FixedRealEstate."OD Asset Type";
        TempAssetStructureBuffer."Hierarchy Level" := Level;
        TempAssetStructureBuffer."Display Order" := DisplayOrder;
        TempAssetStructureBuffer."Display Description" := BuildDisplayDescription(FixedRealEstate, Level);
        TempAssetStructureBuffer."Has Children" := HasChildren(FixedRealEstate);
        TempAssetStructureBuffer."Is Property" := FixedRealEstate.Type = FixedRealEstate.Type::Propiedad;
        TempAssetStructureBuffer.Status := CopyStr(Format(FixedRealEstate.Status), 1, MaxStrLen(TempAssetStructureBuffer.Status));
        TempAssetStructureBuffer."Rental Price" := FixedRealEstate."Last Rental Price";
        TempAssetStructureBuffer.Insert();
    end;

    local procedure BuildDisplayDescription(FixedRealEstate: Record "Fixed Real Estate"; Level: Integer): Text[250]
    var
        DisplayDescription: Text;
        IndentUnit: Text[3];
        Index: Integer;
    begin
        IndentUnit := '  ';
        for Index := 1 to Level do
            DisplayDescription += IndentUnit;

        if Level > 0 then
            DisplayDescription += '> ';

        DisplayDescription += FixedRealEstate."No.";
        if FixedRealEstate.Description <> '' then
            DisplayDescription += ' ' + FixedRealEstate.Description;

        exit(CopyStr(DisplayDescription, 1, 250));
    end;

    local procedure HasChildren(FixedRealEstate: Record "Fixed Real Estate"): Boolean
    var
        ChildFixedRealEstate: Record "Fixed Real Estate";
    begin
        if FixedRealEstate.Type = FixedRealEstate.Type::Propiedad then begin
            ChildFixedRealEstate.SetRange(Type, ChildFixedRealEstate.Type::Activo);
            ChildFixedRealEstate.SetRange("Property No.", FixedRealEstate."No.");
            ChildFixedRealEstate.SetFilter("OD Parent FRE No.", '%1|%2', '', FixedRealEstate."No.");
            exit(ChildFixedRealEstate.FindFirst());
        end;

        ChildFixedRealEstate.SetRange("OD Parent FRE No.", FixedRealEstate."No.");
        exit(ChildFixedRealEstate.FindFirst());
    end;

    local procedure GetLinePropertyNo(FixedRealEstate: Record "Fixed Real Estate"): Code[20]
    begin
        if FixedRealEstate.Type = FixedRealEstate.Type::Propiedad then
            exit(FixedRealEstate."No.");

        if FixedRealEstate."Property No." <> '' then
            exit(FixedRealEstate."Property No.");

        exit(GetRootProperty(FixedRealEstate."No."));
    end;

    local procedure RefreshChildHierarchy(ParentFixedRealEstate: Record "Fixed Real Estate"; PropertyNo: Code[20])
    var
        ChildFixedRealEstate: Record "Fixed Real Estate";
    begin
        if PropertyNo = '' then
            exit;

        ChildFixedRealEstate.Reset();
        ChildFixedRealEstate.SetRange(Type, ChildFixedRealEstate.Type::Activo);
        ChildFixedRealEstate.SetRange("Property No.", PropertyNo);

        if ParentFixedRealEstate.Type = ParentFixedRealEstate.Type::Propiedad then
            ChildFixedRealEstate.SetFilter("OD Parent FRE No.", '%1|%2', '', ParentFixedRealEstate."No.")
        else
            ChildFixedRealEstate.SetRange("OD Parent FRE No.", ParentFixedRealEstate."No.");

        if ChildFixedRealEstate.FindSet() then
            repeat
                UpdateRecordHierarchySortKey(ChildFixedRealEstate);
                RefreshChildHierarchy(ChildFixedRealEstate, PropertyNo);
            until ChildFixedRealEstate.Next() = 0;
    end;

    local procedure UpdateRecordHierarchySortKey(var FixedRealEstate: Record "Fixed Real Estate")
    var
        NewHierarchySortKey: Text[250];
    begin
        NewHierarchySortKey := CopyStr(BuildHierarchySortKey(FixedRealEstate), 1, MaxStrLen(FixedRealEstate."OD Hierarchy Sort Key"));
        if FixedRealEstate."OD Hierarchy Sort Key" = NewHierarchySortKey then
            exit;

        FixedRealEstate."OD Hierarchy Sort Key" := NewHierarchySortKey;
        FixedRealEstate.Modify(false);
    end;

    local procedure BuildSortToken(FixedRealEstate: Record "Fixed Real Estate"): Text
    var
        SortToken: Text;
    begin
        SortToken := FixedRealEstate.Description;
        if SortToken = '' then
            SortToken := FixedRealEstate."No."
        else
            SortToken += SortSeparatorTok + FixedRealEstate."No.";

        exit(ConvertStr(UpperCase(SortToken), 'ÁÀÄÂÉÈËÊÍÌÏÎÓÒÖÔÚÙÜÛÑÇ', 'AAAAEEEEIIIIOOOOUUUUNC'));
    end;
}
