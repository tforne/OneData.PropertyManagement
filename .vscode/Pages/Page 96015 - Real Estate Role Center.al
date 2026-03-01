page 96015 "Real Estate Role Center"
{
    Caption = 'Sales and Relationship Manager', Comment = 'Use same translation as ''Profile Description'' (if applicable)';
    PageType = RoleCenter;

    layout
    {
        area(rolecenter)
        {
//            group(Group01)
//            {
                part(Control139; "Headline FFO Manager")
                {
                    ApplicationArea = all;
                }
                part("Real Estate Incidents"; 96056)
                {
                    ApplicationArea = all;
                }
                part("Real Estate"; 96014)
                {
                    ApplicationArea = all;
                }
                part("Account Manager Activities"; 9030)
                {
                    ApplicationArea = all;
                }
                part("User Tasks Activities"; 9078)
                {
                    ApplicationArea = all;
                }
//            }
            group(Group02)
            {
                systempart(MyNotes; MyNotes)
                {
                    ApplicationArea = all;
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
                    ApplicationArea = All;
                    Caption = 'Posted Lease Invoices';
                    Image = PostedShipment;
                    RunObject = Page "Posted Lease Invoices";
                    ToolTip = 'Open the list of posted REF sales invoices.';
                }
                action("Posted Sales Invoices")
                {
                    ApplicationArea = All;
                    Caption = 'Posted Sales Invoices';
                    Image = PostedShipment;
                    RunObject = Page "Posted Sales Invoices";
                    ToolTip = 'Open the list of posted sales invoices.';
                }
                action("Posted Sales Credit Memos")
                {
                    ApplicationArea = All;
                    Caption = 'Posted Sales Credit Memos';
                    Image = PostedOrder;
                    RunObject = Page "Posted Sales Credit Memos";
                    ToolTip = 'Open the list of posted sales credit memos.';
                }
                action("Posted Lease Invoices Lines")
                {
                    ApplicationArea = All;
                    Caption = 'Posted Lease Invoices Lines';
                    Image = PostedOrder;
                    RunObject = Page "Posted Lease Invoices Lines";
                    ToolTip = 'Open the list of posted sales Lease Invoice.';
                }                
            }
        }
        area(embedding)
        {
            action(Contacts)
            {
                ApplicationArea = all;
                Caption = 'Contacts';
                Image = CustomerContact;
                RunObject = Page 5052;
                ToolTip = 'View a list of all your contacts.';
            }
            action(Customers)
            {
                ApplicationArea = All;
                Caption = 'Customers';
                Image = Customer;
                RunObject = Page 22;
                ToolTip = 'View or edit detailed information for the customers that you trade with. From each customer card, you can open related information, such as sales statistics and ongoing orders, and you can define special prices and line discounts that you grant if certain conditions are met.';
            }
            action(Vendors)
            {
                Caption = 'Vendors';
                ApplicationArea = All;
                RunObject = Page 27;
            }
            action("Fixed Real Estate List")
            {
                Caption = 'Activos inmobiliarios';
                ApplicationArea = All;
                RunObject = Page 96001;
            }
        
            action("Incoming Documents")
            {
                ApplicationArea = All;
                Caption = 'Incoming Documents';
                RunObject = Page "Incoming Documents";
            }
        }
        area(processing)
        {
            group(New)
            {
                Caption = 'New';
                action(NewContract)
                {
                    // AccessByPermission = TableData 5050 = IMD;
                    ApplicationArea = All;
                    Caption = 'Contract';
                    Image = Add;
                    RunObject = Page "Lease Contract Card";
                    RunPageMode = Create;
                    ToolTip = 'Create a new contract.';
                }
            }
            group(Ventas)
            {
                Caption = 'Ventas';
                action("Crear facturación de contratos")
                {
                    Caption = 'Crear facturación de contratos';
                    ApplicationArea = All;
                    Image = Documents;
                    RunObject = Report 96001;
                }
                action("Hoja de incremento de precios")
                {
                    Caption = 'Hoja de incremento de precios';
                    ApplicationArea = All;
                    Image = Documents;
                    RunObject = page 96500;
                }
            }
            group(Compras)
            {
                Caption = 'Compras';
                action("Documentos entrantes")
                {
                    Caption = 'Documentos entrantes';
                    ApplicationArea = All;
                    Image = Documents;
                    RunObject = Page 190;
                }
            }
            group(Setup)
            {
                Caption = 'Setup';
                action("Real Estate Fixed Setup")
                {
                    Caption = 'Real Estate Fixed Setup';
                    ApplicationArea = All;
                    Image = Setup;
                    RunObject = Page 96007;
                }
                action("Sales & Receivables Setup")
                {
                    Caption = 'Sales & Receivables Setup';
                    ApplicationArea = All;
                    Image = Setup;
                    RunObject = Page 459;
                }
                action("FA Classes")
                {
                    Caption = 'FA Classes';
                    ApplicationArea = All;
                    Image = Setup;
                    RunObject = Page 5615;
                }
                action("FA Subclasses")
                {
                    Caption = 'FA Subclasses';
                    ApplicationArea = All;
                    Image = Setup;
                    RunObject = Page 5616;
                }
                action("FA Locations")
                {
                    Caption = 'FA Locations';
                    ApplicationArea = All;
                    Image = Setup;
                    RunObject = Page 5617;
                }
                action("Insurance Types")
                {
                    Caption = 'Insurance Types';
                    ApplicationArea = All;
                    Image = Setup;
                    RunObject = Page 5648;
                }
                action("Fixed Read Es. Web Site List")
                {
                    Caption = 'Fixed Read Es. Web Site List';
                    ApplicationArea = All;
                    Image = Setup;
                    RunObject = Page 96022;
                }
                action("Consumer Price Index")
                {
                    Caption = 'Consumer Price Index';
                    ApplicationArea = All;
                    Image = Setup;
                    RunObject = Page 96050;
                }
                action("Payment Terms")
                {
                    Caption = 'Payment Terms';
                    ApplicationArea = All;
                    Image = Setup;
                    RunObject = Page 4;
                }
                action("Payment Methods")
                {
                    Caption = 'Payment Methods';
                    ApplicationArea = All;
                    Image = Setup;
                    RunObject = Page 427;
                }
            }
        }
    }
}

