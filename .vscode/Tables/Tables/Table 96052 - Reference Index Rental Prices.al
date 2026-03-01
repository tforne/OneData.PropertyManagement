table 96052 "Reference Index Rental Prices"
{
    Caption = 'Reference Index Rental Prices';

    fields
    {
        field(1; "Fixed Real Estate No."; Code[20])
        {
            Caption = 'Fixed Real Estate No.';
            DataClassification = ToBeClassified;
            TableRelation = "Fixed Real Estate";
        }
        field(2; "Line No."; Integer)
        {
            AutoIncrement = true;
            Caption = 'Line No.';
            DataClassification = ToBeClassified;
        }
        field(3; Date; Date)
        {
            DataClassification = ToBeClassified;
        }
        field(4; "Index Rental Price"; Decimal)
        {
            DataClassification = ToBeClassified;

            trigger OnValidate()
            begin
                CalculateArea;
                Price := "Index Rental Price" * Area;
            end;
        }
        field(5; "Area"; Decimal)
        {
            DataClassification = ToBeClassified;

            trigger OnValidate()
            begin
                Price := "Index Rental Price" * Area;
            end;
        }
        field(10; Price; Decimal)
        {
            DataClassification = ToBeClassified;
            Editable = false;
        }
        field(50; Active; Boolean)
        {
            DataClassification = ToBeClassified;

            trigger OnValidate()
            begin
                IF Rec.Active THEN BEGIN
                    ReferenceIndexRentalPrices.RESET;
                    ReferenceIndexRentalPrices.SETRANGE("Fixed Real Estate No.", Rec."Fixed Real Estate No.");
                    ReferenceIndexRentalPrices.SETFILTER("Line No.", '<>%1', Rec."Line No.");
                    IF ReferenceIndexRentalPrices.FINDSET THEN
                        ReferenceIndexRentalPrices.MODIFYALL(Active, FALSE);

                END;
            end;
        }
        field(100; Comments; Text[80])
        {
            DataClassification = ToBeClassified;
        }
    }

    keys
    {
        key(Key1; "Fixed Real Estate No.", "Line No.")
        {
            Clustered = true;
        }
    }

    fieldgroups
    {
    }

    trigger OnModify()
    begin
        // CalculateArea;
    end;

    var
        FixedRealEstate: Record "Fixed Real Estate";
        ReferenceIndexRentalPrices: Record "Reference Index Rental Prices";

    local procedure CalculateArea()
    begin
        IF FixedRealEstate.GET("Fixed Real Estate No.") THEN BEGIN
            FixedRealEstate.CALCFIELDS("Superficie construida");
            VALIDATE(Area, FixedRealEstate."Superficie construida")
        END;
    end;
}

