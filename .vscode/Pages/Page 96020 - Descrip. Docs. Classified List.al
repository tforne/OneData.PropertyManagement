page 96020 "Descrip. Docs. Classified List"
{
    Caption = 'Descripción documentos clasificados';
    PageType = List;
    SourceTable = "Description Documents Class";

    layout
    {
        area(content)
        {
            repeater(Group)
            {
                field(Code; Rec.Code)
                {
                    ApplicationArea = All;
                }
                field(Description; Rec.Description)
                {
                    ApplicationArea = All;
                }
            }
        }
    }

    actions
    {
    }
}

