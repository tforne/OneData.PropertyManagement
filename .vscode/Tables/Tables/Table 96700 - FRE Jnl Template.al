table 96700 "FRE Jnl. Template"
{
    Caption = 'FRE Jnl. Template';
    LookupPageID = "FRE Journal Templates";
    ReplicateData = false;

    fields
    {
        field(1; Name; Code[10])
        {
            Caption = 'Name';
            NotBlank = true;
        }
        field(2; Description; Text[80])
        {
            Caption = 'Description';
        }
        field(5; "Checklist Report ID"; Integer)
        {
            Caption = 'Checklist Report ID';
            TableRelation = AllObjWithCaption."Object ID" WHERE ("Object Type"=CONST(Report));
        }
        field(6; "Page ID"; Integer)
        {
            Caption = 'Page ID';
            TableRelation = AllObjWithCaption."Object ID" WHERE ("Object Type"=CONST(Page));

            trigger OnValidate()
            begin
                IF "Page ID" = 0 THEN
                    "Page ID" := PAGE::"IRPF Journal Line";
                "Checklist Report ID" := REPORT::"IRPF - Checklist";
            end;
        }
        field(15; "Checklist Report Caption"; Text[250])
        {
            CalcFormula = Lookup (AllObjWithCaption."Object Caption" WHERE ("Object Type"=CONST(Report),
                                                                           "Object ID"=FIELD("Checklist Report ID")));
            Caption = 'Checklist Report Caption';
            Editable = false;
            FieldClass = FlowField;
        }
        field(16;"Page Caption";Text[250])
        {
            CalcFormula = Lookup(AllObjWithCaption."Object Caption" WHERE ("Object Type"=CONST(Page),
                                                                           "Object ID"=FIELD("Page ID")));
            Caption = 'Page Caption';
            Editable = false;
            FieldClass = FlowField;
        }
    }

    keys
    {
        key(Key1;Name)
        {
            Clustered = true;
        }
    }

    fieldgroups
    {
    }

    trigger OnDelete()
    begin
        IRPFJnlLine.SETRANGE("Journal Template Name",Name);
        IRPFJnlLine.DELETEALL;
        IRPFJnlBatch.SETRANGE("Journal Template Name",Name);
        IRPFJnlBatch.DELETEALL;
    end;

    trigger OnInsert()
    begin
        VALIDATE("Page ID");
    end;

    var
        IRPFJnlBatch: Record "OneData IRPF Jnl. Batch";
        IRPFJnlLine: Record "OneData IRPF Jnl. Line";
}

