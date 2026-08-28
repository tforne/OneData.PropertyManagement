// ------------------------------------------------------------------------------------------------
// Copyright (c) Tomàs Forné Martínez. All rights reserved.
// ------------------------------------------------------------------------------------------------

namespace OneData.Property.Lease;

using Microsoft.Finance.AllocationAccount;
using Microsoft.Finance.Currency;
using Microsoft.Finance.Dimension;
using Microsoft.Finance.GeneralLedger.Account;
using Microsoft.Finance.GeneralLedger.Setup;
using Microsoft.Finance.VAT.Setup;
using Microsoft.Foundation.UOM;
using Microsoft.Sales.Customer;
using Microsoft.Sales.Document;
using Microsoft.Service.Ledger;
using Microsoft.Utilities;
using OneData.Property.Setup;

table 96019 "Lease Contract Line"
{
    Caption = 'Lease Contract Line';

    fields
    {
        field(1; "Contract No."; Code[20])
        {
            Caption = 'Contract No.';
            TableRelation = "Lease Contract"."Contract No.";
        }
        field(2; "Line No."; Integer)
        {
            Caption = 'Line No.';
        }
        field(3; "Account No."; Code[20])
        {
            Caption = 'Account No.';
            DataClassification = ToBeClassified;
            TableRelation = if (Type = const(" ")) "Standard Text"
            else
            if (Type = const("G/L Account")) "G/L Account" where("Direct Posting" = const(true), "Account Type" = const(Posting), Blocked = const(false))
            else
            if (Type = const("Allocation Account")) "Allocation Account";

            trigger OnValidate()
            var
                TempLeaseLine: Record "Lease Contract Line" temporary;
                IsHandled: Boolean;
            begin

                IsHandled := false;
                OnBeforeValidateNo(Rec, xRec, CurrFieldNo, IsHandled);
                if IsHandled then
                    exit;

                IF "Account No." = '' THEN BEGIN
                    CleanLine;
                    EXIT;
                END;

                TestStatusOpen();
                
                if (xRec."Account No." <> "Account No.")  then begin
                    TestField(Value, 0);
                end;

                TempLeaseLine := Rec;
                Init();
                SystemId := TempLeaseLine.SystemId;
                Type := TempLeaseLine.Type;
                "Account No." := TempLeaseLine."Account No.";
                
                GetLeaseHeader();
                InitHeaderDefaults(LeaseContractHeader);
                
                
                case Type of
                    Type::" ":
                        CopyFromStandardText();
                    Type::"G/L Account":
                        CopyFromGLAccount(TempLeaseLine);
                    Type::"Allocation Account":
                        CopyFromAllocationAccount(TempLeaseLine);
                end;


                VALIDATE("VAT Prod. Posting Group");

               

            end;
        }

        field(4; "Contract Status"; Option)
        {
            Caption = 'Contract Status';
            OptionCaption = ' ,Signed,Cancelled';
            OptionMembers = " ",Signed,Cancelled;
        }
        field(5; Type; Enum "Lease Contract Line Type")
        {
            Caption = 'Type';
            ToolTip = 'Specifies the type of entity that will be posted for this lease contract line, such as G/L Account or Allocation Account. The type that you enter in this field determines what you can select in the No. field.';

            trigger OnValidate()
            var
                TempLeaseLine: Record "Lease Contract Line" temporary;
                IsHandled: Boolean;
            begin
                IsHandled := false;
                OnBeforeValidateType(Rec, xRec, CurrFieldNo, IsHandled);
                if IsHandled then
                    exit;

                TestStatusOpen();
                GetLeaseContractHeader();

                if Type <> Type::" " then begin
                    TestField("Value", 0);
                    TestField(Amount, 0);
                end;
                
                OnValidateTypeOnBeforeInitRec(Rec, xRec, CurrFieldNo);
                TempLeaseLine := Rec;
                Init();
                SystemId := TempLeaseLine.SystemId;
                Type := TempLeaseLine.Type;
                Description := TempLeaseLine.Description;
                ApplyTypeDefaults(TempLeaseLine);
            end;
        }
    
        field(6; Description; Text[50])
        {
            Caption = 'Description';

            trigger OnValidate()
            begin
                TestStatusOpen;
            end;
        }
        field(9; "Customer No."; Code[20])
        {
            Caption = 'Customer No.';
            TableRelation = Customer;
        }
        field(10; "VAT %"; Decimal)
        {
            Caption = 'VAT %';
            DataClassification = ToBeClassified;
            DecimalPlaces = 0 : 5;
            Editable = false;
            MaxValue = 100;
            MinValue = 0;

            trigger OnValidate()
            begin
                CASE "VAT Calculation Type" OF
                    "VAT Calculation Type"::"Normal VAT",
                    "VAT Calculation Type"::"No Taxable VAT",
                    "VAT Calculation Type"::"Reverse Charge VAT":
                        BEGIN
                            "VAT Amount" := ROUND(Amount * ("VAT %" / 100), 0.01);
                            // "VAT Base Amount" := ROUND(Amount + "VAT Amount", 0.01);
                            "VAT Base Amount" := ROUND(Amount, 0.01);
                        END;
                    "VAT Calculation Type"::"Full VAT":
                        "VAT Amount" := Amount;
                    "VAT Calculation Type"::"Sales Tax":
                        BEGIN
                            IF Amount - "VAT Amount" <> 0 THEN
                                "VAT %" := ROUND(100 * "VAT Amount" / (Amount - "VAT Amount"), 0.00001)
                            ELSE
                                "VAT %" := 0;
                            "VAT Amount" :=
                              ROUND("VAT Amount", 0.01);
                        END;
                END;
            end;
        }
        field(12; "Unit of Measure Code"; Code[10])
        {
            Caption = 'Unit of Measure Code';
            TableRelation = "Unit of Measure";

            trigger OnValidate()
            begin
                TestStatusOpen;
            end;
        }
        field(13; "Response Time (Hours)"; Decimal)
        {
            BlankZero = true;
            Caption = 'Response Time (Hours)';
            DecimalPlaces = 0 : 5;
            MinValue = 0;

            trigger OnValidate()
            begin
                TestStatusOpen;
            end;
        }
        field(18; "Invoiced to Date"; Date)
        {
            Caption = 'Invoiced to Date';
            Editable = false;
        }
        field(19; "Credit Memo Date"; Date)
        {
            Caption = 'Credit Memo Date';

            trigger OnValidate()
            begin
                TestStatusOpen;
                IF "Credit Memo Date" <> 0D THEN BEGIN
                    IF "Credit Memo Date" > "Contract Expiration Date" THEN
                        ERROR(
                          Text008,
                          FIELDCAPTION("Credit Memo Date"), FIELDCAPTION("Contract Expiration Date"));
                END;

                IF "Credit Memo Date" <> xRec."Credit Memo Date" THEN
                    IF "Credit Memo Date" = 0D THEN
                        ERROR(Text018, FIELDCAPTION("Credit Memo Date"));
            end;
        }
        field(20; "Contract Expiration Date"; Date)
        {
            Caption = 'Contract Expiration Date';

            trigger OnValidate()
            begin
                TestStatusOpen;

                LeaseContractHeader.GET("Contract No.");

                IF "Contract Expiration Date" = 0D THEN BEGIN
                    "Credit Memo Date" := 0D;
                    EXIT;
                END;

                IF "Contract Expiration Date" < "Starting Date" THEN
                    ERROR(
                      Text009,
                      FIELDCAPTION("Contract Expiration Date"),
                      FIELDCAPTION("Starting Date"));

                IF LeaseContractHeader."Expiration Date" <> 0D THEN
                    IF "Contract Expiration Date" > LeaseContractHeader."Expiration Date" THEN
                        ERROR(
                          Text017,
                          FIELDCAPTION("Contract Expiration Date"),
                          LeaseContractHeader.FIELDCAPTION("Expiration Date"));

                IF "Contract Expiration Date" < "Credit Memo Date" THEN
                    ERROR(
                      Text009,
                      FIELDCAPTION("Contract Expiration Date"),
                      FIELDCAPTION("Credit Memo Date"));

                IF "Credit Memo Date" = 0D THEN
                    "Credit Memo Date" := "Contract Expiration Date";
            end;
        }
        field(21; "Service Period"; DateFormula)
        {
            Caption = 'Service Period';

            trigger OnValidate()
            begin
                TestStatusOpen;
            end;
        }
        field(22; Value; Decimal)
        {
            AutoFormatType = 1;
            BlankZero = true;
            Caption = 'Line Value';

            trigger OnValidate()
            begin
                VALIDATE(Amount, Value);
                VALIDATE("VAT %");
                validate("Aplicar Impuestos")
            end;
        }
        field(24; Amount; Decimal)
        {
            AutoFormatType = 1;
            BlankZero = true;
            Caption = 'Line Amount';

            trigger OnValidate()
            begin
                TestStatusOpen;
                TESTFIELD(Value);
                Profit := ROUND(Amount - Cost, 0.01);
            end;
        }
        field(29; "Starting Date"; Date)
        {
            Caption = 'Starting Date';
            Editable = false;
        }
        field(30; "Shortcut Dimension 1 Code"; Code[20])
        {
            CaptionClass = '1,2,1';
            Caption = 'Shortcut Dimension 1 Code';
            DataClassification = ToBeClassified;
            TableRelation = "Dimension Value".Code WHERE ("Global Dimension No."=CONST(1),
                                                          Blocked=CONST(false));

            trigger OnValidate()
            begin


                ValidateShortcutDimCode(1, "Shortcut Dimension 1 Code");
            end;
        }
        field(31; "Shortcut Dimension 2 Code"; Code[20])
        {
            CaptionClass = '1,2,2';
            Caption = 'Shortcut Dimension 2 Code';
            DataClassification = ToBeClassified;
            TableRelation = "Dimension Value".Code WHERE ("Global Dimension No."=CONST(2),
                                                          Blocked=CONST(false));

            trigger OnValidate()
            begin
                ValidateShortcutDimCode(2, "Shortcut Dimension 2 Code");
            end;
        }
        field(32; Cost; Decimal)
        {
            AutoFormatType = 1;
            BlankZero = true;
            Caption = 'Line Cost';

            trigger OnValidate()
            begin
                TestStatusOpen;
                Profit := ROUND(Amount - Cost, 0.01);
            end;
        }
        field(34; Profit; Decimal)
        {
            AutoFormatType = 1;
            BlankZero = true;
            Caption = 'Profit';

            trigger OnValidate()
            begin
                TestStatusOpen;
                Amount := ROUND(Profit + Cost, 0.01);
            end;
        }
        field(44; "VAT Amount"; Decimal)
        {
            AutoFormatType = 1;
            Caption = 'VAT Amount';
            DataClassification = ToBeClassified;

            trigger OnValidate()
            begin
                IF "VAT Amount" <> 0 THEN BEGIN
                    TESTFIELD("VAT %");
                    TESTFIELD(Amount);
                END;

                "VAT Amount" := ROUND("VAT Amount", 0.01);

                IF "VAT Amount" * Amount < 0 THEN
                    "VAT Base Amount" := Amount - "VAT Amount";

                "VAT Difference" :=
                  "VAT Amount" -
                  ROUND(
                    Amount * "VAT %" / (100 + "VAT %"),
                    0.01);
            end;
        }
        field(45; "VAT Posting"; Option)
        {
            Caption = 'VAT Posting';
            DataClassification = ToBeClassified;
            Editable = false;
            OptionCaption = 'Automatic VAT Entry,Manual VAT Entry';
            OptionMembers = "Automatic VAT Entry","Manual VAT Entry";
        }
        field(58; "Gen. Bus. Posting Group"; Code[20])
        {
            Caption = 'Gen. Bus. Posting Group';
            DataClassification = ToBeClassified;
            TableRelation = "Gen. Business Posting Group";
        }
        field(59; "Gen. Prod. Posting Group"; Code[20])
        {
            Caption = 'Gen. Prod. Posting Group';
            DataClassification = ToBeClassified;
            TableRelation = "Gen. Product Posting Group";
        }
        field(60; "VAT Calculation Type"; Option)
        {
            Caption = 'VAT Calculation Type';
            DataClassification = ToBeClassified;
            Editable = false;
            OptionCaption = 'Normal VAT,Reverse Charge VAT,Full VAT,Sales Tax,No Taxable VAT';
            OptionMembers = "Normal VAT","Reverse Charge VAT","Full VAT","Sales Tax","No Taxable VAT";
        }
        field(71; "VAT Base Amount"; Decimal)
        {
            AutoFormatType = 1;
            Caption = 'VAT Base Amount';
            DataClassification = ToBeClassified;

            trigger OnValidate()
            begin
                "VAT Base Amount" := ROUND("VAT Base Amount", 0.01);
                CASE "VAT Calculation Type" OF
                    "VAT Calculation Type"::"Normal VAT",
                  "VAT Calculation Type"::"Reverse Charge VAT",
                  "VAT Calculation Type"::"No Taxable VAT":
                        Amount :=
                          ROUND(
                            "VAT Base Amount" * (1 + "VAT %" / 100), 0.01);
                    "VAT Calculation Type"::"Full VAT":
                        IF "VAT Base Amount" <> 0 THEN
                            FIELDERROR(
                              "VAT Base Amount",
                              STRSUBSTNO(
                                Text008, FIELDCAPTION("VAT Calculation Type"),
                                "VAT Calculation Type"));
                    "VAT Calculation Type"::"Sales Tax":
                        BEGIN
                            "VAT Amount" := 0;
                            "VAT %" := 0;
                            "VAT Base Amount" := 0;
                            Amount := "VAT Base Amount" + "VAT Amount";
                            "VAT Amount" :=
                              ROUND("VAT Amount", 0.01);
                            Amount := "VAT Base Amount" + "VAT Amount";
                        END;
                END;
                VALIDATE(Amount);
            end;
        }
        field(90; "VAT Bus. Posting Group"; Code[20])
        {
            Caption = 'VAT Bus. Posting Group';
            DataClassification = ToBeClassified;
            TableRelation = "VAT Business Posting Group";

            trigger OnValidate()
            begin
                VALIDATE("VAT Prod. Posting Group");
            end;
        }
        field(91; "VAT Prod. Posting Group"; Code[20])
        {
            Caption = 'VAT Prod. Posting Group';
            DataClassification = ToBeClassified;
            TableRelation = "VAT Product Posting Group";

            trigger OnValidate()
            begin

                "VAT %" := 0;
                "VAT Calculation Type" := "VAT Calculation Type"::"Normal VAT";
                IF NOT VATPostingSetup.GET("VAT Bus. Posting Group", "VAT Prod. Posting Group") THEN
                    VATPostingSetup.INIT;
#pragma warning disable AL0603
                "VAT Calculation Type" := VATPostingSetup."VAT Calculation Type";
#pragma warning restore AL0603
                CASE "VAT Calculation Type" OF
                    "VAT Calculation Type"::"Normal VAT",
                  "VAT Calculation Type"::"No Taxable VAT":
                        "VAT %" := VATPostingSetup."VAT+EC %";
                    "VAT Calculation Type"::"Full VAT":
                        TESTFIELD("Account No.", VATPostingSetup.GetSalesAccount(FALSE));
                END;
                VALIDATE("VAT %");
            end;
        }
        field(111; "VAT Difference"; Decimal)
        {
            AutoFormatType = 1;
            Caption = 'VAT Difference';
            DataClassification = ToBeClassified;
            Editable = false;
        }
        field(480; "Dimension Set ID"; Integer)
        {
            Caption = 'Dimension Set ID';
            DataClassification = ToBeClassified;
            Editable = false;
            TableRelation = "Dimension Set Entry";

            trigger OnLookup()
            begin
                ShowDimensions;
            end;

            trigger OnValidate()
            begin
                DimMgt.UpdateGlobalDimFromDimSetID("Dimension Set ID", "Shortcut Dimension 1 Code", "Shortcut Dimension 2 Code");
            end;
        }
        field(500; "Aplicar incrementos"; Boolean)
        {
            DataClassification = ToBeClassified;
        }
        field(501; "Base Contract"; Boolean)
        {
            DataClassification = ToBeClassified;
        }
        field(502; "Aplicar Impuestos"; Boolean)
        {
            DataClassification = ToBeClassified;
            trigger OnValidate()
            var
                RealEstateManagement: Codeunit "Real Estate Management";
                LeaseContract: Record "Lease Contract";
            begin
                LeaseContract.GET(rec."Contract No.");
                RealEstateManagement.RecalculateIRPFLeaseLine(LeaseContract, rec);
            end;
        }
        field(10000; "Consumer Price Index Category"; Code[10])
        {
            Caption = 'IPC Categoría';
            DataClassification = ToBeClassified;
            TableRelation = "Consumer Price Index Categorie"."Con. Price Index Category Code";
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
        field(10100; "Tax Amount Line"; Decimal)
        {
            AutoFormatType = 1;
            Caption = 'Tax Amount Line';
            Editable = false;
            CalcFormula = Sum("Tax Amount Line"."Tax Amount" WHERE ("Document No."=FIELD("Contract No."),"Line No."=FIELD("Line No.")));
            FieldClass = FlowField;
        }
        field(2678; "Allocation Account No."; Code[20])
        {
            Caption = 'Posting Allocation Account No.';
            DataClassification = CustomerContent;
            TableRelation = "Allocation Account";
        }
    }

    keys
    {
        key(Key1; "Contract No.", "Line No.")
        {
            Clustered = true;
            MaintainSIFTIndex = false;
            SumIndexFields = Amount, Profit;
        }
    }
    fieldgroups
    {
        fieldgroup(DropDown; Description, Amount, "VAT %")
        {
        }
    }

    trigger OnDelete()
    begin


    end;

    trigger OnInsert()
    begin
        TESTFIELD(Description);
        GetLeaseContractHeader;
        LeaseContractHeader.TESTFIELD("Customer No.");
        LeaseContractHeader.TESTFIELD("Contract No.");
        LeaseContractHeader.TESTFIELD("Starting Date");
    end;

    trigger OnModify()
    begin
        IF UseServContractLineAsxRec THEN BEGIN
            xRec := LeaseContractLine;
            UseServContractLineAsxRec := FALSE;
        END;
    end;

    var
        VATPostingSetup: Record "VAT Posting Setup";
        GenBusPostingGrp: Record "Gen. Business Posting Group";
        GenProdPostingGrp: Record "Gen. Product Posting Group";
        GLSetup: Record "General Ledger Setup";
        Currency: Record Currency;
        GLAcc: Record "G/L Account";
        SalesLine: Record "Sales Line";
        ServLedgEntry: Record "Service Ledger Entry";
        LeaseContractHeader: Record "Lease Contract";
        LeaseContractLine: Record "Lease Contract Line";
        AllocationAccount: Record "Allocation Account";    
        Text000: Label 'This service item does not belong to customer no. %1.';
        Text001: Label 'Service item %1 has a different ship-to code for this customer.\\Do you want to continue?';
        Text003: Label 'This service item already exists in this service contract.';
        Text008: Label '%1 field value cannot be later than the %2 field value on the contract line.';
        Text009: Label 'The %1 cannot be less than the %2.';
        Text011: Label 'Service ledger entry exists for service contract line %1.\\You may need to create a credit memo.';
        LeaseContractCommentLine: Record "Lease Comment Line";
        LeaseContractHeaderAux: Record "Lease Contract";
        DimMgt: Codeunit "DimensionManagement";
        HideDialog: Boolean;
        StatusCheckSuspended: Boolean;
        Text013: Label 'You cannot change the %1 field on signed service contracts.';
        Text015: Label 'You cannot delete service contract lines on %1 service contracts.';
        Text016: Label 'Service contract lines must have at least a %1 filled in.';
        Text017: Label 'The %1 cannot be later than the %2.';
        Text018: Label 'You cannot reset %1 manually.';
        Text019: Label 'Service item %1 already belongs to one or more service contracts/quotes.\\Do you want to continue?';
        Text020: Label 'The service period for service item %1 under contract %2 has not yet started.';
        Text021: Label 'The service period for service item %1 under contract %2 has expired.';
        Text022: Label 'If you delete this contract line while the Automatic Credit Memos check box is not selected, a credit memo will not be created.\Do you want to continue?';
        Text023: Label 'The update has been interrupted to respect the warning.';
        UseServContractLineAsxRec: Boolean;
        Text024: Label 'You cannot enter a later date in or clear the %1 field on the contract line that has been invoiced for the period containing that date.';
        Text025: Label 'You cannot add a new %1 because the service contract has expired. Renew the %2 on the service contract.', Comment = 'You cannot add a new Service Item Line because the service contract has expired. Renew the Expiration Date on the service contract.';
        Text026: Label 'Existen lineas en el diario...Borralas para poder realizar el calculo.';

    procedure SetupNewLine()
    begin
        IF NOT LeaseContractHeader.GET("Contract No.") THEN
            EXIT;
        "Customer No." := LeaseContractHeader."Customer No.";
        "Contract Status" := LeaseContractHeader.Status;
        "Contract Expiration Date" := LeaseContractHeader."Expiration Date";
        "Credit Memo Date" := "Contract Expiration Date";
        "Service Period" := LeaseContractHeader."Lease Period";
        "Starting Date" := WORKDATE;
    end;

    procedure HideDialogBox(Hide: Boolean)
    begin
        HideDialog := Hide;
    end;

    local procedure TestStatusOpen()
    begin
        IF StatusCheckSuspended THEN
            EXIT;
        GetLeaseContractHeader;
    end;

    procedure SuspendStatusCheck(Suspend: Boolean)
    begin
        StatusCheckSuspended := Suspend;
    end;

    local procedure GetLeaseContractHeader()
    begin
        TESTFIELD("Contract No.");
        LeaseContractHeader.GET("Contract No.");
    end;

    procedure ShowComments()
    begin

        LeaseContractHeaderAux.GET("Contract No.");
        //LeaseContractHeader.TESTFIELD("Customer No.");
        TESTFIELD("Line No.");
        LeaseContractCommentLine.RESET;
        LeaseContractCommentLine.SETRANGE("Table Name", LeaseContractCommentLine."Table Name"::"Lease Contract");
        // LeaseContractCommentLine.SETRANGE("Table Subtype","Contract Type");
        LeaseContractCommentLine.SETRANGE("No.", "Contract No.");
        //LeaseContractCommentLine.SETRANGE(Type,LeaseContractCommentLine.Type::General);
        LeaseContractCommentLine.SETRANGE("Table Line No.", "Line No.");
        PAGE.RUNMODAL(PAGE::"Lease Comment Sheet", LeaseContractCommentLine);
    end;

    procedure ValidateLeasePeriod(CurrentDate: Date)
    begin
        IF "Starting Date" > CurrentDate THEN
            ERROR(Text020, "Contract No.");
        IF "Contract Expiration Date" = 0D THEN BEGIN
            LeaseContractHeader.GET("Contract No.");
            IF (LeaseContractHeader."Expiration Date" <> 0D) AND
               (LeaseContractHeader."Expiration Date" <= CurrentDate)
            THEN
                ERROR(Text021, "Contract No.");
        END ELSE
            IF "Contract Expiration Date" < CurrentDate THEN
                ERROR(Text021, "Contract No.");
    end;

    local procedure CleanLine()
    begin
        IF xRec."Account No." <> '' THEN BEGIN
            ClearPostingGroups;
            Description := '';
            "Unit of Measure Code" := '';
            Value := 0;
            Amount := 0;
            Cost := 0;
        END;
    end;

    local procedure ApplyTypeDefaults(TempLeaseLine: Record "Lease Contract Line" temporary)
    begin
        GetLeaseContractHeader();
        "Customer No." := LeaseContractHeader."Customer No.";
        "Contract Status" := LeaseContractHeader.Status;

        if Type = Type::" " then begin
            ClearCommentLineFields();
            exit;
        end;

        "Contract Expiration Date" := LeaseContractHeader."Expiration Date";
        "Credit Memo Date" := "Contract Expiration Date";
        "Service Period" := LeaseContractHeader."Lease Period";
        "Starting Date" := WorkDate();

        if TempLeaseLine."Aplicar incrementos" then
            "Aplicar incrementos" := TempLeaseLine."Aplicar incrementos";
        if TempLeaseLine."Base Contract" then
            "Base Contract" := TempLeaseLine."Base Contract";
        if TempLeaseLine."Aplicar Impuestos" then
            "Aplicar Impuestos" := TempLeaseLine."Aplicar Impuestos";
    end;

    local procedure ClearCommentLineFields()
    begin
        "Account No." := '';
        "Unit of Measure Code" := '';
        "Response Time (Hours)" := 0;
        Value := 0;
        Amount := 0;
        Cost := 0;
        Profit := 0;
        "VAT Prod. Posting Group" := '';
        "VAT Bus. Posting Group" := '';
        "Gen. Bus. Posting Group" := '';
        "Gen. Prod. Posting Group" := '';
        "VAT %" := 0;
        "VAT Amount" := 0;
        "VAT Base Amount" := 0;
        "VAT Difference" := 0;
        Clear("Service Period");
        "Starting Date" := 0D;
        "Contract Expiration Date" := 0D;
        "Credit Memo Date" := 0D;
        "Shortcut Dimension 1 Code" := '';
        "Shortcut Dimension 2 Code" := '';
        "Dimension Set ID" := 0;
        "Aplicar incrementos" := false;
        "Base Contract" := false;
        "Aplicar Impuestos" := false;
        "Consumer Price Index Category" := '';
        Year := 0;
        "% Increment" := 0;
        "CPI calculation amount" := 0;
        "Allocation Account No." := '';
    end;

    procedure CreateLineIPC(LeaseContract: Record "Lease Contract" ; _StartingDate : Date; _Year: Integer; BaseAmount: Decimal)
    var
        LeaseContractLine: Record "Lease Contract Line";
        Cust : Record Customer;
        CustomerTemplate : Record "Customer Templ.";
        GenProductPostingGroup : Record "Gen. Product Posting Group";
        REFSetup : Record "REF Setup";
        NoLine: Integer;
        IncrementAmount: Decimal;
        ConsumerPriceIndex: Record "Consumer Price Index";
        _GenBusPostingGroup, _GenProdPostingGroup, _VATBusPostingGroup, _VATProdPostingGroup: Code[20];

    begin
        NoLine := 1000;
        LeaseContractLine.RESET;
        LeaseContractLine.SETRANGE("Contract No.", LeaseContract."Contract No.");
        IF LeaseContractLine.FindLast() THEN BEGIN
            NoLine := LeaseContractLine."Line No." + 10000
        END;

        _GenBusPostingGroup := '';
        _GenProdPostingGroup := ''; 
        _VATBusPostingGroup := '';
        _VATProdPostingGroup := '';
        REFSetup.GET();
        REFSetup.TestField("Service Charge Acc.");
        LeaseContract.TestField("Consumer Price Index Category");
        LeaseContract.TestField("Generic Prod. Posting Gr.");
        GenProductPostingGroup.GET(LeaseContract."Generic Prod. Posting Gr.");
        _GenProdPostingGroup := GenProductPostingGroup.Code;
        _VATProdPostingGroup := GenProductPostingGroup."Def. VAT Prod. Posting Group";

        if LeaseContract."Customer No." <> '' then begin
            Cust.GET(LeaseContract."Customer No.");
            _GenBusPostingGroup := Cust."Gen. Bus. Posting Group";
            _VATBusPostingGroup := Cust."VAT Bus. Posting Group";
        end else begin
            LeaseContract.testfield("Customer Template Code");
            CustomerTemplate.GET(LeaseContract."Customer Template Code");
            _GenBusPostingGroup := CustomerTemplate."Gen. Bus. Posting Group";
            _VATBusPostingGroup := CustomerTemplate."VAT Bus. Posting Group";
        end;
        consumerPriceIndex.get(LeaseContract."Consumer Price Index Category",_Year);
        LeaseContractLine."Contract No." := LeaseContract."Contract No.";
        LeaseContractLine."Line No." := NoLine;
        LeaseContractLine."Customer No." := LeaseContract."Customer No.";
        LeaseContractLine."Starting Date" := LeaseContract."Starting Date";
        LeaseContractLine."Contract Expiration Date" := LeaseContract."Expiration Date";
        LeaseContractLine.INSERT;

        LeaseContractLine.Validate(Type, LeaseContractLine.Type::"G/L Account");
        LeaseContractLine.Validate("Account No.", REFSetup."Service Charge Acc.");
        LeaseContractLine."Contract Status" := LeaseContract.Status;
        LeaseContractLine."Consumer Price Index Category" := consumerPriceIndex."Consumer Price Index Category";
        LeaseContractLine."Starting Date" := _StartingDate;
        LeaseContractLine.Year := _Year;
        LeaseContractLine."% Increment" := consumerPriceIndex."% Increment";
        LeaseContractLine."CPI calculation amount" := BaseAmount;
        IncrementAmount := ROUND((BaseAmount * ConsumerPriceIndex."% Increment" / 100),0.01);
        LeaseContractLine.Description := STRSUBSTNO('Incremento IPC del %1- %2 %', _Year, ConsumerPriceIndex."% Increment");
        
        LeaseContractLine."Unit of Measure Code" := '';
        LeaseContractLine."Response Time (Hours)" := 0;
        LeaseContractLine."Invoiced to Date" := 0D;
        LeaseContractLine."Credit Memo Date" := 0D;        

        if _GenBusPostingGroup <> '' then
            LeaseContractLine.VALIDATE("Gen. Bus. Posting Group", _GenBusPostingGroup);
        if _GenProdPostingGroup <> ''then
            LeaseContractLine.VALIDATE("Gen. Prod. Posting Group", _GenProdPostingGroup);
        if _VATBusPostingGroup <> '' then
            LeaseContractLine.VALIDATE("VAT Bus. Posting Group", _VATBusPostingGroup);
        if _VATProdPostingGroup <> '' then
            LeaseContractLine.VALIDATE("VAT Prod. Posting Group", _VATProdPostingGroup);
        LeaseContractLine.MODIFY;

        LeaseContractLine.VALIDATE(Value, IncrementAmount);
        LeaseContractLine."Dimension Set ID" := 0;
        LeaseContractLine."Aplicar incrementos" := TRUE;
        LeaseContractLine.MODIFY;
    end;

    procedure CreateLineWorksheet(LeaseContract: Record "Lease Contract" ; Year: Integer; BaseAmount: Decimal)
    var
        PriceIncreasesReferIndex : Record "Price Increases by Refer index";
        ConsumerPriceIndex : Record "Consumer Price Index";
        NoLine: Integer;
        IncrementAmount: Decimal;
        "%Increment" : Decimal;
    begin
        NoLine := 1000;
        PriceIncreasesReferIndex.RESET;
        IF PriceIncreasesReferIndex.FindLast() THEN
            NoLine += 10000; 
            
        PriceIncreasesReferIndex."Contract No." := LeaseContract."Contract No.";
        PriceIncreasesReferIndex."Line No." := NoLine;
        if LeaseContract."Customer No." <> '' then
            PriceIncreasesReferIndex."Customer No." := LeaseContract."Customer No.";
        PriceIncreasesReferIndex."Starting Date" := LeaseContract."Starting Date";
        PriceIncreasesReferIndex."Contract Expiration Date" := LeaseContract."Expiration Date";
        if LeaseContract."Contact No." <> '' then
            PriceIncreasesReferIndex."Contact No." := LeaseContract."Contact No.";
        PriceIncreasesReferIndex."Fixed Real Estate No." := LeaseContract."Fixed Real Estate No.";
        PriceIncreasesReferIndex.INSERT;
        
        PriceIncreasesReferIndex."Consumer Price Index Category" := LeaseContract."Consumer Price Index Category";
        PriceIncreasesReferIndex.Year := Year;
        ConsumerPriceIndex.get(LeaseContract."Consumer Price Index Category",Year);
        "%Increment" := ConsumerPriceIndex."% Increment";
        PriceIncreasesReferIndex."CPI calculation amount" := BaseAmount;
        PriceIncreasesReferIndex."% Increment" := "%Increment";
        IncrementAmount := round((BaseAmount * "%Increment" / 100),0.01);
        PriceIncreasesReferIndex.Description := STRSUBSTNO('Incremento %1 del %2 es %3', LeaseContract."Consumer Price Index Category", Year, IncrementAmount);
        PriceIncreasesReferIndex.Amount := IncrementAmount;
        PriceIncreasesReferIndex."Current Unit Price" := LeaseContract."Amount per Period";
        PriceIncreasesReferIndex."Payment Method Code" := LeaseContract."Payment Method Code";
        PriceIncreasesReferIndex.MODIFY;
    end;

    local procedure ClearPostingGroups()
    begin
        "Gen. Bus. Posting Group" := '';
        "Gen. Prod. Posting Group" := '';
        "VAT Bus. Posting Group" := '';
        "VAT Prod. Posting Group" := '';
    end;

    procedure ValidateShortcutDimCode(FieldNumber: Integer; var ShortcutDimCode: Code[20])
    begin
        DimMgt.ValidateShortcutDimValues(FieldNumber, ShortcutDimCode, "Dimension Set ID");
    end;

    procedure LookupShortcutDimCode(FieldNumber: Integer; var ShortcutDimCode: Code[20])
    begin
        DimMgt.LookupDimValueCode(FieldNumber, ShortcutDimCode);
        DimMgt.ValidateShortcutDimValues(FieldNumber, ShortcutDimCode, "Dimension Set ID");
    end;

    procedure ShowShortcutDimCode(var ShortcutDimCode: array[8] of Code[20])
    begin
        DimMgt.GetShortcutDimensions("Dimension Set ID", ShortcutDimCode);
    end;

    procedure ShowDimensions()
    begin
        "Dimension Set ID" :=
          DimMgt.EditDimensionSet(
            "Dimension Set ID", STRSUBSTNO('%1 %2', "Contract No.", "Line No."),
            "Shortcut Dimension 1 Code", "Shortcut Dimension 2 Code");
    end;

    /// <summary>
    /// Gets the sales header associated with the sales line.
    /// Ensures the global SalesHeader variable is correctly set.
    /// </summary>
    /// <returns>The sales header of the current line.</returns>
    procedure GetLeaseHeader(): Record "Lease Contract"
    begin
        TestField("Contract No.");
        if ("Contract No." <> LeaseContractHeader."Contract No.") then
            if not LeaseContractHeader.Get("Contract No.") then
                Clear(LeaseContractHeader);

        exit(LeaseContractHeader);
    end;

    procedure InitHeaderDefaults(LeaseContractHeader: Record "Lease Contract")
    var
        IsHandled: Boolean;
    begin


        // "Shortcut Dimension 1 Code" := LeaseContractHeader."Shortcut Dimension 1 Code";
        // "Shortcut Dimension 2 Code" := LeaseContractHeader."Shortcut Dimension 2 Code";
        // "Dimension Set ID" := LeaseContractHeader."Dimension Set ID";

    end;

    local procedure CheckGLAcc(GLAcc: Record "G/L Account")
    begin
        GLAcc.CheckGLAcc;
    end;

    local procedure CopyFromStandardText()
    var
        StandardText: Record "Standard Text";
    begin
        StandardText.Get("Account No.");
        Description := StandardText.Description;
    end;

    local procedure CopyFromGLAccount(var TempLeaseLine: Record "Lease Contract Line" temporary)
    begin
        GLAcc.Get("Account No.");
        GLAcc.CheckGLAcc();
        Description := GLAcc.Name;

        "Gen. Bus. Posting Group" := GLAcc."Gen. Bus. Posting Group";
        "Gen. Prod. Posting Group" := GLAcc."Gen. Prod. Posting Group";
        "VAT Bus. Posting Group" := GLAcc."VAT Bus. Posting Group";
        "VAT Prod. Posting Group" := GLAcc."VAT Prod. Posting Group";
    end;

    local procedure CopyFromAllocationAccount(var TempLeaseLine: Record "Lease Contract Line" temporary)
    begin
        AllocationAccount.Get("Account No.");
//        AllocationAccount.CheckAllocationAccount();
        Description := AllocationAccount.Name;

        // "Gen. Bus. Posting Group" := AllocationAccount."Gen. Bus. Posting Group";
        // "Gen. Prod. Posting Group" := AllocationAccount."Gen. Prod. Posting Group";
        // "VAT Bus. Posting Group" := AllocationAccount."VAT Bus. Posting Group";
        // "VAT Prod. Posting Group" := AllocationAccount."VAT Prod. Posting Group";
    end;

    procedure SaveLookupSelection(SelectedRecordRef: RecordRef)
    var
        GLAccount: Record "G/L Account";
        AllocationAccount: Record "Allocation Account";
        LookupStateManager: Codeunit "Lookup State Manager";
        NewNo: Code[20];
        RecVariant: Variant;
    begin
        case Rec.Type of
            Rec.Type::"G/L Account":
                begin
                    SelectedRecordRef.SetTable(GLAccount);
                    RecVariant := GLAccount;
                    NewNo := GLAccount."No.";
                    LookupStateManager.SaveRecord(RecVariant);
                end;
            Rec.Type::"Allocation Account":
                begin
                    SelectedRecordRef.SetTable(AllocationAccount);
                    RecVariant := AllocationAccount;
                    NewNo := AllocationAccount."No.";
                    LookupStateManager.SaveRecord(RecVariant);
                end;
        end;
        if (Rec."Contract No." = '') and (NewNo <> '') then
            Rec.Validate("Contract No.", NewNo);
    end;

    [IntegrationEvent(false, false)]
    local procedure OnBeforeValidateType(var LeaseLine: Record "Lease Contract Line"; xLeaseLine: Record "Lease Contract Line"; CurrentFieldNo: Integer; var IsHandled: Boolean)
    begin
    end;

    [IntegrationEvent(false, false)]
    local procedure OnValidateTypeOnBeforeInitRec(var LeaseLine: Record "Lease Contract Line"; xLeaseLine: Record "Lease Contract Line"; CurrentFieldNo: Integer)
    begin
    end;

    [IntegrationEvent(false, false)]
    local procedure OnBeforeValidateNo(var LeaseLine: Record "Lease Contract Line"; xLeaseLine: Record "Lease Contract Line"; CurrentFieldNo: Integer; var IsHandled: Boolean)
    begin
    end;
}

