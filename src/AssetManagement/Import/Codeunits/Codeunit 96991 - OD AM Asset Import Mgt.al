codeunit 96991 "OD AM Asset Import Mgt."
{
    var
        AssetStructureMgt: Codeunit "OD AM Asset Structure Mgt.";
        SelectExcelLbl: Label 'Seleccione el Excel con la estructura de activos.';
        InvalidExcelLbl: Label 'No se ha podido abrir el Excel. %1';
        MissingColumnLbl: Label 'Falta la columna obligatoria %1.';
        DuplicateColumnLbl: Label 'La columna %1 esta duplicada en la cabecera.';
        UnknownColumnLbl: Label 'La columna %1 no esta soportada por esta importacion.';
        NoBatchLbl: Label 'No existen lineas para el lote %1.';
        ImportFinishedLbl: Label 'Se ha importado el lote %1 con %2 lineas.';
        ValidateFinishedLbl: Label 'Se han validado %1 lineas: %2 validas, %3 con aviso y %4 con error.';
        ProcessFinishedLbl: Label 'Se han procesado %1 lineas y se han creado %2 activos.';
        DeleteFinishedLbl: Label 'Se ha eliminado el lote %1.';
        InvalidPropertyLbl: Label 'La propiedad %1 no existe o no es una propiedad raiz.';
        MissingPropertyLbl: Label 'La propiedad es obligatoria.';
        MissingDescriptionLbl: Label 'La descripcion es obligatoria.';
        MissingAssetTypeLbl: Label 'El tipo de activo es obligatorio.';
        InvalidAssetTypeLbl: Label 'El tipo de activo %1 no es valido.';
        DuplicateExternalIdLbl: Label 'El identificador externo %1 esta duplicado en el lote.';
        ParentReferenceConflictLbl: Label 'No puede informar Activo padre y ID externo padre al mismo tiempo.';
        ParentExternalNotFoundLbl: Label 'No existe la linea padre con ID externo %1 dentro del mismo lote.';
        ParentAssetNotFoundLbl: Label 'El activo padre %1 no existe.';
        ParentPropertyMismatchLbl: Label 'El padre %1 no pertenece a la propiedad %2.';
        ParentCreatedMissingLbl: Label 'La linea padre %1 todavia no ha generado el activo. Revise el orden del Excel.';
        SelfParentLbl: Label 'La linea no puede referenciarse a si misma como padre.';
        RoomParentWarningLbl: Label 'Las habitaciones suelen colgar de una vivienda. Revise el padre informado.';
        TemplateFileNameLbl: Label 'OD_Asset_Structure_Import_Template';
        FixedAssetBatchLbl: Label 'Generado desde activos fijos';
        LeaseContractBatchLbl: Label 'Generado desde importacion de contratos';
        FixedAssetNotFoundLbl: Label 'El activo fijo %1 no existe.';
        FixedAssetLinkExistsLbl: Label 'El activo fijo %1 ya tiene un activo inmobiliario activo vinculado.';
        DuplicateFANoLbl: Label 'El activo fijo %1 esta duplicado en el lote.';
        GeneratedBatchLbl: Label 'Se ha generado el lote %1 desde %2 activos fijos.';
        GeneratedFromLeaseImportBatchLbl: Label 'Se ha generado el lote %1 desde %2 activos faltantes del lote de contratos %3.';
        NoMissingLeaseAssetsLbl: Label 'Todas las lineas del lote %1 ya tienen activo inmobiliario existente o no informan activo.';
        MainPropertyCreateErrLbl: Label '[CREAR PROPIEDAD] No se ha podido crear la propiedad principal desde el activo fijo %1.';
        MainPropertyLinkErrLbl: Label '[VINCULAR PROPIEDAD] Se ha creado la propiedad principal %1, pero no se ha podido vincular con el activo fijo %2.';
        MainPropertyChildCreateErrLbl: Label '[CREAR HIJO] Se ha creado la propiedad principal %1, pero no se ha podido crear el activo dependiente para el activo fijo %2.';
        MainPropertyChildLinkErrLbl: Label '[VINCULAR HIJO] Se han creado la propiedad principal %1 y el activo dependiente %2, pero no se ha podido vincular con el activo fijo %3.';

    procedure DownloadTemplate()
    var
        TempExcelBuffer: Record "Excel Buffer" temporary;
        TempBlob: Codeunit "Temp Blob";
        FileOutStream: OutStream;
        FileInStream: InStream;
        DownloadFileName: Text;
    begin
        TempExcelBuffer.NewRow();
        AddHeader(TempExcelBuffer, 'External Asset ID');
        AddHeader(TempExcelBuffer, 'Parent External Asset ID');
        AddHeader(TempExcelBuffer, 'FA No.');
        AddHeader(TempExcelBuffer, 'Property No.');
        AddHeader(TempExcelBuffer, 'Parent Asset No.');
        AddHeader(TempExcelBuffer, 'Description');
        AddHeader(TempExcelBuffer, 'Asset Type');
        AddSampleRow(TempExcelBuffer, 'VIV-001', '', '', 'PROP-001', '', 'Vivienda 1A', 'Dwelling');
        AddSampleRow(TempExcelBuffer, 'HAB-001', 'VIV-001', '', 'PROP-001', '', 'Habitacion 1A-01', 'Room');
        AddSampleRow(TempExcelBuffer, 'PK-001', '', 'FA00045', 'PROP-001', 'VIV00045', 'Parking vinculado', 'Parking');

        TempExcelBuffer.CreateNewBook('Asset Structure');
        TempExcelBuffer.WriteSheet('Asset Structure', CompanyName, UserId);
        TempExcelBuffer.CloseBook();
        DownloadFileName := TemplateFileNameLbl + '.xlsx';
        TempExcelBuffer.SetFriendlyFilename(DownloadFileName);
        TempBlob.CreateOutStream(FileOutStream);
        TempExcelBuffer.SaveToStream(FileOutStream, true);
        TempBlob.CreateInStream(FileInStream);
        DownloadFromStream(FileInStream, '', '', '', DownloadFileName);
    end;

    procedure ImportExcel(): Guid
    var
        TempBlob: Codeunit "Temp Blob";
        UploadStream: InStream;
        TempInStream: InStream;
        TempOutStream: OutStream;
        FileName: Text;
        BatchId: Guid;
        EmptyGuid: Guid;
        ImportLine: Record "OD AM Asset Import";
    begin
        if not UploadIntoStream(SelectExcelLbl, '', 'Excel files (*.xlsx)|*.xlsx', FileName, UploadStream) then
            exit(EmptyGuid);

        TempBlob.CreateOutStream(TempOutStream);
        CopyStream(TempOutStream, UploadStream);

        BatchId := CreateGuid();

        TempBlob.CreateInStream(TempInStream);
        ReadAssetSheet(BatchId, FileName, TempInStream);

        ImportLine.SetRange("Import Batch ID", BatchId);
        Message(ImportFinishedLbl, BatchId, ImportLine.Count);
        exit(BatchId);
    end;

    procedure CreateBatchFromFixedAssets(var FixedAsset: Record "Fixed Asset"): Guid
    var
        BatchId: Guid;
        EmptyGuid: Guid;
        RowNo: Integer;
        ImportLine: Record "OD AM Asset Import";
        InsertedCount: Integer;
    begin
        if FixedAsset.IsEmpty() then
            exit(EmptyGuid);

        BatchId := CreateGuid();
        RowNo := 2;

        if FixedAsset.FindSet() then
            repeat
                Clear(ImportLine);
                InitializeWorkingLine(ImportLine, BatchId, FixedAssetBatchLbl, RowNo);
                ImportLine."External Asset ID" := FixedAsset."No.";
                ImportLine."FA No." := FixedAsset."No.";
                ImportLine."Main Property Line" := true;
                ImportLine."Property No." := FixedAsset."No.";
                ImportLine.Description := CopyStr(FixedAsset.Description, 1, MaxStrLen(ImportLine.Description));
                ImportLine."Asset Type Text" := 'Asset';
                InsertWorkingLine(ImportLine);
                RowNo += 1;
                InsertedCount += 1;
            until FixedAsset.Next() = 0;

        Message(GeneratedBatchLbl, BatchId, InsertedCount);
        exit(BatchId);
    end;

    procedure CreateBatchFromFixedAssetsByNo(FixedAssetNo: Code[20]): Guid
    var
        FixedAsset: Record "Fixed Asset";
        EmptyGuid: Guid;
    begin
        if FixedAssetNo = '' then
            exit(EmptyGuid);

        FixedAsset.SetRange("No.", FixedAssetNo);
        if not FixedAsset.FindSet() then
            exit(EmptyGuid);

        exit(CreateBatchFromFixedAssets(FixedAsset));
    end;

    procedure CreateBatchFromFixedAssetsFilter(FixedAssetNoFilter: Text): Guid
    var
        FixedAsset: Record "Fixed Asset";
        EmptyGuid: Guid;
    begin
        if FixedAssetNoFilter = '' then
            exit(EmptyGuid);

        FixedAsset.SetFilter("No.", FixedAssetNoFilter);
        if not FixedAsset.FindSet() then
            exit(EmptyGuid);

        exit(CreateBatchFromFixedAssets(FixedAsset));
    end;

    procedure CreateBatchFromLeaseContractImport(BatchId: Guid): Guid
    var
        LeaseImportLine: Record "OD Lease Contract Import";
        FixedRealEstate: Record "Fixed Real Estate";
        AssetImportLine: Record "OD AM Asset Import";
        InsertedAssets: Dictionary of [Text, Boolean];
        NewBatchId: Guid;
        EmptyGuid: Guid;
        RowNo: Integer;
        AssetNo: Code[20];
        InsertedCount: Integer;
    begin
        LeaseImportLine.SetRange("Import Batch ID", BatchId);
        if LeaseImportLine.IsEmpty() then
            Error(NoBatchLbl, BatchId);

        NewBatchId := CreateGuid();
        RowNo := 2;

        if LeaseImportLine.FindSet() then
            repeat
                AssetNo := LeaseImportLine."Fixed Real Estate No.";
                if (AssetNo <> '') and (not FixedRealEstate.Get(AssetNo)) and (not InsertedAssets.ContainsKey(Format(AssetNo))) then begin
                    Clear(AssetImportLine);
                    InitializeWorkingLine(AssetImportLine, NewBatchId, LeaseContractBatchLbl, RowNo);
                    AssetImportLine."External Asset ID" := CopyStr(Format(AssetNo), 1, MaxStrLen(AssetImportLine."External Asset ID"));
                    AssetImportLine."Property No." := AssetNo;
                    AssetImportLine.Description := CopyStr(SelectLeaseImportAssetDescription(LeaseImportLine), 1, MaxStrLen(AssetImportLine.Description));
                    AssetImportLine."Asset Type Text" := 'Asset';
                    AssetImportLine."Main Property Line" := true;
                    InsertWorkingLine(AssetImportLine);

                    InsertedAssets.Add(Format(AssetNo), true);
                    RowNo += 1;
                    InsertedCount += 1;
                end;
            until LeaseImportLine.Next() = 0;

        if InsertedCount = 0 then begin
            Message(NoMissingLeaseAssetsLbl, BatchId);
            exit(EmptyGuid);
        end;

        Message(GeneratedFromLeaseImportBatchLbl, NewBatchId, InsertedCount, BatchId);
        exit(NewBatchId);
    end;

    procedure ValidateBatch(BatchId: Guid)
    var
        ImportLine: Record "OD AM Asset Import";
        ValidCount: Integer;
        WarningCount: Integer;
        ErrorCount: Integer;
    begin
        ImportLine.SetRange("Import Batch ID", BatchId);
        if ImportLine.IsEmpty() then
            Error(NoBatchLbl, BatchId);

        if ImportLine.FindSet() then
            repeat
                ValidateLine(ImportLine);
                ImportLine.Modify(true);
                case ImportLine.Status of
                    ImportLine.Status::Validated:
                        ValidCount += 1;
                    ImportLine.Status::Warning:
                        WarningCount += 1;
                    ImportLine.Status::Error:
                        ErrorCount += 1;
                end;
            until ImportLine.Next() = 0;

        Message(ValidateFinishedLbl, ValidCount + WarningCount + ErrorCount, ValidCount, WarningCount, ErrorCount);
    end;

    procedure ValidateSingleLine(var ImportLine: Record "OD AM Asset Import")
    begin
        ValidateLine(ImportLine);
        ImportLine.Modify(true);
    end;

    procedure ProcessBatch(BatchId: Guid)
    var
        ImportLine: Record "OD AM Asset Import";
        CreatedCount: Integer;
        ProcessedCount: Integer;
    begin
        ImportLine.SetRange("Import Batch ID", BatchId);
        ImportLine.SetRange(Processed, false);
        ImportLine.SetFilter(Status, '%1|%2', ImportLine.Status::Validated, ImportLine.Status::Warning);
        if ImportLine.IsEmpty() then
            Error(NoBatchLbl, BatchId);

        if ImportLine.FindSet() then
            repeat
                ProcessSingleLine(ImportLine);
                if ImportLine.Processed then begin
                    ProcessedCount += 1;
                    CreatedCount += 1;
                end;
            until ImportLine.Next() = 0;

        Message(ProcessFinishedLbl, ProcessedCount, CreatedCount);
    end;

    procedure DeleteBatch(BatchId: Guid)
    var
        ImportLine: Record "OD AM Asset Import";
    begin
        ImportLine.SetRange("Import Batch ID", BatchId);
        if not ImportLine.IsEmpty() then
            ImportLine.DeleteAll(true);

        Message(DeleteFinishedLbl, BatchId);
    end;

    procedure ProcessSingleLine(var ImportLine: Record "OD AM Asset Import")
    var
        ParentNo: Code[20];
        CreatedAssetNo: Code[20];
        MainPropertyNo: Code[20];
    begin
        if not (ImportLine.Status in [ImportLine.Status::Validated, ImportLine.Status::Warning]) then begin
            ValidateLine(ImportLine);
            ImportLine.Modify(true);
        end;

        if not (ImportLine.Status in [ImportLine.Status::Validated, ImportLine.Status::Warning]) then
            exit;

        if ImportLine."Main Property Line" then begin
            ClearLastError();
            // TryCreateMainProperty(ImportLine.Description, ImportLine."FA No.", MainPropertyNo) ;
            if not TryCreateMainProperty(ImportLine.Description, ImportLine."FA No.", MainPropertyNo) then begin
                ImportLine.Status := ImportLine.Status::Error;
                ImportLine."Error Message" := CopyStr(GetMainPropertyCreateError(ImportLine."FA No."), 1, MaxStrLen(ImportLine."Error Message"));
                ImportLine.Modify(true);
                exit;
            end;

            ClearLastError();
            if not TryCreateAsset(MainPropertyNo, ImportLine."Resolved Asset Type", ImportLine.Description, '', CreatedAssetNo) then begin
                ImportLine.Status := ImportLine.Status::Error;
                ImportLine."Error Message" := CopyStr(GetMainPropertyChildCreateError(MainPropertyNo, ImportLine."FA No."), 1, MaxStrLen(ImportLine."Error Message"));
                ImportLine.Modify(true);
                exit;
            end;

            if ImportLine."FA No." <> '' then begin
                ClearLastError();
                if not TryLinkCreatedRealEstate(CreatedAssetNo, ImportLine."FA No.") then begin
                    ImportLine.Status := ImportLine.Status::Error;
                    ImportLine."Error Message" := CopyStr(GetMainPropertyChildLinkError(MainPropertyNo, CreatedAssetNo, ImportLine."FA No."), 1, MaxStrLen(ImportLine."Error Message"));
                    ImportLine.Modify(true);
                    exit;
                end;
            end;

            ImportLine."Property No." := MainPropertyNo;
            ImportLine."Parent Asset No." := MainPropertyNo;
            ImportLine."Created Asset No." := CreatedAssetNo;
            ImportLine."Parent Resolved No." := MainPropertyNo;
            ImportLine.Processed := true;
            ImportLine."Processed At" := CurrentDateTime;
            ImportLine.Status := ImportLine.Status::Created;
            ImportLine."Error Message" := '';
            ImportLine.Modify(true);
            exit;
        end;

        ParentNo := ResolveParentNoForProcessing(ImportLine);
        if ParentNo = '' then begin
            ImportLine.Status := ImportLine.Status::Error;
            if ImportLine."Error Message" = '' then
                ImportLine."Error Message" := CopyStr(GetLastErrorText(), 1, MaxStrLen(ImportLine."Error Message"));
            ImportLine.Modify(true);
            exit;
        end;

        ClearLastError();
        if not TryCreateAsset(ParentNo, ImportLine."Resolved Asset Type", ImportLine.Description, ImportLine."FA No.", CreatedAssetNo) then begin
            ImportLine.Status := ImportLine.Status::Error;
            ImportLine."Error Message" := CopyStr(GetLastErrorText(), 1, MaxStrLen(ImportLine."Error Message"));
            ImportLine.Modify(true);
            exit;
        end;

        ImportLine."Created Asset No." := CreatedAssetNo;
        ImportLine."Parent Resolved No." := ParentNo;
        ImportLine.Processed := true;
        ImportLine."Processed At" := CurrentDateTime;
        ImportLine.Status := ImportLine.Status::Created;
        ImportLine."Error Message" := '';
        ImportLine.Modify(true);
    end;

    [TryFunction]
    local procedure TryLinkCreatedRealEstate(CreatedAssetNo: Code[20]; FANo: Code[20])
    var
        LinkMgt: Codeunit "OD RE FA Link Mgt.";
    begin
        LinkMgt.CreateLink(CreatedAssetNo, FANo, Enum::"OD RE FA Link Type"::Exclusive, true, 100);
    end;

    [TryFunction]
    local procedure TryCreateAsset(ParentNo: Code[20]; AssetType: Enum "OD Asset Type"; AssetDescription: Text[100]; FANo: Code[20]; var CreatedAssetNo: Code[20])
    var
        ParentFixedRealEstate: Record "Fixed Real Estate";
        NewFixedRealEstate: Record "Fixed Real Estate";
        LinkMgt: Codeunit "OD RE FA Link Mgt.";
    begin
        ParentFixedRealEstate.Get(ParentNo);
        CreatedAssetNo := AssetStructureMgt.CreateChildAsset(ParentFixedRealEstate, AssetType);
        if NewFixedRealEstate.Get(CreatedAssetNo) then begin
            NewFixedRealEstate.Validate(Description, AssetDescription);
            NewFixedRealEstate.Modify(true);
        end;

        if FANo <> '' then
            LinkMgt.CreateLink(CreatedAssetNo, FANo, Enum::"OD RE FA Link Type"::Exclusive, true, 100);
    end;

    [TryFunction]
    local procedure TryCreateMainProperty(AssetDescription: Text[100]; FANo: Code[20]; var CreatedAssetNo: Code[20])
    var
        NewFixedRealEstate: Record "Fixed Real Estate";
    begin
        NewFixedRealEstate.Init();
        NewFixedRealEstate.Validate(Type, NewFixedRealEstate.Type::Activo);
        NewFixedRealEstate.Validate(Description, AssetDescription);
        NewFixedRealEstate.Acquired := true;
        NewFixedRealEstate.Managed := true;
        NewFixedRealEstate.Insert(true);
        NewFixedRealEstate.Type := NewFixedRealEstate.Type::Propiedad;
        NewFixedRealEstate."Property No." := NewFixedRealEstate."No.";
        NewFixedRealEstate.Modify(false);

        CreatedAssetNo := NewFixedRealEstate."No.";
    end;

    local procedure GetMainPropertyCreateError(FANo: Code[20]): Text
    var
        ErrorText: Text;
    begin
        ErrorText := GetLastErrorText();
        if ErrorText <> '' then
            exit(StrSubstNo('%1 %2', StrSubstNo(MainPropertyCreateErrLbl, FANo), ErrorText));
        exit(StrSubstNo(MainPropertyCreateErrLbl, FANo));
    end;

    local procedure GetMainPropertyLinkError(CreatedAssetNo: Code[20]; FANo: Code[20]): Text
    var
        ErrorText: Text;
    begin
        ErrorText := GetLastErrorText();
        if ErrorText <> '' then
            exit(StrSubstNo('%1 %2', StrSubstNo(MainPropertyLinkErrLbl, CreatedAssetNo, FANo), ErrorText));
        exit(StrSubstNo(MainPropertyLinkErrLbl, CreatedAssetNo, FANo));
    end;

    local procedure GetMainPropertyChildCreateError(CreatedAssetNo: Code[20]; FANo: Code[20]): Text
    var
        ErrorText: Text;
    begin
        ErrorText := GetLastErrorText();
        if ErrorText <> '' then
            exit(StrSubstNo('%1 %2', StrSubstNo(MainPropertyChildCreateErrLbl, CreatedAssetNo, FANo), ErrorText));
        exit(StrSubstNo(MainPropertyChildCreateErrLbl, CreatedAssetNo, FANo));
    end;

    local procedure GetMainPropertyChildLinkError(MainPropertyNo: Code[20]; ChildAssetNo: Code[20]; FANo: Code[20]): Text
    var
        ErrorText: Text;
    begin
        ErrorText := GetLastErrorText();
        if ErrorText <> '' then
            exit(StrSubstNo('%1 %2', StrSubstNo(MainPropertyChildLinkErrLbl, MainPropertyNo, ChildAssetNo, FANo), ErrorText));
        exit(StrSubstNo(MainPropertyChildLinkErrLbl, MainPropertyNo, ChildAssetNo, FANo));
    end;

    local procedure ReadAssetSheet(BatchId: Guid; FileName: Text; UploadStream: InStream)
    var
        ExcelBuffer: Record "Excel Buffer" temporary;
        WorkingLine: Record "OD AM Asset Import";
        HeaderByColumn: Dictionary of [Integer, Text];
        OpenError: Text;
        CurrentRow: Integer;
    begin
        OpenError := ExcelBuffer.OpenBookStream(UploadStream, 'Asset Structure');
        if OpenError <> '' then
            Error(InvalidExcelLbl, OpenError);

        ExcelBuffer.ReadSheetContinous('Asset Structure', true);
        CurrentRow := 0;

        if ExcelBuffer.FindSet() then
            repeat
                if ExcelBuffer."Row No." = 1 then begin
                    MapHeader(HeaderByColumn, ExcelBuffer."Cell Value as Text", ExcelBuffer."Column No.");
                    continue;
                end;

                if CurrentRow <> ExcelBuffer."Row No." then begin
                    if CurrentRow <> 0 then
                        InsertWorkingLine(WorkingLine);
                    Clear(WorkingLine);
                    InitializeWorkingLine(WorkingLine, BatchId, FileName, ExcelBuffer."Row No.");
                    CurrentRow := ExcelBuffer."Row No.";
                end;

                ApplyCellValue(WorkingLine, GetHeaderKey(HeaderByColumn, ExcelBuffer."Column No."), ExcelBuffer."Cell Value as Text");
            until ExcelBuffer.Next() = 0;

        ValidateMandatoryColumns(HeaderByColumn);
        if CurrentRow <> 0 then
            InsertWorkingLine(WorkingLine);
    end;

    local procedure InitializeWorkingLine(var WorkingLine: Record "OD AM Asset Import"; BatchId: Guid; FileName: Text; RowNo: Integer)
    begin
        WorkingLine.Init();
        WorkingLine."Import Batch ID" := BatchId;
        WorkingLine."Excel Row No." := RowNo;
        WorkingLine."File Name" := CopyStr(FileName, 1, MaxStrLen(WorkingLine."File Name"));
        WorkingLine.Status := WorkingLine.Status::Pending;
    end;

    local procedure InsertWorkingLine(var WorkingLine: Record "OD AM Asset Import")
    begin
        WorkingLine.Insert(true);
    end;

    local procedure ApplyCellValue(var WorkingLine: Record "OD AM Asset Import"; HeaderKey: Text; CellValue: Text)
    begin
        case HeaderKey of
            'EXTERNALASSETID':
                WorkingLine."External Asset ID" := CopyStr(CellValue, 1, MaxStrLen(WorkingLine."External Asset ID"));
            'PARENTEXTERNALASSETID':
                WorkingLine."Parent External Asset ID" := CopyStr(CellValue, 1, MaxStrLen(WorkingLine."Parent External Asset ID"));
            'FANO':
                WorkingLine."FA No." := CopyStr(CellValue, 1, MaxStrLen(WorkingLine."FA No."));
            'PROPERTYNO':
                WorkingLine."Property No." := CopyStr(CellValue, 1, MaxStrLen(WorkingLine."Property No."));
            'PARENTASSETNO':
                WorkingLine."Parent Asset No." := CopyStr(CellValue, 1, MaxStrLen(WorkingLine."Parent Asset No."));
            'DESCRIPTION':
                WorkingLine.Description := CopyStr(CellValue, 1, MaxStrLen(WorkingLine.Description));
            'ASSETTYPE':
                WorkingLine."Asset Type Text" := CopyStr(CellValue, 1, MaxStrLen(WorkingLine."Asset Type Text"));
        end;
    end;

    local procedure MapHeader(var HeaderByColumn: Dictionary of [Integer, Text]; HeaderText: Text; ColumnNo: Integer)
    var
        HeaderKey: Text;
    begin
        HeaderKey := ResolveHeaderKey(HeaderText);
        if HeaderKey = '' then
            Error(UnknownColumnLbl, HeaderText);
        if ContainsHeader(HeaderByColumn, HeaderKey) then
            Error(DuplicateColumnLbl, HeaderText);
        HeaderByColumn.Add(ColumnNo, HeaderKey);
    end;

    local procedure ResolveHeaderKey(HeaderText: Text): Text
    var
        NormalizedHeader: Text;
    begin
        NormalizedHeader := NormalizeToken(HeaderText);
        case NormalizedHeader of
            'EXTERNALASSETID', 'IDEXTERNO':
                exit('EXTERNALASSETID');
            'PARENTEXTERNALASSETID', 'IDEXTERNOPADRE':
                exit('PARENTEXTERNALASSETID');
            'FANO', 'FIXEDASSETNO', 'ACTIVOFIJONO', 'ACTIVOFIJO':
                exit('FANO');
            'PROPERTYNO', 'PROPERTY', 'PROPIEDAD', 'NUMEROPROPIEDAD':
                exit('PROPERTYNO');
            'PARENTASSETNO', 'PARENTNO', 'ACTIVOPADRE', 'PADRE':
                exit('PARENTASSETNO');
            'DESCRIPTION', 'DESCRIPCION':
                exit('DESCRIPTION');
            'ASSETTYPE', 'TIPOACTIVO', 'TIPO':
                exit('ASSETTYPE');
        end;
        exit('');
    end;

    local procedure ValidateMandatoryColumns(HeaderByColumn: Dictionary of [Integer, Text])
    begin
        RequireHeader(HeaderByColumn, 'PROPERTYNO', 'Property No.');
        RequireHeader(HeaderByColumn, 'DESCRIPTION', 'Description');
        RequireHeader(HeaderByColumn, 'ASSETTYPE', 'Asset Type');
    end;

    local procedure RequireHeader(HeaderByColumn: Dictionary of [Integer, Text]; HeaderKey: Text; HeaderCaption: Text)
    begin
        if not ContainsHeader(HeaderByColumn, HeaderKey) then
            Error(MissingColumnLbl, HeaderCaption);
    end;

    local procedure ContainsHeader(HeaderByColumn: Dictionary of [Integer, Text]; HeaderKey: Text): Boolean
    var
        ExistingKey: Text;
        ColumnNo: Integer;
    begin
        foreach ColumnNo in HeaderByColumn.Keys do begin
            HeaderByColumn.Get(ColumnNo, ExistingKey);
            if ExistingKey = HeaderKey then
                exit(true);
        end;
        exit(false);
    end;

    local procedure GetHeaderKey(HeaderByColumn: Dictionary of [Integer, Text]; ColumnNo: Integer): Text
    begin
        if HeaderByColumn.ContainsKey(ColumnNo) then
            exit(HeaderByColumn.Get(ColumnNo));
        exit('');
    end;

    local procedure NormalizeToken(SourceText: Text): Text
    begin
        SourceText := UpperCase(SourceText);
        SourceText := DelChr(SourceText, '=', ' ._-/*\()[]{}');
        exit(SourceText);
    end;

    local procedure ValidateLine(var ImportLine: Record "OD AM Asset Import")
    var
        PropertyFixedRealEstate: Record "Fixed Real Estate";
        ParentFixedRealEstate: Record "Fixed Real Estate";
        ParentImportLine: Record "OD AM Asset Import";
        FixedAsset: Record "Fixed Asset";
        RealEstateLink: Record "OD RE FA Link";
    begin
        ClearLineMessages(ImportLine);

        ResolveMissingFixedAssetNo(ImportLine);

        if ImportLine."FA No." <> '' then
            ResolveImportContextFromImportLine(ImportLine);

        if not ImportLine."Main Property Line" then
            if ImportLine."Property No." = '' then
                AddError(ImportLine, MissingPropertyLbl)
            else
                if not PropertyFixedRealEstate.Get(ImportLine."Property No.") then
                    AddError(ImportLine, StrSubstNo(InvalidPropertyLbl, ImportLine."Property No."))
                else
                    if PropertyFixedRealEstate.Type <> PropertyFixedRealEstate.Type::Propiedad then
                        AddError(ImportLine, StrSubstNo(InvalidPropertyLbl, ImportLine."Property No."));

        if ImportLine.Description = '' then
            AddError(ImportLine, MissingDescriptionLbl);

        if ImportLine."Asset Type Text" = '' then
            AddError(ImportLine, MissingAssetTypeLbl)
        else
            if not ResolveAssetType(ImportLine."Asset Type Text", ImportLine."Resolved Asset Type") then
                AddError(ImportLine, StrSubstNo(InvalidAssetTypeLbl, ImportLine."Asset Type Text"));

        if ImportLine."External Asset ID" <> '' then
            if IsDuplicateExternalId(ImportLine) then
                AddError(ImportLine, StrSubstNo(DuplicateExternalIdLbl, ImportLine."External Asset ID"));

        if ImportLine."FA No." <> '' then begin
            if not FixedAsset.Get(ImportLine."FA No.") then
                AddError(ImportLine, StrSubstNo(FixedAssetNotFoundLbl, ImportLine."FA No."))
            else
                if HasConflictingActiveFALink(ImportLine."FA No.", ImportLine."Created Asset No.") then
                    AddError(ImportLine, StrSubstNo(FixedAssetLinkExistsLbl, ImportLine."FA No."));

            if IsDuplicateFANo(ImportLine) then
                AddError(ImportLine, StrSubstNo(DuplicateFANoLbl, ImportLine."FA No."));
        end;

        if (ImportLine."Parent Asset No." <> '') and (ImportLine."Parent External Asset ID" <> '') then
            AddError(ImportLine, ParentReferenceConflictLbl);

        if ImportLine."Parent External Asset ID" = ImportLine."External Asset ID" then
            if ImportLine."External Asset ID" <> '' then
                AddError(ImportLine, SelfParentLbl);

        if ImportLine."Parent Asset No." <> '' then begin
            if not ParentFixedRealEstate.Get(ImportLine."Parent Asset No.") then
                AddError(ImportLine, StrSubstNo(ParentAssetNotFoundLbl, ImportLine."Parent Asset No."))
            else
                if AssetStructureMgt.GetRootProperty(ParentFixedRealEstate."No.") <> ImportLine."Property No." then
                    AddError(ImportLine, StrSubstNo(ParentPropertyMismatchLbl, ParentFixedRealEstate."No.", ImportLine."Property No."))
                else
                    ImportLine."Parent Resolved No." := ParentFixedRealEstate."No.";
        end else
            if ImportLine."Parent External Asset ID" <> '' then begin
                if not ParentImportLine.Get(ImportLine."Import Batch ID", GetParentExternalRowNo(ImportLine)) then
                    AddError(ImportLine, StrSubstNo(ParentExternalNotFoundLbl, ImportLine."Parent External Asset ID"));
            end else
                ImportLine."Parent Resolved No." := ImportLine."Property No.";

        if (ImportLine."Resolved Asset Type" = ImportLine."Resolved Asset Type"::Room) and
           (ImportLine."Parent Asset No." = '') and (ImportLine."Parent External Asset ID" = '')
        then
            AddWarning(ImportLine, RoomParentWarningLbl);

        FinalizeStatus(ImportLine);
    end;

    local procedure GetParentExternalRowNo(ImportLine: Record "OD AM Asset Import"): Integer
    var
        ParentImportLine: Record "OD AM Asset Import";
    begin
        ParentImportLine.SetRange("Import Batch ID", ImportLine."Import Batch ID");
        ParentImportLine.SetRange("External Asset ID", ImportLine."Parent External Asset ID");
        if ParentImportLine.FindFirst() then
            exit(ParentImportLine."Excel Row No.");
        exit(0);
    end;

    local procedure IsDuplicateExternalId(ImportLine: Record "OD AM Asset Import"): Boolean
    var
        OtherLine: Record "OD AM Asset Import";
    begin
        OtherLine.SetRange("Import Batch ID", ImportLine."Import Batch ID");
        OtherLine.SetRange("External Asset ID", ImportLine."External Asset ID");
        exit(OtherLine.Count > 1);
    end;

    local procedure IsDuplicateFANo(ImportLine: Record "OD AM Asset Import"): Boolean
    var
        OtherLine: Record "OD AM Asset Import";
    begin
        OtherLine.SetRange("Import Batch ID", ImportLine."Import Batch ID");
        OtherLine.SetRange("FA No.", ImportLine."FA No.");
        exit((ImportLine."FA No." <> '') and (OtherLine.Count > 1));
    end;

    local procedure HasConflictingActiveFALink(FANo: Code[20]; AllowedRealEstateNo: Code[20]): Boolean
    var
        RealEstateLink: Record "OD RE FA Link";
    begin
        if FANo = '' then
            exit(false);

        RealEstateLink.SetRange("FA No.", FANo);
        RealEstateLink.SetRange(Active, true);
        if RealEstateLink.FindSet() then
            repeat
                if IsExistingLinkedRealEstate(RealEstateLink."Real Estate No.") and
                   (RealEstateLink."Real Estate No." <> AllowedRealEstateNo)
                then
                    exit(true);
            until RealEstateLink.Next() = 0;

        exit(false);
    end;

    local procedure ResolveImportContextFromFixedAsset(FANo: Code[20]; var PropertyNo: Code[20]; var ParentAssetNo: Code[20])
    var
        FixedRealEstate: Record "Fixed Real Estate";
        LinkedRealEstateNo: Code[20];
    begin
        Clear(PropertyNo);
        Clear(ParentAssetNo);

        if FANo = '' then
            exit;

        if FixedRealEstate.Get(FANo) then begin
            if FixedRealEstate.Type = FixedRealEstate.Type::Propiedad then begin
                PropertyNo := FixedRealEstate."No.";
                exit;
            end;

            ParentAssetNo := FixedRealEstate."No.";
            PropertyNo := AssetStructureMgt.GetRootProperty(FixedRealEstate."No.");
            exit;
        end;

        LinkedRealEstateNo := ResolveLinkedRealEstateNoFromFixedAsset(FANo);
        if LinkedRealEstateNo = '' then
            exit;

        ParentAssetNo := LinkedRealEstateNo;
        PropertyNo := AssetStructureMgt.GetRootProperty(LinkedRealEstateNo);
    end;

    local procedure ResolvePropertyNoFromFixedAsset(FANo: Code[20]): Code[20]
    var
        LinkedRealEstateNo: Code[20];
    begin
        LinkedRealEstateNo := ResolveLinkedRealEstateNoFromFixedAsset(FANo);
        if LinkedRealEstateNo = '' then
            exit('');

        exit(AssetStructureMgt.GetRootProperty(LinkedRealEstateNo));
    end;

    local procedure ResolveLinkedRealEstateNoFromFixedAsset(FANo: Code[20]): Code[20]
    var
        RealEstateLink: Record "OD RE FA Link";
    begin
        if FANo = '' then
            exit('');

        RealEstateLink.SetRange("FA No.", FANo);
        RealEstateLink.SetRange(Active, true);
        if RealEstateLink.FindSet() then
            repeat
                if IsExistingLinkedRealEstate(RealEstateLink."Real Estate No.") then
                    exit(RealEstateLink."Real Estate No.");
            until RealEstateLink.Next() = 0;

        exit('');
    end;

    local procedure IsExistingLinkedRealEstate(RealEstateNo: Code[20]): Boolean
    var
        FixedRealEstate: Record "Fixed Real Estate";
    begin
        if RealEstateNo = '' then
            exit(false);

        exit(FixedRealEstate.Get(RealEstateNo));
    end;

    local procedure ResolveImportContextFromImportLine(var ImportLine: Record "OD AM Asset Import")
    var
        PropertyNo: Code[20];
        ParentAssetNo: Code[20];
    begin
        ResolveImportContextFromFixedAsset(ImportLine."FA No.", PropertyNo, ParentAssetNo);

        if (ImportLine."Property No." = '') and (PropertyNo <> '') then
            ImportLine."Property No." := PropertyNo;

        if (ImportLine."Parent Asset No." = '') and (ParentAssetNo <> '') then
            ImportLine."Parent Asset No." := ParentAssetNo;
    end;

    local procedure ResolveMissingFixedAssetNo(var ImportLine: Record "OD AM Asset Import")
    var
        FixedAsset: Record "Fixed Asset";
    begin
        if (ImportLine."FA No." <> '') or (ImportLine."External Asset ID" = '') then
            exit;

        if FixedAsset.Get(CopyStr(ImportLine."External Asset ID", 1, MaxStrLen(ImportLine."FA No."))) then
            ImportLine."FA No." := FixedAsset."No.";
    end;

    local procedure SelectLeaseImportAssetDescription(LeaseImportLine: Record "OD Lease Contract Import"): Text[100]
    begin
        if LeaseImportLine.Description <> '' then
            exit(CopyStr(LeaseImportLine.Description, 1, 100));

        exit(CopyStr(StrSubstNo('Activo %1', LeaseImportLine."Fixed Real Estate No."), 1, 100));
    end;

    local procedure ResolveAssetType(AssetTypeText: Text; var ResolvedAssetType: Enum "OD Asset Type"): Boolean
    var
        NormalizedType: Text;
    begin
        NormalizedType := NormalizeToken(AssetTypeText);
        case NormalizedType of
            'VIVIENDA', 'DWELLING':
                ResolvedAssetType := ResolvedAssetType::Dwelling;
            'HABITACION', 'ROOM':
                ResolvedAssetType := ResolvedAssetType::Room;
            'PARKING', 'APARCAMIENTO', 'GARAJE', 'PLAZADEGARAJE':
                ResolvedAssetType := ResolvedAssetType::Parking;
            'TRASTERO', 'STORAGE':
                ResolvedAssetType := ResolvedAssetType::Storage;
            'ACTIVO', 'ASSET', 'LOCAL', 'OFICINA', 'UNDEFINED':
                ResolvedAssetType := ResolvedAssetType::Undefined;
            else
                exit(false);
        end;
        exit(true);
    end;

    local procedure ResolveParentNoForProcessing(var ImportLine: Record "OD AM Asset Import"): Code[20]
    var
        ParentImportLine: Record "OD AM Asset Import";
    begin
        if ImportLine."Parent Asset No." <> '' then
            exit(ImportLine."Parent Asset No.");

        if ImportLine."Parent External Asset ID" <> '' then begin
            ParentImportLine.SetRange("Import Batch ID", ImportLine."Import Batch ID");
            ParentImportLine.SetRange("External Asset ID", ImportLine."Parent External Asset ID");
            if not ParentImportLine.FindFirst() then
                Error(ParentExternalNotFoundLbl, ImportLine."Parent External Asset ID");
            if ParentImportLine."Created Asset No." = '' then
                Error(ParentCreatedMissingLbl, ImportLine."Parent External Asset ID");
            exit(ParentImportLine."Created Asset No.");
        end;

        exit(ImportLine."Property No.");
    end;

    local procedure ClearLineMessages(var ImportLine: Record "OD AM Asset Import")
    begin
        ImportLine."Error Message" := '';
        ImportLine."Warning Message" := '';
        ImportLine."Parent Resolved No." := '';
        ImportLine.Status := ImportLine.Status::Pending;
    end;

    local procedure AddError(var ImportLine: Record "OD AM Asset Import"; ErrorText: Text)
    begin
        ImportLine."Error Message" := AppendMessage(ImportLine."Error Message", ErrorText, MaxStrLen(ImportLine."Error Message"));
    end;

    local procedure AddWarning(var ImportLine: Record "OD AM Asset Import"; WarningText: Text)
    begin
        ImportLine."Warning Message" := AppendMessage(ImportLine."Warning Message", WarningText, MaxStrLen(ImportLine."Warning Message"));
    end;

    local procedure AppendMessage(CurrentText: Text; NewText: Text; MaxLength: Integer): Text
    begin
        if NewText = '' then
            exit(CurrentText);
        if CurrentText = '' then
            exit(CopyStr(NewText, 1, MaxLength));
        exit(CopyStr(CurrentText + ' | ' + NewText, 1, MaxLength));
    end;

    local procedure FinalizeStatus(var ImportLine: Record "OD AM Asset Import")
    begin
        if ImportLine."Error Message" <> '' then begin
            ImportLine.Status := ImportLine.Status::Error;
            exit;
        end;

        if ImportLine."Warning Message" <> '' then begin
            ImportLine.Status := ImportLine.Status::Warning;
            exit;
        end;

        ImportLine.Status := ImportLine.Status::Validated;
    end;

    local procedure AddHeader(var TempExcelBuffer: Record "Excel Buffer" temporary; HeaderText: Text)
    begin
        TempExcelBuffer.AddColumn(HeaderText, false, '', true, false, false, '', TempExcelBuffer."Cell Type"::Text);
    end;

    local procedure AddSampleRow(var TempExcelBuffer: Record "Excel Buffer" temporary; ExternalAssetId: Text; ParentExternalAssetId: Text; FANo: Text; PropertyNo: Text; ParentAssetNo: Text; Description: Text; AssetType: Text)
    begin
        TempExcelBuffer.NewRow();
        TempExcelBuffer.AddColumn(ExternalAssetId, false, '', false, false, false, '', TempExcelBuffer."Cell Type"::Text);
        TempExcelBuffer.AddColumn(ParentExternalAssetId, false, '', false, false, false, '', TempExcelBuffer."Cell Type"::Text);
        TempExcelBuffer.AddColumn(FANo, false, '', false, false, false, '', TempExcelBuffer."Cell Type"::Text);
        TempExcelBuffer.AddColumn(PropertyNo, false, '', false, false, false, '', TempExcelBuffer."Cell Type"::Text);
        TempExcelBuffer.AddColumn(ParentAssetNo, false, '', false, false, false, '', TempExcelBuffer."Cell Type"::Text);
        TempExcelBuffer.AddColumn(Description, false, '', false, false, false, '', TempExcelBuffer."Cell Type"::Text);
        TempExcelBuffer.AddColumn(AssetType, false, '', false, false, false, '', TempExcelBuffer."Cell Type"::Text);
    end;
}
