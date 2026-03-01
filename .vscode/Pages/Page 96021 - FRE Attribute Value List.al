page 96021 "FRE Attribute Value List"
{
    Caption = 'FRE Attribute Values';
    DelayedInsert = true;
    LinksAllowed = false;
    PageType = ListPart;
    SourceTable = "Item Attribute Value Selection";
    SourceTableTemporary = true;
    Permissions = 
        tabledata "Fixed Real Estate" = R,
        tabledata "Item Attribute" = R,
        tabledata "Item Attribute Value" = RD,
        tabledata "Item Attribute Value Mapping" = RIMD;

    layout
    {
        area(content)
        {
            repeater(Group)
            {
                field("Attribute Name"; rec."Attribute Name")
                {
                    ApplicationArea = All;
                    AssistEdit = false;
                    Caption = 'Attribute';
                    TableRelation = "Item Attribute".Name WHERE (Blocked = CONST (false));
                    ToolTip = 'Specifies the item attribute.';

                    trigger OnValidate()
                    var
                        ItemAttributeValue: Record "Item Attribute Value";
                        ItemAttributeValueMapping: Record "Item Attribute Value Mapping";
                    begin
                        IF xRec."Attribute Name" <> '' THEN
                            DeleteItemAttributeValueMapping(xRec."Attribute ID");

                        IF NOT rec.FindAttributeValue(ItemAttributeValue) THEN
                            rec.InsertItemAttributeValue(ItemAttributeValue, Rec);

                        IF ItemAttributeValue.GET(ItemAttributeValue."Attribute ID", ItemAttributeValue.ID) THEN BEGIN
                            ItemAttributeValueMapping.RESET;
                            ItemAttributeValueMapping.INIT;
                            ItemAttributeValueMapping."Table ID" := 96000;
                            ItemAttributeValueMapping."No." := RelatedRecordCode;
                            ItemAttributeValueMapping."Item Attribute ID" := ItemAttributeValue."Attribute ID";
                            ItemAttributeValueMapping."Item Attribute Value ID" := ItemAttributeValue.ID;
                            ItemAttributeValueMapping.INSERT;
                        END;
                    end;
                }
                field(Value; rec.Value)
                {
                    ApplicationArea = All;
                    Caption = 'Value';
                    TableRelation = IF ("Attribute Type"=CONST(Option)) "Item Attribute Value".Value WHERE ("Attribute ID"=FIELD("Attribute ID"),
                                                                                                          Blocked=CONST(true));
                    ToolTip = 'Specifies the value of the item attribute.';

                    trigger OnValidate()
                    var
                        ItemAttributeValue: Record "Item Attribute Value";
                        ItemAttributeValueMapping: Record "Item Attribute Value Mapping";
                        ItemAttribute: Record "Item Attribute";
                    begin
                        IF NOT rec.FindAttributeValue(ItemAttributeValue) THEN
                          rec.InsertItemAttributeValue(ItemAttributeValue,Rec);

                        ItemAttributeValueMapping.SETRANGE("Table ID",DATABASE::"Fixed Real Estate");
                        ItemAttributeValueMapping.SETRANGE("No.",RelatedRecordCode);
                        ItemAttributeValueMapping.SETRANGE("Item Attribute ID",ItemAttributeValue."Attribute ID");

                        IF ItemAttributeValueMapping.FINDFIRST THEN BEGIN
                          ItemAttributeValueMapping."Item Attribute Value ID" := ItemAttributeValue.ID;
                          OnBeforeItemAttributeValueMappingModify(ItemAttributeValueMapping,ItemAttributeValue,RelatedRecordCode);
                          ItemAttributeValueMapping.MODIFY;
                        END;

                        ItemAttribute.GET(rec."Attribute ID");
                        IF ItemAttribute.Type <> ItemAttribute.Type::Option THEN
                          IF rec.FindAttributeValueFromRecord(ItemAttributeValue,xRec) THEN
                            IF NOT ItemAttributeValue.HasBeenUsed THEN
                              ItemAttributeValue.DELETE;
                    end;
                }
                field("Unit of Measure";rec."Unit of Measure")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the name of the item or resource''s unit of measure, such as piece or hour.';
                }
                field(Comment;rec.Comment)
                {
                    ApplicationArea = All;
                    trigger OnValidate()
                    var
                        ItemAttributeValue: Record "Item Attribute Value";
                        ItemAttributeValueMapping: Record "Item Attribute Value Mapping";
                        ItemAttribute: Record "Item Attribute";
                    begin
                        ItemAttributeValueMapping.SETRANGE("Table ID",DATABASE::"Fixed Real Estate");
                        ItemAttributeValueMapping.SETRANGE("No.",RelatedRecordCode);
                        ItemAttributeValueMapping.SETRANGE("Item Attribute ID",rec."Attribute ID");
                        IF ItemAttributeValueMapping.FINDFIRST THEN BEGIN
                          ItemAttributeValueMapping.Comment := rec.Comment;
                          ItemAttributeValueMapping.MODIFY;
                        END;
                    end;
                }
            }
        }
    }

    actions
    {
    }

    trigger OnDeleteRecord(): Boolean
    begin
        DeleteItemAttributeValueMapping(rec."Attribute ID");
    end;

    trigger OnOpenPage()
    begin
        CurrPage.EDITABLE(TRUE);
    end;

    var
        RelatedRecordCode: Code[20];

    procedure LoadAttributes(ItemNo: Code[20])
    var
        ItemAttributeValueMapping: Record "Item Attribute Value Mapping";
        TempItemAttributeValue: Record "Item Attribute Value" temporary;
        ItemAttributeValue: Record "Item Attribute Value";
    begin
        RelatedRecordCode := ItemNo;
        ItemAttributeValueMapping.SETRANGE("Table ID",DATABASE::"Fixed Real Estate");
        ItemAttributeValueMapping.SETRANGE("No.",ItemNo);
        IF ItemAttributeValueMapping.FINDSET THEN
          REPEAT
            ItemAttributeValue.GET(ItemAttributeValueMapping."Item Attribute ID",ItemAttributeValueMapping."Item Attribute Value ID");
            TempItemAttributeValue.TRANSFERFIELDS(ItemAttributeValue);
            TempItemAttributeValue.Comment := ItemAttributeValueMapping.Comment;
            TempItemAttributeValue.INSERT;
          UNTIL ItemAttributeValueMapping.NEXT = 0;

        rec.PopulateItemAttributeValueSelection(TempItemAttributeValue);
    end;

    procedure DeleteItemAttributeValueMapping(AttributeToDeleteID: Integer)
    var
        ItemAttributeValueMapping: Record "Item Attribute Value Mapping";
        ItemAttribute: Record "Item Attribute";
    begin
        ItemAttributeValueMapping.SETRANGE("Table ID",DATABASE::"Fixed Real Estate");
        ItemAttributeValueMapping.SETRANGE("No.",RelatedRecordCode);
        ItemAttributeValueMapping.SETRANGE("Item Attribute ID",AttributeToDeleteID);
        IF ItemAttributeValueMapping.FINDFIRST THEN BEGIN
          ItemAttributeValueMapping.DELETE;
          OnAfterItemAttributeValueMappingDelete(AttributeToDeleteID,RelatedRecordCode);
        END;

        ItemAttribute.GET(AttributeToDeleteID);
        ItemAttribute.RemoveUnusedArbitraryValues;
    end;

    [IntegrationEvent(false, false)]
    local procedure OnAfterItemAttributeValueMappingDelete(AttributeToDeleteID: Integer;RelatedRecordCode: Code[20])
    begin
    end;

    [IntegrationEvent(false, false)]
    local procedure OnBeforeItemAttributeValueMappingModify(var ItemAttributeValueMapping: Record "Item Attribute Value Mapping";ItemAttributeValue: Record "Item Attribute Value";RelatedRecordCode: Code[20])
    begin
    end;

    procedure LoadAttributeForTypeFixeRealEstate(FRENo: Code[20])
    var
        ItemAttribute: Record "Item Attribute";
        TempFixedRealEstate: Record "Fixed Real Estate";
        TempItemAttributeValue: Record "Item Attribute Value" temporary;
        ItemAttributeValueMapping: Record "Item Attribute Value Mapping";
        ItemAttributeValue: Record "Item Attribute Value";
    begin
        RelatedRecordCode := FRENo;
        ItemAttribute.RESET;
        IF ItemAttribute.FINDSET THEN
          REPEAT
            IF ItemAttribute."Fixed Type"<>'' THEN BEGIN
              TempFixedRealEstate.RESET;
              TempFixedRealEstate.SETRANGE("No.",FRENo);
              TempFixedRealEstate.SETFILTER("Asset Type",ItemAttribute."Fixed Type");
              IF TempFixedRealEstate.FINDFIRST THEN BEGIN
                  TempItemAttributeValue."Attribute ID" := ItemAttribute.ID;
                  TempItemAttributeValue."Attribute Name" := ItemAttribute.Name;
                  IF TempItemAttributeValue.INSERT THEN;
                END;
              END;
          UNTIL ItemAttribute.NEXT = 0;
        //  PopulateItemAttributeValueSelection(TempItemAttributeValue);
        IF TempItemAttributeValue.FINDFIRST THEN REPEAT
          rec."Attribute ID" := TempItemAttributeValue."Attribute ID";
          ItemAttribute.GET(TempItemAttributeValue."Attribute ID");
          rec."Attribute Name" := ItemAttribute.Name;
          rec."Attribute Type" := ItemAttribute.Type;
          rec.Value := TempItemAttributeValue.GetValueInCurrentLanguageWithoutUnitOfMeasure;
          rec.Blocked := TempItemAttributeValue.Blocked;
          rec."Unit of Measure" := ItemAttribute."Unit of Measure";
          // "Inherited-From Table ID" := DefinedOnTableID;
          // "Inherited-From Key Value" := DefinedOnKeyValue;
          IF rec.INSERT THEN BEGIN
            rec.InsertItemAttributeValue(ItemAttributeValue,Rec);
            ItemAttributeValueMapping.INIT;
            ItemAttributeValueMapping."Table ID" := 96000;
            ItemAttributeValueMapping."No." := FRENo;
            ItemAttributeValueMapping."Item Attribute ID" := TempItemAttributeValue."Attribute ID";
            ItemAttributeValueMapping."Item Attribute Value ID" := ItemAttributeValue.ID;
            IF ItemAttributeValueMapping.INSERT THEN;
            END;
          UNTIL TempItemAttributeValue.NEXT = 0;
    end;
}

