page 96786 "FRE Bank Statements ListPart"
{
    PageType = ListPart;
    SourceTable = "FRE Bank Statement";
    Caption = 'Bank Statements';
    ApplicationArea = All;
    Editable = false;

    layout
    {
        area(content)
        {
            repeater(Group)
            {

                field(Company; Rec.Company)
                {
                }

                field(Year; Rec.Year)
                {
                }

                field(Month; Rec.Month)
                {
                }

                field("Bank Account No."; Rec."Bank Account No.")
                {
                }

                field(Counterparty; Rec."Bal. Account No.")
                {
                }

                field("Target Journal"; Rec."Target Journal")
                {
                }
                field("Default Gen. Journal Template"; Rec."Default Gen. Journal Template")
                {
                }
                field("Default Gen. Journal Batch"; Rec."Default Gen. Journal Batch")
                {
                }
                field("Default FRE Journal Template"; Rec."Default FRE Journal Template")
                {
                }
                field("Default FRE Journal Batch"; Rec."Default FRE Journal Batch")
                {
                }

                field(Status; Rec.Status)
                {
                }
            }
        }
    }
}
