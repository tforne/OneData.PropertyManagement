table 96702 "FRE Jnl. Line"
{
    Caption = 'FRE Jnl. Line';

    fields
    {
        field(1; "Journal Template Name"; Code[10])
        {
            Caption = 'Journal Template Name';
            TableRelation = "OneData IRPF Jnl. Template";
        }
        field(2; "Journal Batch Name"; Code[10])
        {
            Caption = 'Journal Batch Name';
            TableRelation = "OneData IRPF Jnl. Batch".Name WHERE ("Journal Template Name"=FIELD("Journal Template Name"));
        }
        field(3; "Line No."; Integer)
        {
            Caption = 'Line No.';
        }
        field(5; Date; Date)
        {
            Caption = 'Date';
        }
        field(6; "Line Type"; Enum "FRE Line Type")
        {
            Caption = 'Line Type';
        }
        field(9; "Row No."; Code[10])
        {
            Caption = 'Row No.';
            TableRelation = "REF Income & Expense Template"."Row No.";
            DataClassification = ToBeClassified;
        }
        field(10; "Description Row No."; Code[10])
        {
            Caption = 'Description Row No.';
            DataClassification = ToBeClassified;
        }
        field(13; "Total Cost"; Decimal)
        {
            AutoFormatType = 1;
            Caption = 'Total Cost';
            Editable = false;
        }
        field(15; "Total Price"; Decimal)
        {
            AutoFormatType = 1;
            Caption = 'Total Price';
            Editable = false;
        }
        field(18; "Document Type"; Enum "Gen. Journal Document Type")
        {
            Caption = 'Document Type';
            DataClassification = ToBeClassified;
        }
        field(19; "Document No."; Code[20])
        {
            Caption = 'Document No.';
        }

        field(57;"Source Type"; Enum "Gen. Journal Source Type")
        {
            Caption = 'Source Type';
            DataClassification = ToBeClassified;
        }
        field(58;"Source No.";Code[20])
        {
            Caption = 'Source No.';
            DataClassification = ToBeClassified;
            TableRelation = IF ("Source Type"=CONST(Customer)) Customer
                            ELSE IF ("Source Type"=CONST(Vendor)) Vendor
                            ELSE IF ("Source Type"=CONST("Bank Account")) "Bank Account"
                            ELSE IF ("Source Type"=CONST("Fixed Asset")) "Fixed Asset"
                            ELSE IF ("Source Type"=CONST(Employee)) Employee;
            trigger OnValidate()
            var
                RecCustomer: Record Customer;
                RecVendor: Record Vendor;
                RecBankAccount: Record "Bank Account";
                RecFixedAsset: Record "Fixed Asset";
                RecEmployee: Record Employee;
                OneDataIRPFSetup : Record "OneData IRPF Setup";
            begin
                case "Source Type" of
                    rec."Source Type"::Customer : begin
                        OneDataIRPFSetup.get();
                        RecCustomer.Get("Source No.");
                        "Source Name" := RecCustomer.Name;
                    end;
                    rec."Source Type"::Vendor : begin
                        RecVendor.Get("Source No.");
                        "Source Name" := RecVendor.Name;

                    end;
                    rec."Source Type"::"Bank Account" : begin
                        RecBankAccount.Get("Source No.");
                        "Source Name" := RecBankAccount.Name;

                    end;
                    rec."Source Type"::"Fixed Asset" : begin
                        RecFixedAsset.Get("Source No.");
                        "Source Name" := RecFixedAsset.Description;
                    end;
                    rec."Source Type"::Employee : begin
                        RecEmployee.Get("Source No.");
                        "Source Name" := RecEmployee.Name;
                    end;
                end;
            end;
        }
        field(62;"Source Name";Text[50])
            {
            Caption = 'Source Name';
            DataClassification = ToBeClassified;
            TableRelation = "OneData Grupos IRPF";
        }
        field(1018; "Ledger Entry No."; Integer)
        {
            BlankZero = true;
            Caption = 'Ledger Entry No.';
            TableRelation = "G/L Entry"."Entry No.";
        }
    }

    keys
    {
        key(Key1;"Journal Template Name","Journal Batch Name","Line No.")
        {
            Clustered = true;
            MaintainSIFTIndex = false;
        }
    }

    fieldgroups
    {
    }

    trigger OnDelete()
    var
        ErrorMessage: Record "Error Message";
        IRPFJnlBatch: Record "OneData IRPF Jnl. Batch";
    begin
        IRPFJnlBatch.GET("Journal Template Name","Journal Batch Name");
        ErrorMessage.SetContext(IRPFJnlBatch);
        ErrorMessage.ClearLogRec(Rec);
    end;

    trigger OnInsert()
    begin
        IRPFJnlTemplate.GET("Journal Template Name");
        IRPFJnlBatch.GET("Journal Template Name","Journal Batch Name");
    end;

    trigger OnModify()
    begin
        IRPFJnlBatch.GET("Journal Template Name","Journal Batch Name");
    end;

    trigger OnRename()
    begin
        IRPFJnlBatch.GET(xRec."Journal Template Name",xRec."Journal Batch Name");
    end;

    var
        IRPFJnlTemplate: Record "OneData IRPF Jnl. Template";
        IRPFJnlBatch: Record "OneData IRPF Jnl. Batch";

    procedure IsOpenedFromBatch(): Boolean
    var
        IRPFJnlBatch: Record "OneData IRPF Jnl. Batch";
        TemplateFilter: Text;
        BatchFilter: Text;
    begin
        BatchFilter := GETFILTER("Journal Batch Name");
        IF BatchFilter <> '' THEN BEGIN
          TemplateFilter := GETFILTER("Journal Template Name");
          IF TemplateFilter <> '' THEN
            IRPFJnlBatch.SETFILTER("Journal Template Name",TemplateFilter);
          IRPFJnlBatch.SETFILTER(Name,BatchFilter);
          IRPFJnlBatch.FINDFIRST;
        END;

        EXIT((("Journal Batch Name" <> '') AND ("Journal Template Name" = '')) OR (BatchFilter <> ''));
    end;
}

