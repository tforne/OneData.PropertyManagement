page 96017 "Description Documents Class"
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
                field(Code; rec.Code)
                {
                    ApplicationArea = All;
                }
                field(Description; rec.Description)
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

