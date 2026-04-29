page 96180 "FRE Attributes"
{
    ApplicationArea = Basic, Suite;
    Caption = 'FRE Attributes';
    CardPageID = "FRE Attribute";
    PageType = List;
    RefreshOnActivate = true;
    SourceTable = "FRE Attribute";
    UsageCategory = Lists;
    DelayedInsert = true;

    layout
    {
        area(content)
        {
            repeater(Control1)
            {
                ShowCaption = false;
                field(Name; Rec.Name)
                {
                    ApplicationArea = Basic, Suite;
                    ToolTip = 'Specifies the name of the FRE attribute.';
                }
                field(Type; Rec.Type)
                {
                    ApplicationArea = Basic, Suite;
                    ToolTip = 'Specifies the type of the FRE attribute.';
                }
                field(Values; Rec.GetValues())
                {
                    ApplicationArea = Basic, Suite;
                    Caption = 'Values';
                    ToolTip = 'Specifies the values of the FRE attribute.';

                    trigger OnDrillDown()
                    begin
                        Rec.OpenFREAttributeValues();
                    end;
                }
                field(Blocked; Rec.Blocked)
                {
                    ApplicationArea = Basic, Suite;
                    ToolTip = 'Specifies that the attribute cannot be assigned to an FRE. FREs to which the attribute is already assigned are not affected.';
                }
            }
        }
    }

    actions
    {
        area(processing)
        {
            group("&Attribute")
            {
                Caption = '&Attribute';
                action(FREAttributeValues)
                {
                    ApplicationArea = Basic, Suite;
                    Caption = 'FRE Attribute &Values';
                    Enabled = (Rec.Type = Rec.Type::Option);
                    Image = CalculateInventory;
                    RunObject = Page "FRE Attribute Values";
                    RunPageLink = "Attribute ID" = field(ID);
                    ToolTip = 'Opens a window in which you can define the values for the selected FRE attribute.';
                }
                action(FREAttributeTranslations)
                {
                    ApplicationArea = Basic, Suite;
                    Caption = 'Translations';
                    Image = Translations;
                    RunObject = Page "FRE Attribute Translations";
                    RunPageLink = "Attribute ID" = field(ID);
                    ToolTip = 'Opens a window in which you can define the translations for the selected item attribute.';
                }
            }
        }
        area(Promoted)
        {
            group(Category_Process)
            {
                Caption = 'Process';

                actionref(ItemAttributeValues_Promoted; FREAttributeValues)
                {
                }
                actionref(ItemAttributeTranslations_Promoted; FREAttributeTranslations)
                {
                }
            }
        }
    }
}

