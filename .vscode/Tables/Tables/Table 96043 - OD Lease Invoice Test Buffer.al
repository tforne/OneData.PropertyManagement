namespace OneData.Property.Lease;

table 96043 "OD Lease Invoice Test Buffer"
{
    Caption = 'Lease Invoice Test Buffer';
    DataClassification = SystemMetadata;

    fields
    {
        field(1; "Line No."; Integer)
        {
            Caption = 'Line No.';
        }
        field(2; "Contract No."; Code[20])
        {
            Caption = 'Contract No.';
        }
        field(3; "Customer No."; Code[20])
        {
            Caption = 'Customer No.';
        }
        field(4; Status; Option)
        {
            Caption = 'Status';
            OptionCaption = 'Validated,Skipped,Error';
            OptionMembers = Validated,Skipped,Error;
        }
        field(5; "Combined Invoice Group"; Boolean)
        {
            Caption = 'Combined Invoice Group';
        }
        field(6; Message; Text[250])
        {
            Caption = 'Message';
        }
        field(7; PostingDate; Date)
        {
            Caption = 'Posting Date';
        }
        field(8; InvoiceFrom; Date)
        {
            Caption = 'Invoice From';
        }
        field(9; InvoiceTo; Date)
        {
            Caption = 'Invoice To';
        }
        field(10; TestAmount; Decimal)
        {
            Caption = 'Amount';
            AutoFormatType = 1;
        }
    }

    keys
    {
        key(PK; "Line No.")
        {
            Clustered = true;
        }
    }
}
