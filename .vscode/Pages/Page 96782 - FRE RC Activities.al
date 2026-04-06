page 96782 "FRE RC Activities"
{
    PageType = CardPart;
    SourceTable = "FRE RC Cue";
    Caption = 'Activities';
    ApplicationArea = All;
    RefreshOnActivate = true;

    layout
    {
        area(content)
        {
            cuegroup(Overview)
            {
                Caption = 'Overview';

                field("Pending Statements"; Rec."Pending Statements")
                {

                    trigger OnDrillDown()
                    var
                        BankStatement: Record "FRE Bank Statement";
                    begin
                        BankStatement.SetRange(Status, BankStatement.Status::Pending);
                        Page.Run(Page::"FRE Bank Statements", BankStatement);
                    end;
                }

                field("Imported Statements"; Rec."Imported Statements")
                {

                    trigger OnDrillDown()
                    var
                        BankStatement: Record "FRE Bank Statement";
                    begin
                        BankStatement.SetRange(Status, BankStatement.Status::Imported);
                        Page.Run(Page::"FRE Bank Statements", BankStatement);
                    end;
                }

                field("Posted Statements"; Rec."Posted Statements")
                {

                    trigger OnDrillDown()
                    var
                        BankStatement: Record "FRE Bank Statement";
                    begin
                        BankStatement.SetRange(Status, BankStatement.Status::Posted);
                        Page.Run(Page::"FRE Bank Statements", BankStatement);
                    end;
                }

                field("Journal Lines"; Rec."Journal Lines")
                {

                    trigger OnDrillDown()
                    begin
                        Page.Run(Page::"FRE Journal Line");
                    end;
                }

                field("Ledger Entries"; Rec."Ledger Entries")
                {

                    trigger OnDrillDown()
                    begin
                        Page.Run(Page::"Movs. FRE");
                    end;
                }

                field("Property Assets"; Rec."Property Assets")
                {
                }

                field("Fixed Assets"; Rec."Fixed Assets")
                {
                }
            }
        }
    }

    trigger OnOpenPage()
    begin
        LoadCue();
    end;

    trigger OnAfterGetRecord()
    begin
        LoadCue();
    end;

    local procedure LoadCue()
    var
        BankStatement: Record "FRE Bank Statement";
        FREJnlLine: Record "FRE Jnl. Line";
        FRELedgerEntry: Record "FRE Ledger Entry";
        FixedRealEstate: Record "Fixed Real Estate";
    begin
        if not Rec.Get('DEFAULT') then begin
            Rec.Init();
            Rec."Primary Key" := 'DEFAULT';
            Rec.Insert();
        end;

        BankStatement.Reset();
        BankStatement.SetRange(Status, BankStatement.Status::Pending);
        Rec."Pending Statements" := BankStatement.Count();

        BankStatement.Reset();
        BankStatement.SetRange(Status, BankStatement.Status::Imported);
        Rec."Imported Statements" := BankStatement.Count();

        BankStatement.Reset();
        BankStatement.SetRange(Status, BankStatement.Status::Posted);
        Rec."Posted Statements" := BankStatement.Count();

        FREJnlLine.Reset();
        Rec."Journal Lines" := FREJnlLine.Count();

        FRELedgerEntry.Reset();
        Rec."Ledger Entries" := FRELedgerEntry.Count();

        FixedRealEstate.Reset();
        FixedRealEstate.SetRange("Type", FixedRealEstate."Type"::Propiedad);
        Rec."Property Assets" := FixedRealEstate.Count();

        FixedRealEstate.Reset();
        FixedRealEstate.SetRange("Type", FixedRealEstate."Type"::Activo);
        Rec."Fixed Assets" := FixedRealEstate.Count();

        Rec.Modify();
    end;
}