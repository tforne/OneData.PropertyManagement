page 96022 "Fixed Real Es. Web Site List"
{
    CardPageID = "Fixed Real Es. Web Site Card";
    PageType = List;
    SourceTable = "Fixed Real Estate Web Site";

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
                field("Preserve Non-Latin Characters"; rec."Preserve Non-Latin Characters")
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

