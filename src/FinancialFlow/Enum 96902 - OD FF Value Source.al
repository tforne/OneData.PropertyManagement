enum 96922 "OD FF Value Source"
{
    Extensible = true;
    Caption = 'Origen valoración Financial Flow';

    value(0; MarketValue)
    {
        Caption = 'Valor de mercado';
    }
    value(1; EstimatedSellingPrice)
    {
        Caption = 'Precio estimado de venta';
    }
    value(2; PurchasePrice)
    {
        Caption = 'Precio de compra';
    }
    value(3; CadastralValue)
    {
        Caption = 'Valor catastral';
    }
    value(4; NotAvailable)
    {
        Caption = 'No disponible';
    }
}
