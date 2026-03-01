page 96028 "Rel. XML Elem. to Attrib. Item"
{
    PageType = ListPart;
    SourceTable = "Rel. XML Elem. to Attrib. Item";

    layout
    {
        area(content)
        {
            repeater(Group)
            {
                field("Web Site Code"; rec."Web Site Code")
                {
                    ApplicationArea = All;
                }
                field("Element XML Name"; rec."Element XML Name")
                {
                    ApplicationArea = All;
                }
                field("Attribute Id."; rec."Attribute Id.")
                {
                    ApplicationArea = All;
                }
                field(Description; rec.Description)
                {
                    ApplicationArea = All;
                }
                field(Required; rec.Required)
                {
                    ApplicationArea = All;
                }
                field("Field No."; rec."Field No.")
                {
                    ApplicationArea = All;
                    BlankZero = true;
                }
            }
        }
    }

    actions
    {
    }
}

