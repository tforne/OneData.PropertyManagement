namespace OneData.Property.Lease;

page 96073 "OD Lease Invoice Test Results"
{
    PageType = List;
    SourceTable = "OD Lease Invoice Test Buffer";
    SourceTableTemporary = true;
    Caption = 'Lease Invoice Test Results';
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

                field(TotalCount; TotalCount)
                {
                    ApplicationArea = All;
                    Caption = 'Total';
                }
                field(ValidatedCount; ValidatedCount)
                {
                    ApplicationArea = All;
                    Caption = 'Validated';
                    Style = Favorable;
                }
                field(SkippedCount; SkippedCount)
                {
                    ApplicationArea = All;
                    Caption = 'Skipped';
                    Style = Ambiguous;
                }
                field(ErrorCount; ErrorCount)
                {
                    ApplicationArea = All;
                    Caption = 'Errors';
                    Style = Unfavorable;
                }
            }
            repeater(Results)
            {
                field("Contract No."; Rec."Contract No.")
                {
                    trigger OnDrillDown()
                    begin
                        OpenLeaseContract();
                    end;
                }
                field("Customer No."; Rec."Customer No.")
                {
                }
                field("Posting Date"; Rec.PostingDate)
                {
                }
                field("Invoice From"; Rec.InvoiceFrom)
                {
                }
                field("Invoice To"; Rec.InvoiceTo)
                {
                }
                field(Amount; Rec.TestAmount)
                {
                }
                field(Status; Rec.Status)
                {
                    StyleExpr = StatusStyle;
                }
                field("Combined Invoice Group"; Rec."Combined Invoice Group")
                {
                }
                field(Message; Rec.Message)
                {
                    StyleExpr = StatusStyle;
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

            action(ShowValidated)
            {
                ApplicationArea = All;
                Caption = 'Show Validated';
                Image = Approve;

                trigger OnAction()
                begin
                    Rec.Reset();
                    Rec.SetRange(Status, Rec.Status::Validated);
                    CurrPage.Update(false);
                end;
            }

            action(ShowSkipped)
            {
                ApplicationArea = All;
                Caption = 'Show Skipped';
                Image = ViewDetails;

                trigger OnAction()
                begin
                    Rec.Reset();
                    Rec.SetRange(Status, Rec.Status::Skipped);
                    CurrPage.Update(false);
                end;
            }

            action(ShowErrors)
            {
                ApplicationArea = All;
                Caption = 'Show Errors';
                Image = Error;

                trigger OnAction()
                begin
                    Rec.Reset();
                    Rec.SetRange(Status, Rec.Status::Error);
                    CurrPage.Update(false);
                end;
            }

            action(OpenContract)
            {
                ApplicationArea = All;
                Caption = 'Open Contract';
                Image = EditLines;

                trigger OnAction()
                begin
                    OpenLeaseContract();
                end;
            }
        }
    }

    trigger OnAfterGetRecord()
    begin
        case Rec.Status of
            Rec.Status::Validated:
                StatusStyle := 'Favorable';
            Rec.Status::Skipped:
                StatusStyle := 'Ambiguous';
            Rec.Status::Error:
                StatusStyle := 'Unfavorable';
        end;
    end;

    trigger OnOpenPage()
    begin
        UpdateSummary();
    end;

    var
        StatusStyle: Text;
        TotalCount: Integer;
        ValidatedCount: Integer;
        SkippedCount: Integer;
        ErrorCount: Integer;

    procedure LoadResults(var SourceResults: Record "OD Lease Invoice Test Buffer" temporary)
    begin
        Rec.Reset();
        Rec.DeleteAll();

        if SourceResults.FindSet() then
            repeat
                Rec := SourceResults;
                Rec.Insert();
            until SourceResults.Next() = 0;

        UpdateSummary();
    end;

    local procedure UpdateSummary()
    var
        TempResults: Record "OD Lease Invoice Test Buffer" temporary;
    begin
        TotalCount := 0;
        ValidatedCount := 0;
        SkippedCount := 0;
        ErrorCount := 0;

        TempResults.Copy(Rec, true);
        TempResults.Reset();
        if TempResults.FindSet() then
            repeat
                TotalCount += 1;
                case TempResults.Status of
                    TempResults.Status::Validated:
                        ValidatedCount += 1;
                    TempResults.Status::Skipped:
                        SkippedCount += 1;
                    TempResults.Status::Error:
                        ErrorCount += 1;
                end;
            until TempResults.Next() = 0;
    end;

    local procedure OpenLeaseContract()
    var
        LeaseContract: Record "Lease Contract";
    begin
        if Rec."Contract No." = '' then
            exit;

        if LeaseContract.Get(Rec."Contract No.") then
            Page.Run(Page::"Lease Contract Card", LeaseContract);
    end;
}
