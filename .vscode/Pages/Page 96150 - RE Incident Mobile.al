
page 96150 "RE Incident Mobile"
{
    
    SourceTable = "Incident Assets Real Estate";

    ApplicationArea = All;
    Caption = 'REIncident Mobile';
    PageType = List;
    UsageCategory = Administration;
    CardPageId = "RE Incident Card";


    layout
    {
        area(content)
        {
            repeater(Group)
            {
                field(id; rec."Incident Id.")
                {
                    Editable = false;
                }
                field(contractNo; rec."Contract No.")
                {
                    Editable = true;
                }
                field(title; rec.Title)
                {
                }
            }
        }
    }
}
