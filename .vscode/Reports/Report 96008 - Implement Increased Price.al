report 96008 "Implement Increased Price"
{
    Caption = 'Implement Price Change';
    ProcessingOnly = true;
    ApplicationArea = All;

    dataset
    {
        dataitem("Price Increases by Refer index"; "Price Increases by Refer index")
        {
            RequestFilterFields = "Contact No.";

            trigger OnAfterGetRecord()
            begin
                Window.Update(1, "Contract No.");
                Window.Update(2, "Starting Date");

                LeaseContract.get("Price Increases by Refer index"."Contract No.");
                LeaseContract.TestField("Consumer Price Index Category");
                InvoicedAmount := 0;
                LeaseContractLine.RESET;
                LeaseContractLine.SETRANGE("Contract No.",LeaseContract."Contract No.");
                LeaseContractLine.SETRANGE("Aplicar incrementos",TRUE);
                IF LeaseContractLine.FINDFIRST THEN REPEAT
                    InvoicedAmount := InvoicedAmount + LeaseContractLine.Amount;
                UNTIL LeaseContractLine.NEXT = 0;
                IF InvoicedAmount = 0 THEN
                    CurrReport.SKIP;
                LeaseContractLine.CreateLineIPC(LeaseContract,"Price Increases by Refer index"."Starting Date Increment",Year,InvoicedAmount);

                // Modify the Lease Contract Import
                LeaseContract."Amount per Period" := RealEstateMangement.CalcContractAmount(LeaseContract, LeaseContract."Starting Date", LeaseContract."Expiration Date");
                LeaseContract."Annual Amount" := LeaseContract."Amount per Period" * 12;
                LeaseContract.MODIFY();
            end;

            trigger OnPostDataItem()
            var
                ConfirmManagement: Codeunit "Confirm Management";
            begin
                Commit();
                if not DeleteWhstLine then
                    DeleteWhstLine := ConfirmManagement.GetResponseOrDefault(Text005, true);
                if DeleteWhstLine then
                    DeleteAll();
                Commit();
                
            end;

            trigger OnPreDataItem()
            begin
                if _year = 0 then
                    Error('Year must be specified.');
                Window.Open(
                  Text000 +
                  Text007 +
                  Text011);
            end;
        }
    }

    requestpage
    {

        layout
        {
            area(content)
            {
                group(Group)
                {
                    Caption = 'Options';
                    field(year; _year)
                    {
                        Caption = 'Year';
                        ToolTip = 'Specifies the year for which the price increase is to be implemented.';
                    }
                }   
            }
        }
    }

    labels
    {
    }
    var
        LeaseContract: Record "Lease Contract";
        LeaseContractLine: Record "Lease Contract Line";
        RealEstateMangement: Codeunit "Real Estate Management";
        Window: Dialog;
        DeleteWhstLine: Boolean;
        InvoicedAmount: Decimal;
        _year: Integer;

        Text000: Label 'Updating Contract Prices...\\';
        Text005: Label 'The contract prices have now been updated in accordance with the suggested price changes.\\Do you want to delete the suggested price changes?';
        Text007: Label 'Contract No.           #1##########\';
        Text011: Label 'Starting Date          #2######';

    procedure InitializeRequest(NewDeleteWhstLine: Boolean)
    begin
        DeleteWhstLine := NewDeleteWhstLine;
    end;

}
