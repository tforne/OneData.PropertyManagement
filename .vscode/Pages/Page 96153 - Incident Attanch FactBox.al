page 96153 "Incident Attach. FactBox"
{
    Caption = 'Incident Files';
    Editable = false;
    PageType = ListPart;
    SourceTable = "Incident Attachment Overview";
    SourceTableTemporary = true;

    layout
    {
        area(content)
        {
            repeater(Group)
            {
                IndentationColumn = Rec.Indentation;
                IndentationControls = Name;
                field(Name; Rec.Name)
                {
                    ApplicationArea = Basic, Suite;
                    StyleExpr = StyleExpressionTxt;
                    ToolTip = 'Specifies the name of the attached file.';

                    trigger OnDrillDown()
                    begin
                        Rec.NameDrillDown();
                    end;
                }
                field(Type; Rec.Type)
                {
                    ApplicationArea = Basic, Suite;
                    ToolTip = 'Specifies the type of the attached file.';
                    Visible = false;
                }
                field("File Extension"; Rec."File Extension")
                {
                    ApplicationArea = Basic, Suite;
                    ToolTip = 'Specifies the file extension of the attached file.';
                    Visible= true;
                }
                field("Size (KB)"; SizeFile)
                {
                    ApplicationArea = Basic, Suite;
                    ToolTip = 'Specifies the size of the attached file in kilobytes.';
                    Editable = false;
                }
                field("Created Date-Time"; Rec."Created Date-Time")
                {
                    ApplicationArea = Basic, Suite;
                    ToolTip = 'Specifies when the incoming document line was created.';
                    Visible = false;
                }
            }
        }
    }

    actions
    {
        area(processing)
        {
            action(UploadMainAttachment)
            {
                ApplicationArea = Basic, Suite;
                Caption = 'Upload main attachment';
                Image = Attach;
                ToolTip = 'Attach a file as the main attachment to the incoming document record.';
                Enabled = not HasMainAttachment;

                trigger OnAction()
                begin
                    UploadSingleAttachment();
                end;
            }
            fileuploadaction(UploadSupportingAttachments)
            {
                ApplicationArea = Basic, Suite;
                Caption = 'Upload supporting attachments';
                AllowMultipleFiles = true;
                Visible = true;
                Image = Import;
                Enabled = HasMainAttachment;
                ToolTip = 'Attach one or more files as the supporting attachments to the incoming document record.';

                trigger OnAction(files: List of [FileUpload])
                begin
                    UploadMultipleAttachments(files);
                end;
            }
#if not CLEAN25
            action(ImportNew)
            {
                ObsoleteState = Pending;
                ObsoleteReason = 'Action ImportNew is replaced by action UploadMainAttachment and UploadSupportingAttachments.';
                ObsoleteTag = '25.0';
                ApplicationArea = Basic, Suite;
                Caption = 'Attach File';
                Image = Attach;
                ToolTip = 'Attach a file to the incoming document record.';
                Visible = false;

                trigger OnAction()
                begin
                    UploadSingleAttachment();
                end;
            }
#endif
            action(IncomingDoc)
            {
                ApplicationArea = Basic, Suite;
                Caption = 'Incoming Document';
                Image = Document;
                Enabled = HasAttachments;
                Scope = Repeater;
                ToolTip = 'View or create an incoming document record that is linked to the entry or document.';

                trigger OnAction()
                var
                    Incident: Record "Incident Assets Real Estate";
                begin
                    if not Incident.Get(Rec."Incident Id.") then
                        exit;
                    PAGE.RunModal(PAGE::"RE Incident Card", Incident);

                    if Incident.Get(Incident."Incident Id.") then
                        LoadDataFromIncident(Incident);
                end;
            }
            action(OpenInOneDrive)
            {
                ApplicationArea = Basic, Suite;
                Caption = 'Open in OneDrive';
                ToolTip = 'Copy the file to your Business Central folder in OneDrive and open it in a new window so you can manage or share the file.', Comment = 'OneDrive should not be translated';
                Image = Cloud;
                Visible = ShareOptionsEnabled;
                Scope = Repeater;
                trigger OnAction()
                var
                    IncidentAttachment: Record "Incident Attachment";
                    FileManagement: Codeunit "File Management";
                    DocumentServiceMgt: Codeunit "Document Service Management";
                    FileName: Text;
                    FileExtension: Text;
                    InStream: InStream;
                begin
                    IncidentAttachment.Get(Rec."Incident Id.", Rec."Line No.");
                    IncidentAttachment.CalcFields(Content);
                    IncidentAttachment.Content.CreateInStream(InStream);

                    FileName := FileManagement.StripNotsupportChrInFileName(Rec.Name);
                    FileExtension := StrSubstNo(FileExtensionLbl, Rec."File Extension");
                    DocumentServiceMgt.OpenInOneDrive(FileName, FileExtension, InStream);
                end;
            }
            action(ShareToOneDrive)
            {
                ApplicationArea = Basic, Suite;
                Caption = 'Share';
                ToolTip = 'Copy the file to your Business Central folder in OneDrive and share the file. You can also see who it''s already shared with.', Comment = 'OneDrive should not be translated';
                Image = Share;
                Visible = ShareOptionsEnabled;
                Scope = Repeater;
                trigger OnAction()
                var
                    IncomingDocumentAttachment: Record "Incoming Document Attachment";
                    FileManagement: Codeunit "File Management";
                    DocumentServiceMgt: Codeunit "Document Service Management";
                    FileName: Text;
                    FileExtension: Text;
                    InStream: InStream;
                begin
                    IncomingDocumentAttachment.Get(Rec."Incident Id.", Rec."Line No.");
                    IncomingDocumentAttachment.CalcFields(Content);
                    IncomingDocumentAttachment.Content.CreateInStream(InStream);

                    FileName := FileManagement.StripNotsupportChrInFileName(Rec.Name);
                    FileExtension := StrSubstNo(FileExtensionLbl, Rec."File Extension");
                    DocumentServiceMgt.ShareWithOneDrive(FileName, FileExtension, InStream);
                end;
            }
            action(OpenInFileViewer)
            {
                ApplicationArea = Basic, Suite;
                Caption = 'View';
                Image = View;
                Enabled = ViewEnabled;
                Scope = Repeater;
                ToolTip = 'View the file. You will be able to download the file from the viewer control. Works only on limited number of file types.';

                trigger OnAction()
                begin
                    Rec.NameDrillDown();
                end;
            }
            action(Export)
            {
                ApplicationArea = Basic, Suite;
                Caption = 'Download';
                Image = Download;
                Enabled = DownloadEnabled;
                Scope = Repeater;
                ToolTip = 'Download the file to your device. Depending on the file, you will need an app to view or edit the file.';

                trigger OnAction()
                begin
                     Rec.NameDrillDown(true);
                end;
            }
        }
    }

    trigger OnAfterGetRecord()
    var
        IncidentAttachment: Record "Incident Attachment";
        DocumentSharing: Codeunit "Document Sharing";
        InS: InStream;
    begin
        StyleExpressionTxt := Rec.GetStyleTxt();

        ShareOptionsEnabled := (not Rec.IsGroupOrLink()) and (IncidentAttachment.Get(Rec."Incident Id.", Rec."Line No.")) and (DocumentSharing.ShareEnabled());
        DownloadEnabled := (not Rec.IsGroupOrLink()) and (IncidentAttachment.Get(Rec."Incident Id.", Rec."Line No."));
        ViewEnabled := DownloadEnabled and IncidentAttachment.SupportedByFileViewer();
        HasMainAttachment := Rec.Count() > 0;
        SizeFile := 0;
        if IncidentAttachment.Get(Rec."Incident Id.", Rec."Line No.") then begin
            IncidentAttachment.CalcFields(Content);
            if IncidentAttachment.Content.HasValue then begin
                IncidentAttachment.Content.CreateInStream(InS);
                SizeFile := InS.Length;
            end;
        end;
    end;

    trigger OnFindRecord(Which: Text): Boolean
    begin
        if LoadedDataFromRecord then begin
            HasAttachments := Rec.FindFirst();
            exit(HasAttachments);
        end;

        if not FilterWasChanged() then
            exit(HasAttachments);

        PreviousViewFilter := Rec.GetView();
        HasAttachments := LoadDataFromOnFindRecord();
        HasMainAttachment := Rec.Count() > 0;
        exit(HasAttachments);
    end;

    var
        MainRecordRef: RecordRef;
        GlobalRecordID: RecordID;
        StyleExpressionTxt: Text;
        FileExtensionLbl: Label '.%1', Locked = true;
        CreateMainDocumentFirstErr: Label 'You must fill in any field to create a main record before you try to attach a document. Refresh the page and try again.';
        LoadedDataFromRecord: Boolean;
        HasAttachments: Boolean;
        ShareOptionsEnabled: Boolean;
        DownloadEnabled: Boolean;
        ViewEnabled: Boolean;
        PreviousViewFilter: text;
        GlobalDocumentNo: text;
        GlobalPostingDate: Date;
        HasMainAttachment: Boolean;
        SizeFile : Decimal;

    local procedure PrepareIncDocAttachmentBeforeUpload(var IncidentAttachment: Record "Incident Attachment")
    begin
        IncidentAttachment.SetRange("Incident Id.", Rec."Incident Id.");
        if GlobalRecordID.TableNo <> 0 then
            MainRecordRef := GlobalRecordID.GetRecord()
        else begin
            if GlobalDocumentNo <> '' then
                IncidentAttachment.SetRange("Document No.", GlobalDocumentNo);
            if GlobalPostingDate <> 0D then
                IncidentAttachment.SetRange("Posting Date", GlobalPostingDate);
        end;

        IncidentAttachment.SetFiltersFromMainRecord(MainRecordRef, IncidentAttachment);

        // check MainRecordRef is initialized
        if MainRecordRef.Number <> 0 then
            if not MainRecordRef.Get(MainRecordRef.RecordId) then
                Error(CreateMainDocumentFirstErr);
    end;

    local procedure UploadSingleAttachment()
    var
        IncidentAttachment: Record "Incident Attachment";
        Incident: Record "Incident Assets Real Estate";
    begin
        PrepareIncDocAttachmentBeforeUpload(IncidentAttachment);

        if IncidentAttachment.Import(true) then
            if Incident.Get(IncidentAttachment."Incident Id.") then
                LoadDataFromIncident(Incident);
    end;

    local procedure UploadMultipleAttachments(Files: List of [FileUpload])
    var
        IncidentAttachment: Record "Incident Attachment";
        Incident: Record "Incident Assets Real Estate";
        ImportAttachmentIncident: Codeunit "Management - Incident";
    begin
        PrepareIncDocAttachmentBeforeUpload(IncidentAttachment);

        if ImportAttachmentIncident.ImportMultiple(IncidentAttachment, true, Files) then
            if Incident.Get(IncidentAttachment."Incident Id.") then
                LoadDataFromIncident(Incident);
    end;

    procedure LoadDataFromOnFindRecord(): Boolean
    var
        Incident: Record "Incident Assets Real Estate";
        IncomingDocumentFound: Boolean;
        CurrentFilterGroup: Integer;
    begin
        CurrentFilterGroup := Rec.FilterGroup();
        Rec.FilterGroup(4);
        IncomingDocumentFound := FindIncidentsFromFilters(Incident);
        GlobalDocumentNo := Rec.GetFilter("Document No.");
        Clear(GlobalPostingDate);
        if Rec.GetFilter("Posting Date") <> '' then
            if Evaluate(GlobalPostingDate, Rec.GetFilter("Posting Date")) then;

        Rec.FilterGroup(CurrentFilterGroup);

        Rec.Reset();
        Rec.DeleteAll();

        if not IncomingDocumentFound then
            exit(false);

        Rec.InsertFromIncident(Incident, Rec);
        exit(not Rec.IsEmpty());
    end;

    local procedure FindIncidentsFromFilters(var Incident: Record "Incident Assets Real Estate"): Boolean
    var
        IncomingDocumentEntryNo: Text;
    begin
        IncomingDocumentEntryNo := Rec.GetFilter("Incident Id.");
        if IncomingDocumentEntryNo <> '' then
            exit(Incident.Get(IncomingDocumentEntryNo));

        // exit(Incident.FindByDocumentNoAndPostingDate(Incident, Rec.GetFilter("Document No."), Rec.GetFilter("Posting Date")));
        exit(false)
    end;

    local procedure FilterWasChanged(): Boolean
    var
        CurrentFilterGroup: Integer;
        CurrentViewFilter: Text;
    begin
        CurrentFilterGroup := Rec.FilterGroup();
        Rec.FilterGroup(4);
        CurrentViewFilter := Rec.GetView();
        Rec.FilterGroup(CurrentFilterGroup);
        exit(PreviousViewFilter <> CurrentViewFilter);
    end;

    procedure LoadDataFromRecord(MainRecordVariant: Variant)
    var
        Incident: Record "Incident Assets Real Estate";
        DataTypeManagement: Codeunit "Data Type Management";
    begin
        LoadedDataFromRecord := true;

        if not DataTypeManagement.GetRecordRef(MainRecordVariant, MainRecordRef) then
            exit;

        OnLoadDataFromRecordOnBeforeDeleteAll(Rec);
        Rec.DeleteAll();

        if not MainRecordRef.Get(MainRecordRef.RecordId) then
            exit;

        if GetIncidentRecord(MainRecordVariant, Incident) then
            Rec.InsertFromIncident(Incident, Rec);
        OnAfterLoadDataFromRecord(MainRecordRef);
        CurrPage.Update(false);
    end;

    procedure SetCurrentRecordID(NewRecordID: RecordID)
    begin
        if GlobalRecordID = NewRecordID then
            exit;

        GlobalRecordID := NewRecordID;
    end;

    procedure LoadDataFromIncident(Incident: Record "Incident Assets Real Estate")
    begin
        OnLoadDataFromIncomingDocumentOnBeforeDeleteAll(Rec);
        Rec.DeleteAll();
        Rec.InsertFromIncident(Incident, Rec);
        CurrPage.Update(false);
    end;

    procedure GetIncidentRecord(MainRecordVariant: Variant; var Incident: Record "Incident Assets Real Estate"): Boolean
    var
        DataTypeManagement: Codeunit "Data Type Management";
    begin
        if not DataTypeManagement.GetRecordRef(MainRecordVariant, MainRecordRef) then
            exit(false);

        if MainRecordRef.Number = DATABASE::"Incoming Document" then begin
            Incident.Copy(MainRecordVariant);
            exit(true);
        end;

        exit(GetIncidentRecordFromRecordRef(Incident, MainRecordRef));
    end;

    procedure RecordHasMainAttachment()
    begin
        HasMainAttachment := Rec.Count() > 0;
    end;

    local procedure GetIncidentRecordFromRecordRef(var Incident: Record "Incident Assets Real Estate"; MainRecordRef: RecordRef): Boolean
    begin
        // if Incident.FindFromIncomingDocumentEntryNo(MainRecordRef, Incident) then
        //     exit(true);
        // if Incident.FindByDocumentNoAndPostingDate(MainRecordRef, Incident) then
        //     exit(true);
        exit(false);
    end;

    [IntegrationEvent(true, false)]
    local procedure OnAfterLoadDataFromRecord(var MainRecordRef: RecordRef)
    begin
    end;

    [IntegrationEvent(false, false)]
    local procedure OnLoadDataFromRecordOnBeforeDeleteAll(var TempIncidentAttachmentOverview: Record "Incident Attachment Overview" temporary)
    begin
    end;

    [IntegrationEvent(false, false)]
    local procedure OnLoadDataFromIncomingDocumentOnBeforeDeleteAll(var TempIncidentAttachmentOverview: Record "Incident Attachment Overview" temporary)
    begin
    end;
}
