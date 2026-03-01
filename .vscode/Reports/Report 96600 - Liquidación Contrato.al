report 96600 "Liquidación Contrato"
{
    ApplicationArea = All;
    Caption = 'Liquidación Contrato';
    UsageCategory = ReportsAndAnalysis;
    DefaultLayout = Word;
    WordLayout = '.vscode/Reports/Report 96600 - Liquidación Contrato.docx';
    dataset
    {
        dataitem(LiquidacionContratoHeader; "Liquidacion Contrato Header")
        {
            column(ContractNo; "Contract No.")
            {
            }
            column(AmountRentalDeposit; "Amount Rental Deposit")
            {
            }
            column(LeaseDescription;LeaseContract.Description)
            {
            }
            column(MotivoLiquidacion; "Motivo Liquidacion")
            {
            }
            column(DescriptionFixedRealEstate; LeaseContract."Description Fixed Real Estate")
            {
            }
            column(LeaseContract;LeaseContract."Amount Rental Deposit")
            {
            }
            column(Titular; LeaseContract.Name)
            {
            }
            dataitem(LiquidacionContratoLines; "Liquidacion Contrato Lines")
            {
                DataItemLink = "Contract No." = field("Contract No.");
                column(ContractNoLine; "Contract No.")
                {
                }
                column(LineNo; "Line No.")
                {
                }
                column(Description; Description)
                {
                }
                column(Amount; Amount)
                {
                }
            }
            trigger OnAfterGetRecord()
            begin
                LeaseContract.Get("Contract No.");
                LeaseContract.CalcFields("Amount Rental Deposit","Description Fixed Real Estate",
                                        Name);
            end;
            
        }
    }
    requestpage
    {
        layout
        {
            area(Content)
            {
                group(GroupName)
                {
                }
            }
        }
        actions
        {
            area(Processing)
            {
            }
        }
    }
    var
        LeaseContract: Record "Lease Contract";
}
