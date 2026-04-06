// ------------------------------------------------------------------------------------------------
// Copyright (c) Tomàs Forné Martínez. All rights reserved.
// ------------------------------------------------------------------------------------------------


namespace OneData.Property.Asset;
using OneData.Property.Setup;
using Microsoft.Foundation.NoSeries;


table 96750 "FRE Bank Statement"
{
    Caption = 'FRE Bank Statement';
    DataClassification = CustomerContent;

    fields
    {

        field(1; "No."; Code[20])
        {
            Caption = 'No.';
            Editable = false;
            DataClassification = SystemMetadata;
        }
        field(2; Company; Code[20])
        {
            Caption = 'Company';
        }

        field(3; Year; Integer)
        {
            Caption = 'Year';
        }

        field(4; Month; Option)
        {
            Caption = 'Month';
            OptionMembers = January,February,March,April,May,June,July,August,September,October,November,December;
        }

        field(5; "SharePoint URL"; Text[250])
        {
            Caption = 'SharePoint URL';
        }

        field(6; Status; Option)
        {
            Caption = 'Status';
            OptionMembers = Pending,Imported,Validated,Posted;
        }

        field(7; Imported; Boolean)
        {
            Caption = 'Imported';
        }

        field(8; Posted; Boolean)
        {
            Caption = 'Posted';
        }
    }

    keys
    {
        key(PK; "No.")
        {
            Clustered = true;
        }
    }
    trigger OnInsert()
    var
        NoSeriesCode: Code[20];
        REFASetup: Record "REF Setup";
        NoSeriesMgt: Codeunit "No. Series";
    begin
        IF "No." = '' THEN BEGIN
            REFASetup.GET;
            REFASetup.TESTFIELD("Statement Bank Nos.");
            NoSeriesCode := REFASetup."Statement Bank Nos.";
            "No." := NoSeriesMgt.GetNextNo(NoSeriesCode, WorkDate(), true);
        END;
    end;
}