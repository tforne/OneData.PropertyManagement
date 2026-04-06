namespace OneData.Property.Lease;

using Microsoft.Sales.Customer;
using OneData.Property.Asset;

codeunit 96041 "OD Lease Contract Copy Helper"
{
    procedure GetSourceHeader(SourceCompanyName: Text[30]; SourceContractNo: Code[20]; var SourceHeader: Record "Lease Contract")
    begin
        SourceHeader.ChangeCompany(SourceCompanyName);
        if not SourceHeader.Get(SourceContractNo) then
            Error('No existe el contrato %1 en la empresa %2.', SourceContractNo, SourceCompanyName);
    end;

    procedure EnsureTargetCanBeUpdated(var TargetHeader: Record "Lease Contract")
    begin
        TargetHeader.TestField(Status, TargetHeader.Status::" ");
    end;

    procedure EnsureLinesCanBeReplaced(TargetContractNo: Code[20]; ReplaceLines: Boolean)
    var
        TargetLine: Record "Lease Contract Line";
    begin
        TargetLine.SetRange("Contract No.", TargetContractNo);
        if TargetLine.IsEmpty() then
            exit;

        if not ReplaceLines then
            Error('El contrato destino ya tiene líneas y no se ha marcado la opción de reemplazarlas.');
    end;

    procedure DeleteTargetLines(TargetContractNo: Code[20])
    var
        TargetLine: Record "Lease Contract Line";
    begin
        TargetLine.SetRange("Contract No.", TargetContractNo);
        if not TargetLine.IsEmpty() then
            TargetLine.DeleteAll(true);
    end;

    procedure CopyHeaderFields(SourceHeader: Record "Lease Contract"; var TargetHeader: Record "Lease Contract")
    begin
        TargetHeader.Validate(Description, SourceHeader.Description);
        TargetHeader.Validate("Customer No.", SourceHeader."Customer No.");

        if SourceHeader."Second Customer No." <> '' then
            TargetHeader.Validate("Second Customer No.", SourceHeader."Second Customer No.")
        else
            TargetHeader."Second Customer No." := '';

        TargetHeader."Your Reference" := SourceHeader."Your Reference";

        if SourceHeader."Fixed Real Estate No." <> '' then
            TargetHeader.Validate("Fixed Real Estate No.", SourceHeader."Fixed Real Estate No.")
        else
            TargetHeader."Fixed Real Estate No." := '';

        TargetHeader."Invoice Period" := SourceHeader."Invoice Period";
        TargetHeader."Starting Date" := SourceHeader."Starting Date";
        TargetHeader."Expiration Date" := SourceHeader."Expiration Date";
        TargetHeader."Contract Date" := SourceHeader."Contract Date";

        if SourceHeader."Payment Method Code" <> '' then
            TargetHeader.Validate("Payment Method Code", SourceHeader."Payment Method Code")
        else
            TargetHeader."Payment Method Code" := '';

        if SourceHeader."Payment Terms Code" <> '' then
            TargetHeader.Validate("Payment Terms Code", SourceHeader."Payment Terms Code")
        else
            TargetHeader."Payment Terms Code" := '';

        TargetHeader."Lease Period" := SourceHeader."Lease Period";
        TargetHeader."Language Code" := SourceHeader."Language Code";
        TargetHeader."Preferred Bank Account Code" := SourceHeader."Preferred Bank Account Code";
        TargetHeader."Salesperson Code" := SourceHeader."Salesperson Code";
        TargetHeader."Contact No." := SourceHeader."Contact No.";
        TargetHeader."Second Contact No." := SourceHeader."Second Contact No.";
        TargetHeader."Notify Customer" := SourceHeader."Notify Customer";
        TargetHeader."Notify Customer 2" := SourceHeader."Notify Customer 2";
        TargetHeader."Amount Rental Deposit" := SourceHeader."Amount Rental Deposit";
        TargetHeader."Consumer Price Index Category" := SourceHeader."Consumer Price Index Category";
        TargetHeader."Generic Prod. Posting Gr." := SourceHeader."Generic Prod. Posting Gr.";
        TargetHeader."Grupo IRPF" := SourceHeader."Grupo IRPF";

        TargetHeader."Street Type Id." := SourceHeader."Street Type Id.";
        TargetHeader."Types Street Numbering Id." := SourceHeader."Types Street Numbering Id.";
        TargetHeader."Street Name" := SourceHeader."Street Name";
        TargetHeader."Number On Street" := SourceHeader."Number On Street";
        TargetHeader."Location Height Floor" := SourceHeader."Location Height Floor";
        TargetHeader."FRE Address" := SourceHeader."FRE Address";
        TargetHeader."FRE City" := SourceHeader."FRE City";
        TargetHeader."FRE County" := SourceHeader."FRE County";
        TargetHeader."FRE Post Code" := SourceHeader."FRE Post Code";
        TargetHeader."FRE Country/Region Code" := SourceHeader."FRE Country/Region Code";
        TargetHeader."FRE Property No." := SourceHeader."FRE Property No.";
        TargetHeader."Google URL" := SourceHeader."Google URL";

        TargetHeader.Modify(true);
    end;

    procedure CopyLines(SourceCompanyName: Text[30]; SourceContractNo: Code[20]; TargetContractNo: Code[20])
    var
        SourceLine: Record "Lease Contract Line";
        TargetLine: Record "Lease Contract Line";
        NextLineNo: Integer;
        IsHandled: Boolean;
    begin
        SourceLine.ChangeCompany(SourceCompanyName);
        SourceLine.SetRange("Contract No.", SourceContractNo);

        if not SourceLine.FindSet() then
            exit;

        NextLineNo := GetNextLineNo(TargetContractNo);

        repeat
            IsHandled := false;
            OnBeforeCopySingleLine(SourceLine, TargetLine, TargetContractNo, NextLineNo, IsHandled);

            if not IsHandled then begin
                TargetLine.Init();
                TargetLine."Contract No." := TargetContractNo;
                TargetLine."Line No." := NextLineNo;

                if SourceLine."Account No." <> '' then
                    TargetLine.Validate("Account No.", SourceLine."Account No.");
                TargetLine.Validate(Description, SourceLine.Description);

                TargetLine."Customer No." := SourceLine."Customer No.";
                TargetLine."Contract Status" := SourceLine."Contract Status";
                TargetLine."Contract Expiration Date" := SourceLine."Contract Expiration Date";
                TargetLine."Service Period" := SourceLine."Service Period";
                TargetLine.Value := SourceLine.Value;
                TargetLine.Amount := SourceLine.Amount;
                TargetLine."Starting Date" := SourceLine."Starting Date";
                TargetLine."Shortcut Dimension 1 Code" := SourceLine."Shortcut Dimension 1 Code";
                TargetLine."Shortcut Dimension 2 Code" := SourceLine."Shortcut Dimension 2 Code";
                TargetLine."Dimension Set ID" := SourceLine."Dimension Set ID";
                TargetLine."Aplicar incrementos" := SourceLine."Aplicar incrementos";
                TargetLine."Base Contract" := SourceLine."Base Contract";
                TargetLine."Aplicar Impuestos" := SourceLine."Aplicar Impuestos";
                TargetLine."Consumer Price Index Category" := SourceLine."Consumer Price Index Category";
                TargetLine.Year := SourceLine.Year;
                TargetLine."% Increment" := SourceLine."% Increment";
                TargetLine."CPI calculation amount" := SourceLine."CPI calculation amount";

                OnBeforeInsertTargetLine(SourceLine, TargetLine);
                TargetLine.Insert(true);
                OnAfterInsertTargetLine(SourceLine, TargetLine);
            end;

            NextLineNo += 10000;
        until SourceLine.Next() = 0;
    end;

    procedure ValidateMasterDataCompatibility(SourceHeader: Record "Lease Contract")
    var
        Customer: Record Customer;
        FixedRealEstate: Record "Fixed Real Estate";
    begin
        if (SourceHeader."Customer No." <> '') and (not Customer.Get(SourceHeader."Customer No.")) then
            Error('El cliente %1 del contrato origen no existe en la empresa destino.', SourceHeader."Customer No.");

        if (SourceHeader."Second Customer No." <> '') and (not Customer.Get(SourceHeader."Second Customer No.")) then
            Error('El segundo cliente %1 del contrato origen no existe en la empresa destino.', SourceHeader."Second Customer No.");

        if (SourceHeader."Fixed Real Estate No." <> '') and (not FixedRealEstate.Get(SourceHeader."Fixed Real Estate No.")) then
            Error('El activo inmobiliario %1 del contrato origen no existe en la empresa destino.', SourceHeader."Fixed Real Estate No.");
    end;

    local procedure GetNextLineNo(TargetContractNo: Code[20]): Integer
    var
        TargetLine: Record "Lease Contract Line";
    begin
        TargetLine.SetRange("Contract No.", TargetContractNo);
        if TargetLine.FindLast() then
            exit(TargetLine."Line No." + 10000);

        exit(10000);
    end;

    [IntegrationEvent(false, false)]
    local procedure OnBeforeCopySingleLine(SourceLine: Record "Lease Contract Line"; var TargetLine: Record "Lease Contract Line"; TargetContractNo: Code[20]; NextLineNo: Integer; var IsHandled: Boolean)
    begin
    end;

    [IntegrationEvent(false, false)]
    local procedure OnBeforeInsertTargetLine(SourceLine: Record "Lease Contract Line"; var TargetLine: Record "Lease Contract Line")
    begin
    end;

    [IntegrationEvent(false, false)]
    local procedure OnAfterInsertTargetLine(SourceLine: Record "Lease Contract Line"; TargetLine: Record "Lease Contract Line")
    begin
    end;
}
