tableextension 50685 NewFieldTable5077 extends "Segment Line"
{
    fields
    {
        field(50003; "Contact Visit No."; Code[20])
        {
            Caption = 'Nº contacto visita';
            TableRelation = "Contact";
        }
        field(50009; "Contact Visit Phone No."; Text[30])
        {
            Caption = 'Nº teléfono contacto visita';
        }
        field(50012; "Contact Visit Name"; Text[50])
        {
            Caption = 'Nombre contacto visita';
        }
        field(50102; "Contact Visit E-Mail"; Text[80])
        {
            Caption = 'Correo electrónico contacto visita';
        }
        field(60000; "Interaction Template Filter"; Code[10])
        {
            Caption = 'Interaction Template Filter';
        }
    }
procedure CreateInteractionFromLeaseContract(VAR LeaseContract : Record "Lease Contract")
var
    Contact : Record Contact;
    Salesperson : Record "Salesperson/Purchaser";
begin
    rec.DeleteAll();
    rec.init();
    LeaseContract.TestField(leaseContract."Contact No.");
//    IF Contact.GET(LeaseContract."Contact No.") THEN begin
        rec.SetRange("Contact No.",LeaseContract."Contact No.");
        rec.validate("Contact No.",LeaseContract."Contact No.");
//    end;
    IF Salesperson.GET(LeaseContract."Salesperson Code") THEN
        SetRange("Salesperson Code",LeaseContract."Salesperson Code");
    rec.StartWizard();
end;

}
