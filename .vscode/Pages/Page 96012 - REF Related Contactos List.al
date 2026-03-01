page 96012 "REF Related Contactos List"
{
    PageType = List;
    SourceTable = "REF Related Contactos";

    layout
    {
        area(content)
        {
            repeater(Group)
            {
                field("No. Entry."; rec."No. Entry.")
                {
                    ApplicationArea = All;
                }
                field("Entity Type"; rec."Entity Type")
                {
                    ApplicationArea = All;
                }
                field("Source No."; rec."Source No.")
                {
                    ApplicationArea = All;
                }
                field(Name; rec.Name)
                {
                    ApplicationArea = All;
                }
                field("Name 2"; rec."Name 2")
                {
                    ApplicationArea = All;
                }
                field(Address; rec.Address)
                {
                    ApplicationArea = All;
                }
                field("Address 2"; rec."Address 2")
                {
                    ApplicationArea = All;
                }
                field(City; rec.City)
                {
                    ApplicationArea = All;
                }
                field("Post Code"; rec."Post Code")
                {
                    ApplicationArea = All;
                }
                field(County; rec.County)
                {
                    ApplicationArea = All;
                }
                field("Country/Region Code"; rec."Country/Region Code")
                {
                    ApplicationArea = All;
                }
                field("Phone No."; rec."Phone No.")
                {
                    ApplicationArea = All;
                }
                field("Telex No."; rec."Telex No.")
                {
                    ApplicationArea = All;
                }
                field("Extension No."; rec."Extension No.")
                {
                    ApplicationArea = All;
                }
                field("Mobile Phone No."; rec."Mobile Phone No.")
                {
                    ApplicationArea = All;
                }
                field(Pager; rec.Pager)
                {
                    ApplicationArea = All;
                }
                field("VAT Registration No."; rec."VAT Registration No.")
                {
                    ApplicationArea = All;
                }
                field("E-Mail"; rec."E-Mail")
                {
                    ApplicationArea = All;
                }
                field("Home Page"; rec."Home Page")
                {
                    ApplicationArea = All;
                }
                field("Fax No."; rec."Fax No.")
                {
                    ApplicationArea = All;
                }
                field("Telex Answer Back"; rec."Telex Answer Back")
                {
                    ApplicationArea = All;
                }
                field("Contact No."; rec."Contact No.")
                {   
                    ApplicationArea = All;
                }
            }
        }
        area(factboxes)
        {
            part(Contacts; 5051)
            {
                applicationarea = All;
                SubPageLink = "Contact No."=FIELD("Contact No.");
            }
            part("Contacts Picture"; 5104)
            {
                applicationarea = All;
                SubPageLink = "No."=FIELD("Contact No.");
            }
        }
    }

    actions
    {
    }
}

