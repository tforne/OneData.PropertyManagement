page 96155 "Incident Attach List"
{
    PageType = List;
    SourceTable = "Incident Attachment";
    Caption = 'Incident Attachment List';
    Editable = true;
    
    layout  
    {
        area(content)
        {
            repeater(Group)
            {
                field("Incident Id."; Rec."Incident Id.")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the name of the attachment file.';
                }
                field("Line No."; rec."Line No.")
                {
                    ApplicationArea = All;
                }
                field("Created Date-Time";rec."Created Date-Time")
                {
                    ApplicationArea = All;
                }
                
                field("Created By User Name"; rec."Created By User Name")
                {
                    ApplicationArea = All;
                }
                field(Name; rec.Name)
                {
                    ApplicationArea = All;
                }
                field(Type; rec.Type)
                {
                    ApplicationArea = All;
                }
                field("File Extension"; rec."File Extension")
                {
                    ApplicationArea = All;
                }
                field(Blob; rec.Content)
                {
                    ApplicationArea = All;
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
                    ApplicationArea = All;
                }
                field("Posting Date"; rec."Posting Date")
                {
                    ApplicationArea = All;
                }
                field("Document Table No. Filter"; rec."Document Table No. Filter")
                {
                    ApplicationArea = All;
                }
                field("Document Type Filter"; rec."Document Type Filter")
                {
                    ApplicationArea = All;
                }
                field("Document No. Filter"; rec."Document No. Filter")
                {
                    ApplicationArea = All;
                }
                field("Journal Template Name Filter"; rec."Journal Template Name Filter")
                {
                    ApplicationArea = All;
                }
                field("Journal Batch Name Filter"; rec."Journal Batch Name Filter")
                {
                    ApplicationArea = All;
                }
                field("Journal Line No. Filter"; rec."Journal Line No. Filter")
                {
                    ApplicationArea = All;
                }
                field("Use for OCR"; rec."Use for OCR")
                {
                    ApplicationArea = All;
                }
                field("External Document Reference"; rec."External Document Reference")
                {
                    ApplicationArea = All;
                }
                field("OCR Service Document Reference"; rec."OCR Service Document Reference")
                {
                    ApplicationArea = All;
                }
                field("Generated from OCR"; rec."Generated from OCR")
                {
                    ApplicationArea = All;
                }
                field("Main Attachment"; rec."Main Attachment")
                {
                    ApplicationArea = All;
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
                ApplicationArea = All;
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