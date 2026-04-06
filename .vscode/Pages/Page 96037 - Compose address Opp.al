page 96037 "Compose address Opp"
{
    DeleteAllowed = false;
    InsertAllowed = false;
    PageType = Card;
    ShowFilter = false;
    SourceTable = Opportunity;
    ApplicationArea = All;

    layout
    {
        area(content)
        {
            group(General)
            {
                field("Street Type Id."; rec."Street Type Id.")
                {
                    trigger OnValidate()
                    begin
                        Compose;
                    end;
                }
                field("Types Street Numbering Id."; rec."Types Street Numbering Id.")
                {
                    trigger OnValidate()
                    begin
                        Compose;
                    end;
                }
                field("Street Name"; rec."Street Name")
                {
                    trigger OnValidate()
                    begin
                        Compose;
                    end;
                }
                field("Number On Street"; rec."Number On Street")
                {
                    trigger OnValidate()
                    begin
                        Compose;
                    end;
                }
                field("Location Height Floor"; rec."Location Height Floor")
                {
                    trigger OnValidate()
                    begin
                        Compose;
                    end;
                }
                field(ComposseAddress; ComposseAddress)
                {
                    Editable = true;
                }
            }
        }
    }

    actions
    {
    }

    var
        StreetType: Record "Street Type";
        TypesStreetNumbering: Record "Types Street Numbering";
        ComposseAddress: Text[50];

    local procedure Compose()
    begin
        IF NOT StreetType.GET(rec."Street Type Id.") THEN StreetType.INIT;
        IF NOT TypesStreetNumbering.GET(rec."Types Street Numbering Id.") THEN TypesStreetNumbering.INIT;
        ComposseAddress := '';
        IF StreetType.Description <> '' THEN
            ComposseAddress := StreetType.Description;
        IF rec."Street Name" <> '' THEN
            ComposseAddress := ComposseAddress + ' ' + rec."Street Name";
        IF rec."Number On Street" <> '' THEN
            ComposseAddress := ComposseAddress + ', ' + rec."Number On Street";

        IF rec."Location Height Floor" <> '' THEN
            ComposseAddress := ComposseAddress + ', ' + rec."Location Height Floor";

        rec."Composse Address" := ComposseAddress;

        /*
        ComposseAddress := STRSUBSTNO('%1 %2, %3, %5', StreetType.Description, "Stree Name", "Number On Street",
                                TypesStreetNumbering.Description,"Location Height Floor")
        */

    end;
}

