page 96013 "REF Related Contactos"
{
    PageType = List;
    SourceTable = "REF Related Contactos";
    ApplicationArea = All;
    Editable = true;

    layout
    {
        area(content)
        {
            repeater(Group)
            {
                field(Type; rec.Type)
                {
                }
                field("Contact No."; rec."Contact No.")
                {
                }
                field(Name; rec.Name)
                {
                }
                field("Name 2"; rec."Name 2")
                {
                }
                field(Address; rec.Address)
                {
                }
                field("Address 2"; rec."Address 2")
                {
                }
                field(City; rec.City)
                {
                }
                field("Post Code"; rec."Post Code")
                {
                }
                field(County; rec.County)
                {
                }
                field("Country/Region Code"; rec."Country/Region Code")
                {
                }
                field("Phone No."; rec."Phone No.")
                {
                }
                field("Telex No."; rec."Telex No.")
                {
                }
                field("Extension No."; rec."Extension No.")
                {
                }
                field("Mobile Phone No."; rec."Mobile Phone No.")
                {
                }
                field(Pager; rec.Pager)
                {
                }
                field("E-Mail"; rec."E-Mail")
                {
                }
                field("Home Page"; rec."Home Page")
                {
                }
                field("Fax No."; rec."Fax No.")
                {
                }
                field("Telex Answer Back"; rec."Telex Answer Back")
                {
                }
            }
        }
        area(factboxes)
        {
            part(Contacts; 5051)
            {
                SubPageLink = "Contact No."=FIELD("Contact No.");
            }
            part("Contact Picture"; 5104)
            {
                SubPageLink = "No."=FIELD("Contact No.");
            }
        }
    }

    actions
    {
    }
}

