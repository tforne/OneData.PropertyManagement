page 96071 "OD Copy Lease Contract Req."
{
    PageType = StandardDialog;
    Caption = 'Copy Lease Contract from Another Company';
    ApplicationArea = All;

    layout
    {
        area(content)
        {
            group(Source)
            {
                Caption = 'Source';

                field(SourceCompanyName; SourceCompanyName)
                {
                    Caption = 'Source Company';
                    TableRelation = Company.Name;
                }

                field(SourceContractNo; SourceContractNo)
                {
                    Caption = 'Source Contract No.';

                    trigger OnLookup(var Text: Text): Boolean
                    var
                        LookupMgt: Codeunit "OD Lease Contract Lookup";
                        SelectedContractNo: Code[20];
                    begin
                        if SourceCompanyName = '' then
                            Error('Debes indicar primero la empresa origen.');

                        if LookupMgt.LookupContractFromCompany(SourceCompanyName, SelectedContractNo) then begin
                            SourceContractNo := SelectedContractNo;
                            Text := SourceContractNo;
                            CurrPage.Update(false);
                            exit(true);
                        end;

                        exit(false);
                    end;
                }
            }

            group(Options)
            {
                Caption = 'Options';

                field(CopyHeader; CopyHeader)
                {
                    Caption = 'Copy Header';
                }

                field(CopyLines; CopyLines)
                {
                    Caption = 'Copy Lines';
                }

                field(ReplaceLines; ReplaceLines)
                {
                    Caption = 'Replace Existing Lines';
                    Editable = CopyLines;
                }

                field(CopyComments; CopyComments)
                {
                    Caption = 'Copy Comments';
                }
            }
        }
    }

    var
        SourceCompanyName: Text[30];
        SourceContractNo: Code[20];
        ReplaceLines: Boolean;
        CopyHeader: Boolean;
        CopyLines: Boolean;
        CopyComments: Boolean;

    procedure SetDefaults()
    begin
        CopyHeader := true;
        CopyLines := true;
        ReplaceLines := true;
        CopyComments := false;
    end;

    procedure GetSourceCompanyName(): Text[30]
    begin
        exit(SourceCompanyName);
    end;

    procedure GetSourceContractNo(): Code[20]
    begin
        exit(SourceContractNo);
    end;

    procedure GetReplaceLines(): Boolean
    begin
        exit(ReplaceLines);
    end;

    procedure GetCopyHeader(): Boolean
    begin
        exit(CopyHeader);
    end;

    procedure GetCopyLines(): Boolean
    begin
        exit(CopyLines);
    end;

    procedure GetCopyComments(): Boolean
    begin
        exit(CopyComments);
    end;
}