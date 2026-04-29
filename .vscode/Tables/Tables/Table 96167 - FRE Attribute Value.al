namespace OneData.Property.Asset;

using Microsoft.Inventory.Item;
using System.Globalization;
using System.IO;

table 96167 "FRE Attribute Value"
{
    Caption = 'FRE Attribute Value';
    DataCaptionFields = Value;
    LookupPageID = "FRE Attribute Values";
    DataClassification = CustomerContent;
    DataPerCompany = false;

    fields
    {
        field(1; "Attribute ID"; Integer)
        {
            Caption = 'Attribute ID';
            NotBlank = true;
            TableRelation = "FRE Attribute".ID where(Blocked = const(false));
        }
        field(2; ID; Integer)
        {
            AutoIncrement = true;
            Caption = 'ID';
        }
        field(3; Value; Text[250])
        {
            Caption = 'Value';

            trigger OnValidate()
            var
                FREAttribute: Record "FRE Attribute";
            begin
                if xRec.Value = Value then
                    exit;

                TestField(Value);
                if HasBeenUsed() then
                    if not Confirm(RenameUsedAttributeValueQst) then
                        Error('');

                CheckValueUniqueness(Rec, Value);
                DeleteTranslationsConditionally(xRec, Value);

                FREAttribute.Get("Attribute ID");
                if IsNumeric(FREAttribute) then
                    Evaluate("Numeric Value", Value);
                if FREAttribute.Type = FREAttribute.Type::Date then
                    Evaluate("Date Value", Value);
            end;
        }
        field(4; "Numeric Value"; Decimal)
        {
            BlankZero = true;
            Caption = 'Numeric Value';

            trigger OnValidate()
            var
                FREAttribute: Record "FRE Attribute";
            begin
                if xRec."Numeric Value" = "Numeric Value" then
                    exit;

                FREAttribute.Get("Attribute ID");
                if IsNumeric(FREAttribute) then
                    Validate(Value, Format("Numeric Value", 0, 9));
            end;
        }
        field(5; "Date Value"; Date)
        {
            Caption = 'Date Value';

            trigger OnValidate()
            var
                FREAttribute: Record "FRE Attribute";
            begin
                if xRec."Date Value" = "Date Value" then
                    exit;

                FREAttribute.Get("Attribute ID");
                if FREAttribute.Type = FREAttribute.Type::Date then
                    Validate(Value, Format("Date Value"));
            end;
        }
        field(6; Blocked; Boolean)
        {
            Caption = 'Blocked';
        }
        field(10; "Attribute Name"; Text[250])
        {
            CalcFormula = lookup("FRE Attribute".Name where(ID = field("Attribute ID")));
            Caption = 'Attribute Name';
            FieldClass = FlowField;
        }
        field(11; "Comment"; Text[50])
        {
            Caption = 'Comment';
        }
    }

    keys
    {
        key(Key1; "Attribute ID", ID)
        {
            Clustered = true;
        }
        key(Key2; Value)
        {
        }
    }

    fieldgroups
    {
        fieldgroup(DropDown; Value)
        {
        }
        fieldgroup(Brick; "Attribute Name", Value)
        {
        }
    }

    trigger OnDelete()
    var
        FREAttrValueTranslation: Record "FRE Attr. Value Translation";
        FREAttributeValueMapping: Record "FRE Attribute Value Mapping";
    begin
        if HasBeenUsed() then
            if not Confirm(DeleteUsedAttributeValueQst) then
                Error('');
        FREAttributeValueMapping.SetRange("FRE Attribute ID", "Attribute ID");
        FREAttributeValueMapping.SetRange("FRE Attribute Value ID", ID);
        FREAttributeValueMapping.DeleteAll();

        FREAttrValueTranslation.SetRange("Attribute ID", "Attribute ID");
        FREAttrValueTranslation.SetRange(ID, ID);
        FREAttrValueTranslation.DeleteAll();
    end;

    var
        TransformationRule: Record "Transformation Rule";

        NameAlreadyExistsErr: Label 'The FREE attribute value with value ''%1'' already exists.', Comment = '%1 - arbitrary name';
        ReuseValueTranslationsQst: Label 'There are translations for FRE attribute value ''%1''.\\Do you want to reuse these translations for the new value ''%2''?', Comment = '%1 - arbitrary name,%2 - arbitrary name';
        DeleteUsedAttributeValueQst: Label 'This FRE attribute value has been assigned to at least one item.\\Are you sure you want to delete it?';
        RenameUsedAttributeValueQst: Label 'This FRE attribute value has been assigned to at least one item.\\Are you sure you want to rename it?';
        CategoryStructureNotValidErr: Label 'The FRE category structure is not valid. The category %1 is a parent of itself or any of its children.', Comment = '%1 - Category Name';

    procedure LookupAttributeValue(AttributeID: Integer; var AttributeValueID: Integer)
    var
        FREAttributeValue: Record "FRE Attribute Value";
        FREAttributeValues: Page "FRE Attribute Values";
    begin
        FREAttributeValue.SetRange("Attribute ID", AttributeID);
        FREAttributeValues.LookupMode := true;
        FREAttributeValues.SetTableView(FREAttributeValue);
        if FREAttributeValue.Get(AttributeID, AttributeValueID) then
            FREAttributeValues.SetRecord(FREAttributeValue);
        if FREAttributeValues.RunModal() = ACTION::LookupOK then begin
            FREAttributeValues.GetRecord(FREAttributeValue);
            AttributeValueID := FREAttributeValue.ID;
        end;
    end;

    procedure GetAttributeNameInCurrentLanguage(): Text[250]
    var
        FREAttribute: Record "FRE Attribute";
    begin
        if FREAttribute.Get("Attribute ID") then
            exit(FREAttribute.GetNameInCurrentLanguage());
        exit('');
    end;

    procedure GetValueInCurrentLanguage() ValueTxt: Text[250]
    var
        FREAttribute: Record "FRE Attribute";
    begin
        ValueTxt := GetValueInCurrentLanguageWithoutUnitOfMeasure();

        if FREAttribute.Get("Attribute ID") then
            case FREAttribute.Type of
                FREAttribute.Type::Integer,
                FREAttribute.Type::Decimal:
                    if ValueTxt <> '' then
                        exit(AppendUnitOfMeasure(ValueTxt, FREAttribute));
            end;

        OnAfterGetValueInCurrentLanguage(Rec, ValueTxt);
    end;

    procedure GetValueInCurrentLanguageWithoutUnitOfMeasure(): Text[250]
    var
        FREAttribute: Record "FRE Attribute";
    begin
        if FREAttribute.Get("Attribute ID") then
            case FREAttribute.Type of
                FREAttribute.Type::Option:
                    exit(GetTranslatedName(GlobalLanguage));
                FREAttribute.Type::Text:
                    exit(Value);
                FREAttribute.Type::Integer:
                    if Value <> '' then
                        exit(Format(Value));
                FREAttribute.Type::Decimal:
                    if Value <> '' then
                        exit(Format("Numeric Value"));
                FREAttribute.Type::Date:
                    exit(Format("Date Value"));
                else begin
                    OnGetValueInCurrentLanguage(FREAttribute, Rec);
                    exit(Value);
                end;
            end;
        exit('');
    end;

    procedure GetTranslatedName(LanguageID: Integer): Text[250]
    var
        Language: Codeunit Language;
        LanguageCode: Code[10];
    begin
        LanguageCode := Language.GetLanguageCode(LanguageID);
        if LanguageCode <> '' then
            exit(GetTranslatedNameByLanguageCode(LanguageCode));
        exit(Value);
    end;

    procedure GetTranslatedNameByLanguageCode(LanguageCode: Code[10]): Text[250]
    var
        FREAttrValueTranslation: Record "FRE Attr. Value Translation";
    begin
        if not FREAttrValueTranslation.Get("Attribute ID", ID, LanguageCode) then
            exit(Value);
        exit(FREAttrValueTranslation.Name);
    end;

    local procedure CheckValueUniqueness(FREAttributeValue: Record "FRE Attribute Value"; NameToCheck: Text[250])
    begin
        FREAttributeValue.SetRange("Attribute ID", "Attribute ID");
        FREAttributeValue.SetFilter(ID, '<>%1', FREAttributeValue.ID);
        FREAttributeValue.SetRange(Value, NameToCheck);
        if not FREAttributeValue.IsEmpty() then
            Error(NameAlreadyExistsErr, NameToCheck);
    end;

    local procedure DeleteTranslationsConditionally(FREAttributeValue: Record "FRE Attribute Value"; NameToCheck: Text[250])
    var
        FREAttrValueTranslation: Record "FRE Attr. Value Translation";
    begin
        if (FREAttributeValue.Value <> '') and (FREAttributeValue.Value <> NameToCheck) then begin
            FREAttrValueTranslation.SetRange("Attribute ID", "Attribute ID");
            FREAttrValueTranslation.SetRange(ID, ID);
            if not FREAttrValueTranslation.IsEmpty() then
                if not Confirm(StrSubstNo(ReuseValueTranslationsQst, FREAttributeValue.Value, NameToCheck)) then
                    FREAttrValueTranslation.DeleteAll();
        end;
    end;

    local procedure AppendUnitOfMeasure(String: Text; FREAttribute: Record "FRE Attribute"): Text
    begin
        if FREAttribute."Unit of Measure" <> '' then
            exit(StrSubstNo('%1 %2', String, Format(FREAttribute."Unit of Measure")));
        exit(String);
    end;

    procedure HasBeenUsed(): Boolean
    var
        FREAttributeValueMapping: Record "FRE Attribute Value Mapping";
        AttributeHasBeenUsed: Boolean;
    begin
        FREAttributeValueMapping.SetRange("FRE Attribute ID", "Attribute ID");
        FREAttributeValueMapping.SetRange("FRE Attribute Value ID", ID);
        AttributeHasBeenUsed := not FREAttributeValueMapping.IsEmpty();
        OnAfterHasBeenUsed(Rec, AttributeHasBeenUsed);
        exit(AttributeHasBeenUsed);
    end;

    procedure SetValueFilter(var FREAttribute: Record "FRE Attribute"; FilterText: Text)
    var
        IndexOfOrCondition: Integer;
        IsHandled: Boolean;
    begin
        IsHandled := false;
        OnBeforeSetValueFilter(Rec, FREAttribute, FilterText, IsHandled);
        if IsHandled then
            exit;

        SetRange("Numeric Value");
        SetRange(Value);

        if IsNumeric(FREAttribute) then begin
            SetFilter("Numeric Value", FilterText);
            exit;
        end;

        if FREAttribute.Type = FREAttribute.Type::Text then
            if (StrPos(FilterText, '*') = 0) and (StrPos(FilterText, '''') = 0) then begin
                FilterText := StrSubstNo('@*%1*', LowerCase(FilterText));
                IndexOfOrCondition := StrPos(FilterText, '|');
                if IndexOfOrCondition > 0 then begin
                    TransformationRule.Init();
                    TransformationRule."Find Value" := '|';
                    TransformationRule."Replace Value" := '*|@*';
                    TransformationRule."Transformation Type" := TransformationRule."Transformation Type"::Replace;
                    FilterText := TransformationRule.TransformText(FilterText);
                end
            end;

        if FREAttribute.Type = FREAttribute.Type::Date then
            if FilterText <> '' then begin
                SetFilter("Date Value", FilterText);
                exit;
            end;

        SetFilter(Value, FilterText);
    end;

    local procedure IsNumeric(var FREAttribute: Record "FRE Attribute"): Boolean
    begin
        exit(FREAttribute.Type in [FREAttribute.Type::Integer, FREAttribute.Type::Decimal]);
    end;

    procedure LoadFREAttributesFactBoxData(KeyValue: Code[20])
    var
        FREAttributeValueMapping: Record "FRE Attribute Value Mapping";
        FREAttributeValue: Record "FRE Attribute Value";
    begin
        Reset();
        DeleteAll();
        FREAttributeValueMapping.SetRange("Table ID", Database::"Fixed Real Estate");
        FREAttributeValueMapping.SetRange("No.", KeyValue);
        if FREAttributeValueMapping.FindSet() then
            repeat
                if FREAttributeValue.Get(FREAttributeValueMapping."FRE Attribute ID", FREAttributeValueMapping."FRE Attribute Value ID") then begin
                    TransferFields(FREAttributeValue);
                    OnLoadFREAttributesFactBoxDataOnBeforeInsert(FREAttributeValueMapping, Rec);
                    Insert();
                end
            until FREAttributeValueMapping.Next() = 0;
    end;

    procedure LoadCategoryAttributesFactBoxData(CategoryCode: Code[20])
    var
        FREAttributeValueMapping: Record "FRE Attribute Value Mapping";
        FREAttributeValue: Record "FRE Attribute Value";
        ItemCategory: Record "Item Category";
        Categories: List of [Code[20]];
    begin
        Reset();
        DeleteAll();
        if CategoryCode = '' then
            exit;
        FREAttributeValueMapping.SetRange("Table ID", Database::"Item Category");
        repeat
            if not Categories.Contains(CategoryCode) then
                Categories.Add(CategoryCode)
            else
                Error(CategoryStructureNotValidErr, CategoryCode);

            FREAttributeValueMapping.SetRange("No.", CategoryCode);
            if FREAttributeValueMapping.FindSet() then
                repeat
                    if FREAttributeValue.Get(FREAttributeValueMapping."FRE Attribute ID", FREAttributeValueMapping."FRE Attribute Value ID") then
                        if not AttributeExists(FREAttributeValue."Attribute ID") then begin
                            TransferFields(FREAttributeValue);
                            OnLoadFREAttributesFactBoxDataOnBeforeInsert(FREAttributeValueMapping, Rec);
                            Insert();
                        end;
                until FREAttributeValueMapping.Next() = 0;
            if ItemCategory.Get(CategoryCode) then
                CategoryCode := ItemCategory."Parent Category"
            else
                CategoryCode := '';
        until CategoryCode = '';
    end;

    procedure AttributeExists(AttributeID: Integer) AttribExist: Boolean
    begin
        SetRange("Attribute ID", AttributeID);
        AttribExist := not IsEmpty();
        Reset();
    end;

    [IntegrationEvent(false, false)]
    local procedure OnAfterGetValueInCurrentLanguage(FREAttributeValue: Record "FRE Attribute Value"; var ValueTxt: Text[250])
    begin
    end;

    [IntegrationEvent(false, false)]
    local procedure OnAfterHasBeenUsed(FREAttributeValue: Record "FRE Attribute Value"; var AttributeHasBeenUsed: Boolean)
    begin
    end;

    [IntegrationEvent(false, false)]
    local procedure OnBeforeSetValueFilter(var FREAttributeValue: Record "FRE Attribute Value"; FREAttribute: Record "FRE Attribute"; FilterText: Text; var IsHandled: Boolean)
    begin
    end;

    [IntegrationEvent(false, false)]
    local procedure OnGetValueInCurrentLanguage(FREAttribute: Record "FRE Attribute"; var FREAttributeValue: Record "FRE Attribute Value")
    begin
    end;

    [IntegrationEvent(false, false)]
    local procedure OnLoadFREAttributesFactBoxDataOnBeforeInsert(var FREAttributeValueMapping: Record "FRE Attribute Value Mapping"; var FREAttributeValue: Record "FRE Attribute Value")
    begin
    end;
}

