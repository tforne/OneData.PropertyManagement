page 96053 "Sumary Lease Contract"
{
    Caption = 'Sumary Lease Contract';
    PageType = CardPart;
    SourceTable = "Lease Contract";

    layout
    {
        area(content)
        {
            field("Description Fixed Real Estate";Rec."Description Fixed Real Estate")
            {
                ApplicationArea = Basic, Suite;
                Caption = 'Fixed Real Estate Description';
                ToolTip = 'Specifies the description of the fixed real estate associated with the lease contract.';
                Editable = false;
            }
            field(Name;Rec.Name)
            {
                ApplicationArea = Basic, Suite;
                Caption = 'Lease Contract Name';
                ToolTip = 'Specifies the name of the lease contract.';
                Editable = false;
            }
            field(Status;Rec.Status)
            {
                ApplicationArea = Basic, Suite;
                Caption = 'Status';
                ToolTip = 'Specifies the status of the lease contract.';
                Editable = false;
            }
            cuegroup(Control2)
            {
                ShowCaption = false;
                field("Annual Amount";Rec."Annual Amount")
                {
                    ApplicationArea = All;
                    Caption = 'Amount per Period';
                    ToolTip = 'Specifies the amount to be paid for each period of the lease contract.';
                }
                field("Amount Rental Deposit";Rec."Amount Rental Deposit")
                {
                    ApplicationArea = All;
                    Caption = 'Amount Rental Deposit';
                    ToolTip = 'Specifies the total amount of rental deposits associated with the lease contract.';
                    DrillDownPageId = 96054;
                }
                field("Contacts Related";Rec."Contacts Related")
                {
                    ApplicationArea = All;
                    Caption = 'Contacts Related';
                    ToolTip = 'Specifies the number of contacts related to the lease contract.';
                    DrillDownPageId = 96013;
                }
            }
            field("Expiration Date";Rec."Expiration Date")
            {
                ApplicationArea = Basic, Suite;
                Caption = 'Expiration Date';
                ToolTip = 'Specifies the expiration date of the lease contract.';
                Editable = false;
            }
        }
    }

    actions
    {
    }

    local procedure ShowDetails()
    begin
        PAGE.Run(PAGE::"Lease Contract Card", Rec);
    end;
}

