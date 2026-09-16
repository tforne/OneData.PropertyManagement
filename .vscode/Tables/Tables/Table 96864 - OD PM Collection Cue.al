table 96864 "OD PM Collection Cue"
{
    Caption = 'OD PM Collection Cue';
    DataClassification = SystemMetadata;

    fields
    {
        field(1; "Primary Key"; Code[10])
        {
            Caption = 'Primary Key';
        }
        field(2; "Open Receivables (LCY)"; Decimal)
        {
            Caption = 'Pending Collection (LCY)';
            AutoFormatType = 1;
        }
        field(3; "Overdue Receivables (LCY)"; Decimal)
        {
            Caption = 'Overdue Collections (LCY)';
            AutoFormatType = 1;
        }
        field(4; "Due Next 7 Days (LCY)"; Decimal)
        {
            Caption = 'Due Next 7 Days (LCY)';
            AutoFormatType = 1;
        }
        field(5; "Due Next 30 Days (LCY)"; Decimal)
        {
            Caption = 'Due Next 30 Days (LCY)';
            AutoFormatType = 1;
        }
        field(6; "Receivables Cartera Documents"; Integer)
        {
            Caption = 'Receivables Cartera Documents';
            Editable = false;
            FieldClass = FlowField;
            CalcFormula = Count("Cartera Doc." WHERE(Type = CONST(Receivable)));
        }
        field(7; "Rejected Cartera Documents"; Integer)
        {
            Caption = 'Rejected Cartera Documents';
            Editable = false;
            FieldClass = FlowField;
            CalcFormula = Count("Posted Cartera Doc." WHERE(Type = CONST(Receivable),
                                                               Status = CONST(Rejected)));
        }
        field(8; "Open Bill Groups"; Integer)
        {
            Caption = 'Open Bill Groups';
            Editable = false;
            FieldClass = FlowField;
            CalcFormula = Count("Bill Group");
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
