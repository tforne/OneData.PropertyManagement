tableextension 96796 "Gen. Journal Line FRE Ext" extends "Gen. Journal Line"
{
    fields
    {
        field(96720; "FRE Integration"; Boolean)
        {
            Caption = 'Integración FRE';
        }

        field(96721; "FRE Fixed Real Estate No."; Code[20])
        {
            Caption = 'Fixed Real Estate No.';
            TableRelation = "Fixed Real Estate";
        }

        field(96722; "FRE Entry Category"; Enum "FRE Entry Category")
        {
            Caption = 'Categoría de movimiento';
        }

        field(96723; "FRE Row No."; Code[10])
        {
            Caption = 'Fila FRE';
            TableRelation = "REF Income & Expense Template"."Row No.";
            ValidateTableRelation = false;

            trigger OnLookup()
            begin
                LookupIncomeExpenseRowNo(true);
            end;

            trigger OnValidate()
            begin
                UpdateIncomeExpenseInfo("FRE Row No.", true);
            end;
        }

        field(96724; "FRE Source Type"; Enum "FRE Journal Source Type")
        {
            Caption = 'Tipo de origen';
        }

        field(96725; "FRE Source No."; Code[20])
        {
            Caption = 'Nº origen';
        }

        field(96726; "FRE FA No."; Code[20])
        {
            Caption = 'Nº activo fijo';
            TableRelation = "Fixed Asset";
        }

        field(96727; "Row No."; Code[10])
        {
            Caption = 'Row No.';
            DataClassification = ToBeClassified;
            TableRelation = "REF Income & Expense Template"."Row No.";
            ValidateTableRelation = false;

            trigger OnLookup()
            begin
                LookupIncomeExpenseRowNo(false);
            end;

            trigger OnValidate()
            begin
                UpdateIncomeExpenseInfo("Row No.", false);
            end;
        }

        field(96728; "Entry Category"; Enum "FRE Entry Category")
        {
            Caption = 'Entry Category';
        }

        field(96729; "Description Row No."; Code[100])
        {
            Caption = 'Description Row No.';
            DataClassification = ToBeClassified;
        }
    }

    local procedure LookupIncomeExpenseRowNo(UseFREFields: Boolean)
    var
        REFIETemplate: Record "REF Income & Expense Template";
        PageREFIETemplate: Page "REF Income & Expenses Template";
    begin
        REFIETemplate.Reset();
        REFIETemplate.SetFilter(Type, '%1|%2', REFIETemplate.Type::Income, REFIETemplate.Type::Expense);

        if not REFIETemplate.FindFirst() then
            exit;

        PageREFIETemplate.LookupMode := true;
        PageREFIETemplate.SetRecord(REFIETemplate);
        PageREFIETemplate.SetTableView(REFIETemplate);

        if PageREFIETemplate.RunModal() <> Action::LookupOK then
            exit;

        PageREFIETemplate.GetRecord(REFIETemplate);

        if UseFREFields then begin
            Rec."FRE Row No." := REFIETemplate."Row No.";
            Rec."FRE Entry Category" := REFIETemplate."Entry Category";
        end else begin
            Rec."Row No." := REFIETemplate."Row No.";
            Rec."Entry Category" := REFIETemplate."Entry Category";
        end;

        Rec."Description Row No." := REFIETemplate.Description;
    end;

    local procedure UpdateIncomeExpenseInfo(SelectedRowNo: Code[10]; UseFREFields: Boolean)
    var
        REFIETemplate: Record "REF Income & Expense Template";
    begin
        if SelectedRowNo = '' then begin
            if UseFREFields then
                Rec."FRE Entry Category" := Rec."FRE Entry Category"::Undefined
            else
                Rec."Entry Category" := Rec."Entry Category"::Undefined;

            Rec."Description Row No." := '';
            exit;
        end;

        REFIETemplate.Reset();
        REFIETemplate.SetRange("Row No.", SelectedRowNo);
        REFIETemplate.SetFilter(Type, '%1|%2', REFIETemplate.Type::Income, REFIETemplate.Type::Expense);

        if not REFIETemplate.FindFirst() then
            exit;

        if UseFREFields then
            Rec."FRE Entry Category" := REFIETemplate."Entry Category"
        else
            Rec."Entry Category" := REFIETemplate."Entry Category";

        Rec."Description Row No." := REFIETemplate.Description;
    end;
}
