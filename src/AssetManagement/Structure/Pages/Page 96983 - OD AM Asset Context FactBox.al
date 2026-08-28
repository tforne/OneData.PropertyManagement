page 96983 "OD AM Asset Context FB"
{
    PageType = CardPart;
    SourceTable = "Fixed Real Estate";
    Caption = 'Contexto del activo';
    ApplicationArea = All;
    Editable = false;

    layout
    {
        area(Content)
        {
            group(Overview)
            {
                Caption = 'Seleccion';

                field(ContextAssetNo; ContextAssetNo)
                {
                    Caption = 'Activo';
                }
                field(ContextDescription; ContextDescription)
                {
                    Caption = 'Descripcion';
                }
                field(ContextAssetType; ContextAssetType)
                {
                    Caption = 'Tipo Asset Management';
                }
                field(ContextPropertyNo; ContextPropertyNo)
                {
                    Caption = 'Propiedad raiz';
                }
                field(ContextParentAssetNo; ContextParentAssetNo)
                {
                    Caption = 'Activo padre';
                }
                field(ContextStatus; ContextStatus)
                {
                    Caption = 'Estado';
                }
            }
            group(Occupancy)
            {
                Caption = 'Ocupacion';

                field(OccupancyStatus; OccupancyStatus)
                {
                    Caption = 'Estado ocupacion';
                }
                field(OccupancyPercentage; OccupancyPercentage)
                {
                    Caption = '% ocupacion';
                }
                field(CurrentContractNo; CurrentContractNo)
                {
                    Caption = 'Contrato actual';
                }
                field(CurrentCustomerNo; CurrentCustomerNo)
                {
                    Caption = 'Cliente';
                }
                field(CurrentStartingDate; CurrentStartingDate)
                {
                    Caption = 'Inicio contrato';
                }
                field(CurrentEndingDate; CurrentEndingDate)
                {
                    Caption = 'Fin contrato';
                }
            }
        }
    }

    var
        ContextAssetNo: Code[20];
        ContextDescription: Text[100];
        ContextAssetType: Text[50];
        ContextPropertyNo: Code[20];
        ContextParentAssetNo: Code[20];
        ContextStatus: Text[50];
        OccupancyStatus: Text[50];
        OccupancyPercentage: Decimal;
        CurrentContractNo: Code[20];
        CurrentCustomerNo: Code[20];
        CurrentStartingDate: Date;
        CurrentEndingDate: Date;

    procedure SetContext(FixedRealEstateNo: Code[20])
    var
        FixedRealEstate: Record "Fixed Real Estate";
        LeaseContract: Record "Lease Contract";
        OccupancyMgt: Codeunit "OD AM Occupancy Mgt.";
        AssetStructureMgt: Codeunit "OD AM Asset Structure Mgt.";
    begin
        Clear(ContextAssetNo);
        Clear(ContextDescription);
        Clear(ContextAssetType);
        Clear(ContextPropertyNo);
        Clear(ContextParentAssetNo);
        Clear(ContextStatus);
        Clear(OccupancyStatus);
        Clear(OccupancyPercentage);
        Clear(CurrentContractNo);
        Clear(CurrentCustomerNo);
        Clear(CurrentStartingDate);
        Clear(CurrentEndingDate);

        if (FixedRealEstateNo = '') or (not FixedRealEstate.Get(FixedRealEstateNo)) then begin
            CurrPage.Update(false);
            exit;
        end;

        ContextAssetNo := FixedRealEstate."No.";
        ContextDescription := FixedRealEstate.Description;
        ContextAssetType := Format(FixedRealEstate."OD Asset Type");
        if FixedRealEstate.Type = FixedRealEstate.Type::Propiedad then
            ContextPropertyNo := FixedRealEstate."No."
        else
            if FixedRealEstate."Property No." <> '' then
                ContextPropertyNo := FixedRealEstate."Property No."
            else
                ContextPropertyNo := AssetStructureMgt.GetRootProperty(FixedRealEstate."No.");
        ContextParentAssetNo := FixedRealEstate."OD Parent FRE No.";
        ContextStatus := Format(FixedRealEstate.Status);

        OccupancyStatus := Format(OccupancyMgt.GetOccupancyStatus(FixedRealEstate."No.", WorkDate()));
        OccupancyPercentage := OccupancyMgt.GetOccupancyPercentage(FixedRealEstate."No.", WorkDate());

        if OccupancyMgt.GetBlockingContractForAsset(FixedRealEstate."No.", WorkDate(), LeaseContract) then begin
            CurrentContractNo := LeaseContract."Contract No.";
            CurrentCustomerNo := LeaseContract."Customer No.";
            CurrentStartingDate := LeaseContract."Starting Date";
            CurrentEndingDate := LeaseContract."Expiration Date";
        end;

        CurrPage.Update(false);
    end;
}
