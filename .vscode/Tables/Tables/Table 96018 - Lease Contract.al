table 96018 "Lease Contract"
{
    DrillDownPageID = 96030;
    LookupPageID = 96030;

    fields
    {
        field(1; "Contract No."; Code[20])
        {
            DataClassification = ToBeClassified;
        }
        field(2; Description; Text[80])
        {
            Caption = 'Descripción';
            DataClassification = ToBeClassified;
        }
        field(3; "Last Date Modified"; Date)
        {
            Caption = 'Last Date Modified';
            DataClassification = ToBeClassified;
            Editable = false;
        }
        field(5; Status; Option)
        {
            Caption = 'Status';
            DataClassification = ToBeClassified;
            Editable = true;
            OptionCaption = ' ,Signed,Canceled';
            OptionMembers = " ",Signed,Canceled;

            trigger OnValidate()
            var
                AnyServItemInOtherContract: Boolean;
            begin
            end;
        }
        field(7; "Customer No."; Code[20])
        {
            Caption = 'Customer No.';
            DataClassification = ToBeClassified;
            NotBlank = true;
            TableRelation = Customer;

            trigger OnValidate()
            begin
                Cust.GET("Customer No.");

                IF "Customer No." <> xRec."Customer No." THEN BEGIN
                    CALCFIELDS(
                      Name, "Name 2", Address, "Address 2",
                      "Post Code", City, County, "Country/Region Code");
                    CALCFIELDS(
                      "Second Name", "Second Name 2", "Second Address", "Second Address 2",
                      "Second Post Code", "Second City", "Second County", "Second Country/Region Code");
                END;
            end;
        }
        field(8; Name; Text[100])
        {
            CalcFormula = Lookup (Customer.Name WHERE ("No."=FIELD("Customer No.")));
            Caption = 'Name';
            Editable = false;
            FieldClass = FlowField;
        }
        field(9;Address;Text[100])
        {
            CalcFormula = Lookup(Customer.Address WHERE ("No."=FIELD("Customer No.")));
            Caption = 'Address';
            Editable = false;
            FieldClass = FlowField;
        }
        field(10;"Address 2";Text[50])
        {
            CalcFormula = Lookup(Customer."Address 2" WHERE ("No."=FIELD("Customer No.")));
            Caption = 'Address 2';
            Editable = false;
            FieldClass = FlowField;
        }
        field(11;"Post Code";Code[20])
        {
            CalcFormula = Lookup(Customer."Post Code" WHERE ("No."=FIELD("Customer No.")));
            Caption = 'Post Code';
            Editable = false;
            FieldClass = FlowField;
        }
        field(12;City;Text[30])
        {
            CalcFormula = Lookup(Customer.City WHERE ("No."=FIELD("Customer No.")));
            Caption = 'City';
            Editable = false;
            FieldClass = FlowField;
        }
        field(13;"Contact Name";Text[50])
        {
            Caption = 'Contact Name';
            DataClassification = ToBeClassified;
        }
        field(15;"Salesperson Code";Code[20])
        {
            Caption = 'Salesperson Code';
            DataClassification = ToBeClassified;
            TableRelation = "Salesperson/Purchaser";

            trigger OnValidate()
            begin
                ValidateSalesPersonOnServiceContractHeader(Rec,FALSE,FALSE);

                MODIFY;
            end;
        }
        field(16;"Second Customer No.";Code[20])
        {
            Caption = 'Second Customer No.';
            DataClassification = ToBeClassified;
            TableRelation = Customer;

            trigger OnValidate()
            var
                CustCheckCrLimit: Codeunit "Cust-Check Cr. Limit";
            begin
                IF xRec."Second Customer No." <> "Second Customer No." THEN
                  Confirmed := TRUE;

                IF Confirmed THEN BEGIN
                  IF "Second Customer No." <> xRec."Second Customer No." THEN
                    IF "Second Customer No." <> '' THEN BEGIN
                      Cust.GET("Second Customer No.");
                      IF Cust."Privacy Blocked" THEN
                        Cust.CustPrivacyBlockedErrorMessage(Cust,FALSE);
                      IF Cust.Blocked = Cust.Blocked::All THEN
                        Cust.CustBlockedErrorMessage(Cust,FALSE);
                    END ELSE BEGIN
                      "Second Contact No." := '';
                      "Second Contact" := '';
                      END;

                  IF Cust.GET("Second Customer No.") THEN BEGIN
                    "Payment Terms Code" := Cust."Payment Terms Code";
                    "Language Code" := Cust."Language Code";
                    SetSalespersonCode(Cust."Salesperson Code","Salesperson Code");
                    IF NOT SkipBillToContact THEN
                      "Second Contact" := Cust.Contact;
                  END;

                  CALCFIELDS(
                    "Second Name","Second Name 2","Second Address","Second Address 2",
                    "Second Post Code","Second City","Second County","Second Country/Region Code");

                  IF NOT SkipBillToContact THEN
                    UpdateBillToCont("Second Customer No.");
                END ELSE
                  "Second Customer No." := xRec."Second Customer No.";
            end;
        }
        field(17;"Second Name";Text[100])
        {
            CalcFormula = Lookup(Customer.Name WHERE ("No."=FIELD("Second Customer No.")));
            Caption = 'Second Name';
            Editable = false;
            FieldClass = FlowField;
        }
        field(18;"Second Address";Text[100])
        {
            CalcFormula = Lookup(Customer.Address WHERE ("No."=FIELD("Second Customer No.")));
            Caption = 'Second Address';
            Editable = false;
            FieldClass = FlowField;
        }
        field(19;"Second Address 2";Text[50])
        {
            CalcFormula = Lookup(Customer."Address 2" WHERE ("No."=FIELD("Second Customer No.")));
            Caption = 'Second Address 2';
            Editable = false;
            FieldClass = FlowField;
        }
        field(20;"Second Post Code";Code[20])
        {
            CalcFormula = Lookup(Customer."Post Code" WHERE ("No."=FIELD("Second Customer No.")));
            Caption = 'Second Post Code';
            Editable = false;
            FieldClass = FlowField;
        }
        field(21;"Second City";Text[30])
        {
            CalcFormula = Lookup(Customer.City WHERE ("No."=FIELD("Second Customer No.")));
            Caption = 'Second City';
            Editable = false;
            FieldClass = FlowField;
        }
        field(28;"No. Series";Code[20])
        {
            Caption = 'No. Series';
            DataClassification = ToBeClassified;
            Editable = true;
            TableRelation = "No. Series";
        }
        field(29;"Your Reference";Text[35])
        {
            Caption = 'Your Reference';
            DataClassification = ToBeClassified;
        }
        field(30;"Fixed Real Estate No.";Code[20])
        {
            Caption = 'Fixed Real Estate No.';
            DataClassification = ToBeClassified;
            TableRelation = "Fixed Real Estate";

            trigger OnValidate()
            begin
                IF FixedRealEstate.GET("Fixed Real Estate No.") THEN BEGIN
                  "Description Fixed Real Estate" := FixedRealEstate.Description;
                  "Types Street Numbering Id." := "Types Street Numbering Id.";
                  "Street Name" := FixedRealEstate."Street Name";
                  "Number On Street" :=  FixedRealEstate."Number On Street";
                  "Location Height Floor" := FixedRealEstate."Location Height Floor";
                  "FRE Address" := FixedRealEstate."Composse Address";
                  "Google URL" := FixedRealEstate."Google URL";
                  "FRE City" := FixedRealEstate.City;
                  "FRE Phone No." := FixedRealEstate."Phone No.";
                  "FRE Territory Code" := FixedRealEstate."Territory Code";
                  "FRE Country/Region Code" := FixedRealEstate."Country/Region Code";
                  "FRE Post Code" := FixedRealEstate."Post Code";
                  "FRE County":= FixedRealEstate.County;
                  "FRE Property No."  := FixedRealEstate."Property No.";
                  "Google URL"  := FixedRealEstate."Google URL";
                  // Contactos relacionados
                  REFRelatedContactos.RESET;
                  REFRelatedContactos.SETRANGE("Entity Type",REFRelatedContactos."Entity Type"::"Fixed Real Estate");
                  REFRelatedContactos.SETRANGE("Source No.","Fixed Real Estate No.");
                  IF REFRelatedContactos.FINDFIRST THEN REPEAT
                    InsREFRelatedContactos := REFRelatedContactos;
                    InsREFRelatedContactos."Entity Type" := InsREFRelatedContactos."Entity Type" :: Contract;
                    InsREFRelatedContactos."Source No." := "Contract No.";
                    InsREFRelatedContactos.INSERT;
                    UNTIL REFRelatedContactos.NEXT = 0;
                END;
            end;
        }
        field(31;"Description Fixed Real Estate";Text[50])
        {
            CalcFormula = Lookup("Fixed Real Estate".Description WHERE ("No."=FIELD("Fixed Real Estate No.")));
            Caption = 'Description';
            Editable = false;
            FieldClass = FlowField;

        }
        field(32;"Invoice Period";Option)
        {
            Caption = 'Invoice Period';
            DataClassification = ToBeClassified;
            OptionCaption = 'Month,Two Months,Quarter,Half Year,Year,None';
            OptionMembers = Month,"Two Months",Quarter,"Half Year",Year,"None";
        }
        field(33;"Last Invoice Date";Date)
        {
            Caption = 'Last Invoice Date';
            DataClassification = ToBeClassified;
            Editable = false;
        }
        field(34;"Next Invoice Date";Date)
        {
            Caption = 'Next Invoice Date';
            DataClassification = ToBeClassified;
            Editable = false;

            trigger OnValidate()
            begin
            end;
        }
        field(35;"Starting Date";Date)
        {
            Caption = 'Starting Date';
            DataClassification = ToBeClassified;
        }
        field(36;"Expiration Date";Date)
        {
            Caption = 'Expiration Date';
            DataClassification = ToBeClassified;
        }
        field(37;"Contract Date";Date)
        {
            DataClassification = ToBeClassified;
        }
        field(42;"Annual Amount";Decimal)
        {
            AutoFormatType = 1;
            BlankZero = true;
            Caption = 'Annual Amount';
            DataClassification = ToBeClassified;
            MinValue = 0;
        }
        field(43;"Amount per Period";Decimal)
        {
            AutoFormatType = 1;
            BlankZero = true;
            Caption = 'Amount per Period';
            DataClassification = ToBeClassified;
            Editable = false;
        }
        field(44;"Combine Invoices";Boolean)
        {
            Caption = 'Combine Invoices';
            DataClassification = ToBeClassified;
        }
        field(47;"Payment Method Code";Code[10])
        {
            Caption = 'Payment Method Code';
            DataClassification = ToBeClassified;
            TableRelation = "Payment Method";

            trigger OnValidate()
            var
                PaymentMethod: Record "Payment Method";
            begin
                IF "Payment Method Code" = '' THEN
                  EXIT;

                PaymentMethod.GET("Payment Method Code");
                IF PaymentMethod."Direct Debit" AND ("Payment Terms Code" = '') THEN
                  VALIDATE("Payment Terms Code",PaymentMethod."Direct Debit Pmt. Terms Code");
            end;
        }
        field(48;"Language Code";Code[10])
        {
            Caption = 'Language Code';
            DataClassification = ToBeClassified;
            TableRelation = Language;
        }
        field(50;"Cancel Reason Code";Code[10])
        {
            Caption = 'Cancel Reason Code';
            DataClassification = ToBeClassified;
            TableRelation = "Reason Code";
        }
        field(59;"Lease Period";DateFormula)
        {
            Caption = 'Service Period';
            DataClassification = ToBeClassified;

            trigger OnValidate()
            begin
                "Expiration Date" := CALCDATE("Lease Period","Starting Date");
            end;
        }
        field(60;"Payment Terms Code";Code[10])
        {
            Caption = 'Payment Terms Code';
            DataClassification = ToBeClassified;
            TableRelation = "Payment Terms";
        }
        field(85;"Responsibility Center";Code[10])
        {
            Caption = 'Responsibility Center';
            DataClassification = ToBeClassified;
            TableRelation = "Responsibility Center";

            trigger OnValidate()
            begin
                /*
                IF NOT UserMgt.CheckRespCenter(2,"Responsibility Center") THEN
                  ERROR(
                    Text040,
                    RespCenter.TABLECAPTION,UserMgt.GetSalesFilter);
                
                CreateDim(
                  DATABASE::"Salesperson/Purchaser","Salesperson Code",
                  DATABASE::Customer,"Second Customer No.",
                  DATABASE::"Responsibility Center","Responsibility Center",
                  DATABASE::"Service Contract Template","Template No.",
                  DATABASE::"Service Order Type","Service Order Type");
                */

            end;
        }
        field(86;"Phone No.";Text[30])
        {
            Caption = 'Phone No.';
            DataClassification = ToBeClassified;
            ExtendedDatatype = PhoneNo;
        }
        field(87;"Fax No.";Text[30])
        {
            Caption = 'Fax No.';
            DataClassification = ToBeClassified;
        }
        field(88;"E-Mail";Text[80])
        {
            Caption = 'Email';
            DataClassification = ToBeClassified;
            ExtendedDatatype = EMail;

            trigger OnValidate()
            var
                MailManagement: Codeunit "Mail Management";
            begin
                MailManagement.ValidateEmailAddressField("E-Mail");
            end;
        }
        field(89;"Second County";Text[30])
        {
            CalcFormula = Lookup(Customer.County WHERE ("No."=FIELD("Second Customer No.")));
            CaptionClass = '5,1,' + "Second Country/Region Code";
            Caption = 'Second County';
            Editable = false;
            FieldClass = FlowField;
        }
        field(90;County;Text[30])
        {
            CalcFormula = Lookup(Customer.County WHERE ("No."=FIELD("Customer No.")));
            CaptionClass = '5,1,' + "Country/Region Code";
            Caption = 'County';
            Editable = false;
            FieldClass = FlowField;
        }
        field(92;"Country/Region Code";Code[10])
        {
            CalcFormula = Lookup(Customer."Country/Region Code" WHERE ("No."=FIELD("Customer No.")));
            Caption = 'Country/Region Code';
            Editable = false;
            FieldClass = FlowField;
        }
        field(93;"Second Country/Region Code";Code[10])
        {
            CalcFormula = Lookup(Customer."Country/Region Code" WHERE ("No."=FIELD("Second Customer No.")));
            Caption = 'Second Country/Region Code';
            Editable = false;
            FieldClass = FlowField;
        }
        field(95;"Name 2";Text[50])
        {
            CalcFormula = Lookup(Customer."Name 2" WHERE ("No."=FIELD("Customer No.")));
            Caption = 'Name 2';
            Editable = false;
            FieldClass = FlowField;
        }
        field(96;"Second Name 2";Text[50])
        {
            CalcFormula = Lookup(Customer."Name 2" WHERE ("No."=FIELD("Second Customer No.")));
            Caption = 'Second Name 2';
            Editable = false;
            FieldClass = FlowField;
        }
        field(98;"Next Invoice Period Start";Date)
        {
            Caption = 'Next Invoice Period Start';
            DataClassification = ToBeClassified;
            Editable = false;
        }
        field(99;"Next Invoice Period End";Date)
        {
            Caption = 'Next Invoice Period End';
            DataClassification = ToBeClassified;
            Editable = false;
        }
        field(100;"Lease Manag. Amount per Period";Decimal)
        {
            AutoFormatType = 1;
            BlankZero = true;
            Caption = 'Lease Manag. Amount per Period';
            DataClassification = ToBeClassified;
        }
        field(101;"Prices Services Including VAT";Boolean)
        {
            DataClassification = ToBeClassified;
        }
        field(102;"Phone No. 2";Text[30])
        {
            Caption = 'Phone No.';
            DataClassification = ToBeClassified;
            ExtendedDatatype = PhoneNo;
        }
        field(103;"E-Mail 2";Text[80])
        {
            Caption = 'Email';
            DataClassification = ToBeClassified;
            ExtendedDatatype = EMail;

            trigger OnValidate()
            var
                MailManagement: Codeunit "Mail Management";
            begin
                MailManagement.ValidateEmailAddressField("E-Mail");
            end;
        }
        field(200;"Important Comments";BLOB)
        {
            Caption = 'Important Comments';
            DataClassification = ToBeClassified;
        }
        field(288;"Preferred Bank Account Code";Code[20])
        {
            Caption = 'Preferred Bank Account Code';
            DataClassification = ToBeClassified;
            TableRelation = "Lease Bank Account".Code WHERE ("Lease No."=FIELD("Contract No."));
        }
        field(5050;"Contact No.";Code[20])
        {
            Caption = 'Contact No.';
            DataClassification = ToBeClassified;
            TableRelation = Contact;

            trigger OnLookup()
            var
                Cont: Record Contact;
                ContBusinessRelation: Record "Contact Business Relation";
            begin
                IF ("Customer No." <> '') AND Cont.GET("Contact No.") THEN
                  Cont.SETRANGE("Company No.",Cont."Company No.")
                ELSE
                  IF "Customer No." <> '' THEN BEGIN
                    IF ContBusinessRelation.FindByRelation(ContBusinessRelation."Link to Table"::Customer,"Customer No.") THEN
                      Cont.SETRANGE("Company No.",ContBusinessRelation."Contact No.");
                  END ELSE
                    Cont.SETFILTER("Company No.",'<>%1','''');

                IF "Contact No." <> '' THEN
                  IF Cont.GET("Contact No.") THEN ;
                IF PAGE.RUNMODAL(0,Cont) = ACTION::LookupOK THEN BEGIN
                  xRec := Rec;
                  VALIDATE("Contact No.",Cont."No.");
                END;
            end;

            trigger OnValidate()
            var
                Cont: Record Contact;
                ContBusinessRelation: Record "Contact Business Relation";
            begin
                IF ("Contact No." <> xRec."Contact No.") AND (xRec."Contact No." <> '') THEN
                  IF NOT CONFIRM(Text014,FALSE,FIELDCAPTION("Contact No.")) THEN BEGIN
                    "Contact No." := xRec."Contact No.";
                    EXIT;
                  END;

                IF ("Customer No." <> '') AND ("Contact No." <> '') THEN BEGIN
                  Cont.GET("Contact No.");
                  IF ContBusinessRelation.FindByRelation(ContBusinessRelation."Link to Table"::Customer,"Customer No.") THEN
                    IF ContBusinessRelation."Contact No." <> Cont."Company No." THEN
                      ERROR(Text045,Cont."No.",Cont.Name,"Customer No.");
                END;

                UpdateCust("Contact No.");
            end;
        }
        field(5051;"Second Contact No.";Code[20])
        {
            Caption = 'Second Contact No.';
            DataClassification = ToBeClassified;
            TableRelation = Contact;

            trigger OnLookup()
            var
                Cont: Record Contact;
                ContBusinessRelation: Record "Contact Business Relation";
            begin
                IF ("Second Customer No." <> '') AND Cont.GET("Second Contact No.") THEN
                  Cont.SETRANGE("Company No.",Cont."Company No.")
                ELSE
                  IF Cust.GET("Second Customer No.") THEN BEGIN
                    IF ContBusinessRelation.FindByRelation(ContBusinessRelation."Link to Table"::Customer,"Second Customer No.") THEN
                      Cont.SETRANGE("Company No.",ContBusinessRelation."Contact No.");
                  END ELSE
                    Cont.SETFILTER("Company No.",'<>%1','''');

                IF "Second Contact No." <> '' THEN
                  IF Cont.GET("Second Contact No.") THEN ;
                IF PAGE.RUNMODAL(0,Cont) = ACTION::LookupOK THEN BEGIN
                  xRec := Rec;
                  VALIDATE("Second Contact No.",Cont."No.");
                END;
            end;

            trigger OnValidate()
            var
                Cont: Record Contact;
                ContBusinessRelation: Record "Contact Business Relation";
            begin
                IF ("Second Contact No." <> xRec."Second Contact No.") AND
                   (xRec."Second Contact No." <> '')
                THEN
                  IF NOT CONFIRM(Text014,FALSE,FIELDCAPTION("Second Contact No.")) THEN BEGIN
                    "Second Contact No." := xRec."Second Contact No.";
                    EXIT;
                  END;

                IF ("Second Customer No." <> '') AND ("Second Contact No." <> '') THEN BEGIN
                  Cont.GET("Second Contact No.");
                  IF ContBusinessRelation.FindByRelation(ContBusinessRelation."Link to Table"::Customer,"Second Customer No.") THEN
                    IF ContBusinessRelation."Contact No." <> Cont."Company No." THEN
                      ERROR(Text045,Cont."No.",Cont.Name,"Second Customer No.");
                END;

                UpdateBillToCust("Second Contact No.");
            end;
        }
        field(5052;"Second Contact";Text[50])
        {
            Caption = 'Second Contact';
            DataClassification = ToBeClassified;
        }
        field(5053;"Last Invoice Period End";Date)
        {
            Caption = 'Last Invoice Period End';
            DataClassification = ToBeClassified;
        }
        field(5060;"Contacts Related";Boolean)
        {
            CalcFormula = Exist("REF Related Contactos" WHERE ("Entity Type"=CONST(Contract),
                                                               "Source No."=FIELD("Contract No.")));
            Caption = 'Contactos relacionados';
            Editable = false;
            FieldClass = FlowField;
        }
        field(5936;"Notify Customer";Option)
        {
            Caption = 'Notify Customer';
            DataClassification = ToBeClassified;
            OptionCaption = ',By Phone 1,By Phone 2,By Fax,By Email';
            OptionMembers = ,"By Phone 1","By Phone 2","By Fax","By Email";
        }
        field(5937;"Notify Customer 2";Option)
        {
            Caption = 'Notify Customer';
            DataClassification = ToBeClassified;
            OptionCaption = ',By Phone 1,By Phone 2,By Fax,By Email';
            OptionMembers = ,"By Phone 1","By Phone 2","By Fax","By Email";
        }
        field(8000;Id;Guid)
        {
            Caption = 'Id';
            DataClassification = ToBeClassified;
        }
        field(10000;"Amount Rental Deposit";Decimal)
        {
            CalcFormula = Sum("Rental Deposit".Amount WHERE ("Contract No."=FIELD("Contract No.")));
            Caption = 'Amount Rental Deposit';
            Editable = false;
            FieldClass = FlowField;
        }
        field(10001; "Consumer Price Index Category"; Code[10])
        {
            Caption = 'IPC Categoría';
            DataClassification = ToBeClassified;
            TableRelation = "Consumer Price Index Categorie"."Con. Price Index Category Code";
        }
        field(10002;"Generic Prod. Posting Gr."; Code[20])
        {
            Caption = 'Generic Prod. Posting Group';
            DataClassification = ToBeClassified;
            TableRelation = "Gen. Product Posting Group";
        }

        field(10003;"Customer Template Code"; Code[20])
        {
            Caption = 'Customer Template Code';
            DataClassification = ToBeClassified;
            TableRelation = "Customer Templ.";
        }
        field(96300;"Street Type Id.";Code[10])
        {
            Caption = 'Código tipo de calle';
            DataClassification = ToBeClassified;
            TableRelation = "Street Type"."Id.";

            trigger OnValidate()
            begin
                ComposeAddress
            end;
        }
        field(96301;"Types Street Numbering Id.";Code[10])
        {
            Caption = 'Código tipo numeración calle';
            DataClassification = ToBeClassified;
            TableRelation = "Types Street Numbering"."Id.";

            trigger OnValidate()
            begin
                Compose
            end;
        }
        field(96302;"Street Name";Text[30])
        {
            Caption = 'Nombre de la calle';
            DataClassification = ToBeClassified;

            trigger OnValidate()
            begin
                Compose
            end;
        }
        field(96303;"Number On Street";Text[5])
        {
            Caption = 'Número en la calle';
            DataClassification = ToBeClassified;

            trigger OnValidate()
            begin
                Compose
            end;
        }
        field(96304;"Location Height Floor";Text[10])
        {
            Caption = 'Altura del piso';
            DataClassification = ToBeClassified;

            trigger OnValidate()
            begin
                Compose
            end;
        }
        field(96305;"FRE Address";Text[50])
        {
            Caption = 'Dirección activo inmobiliario';
            DataClassification = ToBeClassified;

            trigger OnLookup()
            begin
                ComposeAddress;
            end;
        }
        field(96306;"FRE City";Text[30])
        {
            Caption = 'City';
            DataClassification = ToBeClassified;
            TableRelation = IF ("Country/Region Code"=CONST()) "Post Code".City
                            ELSE IF ("Country/Region Code"=FILTER(<>'')) "Post Code".City WHERE ("Country/Region Code"=FIELD("Country/Region Code"));
            //This property is currently not supported
            //TestTableRelation = false;
            ValidateTableRelation = false;

            trigger OnValidate()
            begin
                PostCode.ValidateCity(City,"Post Code",County,"Country/Region Code",(CurrFieldNo <> 0) AND GUIALLOWED);
            end;
        }
        field(96307;"FRE Phone No.";Text[30])
        {
            Caption = 'Phone No.';
            DataClassification = ToBeClassified;
            ExtendedDatatype = PhoneNo;

            trigger OnValidate()
            var
            begin
            end;
        }
        field(96309;"FRE Territory Code";Code[10])
        {
            Caption = 'Territory Code';
            DataClassification = ToBeClassified;
            TableRelation = Territory;
        }
        field(96310;"FRE Country/Region Code";Code[10])
        {
            Caption = 'Country/Region Code';
            DataClassification = ToBeClassified;
            TableRelation = "Country/Region";

            trigger OnValidate()
            begin
                PostCode.ValidateCountryCode("FRE City","FRE Post Code","FRE County","FRE Country/Region Code");
            end;
        }
        field(96311;"FRE Post Code";Code[20])
        {
            Caption = 'Post Code';
            DataClassification = ToBeClassified;
            TableRelation = IF ("Country/Region Code"=CONST()) "Post Code"
                            ELSE IF ("Country/Region Code"=FILTER(<>'')) "Post Code" WHERE ("Country/Region Code"=FIELD("Country/Region Code"));
            //This property is currently not supported
            //TestTableRelation = false;
            ValidateTableRelation = false;

            trigger OnValidate()
            begin
                PostCode.ValidatePostCode("FRE City","FRE Post Code","FRE County","FRE Country/Region Code",(CurrFieldNo <> 0) AND GUIALLOWED);
            end;
        }
        field(96312;"FRE County";Text[30])
        {
            CaptionClass = '5,1,' + "Country/Region Code";
            Caption = 'County';
            DataClassification = ToBeClassified;
        }
        field(96314;"FRE Property No.";Code[20])
        {
            Caption = 'Company No.';
            DataClassification = ToBeClassified;
            TableRelation = "Fixed Real Estate" WHERE (Type=CONST(Propiedad));

            trigger OnValidate()
            var
                Opp: Record Opportunity;
                OppEntry: Record "Opportunity Entry";
                Task: Record "To-do";
                InteractLogEntry: Record "Interaction Log Entry";
                SegLine: Record "Segment Line";
                SalesHeader: Record "Sales Header";
                Cont: Record "Contact";
                ContBusRel: Record "Contact Business Relation";
                refa: Record "Fixed Real Estate";
            begin
            end;
        }
        field(96500;"Google URL";Text[250])
        {
            DataClassification = ToBeClassified;
            ExtendedDatatype = URL;
        }
        
        field(99500; "Grupo IRPF"; Code[20])
        {
            Editable = true;
            TableRelation = "OneData Grupos IRPF".Codigo;
            Caption = 'Grupo IRPF';
            
            trigger OnValidate();
            var
                IRPFManagement : Codeunit "IRPF Management";
            begin
                if rec."Grupo IRPF" <> xrec."Grupo IRPF" then begin
                    RecalculateIRPFLeaseContract(rec);
                end;
            end;
        }
    }

    keys
    {
        key(Key1;"Contract No.")
        {
            Clustered = true;
        }
    }
    fieldgroups
    {
        fieldgroup(DropDown; "Contract No.", "Description Fixed Real Estate",Name, Status)
        {
        }
    }
    trigger OnDelete()
    begin
        TESTFIELD(Status,Status::" ");
    end;

    trigger OnInsert()
    var
        NoSeriesCode: Code[20];
    begin
        IF "Contract No." = '' THEN BEGIN
            REFASetup.GET;
            REFASetup.TESTFIELD("Lease Contract Nos.");
            // NoSeriesMgt.InitSeries(REFASetup."Lease Contract Nos.",xRec."No. Series",0D,"Contract No.","No. Series");
            NoSeriesCode := REFASetup."Lease Contract Nos.";
            "Contract No." := NoSeriesMgt.GetNextNo(NoSeriesCode, WorkDate(), true);
        END;
    end;

    var
        Salesperson: Record "Salesperson/Purchaser";
        REFASetup: Record "REF Setup";
        FixedRealEstate: Record "Fixed Real Estate";
        Cust: Record Customer;
        REFRelatedContactos: Record "REF Related Contactos";
        InsREFRelatedContactos: Record "REF Related Contactos";
        StreetType: Record "Street Type";
        TypesStreetNumbering: Record "Types Street Numbering";
        PostCode: Record "Post Code";
        ComposseAddress: Text[50];
        NoSeriesMgt: Codeunit "No. Series";
        DimMgt: Codeunit "DimensionManagement";
        ServOrderMgt: Codeunit "ServOrderManagement";
        Confirmed: Boolean;
        SkipContact: Boolean;
        SkipBillToContact: Boolean;
        ContactNo: Code[20];
        Text014: Label 'Do you want to change %1?';
        Text045: Label 'Contact %1 %2 is related to a different company than customer %3.';
        Text044: Label 'Contact %1 %2 is not related to customer %3.';
        Text048: Label 'There are unposted invoices linked to this contract.\\Do you want to cancel the contract?';
        Text051: Label 'Contact %1 %2 is not related to a customer.';
        PhoneNoCannotContainLettersErr: Label 'You cannot enter letters in this field.';

    local procedure SetSalespersonCode(SalesPersonCodeToCheck: Code[20];var SalesPersonCodeToAssign: Code[20])
    begin
        IF SalesPersonCodeToCheck <> '' THEN
          IF Salesperson.GET(SalesPersonCodeToCheck) THEN
            IF Salesperson.VerifySalesPersonPurchaserPrivacyBlocked(Salesperson) THEN
              SalesPersonCodeToAssign := ''
            ELSE
              SalesPersonCodeToAssign := SalesPersonCodeToCheck;
    end;

    procedure ValidateSalesPersonOnServiceContractHeader(LeaseContract2: Record "Lease Contract";IsTransaction: Boolean;IsPostAction: Boolean)
    begin
        IF LeaseContract2."Salesperson Code" <> '' THEN
          IF Salesperson.GET(LeaseContract2."Salesperson Code") THEN
            IF Salesperson.VerifySalesPersonPurchaserPrivacyBlocked(Salesperson) THEN BEGIN
              IF IsTransaction THEN
                ERROR(Salesperson.GetPrivacyBlockedTransactionText(Salesperson,IsPostAction,TRUE));
              IF NOT IsTransaction THEN
                ERROR(Salesperson.GetPrivacyBlockedGenericText(Salesperson,TRUE));
            END;
    end;

    procedure UpdateCont(CustomerNo: Code[20])
    var
        ContBusRel: Record "Contact Business Relation";
        Cont: Record Contact;
        Cust: Record Customer;
    begin
        IF Cust.GET(CustomerNo) THEN BEGIN
          CLEAR(ServOrderMgt);
          ContactNo := ServOrderMgt.FindContactInformation(Cust."No.");
          IF Cont.GET(ContactNo) THEN BEGIN
            "Contact No." := Cont."No.";
            "Contact Name" := Cont.Name;
            "Phone No." := Cont."Phone No.";
            "E-Mail" := Cont."E-Mail";
          END ELSE BEGIN
            IF Cust."Primary Contact No." <> '' THEN
              "Contact No." := Cust."Primary Contact No."
            ELSE
              IF ContBusRel.FindByRelation(ContBusRel."Link to Table"::Customer,"Customer No.") THEN
                "Contact No." := ContBusRel."Contact No.";
            "Contact Name" := Cust.Contact;
          END;
        END;
    end;

    local procedure UpdateBillToCont(CustomerNo: Code[20])
    var
        ContBusRel: Record "Contact Business Relation";
        Cont: Record Contact;
        Cust: Record Customer;
    begin
        IF Cust.GET(CustomerNo) THEN BEGIN
          CLEAR(ServOrderMgt);
          ContactNo := ServOrderMgt.FindContactInformation("Second Customer No.");
          IF Cont.GET(ContactNo) THEN BEGIN
            "Second Contact No." := Cont."No.";
            "Second Contact" := Cont.Name;
          END ELSE BEGIN
            IF Cust."Primary Contact No." <> '' THEN
              "Second Contact No." := Cust."Primary Contact No."
            ELSE
              IF ContBusRel.FindByRelation(ContBusRel."Link to Table"::Customer,"Second Customer No.") THEN
                "Second Contact No." := ContBusRel."Contact No.";
            "Second Contact" := Cust.Contact;
          END;
        END;
    end;

    procedure UpdateCust(ContactNo: Code[20])
    var
        ContBusinessRelation: Record "Contact Business Relation";
        Cust: Record Customer;
        Cont: Record Contact;
    begin
        IF Cont.GET(ContactNo) THEN BEGIN
          "Contact No." := Cont."No.";
          "Phone No." := Cont."Phone No.";
          "E-Mail" := Cont."E-Mail";
          IF Cont.Type = Cont.Type::Person THEN
            "Contact Name" := Cont.Name
          ELSE
            IF Cust.GET("Customer No.") THEN
              "Contact Name" := Cust.Contact
            ELSE
              "Contact Name" := ''
        END ELSE BEGIN
          "Contact Name" := '';
          "Phone No." := '';
          "E-Mail" := '';
          EXIT;
        END;

        IF ContBusinessRelation.FindByContact(ContBusinessRelation."Link to Table"::Customer,Cont."Company No.") THEN BEGIN
          IF ("Customer No." <> '') AND
             ("Customer No." <> ContBusinessRelation."No.")
          THEN
            ERROR(Text044,Cont."No.",Cont.Name,"Customer No.");
          IF "Customer No." = '' THEN BEGIN
            SkipContact := TRUE;
            VALIDATE("Customer No.",ContBusinessRelation."No.");
            SkipContact := FALSE;
          END;
        END ELSE
          ERROR(Text051,Cont."No.",Cont.Name);
    end;

    local procedure UpdateBillToCust(ContactNo: Code[20])
    var
        ContBusinessRelation: Record "Contact Business Relation";
        Cust: Record Customer;
        Cont: Record Contact;
    begin
        IF Cont.GET(ContactNo) THEN BEGIN
          "Second Contact No." := Cont."No.";
          IF Cont.Type = Cont.Type::Person THEN
            "Second Contact" := Cont.Name
          ELSE
            IF Cust.GET("Second Customer No.") THEN
              "Second Contact" := Cust.Contact
            ELSE
              "Second Contact" := '';
        END ELSE BEGIN
          "Second Contact" := '';
          EXIT;
        END;
    end;

    local procedure ComposeAddress()
    var
        AuxLeaseContract: Record "Lease Contract";
        AuxAddress: Text[250];
    begin
        AuxLeaseContract := Rec;
        IF PAGE.RUNMODAL(PAGE::"Compose address Contract Lease",Rec) = ACTION::LookupOK THEN BEGIN


        END;
    end;

    procedure Compose()
    begin
        IF NOT StreetType.GET("Street Type Id.") THEN StreetType.INIT;
        IF NOT TypesStreetNumbering.GET("Types Street Numbering Id.") THEN TypesStreetNumbering.INIT;
        ComposseAddress := '';
        IF StreetType.Description <>'' THEN
          ComposseAddress := StreetType.Description;
        IF "Street Name" <> '' THEN
          ComposseAddress := ComposseAddress + ' ' +"Street Name";
        IF "Number On Street" <> '' THEN
          ComposseAddress := ComposseAddress + ' ' + "Number On Street";
        
        IF "Location Height Floor" <> '' THEN
          ComposseAddress := ComposseAddress + ', ' + "Location Height Floor";
        
        "FRE Address" := ComposseAddress;

    end;

    procedure DisplayMap()
    var
        MapPoint: Record "Online Map Setup";
        MapMgt: Codeunit "Online Map Management";
    begin
        IF MapPoint.FINDFIRST THEN
          MapMgt.MakeSelection(DATABASE::"Fixed Real Estate",GETPOSITION)
        ELSE
          MESSAGE(Text014);
    end;




    procedure SetBailDescription(NewWorkDescription: Text)
    var
        OutStream: OutStream;
    begin
        Clear("Important Comments");
        "Important Comments".CreateOutStream(OutStream, TEXTENCODING::UTF8);
        OutStream.WriteText(NewWorkDescription);
        Modify();
    end;

    procedure GetBailDescription(): Text
    var
        TypeHelper: Codeunit "Type Helper";
        InStream: InStream;

    begin
         CALCFIELDS("Important Comments");
        "Important Comments".CreateInStream(InStream, TEXTENCODING::UTF8);
        exit(TypeHelper.TryReadAsTextWithSepAndFieldErrMsg(InStream, TypeHelper.LFSeparator(), FieldName("Important Comments")));
     end;

    procedure GetFREDescription() WorkDescription: Text
    var
        TypeHelper: Codeunit "Type Helper";
        InStream: InStream;
    begin
        CalcFields("Important Comments");
        "Important Comments".CreateInStream(InStream, TEXTENCODING::UTF8);
        exit(TypeHelper.TryReadAsTextWithSepAndFieldErrMsg(InStream, TypeHelper.LFSeparator(), FieldName("Important Comments")));
    end;

    procedure ShowInteractionLogEntries()
    var
        InteractionLogEntry: Record "Interaction Log Entry";
    begin
        IF "Contact No." <> '' THEN
          InteractionLogEntry.SETRANGE("Contact No.","Contact No.");

        // InteractionLogEntry.SETRANGE("Document Type",InteractionLogEntry."Document Type"::"Lease Contract");
        InteractionLogEntry.SETRANGE("Document No.","Contract No.");
        PAGE.RUN(PAGE::"Interaction Log Entries",InteractionLogEntry);
    end;

    procedure RecalculateIRPFLeaseContract(var LeaseContract : Record "Lease Contract")
    var 
    RealEstateManagement : Codeunit "Real Estate Management";
    LeaseContractLine : Record "Lease Contract Line";
    begin
        LeaseContractLine.reset;
        LeaseContractLine.SetRange("Contract No.","Contract No.");
        if LeaseContractLine.FindFirst() then repeat
            RealEstateManagement.RecalculateIRPFLeaseLine(LeaseContract, LeaseContractLine);
            LeaseContractLine.Modify();
        until LeaseContractLine.next = 0;
    end;
}

