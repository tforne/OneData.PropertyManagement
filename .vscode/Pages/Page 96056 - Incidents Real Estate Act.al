page 96056 "Incidents Real Estate Act."
{
    Caption = 'Incidents';
    PageType = CardPart;
    RefreshOnActivate = true;
    SourceTable = "RE Owner Cue";

    layout
    {
        area(content)
        {
            cuegroup(Incidents)
            {
                Caption = 'Incidentes';
                CueGroupLayout = Wide;
                
                field("Active Incidents";Rec."Active Incidents")
                {
                    ApplicationArea = All;
                    StyleExpr = IncidentCueStyle;
                    trigger OnDrillDown()
                    var
                        IncidentList: Page "Incidents List";
                        IncidentRec: Record "Incident Assets Real Estate";
                    begin
                        IncidentRec.RESET;
                        IncidentRec.SetRange(StateCode, IncidentRec.StateCode::Active);
                        IncidentList.SETTABLEVIEW(IncidentRec);
                        IncidentList.RUNMODAL;
                    end;
                }
                field("Tenants";Rec."Tenants")
                {
                    ApplicationArea = All;
                    trigger OnDrillDown()
                    var
                        RelatedContact: Page "REF Related Contactos";
                        RelatedContactRec: Record "REF Related Contactos";
                    begin
                        RelatedContactRec.RESET;
                        RelatedContactRec.SetRange(Type, RelatedContactRec.Type::Tenant);
                        RelatedContact.SETTABLEVIEW(RelatedContactRec);
                        RelatedContact.RUNMODAL;
                    end;
                }
            }
            cuegroup(Camera)
            {
                Caption = 'Scan documents';
                Visible = HasCamera;

                actions
                {
                    action(CreateIncidentFromCamera)
                    {
                        ApplicationArea = Suite;
                        Caption = 'Create Incidents from Camera';
                        Image = TileCamera;
                        ToolTip = 'Create an incidents by taking a photo of the document with your device camera. The photo will be attached to the new document.';

                        trigger OnAction()
                        var
                            Incident: Record "Incident Assets Real Estate";
                            InStr: InStream;
                            PictureName: Text;
                        begin
                            if not Camera.GetPicture(InStr, PictureName) then
                                exit;

                            Incident.CreateIncident(InStr, PictureName);
                            CurrPage.Update();
                        end;
                    }
                }
            }
        }
    }

    trigger OnAfterGetRecord()
    begin
        CalculateCueFieldValues;
    end;

    trigger OnOpenPage()
    begin
        rec.RESET;
        IF NOT rec.GET THEN BEGIN
            rec.INIT;
            rec.INSERT;
        END;
        rec.SETFILTER("Due Date Filter", '<=%1', WORKDATE);
        rec.SETFILTER("Overdue Date Filter", '<%1', WORKDATE);
        rec.SETFILTER("User ID Filter", USERID);
        HasCamera := Camera.IsAvailable();
    end;

    var
        FixedRealEstate: Record "Fixed Real Estate";
        HasCamera: Boolean;
        M2NotRental: Decimal;
        "%NotRental": Decimal;
        PriceM2: Decimal;
        Camera: Codeunit Camera;
        IncidentCueStyle: Text;

    local procedure CalculateCueFieldValues()
    begin

        M2NotRental := 0;
        FixedRealEstate.RESET;
        FixedRealEstate.SETRANGE(Status, FixedRealEstate.Status::"En alquiler");
        IF FixedRealEstate.FINDFIRST THEN
            REPEAT
                FixedRealEstate.CALCFIELDS(FixedRealEstate."Superficie construida");
                M2NotRental := M2NotRental + FixedRealEstate."Superficie construida";
            UNTIL FixedRealEstate.NEXT = 0;

        "%NotRental" := -100;
        IF rec."Builded surface" <> 0 THEN BEGIN
            "%NotRental" := M2NotRental / rec."Builded surface";
            PriceM2 := rec."Lease Contract Signed" / rec."Builded surface"
        END;
        
        if Rec."Active Incidents" = 0 then
            IncidentCueStyle := 'Favorable'
        else
            IncidentCueStyle := 'Unfavorable';
    end;
}

