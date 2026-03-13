

enum 96600 "Motivo Liquidacion Contrato"
{
    Extensible = true;
    Caption = 'Motivo de liquidación';

    value(0; "") { Caption = ''; }
    value(1; "Fin de contrato") { Caption = 'Fin de contrato'; }
    value(2; "Rescision anticipada") { Caption = 'Rescisión anticipada'; }
    value(3; Impago) { Caption = 'Impago'; }
    value(4; "Mutuo acuerdo") { Caption = 'Mutuo acuerdo'; }
    value(5; Otros) { Caption = 'Otros'; }
}