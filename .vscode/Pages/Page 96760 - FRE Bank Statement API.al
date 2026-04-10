page 96761 "FRE Bank Statement API"
{
    PageType = API;
    SourceTable = "FRE Bank Statement";

    APIPublisher = 'onedata';
    APIGroup = 'operations';
    APIVersion = 'v1.0';

    EntityName = 'freeBankStatement';
    EntitySetName = 'freeBankStatements';

    ODataKeyFields = SystemId;

    DelayedInsert = true;
    InsertAllowed = true;
    ModifyAllowed = false;
    DeleteAllowed = false;
    Editable = true;

    Permissions =
        tabledata "FRE Bank Statement" = RIMD;
    ApplicationArea = All;

    layout
    {
        area(content)
        {
            repeater(Group)
            {
                // 🔑 clave estándar

                field(systemId; Rec.SystemId) { }
                field(company; Rec.Company) { }
                field(year; Rec.Year) { }
                field(month; Rec.Month) { }
                field(bankAccountNo; Rec."Bank Account No.") { }
                field(counterparty; Rec."Bal. Account No.") { }
                field(targetJournal; Rec."Target Journal") { }
                field(defaultGenJournalTemplate; Rec."Default Gen. Journal Template") { }
                field(defaultGenJournalBatch; Rec."Default Gen. Journal Batch") { }
                field(defaultFreJournalTemplate; Rec."Default FRE Journal Template") { }
                field(defaultFreJournalBatch; Rec."Default FRE Journal Batch") { }
                field(sharePointUrl; Rec."SharePoint URL") { }

                field(status; Rec.Status) {}
                field(imported; Rec.Imported) { }
                field(posted; Rec.Posted) { }
            }
        }
    }

    trigger OnInsertRecord(BelowxRec: Boolean): Boolean
    begin
        // ValidateMandatoryFields();
        // ValidatePeriod();
        // ValidateSharePointUrl();
        //CheckDuplicates();


        Rec.Status := Rec.Status::Pending;
        Rec.Imported := false;
        Rec.Posted := false;

        exit(true);
    end;

    local procedure ValidateMandatoryFields()
    begin
        if Rec.Company = '' then
            Error('Company is required.');

        if Rec.Year = 0 then
            Error('Year is required.');

        if Rec.Month = 0 then
            Error('Month is required.');

        if Rec."SharePoint URL" = '' then
            Error('SharePoint URL is required.');
    end;

    local procedure ValidatePeriod()
    begin
        if (Rec.Month < 1) or (Rec.Month > 12) then
            Error('Month must be between 1 and 12.');

        if (Rec.Year < 2000) or (Rec.Year > 2100) then
            Error('Year is not valid.');
    end;

    local procedure ValidateSharePointUrl()
    begin
        if StrPos(LowerCase(Rec."SharePoint URL"), 'http') <> 1 then
            Error('SharePoint URL must start with http/https.');

        if StrPos(LowerCase(Rec."SharePoint URL"), 'sharepoint') = 0 then
            Error('URL must be a valid SharePoint link.');
    end;

    local procedure CheckDuplicates()
    var
        Existing: Record "FRE Bank Statement";
    begin
        Existing.Reset();
        Existing.SetRange(Company, Rec.Company);
        Existing.SetRange(Year, Rec.Year);
        Existing.SetRange(Month, Rec.Month);
        Existing.SetRange("SharePoint URL", Rec."SharePoint URL");

        if Existing.FindFirst() then
            Error('A bank statement already exists for this Company, Period and SharePoint document.');
    end;
}
