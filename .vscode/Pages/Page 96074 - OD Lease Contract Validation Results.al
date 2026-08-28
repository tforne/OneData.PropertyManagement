page 96074 "OD Lease Ctr. Val. Results"
{
    PageType = List;
    SourceTable = 96044;
    SourceTableTemporary = true;
    Caption = 'Lease Contract Validation Results';
    ApplicationArea = All;
    UsageCategory = Lists;
    Editable = false;

    layout
    {
        area(content)
        {
            group(Summary)
            {
                Caption = 'Summary';

                field(ContractNo; ContractNo)
                {
                    ApplicationArea = All;
                    Caption = 'Contract No.';
                }
                field(TotalCount; TotalCount)
                {
                    ApplicationArea = All;
                    Caption = 'Issues';
                }
                field(HeaderCount; HeaderCount)
                {
                    ApplicationArea = All;
                    Caption = 'Header';
                }
                field(LineCount; LineCount)
                {
                    ApplicationArea = All;
                    Caption = 'Lines';
                }
                field(AmountCount; AmountCount)
                {
                    ApplicationArea = All;
                    Caption = 'Amounts';
                }
            }
            repeater(Issues)
            {
                field("Issue Type"; Rec."Issue Type")
                {
                    StyleExpr = IssueStyle;
                }
                field("Related Line No."; Rec."Related Line No.")
                {
                }
                field(Message; Rec.Message)
                {
                    StyleExpr = IssueStyle;
                }
            }
        }
    }

    actions
    {
        area(Processing)
        {
            action(ShowAll)
            {
                ApplicationArea = All;
                Caption = 'Show All';
                Image = ClearFilter;

                trigger OnAction()
                begin
                    Rec.Reset();
                    CurrPage.Update(false);
                end;
            }

            action(ShowHeader)
            {
                ApplicationArea = All;
                Caption = 'Show Header';
                Image = ViewDetails;

                trigger OnAction()
                begin
                    Rec.Reset();
                    Rec.SetRange("Issue Type", Rec."Issue Type"::Header);
                    CurrPage.Update(false);
                end;
            }

            action(ShowLines)
            {
                ApplicationArea = All;
                Caption = 'Show Lines';
                Image = ViewDetails;

                trigger OnAction()
                begin
                    Rec.Reset();
                    Rec.SetRange("Issue Type", Rec."Issue Type"::Line);
                    CurrPage.Update(false);
                end;
            }

            action(ShowAmounts)
            {
                ApplicationArea = All;
                Caption = 'Show Amounts';
                Image = Calculate;

                trigger OnAction()
                begin
                    Rec.Reset();
                    Rec.SetRange("Issue Type", Rec."Issue Type"::Amount);
                    CurrPage.Update(false);
                end;
            }
        }
    }

    trigger OnAfterGetRecord()
    begin
        case Rec."Issue Type" of
            Rec."Issue Type"::Header:
                IssueStyle := 'Ambiguous';
            Rec."Issue Type"::Line:
                IssueStyle := 'Attention';
            Rec."Issue Type"::Amount:
                IssueStyle := 'Unfavorable';
            else
                IssueStyle := 'Standard';
        end;
    end;

    trigger OnOpenPage()
    begin
        UpdateSummary();
    end;

    var
        ContractNo: Code[20];
        IssueStyle: Text;
        TotalCount: Integer;
        HeaderCount: Integer;
        LineCount: Integer;
        AmountCount: Integer;
        GeneralCount: Integer;

    procedure LoadResults(var SourceResults: Record 96044 temporary)
    begin
        Rec.Reset();
        Rec.DeleteAll();
        Clear(ContractNo);

        if SourceResults.FindSet() then
            repeat
                Rec := SourceResults;
                if ContractNo = '' then
                    ContractNo := Rec."Contract No.";
                Rec.Insert();
            until SourceResults.Next() = 0;

        UpdateSummary();
    end;

    local procedure UpdateSummary()
    var
        TempResults: Record 96044 temporary;
    begin
        TotalCount := 0;
        HeaderCount := 0;
        LineCount := 0;
        AmountCount := 0;
        GeneralCount := 0;

        TempResults.Copy(Rec, true);
        TempResults.Reset();
        if TempResults.FindSet() then
            repeat
                TotalCount += 1;
                case TempResults."Issue Type" of
                    TempResults."Issue Type"::General:
                        GeneralCount += 1;
                    TempResults."Issue Type"::Header:
                        HeaderCount += 1;
                    TempResults."Issue Type"::Line:
                        LineCount += 1;
                    TempResults."Issue Type"::Amount:
                        AmountCount += 1;
                end;
            until TempResults.Next() = 0;
    end;
}
