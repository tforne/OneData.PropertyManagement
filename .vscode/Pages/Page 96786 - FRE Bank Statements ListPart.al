page 96786 "FRE Bank Statements ListPart"
{
    PageType = ListPart;
    SourceTable = "FRE Bank Statement";
    Caption = 'Bank Statements';
    ApplicationArea = All;
    Editable = false;

    layout
    {
        area(content)
        {
            repeater(Group)
            {

                field(Company; Rec.Company)
                {
                }

                field(Year; Rec.Year)
                {
                }

                field(Month; Rec.Month)
                {
                }

                field(Status; Rec.Status)
                {
                }
            }
        }
    }
}