codeunit 50501 GeneralManagementInstall
{
    Subtype = Install;
    Permissions = TableData "G/L Entry" = rmid;

    trigger OnInstallAppPerDatabase()
    var
    begin
    end;

    trigger OnInstallAppPerCompany()
    var
    begin
        installNewVersion();
        InsertReportSelections();
        InsTenantUserMapping();
    end;

    procedure installNewVersion()
    var
        AllProfile: Record "All Profile";

    begin
        AllProfile.reset;
        AllProfile.setrange("Profile ID", 'PRESIDENTE - EMPR. REAL ESTATE');
        if AllProfile.FindFirst() then begin
            AllProfile.delete;
            message('Perfil eliminado')
        end;
    end;

    local procedure InsertReportSelections()
    var
        ReportSelections: Record "Report Selections";
    begin
        if not ReportSelections.Get(
            Enum::"Report Selection Usage"::"Lease S.Invoice",
            Report::"Standard Sales - Invoice")
        then begin
            ReportSelections.Init();
            ReportSelections."Usage" := Enum::"Report Selection Usage"::"Lease S.Invoice";
            ReportSelections."Report ID" := Report::"Lease Sales - Invoice";
            if ReportSelections.Insert() then;
        end;
    end;

    
    local procedure InsTenantUserMapping()
    var
        TenantUserMApping: Record "Tenant User Mapping";
    begin
        TenantUserMApping.Init();
        TenantUserMApping."User Email" := 'office@forne.family';
        TenantUserMApping."Customer No." := 'C00300';
        if TenantUserMApping.Insert() then;
    end;

    procedure ConfigurarREFSetup()
    var
        REFSetup: Record "REF Setup";
        NoSeries: record "No. Series";
        NoSeriesLine: Record "No. Series Line";
    begin
        if not REFSetup.get('') then begin
            REFSetup."Primary Key" := '';
            REFSetup.insert;
        end;
        // Incicializar Series
        if REFSetup."Contract Invoice Nos." = '' then begin
            NoSeries.Code := 'PM-CTINV';
            NoSeries.Description := 'Property Management Contract Invoice';
            NoSeries."Manual Nos." := true;
            NoSeries."Default Nos." := true;
            NoSeries.insert;
            NoSeriesLine."Series Code" := 'PM-CTINV';
            NoSeriesLine."Line No." := 10000;
            NoSeriesLine."Starting Date" := today;
            NoSeriesLine.Insert(true);
            NoSeriesLine."Starting No." := StrSubstNo('PM-%1-00001', Date2DMY(today, 3) - 2000);
            NoSeriesLine.modify;
            REFSetup."Contract Invoice Nos." := 'PM-CTINV';
            REFSetup.MODIFY;
        end;
        if REFSetup."Contract Lease Invoice Nos." = '' then begin
            NoSeries.Code := 'PM-CTLEASINV';
            NoSeries.Description := 'Property Management Contract Lease Invoice';
            NoSeries."Manual Nos." := true;
            NoSeries."Default Nos." := true;
            NoSeries.insert;
            NoSeriesLine."Series Code" := 'PM-CTLEASINV';
            NoSeriesLine."Line No." := 10000;
            NoSeriesLine."Starting Date" := today;
            NoSeriesLine.Insert(true);
            NoSeriesLine."Starting No." := StrSubstNo('CT-%1-00001', Date2DMY(today, 3) - 2000);
            NoSeriesLine.modify;
            REFSetup.MODIFY;
        end;
        if REFSetup."Fixed Asset Nos." = '' then begin
            NoSeries.Code := 'PM-FA';
            NoSeries.Description := 'Property Management real estate asset';
            NoSeries."Manual Nos." := true;
            NoSeries."Default Nos." := true;
            NoSeries.insert;
            NoSeriesLine."Series Code" := 'PM-FA';
            NoSeriesLine."Line No." := 10000;
            NoSeriesLine."Starting Date" := today;
            NoSeriesLine.Insert(true);
            NoSeriesLine."Starting No." := StrSubstNo('FA-%1-00001', Date2DMY(today, 3) - 2000);
            NoSeriesLine.modify;
            REFSetup."Fixed Asset Nos." := 'PM-FA';
            REFSetup.MODIFY;
        end;
        if REFSetup."Insurance Nos." = '' then begin
            NoSeries.Code := 'PM-INS';
            NoSeries.Description := 'Property Management Insurance';
            NoSeries."Manual Nos." := true;
            NoSeries."Default Nos." := true;
            NoSeries.insert;
            NoSeriesLine."Series Code" := 'PM-INS';
            NoSeriesLine."Line No." := 10000;
            NoSeriesLine."Starting Date" := today;
            NoSeriesLine.Insert(true);
            NoSeriesLine."Starting No." := StrSubstNo('INS-%1-00001', Date2DMY(today, 3) - 2000);
            NoSeriesLine.modify;
            REFSetup."Insurance Nos." := 'PM-INS';
            REFSetup.MODIFY;
        end;
        if REFSetup."Lease Contract Nos." = '' then begin
            NoSeries.Code := 'PM-LEAS';
            NoSeries.Description := 'Property Management Lease Contract';
            NoSeries."Manual Nos." := true;
            NoSeries."Default Nos." := true;
            NoSeries.insert;
            NoSeriesLine."Series Code" := 'PM-LEAS';
            NoSeriesLine."Line No." := 10000;
            NoSeriesLine."Starting Date" := today;
            NoSeriesLine.Insert(true);
            NoSeriesLine."Starting No." := StrSubstNo('LEAS-%1-00001', Date2DMY(today, 3) - 2000);
            NoSeriesLine.modify;
            REFSetup."Lease Contract Nos." := 'PM-LEAS';
            REFSetup.MODIFY;
        end;
    end;
}