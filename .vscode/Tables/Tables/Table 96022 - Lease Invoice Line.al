// ------------------------------------------------------------------------------------------------
// Copyright (c) Tomàs Forné Martínez. All rights reserved.
// ------------------------------------------------------------------------------------------------
namespace OneData.Property.Finance;

using Microsoft.Finance.Currency;
using Microsoft.Finance.Dimension;
using Microsoft.Finance.GeneralLedger.Account;
using Microsoft.Finance.GeneralLedger.Setup;
using Microsoft.Finance.SalesTax;
using Microsoft.Finance.VAT.Calculation;
using Microsoft.Finance.VAT.Setup;
using Microsoft.Foundation.UOM;
using Microsoft.Inventory.Item;
using Microsoft.Inventory.Tracking;
using Microsoft.Projects.Resources.Resource;
using Microsoft.Sales.Customer;
using Microsoft.Service.Pricing;
using Microsoft.Utilities;
using OneData.Property.Asset;
using OneData.Property.Lease;
using System.Reflection;

table 96022 "Lease Invoice Line"
{
    Caption = 'Service Invoice Line';
    DrillDownPageID = 5951;
    LookupPageID = 5951;
    PasteIsValid = false;

    fields
    {
        field(2; "Customer No."; Code[20])
        {
            Caption = 'Customer No.';
            Editable = false;
            TableRelation = Customer;
        }
        field(3; "Document No."; Code[20])
        {
            Caption = 'Document No.';
        }
        field(4; "Line No."; Integer)
        {
            Caption = 'Line No.';
        }
        field(5; Type; Option)
        {
            Caption = 'Type';
            OptionCaption = ' ,Item,Resource,Cost,G/L Account';
            OptionMembers = " ",Item,Resource,Cost,"G/L Account";
        }
        field(6; "No."; Code[20])
        {
            Caption = 'No.';
            TableRelation = IF (Type = CONST (" ")) "Standard Text"
            ELSE
            IF (Type = CONST (Item)) Item
            ELSE
            IF (Type = CONST (Resource)) Resource
            ELSE
            IF (Type = CONST (Cost)) "Service Cost"
            ELSE
            IF (Type = CONST ("G/L Account")) "G/L Account";
        }
        field(8; "Posting Group"; Code[20])
        {
            Caption = 'Posting Group';
            TableRelation = IF (Type = CONST (Item)) "Inventory Posting Group";
        }
        field(11; Description; Text[50])
        {
            Caption = 'Description';
        }
        field(12; "Description 2"; Text[50])
        {
            Caption = 'Description 2';
        }
        field(13; "Unit of Measure"; Text[10])
        {
            Caption = 'Unit of Measure';
        }
        field(15; Quantity; Decimal)
        {
            Caption = 'Quantity';
            DecimalPlaces = 0 : 5;
        }
        field(22; "Unit Price"; Decimal)
        {
            AutoFormatExpression = GetCurrencyCode;
            AutoFormatType = 2;
            CaptionClass = GetCaptionClass(FIELDNO("Unit Price"));
            Caption = 'Unit Price';
            Editable = true;

            trigger OnValidate()
            begin
                VALIDATE("Line Discount %");
            end;
        }
        field(23; "Unit Cost (LCY)"; Decimal)
        {
            AutoFormatType = 2;
            Caption = 'Unit Cost (LCY)';
        }
        field(25; "VAT %"; Decimal)
        {
            Caption = 'VAT %';
            DecimalPlaces = 0 : 5;
            Editable = false;
        }
        field(27; "Line Discount %"; Decimal)
        {
            Caption = 'Line Discount %';
            DecimalPlaces = 0 : 5;
            MaxValue = 100;
            MinValue = 0;

            trigger OnValidate()
            begin
                "Line Discount Amount" :=
                  ROUND(
                    ROUND(Quantity * "Unit Price", Currency."Amount Rounding Precision") *
                    "Line Discount %" / 100, Currency."Amount Rounding Precision");
                UpdateAmounts;
            end;
        }
        field(28; "Line Discount Amount"; Decimal)
        {
            AutoFormatExpression = GetCurrencyCode;
            AutoFormatType = 1;
            Caption = 'Line Discount Amount';
            Editable = false;
        }
        field(29; Amount; Decimal)
        {
            AutoFormatExpression = GetCurrencyCode;
            AutoFormatType = 1;
            Caption = 'Amount';
            Editable = false;
        }
        field(30; "Amount Including VAT"; Decimal)
        {
            AutoFormatExpression = GetCurrencyCode;
            AutoFormatType = 1;
            Caption = 'Amount Including VAT';
            Editable = false;
        }
        field(32; "Allow Invoice Disc."; Boolean)
        {
            Caption = 'Allow Invoice Disc.';
            InitValue = true;
        }
        field(40; "Shortcut Dimension 1 Code"; Code[20])
        {
            CaptionClass = '1,2,1';
            Caption = 'Shortcut Dimension 1 Code';
            TableRelation = "Dimension Value".Code WHERE ("Global Dimension No."=CONST(1));
        }
        field(41; "Shortcut Dimension 2 Code"; Code[20])
        {
            CaptionClass = '1,2,2';
            Caption = 'Shortcut Dimension 2 Code';
            TableRelation = "Dimension Value".Code WHERE ("Global Dimension No."=CONST(2));
        }
        field(68; "Bill-to Customer No."; Code[20])
        {
            Caption = 'Bill-to Customer No.';
            Editable = false;
            TableRelation = Customer;
        }
        field(74; "Gen. Bus. Posting Group"; Code[20])
        {
            Caption = 'Gen. Bus. Posting Group';
            TableRelation = "Gen. Business Posting Group";
        }
        field(75; "Gen. Prod. Posting Group"; Code[20])
        {
            Caption = 'Gen. Prod. Posting Group';
            TableRelation = "Gen. Product Posting Group";
        }
        field(77; "VAT Calculation Type"; Option)
        {
            Caption = 'VAT Calculation Type';
            Editable = false;
            OptionCaption = 'Normal VAT,Reverse Charge VAT,Full VAT,Sales Tax,No Taxable VAT';
            OptionMembers = "Normal VAT","Reverse Charge VAT","Full VAT","Sales Tax","No Taxable VAT";
        }
        field(89; "VAT Bus. Posting Group"; Code[20])
        {
            Caption = 'VAT Bus. Posting Group';
            TableRelation = "VAT Business Posting Group";
        }
        field(90; "VAT Prod. Posting Group"; Code[20])
        {
            Caption = 'VAT Prod. Posting Group';
            TableRelation = "VAT Product Posting Group";

            trigger OnValidate()
            begin
                VATPostingSetup.GET("VAT Bus. Posting Group", "VAT Prod. Posting Group");
                "VAT Difference" := 0;


                GetSalesHeader;
                "VAT %" := VATPostingSetup."VAT %";

#pragma warning disable AL0603
                "VAT Calculation Type" := VATPostingSetup."VAT Calculation Type";
#pragma warning restore AL0603
                "VAT Identifier" := VATPostingSetup."VAT Identifier";

                CASE "VAT Calculation Type" OF
                    "VAT Calculation Type"::"Reverse Charge VAT",
                    "VAT Calculation Type"::"Sales Tax":
                        BEGIN
                            "VAT %" := 0;
                        END;
                    "VAT Calculation Type"::"Full VAT":
                        BEGIN
                            TESTFIELD(Type, Type::"G/L Account");
                            TESTFIELD("No.", VATPostingSetup.GetSalesAccount(FALSE));
                        END;
                END;
                IF LeaseInvoiceHeader."Prices Including VAT" AND (Type IN [Type::Item, Type::Resource]) THEN
                    "Unit Price" :=
                      ROUND(
                        "Unit Price" * (100 + "VAT %") / (100 + xRec."VAT %"),
                        Currency."Unit-Amount Rounding Precision");
                UpdateAmounts;
            end;
        }
        field(99; "VAT Base Amount"; Decimal)
        {
            AutoFormatExpression = GetCurrencyCode;
            AutoFormatType = 1;
            Caption = 'VAT Base Amount';
        }
        field(103; "Line Amount"; Decimal)
        {
            AutoFormatExpression = GetCurrencyCode;
            AutoFormatType = 1;
            CaptionClass = GetCaptionClass(FIELDNO("Line Amount"));
            Caption = 'Line Amount';
        }
        field(104; "VAT Difference"; Decimal)
        {
            AutoFormatExpression = GetCurrencyCode;
            AutoFormatType = 1;
            Caption = 'VAT Difference';
            Editable = false;
        }
        field(106; "VAT Identifier"; Code[20])
        {
            Caption = 'VAT Identifier';
            Editable = false;
        }
        field(5404; "Qty. per Unit of Measure"; Decimal)
        {
            Caption = 'Qty. per Unit of Measure';
            DecimalPlaces = 0 : 5;
            Editable = false;
            InitValue = 1;
        }
        field(5407; "Unit of Measure Code"; Code[10])
        {
            Caption = 'Unit of Measure Code';
            TableRelation = IF (Type = CONST (Item)) "Item Unit of Measure".Code WHERE ("Item No."=FIELD("No."))
                            ELSE "Unit of Measure";
        }
        field(5415;"Quantity (Base)";Decimal)
        {
            Caption = 'Quantity (Base)';
            DecimalPlaces = 0:5;
        }
        field(5908;"Posting Date";Date)
        {
            Caption = 'Posting Date';
        }
        field(502; "Aplicar Impuestos"; Boolean)
        {
            DataClassification = ToBeClassified;
            trigger OnValidate()
            var
                RealEstateManagement: Codeunit "Real Estate Management";
                LeaseInvoice: Record "Lease Invoice Header";
            begin
                LeaseInvoice.GET(rec."Document No.");
                RealEstateManagement.RecalculateIRPFLeaseInvoiceLine(LeaseInvoice, rec);
            end;
        }
        field(10100; "Tax Amount Line"; Decimal)
        {
            AutoFormatType = 1;
            Caption = 'Tax Amount Line';
            Editable = false;
            CalcFormula = Sum("Tax Amount Line"."Tax Amount" WHERE ("Document No."=FIELD("Document No."),"Line No."=FIELD("Line No.")));
            FieldClass = FlowField;
        }

        field(96000;"Contract No.";Code[20])
        {
            DataClassification = ToBeClassified;
            TableRelation = "Lease Contract"."Contract No.";
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
        field(96005; "Base Contract"; Boolean)
        {
            DataClassification = ToBeClassified;
        }
    }

    keys
    {
        key(Key1;"Document No.","Line No.")
        {
            Clustered = true;
            SumIndexFields = Amount;
        }
        key(Key2;Type,"No.")
        {
        }
    }

    fieldgroups
    {
    }

    var
        Currency: Record Currency;
        LeaseInvoiceHeader: Record "Lease Invoice Header";
        VATPostingSetup: Record "VAT Posting Setup";
        SalesTaxCalculate: Codeunit "Sales Tax Calculate";

    procedure ShowItemTrackingLines()
    var
        ItemTrackingDocMgt: Codeunit "Item Tracking Doc. Management";
    begin
        ItemTrackingDocMgt.ShowItemTrackingForInvoiceLine(RowID1);
    end;

#pragma warning disable AL0432
    procedure CalcVATAmountLines(LeaseInvHeader: Record "Lease Invoice Header";var TempVATAmountLine: Record "VAT Amount Line" temporary)
#pragma warning restore AL0432
    begin
        /*
        TempVATAmountLine.DELETEALL;
        SETRANGE("Document No.",LeaseInvHeader."No.");
        IF FIND('-') THEN
          REPEAT
            TempVATAmountLine.INIT;
            TempVATAmountLine.CopyFromServInvLine(Rec);
            IF ServInvHeader."Prices Including VAT" THEN
              TempVATAmountLine."Prices Including VAT" := TRUE;
            TempVATAmountLine.InsertLine;
          UNTIL NEXT = 0;
        */

    end;

    procedure RowID1(): Text[250]
    var
        ItemTrackingMgt: Codeunit "Item Tracking Management";
    begin
        EXIT(ItemTrackingMgt.ComposeRowID(DATABASE::"Lease Invoice Line",0,"Document No.",'',0,"Line No."));
    end;

    procedure GetCaptionClass(FieldNumber: Integer): Text[80]
    var
        LeaseInvHeader: Record "Lease Invoice Header";
    begin
        IF NOT LeaseInvHeader.GET("Document No.") THEN
          LeaseInvHeader.INIT;
        IF LeaseInvHeader."Prices Including VAT" THEN
          EXIT('2,1,' + GetFieldCaption(FieldNumber));
        EXIT('2,0,' + GetFieldCaption(FieldNumber));
    end;

    local procedure GetFieldCaption(FieldNumber: Integer): Text[100]
    var
        "Field": Record Field;
    begin
        Field.GET(DATABASE::"Lease Invoice Line",FieldNumber);
        EXIT(Field."Field Caption");
    end;

    procedure GetCurrencyCode(): Code[10]
    var
        LeaseInvHeader: Record "Lease Invoice Header";
    begin
        IF "Document No." = LeaseInvHeader."No." THEN
          EXIT(LeaseInvHeader."Currency Code");
        IF LeaseInvHeader.GET("Document No.") THEN
          EXIT(LeaseInvHeader."Currency Code");
        EXIT('');
    end;

    // 
    procedure UpdateAmounts()
    var
        VATBaseAmount: Decimal;
        LineAmountChanged: Boolean;
    begin
        IF Type = Type::" " THEN
          EXIT;
        GetSalesHeader;
        VATBaseAmount := "VAT Base Amount";

        IF "Line Amount" <> xRec."Line Amount" THEN BEGIN
          "VAT Difference" := 0;
          LineAmountChanged := TRUE;
        END;
        IF "Line Amount" <> ROUND(Quantity * "Unit Price",Currency."Amount Rounding Precision") - "Line Discount Amount" THEN BEGIN
          "Line Amount" := ROUND(Quantity * "Unit Price",Currency."Amount Rounding Precision") - "Line Discount Amount";
          "VAT Difference" := 0;
          LineAmountChanged := TRUE;
        END;

        UpdateVATAmounts;

        IF VATBaseAmount <> "VAT Base Amount" THEN
          LineAmountChanged := TRUE;
    end;

    local procedure UpdateVATAmounts()
    var
        LeaseInvoiceLine2: Record "Lease Invoice Line";
        TotalLineAmount: Decimal;
        TotalInvDiscAmount: Decimal;
        TotalAmount: Decimal;
        TotalAmountInclVAT: Decimal;
        TotalQuantityBase: Decimal;
    begin

        GetSalesHeader;
        LeaseInvoiceLine2.SETRANGE("Document No.","Document No.");
        LeaseInvoiceLine2.SETFILTER("Line No.",'<>%1',"Line No.");
        IF "Line Amount" = 0 THEN
          IF xRec."Line Amount" >= 0 THEN
            LeaseInvoiceLine2.SETFILTER(Amount,'>%1',0)
          ELSE
            LeaseInvoiceLine2.SETFILTER(Amount,'<%1',0)
        ELSE
          IF "Line Amount" > 0 THEN
            LeaseInvoiceLine2.SETFILTER(Amount,'>%1',0)
          ELSE
            LeaseInvoiceLine2.SETFILTER(Amount,'<%1',0);
        LeaseInvoiceLine2.SETRANGE("VAT Identifier","VAT Identifier");


          TotalLineAmount := 0;
          TotalInvDiscAmount := 0;
          TotalAmount := 0;
          TotalAmountInclVAT := 0;
          TotalQuantityBase := 0;
          IF ("VAT Calculation Type" = "VAT Calculation Type"::"Sales Tax") OR
             (("VAT Calculation Type" IN
               ["VAT Calculation Type"::"Normal VAT","VAT Calculation Type"::"No Taxable VAT",
                "VAT Calculation Type"::"Reverse Charge VAT"]) AND ("VAT %" <> 0))
          THEN
            IF NOT LeaseInvoiceLine2.ISEMPTY THEN BEGIN
              LeaseInvoiceLine2.CALCSUMS("Line Amount",Amount,"Amount Including VAT","Quantity (Base)");
              TotalLineAmount := LeaseInvoiceLine2."Line Amount";
              TotalAmount := LeaseInvoiceLine2.Amount;
              TotalAmountInclVAT := LeaseInvoiceLine2."Amount Including VAT";
              TotalQuantityBase := LeaseInvoiceLine2."Quantity (Base)";
            END;

          IF LeaseInvoiceHeader."Prices Including VAT" THEN
            CASE "VAT Calculation Type" OF
              "VAT Calculation Type"::"Normal VAT",
              "VAT Calculation Type"::"Reverse Charge VAT",
              "VAT Calculation Type"::"No Taxable VAT":
                BEGIN
                  Amount :=
                    ROUND(
                      (TotalLineAmount - TotalInvDiscAmount + CalcLineAmount) / (1 + ("VAT %") / 100),
                      Currency."Amount Rounding Precision") -
                    TotalAmount;
                  "VAT Base Amount" :=
                    ROUND(
                      Amount * (1 - LeaseInvoiceHeader."VAT Base Discount %" / 100),
                      Currency."Amount Rounding Precision");
                  "Amount Including VAT" :=
                    TotalLineAmount + "Line Amount" -
                    ROUND(
                      (TotalAmount + Amount) * (LeaseInvoiceHeader."VAT Base Discount %" / 100) * ("VAT %" ) / 100,
                      Currency."Amount Rounding Precision",Currency.VATRoundingDirection) -
                    TotalAmountInclVAT - TotalInvDiscAmount;
                END;
              "VAT Calculation Type"::"Full VAT":
                BEGIN
                  Amount := 0;
                  "VAT Base Amount" := 0;
                END;
              "VAT Calculation Type"::"Sales Tax":
                BEGIN
                  LeaseInvoiceHeader.TESTFIELD("VAT Base Discount %",0);
                  Amount :=
                    SalesTaxCalculate.ReverseCalculateTax(
                      '','',FALSE,LeaseInvoiceHeader."Posting Date",
                      TotalAmountInclVAT + "Amount Including VAT",TotalQuantityBase + "Quantity (Base)",
                      LeaseInvoiceHeader."Currency Factor") -
                    TotalAmount;
                  IF Amount <> 0 THEN
                    "VAT %" :=
                      ROUND(100 * ("Amount Including VAT" - Amount) / Amount,0.00001)
                  ELSE BEGIN
                    "VAT %" := 0;
                  END;
                  Amount := ROUND(Amount,Currency."Amount Rounding Precision");
                  "VAT Base Amount" := Amount;
                END;
            END
          ELSE
            CASE "VAT Calculation Type" OF
              "VAT Calculation Type"::"Normal VAT",
              "VAT Calculation Type"::"Reverse Charge VAT",
              "VAT Calculation Type"::"No Taxable VAT":
                BEGIN
                  Amount := ROUND(CalcLineAmount,Currency."Amount Rounding Precision");
                  "VAT Base Amount" :=
                    ROUND(Amount * (1 - LeaseInvoiceHeader."VAT Base Discount %" / 100),Currency."Amount Rounding Precision");
                  "Amount Including VAT" :=
                    TotalAmount + Amount +
                    ROUND(
                      (TotalAmount + Amount) * (1 - LeaseInvoiceHeader."VAT Base Discount %" / 100) * ("VAT %" ) / 100,
                      Currency."Amount Rounding Precision",Currency.VATRoundingDirection) -
                    TotalAmountInclVAT;
                END;
              "VAT Calculation Type"::"Full VAT":
                BEGIN
                  Amount := 0;
                  "VAT Base Amount" := 0;
                  "Amount Including VAT" := CalcLineAmount;
                END;
              "VAT Calculation Type"::"Sales Tax":
                BEGIN
                  Amount := ROUND(CalcLineAmount,Currency."Amount Rounding Precision");
                  "VAT Base Amount" := Amount;
                  "Amount Including VAT" :=
                    TotalAmount + Amount +
                    ROUND(
                      SalesTaxCalculate.CalculateTax(
                        '','',FALSE,LeaseInvoiceHeader."Posting Date",
                        TotalAmount + Amount,TotalQuantityBase + "Quantity (Base)",
                        LeaseInvoiceHeader."Currency Factor"),Currency."Amount Rounding Precision") -
                    TotalAmountInclVAT;
                  IF "VAT Base Amount" <> 0 THEN
                    "VAT %" :=
                      ROUND(100 * ("Amount Including VAT" - "VAT Base Amount") / "VAT Base Amount",0.00001)
                  ELSE BEGIN
                    "VAT %" := 0;
                  END;
                END;
            END;
    end;

    procedure GetSalesHeader()
    begin
        TESTFIELD("Document No.");
        IF ("Document No." <> LeaseInvoiceHeader."No.") THEN BEGIN
          LeaseInvoiceHeader.GET("Document No.");
          IF LeaseInvoiceHeader."Currency Code" = '' THEN
            Currency.InitRoundingPrecision
          ELSE BEGIN
            LeaseInvoiceHeader.TESTFIELD("Currency Factor");
            Currency.GET(LeaseInvoiceHeader."Currency Code");
            Currency.TESTFIELD("Amount Rounding Precision");
          END;
        END;
    end;

  
    procedure CalcLineAmount(): Decimal
    begin
        EXIT("Line Amount");
    end;
}

