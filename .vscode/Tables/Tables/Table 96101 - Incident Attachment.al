table 96101 "Incident Attachment"
{
    Caption = 'Incident Attachment';
    DataClassification = CustomerContent;
    DataPerCompany = false;

    fields
    {
        field(1; "Incident Id."; guid)
        {
            Caption = 'Incident Id.';
            TableRelation = "Incident Assets Real Estate"."Incident Id.";
        }
        field(2; "Line No."; Integer)
        {
            Caption = 'Line No.';
        }
        field(3; "Created Date-Time"; DateTime)
        {
            Caption = 'Created Date-Time';
        }
        field(4; "Created By User Name"; Code[50])
        {
            Caption = 'Created By User Name';
            DataClassification = EndUserIdentifiableInformation;
        }
        field(5; Name; Text[250])
        {
            Caption = 'Name';
        }
        field(6; Type; Option)
        {
            Caption = 'Type';
            OptionCaption = ' ,Image,PDF,Word,Excel,PowerPoint,Email,XML,Other';
            OptionMembers = " ",Image,PDF,Word,Excel,PowerPoint,Email,XML,Other;
        }
        field(7; "File Extension"; Text[30])
        {
            Caption = 'File Extension';

            trigger OnValidate()
            begin
                case LowerCase("File Extension") of
                    'jpg', 'jpeg', 'bmp', 'png', 'tiff', 'tif', 'gif':
                        Type := Type::Image;
                    'pdf':
                        Type := Type::PDF;
                    'docx', 'doc':
                        Type := Type::Word;
                    'xlsx', 'xls':
                        Type := Type::Excel;
                    'pptx', 'ppt':
                        Type := Type::PowerPoint;
                    'msg':
                        Type := Type::Email;
                    'xml':
                        Type := Type::XML;
                    else
                        Type := Type::Other;
                end;
            end;
        }
        field(8; Content; BLOB)
        {
            Caption = 'Content';
            SubType = Bitmap;
        }
        field(9; "Document No."; Code[20])
        {
            Caption = 'Document No.';
        }
        field(10; "Posting Date"; Date)
        {
            Caption = 'Posting Date';
        }
        field(11; "Document Table No. Filter"; Integer)
        {
            Caption = 'Document Table No. Filter';
            FieldClass = FlowFilter;
        }
        field(12; "Document Type Filter"; Enum "Incoming Document Type")
        {
            Caption = 'Document Type Filter';
            FieldClass = FlowFilter;
        }
        field(13; "Document No. Filter"; Code[20])
        {
            Caption = 'Document No. Filter';
            FieldClass = FlowFilter;
        }
        field(14; "Journal Template Name Filter"; Code[20])
        {
            Caption = 'Journal Template Name Filter';
            FieldClass = FlowFilter;
        }
        field(15; "Journal Batch Name Filter"; Code[20])
        {
            Caption = 'Journal Batch Name Filter';
            FieldClass = FlowFilter;
        }
        field(16; "Journal Line No. Filter"; Integer)
        {
            Caption = 'Journal Line No. Filter';
            FieldClass = FlowFilter;
        }
        field(17; Default; Boolean)
        {
            Caption = 'Default';

        }
        field(18; "Use for OCR"; Boolean)
        {
            Caption = 'Use for OCR';

            trigger OnValidate()
            begin
                if "Use for OCR" then
                    if not (Type in [Type::PDF, Type::Image]) then
                        Error(MustBePdfOrPictureErr, Type::PDF, Type::Image);
            end;
        }
        field(19; "External Document Reference"; Text[50])
        {
            Caption = 'External Document Reference';
        }
        field(20; "OCR Service Document Reference"; Text[50])
        {
            Caption = 'OCR Service Document Reference';
        }
        field(21; "Generated from OCR"; Boolean)
        {
            Caption = 'Generated from OCR';
            Editable = false;
        }
        field(22; "Main Attachment"; Boolean)
        {
            Caption = 'Main Attachment';

            trigger OnValidate()
            begin
                CheckMainAttachment();
            end;
        }
    }

    keys
    {
        key(Key1; "Incident Id.", "Line No.")
        {
            Clustered = true;
        }
    }

    fieldgroups
    {
        fieldgroup(Brick; "Created Date-Time", Name, "File Extension", Type)
        {
        }
        fieldgroup(drilldown; "Incident Id.", Name)
        {
        }
    }

    trigger OnDelete()
    var
        IncidentAttachment: Record "Incident Attachment";
    begin
        IncidentAttachment.SetRange("Incident Id.", "Incident Id.");
        IncidentAttachment.SetFilter("Line No.", '<>%1', "Line No.");

        if Default then
            if not IncidentAttachment.IsEmpty() then
                Error(DefaultAttachErr);

        if "Main Attachment" then
            if not IncidentAttachment.IsEmpty() then
                Error(MainAttachErr);
    end;

    trigger OnInsert()
    begin
        // TestField("Incident Id.");
        // if "Incident Id." = '00000000-0000-0000-0000-000000000000' then
        //     "Incident Id." := CreateGuid();
        "Created Date-Time" := RoundDateTime(CurrentDateTime, 1000);
        "Created By User Name" := CopyStr(UserId(), 1, MaxStrLen("Created By User Name"));

        SetFirstAttachmentAsDefault();
        SetFirstAttachmentAsMain();

        CheckDefault();
        CheckMainAttachment();
    end;

    trigger OnModify()
    begin
        CheckDefault();
        CheckMainAttachment();
    end;

    var
        DeleteQst: Label 'Do you want to delete the attachment?';
        DefaultAttachErr: Label 'There can only be one default attachment.';
        MainAttachErr: Label 'There can only be one main attachment.';
        MustBePdfOrPictureErr: Label 'Only files of type %1 and %2 can be used for OCR.', Comment = '%1 and %2 are file types: PDF and Picture';
        NotifIncDocCompletedMsg: Label 'The action to create an incident from file has completed.';

    procedure NewAttachment()
    var
        IsHandled: Boolean;
    begin
        IsHandled := false;
        OnBeforeNewAttachment(Rec, IsHandled);
        if IsHandled then
            exit;

        if not CODEUNIT.Run(CODEUNIT::"Management - Incident", Rec) then
            Error(GetLastErrorText());
    end;


    procedure NewAttachmentFromDocument(IncidentId: Guid; TableID: Integer; DocumentType: Option; DocumentNo: Code[20])
    begin
        ApplyFiltersForDocument(IncidentId, TableID, DocumentType, DocumentNo);
        NewAttachment();
        SendNotifActionCompleted();
    end;


    procedure NewAttachmentFromDocument(IncidentId: Guid; TableID: Integer; DocumentType: Option; DocumentNo: Code[20]; FileName: Text[250]; var TempBlob: Codeunit "Temp Blob")
    var
        ImportAttachmentIncident: Codeunit "Management - Incident";
    begin
        ApplyFiltersForDocument(IncidentId, TableID, DocumentType, DocumentNo);
        ImportAttachmentIncident.ImportAttachment(Rec, FileName, TempBlob);
        if GuiAllowed() then
            SendNotifActionCompleted();
    end;

    local procedure ApplyFiltersForDocument(IncidentId: Guid; TableID: Integer; DocumentType: Option; DocumentNo: Code[20])
    begin
        Rec.SetRange("Incident Id.", IncidentId);
        Rec.SetRange("Document Table No. Filter", TableID);
        Rec.SetRange("Document Type Filter", DocumentType);
        Rec.SetRange("Document No. Filter", DocumentNo);
    end;


    procedure NewAttachmentFromPostedDocument(DocumentNo: Code[20]; PostingDate: Date)
    begin
        SetRange("Document No.", DocumentNo);
        SetRange("Posting Date", PostingDate);
        NewAttachment();
        if GuiAllowed() then
            SendNotifActionCompleted();
    end;

    procedure Import() IsImported: Boolean
    var
        IsHandled: Boolean;
    begin
        IsHandled := false;
        IsImported := false;
        OnBeforeImport(Rec, IsImported, IsHandled);
        if IsHandled then
            exit(IsImported);

        exit(Import(false));
    end;

    procedure Import(RethrowError: Boolean): Boolean
    begin
        if CODEUNIT.Run(CODEUNIT::"Management - Incident", Rec) then
            exit(true);

        if not RethrowError then
            exit(false);

        Error(GetLastErrorText());
    end;

    procedure Export(DefaultFileName: Text; ShowFileDialog: Boolean): Text
    var
        TempBlob: Codeunit "Temp Blob";
        FileMgt: Codeunit "File Management";
    begin
        OnBeforeExport(Rec);
        
        if not GetContent(TempBlob) then
            exit;

        if DefaultFileName = '' then
            DefaultFileName := Name + '.' + "File Extension";

        exit(FileMgt.BLOBExport(TempBlob, DefaultFileName, ShowFileDialog));
    end;

    procedure GetContent(var TempBlob: Codeunit "Temp Blob"): Boolean
    begin
        if "Incident Id." = '00000000-0000-0000-0000-000000000000' then
            exit(false);

        OnGetBinaryContent(TempBlob, "Incident Id.");
        if not TempBlob.HasValue() then
            TempBlob.FromRecord(Rec, FieldNo(Content));
        exit(TempBlob.HasValue());
    end;

    procedure DeleteAttachment()
    var
        Incident: Record "Incident Assets Real Estate";
    begin
        TestField("Incident Id.");
        TestField("Line No.");

        if Default then
            Error(DefaultAttachErr);

        Incident.Get("Incident Id.");
        if Confirm(DeleteQst, false) then
            Delete();
    end;

    local procedure CheckDefault()
    var
        IncidentAttachment: Record "Incident Attachment";
    begin
        IncidentAttachment.SetRange("Incident Id.", "Incident Id.");
        IncidentAttachment.SetFilter("Line No.", '<>%1', "Line No.");
        IncidentAttachment.SetRange(Default, true);
        if IncidentAttachment.IsEmpty() then begin
            if not Default then
                Error(DefaultAttachErr);
        end else
            if Default then
                Error(DefaultAttachErr);
    end;

    local procedure ClearDefaultAttachmentsFromIncident()
    var
        IncidentAttachment: Record "Incident Attachment";
    begin
        IncidentAttachment.SetRange("Incident Id.", "Incident Id.");
        IncidentAttachment.SetFilter("Line No.", '<>%1', "Line No.");
        IncidentAttachment.ModifyAll(Default, false);
    end;

    procedure GetFullName(): Text
    begin
        exit(StrSubstNo('%1.%2', Name, "File Extension"));
    end;

    [IntegrationEvent(true, false)]
    procedure OnAttachBinaryFile()
    begin
    end;

    [IntegrationEvent(true, false)]
    local procedure OnGetBinaryContent(var TempBlob: Codeunit "Temp Blob"; IncidentId: Guid)
    begin
    end;

    local procedure FindDataExchType()
    var
        IsHandled: Boolean;
    begin
        IsHandled := false;
        OnBeforeFindDataExchType(Rec, IsHandled);
        if IsHandled then
            exit;

        if Type <> Type::XML then
            exit;
        Commit();
        if CODEUNIT.Run(CODEUNIT::"Data Exch. Type Selector", Rec) then;
    end;

        
    local procedure CheckMainAttachment()
    var
        IncidentAttachment: Record "Incident Attachment";
        MoreThanOneMainAttachmentExist: Boolean;
        NoMainAttachmentExist: Boolean;
    begin
        IncidentAttachment.SetRange("Incident Id.", "Incident Id.");
        IncidentAttachment.SetFilter("Line No.", '<>%1', "Line No.");
        IncidentAttachment.SetRange("Main Attachment", true);

        MoreThanOneMainAttachmentExist := "Main Attachment" and (not IncidentAttachment.IsEmpty);
        NoMainAttachmentExist := (not "Main Attachment") and IncidentAttachment.IsEmpty();
        if MoreThanOneMainAttachmentExist or NoMainAttachmentExist then
            Error(MainAttachErr);
    end;

    local procedure SetFirstAttachmentAsDefault()
    var
        IncidentAttachment: Record "Incident Attachment";
    begin
        if not Default then begin
            IncidentAttachment.SetRange("Incident Id.", "Incident Id.");
            IncidentAttachment.SetRange(Default, true);
            if IncidentAttachment.IsEmpty() then
                Validate(Default, true);
        end;
    end;

    local procedure SetFirstAttachmentAsMain()
    var
        IncidentAttachment: Record "Incident Attachment";
    begin
        if not "Main Attachment" then begin
            IncidentAttachment.SetRange("Incident Id.", "Incident Id.");
            IncidentAttachment.SetRange("Main Attachment", true);
            if IncidentAttachment.IsEmpty() then
                Validate("Main Attachment", true);
        end;
    end;

    procedure SetFiltersFromMainRecord(var MainRecordRef: RecordRef; var IncidentAttachment: Record "Incident Attachment")
    var
        SalesHeader: Record "Sales Header";
        PurchaseHeader: Record "Purchase Header";
        GenJournalLine: Record "Gen. Journal Line";
        PurchInvHeader: Record "Purch. Inv. Header";
        DataTypeManagement: Codeunit "Data Type Management";
        EnumAssignmentMgt: Codeunit "Enum Assignment Management";
        DocumentNoFieldRef: FieldRef;
        PostingDateFieldRef: FieldRef;
        PostingDate: Date;
        IsHandled: Boolean;
    begin
        IsHandled := false;
        OnBeforeSetFiltersFromMainRecord(MainRecordRef, IncidentAttachment, IsHandled);
        if IsHandled then
            exit;

        case MainRecordRef.Number of
            DATABASE::"Incoming Document":
                exit;
            DATABASE::"Sales Header":
                begin
                    MainRecordRef.SetTable(SalesHeader);
                    IncidentAttachment.SetRange("Document Table No. Filter", MainRecordRef.Number);
                    IncidentAttachment.SetRange("Document Type Filter", EnumAssignmentMgt.GetSalesIncomingDocumentType(SalesHeader."Document Type"));
                    IncidentAttachment.SetRange("Document No. Filter", SalesHeader."No.");
                end;
            DATABASE::"Purchase Header":
                begin
                    MainRecordRef.SetTable(PurchaseHeader);
                    IncidentAttachment.SetRange("Document Table No. Filter", MainRecordRef.Number);
                    IncidentAttachment.SetRange("Document Type Filter", EnumAssignmentMgt.GetPurchIncomingDocumentType(PurchaseHeader."Document Type"));
                    IncidentAttachment.SetRange("Document No. Filter", PurchaseHeader."No.");
                end;
            DATABASE::"Gen. Journal Line":
                begin
                    MainRecordRef.SetTable(GenJournalLine);
                    IncidentAttachment.SetRange("Document Table No. Filter", MainRecordRef.Number);
                    IncidentAttachment.SetRange("Journal Template Name Filter", GenJournalLine."Journal Template Name");
                    IncidentAttachment.SetRange("Journal Batch Name Filter", GenJournalLine."Journal Batch Name");
                    IncidentAttachment.SetRange("Journal Line No. Filter", GenJournalLine."Line No.");
                end;
            else begin
                if not DataTypeManagement.FindFieldByName(MainRecordRef, DocumentNoFieldRef, GenJournalLine.FieldName("Document No.")) then
                    if not DataTypeManagement.FindFieldByName(MainRecordRef, DocumentNoFieldRef, PurchInvHeader.FieldName("No.")) then
                        exit;
                if not DataTypeManagement.FindFieldByName(MainRecordRef, PostingDateFieldRef, GenJournalLine.FieldName("Posting Date")) then
                    exit;
                IncidentAttachment.SetRange("Document No.", Format(DocumentNoFieldRef.Value));
                Evaluate(PostingDate, Format(PostingDateFieldRef.Value));
                IncidentAttachment.SetRange("Posting Date", PostingDate);
            end;
        end;
    end;

    procedure AddFieldToFieldBuffer(var TempFieldBuffer: Record "Field Buffer" temporary; FieldID: Integer)
    begin
        TempFieldBuffer.Init();
        TempFieldBuffer.Order += 1;
        TempFieldBuffer."Table ID" := DATABASE::"Incident Assets Real Estate";
        TempFieldBuffer."Field ID" := FieldID;
        TempFieldBuffer.Insert();
    end;

    procedure SendNotifActionCompleted()
    var
        Notification: Notification;
    begin
        Notification.Id := CreateGuid();
        Notification.Message := NotifIncDocCompletedMsg;
        Notification.Scope := NOTIFICATIONSCOPE::LocalScope;
        Notification.Send();
    end;

    procedure SetContentFromBlob(TempBlob: Codeunit "Temp Blob")
    var
        RecordRef: RecordRef;
    begin
        RecordRef.GetTable(Rec);
        TempBlob.ToRecordRef(RecordRef, FieldNo(Content));
        RecordRef.SetTable(Rec);

    end;

    internal procedure SupportedByFileViewer(): Boolean
    begin
        case Type of
            Type::PDF:
                exit(true);
            Type::" ":
                begin
                    if Rec."File Extension" <> '' then
                        exit(LowerCase(Rec."File Extension") = 'pdf');

                    exit(Lowercase(Rec.Name).EndsWith('pdf'))
                end;
            else
                exit(false);
        end;
    end;

    [IntegrationEvent(false, false)]
    procedure OnBeforeExtractHeaderFields(var TempFieldBuffer: Record "Field Buffer" temporary; var Incident: Record "Incident Assets Real Estate")
    begin
    end;

    [IntegrationEvent(false, false)]
    local procedure OnBeforeExport(var IncidentAttachment: Record "Incident Attachment")
    begin
    end;

    [IntegrationEvent(false, false)]
    procedure OnBeforeSetFiltersFromMainRecord(var MainRecordRef: RecordRef; var IncidentAttachment: Record "Incident Attachment"; var IsHandled: Boolean)
    begin
    end;

    [IntegrationEvent(false, false)]
    local procedure OnAfterSetValueOnExtractHeaderField(var Incident: Record "Incident Assets Real Estate"; FieldNumber: Integer)
    begin
    end;

    [IntegrationEvent(false, false)]
    local procedure OnBeforeFindDataExchType(var IncidentAttachment: Record "Incident Attachment"; var IsHandled: Boolean)
    begin
    end;

    [IntegrationEvent(false, false)]
    local procedure OnBeforeNewAttachment(var IncidentAttachment: Record "Incident Attachment"; var IsHandled: Boolean)
    begin
    end;

    [IntegrationEvent(false, false)]
    local procedure OnBeforeImport(var IncidentAttachment: Record "Incident Attachment"; var IsImported: Boolean; var IsHandled: Boolean)
    begin
    end;
}
