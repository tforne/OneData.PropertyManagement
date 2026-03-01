table 96102 "Incident Attachment Overview"
{
    Caption = 'Incident Attachment Overview';
    TableType = Temporary;
    ReplicateData = false;
    DataClassification = CustomerContent;

    fields
    {
        field(1; "Incident Id."; Guid)
        {
            Caption = 'Incident Id.';
            TableRelation = "Incident Assets Real Estate";
        }
        field(2; "Line No."; Integer)
        {
            Caption = 'Line No.';
            InitValue = 0;
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
            Editable = false;
        }
        field(6; Type; Option)
        {
            Caption = 'Type';
            Editable = false;
            OptionCaption = ' ,Image,PDF,Word,Excel,PowerPoint,Email,XML,Other';
            OptionMembers = " ",Image,PDF,Word,Excel,PowerPoint,Email,XML,Other;
        }
        field(7; "File Extension"; Text[30])
        {
            Caption = 'File Extension';
            Editable = false;
        }

        field(100; "Attachment Type"; Option)
        {
            Caption = 'Attachment Type';
            Editable = false;
            OptionCaption = ',Group,Main Attachment,OCR Result,Supporting Attachment,Link';
            OptionMembers = ,Group,"Main Attachment","OCR Result","Supporting Attachment",Link;
        }
        field(101; "Sorting Order"; Integer)
        {
            Caption = 'Sorting Order';
        }
        field(102; Indentation; Integer)
        {
            Caption = 'Indentation';
        }

        field(103; "Posting Date"; Date)
        {
            Caption = 'Posting Date';
            Editable = false;
        }

        field(104; "Document No."; Code[20])
        {
            Caption = 'Document No.';
            Editable = false;
        }
    }

    keys
    {
        key(Key1; "Sorting Order", "Incident Id.")
        {
            Clustered = true;
        }
    }

    fieldgroups
    {
        fieldgroup(Brick; "Created Date-Time", Name, "File Extension")
        {
        }
    }

    trigger OnDelete()
    var
        IncomingDocumentAttachment: Record "Incoming Document Attachment";
    begin
        if IncomingDocumentAttachment.Get("Incident Id.", "Line No.") then
            IncomingDocumentAttachment.Delete(true);
    end;

    var
        ClientTypeManagement: Codeunit "Client Type Management";

        SupportingAttachmentsTxt: Label 'Supporting Attachments';
        NotAvailableAttachmentMsg: Label 'The attachment is no longer available.';

    internal procedure NameDrillDown()
    begin
        NameDrillDown(false)
    end;

    procedure NameDrillDown(DownloadFilePreset: Boolean)
    var
        Incident: Record "Incident Assets Real Estate";
        IncidentAttachment: Record "Incident Attachment";
        IsHandled: Boolean;
    begin
        IsHandled := false;
        OnBeforeNameDrillDown(Rec, IsHandled);
        if IsHandled then
            exit;

        case "Attachment Type" of
            "Attachment Type"::Group:
                exit;
            "Attachment Type"::Link:
                begin
                    Incident.Get("Incident Id.");
                    HyperLink(Incident.GetURL());
                end
            else
                if not IncidentAttachment.Get("Incident Id.", "Line No.") then
                    Message(NotAvailableAttachmentMsg)
                else
                    if (Type = Type::Image) and (ClientTypeManagement.GetCurrentClientType() = CLIENTTYPE::Phone) then
                        PAGE.Run(PAGE::"O365 Incident Att. Pict.", IncidentAttachment)
                    else
                        if IncidentAttachment.SupportedByFileViewer() and not DownloadFilePreset then
                            ViewFile(IncidentAttachment, Name + '.' + "File Extension")
                         else
                             IncidentAttachment.Export(Name + '.' + "File Extension", true);
        end;
    end;

    local procedure ViewFile(var IncidentAttachment: Record "Incident Attachment"; FileName: Text)
    var
        FileInStream: InStream;
    begin
        IncidentAttachment.CalcFields(Content);
        IncidentAttachment.Content.CreateInStream(FileInStream);
        File.ViewFromStream(FileInStream, FileName, true);
    end;

    procedure GetStyleTxt(): Text
    begin
        case "Attachment Type" of
            "Attachment Type"::Group,
          "Attachment Type"::"Main Attachment",
          "Attachment Type"::Link:
                exit('Strong');
            else
                exit('Standard');
        end;
    end;

    procedure InsertFromIncident(Incident: Record "Incident Assets Real Estate"; var TempIncidentAttachmentOverview: Record "Incident Attachment Overview" temporary)
    var
        SortingOrder: Integer;
    begin
        InsertMainAttachment(Incident, TempIncidentAttachmentOverview, SortingOrder);
        InsertLinkAddress(Incident, TempIncidentAttachmentOverview, SortingOrder);
        InsertSupportingAttachments(
          Incident, TempIncidentAttachmentOverview, SortingOrder, false);
          
        OnAfterInsertFromIncomingDocument(Incident, TempIncidentAttachmentOverview, SortingOrder);
    end;

    procedure InsertSupportingAttachmentsFromIncomingDocument(Incident: Record "Incident Assets Real Estate"; var TempIncidentAttachmentOverview: Record "Incident Attachment Overview" temporary)
    var
        SortingOrder: Integer;
    begin
        InsertSupportingAttachments(Incident, TempIncidentAttachmentOverview, SortingOrder, false);
    end;

    local procedure InsertMainAttachment(Incident: Record "Incident Assets Real Estate"; var TempIncidentAttachmentOverview: Record "Incident Attachment Overview" temporary; var SortingOrder: Integer)
    var
        IncidentAttachment: Record "Incident Attachment";
    begin
        if not Incident.GetMainAttachment(IncidentAttachment) then
            exit;

            InsertFromIncomingDocumentAttachment(
              TempIncidentAttachmentOverview, IncidentAttachment, SortingOrder,
              TempIncidentAttachmentOverview."Attachment Type"::"Main Attachment", 0);
    end;

    local procedure InsertSupportingAttachments(Incident: Record "Incident Assets Real Estate"; var TempIncidentAttachmentOverview: Record "Incident Attachment Overview" temporary; var SortingOrder: Integer; IncludeGroupCaption: Boolean)
    var
        IncidentAttachment: Record "Incident Attachment";
        Indentation2: Integer;
    begin
        // if not Incident.GetSupportingAttachments(IncidentAttachment) then
        //     exit;

        if IncludeGroupCaption then
            InsertGroup(TempIncidentAttachmentOverview, Incident, SortingOrder, SupportingAttachmentsTxt);
        Indentation2 := 1;
        repeat
            InsertFromIncomingDocumentAttachment(
              TempIncidentAttachmentOverview, IncidentAttachment, SortingOrder,
              TempIncidentAttachmentOverview."Attachment Type"::"Supporting Attachment", Indentation2);
        until IncidentAttachment.Next() = 0;
    end;

    local procedure InsertLinkAddress(Incident: Record "Incident Assets Real Estate"; var TempIncidentAttachmentOverview: Record "Incident Attachment Overview" temporary; var SortingOrder: Integer)
    var
        URL: Text;
    begin
        URL := Incident.GetURL();
        if URL = '' then
            exit;

        Clear(TempIncidentAttachmentOverview);
        TempIncidentAttachmentOverview.Init();
        TempIncidentAttachmentOverview."Incident Id." := Incident."Incident Id.";
        AssignSortingNo(TempIncidentAttachmentOverview, SortingOrder);
        TempIncidentAttachmentOverview.Name := CopyStr(URL, 1, MaxStrLen(TempIncidentAttachmentOverview.Name));
        TempIncidentAttachmentOverview."Attachment Type" := TempIncidentAttachmentOverview."Attachment Type"::Link;
        TempIncidentAttachmentOverview.Insert(true);
    end;

    local procedure InsertFromIncomingDocumentAttachment(var TempIncidentAttachmentOverview: Record "Incident Attachment Overview" temporary; IncidentAttachment: Record "Incident Attachment"; var SortingOrder: Integer; AttachmentType: Option; Indentation2: Integer)
    begin
        Clear(TempIncidentAttachmentOverview);
        TempIncidentAttachmentOverview.Init();
        TempIncidentAttachmentOverview.TransferFields(IncidentAttachment);
        AssignSortingNo(TempIncidentAttachmentOverview, SortingOrder);
        TempIncidentAttachmentOverview."Attachment Type" := AttachmentType;
        TempIncidentAttachmentOverview.Indentation := Indentation2;
        TempIncidentAttachmentOverview.Insert(true);
    end;

    local procedure InsertGroup(var TempIncidentAttachmentOverview: Record "Incident Attachment Overview" temporary; Incident: Record "Incident Assets Real Estate"; var SortingOrder: Integer; Description: Text[50])
    begin
        Clear(TempIncidentAttachmentOverview);
        TempIncidentAttachmentOverview.Init();
        TempIncidentAttachmentOverview."Incident Id." := "Incident Id.";
        AssignSortingNo(TempIncidentAttachmentOverview, SortingOrder);
        TempIncidentAttachmentOverview."Attachment Type" := TempIncidentAttachmentOverview."Attachment Type"::Group;
        TempIncidentAttachmentOverview.Type := Type::" ";
        TempIncidentAttachmentOverview.Name := Description;
        TempIncidentAttachmentOverview.Insert(true);
    end;

    local procedure AssignSortingNo(var TempIncidentAttachmentOverview: Record "Incident Attachment Overview" temporary; var SortingOrder: Integer)
    begin
        SortingOrder += 1;
        TempIncidentAttachmentOverview."Sorting Order" := SortingOrder;
    end;

    procedure IsGroupOrLink(): Boolean
    begin
        exit(("Attachment Type" = "Attachment Type"::Group) or ("Attachment Type" = "Attachment Type"::Link));
    end;

    [IntegrationEvent(false, false)]
    local procedure OnAfterInsertFromIncomingDocument(Incident: Record "Incident Assets Real Estate"; var TempIncidentAttachmentOverview: Record "Incident Attachment Overview" temporary; var SortingOrder: Integer)
    begin
    end;

    [IntegrationEvent(false, false)]
    local procedure OnBeforeNameDrillDown(var IncidentcAttachmentOverview: Record "Incident Attachment Overview"; var IsHandled: Boolean)
    begin
    end;
}

