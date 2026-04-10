table 96156 "RE Insurance Policy"
{
    Caption = 'RE Insurance Policy';
    DataPerCompany = false;

    fields
    {
        field(1; "No."; Code[20])
        {
            Caption = 'No.';
        }
        field(2; "Fixed Real Estate No."; Code[20])
        {
            Caption = 'Fixed Real Estate No.';
            TableRelation = "Fixed Real Estate"."No.";
        }
        field(3; Description; Text[100])
        {
            Caption = 'Description';
        }
        field(4; "Policy No."; Code[50])
        {
            Caption = 'Policy No.';
        }
        field(5; "Insurer Name"; Text[100])
        {
            Caption = 'Insurer Name';
        }
        field(6; "Broker Name"; Text[100])
        {
            Caption = 'Broker Name';
        }
        field(7; "Coverage Type"; Option)
        {
            Caption = 'Coverage Type';
            OptionMembers = Building,Contents,Liability,RentDefault,Other;
            OptionCaption = 'Building,Contents,Liability,Rent Default,Other';
        }
        field(8; "Starting Date"; Date)
        {
            Caption = 'Starting Date';
        }
        field(9; "Ending Date"; Date)
        {
            Caption = 'Ending Date';
        }
        field(10; "Claim E-Mail"; Text[100])
        {
            Caption = 'Claim E-Mail';
            ExtendedDatatype = EMail;
        }
        field(11; "Claim Phone No."; Text[30])
        {
            Caption = 'Claim Phone No.';
            ExtendedDatatype = PhoneNo;
        }
        field(12; "Coverage Amount"; Decimal)
        {
            Caption = 'Coverage Amount';
        }
        field(13; Deductible; Decimal)
        {
            Caption = 'Deductible';
        }
        field(14; Premium; Decimal)
        {
            Caption = 'Premium';
        }
        field(15; Active; Boolean)
        {
            Caption = 'Active';
            InitValue = true;
        }
        field(16; Notes; Text[250])
        {
            Caption = 'Notes';
        }
    }

    keys
    {
        key(PK; "No.")
        {
            Clustered = true;
        }
        key(Key2; "Fixed Real Estate No.", Active)
        {
        }
        key(Key3; "Policy No.")
        {
        }
    }

    trigger OnInsert()
    var
        REFSetup: Record "REF Setup";
        NoSeries: Codeunit "No. Series";
    begin
        if "No." <> '' then
            exit;

        REFSetup.Get();
        REFSetup.TestField("Insurance Nos.");
        "No." := NoSeries.GetNextNo(REFSetup."Insurance Nos.", WorkDate(), true);
    end;
}
