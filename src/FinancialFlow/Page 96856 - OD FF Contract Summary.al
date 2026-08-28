page 96956 "OD FF Contract Summary"
{
    PageType = Card;
    SourceTable = "OD FF Contract Summary";
    SourceTableTemporary = true;
    ApplicationArea = All;
    Caption = 'Resumen contrato';
    Editable = false;
    InsertAllowed = false;
    DeleteAllowed = false;
    ModifyAllowed = false;

    layout
    {
        area(Content)
        {
            group(General)
            {
                Caption = 'General';

                field("Company Name"; Rec."Company Name")
                {
                    ToolTip = 'Muestra la empresa del contrato.';
                }
                field("Contract No."; Rec."Contract No.")
                {
                    ToolTip = 'Muestra el número del contrato.';
                }
                field(Description; Rec.Description)
                {
                    ToolTip = 'Muestra la descripción del contrato.';
                }
                field(Status; Rec.Status)
                {
                    ToolTip = 'Muestra el estado actual del contrato.';
                }
                field("Customer No."; Rec."Customer No.")
                {
                    ToolTip = 'Muestra el número del cliente.';
                }
                field("Customer Name"; Rec."Customer Name")
                {
                    ToolTip = 'Muestra el nombre del cliente.';
                }
                field("Contact Name"; Rec."Contact Name")
                {
                    ToolTip = 'Muestra el contacto del contrato.';
                }
            }
            group(Fechas)
            {
                Caption = 'Fechas';

                field("Starting Date"; Rec."Starting Date")
                {
                    ToolTip = 'Muestra la fecha de inicio del contrato.';
                }
                field("Expiration Date"; Rec."Expiration Date")
                {
                    ToolTip = 'Muestra la fecha de vencimiento del contrato.';
                }
                field("Last Invoice Date"; Rec."Last Invoice Date")
                {
                    ToolTip = 'Muestra la última fecha de facturación.';
                }
                field("Next Invoice Date"; Rec."Next Invoice Date")
                {
                    ToolTip = 'Muestra la próxima fecha de facturación.';
                }
            }
            group(Importes)
            {
                Caption = 'Importes';

                field("Invoice Period"; Rec."Invoice Period")
                {
                    ToolTip = 'Muestra la periodicidad de facturación.';
                }
                field("Amount per Period"; Rec."Amount per Period")
                {
                    ToolTip = 'Muestra el importe por periodo del contrato.';
                }
                field("Annual Amount"; Rec."Annual Amount")
                {
                    ToolTip = 'Muestra el importe anual del contrato.';
                }
                field("Payment Method Code"; Rec."Payment Method Code")
                {
                    ToolTip = 'Muestra la forma de pago.';
                }
                field("Payment Terms Code"; Rec."Payment Terms Code")
                {
                    ToolTip = 'Muestra los términos de pago.';
                }
            }
            group(Activo)
            {
                Caption = 'Activo';

                field("Property No."; Rec."Property No.")
                {
                    ToolTip = 'Muestra el número del activo asociado.';
                }
                field("Property Description"; Rec."Property Description")
                {
                    ToolTip = 'Muestra la descripción del activo asociado.';
                }
            }
        }
    }
}
