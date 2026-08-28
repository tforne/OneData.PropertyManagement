enum 96920 "OD FF Status"
{
    Extensible = true;
    Caption = 'Estado Financial Flow';

    value(0; Open)
    {
        Caption = 'Abierto';
    }
    value(1; Closed)
    {
        Caption = 'Cerrado';
    }
    value(2; Error)
    {
        Caption = 'Error';
    }
}
