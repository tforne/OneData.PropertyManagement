page 96059 "Estancias"
{
    Caption = 'Estancias';
    PageType = List;
    SourceTable = "Estancia";
    ApplicationArea = All;
    UsageCategory = Administration;

    layout
    {
        area(content)
        {
            repeater(Group)
            {
                field(Code; rec.Code)
                {
                }
                field(Description; rec.Description)
                {
                }
            }
        }
    }
}
