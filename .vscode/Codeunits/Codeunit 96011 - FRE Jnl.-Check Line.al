codeunit 96011 "FRE Jnl.-Check Line"
{
    TableNo = "FRE Jnl. Line";

    trigger OnRun()
    begin
        RunCheck(Rec);
    end;

    var
        REFSetup: Record "REF Setup";
        LogErrorMode: Boolean;
        TempErrorMessage: Record "Error Message" temporary;
        ErrorMessageMgt: Codeunit "Error Message Management";
        Text000: Label 'can only be a closing date for G/L entries';

    procedure RunCheck(var FREJnlLine: Record "FRE Jnl. Line")
    var
        ErrorMessageHandler: Codeunit "Error Message Handler";
        ErrorContextElement: Codeunit "Error Context Element";
        IsHandled: Boolean;
    begin
        IsHandled := false;
        if IsHandled then
            exit;

        if LogErrorMode then begin
            ErrorMessageMgt.Activate(ErrorMessageHandler);
            ErrorMessageMgt.PushContext(ErrorContextElement, FREJnlLine.RecordId, 0, '');
        end;      
        
        REFSetup.Get();
        if FREJnlLine.EmptyLine() then
            exit;
        CheckDates(FREJnlLine);

        TestDocumentNo(FREJnlLine);
        CheckZeroAmount(FREJnlLine);

        if LogErrorMode then
            ErrorMessageMgt.GetErrors(TempErrorMessage);
    end;

    procedure DateNotAllowed(PostingDate: Date): Boolean
    var
        SetupRecordID: RecordID;
    begin
        exit(IsDateNotAllowed(PostingDate, SetupRecordID));
    end;
    procedure IsDateNotAllowed(PostingDate: Date; var SetupRecordID: RecordID) DateIsNotAllowed: Boolean
    var
        UserSetupManagement: Codeunit "User Setup Management";
        IsHandled: Boolean;
    begin
        IsHandled := false;
        if IsHandled then
            exit;

        DateIsNotAllowed := not UserSetupManagement.IsPostingDateValidWithSetup(PostingDate, SetupRecordID);
        exit(DateIsNotAllowed);
    end;
    
    local procedure CheckDates(FREJnlLine: Record "FRE Jnl. Line")
    var
        AccountingPeriodMgt: Codeunit "Accounting Period Mgt.";
        DateCheckDone: Boolean;
        IsHandled: Boolean;
    begin
        FREJnlLine.TestField("Date", ErrorInfo.Create());
        if FREJnlLine."Date" <> NormalDate(FREJnlLine."Date") then begin
            FREJnlLine.FieldError("Date", ErrorInfo.Create(Text000, true));
        end;      
    end;

    local procedure TestDocumentNo(var FREJournalLine: Record "FRE Jnl. Line")
    var
        IsHandled: Boolean;
    begin
        IsHandled := false;
        if IsHandled then
            exit;
        FREJournalLine.TestField("Document No.", ErrorInfo.Create());
    end;

    local procedure CheckZeroAmount(var FREJnlLine: Record "FRE Jnl. Line")
    begin
        FREJnlLine.TestField(Amount, ErrorInfo.Create());
    end;
}