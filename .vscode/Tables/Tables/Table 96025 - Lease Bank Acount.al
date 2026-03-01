table 96025 "Lease Bank Account"
{
    Caption = 'Customer Bank Account';
    DataCaptionFields = "Lease No.", "Code", Name;
    DrillDownPageID = 96042;
    LookupPageID = 96042;

    fields
    {
        field(1; "Lease No."; Code[20])
        {
            Caption = 'Customer No.';
            NotBlank = true;
            TableRelation = "Lease Contract";
        }
        field(2; "Code"; Code[20])
        {
            Caption = 'Code';
            NotBlank = true;
        }
        field(3; Name; Text[50])
        {
            Caption = 'Name';
        }
        field(5; "Name 2"; Text[50])
        {
            Caption = 'Name 2';
        }
        field(6; Address; Text[50])
        {
            Caption = 'Address';
        }
        field(7; "Address 2"; Text[50])
        {
            Caption = 'Address 2';
        }
        field(8; City; Text[30])
        {
            Caption = 'City';
            TableRelation = IF ("Country/Region Code"=CONST('')) "Post Code".City
                            ELSE IF ("Country/Region Code"=FILTER(<>'')) "Post Code".City WHERE ("Country/Region Code"=FIELD("Country/Region Code"));
            //This property is currently not supported
            //TestTableRelation = false;
            ValidateTableRelation = false;

            trigger OnValidate()
            begin
                PostCode.ValidateCity(City,"Post Code",County,"Country/Region Code",(CurrFieldNo <> 0) AND GUIALLOWED);
            end;
        }
        field(9;"Post Code";Code[20])
        {
            Caption = 'Post Code';
            TableRelation = IF ("Country/Region Code"=CONST()) "Post Code"
                            ELSE IF ("Country/Region Code"=FILTER(<>'')) "Post Code" WHERE ("Country/Region Code"=FIELD("Country/Region Code"));
            //This property is currently not supported
            //TestTableRelation = false;
            ValidateTableRelation = false;

            trigger OnValidate()
            begin
                PostCode.ValidatePostCode(City,"Post Code",County,"Country/Region Code",(CurrFieldNo <> 0) AND GUIALLOWED);
            end;
        }
        field(10;Contact;Text[50])
        {
            Caption = 'Contact';
        }
        field(11;"Phone No.";Text[30])
        {
            Caption = 'Phone No.';
            ExtendedDatatype = PhoneNo;
        }
        field(12;"Telex No.";Text[20])
        {
            Caption = 'Telex No.';
        }
        field(13;"Bank Branch No.";Text[20])
        {
            Caption = 'Bank Branch No.';
        }
        field(14;"Bank Account No.";Text[30])
        {
            Caption = 'Bank Account No.';

            trigger OnValidate()
            begin
                TESTFIELD("CCC Bank Account No.",'');
            end;
        }
        field(15;"Transit No.";Text[20])
        {
            Caption = 'Transit No.';
        }
        field(16;"Currency Code";Code[10])
        {
            Caption = 'Currency Code';
            TableRelation = Currency;
        }
        field(17;"Country/Region Code";Code[10])
        {
            Caption = 'Country/Region Code';
            TableRelation = "Country/Region";
        }
        field(18;County;Text[30])
        {
            CaptionClass = '5,1,' + "Country/Region Code";
            Caption = 'County';
        }
        field(19;"Fax No.";Text[30])
        {
            Caption = 'Fax No.';
        }
        field(20;"Telex Answer Back";Text[20])
        {
            Caption = 'Telex Answer Back';
        }
        field(21;"Language Code";Code[10])
        {
            Caption = 'Language Code';
            TableRelation = Language;
        }
        field(22;"E-Mail";Text[80])
        {
            Caption = 'Email';
            ExtendedDatatype = EMail;

            trigger OnValidate()
            var
                MailManagement: Codeunit "Mail Management";
            begin
                MailManagement.ValidateEmailAddressField("E-Mail");
            end;
        }
        field(23;"Home Page";Text[80])
        {
            Caption = 'Home Page';
            ExtendedDatatype = URL;
        }
        field(24;IBAN;Code[50])
        {
            Caption = 'IBAN';

            trigger OnValidate()
            var
                CompanyInfo: Record "Company Information";
            begin
                CompanyInfo.CheckIBAN(IBAN);
            end;
        }
        field(25;"SWIFT Code";Code[20])
        {
            Caption = 'SWIFT Code';
        }
        field(1211;"Bank Clearing Code";Text[50])
        {
            Caption = 'Bank Clearing Code';
        }
        field(1212;"Bank Clearing Standard";Text[50])
        {
            Caption = 'Bank Clearing Standard';
            TableRelation = "Bank Clearing Standard";
        }
        field(10700;"CCC Bank No.";Text[4])
        {
            Caption = 'CCC Bank No.';
            Numeric = true;

            trigger OnValidate()
            begin
                "CCC Bank No." := PrePadString("CCC Bank No.",MAXSTRLEN("CCC Bank No."));
                BuildCCC;
            end;
        }
        field(10701;"CCC Bank Branch No.";Text[4])
        {
            Caption = 'CCC Bank Branch No.';
            Numeric = true;

            trigger OnValidate()
            begin
                "CCC Bank Branch No." := PrePadString("CCC Bank Branch No.",MAXSTRLEN("CCC Bank Branch No."));
                BuildCCC;
            end;
        }
        field(10702;"CCC Control Digits";Text[2])
        {
            Caption = 'CCC Control Digits';
            Numeric = true;

            trigger OnValidate()
            begin
                "CCC Control Digits" := PrePadString("CCC Control Digits",MAXSTRLEN("CCC Control Digits"));
                BuildCCC;
            end;
        }
        field(10703;"CCC Bank Account No.";Text[10])
        {
            Caption = 'CCC Bank Account No.';
            Numeric = true;

            trigger OnValidate()
            begin
                "CCC Bank Account No." := PrePadString("CCC Bank Account No.",MAXSTRLEN("CCC Bank Account No."));
                BuildCCC;
            end;
        }
        field(10704;"CCC No.";Text[20])
        {
            Caption = 'CCC No.';
            Numeric = true;

            trigger OnValidate()
            begin
                "CCC Bank No." := COPYSTR("CCC No.",1,4);
                "CCC Bank Branch No." := COPYSTR("CCC No.",5,4);
                "CCC Control Digits" := COPYSTR("CCC No.",9,2);
                "CCC Bank Account No." := COPYSTR("CCC No.",11,23);
            end;
        }
    }

    keys
    {
        key(Key1;"Lease No.","Code")
        {
            Clustered = true;
        }
    }

    fieldgroups
    {
        fieldgroup(Brick;"Code",Name,"Phone No.",Contact)
        {
        }
    }

    trigger OnDelete()
    var
        CustLedgerEntry: Record "Cust. Ledger Entry";
    begin
    end;

    var
        PostCode: Record "Post Code";
        Customer: Record "Customer";
        BankAccIdentifierIsEmptyErr: Label 'You must specify either a Bank Account No. or an IBAN.';
        BankAccDeleteErr: Label 'You cannot delete this bank account because it is associated with one or more open ledger entries.';

    procedure BuildCCC()
    begin
        "CCC No." := "CCC Bank No." + "CCC Bank Branch No." + "CCC Control Digits" + "CCC Bank Account No.";
        IF "CCC No." <> '' THEN
          TESTFIELD("Bank Account No.",'');
    end;

    procedure PrePadString(InString: Text[250];MaxLen: Integer): Text[250]
    begin
        EXIT(PADSTR('', MaxLen - STRLEN(InString),'0') + InString);
    end;
}

