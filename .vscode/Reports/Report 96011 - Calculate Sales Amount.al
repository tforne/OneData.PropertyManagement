report 96011 "Calculate Sales Amount"
{
    ApplicationArea = All;
    Caption = 'Calculate Sales Amount';
    ProcessingOnly = true;
    UsageCategory = Tasks;

    dataset
    {
        dataitem("Fixed Real Estate";"Fixed Real Estate")
        {
            RequestFilterFields = "No.","Post Code","Asset Type";

            trigger OnAfterGetRecord()
            begin
                Counter1 := Counter1 + 1;
                Counter2 := Counter2 + 1;
                if Counter2 >= CounterBreak then begin
                    Counter2 := 0;
                    Window.UPDATE(1, ROUND(Counter1 / CounterTotal * 10000, 1));
                end;
                ResultDescription := '';
                RealEstateMangement.CalcSalesAmount("Fixed Real Estate", SalesAmountM2, Percentage);
                
            end;

            trigger OnPostDataItem()
            begin
            end;

            trigger OnPreDataItem()
            begin
                if SalesAmountM2 <= 0 then
                    error(Text0000);
                Window.OPEN(
                  Text005 +
                  '@1@@@@@@@@@@@@@@@@@@@@@@@@@@@@@');

                CounterTotal := COUNT;
                Counter1 := 0;
                Counter2 := 0;
                CounterBreak := ROUND(CounterTotal / 100, 1, '>');
            end;
        }
    }

requestpage
{
        SaveValues = true;

        layout
        {
            area(content)
            {
                group(Options)
                {
                    Caption = 'Options';
                    field(salesamountm2; SalesAmountM2)
                    {
                        ApplicationArea = All;
                        Caption = 'Sales Amount per m2';
                        ToolTip = 'Specifies the sales amount per square meter to be used in the calculation.';
                    }
                    field(percentage; Percentage)
                    {
                        ApplicationArea = All;
                        Caption = 'Percentage Discount';
                        ToolTip = 'Specifies the percentage to be applied to the calculated sales amount.';
                    }
                }
            }
        }

        actions
        {
        }

    }

    labels
    {
    }

    
    var
        Text0000: Label 'Debes introducir el importe M2';
        Text005: Label 'Calculating Sales Amount...\\';
        Cust: Record Customer;
        Window: Dialog;
        CounterTotal: Integer;
        Counter1: Integer;
        Counter2: Integer;
        CounterBreak: Integer;
        ResultDescription: Text[80];
        HideDialog: Boolean;
        SalesAmountM2: Decimal;
        Percentage: Decimal;
        SalesAmount: Decimal;
        RealEstateMangement : Codeunit "Real Estate Management";
}
