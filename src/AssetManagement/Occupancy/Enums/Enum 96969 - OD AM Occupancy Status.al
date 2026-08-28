enum 96969 "OD AM Occupancy Status"
{
    Extensible = true;
    Caption = 'OD AM Occupancy Status';

    value(0; Unknown)
    {
        Caption = 'Sin determinar';
    }
    value(1; Available)
    {
        Caption = 'Disponible';
    }
    value(2; Reserved)
    {
        Caption = 'Reservado';
    }
    value(3; Occupied)
    {
        Caption = 'Ocupado';
    }
    value(4; PartiallyOccupied)
    {
        Caption = 'Parcialmente ocupado';
    }
    value(5; Blocked)
    {
        Caption = 'Bloqueado';
    }
    value(6; Inactive)
    {
        Caption = 'Inactivo';
    }
}
