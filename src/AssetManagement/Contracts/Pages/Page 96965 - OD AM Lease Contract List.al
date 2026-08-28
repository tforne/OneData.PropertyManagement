page 96965 "OD AM Lease Contract List"
{
    PageType = List;
    SourceTable = "Lease Contract";
    Caption = 'Contratos alquiler Asset Management';
    ApplicationArea = All;
    UsageCategory = Lists;
    CardPageId = "OD AM Lease Contract Card";
    Editable = false;

    layout
    {
        area(Content)
        {
            repeater(Contracts)
            {
                field("Contract No."; Rec."Contract No.")
                {
                }
                field("Customer No."; Rec."Customer No.")
                {
                }
                field(Name; Rec.Name)
                {
                }
                field("Fixed Real Estate No."; Rec."Fixed Real Estate No.")
                {
                }
                field("FRE Property No."; Rec."FRE Property No.")
                {
                }
                field("Starting Date"; Rec."Starting Date")
                {
                }
                field("Expiration Date"; Rec."Expiration Date")
                {
                }
                field(Status; Rec.Status)
                {
                }
                field(NumberOfAssets; NumberOfAssets)
                {
                    Caption = 'Numero de activos';
                    Editable = false;
                }
                field(AvailabilityStatus; AvailabilityStatus)
                {
                    Caption = 'Estado disponibilidad';
                    Editable = false;
                }
            }
        }
    }

    actions
    {
        area(Processing)
        {
            action(InitializeContractUnits)
            {
                Caption = 'Inicializar activos contractuales';
                Image = Calculate;
                Promoted = true;
                PromotedCategory = Process;

                trigger OnAction()
                var
                    UpgradeMgt: Codeunit "OD AM Contract Unit Upgrade";
                    CreatedCount: Integer;
                begin
                    CreatedCount := UpgradeMgt.EnsurePrincipalUnitsForAllContracts();
                    Message(ContractUnitsInitializedMsg, CreatedCount);
                    CurrPage.Update(false);
                end;
            }
            action(OpenPropertyStructure)
            {
                Caption = 'Abrir estructura';
                Image = Hierarchy;
                Promoted = true;
                PromotedCategory = Process;

                trigger OnAction()
                var
                    AssetStructurePage: Page "OD AM Asset Structure";
                begin
                    if Rec."FRE Property No." = '' then
                        exit;

                    AssetStructurePage.SetSelectedProperty(Rec."FRE Property No.");
                    AssetStructurePage.Run();
                end;
            }
            action(RepairLeaseContractLines)
            {
                Caption = 'Reparar lineas de inmuebles';
                Image = RefreshLines;
                Promoted = true;
                PromotedCategory = Process;

                trigger OnAction()
                var
                    ContractAssetMgt: Codeunit "OD AM Contract Asset Mgt.";
                    LeaseContract: Record "Lease Contract";
                    RepairedLineCount: Integer;
                    RepairedContractCount: Integer;
                begin
                    CurrPage.SetSelectionFilter(LeaseContract);
                    RepairedLineCount := ContractAssetMgt.RepairLeaseContractLinesForSelection(LeaseContract, RepairedContractCount);
                    Message(LeaseLinesRepairMsg, RepairedLineCount, RepairedContractCount);
                    CurrPage.Update(false);
                end;
            }
        }
    }

    trigger OnAfterGetRecord()
    var
        ContractAssetMgt: Codeunit "OD AM Contract Asset Mgt.";
        OccupancyMgt: Codeunit "OD AM Occupancy Mgt.";
    begin
        NumberOfAssets := ContractAssetMgt.GetAssetCount(Rec."Contract No.");
        AvailabilityStatus := CopyStr(OccupancyMgt.EvaluateContractAvailabilityStatus(Rec."Contract No."), 1, MaxStrLen(AvailabilityStatus));
    end;

    var
        NumberOfAssets: Integer;
        AvailabilityStatus: Text[50];
        ContractUnitsInitializedMsg: Label 'Se han creado o sincronizado %1 activos principales legacy.';
        LeaseLinesRepairMsg: Label 'Se han reparado %1 lineas economicas en %2 contratos.';
}
