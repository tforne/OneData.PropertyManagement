table 96159 "ODPM Incident Agent Setup"
{
    Caption = 'ODPM Incident Agent Setup';
    DataClassification = CustomerContent;

    fields
    {
        field(1; "Primary Key"; Code[10])
        {
            Caption = 'Primary Key';
        }
        field(10; Enabled; Boolean)
        {
            Caption = 'Enabled';
        }
        field(20; "Shared Mailbox"; Text[100])
        {
            Caption = 'Shared Mailbox';
        }
        field(30; "Incoming Mail Folder"; Text[100])
        {
            Caption = 'Incoming Mail Folder';
        }
        field(40; "Power Automate Flow Name"; Text[100])
        {
            Caption = 'Power Automate Flow Name';
        }
        field(50; "Power Automate Flow URL"; Text[250])
        {
            Caption = 'Power Automate Flow URL';
        }
        field(60; "Use AI"; Boolean)
        {
            Caption = 'Use AI';
        }
        field(70; "AI Provider"; Option)
        {
            Caption = 'AI Provider';
            OptionCaption = ' ,Azure OpenAI,OpenAI,Custom Endpoint';
            OptionMembers = " ",AzureOpenAI,OpenAI,CustomEndpoint;
        }
        field(80; "Auto Create Drafts"; Boolean)
        {
            Caption = 'Auto Create Drafts';
        }
        field(90; "Confidence Threshold"; Decimal)
        {
            Caption = 'Confidence Threshold';
            DecimalPlaces = 0 : 5;
        }
        field(100; "Setup Completed"; Boolean)
        {
            Caption = 'Setup Completed';
        }
        field(110; "Last Validation At"; DateTime)
        {
            Caption = 'Last Validation At';
            Editable = false;
        }
        field(120; "Last Validation Result"; Text[250])
        {
            Caption = 'Last Validation Result';
            Editable = false;
        }
        field(130; "Help URL"; Text[250])
        {
            Caption = 'Help URL';
        }
    }

    keys
    {
        key(PK; "Primary Key")
        {
            Clustered = true;
        }
    }
}
