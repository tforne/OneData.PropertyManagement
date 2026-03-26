// ------------------------------------------------------------------------------------------------
// Copyright (c) Tomàs Forné Martínez. All rights reserved.
// ------------------------------------------------------------------------------------------------

table 96500 "Price Increases by Refer index"
{
    Caption = 'Rental price increases by reference index';
    DataPerCompany = false;

    fields
    {
        field(1; "Contract No."; Code[20])
        {
            Caption = 'Contract No.';
            NotBlank = true;
            TableRelation = "Lease Contract";

        }
        field(2; "Line No."; Integer)
        {
            Caption = 'Line No.';

        }
        field(10; "Fixed Real Estate No."; Code[20])
        {
            Caption = 'No.';
            TableRelation = "Fixed Real Estate"."No.";
        }
        field(11; "Fixed Real Estate Name"; Text[100])
        {
            FieldClass = FlowField;
            CalcFormula = Lookup("Fixed Real Estate".Description WHERE ("No."=FIELD("Fixed Real Estate No.")));
            Caption = 'Description Fixed Real Estate';
            Editable = false;
        }
        field(15;"Contact No.";Code[20])
        {
            Caption = 'Contact No.';
            TableRelation = Contact."No.";
        }
        field(16; "Contact Name"; Text[100])
        {
            FieldClass = FlowField;
            CalcFormula = Lookup(Contact.Name WHERE ("No."=FIELD("Contact No.")));
            Caption = 'Contact Name';
            Editable = false;
        }
        field(17; "Contact E-Mail"; Text[80])
        {
            FieldClass = FlowField;
            CalcFormula = Lookup(Contact."E-Mail" WHERE ("No."=FIELD("Contact No.")));
            Caption = 'Contact E-Mail';
            Editable = false;
        }
        field(18; "Customer No."; Code[20])
        {
            Caption = 'Customer No.';
        }
        field(19; "Customer Name"; Text[100])
        {
            FieldClass = FlowField;
            CalcFormula = Lookup(Customer.Name WHERE ("No."=FIELD("Customer No.")));
            Caption = 'Customer Name';
            Editable = false;
        }
        field(20; "Description"; Text[100])
        {
            Caption = 'Description';
        }
        field(24; Amount; Decimal)
        {
            AutoFormatType = 1;
            BlankZero = true;
            Caption = 'Line Amount';
        }
        field(30; "Starting Date"; Date)
        {
            Caption = 'ContractStarting Date';
        }

        field(31; "Contract Expiration Date"; Date)
        {
            Caption = 'Contract Expiration Date';
        }

        field(35; "Starting Date Increment"; Date)
        {
            Caption = 'Starting Date Increment';
        }

        field(50; "Current Unit Price"; Decimal)
        {
            AutoFormatType = 2;
            Caption = 'Current Unit Price';
            Editable = false;
            MinValue = 0;
        }
        field(51; "Payment Method Code"; Code[10])
        {
            Caption = 'Payment Method Code';
        }
        field(70; Comunicate; Boolean)
        {
            Caption = 'Comunicate';
        }
        field(100; "Price Increases"; Decimal)
        {
            AutoFormatType = 2;
            Caption = 'Price Increases';
            MinValue = 0;
        }
        field(501; "Base Contract"; Boolean)
        {
            DataClassification = ToBeClassified;
        }
        field(502;"Amount Charged Last Periode"; Decimal)
        {    
            AutoFormatType = 2;
            Caption = 'Amount Charged Last Periode';
            MinValue = 0;
        }
        field(10000; "Consumer Price Index Category"; Code[10])
        {
            Caption = 'IPC Categoría';
            DataClassification = ToBeClassified;
            TableRelation = "Consumer Price Index Categorie";
        }
        field(10001; Year; Integer)
        {
            Caption = 'Año';
            DataClassification = ToBeClassified;
        }
        field(10002; "% Increment"; Decimal)
        {
            DataClassification = ToBeClassified;
        }
        field(10003; "CPI calculation amount"; Decimal)
        {
            Caption = 'Base de cálculo IPC';
            DataClassification = ToBeClassified;
        }

    }

    keys
    {
        key(Key1; "Contract No.", "Line No.")
        {
        }
    }

    fieldgroups
    {
    }

    trigger OnInsert()
    begin
    end;

    trigger OnRename()
    begin
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
        // OnBeforeEmailRecords(DummyReportSelections, Rec, DocumentTypeTxt, ShowDialog, IsHandled);
        // if not IsHandled then
        //     DocumentSendingProfile.TrySendToEMail(
        //       DummyReportSelections.Usage::"S.Invoice".AsInteger(), Rec, FieldNo("No."), DocumentTypeTxt,
        //       FieldNo("Bill-to Customer No."), ShowDialog);
    end;

}
