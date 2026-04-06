page 96024 "Type Fixed Real Estate List"
{
    PageType = List;
    SourceTable = "Type Fixed Real Estate";
    ApplicationArea = All;

    layout
    {
        area(content)
        {
            repeater(Group)
            {
                field(Code; rec.Code)
                {
                }
                field(Description; rec.Description)
                {
                }
            }
        }
    }

    actions
    {
    }

    procedure SetSelection(var TypeFixedRealEstate: Record "Type Fixed Real Estate")
    begin
        CurrPage.SETSELECTIONFILTER(TypeFixedRealEstate);
    end;

    procedure GetSelectionFilter(): Text
    var
        TypeFixedRealEstate: Record "Type Fixed Real Estate";
        SelectionFilterManagement: Codeunit "Real Estate Management";
    begin
        CurrPage.SETSELECTIONFILTER(TypeFixedRealEstate);
        EXIT(SelectionFilterManagement.GetSelectionFilterForTypeREF(TypeFixedRealEstate));
    end;
}

