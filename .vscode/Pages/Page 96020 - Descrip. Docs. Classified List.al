page 96020 "Descrip. Docs. Classified List"
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
                field(Code; Rec.Code)
                {
                }
                field(Description; Rec.Description)
                {
                }
            }
        }
    }

    actions
    {
    }
}

