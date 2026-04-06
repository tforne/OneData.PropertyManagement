page 96060 "Real Estate Incident RC"
{
    Caption = 'Real Estate Incident Manager';
    PageType = RoleCenter;
    ApplicationArea = All;

    layout
    {
        area(rolecenter)
        {
            part(Control139; "Headline FFO Manager")
            {
            }
            part("Real Estate Incidents"; 96056)
            {
            }
            part("Real Estate"; 96014)
            {
            }
            part("User Tasks Activities"; 9078)
            {
            }

            group(Group02)
            {
                systempart(MyNotes; MyNotes)
                {
                }
            }
        }
    }

    actions
    {
        area(sections)
        {
            group("Posted Documents")
            {
                Caption = 'Posted Documents';
                Image = FiledPosted;

                action("Posted Lease Invoices")
                {
                    Caption = 'Posted Lease Invoices';
                    Image = PostedShipment;
                    RunObject = Page "Posted Lease Invoices";
                    ToolTip = 'Open the list of posted REF sales invoices.';
                }

                action("Posted Sales Invoices")
                {
                    Caption = 'Posted Sales Invoices';
                    Image = PostedShipment;
                    RunObject = Page "Posted Sales Invoices";
                    ToolTip = 'Open the list of posted sales invoices.';
                }

                action("Posted Sales Credit Memos")
                {
                    Caption = 'Posted Sales Credit Memos';
                    Image = PostedOrder;
                    RunObject = Page "Posted Sales Credit Memos";
                    ToolTip = 'Open the list of posted sales credit memos.';
                }

                action("Posted Lease Invoices Lines")
                {
                    Caption = 'Posted Lease Invoices Lines';
                    Image = PostedOrder;
                    RunObject = Page "Posted Lease Invoices Lines";
                    ToolTip = 'Open the list of posted sales lease invoice lines.';
                }

                action("Movs. FRE")
                {
                    Caption = 'Movs. FRE';
                    Image = LedgerEntries;
                    RunObject = Page "Movs. FRE";
                    ToolTip = 'Open the list of movements related to Fixed Real Estate.';
                }

                action(Attachments)
                {
                    Caption = 'Attachments';
                    Image = Attachments;
                    RunObject = Page 96155;
                    ToolTip = 'Open the list of attachments related to Real Estate Incidents.';
                }
            }
        }

        area(embedding)
        {
            action(Contacts)
            {
                Caption = 'Contacts';
                Image = CustomerContact;
                RunObject = Page 5052;
                ToolTip = 'View a list of all your contacts.';
            }

            action(Customers)
            {
                Caption = 'Customers';
                Image = Customer;
                RunObject = Page 22;
                ToolTip = 'View or edit detailed information for customers.';
            }

            action(Vendors)
            {
                Caption = 'Vendors';
                RunObject = Page 27;
            }

            action("Fixed Real Estate List")
            {
                Caption = 'Activos inmobiliarios';
                RunObject = Page 96001;
            }
        }
    }
}