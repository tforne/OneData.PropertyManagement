page 96042 "Lease Bank Account List"
{
    Caption = 'Customer Bank Account List';
    CardPageID = "Lease Bank Account Card";
    DataCaptionFields = "Lease No.";
    Editable = false;
    PageType = List;
    SourceTable = "Lease Bank Account";

    layout
    {
        area(content)
        {
            repeater(Group)
            {
                field(Code; rec.Code)
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies a code to identify this customer bank account.';
                }
                field(Name; rec.Name)
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the name of the bank where the customer has the bank account.';
                }
                field("Post Code"; rec."Post Code")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the postal code.';
                    Visible = false;
                }
                field("Country/Region Code"; rec."Country/Region Code")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the country/region of the address.';
                    Visible = false;
                }
                field("Phone No."; rec."Phone No.")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the telephone number of the bank where the customer has the bank account.';
                }
                field("Fax No."; rec."Fax No.")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the fax number associated with the address.';
                    Visible = false;
                }
                field(Contact; rec.Contact)
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the name of the bank employee regularly contacted in connection with this bank account.';
                }
                field("Bank Account No."; rec."Bank Account No.")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the number used by the bank for the bank account.';
                    Visible = false;
                }
                field("SWIFT Code"; rec."SWIFT Code")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the SWIFT code (international bank identifier code) of the bank where the customer has the account.';
                    Visible = false;
                }
                field(IBAN; rec.IBAN)
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the bank account''s international bank account number.';
                    Visible = false;
                }
                field("Currency Code"; rec."Currency Code")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the relevant currency code for the bank account.';
                    Visible = false;
                }
                field("Language Code"; rec."Language Code")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the language that is used when translating specified text on documents to foreign business partner, such as an item description on an order confirmation.';
                    Visible = false;
                }
            }
        }
    }

    actions
    {
    }
}

