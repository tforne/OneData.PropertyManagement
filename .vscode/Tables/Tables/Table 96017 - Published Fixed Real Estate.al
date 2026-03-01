table 96017 "Published Fixed Real Estate"
{
    DrillDownPageID = 96029;
    LookupPageID = 96029;

    fields
    {
        field(1; "Web Site Code"; Code[10])
        {
            Caption = 'Código sitio web';
            DataClassification = ToBeClassified;
            TableRelation = "Fixed Real Estate Web Site";
        }
        field(2; "Fixed Real Estate No."; Code[20])
        {
            Caption = 'No.';
            TableRelation = "Fixed Real Estate"."No.";
        }
    }

    keys
    {
        key(Key1;"Web Site Code","Fixed Real Estate No.")
        {
            Clustered = true;
        }
    }

    fieldgroups
    {
    }

    var
        PublishedFixedRealEstate: Record "Published Fixed Real Estate";

    procedure Publish(FixedRealEstate: Record "Fixed Real Estate")
    var
        FixedReadEstateWebSite: Record "Fixed Real Estate Web Site";
    begin
        FixedReadEstateWebSite.RESET;
        IF FixedReadEstateWebSite.FINDFIRST THEN REPEAT
          PublishedFixedRealEstate."Web Site Code" := FixedReadEstateWebSite.Code;
          PublishedFixedRealEstate."Fixed Real Estate No." := FixedRealEstate."No.";
          IF PublishedFixedRealEstate.INSERT THEN;
          UNTIL FixedReadEstateWebSite.NEXT = 0;
    end;
}

