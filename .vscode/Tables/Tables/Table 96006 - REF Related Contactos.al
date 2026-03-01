table 96006 "REF Related Contactos"
{
    DrillDownPageID = 96012;
    LookupPageID = 96012;
    Caption = 'Related Contacts';

    fields
    {
        field(1; "No. Entry."; Integer)
        {
            AutoIncrement = true;
            Caption = 'No. mov.';
            DataClassification = ToBeClassified;
        }
        field(2; "Entity Type"; Option)
        {
            Caption = 'Type de entidad';
            DataClassification = ToBeClassified;
            OptionCaption = 'Expedient,Contract,Fixed Real Estate,Opportunity';
            OptionMembers = Expedient,Contract,"Fixed Real Estate",Opportunity;
        }
        field(3; "Source No."; Code[20])
        {
            Caption = 'No.';
            DataClassification = ToBeClassified;
            TableRelation = IF ("Entity Type"=CONST("Fixed Real Estate")) "Fixed Real Estate"."No.";
        }
        field(4;Type;Option)
        {
            Caption = 'Tipo';
            DataClassification = ToBeClassified;
            OptionCaption = 'Owner,Administrator,Insurer,Maintenance,Property Representative,Tenant,Other';
            OptionMembers = Owner,Administrator,Insurer,Maintenance,"Property Representative",Tenant,Other;
        }
        field(5;"Contact No.";Code[20])
        {
            Caption = 'Contact No.';
            DataClassification = ToBeClassified;
            TableRelation = Contact;
        }
        field(6;Name;Text[100])
        {
            CalcFormula = Lookup(Contact.Name WHERE ("No."=FIELD("Contact No.")));
            Caption = 'Name';
            Editable = false;
            FieldClass = FlowField;
        }
        field(7;"Name 2";Text[100])
        {
            CalcFormula = Lookup(Contact."Name 2" WHERE ("No."=FIELD("Contact No.")));
            Caption = 'Name 2';
            Editable = false;
            FieldClass = FlowField;
        }
        field(8;Address;Text[100])
        {
            CalcFormula = Lookup(Contact.Address WHERE ("No."=FIELD("Contact No.")));
            Caption = 'Address';
            Editable = false;
            FieldClass = FlowField;
        }
        field(9;"Address 2";Text[50])
        {
            CalcFormula = Lookup(Contact."Address 2" WHERE ("No."=FIELD("Contact No.")));
            Caption = 'Address 2';
            Editable = false;
            FieldClass = FlowField;
        }
        field(10;City;Text[30])
        {
            CalcFormula = Lookup(Contact.City WHERE ("No."=FIELD("Contact No.")));
            Caption = 'City';
            Editable = false;
            FieldClass = FlowField;
        }
        field(11;"Post Code";Code[20])
        {
            CalcFormula = Lookup(Contact."Post Code" WHERE ("No."=FIELD("Contact No.")));
            Caption = 'Post Code';
            FieldClass = FlowField;
            TableRelation = "Post Code";
            ValidateTableRelation = false;
        }
        field(12;County;Text[30])
        {
            CalcFormula = Lookup(Contact.County WHERE ("No."=FIELD("Contact No.")));
            Caption = 'County';
            Editable = false;
            FieldClass = FlowField;
        }
        field(13;"Country/Region Code";Code[10])
        {
            CalcFormula = Lookup(Contact."Country/Region Code" WHERE ("No."=FIELD("Contact No.")));
            Caption = 'Country/Region Code';
            Editable = false;
            FieldClass = FlowField;
            TableRelation = "Country/Region";
        }
        field(14;"Phone No.";Text[30])
        {
            CalcFormula = Lookup(Contact."Phone No." WHERE ("No."=FIELD("Contact No.")));
            Caption = 'Phone No.';
            Editable = false;
            ExtendedDatatype = PhoneNo;
            FieldClass = FlowField;
        }
        field(15;"Telex No.";Text[20])
        {
            CalcFormula = Lookup(Contact."Telex No." WHERE ("No."=FIELD("Contact No.")));
            Caption = 'Telex No.';
            Editable = false;
            FieldClass = FlowField;
        }
        field(16;"Extension No.";Text[30])
        {
            CalcFormula = Lookup(Contact."Extension No." WHERE ("No."=FIELD("Contact No.")));
            Caption = 'Extension No.';
            Editable = false;
            FieldClass = FlowField;
        }
        field(17;"Mobile Phone No.";Text[30])
        {
            CalcFormula = Lookup(Contact."Mobile Phone No." WHERE ("No."=FIELD("Contact No.")));
            Caption = 'Mobile Phone No.';
            Editable = false;
            ExtendedDatatype = PhoneNo;
            FieldClass = FlowField;
        }
        field(18;Pager;Text[30])
        {
            CalcFormula = Lookup(Contact.Pager WHERE ("No."=FIELD("Contact No.")));
            Caption = 'Pager';
            Editable = false;
            FieldClass = FlowField;
        }
        field(19;"E-Mail";Text[80])
        {
            CalcFormula = Lookup(Contact."E-Mail" WHERE ("No."=FIELD("Contact No.")));
            Caption = 'E-Mail';
            Editable = false;
            ExtendedDatatype = EMail;
            FieldClass = FlowField;
        }
        field(20;"Home Page";Text[255])
        {
            CalcFormula = Lookup(Contact."Home Page" WHERE ("No."=FIELD("Contact No.")));
            Caption = 'Home Page';
            Editable = false;
            ExtendedDatatype = URL;
            FieldClass = FlowField;
        }
        field(21;"Fax No.";Text[30])
        {
            CalcFormula = Lookup(Contact."Fax No." WHERE ("No."=FIELD("Contact No.")));
            Caption = 'Fax No.';
            Editable = false;
            FieldClass = FlowField;
        }
        field(22;"Telex Answer Back";Text[20])
        {
            CalcFormula = Lookup(Contact."Telex Answer Back" WHERE ("No."=FIELD("Contact No.")));
            Caption = 'Telex Answer Back';
            Editable = false;
            FieldClass = FlowField;
        }
        field(86;"VAT Registration No.";Text[20])
        {
            CalcFormula = Lookup(Contact."VAT Registration No." WHERE ("No."=FIELD("Contact No.")));
            Caption = 'VAT Registration No.';
            Editable = false;
            FieldClass = FlowField;
        }
        field(50000;"User Garana";Boolean)
        {
            DataClassification = ToBeClassified;
        }
    }

    keys
    {
        key(Key1;"Entity Type","Source No.","No. Entry.")
        {
            Clustered = true;
        }
    }

    fieldgroups
    {
    }
}

