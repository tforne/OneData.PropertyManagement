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
        AllProfile  : Record "All Profile";
    
    begin
        AllProfile.reset;
        AllProfile.setrange("Profile ID",'PRESIDENTE - EMPR. REAL ESTATE');
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
            ReportSelections."Report ID" := Report:: "Lease Sales - Invoice";
            if ReportSelections.Insert() then;
        end;
    end;

    local procedure InsTenantUserMapping()
    var
        TenantUserMApping : Record "Tenant User Mapping";
    begin
            TenantUserMApping.Init();
            TenantUserMApping."User Email" := 'office@forne.family';
            TenantUserMApping."Customer No." := 'C00300';
            if TenantUserMApping.Insert() then;
    end;

    procedure ConfigurarREFSetup()
    var
        REFSetup: Record "REF Setup";
        NoSeries : record "No. Series";
        NoSeriesLine : Record "No. Series Line";
    begin
        if not REFSetup.get('') then  begin
            REFSetup."Primary Key":='';
            REFSetup.insert;
        end;
        // Incicializar Series
        if REFSetup."Contract Invoice Nos." = '' then begin
            NoSeries.Code := 'PM-CTINV';
            NoSeries.Description := 'Property Management Contract Invoice';
            NoSeries.insert;
            NoSeriesLine."Series Code" :=  'PM-CTINV';
            NoSeriesLine."Line No." := 10000;
            NoSeriesLine."Starting Date" := today;
            NoSeriesLine.Insert(true);
            NoSeriesLine."Starting No." := 'PM-26-00001';
            NoSeriesLine.modify;
            REFSetup."Contract Invoice Nos." := 'PM-CTINV';
            REFSetup.MODIFY;
        end;
            // if REFSetup."Contract Lease Invoice Nos."
            // if REFSetup."Fixed Asset Nos."
            // if REFSetup."Insurance Nos."
            // if REFSetup."Lease Contract Nos."
    end;          
}