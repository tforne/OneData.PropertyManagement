// ------------------------------------------------------------------------------------------------
// Copyright (c) Tomàs Forné Martínez. All rights reserved.
// ------------------------------------------------------------------------------------------------

namespace OneData.Property.Finance;

using Microsoft.Bank.BankAccount;
using Microsoft.CRM.Contact;
using Microsoft.CRM.Team;
using Microsoft.Finance.Currency;
using Microsoft.Finance.Dimension;
using Microsoft.Finance.GeneralLedger.Setup;
using Microsoft.Finance.SalesTax;
using Microsoft.Finance.VAT.Setup;
using Microsoft.Foundation.Address;
using Microsoft.Foundation.AuditCodes;
using Microsoft.Foundation.Navigate;
using Microsoft.Foundation.NoSeries;
using Microsoft.Foundation.PaymentTerms;
using Microsoft.Foundation.Reporting;
using Microsoft.Inventory.Location;
using Microsoft.Sales.Customer;
using Microsoft.Sales.Document;
using Microsoft.Sales.History;
using Microsoft.Sales.Pricing;
using Microsoft.Sales.Receivables;
using OneData.Fiscal;
using OneData.Property.Asset;
using OneData.Property.Lease;
using OneData.Property.Setup;
using System.EMail;
using System.Globalization;
using System.Security.AccessControl;
using System.Security.User;

table 96021 "Lease Invoice Header"
{
    Caption = 'Lease Invoice Header';
    DataCaptionFields = "No.", Name;

    fields
    {
        field(2; "Customer No."; Code[20])
        {
            Caption = 'Customer No.';
            NotBlank = true;
            TableRelation = Customer;
        }
        field(3; "No."; Code[20])
        {
            Caption = 'No.';
        }
        field(11; "Your Reference"; Text[35])
        {
            Caption = 'Your Reference';
        }
        field(20; "Posting Date"; Date)
        {
            Caption = 'Posting Date';
        }
        field(22; "Posting Description"; Text[50])
        {
            Caption = 'Posting Description';
        }
        field(23; "Payment Terms Code"; Code[10])
        {
            Caption = 'Payment Terms Code';
            TableRelation = "Payment Terms";

            trigger OnValidate()
            begin
                PaymentTerms.GET("Payment Terms Code");
                "Due Date" := CALCDATE(PaymentTerms."Due Date Calculation", "Document Date");
            end;
        }
        field(24; "Due Date"; Date)
        {
            Caption = 'Due Date';
        }
        field(29; "Shortcut Dimension 1 Code"; Code[20])
        {
            CaptionClass = '1,2,1';
            Caption = 'Shortcut Dimension 1 Code';
            TableRelation = "Dimension Value".Code WHERE ("Global Dimension No."=CONST(1));
        }
        field(30; "Shortcut Dimension 2 Code"; Code[20])
        {
            CaptionClass = '1,2,2';
            Caption = 'Shortcut Dimension 2 Code';
            TableRelation = "Dimension Value".Code WHERE ("Global Dimension No."=CONST(2));
        }
        field(31; "Customer Posting Group"; Code[20])
        {
            Caption = 'Customer Posting Group';
            Editable = false;
            TableRelation = "Customer Posting Group";
        }
        field(32; "Currency Code"; Code[10])
        {
            Caption = 'Currency Code';
            Editable = false;
            TableRelation = Currency;
        }
        field(33; "Currency Factor"; Decimal)
        {
            Caption = 'Currency Factor';
            DecimalPlaces = 0 : 15;
            MinValue = 0;
        }
        field(34; "Customer Price Group"; Code[10])
        {
            Caption = 'Customer Price Group';
            TableRelation = "Customer Price Group";
        }
        field(35; "Prices Including VAT"; Boolean)
        {
            Caption = 'Prices Including VAT';
        }
        field(37; "Invoice Disc. Code"; Code[20])
        {
            Caption = 'Invoice Disc. Code';
        }
        field(40; "Customer Disc. Group"; Code[20])
        {
            Caption = 'Customer Disc. Group';
            TableRelation = "Customer Discount Group";
        }
        field(41; "Language Code"; Code[10])
        {
            Caption = 'Language Code';
            TableRelation = Language;
        }
        field(43; "Salesperson Code"; Code[20])
        {
            Caption = 'Salesperson Code';
            TableRelation = "Salesperson/Purchaser";
        }
        field(46; Open; Boolean)
        {
            Caption = 'Open';
        }
        field(47; "Applies-to ID"; Code[50])
        {
            Caption = 'Applies-to ID';

            trigger OnValidate()
            begin
                TestField(Open, true);
            end;
        }
        field(60;Amount;Decimal)
        {
            AutoFormatExpression = "Currency Code";
            AutoFormatType = 1;
            CalcFormula = Sum("Lease Invoice Line".Amount WHERE ("Document No."=FIELD("No.")));
            Caption = 'Amount';
            Editable = false;
            FieldClass = FlowField;
        }
        field(61;"Amount Including VAT";Decimal)
        {
            AutoFormatExpression = "Currency Code";
            AutoFormatType = 1;
            CalcFormula = Sum("Lease Invoice Line"."Amount Including VAT" WHERE ("Document No."=FIELD("No.")));
            Caption = 'Amount Including VAT';
            Editable = false;
            FieldClass = FlowField;
        }
        field(63;"Posting No.";Code[20])
        {
            Caption = 'Posting No.';
        }
        field(65;"Last Posting No.";Code[20])
        {
            Caption = 'Last Posting No.';
            Editable = false;
            TableRelation = "Sales Invoice Header";
        }
        field(70;"VAT Registration No.";Text[20])
        {
            Caption = 'VAT Registration No.';
        }
        field(74;"Gen. Bus. Posting Group";Code[20])
        {
            Caption = 'Gen. Bus. Posting Group';
            TableRelation = "Gen. Business Posting Group";
        }
        field(79;Name;Text[50])
        {
            Caption = 'Name';
        }
        field(80;"Name 2";Text[50])
        {
            Caption = 'Name 2';
        }
        field(81;Address;Text[50])
        {
            Caption = 'Address';
        }
        field(82;"Address 2";Text[50])
        {
            Caption = 'Address 2';
        }
        field(83;City;Text[30])
        {
            Caption = 'City';
            TableRelation = "Post Code".City;
            //This property is currently not supported
            //TestTableRelation = false;
            ValidateTableRelation = false;
        }
        field(84;"Contact Name";Text[50])
        {
            Caption = 'Contact Name';
        }
        field(88;"Post Code";Code[20])
        {
            Caption = 'Post Code';
            TableRelation = "Post Code";
            //This property is currently not supported
            //TestTableRelation = false;
            ValidateTableRelation = false;
        }
        field(89;County;Text[30])
        {
            CaptionClass = '5,1,' + "Country/Region Code";
            Caption = 'County';
        }
        field(90;"Country/Region Code";Code[10])
        {
            Caption = 'Country/Region Code';
            TableRelation = "Country/Region";
        }
        field(99;"Document Date";Date)
        {
            Caption = 'Document Date';
        }
        field(104;"Payment Method Code";Code[10])
        {
            Caption = 'Payment Method Code';
            TableRelation = "Payment Method";
        }
        field(107;"Pre-Assigned No. Series";Code[20])
        {
            Caption = 'Pre-Assigned No. Series';
            Editable = false;
            TableRelation = "No. Series";
        }
        field(108;"No. Series";Code[20])
        {
            Caption = 'No. Series';
            TableRelation = "No. Series";
        }
        field(112;"User ID";Code[50])
        {
            Caption = 'User ID';
            DataClassification = EndUserIdentifiableInformation;
            TableRelation = User."User Name";
            //This property is currently not supported
            //TestTableRelation = false;

            trigger OnLookup()
            var
                UserMgt: Codeunit "User Management";
            begin
            //    UserMgt.LookupUserID("User ID");
            end;
        }
        field(113;"Source Code";Code[10])
        {
            Caption = 'Source Code';
            TableRelation = "Source Code";
        }
        field(114;"Tax Area Code";Code[20])
        {
            Caption = 'Tax Area Code';
            TableRelation = "Tax Area";
        }
        field(115;"Tax Liable";Boolean)
        {
            Caption = 'Tax Liable';
        }
        field(116;"VAT Bus. Posting Group";Code[20])
        {
            Caption = 'VAT Bus. Posting Group';
            TableRelation = "VAT Business Posting Group";
        }
        field(119;"VAT Base Discount %";Decimal)
        {
            Caption = 'VAT Base Discount %';
            DecimalPlaces = 0:5;
            MaxValue = 100;
            MinValue = 0;
        }
        field(200; Status; Enum "Status Lease Invoice")
        {
            Caption = 'Status';
        }
        field(480;"Dimension Set ID";Integer)
        {
            Caption = 'Dimension Set ID';
            Editable = false;
            TableRelation = "Dimension Set Entry";
        }
        field(5052;"Contact No.";Code[20])
        {
            Caption = 'Contact No.';
            TableRelation = Contact;
        }
        field(5700;"Responsibility Center";Code[10])
        {
            Caption = 'Responsibility Center';
            TableRelation = "Responsibility Center";
        }
        field(5902;Description;Text[50])
        {
            Caption = 'Description';
        }
        field(5907;Priority;Option)
        {
            Caption = 'Priority';
            Editable = false;
            OptionCaption = 'Low,Medium,High';
            OptionMembers = Low,Medium,High;
        }
        field(5915;"Phone No.";Text[30])
        {
            Caption = 'Phone No.';
            ExtendedDatatype = PhoneNo;
        }
        field(5916;"E-Mail";Text[80])
        {
            Caption = 'Email';
            ExtendedDatatype = EMail;

            trigger OnValidate()
            var
                MailManagement: Codeunit "Mail Management";
            begin
                MailManagement.ValidateEmailAddressField("E-Mail");
            end;
        }
        field(5917;"Phone No. 2";Text[30])
        {
            Caption = 'Phone No. 2';
            ExtendedDatatype = PhoneNo;
        }
        field(5918;"Fax No.";Text[30])
        {
            Caption = 'Fax No.';
        }
        field(5936;"Notify Customer";Option)
        {
            Caption = 'Notify Customer';
            DataClassification = ToBeClassified;
            OptionCaption = 'No,By Phone 1,By Phone 2,By Fax,By Email';
            OptionMembers = No,"By Phone 1","By Phone 2","By Fax","By Email";
        }
        field(99500; "Grupo IRPF"; Code[20])
        {
            Editable = true;
            TableRelation = "OneData Grupos IRPF".Codigo;
            Caption = 'Grupo IRPF';
            
            trigger OnValidate();
            var
                IRPFManagement : Codeunit "IRPF Management";
            begin
                if rec."Grupo IRPF" <> xrec."Grupo IRPF" then begin
                    RecalculateIRPFLeaseInvoice(rec);
                end;
            end;
        }

        field(96000;"Contract No.";Code[20])
        {
            DataClassification = ToBeClassified;
            TableRelation = "Lease Contract"."Contract No.";
        }
        field(96001;"Bank Account No.";Code[20])
        {
            Caption = 'Bank Account No.';
            DataClassification = ToBeClassified;
            TableRelation = "Bank Account";

            trigger OnValidate()
            begin
                CALCFIELDS("Bank Account Name");

                IF "Bank Account No." = '' THEN
                  EXIT;

                BankAcc.GET("Bank Account No.");
                BankAcc.TESTFIELD(Blocked,FALSE);
            end;
        }
        field(96002;"Bank Account Name";Text[100])
        {
            CalcFormula = Lookup("Bank Account".Name WHERE ("No."=FIELD("Bank Account No.")));
            Caption = 'Bank Account Name';
            Editable = false;
            FieldClass = FlowField;
        }
        field(96003;"Fixed Real Estate No.";Code[20])
        {
            Caption = 'Fixed Real Estate No.';
        }
        field(96004; "Description Fixed Real Estate";Text[50])
        {
            FieldClass = FlowField;
            CalcFormula = Lookup("Fixed Real Estate".Description WHERE ("No."=FIELD("Fixed Real Estate No.")));
            Caption = 'Description Fixed Real Estate';
            Editable = false;
        }
        field(7000000;"Applies-to Bill No.";Code[20])
        {
            Caption = 'Applies-to Bill No.';
        }
        field(7000001;"Cust. Bank Acc. Code";Code[20])
        {
            Caption = 'Cust. Bank Acc. Code';
            TableRelation = "Customer Bank Account".Code WHERE ("Customer No."=FIELD("Customer No."));
        }
    }

    keys
    {
        key(Key1;"No.")
        {
            Clustered = true;
        }
    }

    fieldgroups
    {
        fieldgroup(DropDown;"No.",Name,"Posting Date","Amount Including VAT")
        {
        }
    }
    trigger OnInsert()
    var
        IsHandled: Boolean;
    begin

        InitInsert();
        InsertMode := true;
        // Remove view filters so that the cards does not show filtered view notification
        SetView('');

    end;
    
    trigger OnDelete()
    var
        LeaseContract : record "Lease Contract";
        LeaseInvoiceHeader : record "Lease Invoice Header";
        LeaseInvoiceLine : record "Lease Invoice Line";
        LeaseBankAccount : record "Lease Bank Account";
        TaxAmountLine : record "Tax Amount Line";
        LiquidacionHeader : record "Liquidacion Contrato Header";
        LiquidacionLines : Record "Liquidacion Contrato Lines";
        refRelatedContactos: Record "REF Related Contactos";
        REFMovs: Record "FRE Ledger Entry";

    begin
        LOCKTABLE;

        LeaseInvoiceLine.RESET;
        LeaseInvoiceLine.SETRANGE("Document No.","No.");
        LeaseInvoiceLine.DELETEALL;

        TaxAmountLine.RESET;
        TaxAmountLine.SETRANGE("Document No.","No.");
        if TaxAmountLine.FINDSET() THEN
            TaxAmountLine.DeleteAll();

        REFMovs.RESET;
        REFMovs.SetRange("Document Type", REFMovs."Document Type"::Invoice);
        REFMovs.SETRANGE("Document No.","No.");
        if REFMovs.FINDSET() THEN
            REFMovs.DeleteAll();
    end;

    var
        CustLedgEntry: Record "Cust. Ledger Entry";
        LeaseInvoiceLine: Record "Lease Invoice Line";
        PaymentTerms: Record "Payment Terms";
        BankAcc: Record "Bank Account";
        DimMgt: Codeunit "DimensionManagement";
        UserSetupMgt: Codeunit "User Setup Management";
        DocTxt: Label 'Service Invoice';
        InsertMode : Boolean;
        REFSetup : Record "REF Setup";
        GlobalNoSeries: Record "No. Series";

    local procedure GetREFSetup()
    begin
        REFSetup.Get();
    end;
    
    procedure TestNoSeries()
    var
        IsHandled: Boolean;
    begin
        GetREFSetup();
        IsHandled := false;
        if not IsHandled then begin
            REFSetup.TestField(REFSetup."Contract Invoice Nos.");
            GlobalNoSeries.Get(REFSetup."Contract Invoice Nos.");
            GlobalNoSeries.TestField("Default Nos.", true);
        end;
    end;
    
    procedure GetNoSeriesCode(): Code[20]
    var
        NoSeries: Codeunit "No. Series";
        NoSeriesCode: Code[20];
        IsHandled: Boolean;
    begin
        GetREFSetup();
        NoSeriesCode := REFSetup."Contract Invoice Nos.";
        exit(NoSeriesCode);
    end;

    procedure InitRecord()
    begin
    end;

    procedure InitInsert()
    var
        SalesHeader2: Record "Sales Header";
        NoSeries: Codeunit "No. Series";
        NoSeriesCode: Code[20];
        IsHandled: Boolean;
    begin
        IsHandled := false;
        if not IsHandled then
            if "No." = '' then begin
                TestNoSeries();
                NoSeriesCode := GetNoSeriesCode();
                "No. Series" := NoSeriesCode;
                if NoSeries.AreRelated("No. Series", xRec."No. Series") then
                    "No. Series" := xRec."No. Series";
                "No." := NoSeries.GetNextNo("No. Series", "Posting Date");
            end;
        InitRecord();
    end;

    procedure Navigate()
    var
        NavigateForm: Page "Navigate";
    begin
        NavigateForm.SetDoc("Posting Date","No.");
        NavigateForm.RUN;
    end;

    procedure RecalculateIRPFLeaseInvoice(var LeaseInvoice : Record "Lease Invoice Header")
    var 
    RealEstateManagement : Codeunit "Real Estate Management";
    LeaseInvoiceLine : Record "Lease Invoice Line";
    begin
        LeaseInvoiceLine.reset;
        LeaseInvoiceLine.SetRange("Document No.","No.");
        if LeaseInvoiceLine.FindFirst() then repeat
            RealEstateManagement.RecalculateIRPFLeaseInvoiceLine(LeaseInvoice, LeaseInvoiceLine);
            LeaseInvoiceLine.Modify();
        until LeaseInvoiceLine.next = 0;
    end;

    procedure SendRecords()
    var
        DocumentSendingProfile: Record "Document Sending Profile";
        DummyReportSelections: Record "Report Selections";
        ReportDistributionMgt: Codeunit "Report Distribution Management";
        DocumentTypeTxt: Text[50];
        IsHandled: Boolean;
    begin
        DocumentTypeTxt := ReportDistributionMgt.GetFullDocumentTypeText(Rec);

        IsHandled := false;
        OnBeforeSendRecords(DummyReportSelections, Rec, DocumentTypeTxt, IsHandled);
        if not IsHandled then
            DocumentSendingProfile.SendCustomerRecords(
              DummyReportSelections.Usage::"Lease S.Invoice".AsInteger(), Rec, DocumentTypeTxt, "Customer No.", "No.",
              FieldNo("Customer No."), FieldNo("No."));
    end;


    procedure PrintRecords(ShowRequestPage: Boolean)
    var
        DocumentSendingProfile: Record "Document Sending Profile";
        DummyReportSelections: Record "Report Selections";
        IsHandled: Boolean;
    begin
        IsHandled := false;
        OnBeforePrintRecords(DummyReportSelections, Rec, ShowRequestPage, IsHandled);
        if not IsHandled then
            DocumentSendingProfile.TrySendToPrinter(
              DummyReportSelections.Usage::"Lease S.Invoice".AsInteger(), Rec, FieldNo("Customer No."), ShowRequestPage);
    end;

    procedure PrintToDocumentAttachment(var LeaseInvoiceHeader: Record "Lease Invoice Header")
    var
        ShowNotificationAction: Boolean;
    begin
        ShowNotificationAction := LeaseInvoiceHeader.Count() = 1;
        if LeaseInvoiceHeader.FindSet() then
            repeat
                DoPrintToDocumentAttachment(LeaseInvoiceHeader, ShowNotificationAction);
            until LeaseInvoiceHeader.Next() = 0;
    end;

    local procedure DoPrintToDocumentAttachment(LeaseInvoiceHeader: Record "Lease Invoice Header"; ShowNotificationAction: Boolean)
    var
        ReportSelections: Record "Report Selections";
        IsHandled: Boolean;
    begin
        IsHandled := false;
        OnBeforeDoPrintToDocumentAttachment(LeaseInvoiceHeader, ShowNotificationAction, IsHandled);
        if IsHandled then
            exit;

        LeaseInvoiceHeader.SetRecFilter();
        ReportSelections.SaveAsDocumentAttachment(
            ReportSelections.Usage::"Lease S.Invoice".AsInteger(), LeaseInvoiceHeader, LeaseInvoiceHeader."No.", LeaseInvoiceHeader."Customer No.", ShowNotificationAction);
    end;

    procedure EmailRecords(ShowDialog: Boolean)
    var
        DocumentSendingProfile: Record "Document Sending Profile";
        DummyReportSelections: Record "Report Selections";
        ReportDistributionMgt: Codeunit "Report Distribution Management";
        DocumentTypeTxt: Text[50];
        IsHandled: Boolean;
    begin
        DocumentTypeTxt := ReportDistributionMgt.GetFullDocumentTypeText(Rec);

        IsHandled := false;
        OnBeforeEmailRecords(DummyReportSelections, Rec, DocumentTypeTxt, ShowDialog, IsHandled);
        if not IsHandled then
            DocumentSendingProfile.TrySendToEMail(
              DummyReportSelections.Usage::"Lease S.Invoice".AsInteger(), Rec, FieldNo("No."), DocumentTypeTxt,
              FieldNo("Customer No."), ShowDialog);
    end;

    [IntegrationEvent(false, false)]
    local procedure OnBeforeSendRecords(var ReportSelections: Record "Report Selections"; var LeaseInvoiceHeader: Record "Lease Invoice Header"; DocTxt: Text; var IsHandled: Boolean)
    begin
    end;
        [IntegrationEvent(false, false)]
    local procedure OnBeforeEmailRecords(var ReportSelections: Record "Report Selections"; var LeaseInvoiceHeader: Record "Lease Invoice Header"; DocTxt: Text; var ShowDialog: Boolean; var IsHandled: Boolean)
    begin
    end;
    [IntegrationEvent(false, false)]
    local procedure OnBeforeDoPrintToDocumentAttachment(var LeaseInvoiceHeader: Record "Lease Invoice Header"; var ShowNotificationAction: Boolean; var IsHandled: Boolean)
    begin
    end;

  [IntegrationEvent(false, false)]
    local procedure OnBeforePrintRecords(var ReportSelections: Record "Report Selections"; var LeaseInvoiceHeader: Record "Lease Invoice Header"; ShowRequestPage: Boolean; var IsHandled: Boolean)
    begin
    end;
}
