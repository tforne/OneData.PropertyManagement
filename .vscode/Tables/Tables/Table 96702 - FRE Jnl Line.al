// ------------------------------------------------------------------------------------------------
// Copyright (c) Tomàs Forné Martínez. All rights reserved.
// ------------------------------------------------------------------------------------------------

table 96702 "FRE Jnl. Line"
{
    Caption = 'FRE Jnl. Line';

    fields
    {
        field(1; "Journal Template Name"; Code[10])
        {
            Caption = 'Journal Template Name';
            TableRelation = "FRE Jnl. Template";
        }
        field(2; "Journal Batch Name"; Code[10])
        {
            Caption = 'Journal Batch Name';
            TableRelation = "FRE Jnl. Batch".Name WHERE("Journal Template Name" = FIELD("Journal Template Name"));
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
        field(7; "Fixed Real Estate No."; Code[20])
        {
            Caption = 'No.';
            TableRelation = "Fixed Real Estate"."No.";
        }
        field(8; Description; Text[100])
        {
            Caption = 'Description';
        }
        field(9; "Row No."; Code[10])
        {
            Caption = 'Row No.';
            DataClassification = ToBeClassified;
            trigger OnLookup()
            var
                REFIETemplate : record "REF Income & Expense Template";
                PageREFIETemplate : page "REF Income & Expenses Template";
            begin
                REFIETemplate.reset;
                REFIETemplate.setfilter(Type,'%1|%2',0,1);
                if REFIETemplate.FindFirst() then begin
                    PageREFIETemplate.LookupMode := true;
                    PageREFIETemplate.SetRecord(REFIETemplate);
                    PageREFIETemplate.SetTableView(REFIETemplate);
                    if PageREFIETemplate.RunModal() = Action::LookupOK then begin
                        PageREFIETemplate.GetRecord(REFIETemplate);
                        rec."Row No." := REFIETemplate."Row No.";
                        Rec."Description Row No." := REFIETemplate.Description;
                        rec."Entry Category" := REFIETemplate."Entry Category";
                    end;

                end;
            end;
        }
        field(10; "Description Row No."; Code[100])
        {
            Caption = 'Description Row No.';
            DataClassification = ToBeClassified;
        }
        field(13; Amount; Decimal)
        {
            AutoFormatType = 1;
            Caption = 'Amount';
            Editable = false;
        }
        field(15; "Amount Including VAT"; Decimal)
        {
            AutoFormatType = 1;
            Caption = 'Amount Including VAT';
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
        field(20; "Due Date"; Date)
        {
            Caption = 'Due Date';
        }
        field(21; Open; Boolean)
        {
            Caption = 'Open';
        }
        field(22; "Applies-to Entry No."; Integer)
        {
            Caption = 'Applies-to Entry No.';
            TableRelation = "FRE Ledger Entry"."Entry No.";
        }
        field(23; "Amount to Apply"; Decimal)
        {
            Caption = 'Amount to Apply';
            AutoFormatType = 1;
        }
        field(24; "External Document No."; Code[35])
        {
            Caption = 'External Document No.';
        }
        field(26; "Contract No."; Code[20])
        {
            Caption = 'Contract No.';
        }
        field(27; "Entry Category"; Enum "FRE Entry Category")
        {
            Caption = 'Entry Category';
        }
        field(57; "Source Type"; Enum "FRE Journal Source Type")
        {
            Caption = 'Source Type';
            DataClassification = ToBeClassified;
        }
        field(58; "Source No."; Code[20])
        {
            Caption = 'Source No.';
            DataClassification = ToBeClassified;
            TableRelation = IF ("Source Type" = CONST(Customer)) Customer
            ELSE IF ("Source Type" = CONST(Vendor)) Vendor
            ELSE IF ("Source Type" = CONST("Bank Account")) "Bank Account"
            ELSE IF ("Source Type" = CONST("Fixed Asset")) "Fixed Asset"
            ELSE IF ("Source Type" = CONST("Real Estate Asset")) "Fixed Real Estate"
            ELSE IF ("Source Type" = CONST(Employee)) Employee;
            trigger OnValidate()
            var
                RecCustomer: Record Customer;
                RecVendor: Record Vendor;
                RecBankAccount: Record "Bank Account";
                RecFRE : Record "Fixed Real Estate";
                RecEmployee: Record Employee;
                OneDataIRPFSetup: Record "OneData IRPF Setup";
            begin
                case "Source Type" of
                    rec."Source Type"::Customer:
                        begin
                            OneDataIRPFSetup.get();
                            RecCustomer.Get("Source No.");
                            "Source Name" := RecCustomer.Name;
                        end;
                    rec."Source Type"::Vendor:
                        begin
                            RecVendor.Get("Source No.");
                            "Source Name" := RecVendor.Name;

                        end;
                    rec."Source Type"::"Bank Account":
                        begin
                            RecBankAccount.Get("Source No.");
                            "Source Name" := RecBankAccount.Name;

                        end;
                    rec."Source Type"::"real estate asset":
                        begin
                            RecFRE.Get("Source No.");
                            "Source Name" := RecFRE.Description;
                        end;
                    rec."Source Type"::Employee:
                        begin
                            RecEmployee.Get("Source No.");
                            "Source Name" := RecEmployee.Name;
                        end;
                end;
            end;
        }
        field(62; "Source Name"; Text[50])
        {
            Caption = 'Source Name';
            DataClassification = ToBeClassified;

        }

        field(70; "System-Created Entry"; Boolean)
        {
            Caption = 'System-Created Entry';
            Editable = false;
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
        key(Key1; "Journal Template Name", "Journal Batch Name", "Line No.")
        {
            Clustered = true;
            MaintainSIFTIndex = false;
        }
        key(Key2; "Fixed Real Estate No.", "Date")
        {
        }
        key(Key3; "Document No.")
        {
        }
        key(Key4; "Source Type", "Source No.")
        {
        }
        key(Key5; Open, "Due Date")
        {
        }
        key(Key6; "Contract No.", "Date")
        {
        }
        key(Key7; "Entry Category", "Date")
        {
        }
        key(Key8; "Line Type")
        {
        }
        }

    fieldgroups
    {
    }

    trigger OnDelete()
    var
        ErrorMessage: Record "Error Message";
        FREJnlBatch: Record "FRE Jnl. Batch";
    begin
        FREJnlBatch.GET("Journal Template Name", "Journal Batch Name");
        ErrorMessage.SetContext(FREJnlBatch);
        ErrorMessage.ClearLogRec(Rec);
    end;

    trigger OnInsert()
    begin
        FREJnlTemplate.GET("Journal Template Name");
        FREJnlBatch.GET("Journal Template Name", "Journal Batch Name");
    end;

    trigger OnModify()
    begin
        FREJnlBatch.GET("Journal Template Name", "Journal Batch Name");
    end;

    trigger OnRename()
    begin
        FREJnlBatch.GET(xRec."Journal Template Name", xRec."Journal Batch Name");
    end;

    var
        FREJnlTemplate: Record "FRE Jnl. Template";
        FREJnlBatch: Record "FRE Jnl. Batch";

    procedure IsOpenedFromBatch(): Boolean
    var
        FREJnlBatch: Record "FRE Jnl. Batch";
        TemplateFilter: Text;
        BatchFilter: Text;
    begin
        BatchFilter := GETFILTER("Journal Batch Name");
        IF BatchFilter <> '' THEN BEGIN
            TemplateFilter := GETFILTER("Journal Template Name");
            IF TemplateFilter <> '' THEN
                FREJnlBatch.SETFILTER("Journal Template Name", TemplateFilter);
            FREJnlBatch.SETFILTER(Name, BatchFilter);
            FREJnlBatch.FINDFIRST;
        END;

        EXIT((("Journal Batch Name" <> '') AND ("Journal Template Name" = '')) OR (BatchFilter <> ''));
    end;

    procedure EmptyLine() Result: Boolean
    var
        IsHandled: Boolean;
    begin
        exit(
          ("Fixed Real Estate No." = '') and (Amount = 0)
           or (not "System-Created Entry"));
    end;
}

