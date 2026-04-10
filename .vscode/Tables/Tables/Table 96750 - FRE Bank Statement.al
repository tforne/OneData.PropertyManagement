// ------------------------------------------------------------------------------------------------
// Copyright (c) Tomàs Forné Martínez. All rights reserved.
// ------------------------------------------------------------------------------------------------


namespace OneData.Property.Asset;
using Microsoft.Finance.GeneralLedger.Journal;
using OneData.Property.Setup;
using Microsoft.Foundation.NoSeries;
using Microsoft.Finance.GeneralLedger.Account;
using Microsoft.Bank.BankAccount;


table 96750 "FRE Bank Statement"
{
    Caption = 'FRE Bank Statement';
    DataClassification = CustomerContent;

    fields
    {

        field(1; "No."; Code[20])
        {
            Caption = 'No.';
            Editable = false;
            DataClassification = SystemMetadata;
        }
        field(2; Company; Code[20])
        {
            Caption = 'Company';
        }

        field(3; Year; Integer)
        {
            Caption = 'Year';
        }

        field(4; Month; Option)
        {
            Caption = 'Month';
            OptionMembers = January,February,March,April,May,June,July,August,September,October,November,December;
        }

        field(5; "SharePoint URL"; Text[250])
        {
            Caption = 'SharePoint URL';

            trigger OnValidate()
            begin
                ValidateSharePointUrl("SharePoint URL");
            end;
        }

        field(6; Status; Option)
        {
            Caption = 'Status';
            OptionMembers = Pending,Imported,Validated,Posted;
        }

        field(7; Imported; Boolean)
        {
            Caption = 'Imported';
        }

        field(8; Posted; Boolean)
        {
            Caption = 'Posted';
        }
        field(9; "Bank Account No."; Code[20])
        {
            Caption = 'Código banco';
            TableRelation = "Bank Account";
        }
        field(10; "Bal. Account No."; Code[20])
        {
            Caption = 'Contrapartida';
            TableRelation = "G/L Account"."No." where ("Account Type" = const(Posting));
        }
        field(11; "Target Journal"; Option)
        {
            Caption = 'Diario destino';
            OptionMembers = "FRE Journal","Gen Journal";
            OptionCaption = 'FRE Journal,Gen Journal';
        }

        field(30; "Default Gen. Journal Template"; Code[10])
        {
            Caption = 'Plantilla diario general por defecto';
            TableRelation = "Gen. Journal Template".Name;
        }

        field(31; "Default Gen. Journal Batch"; Code[10])
        {
            Caption = 'Sección diario general por defecto';
            TableRelation = "Gen. Journal Batch".Name where("Journal Template Name" = field("Default Gen. Journal Template"));
        }

        field(40; "Default FRE Journal Template"; Code[10])
        {
            Caption = 'Plantilla diario FRE por defecto';
            TableRelation = "FRE Jnl. Template".Name;
        }

        field(41; "Default FRE Journal Batch"; Code[10])
        {
            Caption = 'Sección diario FRE por defecto';
            TableRelation = "FRE Jnl. Batch".Name where("Journal Template Name" = field("Default FRE Journal Template"));
        }

    }

    keys
    {
        key(PK; "No.")
        {
            Clustered = true;
        }
    }
    trigger OnInsert()
    var
        NoSeriesCode: Code[20];
        REFASetup: Record "REF Setup";
        FREExcelTemplateSetup: Record "FRE Excel Template Setup";
        NoSeriesMgt: Codeunit "No. Series";
    begin
        IF "No." = '' THEN BEGIN
            REFASetup.GET;
            REFASetup.TESTFIELD("Statement Bank Nos.");
            NoSeriesCode := REFASetup."Statement Bank Nos.";
            "No." := NoSeriesMgt.GetNextNo(NoSeriesCode, WorkDate(), true);
        END;

        if FREExcelTemplateSetup.Get('SETUP') then begin
            "Default Gen. Journal Template" := FREExcelTemplateSetup."Default Gen. Journal Template";
            "Default Gen. Journal Batch" := FREExcelTemplateSetup."Default Gen. Journal Batch";
            "Default FRE Journal Template" := FREExcelTemplateSetup."Default FRE Journal Template";
            "Default FRE Journal Batch" := FREExcelTemplateSetup."Default FRE Journal Batch";
        end;
    end;

    local procedure ValidateSharePointUrl(SharePointUrl: Text)
    var
        LowerUrl: Text;
    begin
        if SharePointUrl = '' then
            exit;

        LowerUrl := LowerCase(SharePointUrl);

        // if StrPos(LowerUrl, 'http://') <> 1 then
        //     if StrPos(LowerUrl, 'https://') <> 1 then
        //         Error('La URL debe comenzar por http:// o https://.');

        // if StrPos(LowerUrl, 'sharepoint') = 0 then
        //     if StrPos(LowerUrl, 'sharepoint.com') = 0 then
        //         Error('La URL debe corresponder a un documento de SharePoint.');
    end;
}
