namespace OneData.Property.Lease;

page 96070 "OD Lease Contract Lookup"
{
    PageType = List;
    SourceTable = "OD Lease Contract Buffer";
    SourceTableTemporary = true;
    Caption = 'Source Lease Contracts';
    ApplicationArea = All;
    Editable = false;

    layout
    {
        area(content)
        {
            repeater(Control1)
            {
                field("Company Name"; Rec."Company Name")
                {
                }
                field("Contract No."; Rec."Contract No.")
                {
                }
                field(Description; Rec.Description)
                {
                }
                field("Customer No."; Rec."Customer No.")
                {
                }
                field("Fixed Real Estate No."; Rec."Fixed Real Estate No.")
                {
                }
                field("Starting Date"; Rec."Starting Date")
                {
                }
                field("Expiration Date"; Rec."Expiration Date")
                {
                }
                field(StatusText; Rec.StatusText)
                {
                }
            }
        }
    }
    procedure SetTempSource(var TempLeaseContractBuffer: Record "OD Lease Contract Buffer" temporary)
    begin
        Rec.Reset();
        Rec.DeleteAll();
        Rec.Copy(TempLeaseContractBuffer, true);
    end;
    
    procedure GetSelectedContractNo(): Code[20]
    begin

        exit(Rec."Contract No.");
    end;
}
