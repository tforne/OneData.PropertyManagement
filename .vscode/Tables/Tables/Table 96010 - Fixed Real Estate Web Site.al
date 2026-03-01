table 96010 "Fixed Real Estate Web Site"
{
    DrillDownPageID = 96022;
    LookupPageID = 96022;

    fields
    {
        field(1; "Code"; Code[10])
        {
            Caption = 'Código';
            DataClassification = ToBeClassified;
        }
        field(2; Description; Text[30])
        {
            Caption = 'Descripción';
            DataClassification = ToBeClassified;
        }
        field(4; "Processing Codeunit ID"; Integer)
        {
            Caption = 'Processing Codeunit ID';
            DataClassification = ToBeClassified;
            TableRelation = AllObjWithCaption."Object ID" WHERE ("Object Type"=CONST(Codeunit));
        }
        field(5; "Processing Codeunit Name"; Text[249])
        {
            CalcFormula = Lookup (AllObjWithCaption."Object Caption" WHERE ("Object Type"=CONST(Codeunit),
                                                                           "Object ID"=FIELD("Processing Codeunit ID")));
            Caption = 'Processing Codeunit Name';
            Editable = false;
            FieldClass = FlowField;
        }
        field(6;"Processing XMLport ID";Integer)
        {
            Caption = 'Processing XMLport ID';
            DataClassification = ToBeClassified;
            TableRelation = AllObjWithCaption."Object ID" WHERE ("Object Type"=CONST(XMLport));
        }
        field(7;"Processing XMLport Name";Text[249])
        {
            CalcFormula = Lookup(AllObjWithCaption."Object Caption" WHERE ("Object Type"=CONST(XMLport),
                                                                           "Object ID"=FIELD("Processing XMLport ID")));
            Caption = 'Processing XMLport Name';
            Editable = false;
            FieldClass = FlowField;
        }
        field(10;"Preserve Non-Latin Characters";Boolean)
        {
            Caption = 'Preserve Non-Latin Characters';
            DataClassification = ToBeClassified;
            InitValue = true;
        }
        field(11;"Check Export Codeunit";Integer)
        {
            Caption = 'Check Export Codeunit';
            DataClassification = ToBeClassified;
            TableRelation = AllObjWithCaption."Object ID" WHERE ("Object Type"=CONST(Codeunit));
        }
        field(12;"Check Export Codeunit Name";Text[249])
        {
            CalcFormula = Lookup(AllObjWithCaption."Object Caption" WHERE ("Object Type"=CONST(Codeunit),
                                                                           "Object ID"=FIELD("Check Export Codeunit")));
            Caption = 'Check Export Codeunit Name';
            Editable = false;
            FieldClass = FlowField;
        }
        field(100;URL;Text[250])
        {
            Caption = 'Description 2';
            DataClassification = ToBeClassified;
            ExtendedDatatype = URL;
        }
        field(300;"Real Estate Id.";Text[50])
        {
            Caption = 'Identificador inmobiliaria';
            DataClassification = ToBeClassified;
        }
    }

    keys
    {
        key(Key1;"Code")
        {
            Clustered = true;
        }
    }

    fieldgroups
    {
    }

    procedure GetExportCodeunitID(): Integer
    begin
        TESTFIELD("Processing Codeunit ID");
        EXIT("Processing Codeunit ID");
    end;

    procedure GetPublicExportXMLPortID(): Integer

    begin
        TESTFIELD("Processing XMLport ID");
        EXIT("Processing XMLport ID");
    end;
}

