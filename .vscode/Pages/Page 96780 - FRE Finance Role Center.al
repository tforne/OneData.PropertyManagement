page 96780 "FRE Finance Role Center"
{
    PageType = RoleCenter;
    Caption = 'OneData Operations';
    ApplicationArea = All;
    UsageCategory = None;

    layout
    {
        area(rolecenter)
        {
            part(Headline; "FRE RC Headline")
            {
            }
            part(Activities; "FRE RC Activities")
            {
            }
            part(FRELedgerEntries; "FRE Ledger Entry ListPart")
            {
            }
            part("Account Manager Activities"; 9030)
            {
            }
        }
    }

    actions
    {
        area(embedding)
        {
            action(BankStatements)
            {
                Caption = 'Bank Statements';
                RunObject = page "FRE Bank Statements";
            }

            action(FREJournal)
            {
                Caption = 'FRE Journal';
                RunObject = page "FRE Journal Line";
            }

            action(FREMovs)
            {
                Caption = 'FRE Movs.';
                RunObject = page "Movs. FRE";
            }

            action(FixedRealEstate)
            {
                Caption = 'Fixed Real Estate';
                RunObject = page "Fixed Real Estate List";
            }
        }

        area(sections)
        {
            group(Operations)
            {
                Caption = 'Operations';

                action(OpenBankStatements)
                {
                    Caption = 'Bank Statements';
                    Image = Bank;
                    RunObject = page "FRE Bank Statements";
                }

                action(OpenFREJournal)
                {
                    Caption = 'FRE Journal';
                    Image = Journals;
                    RunObject = page "FRE Journal Line";
                }

                action(OpenFREMovs)
                {
                    Caption = 'FRE Movs.';
                    Image = LedgerEntries;
                    RunObject = page "Movs. FRE";
                }
            }

            group(MasterData)
            {
                Caption = 'Master Data';

                action(OpenFixedRealEstate)
                {
                    Caption = 'Fixed Real Estate';
                    Image = FixedAssets;
                    RunObject = page "Fixed Real Estate List";
                }

                action(OpenExcelTemplateSetup)
                {
                    Caption = 'Excel Template Setup';
                    Image = Setup;
                    RunObject = page "FRE Excel Template Setup";
                }
            }
        }

        area(processing)
        {
            group(Process)
            {
                Caption = 'Process';

                action(OpenBankStatements2)
                {
                    Caption = 'Open Bank Statements';
                    Image = Bank;
                    RunObject = page "FRE Bank Statements";
                }

                action(OpenFREJournal2)
                {
                    Caption = 'Open FRE Journal';
                    Image = Journals;
                    RunObject = page "FRE Journal Line";
                }

                action(OpenFREMovs2)
                {
                    Caption = 'Open FRE Movs.';
                    Image = LedgerEntries;
                    RunObject = page "Movs. FRE";
                }
            }
        }
    }
}