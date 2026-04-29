namespace OneData.Property.Asset;

using System.Globalization;

table 96166 "FRE Attribute"
{
    Caption = 'FRE Attribute';
    DataCaptionFields = Name;
    LookupPageID = "FRE Attributes";
    DataClassification = CustomerContent;
    DataPerCompany = false;

    fields
    {
        field(1; ID; Integer)
        {
            AutoIncrement = true;
            Caption = 'ID';
            NotBlank = true;
        }
        field(2; Name; Text[250])
        {
            Caption = 'Name';
            NotBlank = true;

            trigger OnValidate()
            begin
                if xRec.Name = Name then
                    exit;

                TestField(Name);
                if HasBeenUsed() then
                    if not Confirm(RenameUsedAttributeQst) then
                        Error('');
                CheckNameUniqueness(Rec, Name);
                DeleteValuesAndTranslationsConditionally(xRec, Name);
            end;
        }
        field(6; Blocked; Boolean)
        {
            Caption = 'Blocked';
        }
        field(7; Type; Option)
        {
            Caption = 'Type';
            InitValue = Text;
            OptionCaption = 'Option,Text,Integer,Decimal,Date';
            OptionMembers = Option,Text,"Integer",Decimal,Date;

            trigger OnValidate()
            var
                FREAttributeValue: Record "FRE Attribute Value";
            begin
                if xRec.Type <> Type then begin
                    FREAttributeValue.SetRange("Attribute ID", ID);
                    if not FREAttributeValue.IsEmpty() then
                        Error(ChangingAttributeTypeErr, Name);
                end;
            end;
        }
        field(8; "Unit of Measure"; Text[30])
        {
            Caption = 'Unit of Measure';

            trigger OnValidate()
            begin
                if (xRec."Unit of Measure" <> '') and (xRec."Unit of Measure" <> "Unit of Measure") then
                    if HasBeenUsed() then
                        if not Confirm(ChangeUsedAttributeUoMQst) then
                            Error('');
            end;
        }
        field(96000; "Fixed Type"; Text[250])
        {
            Caption = 'Tipo de activo';
            TableRelation = "Type Fixed Real Estate";
        }
        field(96001; "Used in"; Integer)
        {
            Caption = 'Utilizado en';
        }
    }

    keys
    {
        key(Key1; ID)
        {
            Clustered = true;
        }
        key(Key2; Name)
        {
        }
    }

    fieldgroups
    {
        fieldgroup(DropDown; Name)
        {
        }
        fieldgroup(Brick; ID, Name)
        {
        }
    }

    trigger OnDelete()
    begin
        if HasBeenUsed() then
            if not Confirm(DeleteUsedAttributeQst) then
                Error('');
        DeleteValuesAndTranslations();
    end;

    trigger OnRename()
    var
        FREAttributeValue: Record "FRE Attribute Value";
    begin
        FREAttributeValue.SetRange("Attribute ID", xRec.ID);
        if FREAttributeValue.FindSet() then
            repeat
                FREAttributeValue.Rename(ID, FREAttributeValue.ID);
            until FREAttributeValue.Next() = 0;
    end;

    trigger OnInsert()
    begin
        TestField(Name);
    end;

    var
        FREAttributeTranslation: Record "FRE Attribute Translation";
        NameAlreadyExistsErr: Label 'The FRE attribute with name ''%1'' already exists.', Comment = '%1 - arbitrary name';
        ReuseValueTranslationsQst: Label 'There are values and translations for FRE attribute ''%1''.\\Do you want to reuse them after changing the FRE attribute name to ''%2''?', Comment = '%1 - arbitrary name,%2 - arbitrary name';
        ChangingAttributeTypeErr: Label 'You cannot change the type of FRE attribute ''%1'', because it is either in use or it has predefined values.', Comment = '%1 - arbirtrary text';
        DeleteUsedAttributeQst: Label 'This FRE attribute has been assigned to at least one FRE.\\Are you sure you want to delete it?';
        RenameUsedAttributeQst: Label 'This FRE attribute has been assigned to at least one FRE.\\Are you sure you want to rename it?';
        ChangeUsedAttributeUoMQst: Label 'This FRE attribute has been assigned to at least one FRE.\\Are you sure you want to change its unit of measure?';
        ChangeToOptionQst: Label 'Predefined values can be defined only for FRE attributes of type Option.\\Do you want to change the type of this FRE attribute to Option?';

    procedure GetTranslatedName(LanguageID: Integer) TranslatedName: Text[250]
    var
        Language: Codeunit Language;
        LanguageCode: Code[10];
        IsHandled: Boolean;
    begin
        OnBeforeGetTranslatedName(Rec, LanguageID, TranslatedName, IsHandled);
        if IsHandled then
            exit(TranslatedName);

        LanguageCode := Language.GetLanguageCode(LanguageID);
        if LanguageCode <> '' then begin
            GetAttributeTranslation(LanguageCode);
            exit(FREAttributeTranslation.Name);
        end;
        exit(Name);
    end;

    procedure GetNameInCurrentLanguage(): Text[250]
    begin
        exit(GetTranslatedName(GlobalLanguage));
    end;

    local procedure GetAttributeTranslation(LanguageCode: Code[10])
    begin
        if (FREAttributeTranslation."Attribute ID" <> ID) or (FREAttributeTranslation."Language Code" <> LanguageCode) then
            if not FREAttributeTranslation.Get(ID, LanguageCode) then begin
                FREAttributeTranslation.Init();
                FREAttributeTranslation."Attribute ID" := ID;
                FREAttributeTranslation."Language Code" := LanguageCode;
                FREAttributeTranslation.Name := Name;
                OnGetAttributeTranslationOnAfterCreateNewTranslation(Rec, FREAttributeTranslation);
            end;
    end;

    procedure GetValues() Values: Text
    var
        FREAttributeValue: Record "FRE Attribute Value";
    begin
        if Type <> Type::Option then
            exit('');
        FREAttributeValue.SetRange("Attribute ID", ID);
        if FREAttributeValue.FindSet() then
            repeat
                if Values <> '' then
                    Values += ',';
                Values += FREAttributeValue.Value;
            until FREAttributeValue.Next() = 0;
    end;

    procedure HasBeenUsed() AttributeHasBeenUsed: Boolean
    var
        FREAttributeValueMapping: Record "FRE Attribute Value Mapping";
    begin
        FREAttributeValueMapping.SetRange("FRE Attribute ID", ID);
        AttributeHasBeenUsed := not FREAttributeValueMapping.IsEmpty();
        OnAfterHasBeenUsed(Rec, AttributeHasBeenUsed);
    end;

    procedure RemoveUnusedArbitraryValues()
    var
        FREAttributeValue: Record "FRE Attribute Value";
    begin
        if Type = Type::Option then
            exit;

        FREAttributeValue.SetRange("Attribute ID", ID);
        if FREAttributeValue.FindSet() then
            repeat
                if not FREAttributeValue.HasBeenUsed() then
                    FREAttributeValue.Delete();
            until FREAttributeValue.Next() = 0;
    end;

    procedure OpenFREAttributeValues()
    var
        FREAttributeValue: Record "FRE Attribute Value";
    begin
        FREAttributeValue.SetRange("Attribute ID", ID);
        if (Type <> Type::Option) and FREAttributeValue.IsEmpty() then
            if Confirm(ChangeToOptionQst) then begin
                Validate(Type, Type::Option);
                Modify();
            end;

        if Type = Type::Option then
            PAGE.Run(PAGE::"FRE Attribute Values", FREAttributeValue);
    end;

    local procedure CheckNameUniqueness(FREAttribute: Record "FRE Attribute"; NameToCheck: Text[250])
    begin
        OnBeforeCheckNameUniqueness(FREAttribute, Rec);

        FREAttribute.SetRange(Name, NameToCheck);
        FREAttribute.SetFilter(ID, '<>%1', FREAttribute.ID);
        if not FREAttribute.IsEmpty() then
            Error(NameAlreadyExistsErr, NameToCheck);
    end;

    local procedure DeleteValuesAndTranslationsConditionally(FREAttribute: Record "FRE Attribute"; NameToCheck: Text[250])
    var
        FREAttributeTranslation: Record "FRE Attribute Translation";
        FREAttributeValue: Record "FRE Attribute Value";
        ValuesOrTranslationsExist: Boolean;
    begin
        if (FREAttribute.Name <> '') and (FREAttribute.Name <> NameToCheck) then begin
            FREAttributeValue.SetRange("Attribute ID", ID);
            FREAttributeTranslation.SetRange("Attribute ID", ID);
            ValuesOrTranslationsExist := not (FREAttributeValue.IsEmpty() and FREAttributeTranslation.IsEmpty);
            if ValuesOrTranslationsExist then
                if not Confirm(StrSubstNo(ReuseValueTranslationsQst, FREAttribute.Name, NameToCheck)) then
                    DeleteValuesAndTranslations();
        end;
    end;

    local procedure DeleteValuesAndTranslations()
    var
        FREAttributeValue: Record "FRE Attribute Value";
        FREAttributeValueMapping: Record "FRE Attribute Value Mapping";
        FREAttrValueTranslation: Record "FRE Attr. Value Translation";
    begin
        FREAttributeValueMapping.SetRange("FRE Attribute ID", ID);
        FREAttributeValueMapping.DeleteAll();

        FREAttributeValue.SetRange("Attribute ID", ID);
        FREAttributeValue.DeleteAll();

        FREAttributeTranslation.SetRange("Attribute ID", ID);
        FREAttributeTranslation.DeleteAll();

        FREAttrValueTranslation.SetRange("Attribute ID", ID);
        FREAttrValueTranslation.DeleteAll();
    end;

    [IntegrationEvent(false, false)]
    local procedure OnAfterHasBeenUsed(var FREAttribute: Record "FRE Attribute"; var AttributeHasBeenUsed: Boolean)
    begin
    end;

    [IntegrationEvent(false, false)]
    local procedure OnBeforeCheckNameUniqueness(var NewFREAttribute: Record "FRE Attribute"; FREAttribute: Record "FRE Attribute")
    begin
    end;

    [IntegrationEvent(false, false)]
    local procedure OnBeforeGetTranslatedName(var FREAttribute: Record "FRE Attribute"; LanguageID: Integer; var TranslatedName: Text[250]; var IsHandled: Boolean)
    begin
    end;

    [IntegrationEvent(false, false)]
    local procedure OnGetAttributeTranslationOnAfterCreateNewTranslation(FREAttribute: Record "FRE Attribute"; var FREAttributeTranslation: Record "FRE Attribute Translation")
    begin
    end;
}

