page 96022 "Fixed Real Es. Web Site List"
{
    CardPageID = "Fixed Real Es. Web Site Card";
    PageType = List;
    SourceTable = "Fixed Real Estate Web Site";
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
                field("Preserve Non-Latin Characters"; rec."Preserve Non-Latin Characters")
                {
                }
            }
        }
    }

    actions
    {
    }
}

