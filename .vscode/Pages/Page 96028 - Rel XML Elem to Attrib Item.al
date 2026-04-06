page 96028 "Rel. XML Elem. to Attrib. Item"
{
    PageType = ListPart;
    SourceTable = "Rel. XML Elem. to Attrib. Item";
    ApplicationArea = All;

    layout
    {
        area(content)
        {
            repeater(Group)
            {
                field("Web Site Code"; rec."Web Site Code")
                {
                }
                field("Element XML Name"; rec."Element XML Name")
                {
                }
                field("Attribute Id."; rec."Attribute Id.")
                {
                }
                field(Description; rec.Description)
                {
                }
                field(Required; rec.Required)
                {
                }
                field("Field No."; rec."Field No.")
                {
                    BlankZero = true;
                }
            }
        }
    }

    actions
    {
    }
}

