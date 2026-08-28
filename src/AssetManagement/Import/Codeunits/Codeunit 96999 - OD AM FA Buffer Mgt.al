codeunit 96999 "OD AM FA Buffer Mgt."
{
    var
        FixedAssetBatchLbl: Label 'Generado desde activos fijos';
        GeneratedBatchLbl: Label 'Se ha generado el lote %1 desde %2 activos fijos.';
        AssetStructureMgt: Codeunit "OD AM Asset Structure Mgt.";

    procedure CreateBatchFromFixedAssets(var FixedAsset: Record "Fixed Asset"): Guid
    begin
        exit(CreateBatchFromFixedAssetsForProperty(FixedAsset, ''));
    end;

    procedure CreateBatchFromFixedAssetsForProperty(var FixedAsset: Record "Fixed Asset"; PropertyNo: Code[20]): Guid
    var
        ImportLine: Record "OD AM Asset Import";
        BatchId: Guid;
        EmptyGuid: Guid;
        RowNo: Integer;
        InsertedCount: Integer;
        LinePropertyNo: Code[20];
    begin
        if not FixedAsset.FindSet() then
            exit(EmptyGuid);

        BatchId := CreateGuid();
        RowNo := 2;

        repeat
            ImportLine.Init();
            ImportLine."Import Batch ID" := BatchId;
            ImportLine."Excel Row No." := RowNo;
            ImportLine."File Name" := CopyStr(FixedAssetBatchLbl, 1, MaxStrLen(ImportLine."File Name"));
            ImportLine.Status := ImportLine.Status::Pending;
            ImportLine."External Asset ID" := FixedAsset."No.";
            ImportLine."FA No." := FixedAsset."No.";
            LinePropertyNo := PropertyNo;
            if LinePropertyNo = '' then
                LinePropertyNo := ResolvePropertyNoFromFixedAsset(FixedAsset."No.");
            ImportLine."Property No." := LinePropertyNo;
            ImportLine.Description := CopyStr(FixedAsset.Description, 1, MaxStrLen(ImportLine.Description));
            ImportLine."Asset Type Text" := 'Asset';
            ImportLine.Insert(true);
            RowNo += 1;
            InsertedCount += 1;
        until FixedAsset.Next() = 0;

        Message(GeneratedBatchLbl, BatchId, InsertedCount);
        exit(BatchId);
    end;

    local procedure ResolvePropertyNoFromFixedAsset(FixedAssetNo: Code[20]): Code[20]
    var
        RealEstateLink: Record "OD RE FA Link";
    begin
        if FixedAssetNo = '' then
            exit('');

        RealEstateLink.SetRange("FA No.", FixedAssetNo);
        RealEstateLink.SetRange(Active, true);
        if not RealEstateLink.FindFirst() then
            exit('');

        exit(AssetStructureMgt.GetRootProperty(RealEstateLink."Real Estate No."));
    end;
}
