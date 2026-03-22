table 96729 "FRE Import Preview v2"
{
    Caption = 'FRE Import Preview';
    DataClassification = ToBeClassified;

    fields
    {
        field(1; "Excel Row No."; Integer)
        {
            Caption = 'Excel Row No.';
        }

        field(2; Date; Date)
        {
            Caption = 'Date';
        }

        field(3; "Document Type Text"; Text[30])
        {
            Caption = 'Document Type';
        }

        field(4; "Document No."; Code[20])
        {
            Caption = 'Document No.';
        }

        field(5; "Line Type Text"; Text[50])
        {
            Caption = 'Line Type';
        }

        field(6; "Fixed Real Estate Description"; Text[100])
        {
            Caption = 'Fixed Real Estate Description';
        }

        field(7; "Fixed Real Estate No."; Code[20])
        {
            Caption = 'Fixed Real Estate No.';
            TableRelation = "Fixed Real Estate"."No.";
            trigger OnValidate()
            var
                AssetSuggestionMgt : Codeunit "FRE Asset Suggestion Mgt.";
                RE : Record "Fixed Real Estate";
            begin
                "Fixed Real Estate Description" := '';
                if re.get("Fixed Real Estate No.") then begin
                    "Fixed Real Estate Description" := re.Description;
                    AssetSuggestionMgt.LearnFromPreview(Rec);
                end;
            end;
        }

        field(8; Description; Text[100])
        {
            Caption = 'Description';
        }

        field(9; "Description Row No. Text"; Text[100])
        {
            Caption = 'Description Row No.';
        }

        field(10; "Row No."; Code[10])
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
                        Rec."Description Row No. Text" := REFIETemplate.Description;
                        rec."Entry Category" := REFIETemplate."Entry Category";
                    end;

                end;
            end;
        }

        field(11; Amount; Decimal)
        {
            Caption = 'Amount';
            AutoFormatType = 1;
        }

        field(12; "Amount Including VAT"; Decimal)
        {
            Caption = 'Amount Including VAT';
            AutoFormatType = 1;
        }

        field(13; Error; Text[250])
        {
            Caption = 'Error';
        }
        field(15; "Source Type"; Text[30])
        {
            Caption = 'Source Type';
        }

        field(16; "Source No."; Code[20])
        {
            Caption = 'Source No.';
        }
        field(17; "Entry Category"; Enum "FRE Entry Category")
        {
            Caption = 'Entry Category';
        }
        field(20; "Suggested Source Type"; Enum "FRE Journal Source Type") 
        {}
        field(21; "Suggested Source No."; Code[20]) 
        {}
        field(24; "Accept Suggestion"; Boolean) 
        {}
        field(30; "Suggested FRE No."; Code[20])
        {
            Caption = 'Suggested Fixed Real Estate No.';
        }
        field(31; "Suggested FRE Desc."; Text[100])
        {
            Caption = 'Suggested Fixed Real Estate Description';
        }
        field(32; "Suggestion Confidence"; Decimal)
        {
            Caption = 'Suggestion Confidence';
        }
        field(33; "Suggestion Explanation"; Text[250])
        {
            Caption = 'Suggestion Explanation';
        }

        field(34; "Accept FRE Suggestion"; Boolean)
        {
            Caption = 'Accept FRE Suggestion';
        }
    }

    keys
    {
        key(PK; "Excel Row No.")
        {
            Clustered = true;
        }
    }
}