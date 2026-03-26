// ------------------------------------------------------------------------------------------------
// Copyright (c) Tomàs Forné Martínez. All rights reserved.
// ------------------------------------------------------------------------------------------------

table 96007 "RE Owner Cue"
{
    Caption = 'SB Owner Cue';

    fields
    {
        field(1; "Primary Key"; Code[10])
        {
            Caption = 'Primary Key';
        }
        field(2; "Released Sales Quotes"; Integer)
        {
            CalcFormula = Count ("Sales Header" WHERE ("Document Type"=CONST(Quote),
                                                      Status=FILTER(Released)));
            Caption = 'Released Sales Quotes';
            FieldClass = FlowField;
        }
        field(3;"Open Sales Orders";Integer)
        {
            AccessByPermission = TableData 6660=R;
            CalcFormula = Count("Sales Header" WHERE ("Document Type"=CONST(Order),
                                                      Status=FILTER(Open)));
            Caption = 'Open Sales Orders';
            FieldClass = FlowField;
        }
        field(4;"Released Sales Orders";Integer)
        {
            AccessByPermission = TableData 6660=R;
            CalcFormula = Count("Sales Header" WHERE ("Document Type"=CONST(Order),
                                                      Status=FILTER(Released)));
            Caption = 'Released Sales Orders';
            FieldClass = FlowField;
        }
        field(5;"Released Purchase Orders";Integer)
        {
            AccessByPermission = TableData 120=R;
            CalcFormula = Count("Purchase Header" WHERE ("Document Type"=CONST(Order),
                                                         Status=FILTER(Released)));
            Caption = 'Released Purchase Orders';
            FieldClass = FlowField;
        }
        field(6;"Overdue Sales Documents";Integer)
        {
            CalcFormula = Count("Cust. Ledger Entry" WHERE ("Document Type"=FILTER('Invoice|Credit Memo'),
                                                            "Due Date"=FIELD("Overdue Date Filter"),
                                                            Open=CONST(true)));
            Caption = 'Overdue Sales Documents';
            FieldClass = FlowField;
        }
        field(7;"Shipped Not Invoiced";Integer)
        {
            AccessByPermission = TableData 110=R;
            CalcFormula = Count("Sales Header" WHERE ("Document Type"=CONST(Order),
                                                      "Completely Shipped"=CONST(true),
                                                      "Shipped Not Invoiced"=CONST(true)));
            Caption = 'SOs Shipped Not Invoiced';
            FieldClass = FlowField;
        }
        field(8;"Customers - Blocked";Integer)
        {
            CalcFormula = Count(Customer WHERE (Blocked=FILTER(<>' ')));
            Caption = 'Customers - Blocked';
            FieldClass = FlowField;
        }
        field(9;"Purchase Documents Due Today";Integer)
        {
            CalcFormula = Count("Vendor Ledger Entry" WHERE ("Document Type"=FILTER('Invoice|Credit Memo'),
                                                             "Due Date"=FIELD("Due Date Filter"),
                                                             Open=CONST(false)));
            Caption = 'Purchase Documents Due Today';
            FieldClass = FlowField;
        }
        field(10;"Vendors - Payment on Hold";Integer)
        {
            CalcFormula = Count(Vendor WHERE (Blocked=FILTER(Payment)));
            Caption = 'Vendors - Payment on Hold';
            FieldClass = FlowField;
        }
        field(11;"Sales Invoices";Integer)
        {
            CalcFormula = Count("Sales Header" WHERE ("Document Type"=FILTER(Invoice)));
            Caption = 'Sales Invoices';
            FieldClass = FlowField;
        }
        field(12;"Unpaid Sales Invoices";Integer)
        {
            CalcFormula = Count("Sales Invoice Header" WHERE (Closed=FILTER(false)));
            Caption = 'Unpaid Sales Invoices';
            FieldClass = FlowField;
        }
        field(13;"Overdue Sales Invoices";Integer)
        {
            CalcFormula = Count("Sales Invoice Header" WHERE ("Due Date"=FIELD("Overdue Date Filter"),
                                                              Closed=FILTER('false')));
            Caption = 'Overdue Sales Invoices';
            FieldClass = FlowField;
        }
        field(14;"Sales Quotes";Integer)
        {
            CalcFormula = Count("Sales Header" WHERE ("Document Type"=FILTER(Quote)));
            Caption = 'Sales Quotes';
            FieldClass = FlowField;
        }
        field(20;"Due Date Filter";Date)
        {
            Caption = 'Due Date Filter';
            Editable = false;
            FieldClass = FlowFilter;
        }
        field(21;"Overdue Date Filter";Date)
        {
            Caption = 'Overdue Date Filter';
            FieldClass = FlowFilter;
        }
        field(30;"Purchase Invoices";Integer)
        {
            CalcFormula = Count("Purchase Header" WHERE ("Document Type"=FILTER(Invoice)));
            Caption = 'Purchase Invoices';
            FieldClass = FlowField;
        }
        field(31;"Unpaid Purchase Invoices";Integer)
        {
            CalcFormula = Count("Purch. Inv. Header" WHERE (Closed=FILTER('false')));
            Caption = 'Unpaid Purchase Invoices';
            FieldClass = FlowField;
        }
        field(32;"Overdue Purchase Invoices";Integer)
        {
            CalcFormula = Count("Purch. Inv. Header" WHERE ("Due Date"=FIELD("Overdue Date Filter"),
                                                            Closed=FILTER('False')));
            Caption = 'Overdue Purchase Invoices';
            FieldClass = FlowField;
        }
        field(33;"User ID Filter";Code[50])
        {
            Caption = 'User ID Filter';
            FieldClass = FlowFilter;
        }
        field(34;"Pending Tasks";Integer)
        {
            CalcFormula = Count("User Task" WHERE ("Assigned To User Name"=FIELD("User ID Filter"),
                                                   "Percent Complete"=FILTER('<>100')));
            Caption = 'Pending Tasks';
            FieldClass = FlowField;
        }
        field(96000;"Fixed Real Estate";Integer)
        {
            CalcFormula = Count("Fixed Real Estate" WHERE (Type=CONST(Activo)));
            Caption = 'Activos inmobilizados';
            Editable = false;
            FieldClass = FlowField;
        }
        field(96001;"Lease Contract Signed";Decimal)
        {
            CalcFormula = Sum("Lease Contract"."Amount per Period" WHERE (Status=CONST(Signed)));
            Caption = 'Contratos de alquiler firmados';
            Editable = false;
            FieldClass = FlowField;
        }
        field(96002;"Lease Contract Expired";Integer)
        {
            CalcFormula = Count("Lease Contract" WHERE (Status=CONST(Signed),
                                                        "Expiration Date"=FIELD("Due Date Filter")));
            Caption = 'Contratos de alquiler caducados';
            FieldClass = FlowField;
        }
        field(96003;"Builded surface";Decimal)
        {
            CalcFormula = Sum("FRE Superficies"."Superficie m2" where(Construida=const(true)));
            Editable = false;
            FieldClass = FlowField;
        }
        field(96004;"Rental Fixed Real Estate";Integer)
        {
            CalcFormula = Count("Fixed Real Estate" WHERE (Type=CONST(Activo),
                                                           Status=CONST("En alquiler")));
            Caption = 'Activos inmobiliarios en alquiler';
            Editable = false;
            FieldClass = FlowField;
        }
        field(96005;"Lease Contract Open";Integer)
        {
            CalcFormula = Count("Lease Contract" WHERE (Status=CONST(" ")));
            Caption = 'Contratos de alquiler abiertos';
            Editable = false;
            FieldClass = FlowField;
        }
        field(96100;Contacts;Integer)
        {
            CalcFormula = Count(Contact);
            Caption = 'Contactos';
            Editable = false;
            FieldClass = FlowField;
        }
        field(96101;"Active Incidents";Integer)
        {
            CalcFormula = Count("Incident Assets Real Estate" WHERE (StateCode=CONST(Active)));
            Caption = 'Incidentes activos';
            Editable = false;
            FieldClass = FlowField;
        }
        field(96102;"Tenants";Integer)
        {
            CalcFormula = Count("REF Related Contactos" WHERE (Type =CONST(Tenant)));
            Caption = 'Inquilinos';
            Editable = false;
            FieldClass = FlowField;
        }

        field(7000000;"Receivable Documents";Integer)
        {
            CalcFormula = Count("Cartera Doc." WHERE (Type=CONST(Receivable),
                                                      "Bill Gr./Pmt. Order No."=CONST()));
            Caption = 'Receivable Documents';
            FieldClass = FlowField;
        }
        field(7000001;"Payable Documents";Integer)
        {
            CalcFormula = Count("Cartera Doc." WHERE (Type=CONST(Payable),
                                                      "Bill Gr./Pmt. Order No."=CONST()));
            Caption = 'Payable Documents';
            FieldClass = FlowField;
        }
        field(7000002;"Posted Receivable Documents";Integer)
        {
            CalcFormula = Count("Posted Cartera Doc." WHERE (Type=CONST(Receivable),
                                                             "Bill Gr./Pmt. Order No."=CONST()));
            Caption = 'Posted Receivable Documents';
            FieldClass = FlowField;
        }
        field(7000003;"Posted Payable Documents";Integer)
        {
            CalcFormula = Count("Posted Cartera Doc." WHERE (Type=CONST(Payable),
                                                             "Bill Gr./Pmt. Order No."=CONST()));
            Caption = 'Posted Payable Documents';
            FieldClass = FlowField;
        }
    }

    keys
    {
        key(Key1;"Primary Key")
        {
            Clustered = true;
        }
    }

    fieldgroups
    {
    }

    procedure CountSalesOrdersShippedNotInvoiced(): Integer
    var
        CountSalesOrders: Query "Count Sales Orders";
    begin
        CountSalesOrders.SETRANGE(Completely_Shipped,TRUE);
        CountSalesOrders.SETRANGE(Shipped_Not_Invoiced,FALSE);
        CountSalesOrders.OPEN;
        CountSalesOrders.READ;
        EXIT(CountSalesOrders.Count_Orders);
    end;

    procedure ShowSalesOrdersShippedNotInvoiced()
    var
        SalesHeader: Record "Sales Header";
    begin
        SalesHeader.SETRANGE("Document Type",SalesHeader."Document Type"::Order);
        SalesHeader.SETRANGE("Completely Shipped",TRUE);
        SalesHeader.SETRANGE(Invoice,FALSE);
        PAGE.RUN(PAGE::"Sales Order List",SalesHeader);
    end;
}

