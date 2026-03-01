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
                    ApplicationArea = All;
                }
                field("Motivo Liquidacion"; rec."Motivo Liquidacion")
                {
                    ApplicationArea = All;
                }
            }

            group(Economico)
            {
                field("Amount Rental Deposit"; rec."Amount Rental Deposit")
                {
                    ApplicationArea = All;
                }
                field("Renta Final"; rec."Renta Final")
                {
                    ApplicationArea = All;
                }
                field("Penalizacion"; rec."Penalizacion")
                {
                    ApplicationArea = All;
                }
                field("Importe Total Liquidacion"; rec."Importe Total Liquidacion")
                {
                    ApplicationArea = All;
                    Style = Strong;
                }
            }
        }
    }
}
