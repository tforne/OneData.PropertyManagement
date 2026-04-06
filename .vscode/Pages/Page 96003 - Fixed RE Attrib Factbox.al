page 96003 "Fixed RE Attrib. Factbox"
{
    Caption = 'Item Attributes';
    DeleteAllowed = false;
    InsertAllowed = false;
    ModifyAllowed = false;
    PageType = ListPart;
    RefreshOnActivate = true;
    SourceTable = "Item Attribute Value";
    SourceTableTemporary = true;
    ApplicationArea = All;

    layout
    {
        area(content)
        {
            repeater(Group)
            {
                field(Attribute; rec.GetAttributeNameInCurrentLanguage)
                {
                    ApplicationArea = Basic, Suite;
                    Caption = 'Attribute';
                    ToolTip = 'Specifies the name of the item attribute.';
                    Visible = TranslatedValuesVisible;
                }
                field(Value; rec.GetValueInCurrentLanguage)
                {
                    ApplicationArea = Basic, Suite;
                    Caption = 'Value';
                    ToolTip = 'Specifies the value of the item attribute.';
                    Visible = TranslatedValuesVisible;
                }
                field("Attribute Name"; rec."Attribute Name")
                {
                    ApplicationArea = Basic, Suite;
                    Caption = 'Attribute';
                    ToolTip = 'Specifies the name of the item attribute.';
                    Visible = NOT TranslatedValuesVisible;
                }
                field(RawValue; rec.Value)
                {
                    ApplicationArea = Basic, Suite;
                    Caption = 'Value';
                    ToolTip = 'Specifies the value of the item attribute.';
                    Visible = NOT TranslatedValuesVisible;
                }
            }
        }
    }

    actions
    {
        area(processing)
        {
            action(Edit)
            {
                AccessByPermission = TableData 7500 = R;
                ApplicationArea = Basic, Suite;
                Caption = 'Edit';
                Image = Edit;
                ToolTip = 'Edit item''s attributes, such as color, size, or other characteristics that help to describe the item.';
                Visible = IsItem;

                trigger OnAction()
                var
                    Item: Record "Item";
                begin
                    IF NOT IsItem THEN
                        EXIT;
                    IF NOT Item.GET(ContextValue) THEN
                        EXIT;
                    PAGE.RUNMODAL(PAGE::"Item Attribute Value Editor", Item);
                    CurrPage.SAVERECORD;
                    LoadItemAttributesData(ContextValue);
                end;
            }
        }
    }

    trigger OnOpenPage()
    begin
        rec.SETAUTOCALCFIELDS("Attribute Name");
        TranslatedValuesVisible := true;
    end;

    var
        TranslatedValuesVisible: Boolean;
        ContextType: Option "None",Item,Category;
        ContextValue: Code[20];
        IsItem: Boolean;

    procedure LoadItemAttributesData(KeyValue: Code[20])
    var
        RealEstateManagement : Codeunit "Real Estate Management";
    begin
        RealEstateManagement.LoadItemFREAttributesFactBoxData(KeyValue);
        SetContext(ContextType::Item, KeyValue);
        CurrPage.UPDATE(FALSE);
    end;

    procedure LoadCategoryAttributesData(CategoryCode: Code[20])
    begin
        rec.LoadCategoryAttributesFactBoxData(CategoryCode);
        SetContext(ContextType::Category, CategoryCode);
        CurrPage.UPDATE(FALSE);
    end;

    local procedure SetContext(NewType: Option; NewValue: Code[20])
    begin
        ContextType := NewType;
        ContextValue := NewValue;
        IsItem := ContextType = ContextType::Item;
    end;
}

