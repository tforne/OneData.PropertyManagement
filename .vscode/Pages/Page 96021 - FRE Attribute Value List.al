page 96021 "FRE Attribute Value List"
{
    Caption = 'FRE Attribute Values';
    DelayedInsert = true;
    LinksAllowed = false;
    PageType = ListPart;
    SourceTable = "FRE Attribute Value Selection";
    SourceTableTemporary = true;
    Permissions = 
        tabledata "Fixed Real Estate" = R,
        tabledata "FRE Attribute" = R,
        tabledata "FRE Attribute Value" = RD,
        tabledata "FRE Attribute Value Mapping" = RIMD;
    ApplicationArea = All;

    layout
    {
        area(content)
        {
            field(RelatedRecordCode;RelatedRecordCode)
            {
                AssistEdit = false;
                Caption = 'Related Record Code';
                ToolTip = 'Specifies the FRE attribute.';
            }
            repeater(Group)
            {
                field("Attribute Name"; rec."Attribute Name")
                {
                    AssistEdit = false;
                    Caption = 'Attribute';
                    TableRelation = "FRE Attribute".Name WHERE (Blocked = CONST (false));
                    ToolTip = 'Specifies the FRE attribute.';

                    trigger OnValidate()
                    var
                        FREAttributeValue: Record "FRE Attribute Value";
                        FREAttributeValueMapping: Record "FRE Attribute Value Mapping";
                    begin
                        IF xRec."Attribute Name" <> '' THEN
                            DeleteFREAttributeValueMapping(xRec."Attribute ID");

                        IF NOT rec.FindAttributeValue(FREAttributeValue) THEN
                            rec.InsertFREAttributeValue(FREAttributeValue, Rec);

                        IF FREAttributeValue.GET(FREAttributeValue."Attribute ID", FREAttributeValue.ID) THEN BEGIN
                            FREAttributeValueMapping.RESET;
                            FREAttributeValueMapping.INIT;
                            FREAttributeValueMapping."Table ID" := 96000;
                            FREAttributeValueMapping."No." := RelatedRecordCode;
                            FREAttributeValueMapping."FRE Attribute ID" := FREAttributeValue."Attribute ID";
                            FREAttributeValueMapping."FRE Attribute Value ID" := FREAttributeValue.ID;
                            FREAttributeValueMapping.INSERT;
                        END;
                    end;
                }
                field(Value; rec.Value)
                {
                    Caption = 'Value';
                    TableRelation = IF ("Attribute Type"=CONST(Option)) "FRE Attribute Value".Value WHERE ("Attribute ID"=FIELD("Attribute ID"),
                                                                                                          Blocked=CONST(true));
                    ToolTip = 'Specifies the value of the FRE attribute.';

                    trigger OnValidate()
                    var
                        FREAttributeValue: Record "FRE Attribute Value";
                        FREAttributeValueMapping: Record "FRE Attribute Value Mapping";
                        FREAttribute: Record "FRE Attribute";
                    begin
                        IF NOT rec.FindAttributeValue(FREAttributeValue) THEN
                          rec.InsertFREAttributeValue(FREAttributeValue,Rec);

                        FREAttributeValueMapping.SETRANGE("Table ID",DATABASE::"Fixed Real Estate");
                        FREAttributeValueMapping.SETRANGE("No.",RelatedRecordCode);
                        FREAttributeValueMapping.SETRANGE("FRE Attribute ID",FREAttributeValue."Attribute ID");

                        IF FREAttributeValueMapping.FINDFIRST THEN BEGIN
                          FREAttributeValueMapping."FRE Attribute Value ID" := FREAttributeValue.ID;
                          OnBeforeFREAttributeValueMappingModify(FREAttributeValueMapping,FREAttributeValue,RelatedRecordCode);
                          FREAttributeValueMapping.MODIFY;
                        END;

                        FREAttribute.GET(rec."Attribute ID");
                        IF FREAttribute.Type <> FREAttribute.Type::Option THEN
                          IF rec.FindAttributeValueFromRecord(FREAttributeValue,xRec) THEN
                            IF NOT FREAttributeValue.HasBeenUsed THEN
                              FREAttributeValue.DELETE;
                    end;
                }
                field("Unit of Measure";rec."Unit of Measure")
                {
                    ToolTip = 'Specifies the name of the FRE or resource''s unit of measure, such as piece or hour.';
                }
                field(Comment;rec.Comment)
                {
                    trigger OnValidate()
                    var
                        FREAttributeValue: Record "FRE Attribute Value";
                        FREAttributeValueMapping: Record "FRE Attribute Value Mapping";
                        FREAttribute: Record "FRE Attribute";
                    begin
                        FREAttributeValueMapping.SETRANGE("Table ID",DATABASE::"Fixed Real Estate");
                        FREAttributeValueMapping.SETRANGE("No.",RelatedRecordCode);
                        FREAttributeValueMapping.SETRANGE("FRE Attribute ID",rec."Attribute ID");
                        IF FREAttributeValueMapping.FINDFIRST THEN BEGIN
                          FREAttributeValueMapping.Comment := rec.Comment;
                          FREAttributeValueMapping.MODIFY;
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
        DeleteFREAttributeValueMapping(rec."Attribute ID");
    end;

    trigger OnOpenPage()
    begin
        CurrPage.EDITABLE(TRUE);
    end;

    var
        RelatedRecordCode: Code[20];

    procedure LoadAttributes(FRENo: Code[20])
    var
        FREAttributeValueMapping: Record "FRE Attribute Value Mapping";
        TempFREAttributeValue: Record "FRE Attribute Value" temporary;
        FREAttributeValue: Record "FRE Attribute Value";
    begin
        RelatedRecordCode := FRENo;
        FREAttributeValueMapping.SETRANGE("Table ID",DATABASE::"Fixed Real Estate");
        FREAttributeValueMapping.SETRANGE("No.",FRENo);
        IF FREAttributeValueMapping.FINDSET THEN
          REPEAT
            TempFREAttributeValue."Attribute ID" := FREAttributeValueMapping."FRE Attribute ID";
            // TempFREAttributeValue."Attribute Name" := FREAttributeValueMapping.
            TempFREAttributeValue.Comment := FREAttributeValueMapping.Comment;
            if FREAttributeValue.GET(FREAttributeValueMapping."FRE Attribute ID",FREAttributeValueMapping."FRE Attribute Value ID") then
                TempFREAttributeValue.TRANSFERFIELDS(FREAttributeValue);
            
            TempFREAttributeValue.INSERT;
          UNTIL FREAttributeValueMapping.NEXT = 0;

        rec.PopulateFREAttributeValueSelection(TempFREAttributeValue);
    end;

    procedure DeleteFREAttributeValueMapping(AttributeToDeleteID: Integer)
    var
        FREAttributeValueMapping: Record "FRE Attribute Value Mapping";
        FREAttribute: Record "FRE Attribute";
    begin
        FREAttributeValueMapping.SETRANGE("Table ID",DATABASE::"Fixed Real Estate");
        FREAttributeValueMapping.SETRANGE("No.",RelatedRecordCode);
        FREAttributeValueMapping.SETRANGE("FRE Attribute ID",AttributeToDeleteID);
        IF FREAttributeValueMapping.FINDFIRST THEN BEGIN
          FREAttributeValueMapping.DELETE;
          OnAfterFREAttributeValueMappingDelete(AttributeToDeleteID,RelatedRecordCode);
        END;

        FREAttribute.GET(AttributeToDeleteID);
        FREAttribute.RemoveUnusedArbitraryValues;
    end;

    [IntegrationEvent(false, false)]
    local procedure OnAfterFREAttributeValueMappingDelete(AttributeToDeleteID: Integer;RelatedRecordCode: Code[20])
    begin
    end;

    [IntegrationEvent(false, false)]
    local procedure OnBeforeFREAttributeValueMappingModify(var FREAttributeValueMapping: Record "FRE Attribute Value Mapping";FREAttributeValue: Record "FRE Attribute Value";RelatedRecordCode: Code[20])
    begin
    end;

    procedure LoadAttributeForTypeFixeRealEstate(FRENo: Code[20])
    var
        FREAttribute: Record "FRE Attribute";
        TempFixedRealEstate: Record "Fixed Real Estate";
        TempFREAttributeValue: Record "FRE Attribute Value" temporary;
        FREAttributeValueMapping: Record "FRE Attribute Value Mapping";
        FREAttributeValue: Record "FRE Attribute Value";
    begin
        RelatedRecordCode := FRENo;
        FREAttribute.RESET;
        IF FREAttribute.FINDSET THEN
          REPEAT
            // IF FREAttribute."Fixed Type"<>'' THEN BEGIN
                TempFixedRealEstate.RESET;
                TempFixedRealEstate.SETRANGE("No.",FRENo);
                TempFixedRealEstate.SETFILTER("Asset Type",FREAttribute."Fixed Type");
                IF TempFixedRealEstate.FINDFIRST THEN BEGIN
                    TempFREAttributeValue."Attribute ID" := FREAttribute.ID;
                    TempFREAttributeValue."Attribute Name" := FREAttribute.Name;
                    IF TempFREAttributeValue.INSERT THEN;
                END;
            //END;
          UNTIL FREAttribute.NEXT = 0;
        //  PopulateFREAttributeValueSelection(TempFREAttributeValue);
        IF TempFREAttributeValue.FINDFIRST THEN REPEAT
          rec."Attribute ID" := TempFREAttributeValue."Attribute ID";
          FREAttribute.GET(TempFREAttributeValue."Attribute ID");
          rec."Attribute Name" := FREAttribute.Name;
          rec."Attribute Type" := FREAttribute.Type;
          rec.Value := TempFREAttributeValue.GetValueInCurrentLanguageWithoutUnitOfMeasure;
          rec.Blocked := TempFREAttributeValue.Blocked;
          rec."Unit of Measure" := FREAttribute."Unit of Measure";
          // "Inherited-From Table ID" := DefinedOnTableID;
          // "Inherited-From Key Value" := DefinedOnKeyValue;
          IF rec.INSERT THEN BEGIN
            rec.InsertFREAttributeValue(FREAttributeValue,Rec);
            FREAttributeValueMapping.INIT;
            FREAttributeValueMapping."Table ID" := 96000;
            FREAttributeValueMapping."No." := FRENo;
            FREAttributeValueMapping."FRE Attribute ID" := TempFREAttributeValue."Attribute ID";
            FREAttributeValueMapping."FRE Attribute Value ID" := FREAttributeValue.ID;
            IF FREAttributeValueMapping.INSERT THEN;
            END;
          UNTIL TempFREAttributeValue.NEXT = 0;
    end;
}

