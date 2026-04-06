page 96155 "Incident Attach List"
{
    PageType = List;
    SourceTable = "Incident Attachment";
    Caption = 'Incident Attachment List';
    Editable = true;
    ApplicationArea = All;

    layout  
    {
        area(content)
        {
            repeater(Group)
            {
                field("Incident Id."; Rec."Incident Id.")
                {
                    ToolTip = 'Specifies the name of the attachment file.';
                }
                field("Line No."; rec."Line No.")
                {
                }
                field("Created Date-Time";rec."Created Date-Time")
                {
                }
                
                field("Created By User Name"; rec."Created By User Name")
                {
                }
                field(Name; rec.Name)
                {
                }
                field(Type; rec.Type)
                {
                }
                field("File Extension"; rec."File Extension")
                {
                }
                field(Blob; rec.Content)
                {
                    ToolTip = 'Specifies the content of the attachment.';
                }
                field("Size (KB)"; SizeFile)
                {
                    ApplicationArea = Basic, Suite;
                    ToolTip = 'Specifies the size of the attached file in kilobytes.';
                    Editable = false;
                }
                field("Document No."; rec."Document No.")
                {
                }
                field("Posting Date"; rec."Posting Date")
                {
                }
                field("Document Table No. Filter"; rec."Document Table No. Filter")
                {
                }
                field("Document Type Filter"; rec."Document Type Filter")
                {
                }
                field("Document No. Filter"; rec."Document No. Filter")
                {
                }
                field("Journal Template Name Filter"; rec."Journal Template Name Filter")
                {
                }
                field("Journal Batch Name Filter"; rec."Journal Batch Name Filter")
                {
                }
                field("Journal Line No. Filter"; rec."Journal Line No. Filter")
                {
                }
                field("Use for OCR"; rec."Use for OCR")
                {
                }
                field("External Document Reference"; rec."External Document Reference")
                {
                }
                field("OCR Service Document Reference"; rec."OCR Service Document Reference")
                {
                }
                field("Generated from OCR"; rec."Generated from OCR")
                {
                }
                field("Main Attachment"; rec."Main Attachment")
                {
                }
            }
        }
    }

    actions
    {
        area(processing)
        {
            action(Delete)
            {
                Image = Delete;
                Promoted = true;
                PromotedIsBig = true;
                Scope = Repeater;
                
                trigger OnAction()
                begin
                    if Confirm('Delete this attachment?') then
                        Rec.Delete();
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
    
        SizeFile := 0;
        Rec.CalcFields(Content);
        if Rec.Content.HasValue then begin
            Rec.Content.CreateInStream(InS);
            SizeFile := InS.Length;
        end;
    end;

    var
        SizeFile : integer;
}