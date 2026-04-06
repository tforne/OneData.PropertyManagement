// ------------------------------------------------------------------------------------------------
// Copyright (c) Tomàs Forné Martínez. All rights reserved.
// ------------------------------------------------------------------------------------------------

namespace OneData.Property.Setup;

using Microsoft.Finance.GeneralLedger.Account;
using Microsoft.Foundation.NoSeries;
using Microsoft.CRM.BusinessRelation;

table 96003 "REF Setup"
{
    Caption = 'REF Setup';

    fields
    {
        field(1; "Primary Key"; Code[10])
        {
            Caption = 'Primary Key';
        }
        field(7; "Service Charge Acc."; Code[20])
        {
            Caption = 'Service Charge Acc.';
            DataClassification = ToBeClassified;
            TableRelation = "G/L Account";
        }
        field(8; "Lease Contract Nos."; Code[20])
        {
            Caption = 'Lease Contract Nos.';
            DataClassification = ToBeClassified;
            TableRelation = "No. Series";
        }
        field(9; "Fixed Asset Nos."; Code[20])
        {
            Caption = 'Real Estate Asset Nos.';
            TableRelation = "No. Series";
        }
        field(10; "Insurance Nos."; Code[20])
        {
            AccessByPermission = TableData 5628 = R;
            Caption = 'Insurance Nos.';
            TableRelation = "No. Series";
        }
        field(11; "Contract Invoice Nos."; Code[20])
        {
            Caption = 'Contract Invoice Nos.';
            DataClassification = ToBeClassified;
            TableRelation = "No. Series";
        }
        field(12; "Contract Lease Invoice Nos."; Code[20])
        {
            Caption = 'Contract Lease Invoice Nos.';
            DataClassification = ToBeClassified;
            TableRelation = "No. Series";
        }
        field(13; "Statement Bank Nos."; Code[20])
        {
            Caption = 'Statement Bank Nos.';
            DataClassification = ToBeClassified;
            TableRelation = "No. Series";
        }
        field(200; "Repository Contracts Files"; Text[250])
        {
            Caption = 'Repositorio contratos';
            DataClassification = ToBeClassified;
        }
        field(201; "Repository Lease Invoices"; Text[250])
        {
            Caption = 'Repositorio recibos alquiler';
            DataClassification = ToBeClassified;
        }
        field(202; "Bus. Rel. Code for Visits"; Code[20])
        {
            Caption = 'Cod. rel. negocio visitas';
            DataClassification = ToBeClassified;
            TableRelation = "Business Relation".Code;
        }
        field(203; "Bus. Rel. Code for Owner"; Code[20])
        {
            Caption = 'Cod. rel. negocio propietarios';
            DataClassification = ToBeClassified;
            TableRelation = "Business Relation".Code;
        }
        field(204; "Bus. Rel. Code for Partner"; Code[20])
        {
            Caption = 'Cod. rel. negocio colaboradores';
            DataClassification = ToBeClassified;
            TableRelation = "Business Relation".Code;
        }
        field(300; "Journal Template Name"; Code[10])
        {
            Caption = 'Journal Template Name';
            TableRelation = "FRE Jnl. Template";
        }
        field(301; "Journal Batch Name"; Code[10])
        {
            Caption = 'Journal Batch Name';
            TableRelation = "FRE Jnl. Batch".Name WHERE("Journal Template Name" = FIELD("Journal Template Name"));
        }
        field(302; "Default Income Row No"; Code[10])
        {
            Caption = 'Default income row number';
            TableRelation = "REF Income & Expense Template"."Row No.";
            ValidateTableRelation = false;
        }
        field(60000; "Interaction Template Filter"; Text[30])
        {
        }
    }

    keys
    {
        key(Key1; "Primary Key")
        {
            Clustered = true;
        }
    }

    fieldgroups
    {
    }

}

