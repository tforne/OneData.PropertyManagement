page 96017 "Description Documents Class"
{
    Caption = 'Descripción documentos clasificados';
    PageType = List;
    SourceTable = "Description Documents Class";
    ApplicationArea = All;

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

    actions
    {
    }
}

