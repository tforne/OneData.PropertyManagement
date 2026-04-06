page 96015 "Real Estate Role Center"
{
    Caption = 'Property Management Role Center';
    PageType = RoleCenter;
    ApplicationArea = All;

    layout
    {
        area(rolecenter)
        {
            part(Control139; "Headline FFO Manager")
            {
            }
            part(RECashFlowChart;"RE Analisis Ingresos y Gastos")
            {
            }
            part("Real Estate Incidents"; 96056)
            {
            }
            part("Real Estate"; 96014)
            {
            }
            part("Account Manager Activities"; 9030)
            {
            }
            part("User Tasks Activities"; 9078)
            {
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
                    ToolTip = 'Open the list of posted sales Lease Invoice.';
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
                ToolTip = 'View or edit detailed information for the customers that you trade with. From each customer card, you can open related information, such as sales statistics and ongoing orders, and you can define special prices and line discounts that you grant if certain conditions are met.';
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
            action("Fixed Assets")
            {
                Caption = 'Activos fijos';
                Image = FixedAssets;
                RunObject = Page "Fixed Asset List";
            }       
            action("Incoming Documents")
            {
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
                    Image = Documents;
                    RunObject = Report 96001;
                }
                action("Hoja de incremento de precios")
                {
                    Caption = 'Hoja de incremento de precios';
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
                    Image = Documents;
                    RunObject = Page 190;
                }
            }
            group(Journals)
            {
                Caption = 'Journals';
                action("Journal property")
                {
                    Caption = 'Journal property';
                    Image = Journal;
                    RunObject = Page "FRE Journal Line";
                }
                action("General Journals")
                {
                    Caption = 'Diarios generales';
                    Image = Journal;
                    RunObject = Page "General Journal";
                    ToolTip = 'Abrir los diarios generales para registrar movimientos contables.';
                }
            }
            group(Setup)
            {
                Caption = 'Setup';
                action("Real Estate Fixed Setup")
                {
                    Caption = 'Real Estate Fixed Setup';
                    Image = Setup;
                    RunObject = Page 96007;
                }
                action("Sales & Receivables Setup")
                {
                    Caption = 'Sales & Receivables Setup';
                    Image = Setup;
                    RunObject = Page 459;
                }
                action("FA Classes")
                {
                    Caption = 'FA Classes';
                    Image = Setup;
                    RunObject = Page 5615;
                }
                action("FA Subclasses")
                {
                    Caption = 'FA Subclasses';
                    Image = Setup;
                    RunObject = Page 5616;
                }
                action("FA Locations")
                {
                    Caption = 'FA Locations';
                    Image = Setup;
                    RunObject = Page 5617;
                }
                action("Insurance Types")
                {
                    Caption = 'Insurance Types';
                    Image = Setup;
                    RunObject = Page 5648;
                }
                action("Fixed Read Es. Web Site List")
                {
                    Caption = 'Fixed Read Es. Web Site List';
                    Image = Setup;
                    RunObject = Page 96022;
                }
                action("Consumer Price Index")
                {
                    Caption = 'Consumer Price Index';
                    Image = Setup;
                    RunObject = Page 96050;
                }
                action("Payment Terms")
                {
                    Caption = 'Payment Terms';
                    Image = Setup;
                    RunObject = Page 4;
                }
                action("Payment Methods")
                {
                    Caption = 'Payment Methods';
                    Image = Setup;
                    RunObject = Page 427;
                }
                action("FRE Excel Template Setup")
                {
                    Caption = 'FRE Excel Template Setup';
                    Image = Setup;
                    RunObject = Page 96725;
                }
                action("FRE Jnl. Template List")
                {
                    Caption = 'FRE Jnl. Template List';
                    Image = Setup;
                    RunObject = Page 96700;
                }
            }
            group(Information)
            {
                Caption = 'Information';
                action("WebPropertyManagement")
                {
                    Caption = 'Web Property Management';
                    Image = Web;
                    RunObject = codeunit 96200;
                }
                action("Documentación")
                {
                    Caption = 'Documentación';
#pragma warning disable AL0482
                    Image = Information;
#pragma warning restore AL0482
                    RunObject = codeunit 96201;

                }
            }
        }
    }
}


