page 96043 "Lease Bank Account Card"
{
    Caption = 'Customer Bank Account Card';
    PageType = Card;
    SourceTable = "Lease Bank Account";
    ApplicationArea = All;

    layout
    {
        area(content)
        {
            group(General)
            {
                Caption = 'General';
                field(Code; rec.Code)
                {
                    ApplicationArea = Basic, Suite;
                    ToolTip = 'Specifies a code to identify this customer bank account.';
                }
                field(Name; rec.Name)
                {
                    ApplicationArea = Basic, Suite;
                    ToolTip = 'Specifies the name of the bank where the customer has the bank account.';
                }
                field(Address; rec.Address)
                {
                    ApplicationArea = Basic, Suite;
                    ToolTip = 'Specifies the address of the bank where the customer has the bank account.';
                }
                field("Address 2"; rec."Address 2")
                {
                    ApplicationArea = Basic, Suite;
                    ToolTip = 'Specifies additional address information.';
                }
                field("Post Code"; rec."Post Code")
                {
                    ApplicationArea = Basic, Suite;
                    ToolTip = 'Specifies the postal code.';
                }
                field(City; rec.City)
                {
                    ApplicationArea = Basic, Suite;
                    ToolTip = 'Specifies the city of the bank where the customer has the bank account.';
                }
                field(County; rec.County)
                {
                    ApplicationArea = Basic, Suite;
                    ToolTip = 'Specifies the county of the address.';
                }
                field("Country/Region Code"; rec."Country/Region Code")
                {
                    ApplicationArea = Basic, Suite;
                    ToolTip = 'Specifies the country/region of the address.';
                }
                field("Phone No."; rec."Phone No.")
                {
                    ApplicationArea = Basic, Suite;
                    ToolTip = 'Specifies the telephone number of the bank where the customer has the bank account.';
                }
                field(Contact; rec.Contact)
                {
                    ApplicationArea = Basic, Suite;
                    ToolTip = 'Specifies the name of the bank employee regularly contacted in connection with this bank account.';
                }
                field("Currency Code"; rec."Currency Code")
                {
                    ApplicationArea = Suite;
                    ToolTip = 'Specifies the relevant currency code for the bank account.';
                }
                field("Transit No."; rec."Transit No.")
                {
                    ApplicationArea = Basic, Suite;
                    ToolTip = 'Specifies a bank identification number of your own choice.';
                }
            }
            group(Communication)
            {
                Caption = 'Communication';
                field("Fax No."; rec."Fax No.")
                {
                    ApplicationArea = Basic, Suite;
                    ToolTip = 'Specifies the fax number of the bank where the customer has the bank account.';
                }
                field("E-Mail"; rec."E-Mail")
                {
                    ApplicationArea = Basic, Suite;
                    ExtendedDatatype = EMail;
                    ToolTip = 'Specifies the email address associated with the bank account.';
                }
                field("Home Page"; rec."Home Page")
                {
                    ApplicationArea = Basic, Suite;
                    ToolTip = 'Specifies the bank web site.';
                }
            }
            group(Transfer)
            {
                Caption = 'Transfer';
                field("CCC Bank No."; rec."CCC Bank No.")
                {
                    ApplicationArea = Basic, Suite;
                    ToolTip = 'Specifies the bank account code. This code is the first part of the C¾digo Cuenta Cliente (CCC) number.';
                }
                field("CCC Bank Branch No."; rec."CCC Bank Branch No.")
                {
                    ApplicationArea = Basic, Suite;
                    ToolTip = 'Specifies the four-digit bank office number. This number is the second part of the C¾digo Cuenta Cliente (CCC) number.';
                }
                field("CCC Control Digits"; rec."CCC Control Digits")
                {
                    ApplicationArea = Basic, Suite;
                    ToolTip = 'Specifies the two-digit account control code. This number is the third part of the C¾digo Cuenta Cliente (CCC) number.';
                }
                field("CCC Bank Account No."; rec."CCC Bank Account No.")
                {
                    ApplicationArea = Basic, Suite;
                    ToolTip = 'Specifies the company''s bank account code.';
                }
                field("CCC No."; rec."CCC No.")
                {
                    ApplicationArea = Basic, Suite;
                    ToolTip = 'Specifies the C¾digo Cuenta Cliente (CCC) number.';
                }
                field("Bank Branch No."; rec."Bank Branch No.")
                {
                    ApplicationArea = Basic, Suite;
                    ToolTip = 'Specifies the number of the bank branch.';
                }
                field("Bank Account No."; rec."Bank Account No.")
                {
                    ApplicationArea = Basic, Suite;
                    ToolTip = 'Specifies the number used by the bank for the bank account.';
                }
                field(IBAN; rec.IBAN)
                {
                    ApplicationArea = Basic, Suite;
                    ToolTip = 'Specifies the bank account''s international bank account number.';
                }
                field("SWIFT Code"; rec."SWIFT Code")
                {
                    ApplicationArea = Basic, Suite;
                    ToolTip = 'Specifies the SWIFT code (international bank identifier code) of the bank where the customer has the account.';
                }
                field("Bank Clearing Standard"; rec."Bank Clearing Standard")
                {
                    ApplicationArea = Basic, Suite;
                    ToolTip = 'Specifies the format standard to be used in bank transfers if you use the Bank Clearing Code field to identify you as the sender.';
                }
                field("Bank Clearing Code"; rec."Bank Clearing Code")
                {
                    ApplicationArea = Basic, Suite;
                    ToolTip = 'Specifies the code for bank clearing that is required according to the format standard you selected in the Bank Clearing Standard field.';
                }
            }
        }
    }

    actions
    {
    }
}

