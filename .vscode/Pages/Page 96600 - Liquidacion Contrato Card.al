page 96600 "Liquidacion Contrato Card"
{
    PageType = Card;
    SourceTable = "Liquidacion Contrato Header";
    Caption = 'Liquidar contrato';
    ApplicationArea = All;
    Editable = true;

    layout
    {
        area(content)
        {
            group(General)
            {
                field("Fecha Entrega Llaves"; rec."Fecha Entrega Llaves") 
                { 
                    ApplicationArea = All;
                }
                field(Motivo; rec."Motivo Liquidacion") 
                { 
                    ApplicationArea = All;
                }
                field("Fecha Liquidacion"; rec."Fecha Liquidacion") 
                { 
                    ApplicationArea = All;
                }
            }
            part(LiquidacionContratoLines; 96602)
            {
                ApplicationArea = All;
                SubPageLink = "Contract No."=FIELD("Contract No.");
            }
            group(Economico)
            {
                field("Amount Rental Deposit"; rec."Amount Rental Deposit") 
                { 
                    ApplicationArea = All;
                    Editable = false;
                }
                field(RentaFinal; rec."Renta Final") 
                { 
                    ApplicationArea = All;
                    Editable = false;
                }
                field(Penalizacion; rec."Penalizacion") 
                { 
                    ApplicationArea = All;
                    Editable = false;
                }
            }
        }
    }

    actions
    {
        area(processing)
        {
        }
    }

    var
        ContratoNo: Code[20];

    procedure SetContrato(NoContrato: Code[20])
    begin
        ContratoNo := NoContrato;
    end;
}