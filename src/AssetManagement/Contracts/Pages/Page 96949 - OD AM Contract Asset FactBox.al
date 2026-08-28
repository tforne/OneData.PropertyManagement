page 96949 "OD AM Contract Asset FactBox"
{
    PageType = CardPart;
    SourceTable = "Lease Contract";
    Caption = 'Resumen activos contrato';
    ApplicationArea = All;

    layout
    {
        area(Content)
        {
            group(Overview)
            {
                Caption = 'Resumen';

                field(AssetCount; AssetCount)
                {
                    Caption = 'Activos';
                    Editable = false;
                }
                field(PrincipalAssetNo; PrincipalAssetNo)
                {
                    Caption = 'Activo principal';
                    Editable = false;
                }
                field(PropertyNo; PropertyNo)
                {
                    Caption = 'Propiedad';
                    Editable = false;
                }
                field(AssetTypesSummary; AssetTypesSummary)
                {
                    Caption = 'Tipos';
                    Editable = false;
                    MultiLine = true;
                }
            }
        }
    }

    trigger OnAfterGetCurrRecord()
    begin
        LoadSummary();
    end;

    var
        AssetCount: Integer;
        PrincipalAssetNo: Code[20];
        PropertyNo: Code[20];
        AssetTypesSummary: Text;

    local procedure LoadSummary()
    var
        ContractAssetMgt: Codeunit "OD AM Contract Asset Mgt.";
        FixedRealEstate: Record "Fixed Real Estate";
        DwellingCount: Integer;
        RoomCount: Integer;
        ParkingCount: Integer;
        StorageCount: Integer;
    begin
        Clear(AssetCount);
        Clear(PrincipalAssetNo);
        Clear(PropertyNo);
        Clear(AssetTypesSummary);

        if Rec."Contract No." = '' then
            exit;

        ContractAssetMgt.GetContractAssetStatistics(Rec."Contract No.", AssetCount, DwellingCount, RoomCount, ParkingCount, StorageCount);
        AssetTypesSummary := ContractAssetMgt.GetAssetTypesSummary(Rec."Contract No.");

        if ContractAssetMgt.GetPrincipalAsset(Rec."Contract No.", FixedRealEstate) then begin
            PrincipalAssetNo := FixedRealEstate."No.";
            if FixedRealEstate."Property No." <> '' then
                PropertyNo := FixedRealEstate."Property No."
            else
                PropertyNo := Rec."FRE Property No.";
        end else
            PropertyNo := Rec."FRE Property No.";
    end;
}
