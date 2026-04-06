tableextension 96796 "Gen. Journal Line FRE Ext" extends "Gen. Journal Line"
{
    fields
    {
        field(96720; "FRE Integration"; Boolean)
        {
            Caption = 'Integración FRE';
        }

        field(96721; "FRE Real Estate No."; Code[20])
        {
            Caption = 'Nº de inmueble';
            TableRelation = "Fixed Real Estate";
        }

        field(96722; "FRE Entry Category"; Enum "FRE Entry Category")
        {
            Caption = 'Categoría de movimiento';
        }

        field(96723; "FRE Row No."; Code[10])
        {
            Caption = 'Fila FRE';
            TableRelation = "REF Income & Expense Template";
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
    }
}