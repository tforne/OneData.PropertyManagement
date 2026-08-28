codeunit 96983 "OD FF Snapshot Mgt"
{
    procedure CreateSnapshotForCurrentUser(Description: Text; var SnapshotNo: Code[20])
    var
        Buffer: Record "OD FF Buffer";
    begin
        Buffer.SetRange("User ID", CopyStr(UserId(), 1, 50));
        if Buffer.IsEmpty() then
            Error('No existe ningún análisis para guardar.');

        CreateSnapshot(Buffer, Description, SnapshotNo);
    end;

    procedure CreateSnapshot(var Buffer: Record "OD FF Buffer"; Description: Text; var SnapshotNo: Code[20])
    var
        Setup: Record "OD FF Setup";
        Header: Record "OD FF Snapshot Header";
        Line: Record "OD FF Snapshot Line";
        LastLineNo: Integer;
    begin
        Setup.EnsureSetup();
        Setup.Get('SETUP');

        SnapshotNo := GetNextSnapshotNo();

        Header.Init();
        Header."Snapshot No." := SnapshotNo;
        Header.Description := CopyStr(Description, 1, MaxStrLen(Header.Description));
        Header."Analysis Date" := Today;
        Header."Analysis Time" := DT2Time(CurrentDateTime());
        Header."Analysis DateTime" := CurrentDateTime();
        Header."User ID" := CopyStr(UserId(), 1, 50);
        Header."Source Company" := CompanyName();
        Header.Status := Header.Status::Open;
        Header."Version No." := '1.0';
        Header.Insert();

        Buffer.FindSet();
        repeat
            LastLineNo += 10000;
            Line.Init();
            Line."Snapshot No." := Header."Snapshot No.";
            Line."Line No." := LastLineNo;
            Line."Company Name" := Buffer."Company Name";
            Line."Property No." := Buffer."Property No.";
            Line."Property Description" := Buffer."Property Description";
            Line."Contract No." := Buffer."Contract No.";
            Line."Contract Description" := Buffer."Contract Description";
            Line."Customer No." := Buffer."Customer No.";
            Line."Customer Name" := Buffer."Customer Name";
            Line."Contract Status" := Buffer."Contract Status";
            Line."Contract Start Date" := Buffer."Contract Start Date";
            Line."Contract End Date" := Buffer."Contract End Date";
            Line."Monthly Rent" := Buffer."Monthly Rent";
            Line."Annual Rent" := Buffer."Annual Rent";
            Line."Cadastral Value" := Buffer."Cadastral Value";
            Line."Purchase Price" := Buffer."Purchase Price";
            Line."Market Value" := Buffer."Market Value";
            Line."Estimated Selling Price" := Buffer."Estimated Selling Price";
            Line."Remaining Contract Income" := Buffer."Remaining Contract Income";
            Line."Forecast Income 12M" := Buffer."Forecast Income 12M";
            Line."Forecast Income 24M" := Buffer."Forecast Income 24M";
            Line."Forecast Income 60M" := Buffer."Forecast Income 60M";
            Line."Annual Operating Costs" := Buffer."Annual Operating Costs";
            Line."Annual Net Income" := Buffer."Annual Net Income";
            Line."Gross Yield Percentage" := Buffer."Gross Yield Percentage";
            Line."Net Yield Percentage" := Buffer."Net Yield Percentage";
            Line."ROI Percentage" := Buffer."ROI Percentage";
            Line."Cap Rate Percentage" := Buffer."Cap Rate Percentage";
            Line."Estimated Capital Gain" := Buffer."Estimated Capital Gain";
            Line."Cash Flow Amount" := Buffer."Cash Flow Amount";
            Line."Customer Concentration %" := Buffer."Customer Concentration %";
            Line."Risk Level" := Buffer."Risk Level";
            Line."Risk Description" := Buffer."Risk Description";
            Line."Value Source" := Buffer."Value Source";
            Line."Has Error" := Buffer."Has Error";
            Line."Error Message" := Buffer."Error Message";
            Line.Insert();
        until Buffer.Next() = 0;

        CalculateSnapshotTotals(Header);
        Header.Status := Header.Status::Closed;
        Header.Modify();

        Setup."Last Snapshot No." := Header."Snapshot No.";
        Setup.Modify();
    end;

    procedure CalculateSnapshotTotals(var Header: Record "OD FF Snapshot Header")
    var
        Line: Record "OD FF Snapshot Line";
        LastCompany: Text[30];
        LastPropertyKey: Text[100];
        TotalAnnualNetIncome: Decimal;
        PropertyValue: Decimal;
    begin
        Clear(Header."No. of Companies");
        Clear(Header."No. of Properties");
        Clear(Header."No. of Contracts");

        Line.SetRange("Snapshot No.", Header."Snapshot No.");
        if not Line.FindSet() then
            exit;

        repeat
            if Line."Company Name" <> LastCompany then begin
                Header."No. of Companies" += 1;
                LastCompany := Line."Company Name";
            end;

            if Line."Company Name" + '|' + Line."Property No." <> LastPropertyKey then begin
                Header."No. of Properties" += 1;
                LastPropertyKey := CopyStr(Line."Company Name" + '|' + Line."Property No.", 1, MaxStrLen(LastPropertyKey));
                PropertyValue := GetSnapshotPropertyValue(Line);
                Header."Total Market Value" += PropertyValue;
            end;

            Header."No. of Contracts" += 1;
            Header."Total Monthly Rent" += Line."Monthly Rent";
            Header."Total Annual Rent" += Line."Annual Rent";
            Header."Total Cadastral Value" += Line."Cadastral Value";
            Header."Total Purchase Price" += Line."Purchase Price";
            Header."Total Est. Selling Price" += Line."Estimated Selling Price";
            Header."Forecast Income 12M" += Line."Forecast Income 12M";
            Header."Forecast Income 24M" += Line."Forecast Income 24M";
            Header."Forecast Income 60M" += Line."Forecast Income 60M";
            Header."Total Cash Flow" += Line."Cash Flow Amount";
            TotalAnnualNetIncome += Line."Annual Net Income";
            if Line."Risk Level" = Line."Risk Level"::High then
                Header."High Risk Contracts" += 1;
            if Line."Risk Level" = Line."Risk Level"::Critical then
                Header."Critical Risk Contracts" += 1;
        until Line.Next() = 0;

        if Header."Total Market Value" <> 0 then begin
            Header."Weighted Gross Yield %" := (Header."Total Annual Rent" / Header."Total Market Value") * 100;
            Header."Weighted Net Yield %" := (TotalAnnualNetIncome / Header."Total Market Value") * 100;
        end;

        Header.Modify();
    end;

    local procedure GetSnapshotPropertyValue(Line: Record "OD FF Snapshot Line"): Decimal
    begin
        case Line."Value Source" of
            Line."Value Source"::MarketValue:
                if Line."Market Value" <> 0 then
                    exit(Line."Market Value");
            Line."Value Source"::EstimatedSellingPrice:
                if Line."Estimated Selling Price" <> 0 then
                    exit(Line."Estimated Selling Price");
            Line."Value Source"::PurchasePrice:
                if Line."Purchase Price" <> 0 then
                    exit(Line."Purchase Price");
            Line."Value Source"::CadastralValue:
                if Line."Cadastral Value" <> 0 then
                    exit(Line."Cadastral Value");
        end;

        if Line."Market Value" <> 0 then
            exit(Line."Market Value");
        if Line."Estimated Selling Price" <> 0 then
            exit(Line."Estimated Selling Price");
        if Line."Purchase Price" <> 0 then
            exit(Line."Purchase Price");
        if Line."Cadastral Value" <> 0 then
            exit(Line."Cadastral Value");

        exit(0);
    end;

    procedure DeleteSnapshot(SnapshotNo: Code[20])
    var
        Header: Record "OD FF Snapshot Header";
        Line: Record "OD FF Snapshot Line";
    begin
        if not Header.Get(SnapshotNo) then
            exit;

        Line.SetRange("Snapshot No.", SnapshotNo);
        if not Line.IsEmpty() then
            Line.DeleteAll();

        Header.Delete();
    end;

    procedure CompareLastTwoSnapshotsForCurrentUser()
    var
        Header: Record "OD FF Snapshot Header";
        SnapshotNo1: Code[20];
        SnapshotNo2: Code[20];
    begin
        Header.SetCurrentKey("Analysis DateTime");
        if not Header.FindLast() then
            Error('No existen snapshots para comparar.');

        SnapshotNo2 := Header."Snapshot No.";
        if Header.Next(-1) = 0 then
            Error('Se necesitan al menos dos snapshots para comparar.');
        SnapshotNo1 := Header."Snapshot No.";

        CompareSnapshots(SnapshotNo1, SnapshotNo2);
    end;

    procedure CompareSnapshots(SnapshotNo1: Code[20]; SnapshotNo2: Code[20])
    var
        CompareBuffer: Record "OD FF Compare Buffer";
        Line1: Record "OD FF Snapshot Line";
        Line2: Record "OD FF Snapshot Line";
    begin
        CompareBuffer.SetRange("User ID", CopyStr(UserId(), 1, 50));
        if not CompareBuffer.IsEmpty() then
            CompareBuffer.DeleteAll();

        Line2.SetRange("Snapshot No.", SnapshotNo2);
        if Line2.FindSet() then
            repeat
                if FindSnapshotLine(Line1, SnapshotNo1, Line2."Company Name", Line2."Property No.", Line2."Contract No.") then
                    InsertCompareLine(Line1, Line2, 'Modificado')
                else
                    InsertAddedRemovedLine(Line2, SnapshotNo1, SnapshotNo2, 'Alta');
            until Line2.Next() = 0;

        Line1.SetRange("Snapshot No.", SnapshotNo1);
        if Line1.FindSet() then
            repeat
                if not FindSnapshotLine(Line2, SnapshotNo2, Line1."Company Name", Line1."Property No.", Line1."Contract No.") then
                    InsertAddedRemovedLine(Line1, SnapshotNo1, SnapshotNo2, 'Baja');
            until Line1.Next() = 0;
    end;

    local procedure GetNextSnapshotNo(): Code[20]
    var
        Header: Record "OD FF Snapshot Header";
        CountForYear: Integer;
        CurrentYearTxt: Text;
    begin
        CurrentYearTxt := Format(Date2DMY(Today, 3));
        Header.SetFilter("Snapshot No.", 'FFM-%1-*', CurrentYearTxt);
        CountForYear := Header.Count + 1;
        exit(CopyStr(StrSubstNo('FFM-%1-%2', Date2DMY(Today, 3), PadStr(Format(CountForYear), 6, '0')), 1, 20));
    end;

    local procedure FindSnapshotLine(var SnapshotLine: Record "OD FF Snapshot Line"; SnapshotNo: Code[20]; CompanyName: Text[30]; PropertyNo: Code[20]; ContractNo: Code[20]): Boolean
    begin
        SnapshotLine.Reset();
        SnapshotLine.SetRange("Snapshot No.", SnapshotNo);
        SnapshotLine.SetRange("Company Name", CompanyName);
        SnapshotLine.SetRange("Property No.", PropertyNo);
        SnapshotLine.SetRange("Contract No.", ContractNo);
        exit(SnapshotLine.FindFirst());
    end;

    local procedure InsertCompareLine(Line1: Record "OD FF Snapshot Line"; Line2: Record "OD FF Snapshot Line"; ChangeType: Text[30])
    var
        CompareBuffer: Record "OD FF Compare Buffer";
    begin
        CompareBuffer.Init();
        CompareBuffer."User ID" := CopyStr(UserId(), 1, 50);
        CompareBuffer."Snapshot No. 1" := Line1."Snapshot No.";
        CompareBuffer."Snapshot No. 2" := Line2."Snapshot No.";
        CompareBuffer."Company Name" := Line2."Company Name";
        CompareBuffer."Property No." := Line2."Property No.";
        CompareBuffer."Contract No." := Line2."Contract No.";
        CompareBuffer.Description := CopyStr(Line2."Property Description" + ' / ' + Line2."Contract Description", 1, MaxStrLen(CompareBuffer.Description));
        CompareBuffer."Change Type" := ChangeType;
        CompareBuffer."Monthly Rent Delta" := Line2."Monthly Rent" - Line1."Monthly Rent";
        CompareBuffer."Annual Rent Delta" := Line2."Annual Rent" - Line1."Annual Rent";
        CompareBuffer."Market Value Delta" := Line2."Market Value" - Line1."Market Value";
        CompareBuffer."Cadastral Value Delta" := Line2."Cadastral Value" - Line1."Cadastral Value";
        CompareBuffer."Selling Price Delta" := Line2."Estimated Selling Price" - Line1."Estimated Selling Price";
        CompareBuffer."Gross Yield Delta" := Line2."Gross Yield Percentage" - Line1."Gross Yield Percentage";
        CompareBuffer."Net Yield Delta" := Line2."Net Yield Percentage" - Line1."Net Yield Percentage";
        CompareBuffer."Cash Flow Delta" := Line2."Cash Flow Amount" - Line1."Cash Flow Amount";
        CompareBuffer.Insert();
    end;

    local procedure InsertAddedRemovedLine(Line: Record "OD FF Snapshot Line"; SnapshotNo1: Code[20]; SnapshotNo2: Code[20]; ChangeType: Text[30])
    var
        CompareBuffer: Record "OD FF Compare Buffer";
    begin
        CompareBuffer.Init();
        CompareBuffer."User ID" := CopyStr(UserId(), 1, 50);
        CompareBuffer."Snapshot No. 1" := SnapshotNo1;
        CompareBuffer."Snapshot No. 2" := SnapshotNo2;
        CompareBuffer."Company Name" := Line."Company Name";
        CompareBuffer."Property No." := Line."Property No.";
        CompareBuffer."Contract No." := Line."Contract No.";
        CompareBuffer.Description := CopyStr(Line."Property Description" + ' / ' + Line."Contract Description", 1, MaxStrLen(CompareBuffer.Description));
        CompareBuffer."Change Type" := ChangeType;
        if ChangeType = 'Alta' then begin
            CompareBuffer."Monthly Rent Delta" := Line."Monthly Rent";
            CompareBuffer."Annual Rent Delta" := Line."Annual Rent";
            CompareBuffer."Market Value Delta" := Line."Market Value";
            CompareBuffer."Cadastral Value Delta" := Line."Cadastral Value";
            CompareBuffer."Selling Price Delta" := Line."Estimated Selling Price";
            CompareBuffer."Gross Yield Delta" := Line."Gross Yield Percentage";
            CompareBuffer."Net Yield Delta" := Line."Net Yield Percentage";
            CompareBuffer."Cash Flow Delta" := Line."Cash Flow Amount";
        end else begin
            CompareBuffer."Monthly Rent Delta" := -Line."Monthly Rent";
            CompareBuffer."Annual Rent Delta" := -Line."Annual Rent";
            CompareBuffer."Market Value Delta" := -Line."Market Value";
            CompareBuffer."Cadastral Value Delta" := -Line."Cadastral Value";
            CompareBuffer."Selling Price Delta" := -Line."Estimated Selling Price";
            CompareBuffer."Gross Yield Delta" := -Line."Gross Yield Percentage";
            CompareBuffer."Net Yield Delta" := -Line."Net Yield Percentage";
            CompareBuffer."Cash Flow Delta" := -Line."Cash Flow Amount";
        end;
        CompareBuffer.Insert();
    end;
}
