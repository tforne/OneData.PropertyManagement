page 96725 "FRE Excel Template Setup"
{
    PageType = Card;
    ApplicationArea = All;
    UsageCategory = Administration;
    SourceTable = "FRE Excel Template Setup";
    Caption = 'FRE Excel Template Setup';

    layout
    {
        area(Content)
        {
            group(General)
            {
                field("Template File Name"; Rec."Template File Name")
                {
                    ApplicationArea = All;
                    Editable = false;
                }
            }
        }
    }

    actions
    {
        area(Processing)
        {
            action(UploadTemplate)
            {
                Caption = 'Upload Excel Template';
                Image = Import;
                Promoted = true;
                PromotedCategory = Process;

                trigger OnAction()
                var
                    FileName: Text;
                    InStr: InStream;
                    OutStr: OutStream;
                begin
                    UploadIntoStream(
                        'Select Excel template',
                        '',
                        'Excel files (*.xlsx)|*.xlsx',
                        FileName,
                        InStr);

                    if FileName = '' then
                        Error('No file was selected.');

                    if not FileName.ToLower().EndsWith('.xlsx') then
                        Error('Only .xlsx files are allowed.');

                    Clear(Rec."Journal Template File");
                    Rec."Journal Template File".CreateOutStream(OutStr);
                    CopyStream(OutStr, InStr);

                    Rec."Template File Name" := FileName;
                    Rec.Modify(true);

                    Message('Template uploaded successfully.');
                end;
            }
            action(DownloadStoredTemplate)
            {
                Caption = 'Download Stored Template';
                Image = Export;
                Promoted = true;
                PromotedCategory = Process;

                trigger OnAction()
                var
                    InStr: InStream;
                begin
                    Rec.CalcFields("Journal Template File");

                    if not Rec."Journal Template File".HasValue then
                        Error('No template uploaded.');

                    Rec."Journal Template File".CreateInStream(InStr);

                    DownloadFromStream(
                        InStr,
                        '',
                        '',
                        '',
                        Rec."Template File Name");
                end;
            }
            action(TestDownloadStoredTemplate)
            {
                Caption = 'Test Download Stored Template';
                Image = Export;
                Promoted = true;
                PromotedCategory = Process;
                ApplicationArea = All;

                trigger OnAction()
                var
                    FREImportJnlLines: Codeunit "FRE Import Jnl. Lines";
                begin
                    FREImportJnlLines.DownloadStoredTemplateForTest();
                end;
            }
            action(TestOpenStoredTemplate)
            {
                Caption = 'Test Open Stored Template';
                Image = Export;
                Promoted = true;
                PromotedCategory = Process;
                ApplicationArea = All;

                trigger OnAction()
                var
                    FREImportJnlLines: Codeunit "FRE Import Jnl. Lines";
                begin
                    FREImportJnlLines.TestOpenStoredTemplate();
                end;
            }
        }
    }

    trigger OnOpenPage()
    begin
        if not Rec.Get('SETUP') then begin
            Rec.Init();
            Rec."Primary Key" := 'SETUP';
            Rec.Insert();
        end;
    end;
}