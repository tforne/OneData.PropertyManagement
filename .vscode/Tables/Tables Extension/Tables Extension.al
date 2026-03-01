
tableextension 50023 NewFieldTable36 extends "Sales Header"
{
    fields
    {
        field(96000; "Contract No."; Code[20])
        {
            Caption = 'Contract No.';
        }
        field(96001; "Periode"; Code[6])
        {
            Caption = 'Periode';
        }
        field(96002; "Total IRPF"; Decimal)
        {
            Caption = 'Total IRPF';
        }
    }
}
tableextension 50024 NewFieldTable37 extends "Sales Line"
{
    fields
    {
        field(50000; "No. Labels"; Integer)
        {
            Caption = 'Nº etiquetas';
        }
    }
}


tableextension 50048 NewFieldTable79 extends "Company Information"
{
    fields
    {
        field(50000; "IBAN 2"; Code[50])
        {
            Caption = 'IBAN';
        }
    }
}

tableextension 50069 NewFieldTable112 extends "Sales Invoice Header"
{
    fields
    {
        field(96001; "Periode"; Code[6])
        {
            Caption = 'Periode';
        }
        field(96002; "Total IRPF"; Decimal)
        {
            Caption = 'Total IRPF';
        }
    }
}
tableextension 50458 NewFieldTable1173 extends "Document Attachment"
{
    fields
    {
        field(50000; "Documents Class Code"; Code[10])
        {
            Caption = 'Documents Class Code';
            TableRelation = "Description Documents Class";
        }
    }
}
tableextension 50673 NewFieldTable5065 extends "Interaction Log Entry"
{
    fields
    {
        field(50003; "Contact Visit No."; Code[20])
        {
            Caption = 'Nº contacto visita';
            TableRelation = "Contact";
        }
        field(50009; "Contact Visit Phone No."; Text[30])
        {
            Caption = 'Nº teléfono contacto visita';
        }
        field(50012; "Contact Visit Name"; Text[50])
        {
            Caption = 'Nombre contacto visita';
        }
        field(50102; "Contact Visit E-Mail"; Text[80])
        {
            Caption = 'Correo electrónico contacto visita';
        }
    }
}
tableextension 50698 NewFieldTable5090 extends "Sales Cycle"
{
    fields
    {
        field(50000; "Directory Path"; Text[250])
        {
            Caption = 'Directory Path';
        }
    }
}
tableextension 50700 NewFieldTable5092 extends "Opportunity"
{
    fields
    {
        field(96000; "Fixed Real Estate Id."; Code[20])
        {
            Caption = 'Fixed Real Estate Id.';
            TableRelation = "Fixed Real Estate";
        }
        field(96009; "Asset Type"; Code[10])
        {
            Caption = 'Tipo de activo';
            TableRelation = "Type Fixed Real Estate";
        }
        field(96300; "Street Type Id."; Code[10])
        {
            Caption = 'Código tipo de calle';
            TableRelation = "Street Type";
        }
        field(96301; "Types Street Numbering Id."; Code[10])
        {
            Caption = 'Código tipo numeración calle';
            TableRelation = "Types Street Numbering";
        }
        field(96302; "Street Name"; Text[30])
        {
            Caption = 'Nombre de la calle';
        }
        field(96303; "Number On Street"; Text[5])
        {
            Caption = 'Número en la calle';
        }
        field(96304; "Location Height Floor"; Text[10])
        {
            Caption = 'Altura del piso';
        }
        field(96305; "Composse Address"; Text[50])
        {
            Caption = 'Composse Address';
        }
        field(96500; "Google URL"; Text[250])
        {
            Caption = 'Google URL';
        }
    }
}
tableextension 51117 NewFieldTable7500 extends "Item Attribute"
{
    fields
    {
        field(96000; "Fixed Type"; Text[250])
        {
            Caption = 'Tipo de activo';
            TableRelation = "Type Fixed Real Estate";
        }
        field(96001; "Used in"; Integer)
        {
            Caption = 'Utilizado en';
        }
    }
}
tableextension 51118 NewFieldTable7501 extends "Item Attribute Value"
{
    fields
    {
        field(50000; "Comment"; Text[50])
        {
            Caption = 'Comment';
        }
    }
}
tableextension 51121 NewFieldTable7504 extends "Item Attribute Value Selection"
{
    fields
    {
        field(50000; "Comment"; Text[50])
        {
            Caption = 'Comentarios';
        }
    }
}
tableextension 51122 NewFieldTable7505 extends "Item Attribute Value Mapping"
{
    fields
    {
        field(50000; "Comment"; Text[50])
        {
            Caption = 'Comentarios';
        }
    }
}
