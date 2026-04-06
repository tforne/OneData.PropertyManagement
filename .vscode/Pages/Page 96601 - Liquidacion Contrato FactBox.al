page 96601 "Liquidacion Contrato FactBox"
{
    PageType = CardPart;
    SourceTable = "Liquidacion Contrato Header";
    Caption = 'Liquidación';
    Editable = false;
    ApplicationArea = All;
    CardPageId = 96600;

    layout
    {
        area(content)
        {
            group(General)
            {
                field("Fecha Liquidacion"; rec."Fecha Liquidacion")
                {
                }
                field("Motivo Liquidacion"; rec."Motivo Liquidacion")
                {
                }
            }

            group(Economico)
            {
                field("Amount Rental Deposit"; rec."Amount Rental Deposit")
                {
                }
                field("Renta Final"; rec."Renta Final")
                {
                }
                field("Penalizacion"; rec."Penalizacion")
                {
                }
                field("Importe Total Liquidacion"; rec."Importe Total Liquidacion")
                {
                    Style = Strong;
                }
            }
        }
    }
}
