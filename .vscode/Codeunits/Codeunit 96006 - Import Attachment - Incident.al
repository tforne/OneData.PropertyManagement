codeunit 96006 "Management - Incident"
{
    TableNo = "Incident Attachment";

    trigger OnRun()
    var
        FileName: Text;
        FileUp: FileUpload;
        TempBlob: Codeunit "Temp Blob";
    begin
        UploadFileSaaS(Rec, FileName, TempBlob);
        if FileName = '' then
            exit;
        ImportAttachment(Rec, FileName, TempBlob);
    end;

    var
        ReplaceContentQst: Label 'Do you want to replace the file content?';
        ImportTxt: Label 'Insert File';
        FileDialogTxt: Label 'Attachments (%1)|%1', Comment = '%1=file types, such as *.txt or *.docx';
        FilterTxt: Label '*.jpg;*.jpeg;*.bmp;*.png;*.gif;*.tiff;*.tif;*.pdf;*.docx;*.doc;*.xlsx;*.xls;*.pptx;*.ppt;*.msg;*.xml;*.*', Locked = true;
        NotSupportedDocTableErr: Label 'Table no. %1 is not supported.', Comment = '%1 is a number (integer).';
        PhotoLbl: Label 'Photo %1', Comment = '%1 = a number, e.g. 1, 2, 3,...';
        EmptyFileMsg: Label 'You have created an incident based on an empty file. Try again with a file that contains data that you want to import.';
        ChooseFileTitleMsg: Label 'Choose the file to upload.';
        IsTestMode: Boolean;


    // internal procedure ImportAttachment(var IncidentAttachment: Record "Incident Attachment"; var FileName:Text; var TempBlob : Codeunit "Temp Blob"): Boolean
    // begin
    //     // Default to MS-DOS encoding to keep consistent with the previous behavior
    //     exit(ImportAttachment(IncidentAttachment, FileName, TextEncoding::MSDos,TempBlob));
    // end;

    internal procedure ImportAttachment(var IncidentAttachment: Record "Incident Attachment"; var FileName : Text; Encoding: TextEncoding; var TempBlob : Codeunit "Temp Blob"): Boolean
    var
        TempInStream: InStream;
        TempOutStream: OutStream;
    begin
        // TempBlob.CreateInStream(TempInStream, Encoding);
        // TempBlob.CreateOutStream(TempOutStream, Encoding);
        // CopyStream(TempOutStream, TempInStream);

        CheckFileContentBeforeUploadFile(IncidentAttachment);
        IncidentAttachment.SetContentFromBlob(TempBlob);
        exit(ImportAttachment(IncidentAttachment, FileName, TempBlob));
    end;

    procedure UploadFileSaaS(var IncidentAttachment: Record "Incident Attachment"; var FileName: Text; var TempBlob: Codeunit "Temp Blob")
    var
        FileManagement: Codeunit "File Management";
    begin
        CheckFileContentBeforeUploadFile(IncidentAttachment);

        FileName := FileManagement.BLOBImportWithFilter(
            TempBlob, ImportTxt, FileName, StrSubstNo(FileDialogTxt, FilterTxt), FilterTxt);

        if FileName = '' then
            exit;

        if not TempBlob.HasValue() then
            Error('No se ha podido cargar el archivo.');
    end;

    // procedure UploadFileSaaS(var IncidentAttachment: Record "Incident Attachment"; var FileName: Text)
    // var
    //     TempBlob: Codeunit "Temp Blob";
    //     FileManagement: Codeunit "File Management";
  
    //     InStr: InStream;
    //     OutStr: OutStream;
    //     Incident : Record "Incident Assets Real Estate";

    // begin
    //     CheckFileContentBeforeUploadFile(IncidentAttachment);

    //     // if not UploadIntoStream(ImportTxt, '', FilterTxt, FileName, InStr) then
    //     //     exit;

        
    //     FileName := FileManagement.BLOBImportWithFilter(
    //         TempBlob, ImportTxt, FileName, StrSubstNo(FileDialogTxt, FilterTxt), FilterTxt);

    //     TempBlob.CreateOutStream(OutStr);
    //     // CopyStream(OutStr, InStr);

    //     if FileName = '' then
    //     exit;
    //     if not TempBlob.HasValue() then
    //         Error('No se ha podido cargar el archivo.');

    //     IncidentAttachment.SetContentFromBlob(TempBlob);
    // end;
    
    local procedure CheckFileContentBeforeUploadFile(var IncidentAttachment: Record "Incident Attachment")
    begin
        OnBeforeUploadFile(IncidentAttachment);
        IncidentAttachment.CalcFields(Content);
        if IncidentAttachment.Content.HasValue() then begin
            if not Confirm(ReplaceContentQst, false) then
                Error('');
        end;
    end;

    
    procedure ImportAttachment(var IncidentAttachment: Record "Incident Attachment"; FileName: Text[250]; var TempBlob: Codeunit "Temp Blob"): Boolean
    var
        Incident: Record "Incident Assets Real Estate";
        EmptyFileNameErr: Label 'A file name must be provided.';
    begin
        
        if FileName = '' then
            Error(EmptyFileNameErr);

        FindOrCreateIncidentAttachment(IncidentAttachment, Incident);
        exit(SaveDocumentAttachment(Incident, IncidentAttachment, FileName, TempBlob, true));
    end;

    local procedure SaveDocumentAttachment(var Incident: Record "Incident Assets Real Estate"; var IncidentAttachment: Record "Incident Attachment"; FileName: Text; var TempBlob: Codeunit "Temp Blob"; ReplaceContent: Boolean): Boolean
    var
        FileManagement: Codeunit "File Management";
        RecordRef: RecordRef;
    begin

        IncidentAttachment."Incident Id." := Incident."Incident Id.";
        IncidentAttachment."Line No." := GetIncidentNextLineNo(Incident);

        if ReplaceContent then begin
            RecordRef.GetTable(IncidentAttachment);
            TempBlob.ToRecordRef(RecordRef, IncidentAttachment.FieldNo(IncidentAttachment.Content));
            RecordRef.SetTable(IncidentAttachment);
        end;

        // Tfm
        // if not IncidentAttachment.Content.HasValue() then begin
        //     Message(EmptyFileMsg);
        //     if not IsTestMode then
        //         IncidentAttachment.Delete();
        //     exit(false);
        // end;

        IncidentAttachment.Validate("File Extension", LowerCase(CopyStr(FileManagement.GetExtension(FileName), 1, MaxStrLen(IncidentAttachment."File Extension"))));
        if IncidentAttachment.Name = '' then
            IncidentAttachment.Name := CopyStr(FileManagement.GetFileNameWithoutExtension(FileName), 1, MaxStrLen(IncidentAttachment.Name));

        if Incident.Description = '' then begin
            Incident.Description := CopyStr(IncidentAttachment.Name, 1, MaxStrLen(Incident.Description));
            Incident.Modify();
        end;

        if IncidentAttachment.Type in [IncidentAttachment.Type::Image, IncidentAttachment.Type::PDF] then
            IncidentAttachment.OnAttachBinaryFile();

        IncidentAttachment.Insert(true);
        OnAfterImportAttachment(IncidentAttachment);
        exit(true);
    end;

    procedure CreateNewAttachment(var IncidentAttachment: Record "Incident Attachment")
    var
        Incident: Record "Incident Assets Real Estate";
    begin
        Incident.Init();

        FindOrCreateIncidentAttachment(IncidentAttachment, Incident);

        IncidentAttachment."Incident Id." := Incident."Incident Id.";

        IncidentAttachment."Line No." := GetIncidentNextLineNo(Incident);
    end;

    local procedure FindOrCreateIncidentAttachment(var IncidentAttachment: Record "Incident Attachment"; var Incident: Record "Incident Assets Real Estate")
    var
        DocNo: Code[20];
        PostingDate: Date;
    begin
        if FindUsingIncidentAttNoFilter(IncidentAttachment, Incident) then
            exit;
        if FindUsingDocNoFilter(IncidentAttachment, Incident, PostingDate, DocNo) then
            exit;
        CreateIncident(IncidentAttachment, Incident, PostingDate, DocNo);
    end;

    local procedure FindInIncidentAttachmentUsingIncidentNoFilter(var IncidentAttachment: Record "Incident Attachment"; var Incident: Record "Incident Assets Real Estate"): Boolean
    var
        IncidentId: Guid;
    begin
       
        if IncidentAttachment.GetFilter("Incident Id.") <> '' then begin
            IncidentId := IncidentAttachment.GetRangeMin("Incident Id.");
            if IncidentId <> '00000000-0000-0000-0000-000000000000' then
                exit(Incident.Get(IncidentId));
        end;
        exit(false);
    end;


    local procedure FindUsingIncidentAttNoFilter(var IncidentAttachment: Record "Incident Attachment"; var Incident: Record "Incident Assets Real Estate"): Boolean
    var
        FilterGroupID: Integer;
        Found: Boolean;
        IncidentId: Guid;
    begin
        IncidentAttachment.FilterGroup(0);
        if IncidentAttachment.GetFilter("Incident Id.") <> '' then begin
            IncidentId := IncidentAttachment.GetRangeMin("Incident Id.");
            if IncidentId <> '00000000-0000-0000-0000-000000000000' then
                exit(Incident.Get(IncidentId));
        end;

        exit(false);
    end;

    local procedure FindUsingDocNoFilter(var IncidentAttachment: Record "Incident Attachment"; var Incident: Record "Incident Assets Real Estate"; var PostingDate: Date; var DocNo: Code[20]): Boolean
    var
        FilterGroupID: Integer;
        IsFound: Boolean;
        IsHandled: Boolean;
    begin
        for FilterGroupID := 0 to 2 do begin
            IncidentAttachment.FilterGroup(FilterGroupID * 2);
            if (IncidentAttachment.GetFilter("Document No.") <> '') and
               (IncidentAttachment.GetFilter("Posting Date") <> '')
            then begin
                DocNo := IncidentAttachment.GetRangeMin("Document No.");
                PostingDate := IncidentAttachment.GetRangeMin("Posting Date");
                if DocNo <> '' then
                    break;
            end;
        end;
        IncidentAttachment.FilterGroup(0);

        if (DocNo = '') or (PostingDate = 0D) then
            exit(false);

        IsHandled := false;
        OnFindUsingDocNoFilterOnBeforeFind(IncidentAttachment, Incident, PostingDate, DocNo, IsFound, IsHandled);
        if IsHandled then
            exit(IsFound);

        exit(Incident.FindFirst());
    end;

    
    local procedure CreateIncident(var IncidentAttachment: Record "Incident Attachment"; var Incident: Record "Incident Assets Real Estate"; PostingDate: Date; DocNo: Code[20])
    var
        DummyRecordID: RecordID;
    begin
        CreateIncidentExtended(IncidentAttachment, Incident, PostingDate, DocNo, DummyRecordID);
    end;

    procedure CreateIncidentExtended(var IncidentAttachment: Record "Incident Attachment"; var Incident: Record "Incident Assets Real Estate"; PostingDate: Date; DocNo: Code[20]; RelatedRecordID: RecordID)
    var
        DataTypeManagement: Codeunit "Data Type Management";
        RelatedRecordRef: RecordRef;
        RelatedRecord: Variant;
    begin
        Incident.CreateIncident(IncidentAttachment,IncidentAttachment.Name, '');
        Incident.StateCode := Incident.StateCode::Active;
        Incident.Modify();
    end;

    
    
    local procedure GetIncidentNextLineNo(Incident: Record "Incident Assets Real Estate"): Integer
    var
        IncidentAttachment: Record "Incident Attachment";
    begin
        IncidentAttachment.SetRange("Incident id.", Incident."Incident Id.");
        if IncidentAttachment.FindLast() then;
        exit(IncidentAttachment."Line No." + LineIncrement());
    end;

    local procedure LineIncrement(): Integer
    begin
        exit(10000);
    end;

    procedure ProcessAndUploadPicture(PictureStream: InStream; var IncidentAttachmentOriginal: Record "Incident Attachment")
    var
        IncidentAttachment: Record "Incident Attachment";
        OutStr: OutStream;
    begin
        IncidentAttachment.Init();
        IncidentAttachment.CopyFilters(IncidentAttachmentOriginal);
        CreateNewAttachment(IncidentAttachment);
        IncidentAttachment.Name :=
          CopyStr(StrSubstNo(PhotoLbl, IncidentAttachment."Line No." div 10000), 1, MaxStrLen(IncidentAttachment.Name));
        IncidentAttachment.Validate("File Extension", 'jpg');

        IncidentAttachment.Content.CreateOutStream(OutStr);
        CopyStream(OutStr, PictureStream);

        IncidentAttachment.Insert(true);
        Commit();
    end;

    [Scope('OnPrem')]
    procedure SetTestMode()
    begin
        IsTestMode := true;
    end;

    [IntegrationEvent(false, false)]
    local procedure OnAfterImportAttachment(var IncidentAttachment: Record "Incident Attachment")
    begin
    end;

    
    [IntegrationEvent(false, false)]
    local procedure OnBeforeUploadFile(var IncidentAttachment: Record "Incident Attachment")
    begin
    end;

    [IntegrationEvent(false, false)]
    local procedure OnFindUsingDocNoFilterOnBeforeFind(var IncidentAttachment: Record "Incident Attachment"; var Incident: Record "Incident Assets Real Estate"; PostingDate: Date; DocNo: Code[20]; var IsFound: Boolean; var IsHandled: Boolean)
    begin
    end;

}

