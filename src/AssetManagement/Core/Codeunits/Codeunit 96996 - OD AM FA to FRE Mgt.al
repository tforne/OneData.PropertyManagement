codeunit 96996 "OD AM FA to FRE Mgt."
{
    var
        MultipleLinksErr: Label 'El activo fijo %1 ya tiene varios activos inmobiliarios activos vinculados. Revise los vínculos antes de crear uno nuevo.';

    procedure OpenOrCreateRealEstateFromFixedAsset(var FixedAsset: Record "Fixed Asset")
    var
        FixedRealEstate: Record "Fixed Real Estate";
    begin
        FixedRealEstate := GetOrCreateRealEstateFromFixedAsset(FixedAsset);
        Page.Run(Page::"Fixed Real Estate Card", FixedRealEstate);
    end;

    procedure GetOrCreateRealEstateFromFixedAsset(var FixedAsset: Record "Fixed Asset"): Record "Fixed Real Estate"
    var
        RealEstateLink: Record "OD RE FA Link";
        FixedRealEstate: Record "Fixed Real Estate";
        LinkMgt: Codeunit "OD RE FA Link Mgt.";
    begin
        FixedAsset.TestField("No.");

        RealEstateLink.SetRange("FA No.", FixedAsset."No.");
        RealEstateLink.SetRange(Active, true);
        if RealEstateLink.FindFirst() then begin
            if RealEstateLink.Count > 1 then
                Error(MultipleLinksErr, FixedAsset."No.");

            FixedRealEstate.Get(RealEstateLink."Real Estate No.");
            exit(FixedRealEstate);
        end;

        FixedRealEstate.Init();
        FixedRealEstate.Validate(Type, FixedRealEstate.Type::Activo);
        FixedRealEstate.Validate(Description, CopyStr(FixedAsset.Description, 1, MaxStrLen(FixedRealEstate.Description)));
        FixedRealEstate.Insert(true);

        LinkMgt.CreateLink(FixedRealEstate."No.", FixedAsset."No.", Enum::"OD RE FA Link Type"::Exclusive, true, 100);
        exit(FixedRealEstate);
    end;
}
