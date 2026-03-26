// ------------------------------------------------------------------------------------------------
// Copyright (c) Tomàs Forné Martínez. All rights reserved.
// ------------------------------------------------------------------------------------------------

namespace OneData.Property.Asset;

using Microsoft.FixedAssets.Setup;
using Microsoft.Finance.Dimension;
using Microsoft.Purchases.Vendor;
using Microsoft.FixedAssets.Insurance;
using Microsoft.Foundation.Comment;
using Microsoft.Foundation.NoSeries;
using Microsoft.HumanResources.Employee;
using Microsoft.Inventory.Location;
using Microsoft.Purchases.Document;
using Microsoft.Sales.Document;
using System.Environment.Configuration;
using System.Telemetry;
using Microsoft.eServices.OnlineMap;
using Microsoft.Foundation.Address;
using Microsoft.Inventory.Intrastat;
using System.Reflection;
using OneData.Property.Setup;
using OneData.Property.Lease;
using Microsoft.CRM.Contact;
using Microsoft.CRM.Team;

table 96000 "Fixed Real Estate"
{
    Caption = 'Fixed Real Estate';
    DataCaptionFields = "No.", Description;
    DrillDownPageID = 96061;
    LookupPageID = 96061;
    DataPerCompany = false;

    fields
    {
        field(1; "No."; Code[20])
        {
            Caption = 'No.';

            trigger OnValidate()
            begin
                IF "No." <> xRec."No." THEN BEGIN
                    REFASetup.GET;
                    NoSeriesMgt.TestManual(REFASetup."Fixed Asset Nos.");
                    "No. Series" := '';
                END;
            end;
        }
        field(2; Description; Text[50])
        {
            Caption = 'Description';

            trigger OnValidate()
            begin
                IF ("Search Description" = UPPERCASE(xRec.Description)) OR ("Search Description" = '') THEN
                    "Search Description" := Description;
                IF Type = Type::Propiedad THEN BEGIN
                    "Property No." := "No.";
                    VALIDATE("Property Description", Description);
                END;
            end;
        }
        field(3; "Search Description"; Code[50])
        {
            Caption = 'Search Description';
        }
        field(4; "Description 2"; Text[50])
        {
            Caption = 'Description 2';
        }
        field(5; "FRE Class Code"; Code[10])
        {
            Caption = 'FA Class Code';
            TableRelation = "FA Class";

            trigger OnValidate()
            var
                FASubclass: Record "FA Subclass";
            begin
                IF "FRE Subclass Code" = '' THEN
                    EXIT;

                FASubclass.GET("FRE Subclass Code");
                IF NOT (FASubclass."FA Class Code" IN ['', "FRE Class Code"]) THEN
                    "FRE Subclass Code" := '';
            end;
        }
        field(6; "FRE Subclass Code"; Code[10])
        {
            Caption = 'FA Subclass Code';
            TableRelation = "FA Subclass";

            trigger OnValidate()
            var
                FASubclass: Record "FA Subclass";
            begin
                IF "FRE Subclass Code" = '' THEN
                    EXIT;

                FASubclass.GET("FRE Subclass Code");
                IF "FRE Class Code" <> '' THEN BEGIN
                    IF FASubclass."FA Class Code" IN ['', "FRE Class Code"] THEN
                        EXIT;

                    ERROR(UnexpctedSubclassErr);
                END;

                VALIDATE("FRE Class Code", FASubclass."FA Class Code");
            end;
        }
        field(7; "Global Dimension 1 Code"; Code[20])
        {
            CaptionClass = '1,1,1';
            Caption = 'Global Dimension 1 Code';
            TableRelation = "Dimension Value".Code WHERE("Global Dimension No." = CONST(1));

            trigger OnValidate()
            begin
                ValidateShortcutDimCode(1, "Global Dimension 1 Code");
            end;
        }
        field(8; "Global Dimension 2 Code"; Code[20])
        {
            CaptionClass = '1,1,2';
            Caption = 'Global Dimension 2 Code';
            TableRelation = "Dimension Value".Code WHERE("Global Dimension No." = CONST(2));

            trigger OnValidate()
            begin
                ValidateShortcutDimCode(2, "Global Dimension 2 Code");
            end;
        }
        field(9; "Asset Type"; Code[10])
        {
            Caption = 'Tipo de activo';
            DataClassification = ToBeClassified;
            TableRelation = "Type Fixed Real Estate";
        }
        field(11; "Vendor No."; Code[20])
        {
            Caption = 'Vendor No.';
            TableRelation = Vendor;
        }
        field(16; "Responsible Employee"; Code[20])
        {
            Caption = 'Responsible Employee';
            TableRelation = Employee;
        }
        field(17; "Cadastral reference"; Text[50])
        {
            Caption = 'Referencia catrastal';
        }
        field(18; "Last Date Modified"; Date)
        {
            Caption = 'Last Date Modified';
            Editable = false;
        }
        field(19; Insured; Boolean)
        {
            CalcFormula = Exist("Ins. Coverage Ledger Entry" WHERE("FA No." = FIELD("No.")));
            Caption = 'Insured';
            Editable = false;
            FieldClass = FlowField;
        }
        field(20; Comment; Boolean)
        {
            CalcFormula = Exist("Real Estate Comment Line" WHERE("No." = FIELD("No.")));
            Caption = 'Comment';
            Editable = false;
            FieldClass = FlowField;
        }
        field(21; Blocked; Boolean)
        {
            Caption = 'Blocked';
        }
        field(22; Picture; BLOB)
        {
            Caption = 'Picture';
            SubType = Bitmap;
        }
        field(23; "Maintenance Vendor No."; Code[20])
        {
            Caption = 'Maintenance Vendor No.';
            TableRelation = Vendor;
        }
        field(24; "Under Maintenance"; Boolean)
        {
            Caption = 'Under Maintenance';
        }
        field(28; "No. Series"; Code[20])
        {
            Caption = 'No. Series';
            Editable = false;
            TableRelation = "No. Series";
        }
        field(30; Acquired; Boolean)
        {
            Caption = 'Adquirido';
        }
        field(31; Managed; Boolean)
        {
            Caption = 'Administrado';
            DataClassification = ToBeClassified;
        }
        field(45; Address; Text[50])
        {
            Caption = 'Address';
            DataClassification = ToBeClassified;

            trigger OnLookup()
            begin
                ComposeAddress;
            end;
        }
        field(46; "Address 2"; Text[50])
        {
            Caption = 'Address 2';
            DataClassification = ToBeClassified;
        }
        field(47; City; Text[30])
        {
            Caption = 'City';
            DataClassification = ToBeClassified;
            TableRelation = IF ("Country/Region Code" = CONST()) "Post Code".City
            ELSE IF ("Country/Region Code" = FILTER(<> '')) "Post Code".City WHERE("Country/Region Code" = FIELD("Country/Region Code"));
            //This property is currently not supported
            //TestTableRelation = false;
            ValidateTableRelation = false;

            trigger OnValidate()
            begin
                PostCode.ValidateCity(City, "Post Code", County, "Country/Region Code", (CurrFieldNo <> 0) AND GUIALLOWED);
            end;
        }
        field(49; "Phone No."; Text[30])
        {
            Caption = 'Phone No.';
            DataClassification = ToBeClassified;
            ExtendedDatatype = PhoneNo;

            trigger OnValidate()
            var
            begin
            end;
        }
        field(50; "Telex No."; Text[20])
        {
            Caption = 'Telex No.';
            DataClassification = ToBeClassified;
        }
        field(51; "Territory Code"; Code[10])
        {
            Caption = 'Territory Code';
            DataClassification = ToBeClassified;
            TableRelation = Territory;
        }
        field(52; "Country/Region Code"; Code[10])
        {
            Caption = 'Country/Region Code';
            DataClassification = ToBeClassified;
            TableRelation = "Country/Region";

            trigger OnValidate()
            begin
                PostCode.ValidateCountryCode(City, "Post Code", County, "Country/Region Code");
            end;
        }
        field(53; "Post Code"; Code[20])
        {
            Caption = 'Post Code';
            DataClassification = ToBeClassified;
            TableRelation = IF ("Country/Region Code" = CONST()) "Post Code"
            ELSE IF ("Country/Region Code" = FILTER(<> '')) "Post Code" WHERE("Country/Region Code" = FIELD("Country/Region Code"));
            //This property is currently not supported
            //TestTableRelation = false;
            ValidateTableRelation = false;

            trigger OnValidate()
            begin
                PostCode.ValidatePostCode(City, "Post Code", County, "Country/Region Code", (CurrFieldNo <> 0) AND GUIALLOWED);
            end;
        }
        field(54; County; Text[30])
        {
            CaptionClass = '5,1,' + "Country/Region Code";
            Caption = 'County';
            DataClassification = ToBeClassified;
        }
        field(60; Status; Option)
        {
            Caption = 'Status';
            DataClassification = ToBeClassified;
            OptionMembers = " ","En alquiler",Alquilado,"En venta",Vendido,"En alquiler o en venta","En alquiler con opción a compra",Bloqueado;
        }
        field(140; Image; Media)
        {
            Caption = 'Image';
        }
        field(200; "Comercial Description"; BLOB)
        {
            Caption = 'Work Description';
            DataClassification = ToBeClassified;
        }
        field(300; "Street Type Id."; Code[10])
        {
            Caption = 'Código tipo de calle';
            DataClassification = ToBeClassified;
            TableRelation = "Street Type"."Id.";
        }
        field(301; "Types Street Numbering Id."; Code[10])
        {
            Caption = 'Código tipo numeración calle';
            DataClassification = ToBeClassified;
            TableRelation = "Types Street Numbering"."Id.";
        }
        field(302; "Street Name"; Text[30])
        {
            Caption = 'Nombre de la calle';
            DataClassification = ToBeClassified;
        }
        field(303; "Number On Street"; Text[5])
        {
            Caption = 'Número en la calle';
            DataClassification = ToBeClassified;
        }
        field(304; "Location Height Floor"; Text[10])
        {
            Caption = 'Altura del piso';
            DataClassification = ToBeClassified;
        }
        field(305; "Composse Address"; Text[50])
        {
            DataClassification = ToBeClassified;
        }
        field(500; "Google URL"; Text[250])
        {
            DataClassification = ToBeClassified;
            ExtendedDatatype = URL;
        }
        field(501; "URL Sede electrónica catastro"; Text[250])
        {
            DataClassification = ToBeClassified;
            ExtendedDatatype = URL;
        }
        field(600; "Avatar Picture"; BLOB)
        {
            Caption = 'Picture';
            DataClassification = ToBeClassified;
            SubType = Bitmap;
        }
        field(5000; Type; Option)
        {
            Caption = 'Tipo';
            DataClassification = ToBeClassified;
            OptionCaption = 'Property,Fixed';
            OptionMembers = Propiedad,Activo;

            trigger OnValidate()
            begin
                IF Type = Type::Activo THEN BEGIN
                    Totaling := "No.";
                END;
            end;
        }
        field(5001; "Year of construction"; Integer)
        {
            Caption = 'Año de construcción';
            DataClassification = ToBeClassified;
        }
        field(5051; "Property No."; Code[20])
        {
            Caption = 'Property No.';
            DataClassification = ToBeClassified;
            TableRelation = "Fixed Real Estate" WHERE(Type = CONST(Propiedad));

            trigger OnValidate()
            begin
                IF REFA.GET("Property No.") THEN
                    InheritPropertyToFREData(REFA)
                ELSE
                    CLEAR("Property Description");

                TESTFIELD(Type, Type::Activo);
            end;
        }
        field(5052; "Property Description"; Text[50])
        {
            Caption = 'Property Description';
            DataClassification = ToBeClassified;
            Editable = false;
            TableRelation = "Fixed Real Estate" WHERE(Type = CONST(Propiedad));
            ValidateTableRelation = false;

            trigger OnValidate()
            begin
                IF Type = Type::Propiedad THEN BEGIN
                    IF "Property No." <> '' THEN BEGIN
                        REFA.RESET;
                        REFA.SETRANGE("Property No.", "Property No.");
                        IF REFA.FINDSET THEN
                            REFA.MODIFYALL("Property Description", "Property Description");
                    END;
                END;
            end;
        }
        field(5053; "Sales price"; Decimal)
        {
            Caption = 'Precio de venta';
            DataClassification = ToBeClassified;
        }
        field(5054; "Minimum Sales Price"; Decimal)
        {
            Caption = 'Precio de venta mínimo';
            DataClassification = ToBeClassified;
        }
        field(5055; "Last Rental Price"; Decimal)
        {
            Caption = 'Last Rental Price';
            DataClassification = ToBeClassified;
        }
        field(5056; "Minimum Rental Price"; Decimal)
        {
            Caption = 'Minimum Rental Price';
            DataClassification = ToBeClassified;
        }
        field(5057; "Superficie construida"; Decimal)
        {
            CalcFormula = Sum("FRE Superficies"."Superficie m2" WHERE("FRE No" = FIELD(FILTER(Totaling))));
            Editable = false;
            FieldClass = FlowField;
        }
        field(5058; "Last Reference Price"; Decimal)
        {
            CalcFormula = Lookup("Reference Index Rental Prices".Price WHERE("Fixed Real Estate No." = FIELD("No."),
                                                                              Active = CONST(true)));
            Editable = false;
            FieldClass = FlowField;
        }
        field(5059; "Last Price Contract"; Decimal)
        {
            CalcFormula = Lookup("Lease Contract"."Amount per Period" WHERE("Fixed Real Estate No." = FIELD("No."),
                                                                             Status = CONST(Signed)));
            Editable = false;
            FieldClass = FlowField;
        }
        field(5155; "Last Rental Price Modified"; Date)
        {
            Caption = 'Last Rental Price Modified';
            DataClassification = ToBeClassified;
            Editable = false;
            ToolTip = 'Specifies when the last rental price was last modified.';
        }
        field(6000; "Income Amount"; Decimal)
        {
            CalcFormula = Sum("REF Income & Expense Lines".Amount WHERE("No. Fixed Real Estate" = FIELD(FILTER(Totaling)),
                                                                         Type = CONST(Income)));
            Caption = 'Cantidad de Ingresos';
            Editable = false;
            FieldClass = FlowField;
        }
        field(6001; "Expense Amount"; Decimal)
        {
            CalcFormula = Sum("REF Income & Expense Lines".Amount WHERE("No. Fixed Real Estate" = FIELD(FILTER(Totaling)),
                                                                         Type = CONST(Expense)));
            Caption = 'Cantidad de gastos';
            Editable = false;
            FieldClass = FlowField;
        }
        field(6002; Totaling; Text[250])
        {
            Caption = 'Totaling';
            DataClassification = ToBeClassified;
            Editable = false;
        }
        field(7000; "Val. Catastral Activo"; Decimal)
        {
            DataClassification = ToBeClassified;
        }
        field(7001; "Val. Castastral Const. Activo"; Decimal)
        {
            DataClassification = ToBeClassified;
        }
        field(7002; "Val. Castastral Actua. Activo"; Boolean)
        {
            DataClassification = ToBeClassified;
        }
        field(7010; "Val. Catastral Finca"; Decimal)
        {
            DataClassification = ToBeClassified;
        }
        field(7011; "Val. Castastral Const. Finca"; Decimal)
        {
            DataClassification = ToBeClassified;
        }
        field(7012; "Val. Castastral Actua. Finca"; Boolean)
        {
            DataClassification = ToBeClassified;
        }
        field(7020; "Total Val. Catastral Activo"; Decimal)
        {
            DataClassification = ToBeClassified;
        }
        field(7021; "Total Val. Castas. Const. Act."; Decimal)
        {
            DataClassification = ToBeClassified;
        }
        field(7022; "Total Val. Castas. Act. Act."; Boolean)
        {
            DataClassification = ToBeClassified;
        }
        field(8000; "Owner Name"; Text[100])
        {
            CalcFormula = Lookup("REF Related Contactos".Name WHERE("Source No." = FIELD("No."),
                                                                     Type = CONST(Owner)));
            Caption = 'Nombre propietario';
            Editable = false;
            FieldClass = FlowField;
        }
        field(10000; "Codeunit Id."; Integer)
        {
            DataClassification = ToBeClassified;
        }
        field(10001; "XmlPort Id."; Integer)
        {
            DataClassification = ToBeClassified;
        }
        field(10002; "Web Site Id."; Code[10])
        {
            DataClassification = ToBeClassified;
        }
    }

    keys
    {
        key(Key1; "No.")
        {
            Clustered = true;
        }
        key(Key2; "Search Description")
        {
        }
        key(Key3; "Property Description", "Property No.", Type, Description)
        {
        }
        key(Key4; "FRE Class Code")
        {
        }
        key(Key5; "FRE Subclass Code")
        {
        }
        key(Key6; "Global Dimension 1 Code")
        {
        }
        key(Key7; "Global Dimension 2 Code")
        {
        }
        key(Key8; Description)
        {
        }
    }

    fieldgroups
    {
        fieldgroup(DropDown; Description, Type,"No.", Status)
        {
        }
        fieldgroup(Brick; "No.", Description, City, Image)
        {
        }
    }

    trigger OnDelete()
    begin
        LOCKTABLE;

        RECommentLine.SETRANGE("Table Name", RECommentLine."Table Name"::"Fixed Real Estate");
        RECommentLine.SETRANGE("No.", "No.");
        if RECommentLine.FindFirst() THEN
            RECommentLine.DELETEALL;

        DimMgt.DeleteDefaultDim(DATABASE::"Fixed Real Estate", "No.");

    end;

    trigger OnInsert()
    var
        NoSeriesCode: Code[20];
    begin
        IF "No." = '' THEN BEGIN
            REFASetup.GET;
            REFASetup.TESTFIELD("Fixed Asset Nos.");
            NoSeriesCode := REFASetup."Fixed Asset Nos.";
            "No." := NoSeriesMgt.GetNextNo(NoSeriesCode, WorkDate(), true);
        END;
    end;

    trigger OnModify()
    begin

        "Last Date Modified" := TODAY;
        CalculateAmounts();
    end;

    trigger OnRename()
    var
        SalesLine: Record "Sales Line";
        PurchaseLine: Record "Purchase Line";
    begin
        "Last Date Modified" := TODAY;
    end;

    var
        Text000: Label 'A main asset cannot be deleted.';
        Text001: Label 'You cannot delete %1 %2 because it has associated depreciation books.';
        RECommentLine: Record "Real Estate Comment Line";
        REFA: Record "Fixed Real Estate";
        REFASetup: Record "REF Setup";
        PostCode: Record "Post Code";
        InsCoverageLedgEntry: Record "Ins. Coverage Ledger Entry";
        NoSeriesMgt: Codeunit "No. Series";
        DimMgt: Codeunit "DimensionManagement";
        text002: Label 'Calculo de Totaling sobrepasa los 250. Puede dar incongruencias de calculo de ingresos y gastos';
        Text014: Label 'Before you can use Online Map, you must fill in the Online Map Setup window.\See Setting Up Online Map in Help.';
        UnexpctedSubclassErr: Label 'This real estate asset subclass belongs to a different real estate asset class.';
        DontAskAgainActionTxt: Label 'Don''t ask again';
        NotificationNameTxt: Label 'real estate asset Acquisition Wizard', Locked = true;
        NotificationDescriptionTxt: Label 'Notify when ready to acquire the real estate asset.', Locked = true;
        ReadyToAcquireMsg: Label 'You are ready to acquire the real estate asset.';
        AcquireActionTxt: Label 'Acquire';
        PhoneNoCannotContainLettersErr: Label 'You cannot enter letters in this field.';
        Text004: Label 'untitled';

    procedure Caption(): Text
    begin
        if "No." = '' then
            exit(Text004);
        exit(
          StrSubstNo(
            '%1 %2 %3', "No.", Description, City));
    end;

    procedure ValidateShortcutDimCode(FieldNumber: Integer; var ShortcutDimCode: Code[20])
    begin
        DimMgt.ValidateDimValueCode(FieldNumber, ShortcutDimCode);
        DimMgt.SaveDefaultDim(DATABASE::"Fixed Real Estate", "No.", FieldNumber, ShortcutDimCode);
        MODIFY(TRUE);
    end;

    procedure FieldsForAcquitionInGeneralGroupAreCompleted(): Boolean
    begin
        EXIT(("No." <> '') AND (Description <> '') AND ("FRE Subclass Code" <> ''));
    end;

    
    procedure GetNotificationID(): Guid
    begin
    end;

    procedure SetNotificationDefaultState()
    var
        MyNotifications: Record "My Notifications";
    begin
        MyNotifications.InsertDefault(GetNotificationID, NotificationNameTxt, NotificationDescriptionTxt, TRUE);
    end;

    local procedure IsNotificationEnabledForCurrentUser(): Boolean
    var
        MyNotifications: Record "My Notifications";
    begin
        EXIT(MyNotifications.IsEnabled(GetNotificationID));
    end;

    procedure DontNotifyCurrentUserAgain()
    var
        MyNotifications: Record "My Notifications";
    begin
        IF NOT MyNotifications.Disable(GetNotificationID) THEN
            MyNotifications.InsertDefault(GetNotificationID, NotificationNameTxt, NotificationDescriptionTxt, FALSE);
    end;

    procedure RecallNotificationForCurrentUser()
    var
        NotificationLifecycleMgt: Codeunit "Notification Lifecycle Mgt.";
    begin
        NotificationLifecycleMgt.RecallNotificationsForRecord(RECORDID, FALSE);
    end;

    procedure SetFREDescription(NewWorkDescription: Text)
    var
        OutStream: OutStream;
    begin
        Clear("Comercial Description");
        "Comercial Description".CreateOutStream(OutStream, TEXTENCODING::UTF8);
        OutStream.WriteText(NewWorkDescription);
        Modify();
    end;

    procedure GetFREDescription() WorkDescription: Text
    var
        TypeHelper: Codeunit "Type Helper";
        InStream: InStream;
    begin
        CalcFields("Comercial Description");
        "Comercial Description".CreateInStream(InStream, TEXTENCODING::UTF8);
        exit(TypeHelper.TryReadAsTextWithSepAndFieldErrMsg(InStream, TypeHelper.LFSeparator(), FieldName("Comercial Description")));
    end;


    procedure DisplayMap()
    var
        MapPoint: Record "Online Map Setup";
        MapMgt: Codeunit "Online Map Management";
    begin
        IF MapPoint.FINDFIRST THEN
            MapMgt.MakeSelection(DATABASE::"Fixed Real Estate", GETPOSITION)
        ELSE
            MESSAGE(Text014);
    end;

    procedure InheritPropertyToFREData(NewProperty: Record "Fixed Real Estate")
    begin

        "Property Description" := NewProperty.Description;
        "Territory Code" := NewProperty."Territory Code";
        "Country/Region Code" := NewProperty."Country/Region Code";
        Address := NewProperty.Address;
        "Address 2" := NewProperty."Address 2";
        "Post Code" := NewProperty."Post Code";
        City := NewProperty.City;
        County := NewProperty.County;
    end;

    procedure GetFRENo(FREText: Text): Code[20]
    begin
        IF FREText = '' THEN
            EXIT('');

        REFA.SETCURRENTKEY(Description);
        REFA.SETRANGE(Description, FREText);
        IF REFA.FINDFIRST THEN
            EXIT(REFA."No.");


        EXIT('');
    end;

    procedure CalculateTotaling()
    var
        FixedRealEstate: Record "Fixed Real Estate";
        PropertyRealEstate: Record "Fixed Real Estate";
        Filtro: Text;
        l: Integer;
    begin
        Filtro := '';
        FixedRealEstate.RESET;
        FixedRealEstate.SETRANGE(Type, Type::Activo);
        FixedRealEstate.SETRANGE("Property No.", "No.");
        IF FixedRealEstate.FINDFIRST THEN BEGIN
            REPEAT
                IF Filtro = '' THEN
                    Filtro := FixedRealEstate."No."
                ELSE
                    Filtro := Filtro + '|' + FixedRealEstate."No.";
            UNTIL FixedRealEstate.NEXT = 0;
        END;

        l := STRLEN(Filtro);
        IF l > 250 THEN
            MESSAGE(text002);
        IF l > 0 THEN BEGIN
            IF COPYSTR(Filtro, l, 1) = '|' THEN
                Filtro := COPYSTR(Filtro, 1, l - 1);
        END ELSE
            Filtro := "No.";
        Totaling := COPYSTR(Filtro, 1, 250);
    end;

    procedure CalculateAmounts()
    var
        FixedRealEstate: Record "Fixed Real Estate";
        TotalSalesAmount: Decimal;
        TotalSalesAmountMinimum: Decimal;
        TotalExpenseAmount: Decimal;
        TotalIncomingAmount: Decimal;
        TotalRentalAmount: Decimal;
        TotalValCatastralActivo: Decimal;
        TotalValCastastralConstActivo: Decimal;

    begin
        if rec.Type <> Type::Propiedad then
            EXIT;

        TotalSalesAmount := 0;
        TotalSalesAmountMinimum := 0;
        TotalExpenseAmount := 0;
        TotalIncomingAmount := 0;
        TotalRentalAmount := 0;

        FixedRealEstate.Reset();
        FixedRealEstate.SETRANGE(Type, Type::Activo);
        FixedRealEstate.SETRANGE("Property No.", "No.");
        if FixedRealEstate.FINDFIRST then begin
            REPEAT
                FixedRealEstate.CALCFIELDS("Income Amount");
                FixedRealEstate.CALCFIELDS("Expense Amount");
                TotalSalesAmount += FixedRealEstate."Sales price";
                TotalSalesAmountMinimum += FixedRealEstate."Minimum Sales Price";
                TotalExpenseAmount += FixedRealEstate."Expense Amount";
                TotalIncomingAmount += FixedRealEstate."Income Amount";
                TotalRentalAmount += FixedRealEstate."Last Rental Price";
                TotalValCatastralActivo += FixedRealEstate."Val. Catastral Activo";
                TotalValCastastralConstActivo += FixedRealEstate."Val. Castastral Const. Activo";

            UNTIL FixedRealEstate.NEXT = 0;
        END;
        rec."Sales price" := TotalSalesAmount;
        rec."Minimum Sales Price" := TotalSalesAmountMinimum;
        //rec."Expense Amount" := TotalExpenseAmount;
        //rec."Income Amount" := TotalIncomingAmount;
        rec."Last Rental Price" := TotalRentalAmount;
        rec."Val. Catastral Activo" := TotalValCatastralActivo;
        rec."Val. Castastral Const. Activo" := TotalValCastastralConstActivo;
        rec.MODIFY();
    end;

    procedure PublicToWebSite()
    var
        FixedRealEstate: Record "Fixed Real Estate";
        PublishedFixedRealEstate: Record "Published Fixed Real Estate";
        PublishWebSiteManagement: Codeunit "Publish Web Site Management";
    begin
        PublishedFixedRealEstate.Publish(Rec);
    end;

    local procedure ComposeAddress()
    var
        AuxFixedRealEstate: Record "Fixed Real Estate";
        AuxAddress: Text[250];
    begin
        AuxFixedRealEstate := Rec;
        IF PAGE.RUNMODAL(PAGE::"Compose address", Rec) = ACTION::LookupOK THEN BEGIN
            Address := "Composse Address";
        END;
    end;

    procedure IsPublicToWeb(REFNo: Code[20]; WebSiteId: Code[20]): Boolean
    var
        FixedRealEstate: Record "Fixed Real Estate";
        PublishedFixedRealEstate: Record "Published Fixed Real Estate";
        PublishWebSiteManagement: Codeunit "Publish Web Site Management";
    begin
        PublishedFixedRealEstate.RESET;
        PublishedFixedRealEstate.SETRANGE("Web Site Code", WebSiteId);
        PublishedFixedRealEstate.SETRANGE("Fixed Real Estate No.", REFNo);
        EXIT(PublishedFixedRealEstate.FINDFIRST);
    end;
}

