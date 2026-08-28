table 96926 "OD AM Lease Wizard Line"
{
    Caption = 'Lease Contract Wizard Line';
    DataClassification = ToBeClassified;

    fields
    {
        field(1; "Wizard Id"; Guid)
        {
            Caption = 'Wizard Id';
        }
        field(2; "Line No."; Integer)
        {
            Caption = 'Line No.';
        }
        field(5; Type; Enum "Lease Contract Line Type")
        {
            Caption = 'Type';

            trigger OnValidate()
            begin
                if Type = xRec.Type then
                    exit;

                Clear("Account No.");
                Clear(Description);
                Clear("Gen. Bus. Posting Group");
                Clear("Gen. Prod. Posting Group");
                Clear("VAT Bus. Posting Group");
                Clear("VAT Prod. Posting Group");
                Clear("VAT %");
                Clear("VAT Amount");
                Clear("VAT Base Amount");
            end;
        }
        field(10; "Account No."; Code[20])
        {
            Caption = 'Account No.';
            TableRelation = if (Type = const(" ")) "Standard Text"
            else
            if (Type = const("G/L Account")) "G/L Account" where("Direct Posting" = const(true), "Account Type" = const(Posting), Blocked = const(false))
            else
            if (Type = const("Allocation Account")) "Allocation Account";

            trigger OnValidate()
            var
                GLAccount: Record "G/L Account";
                AllocationAccount: Record "Allocation Account";
                StandardText: Record "Standard Text";
            begin
                if "Account No." = '' then begin
                    Clear(Description);
                    exit;
                end;

                case Type of
                    Type::" ":
                        begin
                            StandardText.Get("Account No.");
                            Description := StandardText.Description;
                        end;
                    Type::"G/L Account":
                        begin
                            GLAccount.Get("Account No.");
                            GLAccount.CheckGLAcc();
                            Description := GLAccount.Name;
                            "Gen. Bus. Posting Group" := GLAccount."Gen. Bus. Posting Group";
                            "Gen. Prod. Posting Group" := GLAccount."Gen. Prod. Posting Group";
                            "VAT Bus. Posting Group" := GLAccount."VAT Bus. Posting Group";
                            Validate("VAT Prod. Posting Group", GLAccount."VAT Prod. Posting Group");
                        end;
                    Type::"Allocation Account":
                        begin
                            AllocationAccount.Get("Account No.");
                            Description := AllocationAccount.Name;
                        end;
                end;
            end;
        }
        field(20; Description; Text[50])
        {
            Caption = 'Description';
        }
        field(30; "Unit of Measure Code"; Code[10])
        {
            Caption = 'Unit of Measure Code';
            TableRelation = "Unit of Measure";
        }
        field(40; "Response Time (Hours)"; Decimal)
        {
            Caption = 'Response Time (Hours)';
            DecimalPlaces = 0 : 5;
        }
        field(50; Value; Decimal)
        {
            Caption = 'Line Value';
            AutoFormatType = 1;

            trigger OnValidate()
            begin
                Amount := Value;
                RecalculateVATAmounts();
            end;
        }
        field(60; Amount; Decimal)
        {
            Caption = 'Line Amount';
            AutoFormatType = 1;

            trigger OnValidate()
            begin
                RecalculateVATAmounts();
            end;
        }
        field(70; "VAT Bus. Posting Group"; Code[20])
        {
            Caption = 'VAT Bus. Posting Group';
            TableRelation = "VAT Business Posting Group";
        }
        field(80; "VAT Prod. Posting Group"; Code[20])
        {
            Caption = 'VAT Prod. Posting Group';
            TableRelation = "VAT Product Posting Group";

            trigger OnValidate()
            var
                VATPostingSetup: Record "VAT Posting Setup";
            begin
                Clear("VAT %");
                "VAT Calculation Type" := "VAT Calculation Type"::"Normal VAT";

                if VATPostingSetup.Get("VAT Bus. Posting Group", "VAT Prod. Posting Group") then begin
#pragma warning disable AL0603
                    "VAT Calculation Type" := VATPostingSetup."VAT Calculation Type";
#pragma warning restore AL0603
                    case "VAT Calculation Type" of
                        "VAT Calculation Type"::"Normal VAT",
                        "VAT Calculation Type"::"No Taxable VAT":
                            "VAT %" := VATPostingSetup."VAT+EC %";
                    end;
                end;

                RecalculateVATAmounts();
            end;
        }
        field(90; "VAT %"; Decimal)
        {
            Caption = 'VAT %';
            DecimalPlaces = 0 : 5;
        }
        field(100; "VAT Calculation Type"; Option)
        {
            Caption = 'VAT Calculation Type';
            OptionCaption = 'Normal VAT,Reverse Charge VAT,Full VAT,Sales Tax,No Taxable VAT';
            OptionMembers = "Normal VAT","Reverse Charge VAT","Full VAT","Sales Tax","No Taxable VAT";
        }
        field(110; "VAT Base Amount"; Decimal)
        {
            Caption = 'VAT Base Amount';
            AutoFormatType = 1;
            Editable = false;
        }
        field(120; "VAT Amount"; Decimal)
        {
            Caption = 'VAT Amount';
            AutoFormatType = 1;
            Editable = false;
        }
        field(130; "Service Period"; DateFormula)
        {
            Caption = 'Service Period';
        }
        field(140; "Starting Date"; Date)
        {
            Caption = 'Starting Date';
        }
        field(150; "Contract Expiration Date"; Date)
        {
            Caption = 'Contract Expiration Date';
        }
        field(160; "Credit Memo Date"; Date)
        {
            Caption = 'Credit Memo Date';
        }
        field(170; "Shortcut Dimension 1 Code"; Code[20])
        {
            CaptionClass = '1,2,1';
            Caption = 'Shortcut Dimension 1 Code';
            TableRelation = "Dimension Value".Code where("Global Dimension No." = const(1), Blocked = const(false));
        }
        field(180; "Shortcut Dimension 2 Code"; Code[20])
        {
            CaptionClass = '1,2,2';
            Caption = 'Shortcut Dimension 2 Code';
            TableRelation = "Dimension Value".Code where("Global Dimension No." = const(2), Blocked = const(false));
        }
        field(190; "Dimension Set ID"; Integer)
        {
            Caption = 'Dimension Set ID';
        }
        field(200; "Aplicar incrementos"; Boolean)
        {
            Caption = 'Aplicar incrementos';
        }
        field(210; "Base Contract"; Boolean)
        {
            Caption = 'Base Contract';
        }
        field(220; "Aplicar Impuestos"; Boolean)
        {
            Caption = 'Aplicar Impuestos';
        }
        field(230; "Consumer Price Index Category"; Code[10])
        {
            Caption = 'Consumer Price Index Category';
            TableRelation = "Consumer Price Index Categorie"."Con. Price Index Category Code";
        }
        field(240; Year; Integer)
        {
            Caption = 'Year';
        }
        field(250; "% Increment"; Decimal)
        {
            Caption = '% Increment';
        }
        field(260; "CPI calculation amount"; Decimal)
        {
            Caption = 'CPI calculation amount';
        }
        field(270; "Gen. Bus. Posting Group"; Code[20])
        {
            Caption = 'Gen. Bus. Posting Group';
            TableRelation = "Gen. Business Posting Group";
        }
        field(280; "Gen. Prod. Posting Group"; Code[20])
        {
            Caption = 'Gen. Prod. Posting Group';
            TableRelation = "Gen. Product Posting Group";
        }
    }

    keys
    {
        key(PK; "Wizard Id", "Line No.")
        {
            Clustered = true;
        }
    }

    trigger OnInsert()
    begin
        if "Line No." = 0 then
            "Line No." := GetNextLineNo();
    end;

    local procedure GetNextLineNo(): Integer
    var
        WizardLine: Record "OD AM Lease Wizard Line";
    begin
        WizardLine.SetRange("Wizard Id", "Wizard Id");
        if WizardLine.FindLast() then
            exit(WizardLine."Line No." + 10000);

        exit(10000);
    end;

    local procedure RecalculateVATAmounts()
    begin
        case "VAT Calculation Type" of
            "VAT Calculation Type"::"Normal VAT",
            "VAT Calculation Type"::"No Taxable VAT",
            "VAT Calculation Type"::"Reverse Charge VAT":
                begin
                    "VAT Base Amount" := Round(Amount, 0.01);
                    "VAT Amount" := Round("VAT Base Amount" * ("VAT %" / 100), 0.01);
                end;
            "VAT Calculation Type"::"Full VAT":
                begin
                    "VAT Base Amount" := Amount;
                    "VAT Amount" := Amount;
                end;
            else begin
                "VAT Base Amount" := Amount;
                "VAT Amount" := 0;
            end;
        end;
    end;
}
