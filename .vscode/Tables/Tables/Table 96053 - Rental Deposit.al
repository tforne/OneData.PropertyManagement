table 96053 "Rental Deposit"
{
    Caption = 'Rental Deposit';

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
        field(6; Description; Text[50])
        {
            Caption = 'Description';

            trigger OnValidate()
            begin
                TestStatusOpen;
            end;
        }
        field(24; Amount; Decimal)
        {
            AutoFormatType = 1;
            BlankZero = true;
            Caption = 'Line Amount';

        }
    }

    keys
    {
        key(Key1; "Contract No.", "Line No.")
        {
            Clustered = true;
            MaintainSIFTIndex = false;
            SumIndexFields = Amount;
        }
    }

    fieldgroups
    {
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
    end;

    var
        VATPostingSetup: Record "VAT Posting Setup";
        GenBusPostingGrp: Record "Gen. Business Posting Group";
        GenProdPostingGrp: Record "Gen. Product Posting Group";
        GLSetup: Record "General Ledger Setup";
        Currency: Record Currency;
        GLAcc: Record "G/L Account";
        ServLedgEntry: Record "Service Ledger Entry";
        LeaseContractHeader: Record "Lease Contract";
        LeaseContractLine: Record "Lease Contract Line";
        Text000: Label 'This service item does not belong to customer no. %1.';
        Text001: Label 'Service item %1 has a different ship-to code for this customer.\\Do you want to continue?';
        Text003: Label 'This service item already exists in this service contract.';
        Text008: Label '%1 field value cannot be later than the %2 field value on the contract line.';
        Text009: Label 'The %1 cannot be less than the %2.';
        Text011: Label 'Service ledger entry exists for service contract line %1.\\You may need to create a credit memo.';
        LeaseContractCommentLine: Record "Service Comment Line";
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
}

