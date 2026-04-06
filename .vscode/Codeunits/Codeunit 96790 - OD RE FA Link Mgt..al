codeunit 96790 "OD RE FA Link Mgt."
{
    procedure CreateExclusiveFAForRealEstate(var RE: Record "Fixed Real Estate")
    var
        FA: Record "Fixed Asset";
        NoSeriesMgt: Codeunit "No. Series";
    begin
        ValidateNoActiveLinks(RE."No.");

        FA.Init();
        FA."No." := NoSeriesMgt.GetNextNo('FA', Today(), true);
        FA.Description := RE.Description;
        FA.Insert(true);

        CreateLink(RE."No.", FA."No.", Enum::"OD RE FA Link Type"::Exclusive, true, 100);
    end;

    procedure LinkExistingFA(RE: Record "Fixed Real Estate"; FANo: Code[20]; LinkType: Enum "OD RE FA Link Type"; Primary: Boolean; Allocation: Decimal)
    begin
        ValidateLink(RE."No.", FANo, LinkType, Primary, Allocation);
        CreateLink(RE."No.", FANo, LinkType, Primary, Allocation);
    end;

    procedure CreateLink(RENo: Code[20]; FANo: Code[20]; LinkType: Enum "OD RE FA Link Type"; Primary: Boolean; Allocation: Decimal)
    var
        Link: Record "OD RE FA Link";
    begin
        Link.Init();
        Link."Real Estate No." := RENo;
        Link."FA No." := FANo;
        Link."Link Type" := LinkType;
        Link."Primary Link" := Primary;
        Link."Allocation %" := Allocation;
        Link.Active := true;
        Link."Starting Date" := Today();
        Link.Insert(true);
    end;

    procedure ValidateNoActiveLinks(RENo: Code[20])
    var
        Link: Record "OD RE FA Link";
    begin
        Link.SetRange("Real Estate No.", RENo);
        Link.SetRange(Active, true);
        if not Link.IsEmpty() then
            Error('Ya existen vínculos activos para este inmueble.');
    end;

    procedure ValidateLink(RENo: Code[20]; FANo: Code[20]; LinkType: Enum "OD RE FA Link Type"; Primary: Boolean; Allocation: Decimal)
    begin
        if LinkType = LinkType::Exclusive then
            ValidateExclusive(RENo, FANo);

        if LinkType = LinkType::Shared then
            ValidateShared(FANo, Primary, Allocation);
    end;

    local procedure ValidateExclusive(RENo: Code[20]; FANo: Code[20])
    var
        Link: Record "OD RE FA Link";
    begin
        Link.SetRange("Real Estate No.", RENo);
        Link.SetRange(Active, true);
        if not Link.IsEmpty() then
            Error('El inmueble ya tiene un vínculo.');

        Link.Reset();
        Link.SetRange("FA No.", FANo);
        Link.SetRange(Active, true);
        if not Link.IsEmpty() then
            Error('El activo fijo ya está vinculado.');
    end;

    local procedure ValidateShared(FANo: Code[20]; Primary: Boolean; Allocation: Decimal)
    var
        Link: Record "OD RE FA Link";
        Total: Decimal;
    begin
        if Primary then begin
            Link.SetRange("FA No.", FANo);
            Link.SetRange("Primary Link", true);
            Link.SetRange(Active, true);
            if not Link.IsEmpty() then
                Error('Ya existe un vínculo principal para este activo fijo.');
        end;

        Total := GetAllocation(FANo);
        if Total + Allocation > 100 then
            Error('La suma de porcentajes supera el 100.');
    end;

    procedure GetAllocation(FANo: Code[20]): Decimal
    var
        Link: Record "OD RE FA Link";
        Total: Decimal;
    begin
        Link.SetRange("FA No.", FANo);
        Link.SetRange(Active, true);
        if Link.FindSet() then
            repeat
                Total += Link."Allocation %";
            until Link.Next() = 0;

        exit(Total);
    end;
}