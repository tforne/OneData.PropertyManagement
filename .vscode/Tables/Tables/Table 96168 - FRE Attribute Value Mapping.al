namespace OneData.Property.Asset;
table 96168 "FRE Attribute Value Mapping"
{
    Caption = 'FRE Attribute Value Mapping';
    DataClassification = CustomerContent;
    DataPerCompany = false;

    fields
    {
        field(1; "Table ID"; Integer)
        {
            Caption = 'Table ID';
            Description = 'The table of the record to which the attribute applies (for example Database::Item or Database::"Item Category").';
        }
        field(2; "No."; Code[20])
        {
            Caption = 'No.';
            Description = 'The key of the record to which the attribute applies (the record type is specified by "Table ID").';
        }
        field(3; "FRE Attribute ID"; Integer)
        {
            Caption = 'FRE Attribute ID';
            TableRelation = "FRE Attribute";
        }
        field(4; "FRE Attribute Value ID"; Integer)
        {
            Caption = 'FRE Attribute Value ID';
            TableRelation = "FRE Attribute Value".ID;
        }
        field(50000; "Comment"; Text[50])
        {
            Caption = 'Comment';
        }
    }

    keys
    {
        key(Key1; "Table ID", "No.", "FRE Attribute ID")
        {
            Clustered = true;
        }
        key(Key2; "FRE Attribute ID", "FRE Attribute Value ID")
        {
        }
    }

    fieldgroups
    {
    }

    trigger OnDelete()
    var
        FREAttribute: Record "FRE Attribute";
        FREAttributeValue: Record "FRE Attribute Value";
        FREAttributeValueMapping: Record "FRE Attribute Value Mapping";
        IsHandled: Boolean;
    begin
        IsHandled := false;
        OnBeforeOnDelete(Rec, IsHandled);
        if IsHandled then
            exit;

        FREAttribute.Get("FRE Attribute ID");
        if FREAttribute.Type = FREAttribute.Type::Option then
            exit;

        if not FREAttributeValue.Get("FRE Attribute ID", "FRE Attribute Value ID") then
            exit;

        FREAttributeValueMapping.SetRange("FRE Attribute ID", "FRE Attribute ID");
        FREAttributeValueMapping.SetRange("FRE Attribute Value ID", "FRE Attribute Value ID");
        if FREAttributeValueMapping.Count <> 1 then
            exit;

        FREAttributeValueMapping := Rec;
        if FREAttributeValueMapping.Find() then
            FREAttributeValue.Delete();
    end;

    trigger OnInsert()
    var
        FREAttributeValue: Record "FRE Attribute Value";
        RecRef: RecordRef;
        FieldRef: FieldRef;
    begin
        RecRef.Open("Table ID");
        FieldRef := RecRef.Field(1);
        FieldRef.SetRange("No.");
        RecRef.FindFirst();

        if "FRE Attribute Value ID" <> 0 then
            FREAttributeValue.Get("FRE Attribute ID", "FRE Attribute Value ID");
    end;

    procedure RenameFREAttributeValueMapping(PrevNo: Code[20]; NewNo: Code[20])
    var
        FREAttributeValueMapping: Record "FRE Attribute Value Mapping";
    begin
        SetRange("Table ID", Database::"Fixed Real Estate");
        SetRange("No.", PrevNo);
        if FindSet() then
            repeat
                FREAttributeValueMapping := Rec;
                FREAttributeValueMapping.Rename("Table ID", NewNo, "FRE Attribute ID");
            until Next() = 0;
    end;

    [IntegrationEvent(false, false)]
    local procedure OnBeforeOnDelete(var FREAttributeValueMapping: Record "FRE Attribute Value Mapping"; var IsHandled: Boolean)
    begin
    end;
}

