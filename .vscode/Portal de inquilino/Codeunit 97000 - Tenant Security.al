codeunit 97000 "Tenant Security"
{
    SingleInstance = true;

    procedure ApplyTenantFilter(var RecRef: RecordRef)
    var
        CustomerNo: Code[20];
        FieldRef: FieldRef;
    begin
        CustomerNo := GetCustomerForUser(UserId);

        if CustomerNo = '' then
            Error('Usuario no autorizado para el portal del inquilino.');

        if not GetFieldByName(RecRef, 'Customer No.', FieldRef) then
            Error('La tabla %1 no contiene el campo Customer No.', RecRef.Name);

        FieldRef.SetRange(CustomerNo);
    end;


    procedure GetCustomerForUser(UserEmail: Text): Code[20]
    var
        Mapping: Record "Tenant User Mapping";
    begin
        if Mapping.Get(UserEmail) then
            exit(Mapping."Customer No.");

        exit('');
    end;

    procedure SetTenantDefaults(var RecRef: RecordRef)
    var
        CustomerNo: Code[20];
        FieldRef: FieldRef;
    begin
        CustomerNo := GetCustomerForUser(UserId);

        if CustomerNo = '' then
            Error('Usuario no autorizado para crear registros.');

        if not GetFieldByName(RecRef, 'Customer No.', FieldRef) then
            Error('La tabla %1 no contiene el campo Customer No.', RecRef.Name);

        FieldRef.Value := CustomerNo;
    end;

    local procedure GetFieldByName(var RecRef: RecordRef; FieldName: Text; var FoundField: FieldRef): Boolean
    var
        i: Integer;
        FRef: FieldRef;
    begin
        for i := 1 to RecRef.FieldCount do begin
            FRef := RecRef.FieldIndex(i);
            if UpperCase(FRef.Name) = UpperCase(FieldName) then begin
                FoundField := FRef;
                exit(true);
            end;
        end;

        exit(false);
    end;
}