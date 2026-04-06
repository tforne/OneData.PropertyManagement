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
                }
                field("Ciudad Entrega Llaves";Rec."Ciudad Entrega Llaves")
                {
                }
                field(Motivo; rec."Motivo Liquidacion") 
                { 
                }
                field("Fecha Liquidacion"; rec."Fecha Liquidacion") 
                { 
                }
            }
            part(LiquidacionContratoLines; 96602)
            {
                SubPageLink = "Contract No."=FIELD("Contract No.");
            }
            group(Economico)
            {
                field("Amount Rental Deposit"; rec."Amount Rental Deposit") 
                { 
                    Editable = false;
                }
                field(RentaFinal; rec."Renta Final") 
                { 
                    Editable = false;
                }
                field(Penalizacion; rec."Penalizacion") 
                { 
                    Editable = false;
                }
            }
        }
    }

actions
{
    area(processing)
    {
        action(ImprimirEntregaLlaves)
        {
            Caption = 'Entrega de llaves y posesión';
            Image = Print;

            trigger OnAction()
            var
                LiquidacionHeader: Record "Liquidacion Contrato Header";
            begin
                LiquidacionHeader := Rec;
                LiquidacionHeader.SetRecFilter();

                Report.RunModal(
                    Report::"Entrega Llaves y Posesion",
                    true,
                    false,
                    LiquidacionHeader
                );
            end;
        }
        action(ImprimirLiquidacionContrato)
        {
            Caption = 'Imprimir liquidación';
            Image = Print;

            trigger OnAction()
            var
                LiquidacionHeader: Record "Liquidacion Contrato Header";
            begin
                LiquidacionHeader := Rec;
                LiquidacionHeader.SetRecFilter();
                Report.RunModal(Report::"Liquidacion Contrato", true, false, LiquidacionHeader);
            end;
        }
    }
}

    var
        ContratoNo: Code[20];

    procedure SetContrato(NoContrato: Code[20])
    begin
        ContratoNo := NoContrato;
    end;
}