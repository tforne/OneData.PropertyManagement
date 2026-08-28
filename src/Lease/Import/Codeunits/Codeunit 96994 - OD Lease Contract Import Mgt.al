codeunit 96994 "OD Lease Contract Import Mgt."
{
    var
        SelectExcelLbl: Label 'Seleccione el Excel con las cabeceras de contratos.';
        InvalidExcelLbl: Label 'No se ha podido abrir el Excel. %1';
        MissingColumnLbl: Label 'Falta la columna obligatoria %1.';
        DuplicateColumnLbl: Label 'La columna %1 esta duplicada en la cabecera.';
        UnknownColumnLbl: Label 'La columna %1 no esta soportada por esta importacion.';
        NoBatchLbl: Label 'No existen lineas para el lote %1.';
        NoPendingLinesLbl: Label 'No existen lineas pendientes de procesar para el lote %1.';
        ImportFinishedLbl: Label 'Se ha importado el lote %1 con %2 lineas.';
        ValidateFinishedLbl: Label 'Se han validado %1 lineas: %2 validas, %3 con aviso y %4 con error.';
        ProcessFinishedLbl: Label 'Se han procesado %1 lineas y se han creado %2 contratos.';
        ResetFinishedLbl: Label 'El lote %1 se ha preparado para volver a crear contratos. Contratos eliminados: %2.';
        DeleteFinishedLbl: Label 'Se ha eliminado el lote %1.';
        AssignFREFinishedLbl: Label 'Se ha revisado el lote %1. %2 lineas actualizadas, %3 sin vinculo y %4 con multiples vinculos.';
        MissingDescriptionLbl: Label 'La descripcion es obligatoria.';
        MissingCustomerLbl: Label 'El cliente es obligatorio.';
        MissingAssetLbl: Label 'El activo inmobiliario es obligatorio.';
        MissingStartDateLbl: Label 'La fecha de inicio es obligatoria.';
        CustomerNotFoundLbl: Label 'El cliente %1 no existe.';
        SecondCustomerNotFoundLbl: Label 'El segundo cliente %1 no existe.';
        AssetNotFoundLbl: Label 'El activo %1 no existe.';
        AssetTypeInvalidLbl: Label 'El registro %1 debe ser un activo y no una propiedad.';
        ContractExistsLbl: Label 'El contrato %1 ya existe.';
        DuplicateContractNoLbl: Label 'El contrato %1 esta duplicado dentro del lote.';
        ExpirationBeforeStartLbl: Label 'La fecha de fin no puede ser anterior a la fecha de inicio.';
        PaymentMethodNotFoundLbl: Label 'La forma de pago %1 no existe.';
        PaymentTermsNotFoundLbl: Label 'Los terminos de pago %1 no existen.';
        InvalidInvoicePeriodLbl: Label 'El periodo de facturacion %1 no es valido.';
        MissingContractImportKeyLbl: Label 'Debe informar Contract Import Key o Contract No. cuando el lote incluya varias lineas para un mismo contrato.';
        MissingLineTypeLbl: Label 'El tipo de linea es obligatorio cuando se informan datos de linea.';
        InvalidLineTypeLbl: Label 'El tipo de linea %1 no es valido.';
        MissingLineAccountLbl: Label 'La cuenta de linea es obligatoria cuando se informan datos de linea.';
        LineAccountNotFoundLbl: Label 'La cuenta de linea %1 no existe para el tipo %2.';
        InvalidLineDatesLbl: Label 'La fecha fin de linea no puede ser anterior a la fecha inicio de linea.';
        InvalidLineServicePeriodLbl: Label 'El periodo de servicio de linea %1 no es valido.';
        DefaultImportedLineDescriptionLbl: Label 'Linea importada';
        HeaderConflictLbl: Label 'Las filas agrupadas del contrato %1 contienen datos de cabecera distintos en el campo %2.';
        MultipleFALinksLbl: Label 'El activo fijo %1 tiene varios activos inmobiliarios activos vinculados. Revise el vinculo principal.';
        TemplateFileNameLbl: Label 'OD_Lease_Contract_Import_Template';

    procedure DownloadTemplate()
    var
        TempExcelBuffer: Record "Excel Buffer" temporary;
        TempBlob: Codeunit "Temp Blob";
        FileOutStream: OutStream;
        FileInStream: InStream;
        DownloadFileName: Text;
    begin
        TempExcelBuffer.NewRow();
        AddHeader(TempExcelBuffer, 'Contract No.');
        AddHeader(TempExcelBuffer, 'Description');
        AddHeader(TempExcelBuffer, 'Customer No.');
        AddHeader(TempExcelBuffer, 'Second Customer No.');
        AddHeader(TempExcelBuffer, 'Fixed Real Estate No.');
        AddHeader(TempExcelBuffer, 'Contract Date');
        AddHeader(TempExcelBuffer, 'Starting Date');
        AddHeader(TempExcelBuffer, 'Expiration Date');
        AddHeader(TempExcelBuffer, 'Invoice Period');
        AddHeader(TempExcelBuffer, 'Annual Amount');
        AddHeader(TempExcelBuffer, 'Payment Method Code');
        AddHeader(TempExcelBuffer, 'Payment Terms Code');
        AddHeader(TempExcelBuffer, 'Contract Import Key');
        AddHeader(TempExcelBuffer, 'Line Type');
        AddHeader(TempExcelBuffer, 'No. Cuenta');
        AddHeader(TempExcelBuffer, 'Descripcion linea');
        AddHeader(TempExcelBuffer, 'Valor de linea');
        AddHeader(TempExcelBuffer, 'Line Starting Date');
        AddHeader(TempExcelBuffer, 'Line Expiration Date');
        AddHeader(TempExcelBuffer, 'Line Service Period');
        AddHeader(TempExcelBuffer, 'Line VAT Bus. Posting Group');
        AddHeader(TempExcelBuffer, 'Grupo registro IVA producto');
        AddHeader(TempExcelBuffer, 'Line Shortcut Dim. 1 Code');
        AddHeader(TempExcelBuffer, 'Line Shortcut Dim. 2 Code');
        AddHeader(TempExcelBuffer, 'Line Apply Increments');
        AddHeader(TempExcelBuffer, 'Line Apply Taxes');
        AddHeader(TempExcelBuffer, 'Line Base Contract');

        TempExcelBuffer.CreateNewBook('Lease Contracts');
        TempExcelBuffer.WriteSheet('Lease Contracts', CompanyName, UserId);
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
        ImportLine: Record "OD Lease Contract Import";
    begin
        if not UploadIntoStream(SelectExcelLbl, '', 'Excel files (*.xlsx)|*.xlsx', FileName, UploadStream) then
            exit(EmptyGuid);

        TempBlob.CreateOutStream(TempOutStream);
        CopyStream(TempOutStream, UploadStream);

        BatchId := CreateGuid();

        TempBlob.CreateInStream(TempInStream);
        ReadContractSheet(BatchId, FileName, TempInStream);

        ImportLine.SetRange("Import Batch ID", BatchId);
        Message(ImportFinishedLbl, BatchId, ImportLine.Count);
        exit(BatchId);
    end;

    procedure ValidateBatch(BatchId: Guid)
    var
        ImportLine: Record "OD Lease Contract Import";
        ValidCount: Integer;
        WarningCount: Integer;
        ErrorCount: Integer;
        GroupLine: Record "OD Lease Contract Import";
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

        GroupLine.SetRange("Import Batch ID", BatchId);
        if GroupLine.FindSet() then
            repeat
                ValidateGroupConsistency(GroupLine);
            until GroupLine.Next() = 0;

        ImportLine.SetRange("Import Batch ID", BatchId);
        ValidCount := 0;
        WarningCount := 0;
        ErrorCount := 0;
        if ImportLine.FindSet() then
            repeat
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

    procedure ValidateSingleLine(var ImportLine: Record "OD Lease Contract Import")
    begin
        ValidateLine(ImportLine);
        ImportLine.Modify(true);
    end;

    procedure ProcessBatch(BatchId: Guid)
    var
        ImportLine: Record "OD Lease Contract Import";
        CreatedCount: Integer;
        ProcessedCount: Integer;
        CreatedContractNo: Code[20];
    begin
        ImportLine.SetRange("Import Batch ID", BatchId);
        if ImportLine.IsEmpty() then
            Error(NoBatchLbl, BatchId);

        if not FindNextPendingBatchLine(BatchId, ImportLine) then
            Error(NoPendingLinesLbl, BatchId);

        repeat
            ProcessImportGroup(ImportLine, CreatedContractNo, ProcessedCount, CreatedCount);
        until not FindNextPendingBatchLine(BatchId, ImportLine);

        Message(ProcessFinishedLbl, ProcessedCount, CreatedCount);
    end;

    procedure DeleteBatch(BatchId: Guid)
    var
        ImportLine: Record "OD Lease Contract Import";
    begin
        ImportLine.SetRange("Import Batch ID", BatchId);
        if not ImportLine.IsEmpty() then
            ImportLine.DeleteAll(true);

        Message(DeleteFinishedLbl, BatchId);
    end;

    procedure ResetBatchForReprocessing(BatchId: Guid)
    var
        ImportLine: Record "OD Lease Contract Import";
        LeaseContract: Record "Lease Contract";
        DeletedContracts: Integer;
        LastDeletedContractNo: Code[20];
    begin
        ImportLine.SetRange("Import Batch ID", BatchId);
        if ImportLine.IsEmpty() then
            Error(NoBatchLbl, BatchId);

        if ImportLine.FindSet() then
            repeat
                if (ImportLine."Created Contract No." <> '') and (ImportLine."Created Contract No." <> LastDeletedContractNo) then
                    if LeaseContract.Get(ImportLine."Created Contract No.") then begin
                        LeaseContract.Delete(true);
                        DeletedContracts += 1;
                        LastDeletedContractNo := ImportLine."Created Contract No.";
                    end;
            until ImportLine.Next() = 0;

        ImportLine.Reset();
        ImportLine.SetRange("Import Batch ID", BatchId);
        if ImportLine.FindSet() then
            repeat
                ImportLine.Processed := false;
                Clear(ImportLine."Processed At");
                Clear(ImportLine."Created Contract No.");
                ClearLineMessages(ImportLine);
                ImportLine.Modify(true);
            until ImportLine.Next() = 0;

        Message(ResetFinishedLbl, BatchId, DeletedContracts);
    end;

    procedure AssignFixedRealEstateNoFromFALinks(BatchId: Guid)
    var
        ImportLine: Record "OD Lease Contract Import";
        FixedRealEstate: Record "Fixed Real Estate";
        UpdatedCount: Integer;
        MissingLinkCount: Integer;
        MultipleLinkCount: Integer;
        ResolvedRealEstateNo: Code[20];
    begin
        ImportLine.SetRange("Import Batch ID", BatchId);
        if ImportLine.IsEmpty() then
            Error(NoBatchLbl, BatchId);

        if ImportLine.FindSet() then
            repeat
                if ImportLine."Fixed Real Estate No." = '' then
                    continue;

                if FixedRealEstate.Get(ImportLine."Fixed Real Estate No.") then
                    continue;

                ResolvedRealEstateNo := ResolveFixedRealEstateNoFromFALink(ImportLine."Fixed Real Estate No.");
                if ResolvedRealEstateNo = '' then
                    MissingLinkCount += 1
                else
                    if ResolvedRealEstateNo = GetMultipleLinkMarker() then begin
                        MultipleLinkCount += 1;
                        ImportLine."Warning Message" := AppendMessage(ImportLine."Warning Message", StrSubstNo(MultipleFALinksLbl, ImportLine."Fixed Real Estate No."), MaxStrLen(ImportLine."Warning Message"));
                        if ImportLine."Error Message" = '' then
                            ImportLine.Status := ImportLine.Status::Warning
                        else
                            FinalizeStatus(ImportLine);
                        ImportLine.Modify(false);
                    end else
                        if ImportLine."Fixed Real Estate No." <> ResolvedRealEstateNo then begin
                            ImportLine."Fixed Real Estate No." := ResolvedRealEstateNo;
                            ImportLine.Processed := false;
                            Clear(ImportLine."Processed At");
                            Clear(ImportLine."Created Contract No.");
                            ClearLineMessages(ImportLine);
                            ImportLine.Modify(false);
                            UpdatedCount += 1;
                        end;
            until ImportLine.Next() = 0;

        Message(AssignFREFinishedLbl, BatchId, UpdatedCount, MissingLinkCount, MultipleLinkCount);
    end;

    procedure ProcessSingleLine(var ImportLine: Record "OD Lease Contract Import")
    var
        CreatedContractNo: Code[20];
        ProcessedCount: Integer;
        CreatedCount: Integer;
    begin
        ProcessImportGroup(ImportLine, CreatedContractNo, ProcessedCount, CreatedCount);
    end;

    [TryFunction]
    local procedure TryCreateContractGroup(ImportLine: Record "OD Lease Contract Import"; var CreatedContractNo: Code[20])
    var
        LeaseContract: Record "Lease Contract";
        GroupLine: Record "OD Lease Contract Import";
    begin
        LeaseContract.Init();
        if ImportLine."Contract No." <> '' then
            LeaseContract."Contract No." := ImportLine."Contract No.";
        LeaseContract.Insert(true);

        LeaseContract.Validate(Description, ImportLine.Description);
        LeaseContract.Validate("Customer No.", ImportLine."Customer No.");

        if ImportLine."Second Customer No." <> '' then
            LeaseContract.Validate("Second Customer No.", ImportLine."Second Customer No.");

        LeaseContract.Validate("Fixed Real Estate No.", ImportLine."Fixed Real Estate No.");

        if ImportLine."Contract Date" <> 0D then
            LeaseContract.Validate("Contract Date", ImportLine."Contract Date")
        else
            LeaseContract.Validate("Contract Date", ImportLine."Starting Date");

        LeaseContract.Validate("Starting Date", ImportLine."Starting Date");

        if ImportLine."Expiration Date" <> 0D then
            LeaseContract.Validate("Expiration Date", ImportLine."Expiration Date");

        if ImportLine."Invoice Period Text" <> '' then
            ApplyInvoicePeriod(LeaseContract, ImportLine."Invoice Period Text");

        if ImportLine."Annual Amount" <> 0 then
            LeaseContract.Validate("Annual Amount", ImportLine."Annual Amount");

        if ImportLine."Payment Method Code" <> '' then
            LeaseContract.Validate("Payment Method Code", ImportLine."Payment Method Code");

        if ImportLine."Payment Terms Code" <> '' then
            LeaseContract.Validate("Payment Terms Code", ImportLine."Payment Terms Code");

        LeaseContract.Modify(true);
        CreatedContractNo := LeaseContract."Contract No.";

        SetGroupFilter(GroupLine, ImportLine);
        if GroupLine.FindSet() then
            repeat
                if HasLineData(GroupLine) then
                    CreateImportedContractLine(LeaseContract, GroupLine);
            until GroupLine.Next() = 0;
    end;

    local procedure ReadContractSheet(BatchId: Guid; FileName: Text; UploadStream: InStream)
    var
        ExcelBuffer: Record "Excel Buffer" temporary;
        WorkingLine: Record "OD Lease Contract Import";
        HeaderByColumn: Dictionary of [Integer, Text];
        OpenError: Text;
        CurrentRow: Integer;
    begin
        OpenError := ExcelBuffer.OpenBookStream(UploadStream, 'Lease Contracts');
        if OpenError <> '' then
            Error(InvalidExcelLbl, OpenError);

        ExcelBuffer.ReadSheetContinous('Lease Contracts', true);
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

    local procedure InitializeWorkingLine(var WorkingLine: Record "OD Lease Contract Import"; BatchId: Guid; FileName: Text; RowNo: Integer)
    begin
        WorkingLine.Init();
        WorkingLine."Import Batch ID" := BatchId;
        WorkingLine."Excel Row No." := RowNo;
        WorkingLine."File Name" := CopyStr(FileName, 1, MaxStrLen(WorkingLine."File Name"));
        WorkingLine.Status := WorkingLine.Status::Pending;
    end;

    local procedure InsertWorkingLine(var WorkingLine: Record "OD Lease Contract Import")
    begin
        WorkingLine.Insert(true);
    end;

    local procedure ApplyCellValue(var WorkingLine: Record "OD Lease Contract Import"; HeaderKey: Text; CellValue: Text)
    begin
        case HeaderKey of
            'CONTRACTNO':
                WorkingLine."Contract No." := CopyStr(CellValue, 1, MaxStrLen(WorkingLine."Contract No."));
            'DESCRIPTION':
                WorkingLine.Description := CopyStr(CellValue, 1, MaxStrLen(WorkingLine.Description));
            'CUSTOMERNO':
                WorkingLine."Customer No." := CopyStr(CellValue, 1, MaxStrLen(WorkingLine."Customer No."));
            'SECONDCUSTOMERNO':
                WorkingLine."Second Customer No." := CopyStr(CellValue, 1, MaxStrLen(WorkingLine."Second Customer No."));
            'FIXEDREALESTATENO':
                WorkingLine."Fixed Real Estate No." := CopyStr(CellValue, 1, MaxStrLen(WorkingLine."Fixed Real Estate No."));
            'CONTRACTDATE':
                Evaluate(WorkingLine."Contract Date", CellValue);
            'STARTINGDATE':
                Evaluate(WorkingLine."Starting Date", CellValue);
            'EXPIRATIONDATE':
                Evaluate(WorkingLine."Expiration Date", CellValue);
            'INVOICEPERIOD':
                WorkingLine."Invoice Period Text" := CopyStr(CellValue, 1, MaxStrLen(WorkingLine."Invoice Period Text"));
            'ANNUALAMOUNT':
                Evaluate(WorkingLine."Annual Amount", CellValue);
            'PAYMENTMETHODCODE':
                WorkingLine."Payment Method Code" := CopyStr(CellValue, 1, MaxStrLen(WorkingLine."Payment Method Code"));
            'PAYMENTTERMSCODE':
                WorkingLine."Payment Terms Code" := CopyStr(CellValue, 1, MaxStrLen(WorkingLine."Payment Terms Code"));
            'CONTRACTIMPORTKEY':
                WorkingLine."Contract Import Key" := CopyStr(CellValue, 1, MaxStrLen(WorkingLine."Contract Import Key"));
            'LINETYPE':
                WorkingLine."Line Type Text" := CopyStr(CellValue, 1, MaxStrLen(WorkingLine."Line Type Text"));
            'LINEACCOUNTNO':
                WorkingLine."Line Account No." := CopyStr(CellValue, 1, MaxStrLen(WorkingLine."Line Account No."));
            'LINEDESCRIPTION':
                WorkingLine."Line Description" := CopyStr(CellValue, 1, MaxStrLen(WorkingLine."Line Description"));
            'LINEVALUE':
                Evaluate(WorkingLine."Line Value", CellValue);
            'LINESTARTINGDATE':
                Evaluate(WorkingLine."Line Starting Date", CellValue);
            'LINEEXPIRATIONDATE':
                Evaluate(WorkingLine."Line Expiration Date", CellValue);
            'LINESERVICEPERIOD':
                WorkingLine."Line Service Period Text" := CopyStr(CellValue, 1, MaxStrLen(WorkingLine."Line Service Period Text"));
            'LINEVATBUSPOSTINGGROUP':
                WorkingLine."Line VAT Bus. Posting Group" := CopyStr(CellValue, 1, MaxStrLen(WorkingLine."Line VAT Bus. Posting Group"));
            'LINEVATPRODPOSTINGGROUP':
                WorkingLine."Line VAT Prod. Posting Group" := CopyStr(CellValue, 1, MaxStrLen(WorkingLine."Line VAT Prod. Posting Group"));
            'LINESHORTCUTDIM1CODE':
                WorkingLine."Line Shortcut Dim. 1 Code" := CopyStr(CellValue, 1, MaxStrLen(WorkingLine."Line Shortcut Dim. 1 Code"));
            'LINESHORTCUTDIM2CODE':
                WorkingLine."Line Shortcut Dim. 2 Code" := CopyStr(CellValue, 1, MaxStrLen(WorkingLine."Line Shortcut Dim. 2 Code"));
            'LINEAPPLYINCREMENTS':
                Evaluate(WorkingLine."Line Apply Increments", CellValue);
            'LINEAPPLYTAXES':
                Evaluate(WorkingLine."Line Apply Taxes", CellValue);
            'LINEBASECONTRACT':
                Evaluate(WorkingLine."Line Base Contract", CellValue);
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
            'CONTRACTNO', 'NUMEROCONTRATO':
                exit('CONTRACTNO');
            'DESCRIPTION', 'DESCRIPCION':
                exit('DESCRIPTION');
            'CUSTOMERNO', 'CLIENTE', 'CUSTOMER':
                exit('CUSTOMERNO');
            'SECONDCUSTOMERNO', 'SEGUNDOCLIENTE':
                exit('SECONDCUSTOMERNO');
            'FIXEDREALESTATENO', 'ACTIVO', 'ACTIVOINMOBILIARIO':
                exit('FIXEDREALESTATENO');
            'CONTRACTDATE', 'FECHACONTRATO':
                exit('CONTRACTDATE');
            'STARTINGDATE', 'FECHAINICIO':
                exit('STARTINGDATE');
            'EXPIRATIONDATE', 'FECHAFIN':
                exit('EXPIRATIONDATE');
            'INVOICEPERIOD', 'PERIODOFACTURACION':
                exit('INVOICEPERIOD');
            'ANNUALAMOUNT', 'IMPORTEANUAL':
                exit('ANNUALAMOUNT');
            'PAYMENTMETHODCODE', 'FORMAPAGO':
                exit('PAYMENTMETHODCODE');
            'PAYMENTTERMSCODE', 'TERMINOSPAGO':
                exit('PAYMENTTERMSCODE');
            'CONTRACTIMPORTKEY', 'CLAVECONTRATOIMPORT':
                exit('CONTRACTIMPORTKEY');
            'LINETYPE', 'TIPOLINEA':
                exit('LINETYPE');
            'LINEACCOUNTNO', 'CUENTALINEA', 'NOCUENTA':
                exit('LINEACCOUNTNO');
            'LINEDESCRIPTION', 'DESCRIPCIONLINEA':
                exit('LINEDESCRIPTION');
            'LINEVALUE', 'IMPORTELINEA', 'VALORDELINEA':
                exit('LINEVALUE');
            'LINESTARTINGDATE', 'FECHAINICIOLINEA':
                exit('LINESTARTINGDATE');
            'LINEEXPIRATIONDATE', 'FECHAFINLINEA':
                exit('LINEEXPIRATIONDATE');
            'LINESERVICEPERIOD', 'PERIODOSERVICIOLINEA':
                exit('LINESERVICEPERIOD');
            'LINEVATBUSPOSTINGGROUP':
                exit('LINEVATBUSPOSTINGGROUP');
            'LINEVATPRODPOSTINGGROUP', 'GRUPOREGISTROIVAPRODUCTO':
                exit('LINEVATPRODPOSTINGGROUP');
            'LINESHORTCUTDIM1CODE':
                exit('LINESHORTCUTDIM1CODE');
            'LINESHORTCUTDIM2CODE':
                exit('LINESHORTCUTDIM2CODE');
            'LINEAPPLYINCREMENTS':
                exit('LINEAPPLYINCREMENTS');
            'LINEAPPLYTAXES':
                exit('LINEAPPLYTAXES');
            'LINEBASECONTRACT':
                exit('LINEBASECONTRACT');
        end;
        exit('');
    end;

    local procedure ValidateMandatoryColumns(HeaderByColumn: Dictionary of [Integer, Text])
    begin
        RequireHeader(HeaderByColumn, 'DESCRIPTION', 'Description');
        RequireHeader(HeaderByColumn, 'CUSTOMERNO', 'Customer No.');
        RequireHeader(HeaderByColumn, 'FIXEDREALESTATENO', 'Fixed Real Estate No.');
        RequireHeader(HeaderByColumn, 'STARTINGDATE', 'Starting Date');
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

    local procedure ValidateLine(var ImportLine: Record "OD Lease Contract Import")
    var
        Customer: Record Customer;
        FixedRealEstate: Record "Fixed Real Estate";
        PaymentMethod: Record "Payment Method";
        PaymentTerms: Record "Payment Terms";
        DummyInvoicePeriod: Integer;
        ExistingLeaseContract: Record "Lease Contract";
        LeaseLineType: Enum "Lease Contract Line Type";
        GLAccount: Record "G/L Account";
        AllocationAccount: Record "Allocation Account";
        StandardText: Record "Standard Text";
        LineServicePeriod: DateFormula;
    begin
        ClearLineMessages(ImportLine);
        ApplyHeaderDefaults(ImportLine);

        if ImportLine.Description = '' then
            AddError(ImportLine, MissingDescriptionLbl);

        if ImportLine."Customer No." = '' then
            AddError(ImportLine, MissingCustomerLbl)
        else
            if not Customer.Get(ImportLine."Customer No.") then
                AddError(ImportLine, StrSubstNo(CustomerNotFoundLbl, ImportLine."Customer No."));

        if (ImportLine."Second Customer No." <> '') and (not Customer.Get(ImportLine."Second Customer No.")) then
            AddError(ImportLine, StrSubstNo(SecondCustomerNotFoundLbl, ImportLine."Second Customer No."));

        if ImportLine."Fixed Real Estate No." = '' then
            AddError(ImportLine, MissingAssetLbl)
        else
            if not FixedRealEstate.Get(ImportLine."Fixed Real Estate No.") then
                AddError(ImportLine, StrSubstNo(AssetNotFoundLbl, ImportLine."Fixed Real Estate No."))
            else
                if FixedRealEstate.Type <> FixedRealEstate.Type::Activo then
                    AddError(ImportLine, StrSubstNo(AssetTypeInvalidLbl, ImportLine."Fixed Real Estate No."));

        if ImportLine."Starting Date" = 0D then
            AddError(ImportLine, MissingStartDateLbl);

        if (ImportLine."Starting Date" <> 0D) and (ImportLine."Expiration Date" <> 0D) and
           (ImportLine."Expiration Date" < ImportLine."Starting Date")
        then
            AddError(ImportLine, ExpirationBeforeStartLbl);

        if ImportLine."Contract No." <> '' then begin
            if ExistingLeaseContract.Get(ImportLine."Contract No.") then
                if ImportLine."Created Contract No." <> ExistingLeaseContract."Contract No." then
                    AddError(ImportLine, StrSubstNo(ContractExistsLbl, ImportLine."Contract No."));
            if IsDuplicateContractNo(ImportLine) then
                AddError(ImportLine, StrSubstNo(DuplicateContractNoLbl, ImportLine."Contract No."));
        end;

        if (ImportLine."Payment Method Code" <> '') and (not PaymentMethod.Get(ImportLine."Payment Method Code")) then
            AddError(ImportLine, StrSubstNo(PaymentMethodNotFoundLbl, ImportLine."Payment Method Code"));

        if (ImportLine."Payment Terms Code" <> '') and (not PaymentTerms.Get(ImportLine."Payment Terms Code")) then
            AddError(ImportLine, StrSubstNo(PaymentTermsNotFoundLbl, ImportLine."Payment Terms Code"));

        if (ImportLine."Invoice Period Text" <> '') and
           (not TryResolveInvoicePeriod(ImportLine."Invoice Period Text", DummyInvoicePeriod))
        then
            AddError(ImportLine, StrSubstNo(InvalidInvoicePeriodLbl, ImportLine."Invoice Period Text"));

        if HasLineData(ImportLine) then begin
            if (ImportLine."Contract Import Key" = '') and (ImportLine."Contract No." = '') then
                AddError(ImportLine, MissingContractImportKeyLbl);

            if ImportLine."Line Type Text" = '' then
                AddError(ImportLine, MissingLineTypeLbl)
            else
                if not TryResolveLineType(ImportLine."Line Type Text", LeaseLineType) then
                    AddError(ImportLine, StrSubstNo(InvalidLineTypeLbl, ImportLine."Line Type Text"));

            if TryResolveLineType(ImportLine."Line Type Text", LeaseLineType) then begin
                if (not IsCommentLineType(ImportLine."Line Type Text")) and (ImportLine."Line Account No." = '') then
                    AddError(ImportLine, MissingLineAccountLbl)
                else
                    case LeaseLineType of
                        LeaseLineType::" ":
                            if (ImportLine."Line Account No." <> '') and (not StandardText.Get(ImportLine."Line Account No.")) then
                                AddError(ImportLine, StrSubstNo(LineAccountNotFoundLbl, ImportLine."Line Account No.", Format(LeaseLineType)));
                        LeaseLineType::"G/L Account":
                            if not GLAccount.Get(ImportLine."Line Account No.") then
                                AddError(ImportLine, StrSubstNo(LineAccountNotFoundLbl, ImportLine."Line Account No.", Format(LeaseLineType)));
                        LeaseLineType::"Allocation Account":
                            if not AllocationAccount.Get(ImportLine."Line Account No.") then
                                AddError(ImportLine, StrSubstNo(LineAccountNotFoundLbl, ImportLine."Line Account No.", Format(LeaseLineType)));
                    end;
            end;

            if (ImportLine."Line Starting Date" <> 0D) and (ImportLine."Line Expiration Date" <> 0D) and
               (ImportLine."Line Expiration Date" < ImportLine."Line Starting Date")
            then
                AddError(ImportLine, InvalidLineDatesLbl);

            if (ImportLine."Line Service Period Text" <> '') and
               (not EvaluateLineServicePeriod(ImportLine."Line Service Period Text", LineServicePeriod))
            then
                AddError(ImportLine, StrSubstNo(InvalidLineServicePeriodLbl, ImportLine."Line Service Period Text"));
        end;

        FinalizeStatus(ImportLine);
    end;

    local procedure ApplyHeaderDefaults(var ImportLine: Record "OD Lease Contract Import")
    begin
        if (ImportLine."Starting Date" = 0D) and (ImportLine."Contract Date" <> 0D) then
            ImportLine."Starting Date" := ImportLine."Contract Date";
    end;

    local procedure IsDuplicateContractNo(ImportLine: Record "OD Lease Contract Import"): Boolean
    var
        OtherLine: Record "OD Lease Contract Import";
        CurrentGroupId: Text;
    begin
        CurrentGroupId := GetContractGroupId(ImportLine);
        OtherLine.SetRange("Import Batch ID", ImportLine."Import Batch ID");
        OtherLine.SetRange("Contract No.", ImportLine."Contract No.");
        if OtherLine.FindSet() then
            repeat
                if OtherLine."Excel Row No." <> ImportLine."Excel Row No." then
                    if GetContractGroupId(OtherLine) <> CurrentGroupId then
                        exit(true);
            until OtherLine.Next() = 0;

        exit(false);
    end;

    local procedure GetContractGroupId(ImportLine: Record "OD Lease Contract Import"): Text
    begin
        if ImportLine."Contract Import Key" <> '' then
            exit('KEY:' + Format(ImportLine."Contract Import Key"));

        exit('CONTRACT:' + Format(ImportLine."Contract No."));
    end;

    local procedure ApplyInvoicePeriod(var LeaseContract: Record "Lease Contract"; InvoicePeriodText: Text)
    var
        InvoicePeriod: Integer;
    begin
        if not TryResolveInvoicePeriod(InvoicePeriodText, InvoicePeriod) then
            Error(InvalidInvoicePeriodLbl, InvoicePeriodText);

        case InvoicePeriod of
            1:
                LeaseContract.Validate("Invoice Period", LeaseContract."Invoice Period"::Month);
            2:
                LeaseContract.Validate("Invoice Period", LeaseContract."Invoice Period"::"Two Months");
            3:
                LeaseContract.Validate("Invoice Period", LeaseContract."Invoice Period"::Quarter);
            4:
                LeaseContract.Validate("Invoice Period", LeaseContract."Invoice Period"::"Half Year");
            5:
                LeaseContract.Validate("Invoice Period", LeaseContract."Invoice Period"::Year);
            6:
                LeaseContract.Validate("Invoice Period", LeaseContract."Invoice Period"::"None");
        end;
    end;

    local procedure TryResolveInvoicePeriod(InvoicePeriodText: Text; var InvoicePeriod: Integer): Boolean
    var
        NormalizedText: Text;
    begin
        NormalizedText := NormalizeToken(InvoicePeriodText);
        case NormalizedText of
            'MONTH', 'MES':
                InvoicePeriod := 1;
            'TWOMONTHS', 'BIMONTHLY', 'DOSMESES':
                InvoicePeriod := 2;
            'QUARTER', 'TRIMESTRE':
                InvoicePeriod := 3;
            'HALFYEAR', 'SEMESTRE':
                InvoicePeriod := 4;
            'YEAR', 'ANO', 'ANUAL':
                InvoicePeriod := 5;
            'NONE', 'NINGUNO':
                InvoicePeriod := 6;
            else
                exit(false);
        end;
        exit(true);
    end;

    local procedure TryResolveLineType(LineTypeText: Text; var LeaseLineType: Enum "Lease Contract Line Type"): Boolean
    var
        NormalizedText: Text;
    begin
        NormalizedText := NormalizeToken(LineTypeText);
        case NormalizedText of
            '0', 'COMMENT', 'COMENTARIO', 'STANDARDTEXT', 'TEXT', 'BLANK':
                LeaseLineType := LeaseLineType::" ";
            '1', 'ACCOUNT', 'CUENTA', 'GLACCOUNT', 'GACCOUNT', 'GLCUENTA', 'CUENTACONTABLE':
                LeaseLineType := LeaseLineType::"G/L Account";
            'ALLOCATIONACCOUNT', 'REPARTO', 'CUENTADEREPARTO':
                LeaseLineType := LeaseLineType::"Allocation Account";
            else
                exit(false);
        end;
        exit(true);
    end;

    local procedure IsCommentLineType(LineTypeText: Text): Boolean
    var
        NormalizedText: Text;
    begin
        NormalizedText := NormalizeToken(LineTypeText);
        exit(NormalizedText in ['0', 'COMMENT', 'COMENTARIO', 'STANDARDTEXT', 'TEXT', 'BLANK']);
    end;

    local procedure EvaluateLineServicePeriod(LineServicePeriodText: Text; var LineServicePeriod: DateFormula): Boolean
    begin
        if LineServicePeriodText = '' then begin
            Clear(LineServicePeriod);
            exit(true);
        end;

        Clear(LineServicePeriod);
        exit(Evaluate(LineServicePeriod, LineServicePeriodText));
    end;

    local procedure HasLineData(ImportLine: Record "OD Lease Contract Import"): Boolean
    begin
        exit(
            (ImportLine."Line Type Text" <> '') or
            (ImportLine."Line Account No." <> '') or
            (ImportLine."Line Description" <> '') or
            (ImportLine."Line Value" <> 0) or
            (ImportLine."Line Starting Date" <> 0D) or
            (ImportLine."Line Expiration Date" <> 0D) or
            (ImportLine."Line Service Period Text" <> '') or
            (ImportLine."Line VAT Bus. Posting Group" <> '') or
            (ImportLine."Line VAT Prod. Posting Group" <> '') or
            (ImportLine."Line Shortcut Dim. 1 Code" <> '') or
            (ImportLine."Line Shortcut Dim. 2 Code" <> '') or
            ImportLine."Line Apply Increments" or
            ImportLine."Line Apply Taxes" or
            ImportLine."Line Base Contract");
    end;

    local procedure ValidateGroupConsistency(SampleLine: Record "OD Lease Contract Import")
    var
        GroupLine: Record "OD Lease Contract Import";
    begin
        SetGroupFilter(GroupLine, SampleLine);
        if not GroupLine.FindFirst() then
            exit;

        repeat
            CompareHeaderField(SampleLine, GroupLine, SampleLine.Description, GroupLine.Description, SampleLine.FieldCaption(Description));
            CompareHeaderField(SampleLine, GroupLine, SampleLine."Customer No.", GroupLine."Customer No.", SampleLine.FieldCaption("Customer No."));
            CompareHeaderField(SampleLine, GroupLine, SampleLine."Second Customer No.", GroupLine."Second Customer No.", SampleLine.FieldCaption("Second Customer No."));
            CompareHeaderField(SampleLine, GroupLine, SampleLine."Fixed Real Estate No.", GroupLine."Fixed Real Estate No.", SampleLine.FieldCaption("Fixed Real Estate No."));
            CompareHeaderField(SampleLine, GroupLine, SampleLine."Contract Date", GroupLine."Contract Date", SampleLine.FieldCaption("Contract Date"));
            CompareHeaderField(SampleLine, GroupLine, SampleLine."Starting Date", GroupLine."Starting Date", SampleLine.FieldCaption("Starting Date"));
            CompareHeaderField(SampleLine, GroupLine, SampleLine."Expiration Date", GroupLine."Expiration Date", SampleLine.FieldCaption("Expiration Date"));
            CompareHeaderField(SampleLine, GroupLine, SampleLine."Invoice Period Text", GroupLine."Invoice Period Text", SampleLine.FieldCaption("Invoice Period Text"));
            CompareHeaderField(SampleLine, GroupLine, SampleLine."Annual Amount", GroupLine."Annual Amount", SampleLine.FieldCaption("Annual Amount"));
            CompareHeaderField(SampleLine, GroupLine, SampleLine."Payment Method Code", GroupLine."Payment Method Code", SampleLine.FieldCaption("Payment Method Code"));
            CompareHeaderField(SampleLine, GroupLine, SampleLine."Payment Terms Code", GroupLine."Payment Terms Code", SampleLine.FieldCaption("Payment Terms Code"));
        until GroupLine.Next() = 0;
    end;

    local procedure CompareHeaderField(SampleLine: Record "OD Lease Contract Import"; var GroupLine: Record "OD Lease Contract Import"; SampleValue: Variant; GroupValue: Variant; FieldCaption: Text)
    begin
        if Format(SampleValue) = Format(GroupValue) then
            exit;

        AddError(GroupLine, StrSubstNo(HeaderConflictLbl, GetReadableGroupKey(SampleLine), FieldCaption));
        FinalizeStatus(GroupLine);
        GroupLine.Modify(true);
    end;

    local procedure FindNextPendingBatchLine(BatchId: Guid; var ImportLine: Record "OD Lease Contract Import"): Boolean
    begin
        ImportLine.Reset();
        ImportLine.SetRange("Import Batch ID", BatchId);
        ImportLine.SetRange(Processed, false);
        ImportLine.SetFilter(Status, '%1|%2', ImportLine.Status::Validated, ImportLine.Status::Warning);
        ImportLine.SetCurrentKey("Import Batch ID", "Excel Row No.");
        exit(ImportLine.FindFirst());
    end;

    local procedure ProcessImportGroup(ImportLine: Record "OD Lease Contract Import"; var CreatedContractNo: Code[20]; var ProcessedCount: Integer; var CreatedCount: Integer)
    var
        GroupLine: Record "OD Lease Contract Import";
        ErrorText: Text;
    begin
        ValidateGroupConsistency(ImportLine);
        SetGroupFilter(GroupLine, ImportLine);
        GroupLine.SetFilter(Status, '%1|%2', GroupLine.Status::Validated, GroupLine.Status::Warning);
        if GroupLine.IsEmpty() then begin
            MarkGroupAsProcessed(ImportLine, '', false);
            exit;
        end;

        ClearLastError();
        if not TryCreateContractGroup(ImportLine, CreatedContractNo) then begin
            ErrorText := GetLastErrorText();
            MarkGroupAsProcessed(ImportLine, ErrorText, false);
            exit;
        end;

        MarkGroupAsProcessed(ImportLine, '', true, CreatedContractNo);
        SetGroupFilter(GroupLine, ImportLine);
        ProcessedCount += GroupLine.Count();
        CreatedCount += 1;
    end;

    local procedure MarkGroupAsProcessed(ImportLine: Record "OD Lease Contract Import"; ErrorText: Text; WasCreated: Boolean)
    begin
        MarkGroupAsProcessed(ImportLine, ErrorText, WasCreated, '');
    end;

    local procedure MarkGroupAsProcessed(ImportLine: Record "OD Lease Contract Import"; ErrorText: Text; WasCreated: Boolean; CreatedContractNo: Code[20])
    var
        GroupLine: Record "OD Lease Contract Import";
    begin
        SetGroupFilter(GroupLine, ImportLine);
        if GroupLine.FindSet() then
            repeat
                GroupLine.Processed := true;
                GroupLine."Processed At" := CurrentDateTime;
                if WasCreated then begin
                    GroupLine."Created Contract No." := CreatedContractNo;
                    GroupLine.Status := GroupLine.Status::Created;
                    GroupLine."Error Message" := '';
                end else begin
                    GroupLine.Status := GroupLine.Status::Error;
                    GroupLine."Error Message" := CopyStr(ErrorText, 1, MaxStrLen(GroupLine."Error Message"));
                end;
                GroupLine.Modify(true);
            until GroupLine.Next() = 0;
    end;

    local procedure SetGroupFilter(var GroupLine: Record "OD Lease Contract Import"; SampleLine: Record "OD Lease Contract Import")
    begin
        GroupLine.Reset();
        GroupLine.SetRange("Import Batch ID", SampleLine."Import Batch ID");
        if SampleLine."Contract Import Key" <> '' then
            GroupLine.SetRange("Contract Import Key", SampleLine."Contract Import Key")
        else
            if SampleLine."Contract No." <> '' then
                GroupLine.SetRange("Contract No.", SampleLine."Contract No.")
            else
                GroupLine.SetRange("Excel Row No.", SampleLine."Excel Row No.");
    end;

    local procedure GetReadableGroupKey(ImportLine: Record "OD Lease Contract Import"): Text
    begin
        if ImportLine."Contract Import Key" <> '' then
            exit(ImportLine."Contract Import Key");
        if ImportLine."Contract No." <> '' then
            exit(ImportLine."Contract No.");
        exit(Format(ImportLine."Excel Row No."));
    end;

    local procedure CreateImportedContractLine(LeaseContract: Record "Lease Contract"; ImportLine: Record "OD Lease Contract Import")
    var
        LeaseContractLine: Record "Lease Contract Line";
        LeaseLineType: Enum "Lease Contract Line Type";
        LineServicePeriod: DateFormula;
        LineDescription: Text[50];
        ResolvedShortcutDim1Code: Code[20];
        ResolvedShortcutDim2Code: Code[20];
    begin
        if not TryResolveLineType(ImportLine."Line Type Text", LeaseLineType) then
            Error(InvalidLineTypeLbl, ImportLine."Line Type Text");

        LeaseContractLine.Init();
        LeaseContractLine."Contract No." := LeaseContract."Contract No.";
        LeaseContractLine."Line No." := GetNextLeaseContractLineNo(LeaseContract."Contract No.");
        if ImportLine."Line Description" <> '' then
            LineDescription := CopyStr(ImportLine."Line Description", 1, MaxStrLen(LineDescription))
        else
            if ImportLine."Line Account No." <> '' then
                LineDescription := CopyStr(ImportLine."Line Account No.", 1, MaxStrLen(LineDescription));

        if LineDescription = '' then
            LineDescription := CopyStr(DefaultImportedLineDescriptionLbl, 1, MaxStrLen(LineDescription));
        LeaseContractLine.Description := LineDescription;
        LeaseContractLine.Insert(true);
        LeaseContractLine.Validate(Type, LeaseLineType);
        if not IsCommentLineType(ImportLine."Line Type Text") then
            LeaseContractLine.Validate("Account No.", ImportLine."Line Account No.")
        else
            if ImportLine."Line Account No." <> '' then
                LeaseContractLine.Validate("Account No.", ImportLine."Line Account No.");
        if ImportLine."Line Description" <> '' then
            LeaseContractLine.Validate(Description, ImportLine."Line Description");
        LeaseContractLine."Customer No." := LeaseContract."Customer No.";
        LeaseContractLine."Contract Status" := LeaseContract.Status;
        LeaseContractLine."Starting Date" := SelectLineStartDate(ImportLine, LeaseContract);
        LeaseContractLine."Contract Expiration Date" := SelectLineEndDate(ImportLine, LeaseContract);
        LeaseContractLine."Credit Memo Date" := LeaseContractLine."Contract Expiration Date";
        if EvaluateLineServicePeriod(ImportLine."Line Service Period Text", LineServicePeriod) and (ImportLine."Line Service Period Text" <> '') then
            LeaseContractLine."Service Period" := LineServicePeriod;
        ResolvedShortcutDim1Code := ResolveImportedShortcutDimensionCode(1, ImportLine."Line Shortcut Dim. 1 Code", LeaseContract."Fixed Real Estate No.");
        if ResolvedShortcutDim1Code <> '' then
            LeaseContractLine.Validate("Shortcut Dimension 1 Code", ResolvedShortcutDim1Code);
        ResolvedShortcutDim2Code := ResolveImportedShortcutDimensionCode(2, ImportLine."Line Shortcut Dim. 2 Code", LeaseContract."Fixed Real Estate No.");
        if ResolvedShortcutDim2Code <> '' then
            LeaseContractLine.Validate("Shortcut Dimension 2 Code", ResolvedShortcutDim2Code);
        LeaseContractLine."Aplicar incrementos" := ImportLine."Line Apply Increments";
        LeaseContractLine."Base Contract" := ImportLine."Line Base Contract";
        if ImportLine."Line Value" = 0 then begin
            LeaseContractLine.Value := 0;
            LeaseContractLine.Amount := 0;
            LeaseContractLine."VAT Bus. Posting Group" := ImportLine."Line VAT Bus. Posting Group";
            LeaseContractLine."VAT Prod. Posting Group" := ImportLine."Line VAT Prod. Posting Group";
            LeaseContractLine."Aplicar Impuestos" := ImportLine."Line Apply Taxes";
        end else begin
            if ImportLine."Line VAT Bus. Posting Group" <> '' then
                LeaseContractLine.Validate("VAT Bus. Posting Group", ImportLine."Line VAT Bus. Posting Group");
            if ImportLine."Line VAT Prod. Posting Group" <> '' then
                LeaseContractLine.Validate("VAT Prod. Posting Group", ImportLine."Line VAT Prod. Posting Group");
            LeaseContractLine.Validate(Value, ImportLine."Line Value");
            if ImportLine."Line Apply Taxes" then
                LeaseContractLine.Validate("Aplicar Impuestos", true)
            else
                LeaseContractLine."Aplicar Impuestos" := false;
        end;
        LeaseContractLine.Modify(true);
    end;

    local procedure GetNextLeaseContractLineNo(ContractNo: Code[20]): Integer
    var
        LeaseContractLine: Record "Lease Contract Line";
    begin
        LeaseContractLine.SetRange("Contract No.", ContractNo);
        if LeaseContractLine.FindLast() then
            exit(LeaseContractLine."Line No." + 10000);

        exit(10000);
    end;

    local procedure SelectLineStartDate(ImportLine: Record "OD Lease Contract Import"; LeaseContract: Record "Lease Contract"): Date
    begin
        if ImportLine."Line Starting Date" <> 0D then
            exit(ImportLine."Line Starting Date");

        exit(LeaseContract."Starting Date");
    end;

    local procedure SelectLineEndDate(ImportLine: Record "OD Lease Contract Import"; LeaseContract: Record "Lease Contract"): Date
    begin
        if ImportLine."Line Expiration Date" <> 0D then
            exit(ImportLine."Line Expiration Date");

        exit(LeaseContract."Expiration Date");
    end;

    local procedure ResolveImportedShortcutDimensionCode(GlobalDimensionNo: Integer; ImportedCode: Code[20]; LeaseContractFixedRealEstateNo: Code[20]): Code[20]
    var
        FixedRealEstate: Record "Fixed Real Estate";
    begin
        if ImportedCode = '' then
            exit('');

        if IsValidShortcutDimensionValue(GlobalDimensionNo, ImportedCode) then
            exit(ImportedCode);

        if TryGetFixedRealEstateFromImportedCode(ImportedCode, FixedRealEstate) then
            exit(GetFixedRealEstateShortcutDimensionCode(GlobalDimensionNo, FixedRealEstate));

        if (LeaseContractFixedRealEstateNo <> '') and TryGetFixedRealEstateFromImportedCode(LeaseContractFixedRealEstateNo, FixedRealEstate) then
            exit(GetFixedRealEstateShortcutDimensionCode(GlobalDimensionNo, FixedRealEstate));

        exit('');
    end;

    local procedure IsValidShortcutDimensionValue(GlobalDimensionNo: Integer; DimensionValueCode: Code[20]): Boolean
    var
        DimensionValue: Record "Dimension Value";
    begin
        if DimensionValueCode = '' then
            exit(false);

        DimensionValue.SetRange("Global Dimension No.", GlobalDimensionNo);
        DimensionValue.SetRange(Code, DimensionValueCode);
        DimensionValue.SetRange(Blocked, false);
        exit(not DimensionValue.IsEmpty());
    end;

    local procedure TryGetFixedRealEstateFromImportedCode(ImportedCode: Code[20]; var FixedRealEstate: Record "Fixed Real Estate"): Boolean
    var
        ResolvedRealEstateNo: Code[20];
    begin
        if ImportedCode = '' then
            exit(false);

        if FixedRealEstate.Get(ImportedCode) then
            exit(true);

        ResolvedRealEstateNo := ResolveFixedRealEstateNoFromFALink(ImportedCode);
        if (ResolvedRealEstateNo = '') or (ResolvedRealEstateNo = GetMultipleLinkMarker()) then
            exit(false);

        exit(FixedRealEstate.Get(ResolvedRealEstateNo));
    end;

    local procedure GetFixedRealEstateShortcutDimensionCode(GlobalDimensionNo: Integer; FixedRealEstate: Record "Fixed Real Estate"): Code[20]
    begin
        case GlobalDimensionNo of
            1:
                exit(FixedRealEstate."Global Dimension 1 Code");
            2:
                exit(FixedRealEstate."Global Dimension 2 Code");
        end;

        exit('');
    end;

    local procedure ClearLineMessages(var ImportLine: Record "OD Lease Contract Import")
    begin
        ImportLine."Error Message" := '';
        ImportLine."Warning Message" := '';
        ImportLine.Status := ImportLine.Status::Pending;
    end;

    local procedure ResolveFixedRealEstateNoFromFALink(FANo: Code[20]): Code[20]
    var
        RealEstateLink: Record "OD RE FA Link";
        PrimaryRealEstateNo: Code[20];
        MatchCount: Integer;
    begin
        if FANo = '' then
            exit('');

        RealEstateLink.SetRange("FA No.", FANo);
        RealEstateLink.SetRange(Active, true);
        if not RealEstateLink.FindSet() then
            exit('');

        repeat
            MatchCount += 1;
            if RealEstateLink."Primary Link" then begin
                if PrimaryRealEstateNo <> '' then
                    exit(GetMultipleLinkMarker());
                PrimaryRealEstateNo := RealEstateLink."Real Estate No.";
            end;
        until RealEstateLink.Next() = 0;

        if MatchCount = 1 then begin
            RealEstateLink.FindFirst();
            exit(RealEstateLink."Real Estate No.");
        end;

        if PrimaryRealEstateNo <> '' then
            exit(PrimaryRealEstateNo);

        exit(GetMultipleLinkMarker());
    end;

    local procedure GetMultipleLinkMarker(): Code[20]
    begin
        exit('*MULTIPLE*');
    end;

    local procedure AddError(var ImportLine: Record "OD Lease Contract Import"; ErrorText: Text)
    begin
        ImportLine."Error Message" := AppendMessage(ImportLine."Error Message", ErrorText, MaxStrLen(ImportLine."Error Message"));
    end;

    local procedure AppendMessage(CurrentText: Text; NewText: Text; MaxLength: Integer): Text
    begin
        if NewText = '' then
            exit(CurrentText);
        if CurrentText = '' then
            exit(CopyStr(NewText, 1, MaxLength));
        exit(CopyStr(CurrentText + ' | ' + NewText, 1, MaxLength));
    end;

    local procedure FinalizeStatus(var ImportLine: Record "OD Lease Contract Import")
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
}
