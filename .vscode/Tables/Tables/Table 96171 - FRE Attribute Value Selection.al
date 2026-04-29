namespace OneData.Property.Asset;

using System.Globalization;
using System.Reflection;
table 96171 "FRE Attribute Value Selection"
{
    Caption = 'FRE Attribute Value Selection';
    Description = 'This table is used when selecting attributes for FREs or categories. It should only be used as temporary.';
    DataClassification = CustomerContent;
    DataPerCompany = false;

    fields
    {
        field(1; "Attribute Name"; Text[250])
        {
            Caption = 'Attribute Name';
            NotBlank = true;

            trigger OnValidate()
            var
                FREAttribute: Record "FRE Attribute";
            begin
                FindFREAttributeCaseInsensitive(FREAttribute);
                CheckForDuplicate();
                CheckIfBlocked(FREAttribute);
                AdjustAttributeName(FREAttribute);
                ValidateChangedAttribute(FREAttribute);
            end;
        }
        field(2; Value; Text[250])
        {
            Caption = 'Value';

            trigger OnValidate()
            var
                FREAttributeValue: Record "FRE Attribute Value";
                FREAttribute: Record "FRE Attribute";
                DecimalValue: Decimal;
                IntegerValue: Integer;
                DateValue: Date;
            begin
                if Value = '' then
                    exit;

                DateValue := 0D;
                DecimalValue := 0;
                IntegerValue := 0;

                FREAttribute.Get("Attribute ID");
                if FindFREAttributeValueCaseSensitive(FREAttributeValue) then
                    CheckIfValueBlocked(FREAttributeValue);

                case "Attribute Type" of
                    "Attribute Type"::Option:
                        begin
                            if FREAttributeValue.Value = '' then begin
                                if not FindFREAttributeValueCaseInsensitive(FREAttributeValue) then
                                    Error(AttributeValueDoesntExistErr, Value);
                                CheckIfValueBlocked(FREAttributeValue);
                            end;
                            AdjustAttributeValue(FREAttributeValue);
                        end;
                    "Attribute Type"::Decimal:
                        ValidateType(DecimalValue, Value, FREAttribute);
                    "Attribute Type"::Integer:
                        ValidateType(IntegerValue, Value, FREAttribute);
                    "Attribute Type"::Date:
                        ValidateType(DateValue, Value, FREAttribute);
                end;
            end;
        }
        field(3; "Attribute ID"; Integer)
        {
            Caption = 'Attribute ID';
        }
        field(4; "Unit of Measure"; Text[30])
        {
            Caption = 'Unit of Measure';
            Editable = false;
        }
        field(6; Blocked; Boolean)
        {
            Caption = 'Blocked';
        }
        field(7; "Attribute Type"; Option)
        {
            Caption = 'Attribute Type';
            OptionCaption = 'Option,Text,Integer,Decimal,Date';
            OptionMembers = Option,Text,"Integer",Decimal,Date;
        }
        field(8; "Inherited-From Table ID"; Integer)
        {
            Caption = 'Inherited-From Table ID';
        }
        field(9; "Inherited-From Key Value"; Code[20])
        {
            Caption = 'Inherited-From Key Value';
        }
        field(10; "Inheritance Level"; Integer)
        {
            Caption = 'Inheritance Level';
        }
        field(50000; "Comment"; Text[50])
        {
            Caption = 'Comment';
        }
    }

    keys
    {
        key(Key1; "Attribute Name")
        {
            Clustered = true;
        }
        key(Key2; "Inheritance Level", "Attribute Name")
        {
        }
    }

    fieldgroups
    {
        fieldgroup(DropDown; "Attribute ID")
        {
        }
        fieldgroup(Brick; "Attribute Name", Value, "Unit of Measure")
        {
        }
    }

    var
        AttributeDoesntExistErr: Label 'The FRE attribute ''%1'' doesn''t exist.', Comment = '%1 - arbitrary name';
        AttributeBlockedErr: Label 'The FRE attribute ''%1'' is blocked.', Comment = '%1 - arbitrary name';
        AttributeValueBlockedErr: Label 'The FRE attribute value ''%1'' is blocked.', Comment = '%1 - arbitrary name';
        AttributeValueDoesntExistErr: Label 'The FRE attribute value ''%1'' doesn''t exist.', Comment = '%1 - arbitrary name';
        AttributeValueAlreadySpecifiedErr: Label 'You have already specified a value for FRE attribute ''%1''.', Comment = '%1 - attribute name';
        AttributeValueTypeMismatchErr: Label 'The value ''%1'' does not match the FRE attribute of type %2.', Comment = ' %1 is arbitrary string, %2 is type name';

    procedure PopulateFREAttributeValueSelection(var TempFREAttributeValue: Record "FRE Attribute Value" temporary)
    begin
        PopulateFREAttributeValueSelection(TempFREAttributeValue, 0, '')
    end;

    procedure PopulateFREAttributeValueSelection(var TempFREAttributeValue: Record "FRE Attribute Value" temporary; DefinedOnTableID: Integer; DefinedOnKeyValue: Code[20])
    begin
        if TempFREAttributeValue.FindSet() then
            repeat
                InsertRecord(TempFREAttributeValue, DefinedOnTableID, DefinedOnKeyValue);
            until TempFREAttributeValue.Next() = 0;
    end;

    procedure PopulateFREAttributeValue(var TempNewFREAttributeValue: Record "FRE Attribute Value" temporary)
    var
        FREAttributeValue: Record "FRE Attribute Value";
        ValDecimal: Decimal;
        ValDate: Date;
    begin
        if FindSet() then
            repeat
                Clear(TempNewFREAttributeValue);
                TempNewFREAttributeValue.Init();
                TempNewFREAttributeValue."Attribute ID" := "Attribute ID";
                TempNewFREAttributeValue.Blocked := Blocked;
                FREAttributeValue.Reset();
                FREAttributeValue.SetRange("Attribute ID", "Attribute ID");
                case "Attribute Type" of
                    "Attribute Type"::Option,
                    "Attribute Type"::Text,
                    "Attribute Type"::Integer:
                        begin
                            TempNewFREAttributeValue.Value := Value;
                            FREAttributeValue.SetRange(Value, Value);
                        end;
                    "Attribute Type"::Decimal:
                        begin
                            if Value <> '' then begin
                                Evaluate(ValDecimal, Value);
                                FREAttributeValue.SetRange(Value, Format(ValDecimal, 0, 9));
                                if FREAttributeValue.IsEmpty() then begin
                                    FREAttributeValue.SetRange(Value, Format(ValDecimal));
                                    if FREAttributeValue.IsEmpty() then
                                        FREAttributeValue.SetRange(Value, Value);
                                end;
                            end else
                                FREAttributeValue.SetRange(Value, Value);
                            TempNewFREAttributeValue.Value := Format(ValDecimal);
                        end;
                    "Attribute Type"::Date:
                        begin
                            if Value <> '' then begin
                                Evaluate(ValDate, Value);
                                FREAttributeValue.SetRange(Value, Format(ValDate));
                                if FREAttributeValue.IsEmpty() then
                                    FREAttributeValue.SetRange(Value, Value);
                            end;
                            TempNewFREAttributeValue.Value := Format(ValDate);
                        end;
                end;
                if not FindFREAttributeValueByValueFilterIncludingTranslated(FREAttributeValue) then
                    InsertFREAttributeValue(FREAttributeValue, Rec);
                TempNewFREAttributeValue.ID := FREAttributeValue.ID;

                OnPopulateFREAttributeValueOnBeforeInsert(Rec, TempNewFREAttributeValue);
                TempNewFREAttributeValue.Insert();
            until Next() = 0;
    end;

    local procedure FindFREAttributeValueByValueFilterIncludingTranslated(var FREAttributeValue: Record "FRE Attribute Value"): Boolean
    var
        FREAttrValueTranslation: Record "FRE Attr. Value Translation";
    begin
        if FREAttributeValue.FindFirst() then
            exit(true);

        FREAttributeValue.CopyFilter("Attribute ID", FREAttrValueTranslation."Attribute ID");
        FREAttributeValue.CopyFilter(Value, FREAttrValueTranslation.Name);
        FREAttrValueTranslation.SetRange("Language Code", GetGlobalLanguageCode());

        if FREAttrValueTranslation.FindFirst() then begin
            FREAttributeValue.ID := FREAttrValueTranslation.ID;
            exit(true);
        end;

        exit(false);
    end;

    local procedure GetGlobalLanguageCode(): Text
    var
        WindowsLanguage: Record "Windows Language";
    begin
        WindowsLanguage.Get(GlobalLanguage());
        exit(WindowsLanguage."Abbreviated Name");
    end;

    procedure InsertFREAttributeValue(var FREAttributeValue: Record "FRE Attribute Value"; TempFREAttributeValueSelection: Record "FRE Attribute Value Selection" temporary)
    var
        ValDecimal: Decimal;
        ValDate: Date;
    begin
        Clear(FREAttributeValue);
        FREAttributeValue."Attribute ID" := TempFREAttributeValueSelection."Attribute ID";
        FREAttributeValue.Blocked := TempFREAttributeValueSelection.Blocked;
        case TempFREAttributeValueSelection."Attribute Type" of
            TempFREAttributeValueSelection."Attribute Type"::Option,
          TempFREAttributeValueSelection."Attribute Type"::Text:
                FREAttributeValue.Value := TempFREAttributeValueSelection.Value;
            TempFREAttributeValueSelection."Attribute Type"::Integer:
                FREAttributeValue.Validate(Value, TempFREAttributeValueSelection.Value);
            TempFREAttributeValueSelection."Attribute Type"::Decimal:
                if TempFREAttributeValueSelection.Value <> '' then begin
                    Evaluate(ValDecimal, TempFREAttributeValueSelection.Value);
                    FREAttributeValue.Validate(Value, Format(ValDecimal));
                end;
            TempFREAttributeValueSelection."Attribute Type"::Date:
                if TempFREAttributeValueSelection.Value <> '' then begin
                    Evaluate(ValDate, TempFREAttributeValueSelection.Value);
                    FREAttributeValue.Validate("Date Value", ValDate);
                end;
        end;
        OnInsertFREAttributeValueOnBeforeInsertFREAttributeValue(FREAttributeValue, TempFREAttributeValueSelection);
        FREAttributeValue.Insert();
    end;

    procedure InsertRecord(var TempFREAttributeValue: Record "FRE Attribute Value" temporary; DefinedOnTableID: Integer; DefinedOnKeyValue: Code[20])
    var
        FREAttribute: Record "FRE Attribute";
    begin
        "Attribute ID" := TempFREAttributeValue."Attribute ID";
        FREAttribute.Get(TempFREAttributeValue."Attribute ID");
        "Attribute Name" := FREAttribute.Name;
        "Attribute Type" := FREAttribute.Type;
        Value := TempFREAttributeValue.GetValueInCurrentLanguageWithoutUnitOfMeasure();
        Blocked := TempFREAttributeValue.Blocked;
        "Unit of Measure" := FREAttribute."Unit of Measure";
        "Inherited-From Table ID" := DefinedOnTableID;
        "Inherited-From Key Value" := DefinedOnKeyValue;
        OnInsertRecordOnBeforeFREAttrValueSelectionInsert(Rec, TempFREAttributeValue);
        Insert();
    end;

    local procedure ValidateType(Variant: Variant; ValueToValidate: Text; FREAttribute: Record "FRE Attribute")
    var
        TypeHelper: Codeunit "Type Helper";
        // CultureInfo: DotNet CultureInfo;
    begin
        if (ValueToValidate <> '') and not TypeHelper.Evaluate(Variant, ValueToValidate, '', '') then
            Error(AttributeValueTypeMismatchErr, ValueToValidate, FREAttribute.Type);
    end;

    procedure FindFREAttributeByName(var FREAttribute: Record "FRE Attribute")
    begin
        FindFREAttributeCaseInsensitive(FREAttribute);
    end;

    local procedure FindFREAttributeCaseInsensitive(var FREAttribute: Record "FRE Attribute")
    var
        AttributeName: Text[250];
    begin
        OnBeforeFindFREAttributeCaseInsensitive(FREAttribute, Rec);

        FREAttribute.SetRange(Name, "Attribute Name");
        if FREAttribute.FindFirst() then
            exit;

        AttributeName := LowerCase("Attribute Name");
        FREAttribute.SetRange(Name);
        if FREAttribute.FindSet() then
            repeat
                if LowerCase(FREAttribute.Name) = AttributeName then
                    exit;
            until FREAttribute.Next() = 0;

        Error(AttributeDoesntExistErr, "Attribute Name");
    end;

    local procedure FindFREAttributeValueCaseSensitive(var FREAttributeValue: Record "FRE Attribute Value"): Boolean
    begin
        FREAttributeValue.SetRange("Attribute ID", "Attribute ID");
        FREAttributeValue.SetRange(Value, Value);
        exit(FREAttributeValue.FindFirst());
    end;

    local procedure FindFREAttributeValueCaseInsensitive(var FREAttributeValue: Record "FRE Attribute Value"): Boolean
    var
        AttributeValue: Text[250];
    begin
        FREAttributeValue.SetRange("Attribute ID", "Attribute ID");
        FREAttributeValue.SetRange(Value);
        if FREAttributeValue.FindSet() then begin
            AttributeValue := LowerCase(Value);
            repeat
                if LowerCase(FREAttributeValue.Value) = AttributeValue then
                    exit(true);
            until FREAttributeValue.Next() = 0;
        end;
        exit(false);
    end;

    local procedure CheckForDuplicate()
    var
        TempFREAttributeValueSelection: Record "FRE Attribute Value Selection" temporary;
        AttributeName: Text[250];
    begin
        if IsEmpty() then
            exit;
        AttributeName := LowerCase("Attribute Name");
        TempFREAttributeValueSelection.Copy(Rec, true);
        if TempFREAttributeValueSelection.FindSet() then
            repeat
                if TempFREAttributeValueSelection."Attribute ID" <> "Attribute ID" then
                    if LowerCase(TempFREAttributeValueSelection."Attribute Name") = AttributeName then
                        Error(AttributeValueAlreadySpecifiedErr, "Attribute Name");
            until TempFREAttributeValueSelection.Next() = 0;
    end;

    local procedure CheckIfBlocked(var FREAttribute: Record "FRE Attribute")
    begin
        if FREAttribute.Blocked then
            Error(AttributeBlockedErr, FREAttribute.Name);
    end;

    local procedure CheckIfValueBlocked(FREAttributeValue: Record "FRE Attribute Value")
    begin
        if FREAttributeValue.Blocked then
            Error(AttributeValueBlockedErr, FREAttributeValue.Value);
    end;

    local procedure AdjustAttributeName(var FREAttribute: Record "FRE Attribute")
    begin
        if "Attribute Name" <> FREAttribute.Name then
            "Attribute Name" := FREAttribute.Name;
    end;

    local procedure AdjustAttributeValue(var FREAttributeValue: Record "FRE Attribute Value")
    begin
        if Value <> FREAttributeValue.Value then
            Value := FREAttributeValue.Value;
    end;

    local procedure ValidateChangedAttribute(var FREAttribute: Record "FRE Attribute")
    begin
        if "Attribute ID" <> FREAttribute.ID then begin
            Validate("Attribute ID", FREAttribute.ID);
            Validate("Attribute Type", FREAttribute.Type);
            Validate("Unit of Measure", FREAttribute."Unit of Measure");
            OnValidateChangedAttributeOnBeforeValidateValue(FREAttribute, Rec);
            Validate(Value, '');
        end;
    end;

    procedure FindAttributeValue(var FREAttributeValue: Record "FRE Attribute Value"): Boolean
    begin
        exit(FindAttributeValueFromRecord(FREAttributeValue, Rec));
    end;

    procedure FindAttributeValueFromRecord(var FREAttributeValue: Record "FRE Attribute Value"; FREAttributeValueSelection: Record "FRE Attribute Value Selection"): Boolean
    var
        ValDecimal: Decimal;
        ValDate: Date;
    begin
        FREAttributeValue.Reset();
        FREAttributeValue.SetRange("Attribute ID", FREAttributeValueSelection."Attribute ID");
        if IsNotBlankDecimal(FREAttributeValueSelection.Value) then begin
            Evaluate(ValDecimal, FREAttributeValueSelection.Value);
            FREAttributeValue.SetRange("Numeric Value", ValDecimal);
        end else
            if IsNotBlankDate() then begin
                Evaluate(ValDate, FREAttributeValueSelection.Value);
                FREAttributeValue.SetRange("Date Value", ValDate);
            end else
                FREAttributeValue.SetRange(Value, FREAttributeValueSelection.Value);
        OnFindAttributeValueFromRecordOnBeforeFindAttributeValueFromRecord(FREAttributeValue, FREAttributeValueSelection);
        exit(FREAttributeValue.FindFirst());
    end;

    procedure GetAttributeValueID(var TempFREAttributeValueToInsert: Record "FRE Attribute Value" temporary): Integer
    var
        FREAttributeValue: Record "FRE Attribute Value";
        FREAttribute: Record "FRE Attribute";
        ValDecimal: Decimal;
        ValDate: Date;
        ValInteger: Integer;
    begin
        if not FindAttributeValue(FREAttributeValue) then begin
            FREAttributeValue."Attribute ID" := "Attribute ID";
            FREAttribute.Get("Attribute ID");
            if Value <> '' then
                case FREAttribute.Type of
                    FREAttribute.Type::Decimal:
                        begin
                            Evaluate(ValDecimal, Value);
                            FREAttributeValue.Validate(Value, Format(ValDecimal));
                        end;
                    FREAttribute.Type::Date:
                        begin
                            Evaluate(ValDate, Value);
                            FREAttributeValue.Validate(Value, Format(ValDate));
                        end;
                    FREAttribute.Type::Integer:
                        begin
                            Evaluate(ValInteger, Value);
                            FREAttributeValue.Validate(Value, Format(ValInteger));
                        end;
                    else
                        FREAttributeValue.Value := Value;
                end;
            FREAttributeValue.Insert();
        end;
        TempFREAttributeValueToInsert.TransferFields(FREAttributeValue);
        OnGetAttributeValueIDOnBeforeInsertTempFREAttributeValue(TempFREAttributeValueToInsert, FREAttributeValue);
        TempFREAttributeValueToInsert.Insert();
        exit(FREAttributeValue.ID);
    end;

    procedure IsNotBlankDecimal(TextValue: Text[250]) Result: Boolean
    var
        FREAttribute: Record "FRE Attribute";
        IsHandled: Boolean;
    begin
        IsHandled := false;
        OnBeforeIsNotBlankDecimal(Rec, TextValue, Result, IsHandled);
        if IsHandled then
            exit(Result);

        if TextValue = '' then
            exit(false);
        FREAttribute.Get("Attribute ID");
        exit(FREAttribute.Type = FREAttribute.Type::Decimal);
    end;

    procedure IsNotBlankDate(): Boolean
    var
        FREAttribute: Record "FRE Attribute";
    begin
        if Value = '' then
            exit(false);
        FREAttribute.Get("Attribute ID");
        exit(FREAttribute.Type = FREAttribute.Type::Date);
    end;

    [IntegrationEvent(false, false)]
    local procedure OnBeforeFindFREAttributeCaseInsensitive(var FREAttribute: Record "FRE Attribute"; var FREAttributeValueSelection: Record "FRE Attribute Value Selection")
    begin
    end;

    [IntegrationEvent(false, false)]
    local procedure OnBeforeIsNotBlankDecimal(var FREAttributeValueSelection: Record "FRE Attribute Value Selection"; TextValue: Text[250]; var Result: Boolean; var IsHandled: Boolean)
    begin
    end;

    [IntegrationEvent(false, false)]
    local procedure OnInsertRecordOnBeforeFREAttrValueSelectionInsert(var FREAttributeValueSelection: Record "FRE Attribute Value Selection"; TempFREAttributeValue: Record "FRE Attribute Value" temporary)
    begin
    end;

    [IntegrationEvent(false, false)]
    local procedure OnPopulateFREAttributeValueOnBeforeInsert(FREAttributeValueSelection: Record "FRE Attribute Value Selection"; var TempFREAttributeValue: Record "FRE Attribute Value" temporary);
    begin
    end;

    [IntegrationEvent(false, false)]
    local procedure OnValidateChangedAttributeOnBeforeValidateValue(FREAttribute: Record "FRE Attribute"; var FREAttributeValueSelection: Record "FRE Attribute Value Selection")
    begin
    end;

    [IntegrationEvent(false, false)]
    local procedure OnInsertFREAttributeValueOnBeforeInsertFREAttributeValue(var FREAttributeValue: Record "FRE Attribute Value"; var TempFREAttributeValueSelection: Record "FRE Attribute Value Selection" temporary)
    begin
    end;

    [IntegrationEvent(false, false)]
    local procedure OnFindAttributeValueFromRecordOnBeforeFindAttributeValueFromRecord(var FREAttributeValue: Record "FRE Attribute Value"; FREAttributeValueSelection: Record "FRE Attribute Value Selection")
    begin
    end;

    [IntegrationEvent(false, false)]
    local procedure OnGetAttributeValueIDOnBeforeInsertTempFREAttributeValue(var TempFREAttributeValueToInsert: Record "FRE Attribute Value" temporary; var FREAttributeValue: Record "FRE Attribute Value")
    begin
    end;
}

