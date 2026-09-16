query 96866 "OD PM Open Receivable Sum"
{
    QueryType = Normal;

    elements
    {
        dataitem(CustLedgerEntry; "Cust. Ledger Entry")
        {
            DataItemTableFilter = Open = CONST(true);

            column(DueDate; "Due Date")
            {
            }
            dataitem(DetailedCustLedgEntry; "Detailed Cust. Ledg. Entry")
            {
                DataItemLink = "Cust. Ledger Entry No." = CustLedgerEntry."Entry No.";
                DataItemTableFilter = "Excluded from calculation" = CONST(false);

                column(RemainingAmtLCY; "Amount (LCY)")
                {
                    Method = Sum;
                }
            }
        }
    }
}
