page 96942 "OD AM Property Asset FactBox"
{
    PageType = CardPart;
    SourceTable = "Fixed Real Estate";
    Caption = 'Resumen de activos';
    ApplicationArea = All;
    Editable = false;

    layout
    {
        area(Content)
        {
            group(Counts)
            {
                Caption = 'Conteo';

                field(TotalAssets; TotalAssets)
                {
                    Caption = 'Activos';
                }
                field(TotalDwellings; TotalDwellings)
                {
                    Caption = 'Viviendas';
                }
                field(TotalRooms; TotalRooms)
                {
                    Caption = 'Habitaciones';
                }
                field(TotalParkings; TotalParkings)
                {
                    Caption = 'Parkings';
                }
                field(TotalStorages; TotalStorages)
                {
                    Caption = 'Trasteros';
                }
            }
        }
    }

    trigger OnAfterGetRecord()
    begin
        RefreshCounts();
    end;

    var
        TotalAssets: Integer;
        TotalDwellings: Integer;
        TotalRooms: Integer;
        TotalParkings: Integer;
        TotalStorages: Integer;
        ContextPropertyNo: Code[20];
        UseAllProperties: Boolean;
        ContextInitialized: Boolean;

    local procedure RefreshCounts()
    var
        FixedRealEstate: Record "Fixed Real Estate";
        PropertyNo: Code[20];
    begin
        Clear(TotalAssets);
        Clear(TotalDwellings);
        Clear(TotalRooms);
        Clear(TotalParkings);
        Clear(TotalStorages);

        if UseAllProperties then begin
            FixedRealEstate.SetRange(Type, FixedRealEstate.Type::Activo);
            if FixedRealEstate.FindSet() then
                repeat
                    TotalAssets += 1;
                    case FixedRealEstate."OD Asset Type" of
                        FixedRealEstate."OD Asset Type"::Dwelling:
                            TotalDwellings += 1;
                        FixedRealEstate."OD Asset Type"::Room:
                            TotalRooms += 1;
                        FixedRealEstate."OD Asset Type"::Parking:
                            TotalParkings += 1;
                        FixedRealEstate."OD Asset Type"::Storage:
                            TotalStorages += 1;
                    end;
                until FixedRealEstate.Next() = 0;
            exit;
        end;

        if ContextPropertyNo <> '' then
            PropertyNo := ContextPropertyNo
        else
            if ContextInitialized then
                exit;

        if (PropertyNo = '') and (Rec."No." <> '') then
            if Rec.Type = Rec.Type::Propiedad then
                PropertyNo := Rec."No."
            else
                PropertyNo := Rec."Property No.";

        if PropertyNo = '' then
            exit;

        FixedRealEstate.SetRange(Type, FixedRealEstate.Type::Activo);
        FixedRealEstate.SetRange("Property No.", PropertyNo);
        if FixedRealEstate.FindSet() then
            repeat
                TotalAssets += 1;
                case FixedRealEstate."OD Asset Type" of
                    FixedRealEstate."OD Asset Type"::Dwelling:
                        TotalDwellings += 1;
                    FixedRealEstate."OD Asset Type"::Room:
                        TotalRooms += 1;
                    FixedRealEstate."OD Asset Type"::Parking:
                        TotalParkings += 1;
                    FixedRealEstate."OD Asset Type"::Storage:
                        TotalStorages += 1;
                end;
            until FixedRealEstate.Next() = 0;
    end;

    procedure SetPropertyFilterContext(PropertyNo: Code[20])
    begin
        ContextInitialized := true;
        ContextPropertyNo := PropertyNo;
        UseAllProperties := PropertyNo = '';
        RefreshCounts();
        CurrPage.Update(false);
    end;
}
