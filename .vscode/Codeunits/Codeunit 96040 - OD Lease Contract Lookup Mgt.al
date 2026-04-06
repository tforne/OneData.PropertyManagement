namespace OneData.Property.Lease;

codeunit 96040 "OD Lease Contract Lookup Mgt."
{
    procedure LookupContractFromCompany(SourceCompanyName: Text[30]; var SelectedContractNo: Code[20]): Boolean
    var
        SourceHeader: Record "Lease Contract";
        TempBuffer: Record "OD Lease Contract Buffer" temporary;
        LookupPage: Page "OD Lease Contract Lookup";
        EntryNo: Integer;
    begin
        SourceHeader.ChangeCompany(SourceCompanyName);

        if SourceHeader.FindSet() then
            repeat
                EntryNo += 1;
                TempBuffer.Init();
                TempBuffer."Entry No." := EntryNo;
                TempBuffer."Company Name" := SourceCompanyName;
                TempBuffer."Contract No." := SourceHeader."Contract No.";
                TempBuffer.Description := SourceHeader.Description;
                TempBuffer."Customer No." := SourceHeader."Customer No.";
                TempBuffer."Fixed Real Estate No." := SourceHeader."Fixed Real Estate No.";
                TempBuffer."Starting Date" := SourceHeader."Starting Date";
                TempBuffer."Expiration Date" := SourceHeader."Expiration Date";
                TempBuffer.StatusText := Format(SourceHeader.Status);
                TempBuffer.Insert();
            until SourceHeader.Next() = 0;

        if TempBuffer.IsEmpty() then
            Error('No se han encontrado contratos en la empresa %1.', SourceCompanyName);

        LookupPage.SetTableView(TempBuffer);
        LookupPage.LookupMode(true);

        if LookupPage.RunModal() = Action::LookupOK then begin
            LookupPage.GetRecord(TempBuffer);
            SelectedContractNo := TempBuffer."Contract No.";
            exit(true);
        end;

        exit(false);
    end;
}
