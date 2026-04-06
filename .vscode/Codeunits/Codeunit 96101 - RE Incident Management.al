codeunit 96101 "RE Incident Management"
{
    procedure CheckStatusConsistency(var Incident: Record "Incident Assets Real Estate")
    begin
        CheckDateConsistency(Incident);

        case Incident.StateCode of
            Incident.StateCode::Active:
                CheckActiveStatus(Incident);

            Incident.StateCode::Resolved:
                CheckResolvedStatus(Incident);

            Incident.StateCode::Canceled:
                CheckCanceledStatus(Incident);
        end;
    end;

    procedure OnValidateStateCode(var Incident: Record "Incident Assets Real Estate")
    begin
        case Incident.StateCode of
            Incident.StateCode::Active:
                begin
                    Incident."Resolution Date" := 0D;

                    if Incident.StatusCode in
                       [Incident.StatusCode::ProblemSolved,
                        Incident.StatusCode::InformationProvided,
                        Incident.StatusCode::Canceled]
                    then
                        Incident.StatusCode := Incident.StatusCode::InProgress;
                end;

            Incident.StateCode::Resolved:
                begin
                    if Incident."Resolution Date" = 0D then
                        Incident."Resolution Date" := Today;

                    if Incident.StatusCode in
                       [Incident.StatusCode::" ",
                        Incident.StatusCode::Canceled,
                        Incident.StatusCode::InProgress,
                        Incident.StatusCode::OnHold,
                        Incident.StatusCode::WaitingforDetails,
                        Incident.StatusCode::Researching,
                        Incident.StatusCode::Merged]
                    then
                        Incident.StatusCode := Incident.StatusCode::ProblemSolved;
                end;

            Incident.StateCode::Canceled:
                begin
                    if Incident."Resolution Date" = 0D then
                        Incident."Resolution Date" := Today;

                    Incident.StatusCode := Incident.StatusCode::Canceled;
                end;
        end;

        CheckStatusConsistency(Incident);
    end;

    procedure OnValidateStatusCode(var Incident: Record "Incident Assets Real Estate")
    begin
        case Incident.StatusCode of
            Incident.StatusCode::ProblemSolved,
            Incident.StatusCode::InformationProvided:
                begin
                    if Incident.StateCode <> Incident.StateCode::Resolved then
                        Incident.StateCode := Incident.StateCode::Resolved;

                    if Incident."Resolution Date" = 0D then
                        Incident."Resolution Date" := Today;
                end;

            Incident.StatusCode::Canceled:
                begin
                    if Incident.StateCode <> Incident.StateCode::Canceled then
                        Incident.StateCode := Incident.StateCode::Canceled;

                    if Incident."Resolution Date" = 0D then
                        Incident."Resolution Date" := Today;
                end;

            Incident.StatusCode::InProgress,
            Incident.StatusCode::OnHold,
            Incident.StatusCode::WaitingforDetails,
            Incident.StatusCode::Researching,
            Incident.StatusCode::Merged:
                begin
                    if Incident.StateCode <> Incident.StateCode::Active then
                        Incident.StateCode := Incident.StateCode::Active;

                    Incident."Resolution Date" := 0D;
                end;
        end;

        CheckStatusConsistency(Incident);
    end;

    procedure OnValidateResolutionDate(var Incident: Record "Incident Assets Real Estate")
    begin
        if (Incident."Incident Date" <> 0D) and (Incident."Resolution Date" <> 0D) then
            if Incident."Resolution Date" < Incident."Incident Date" then
                Error('La fecha de resolución no puede ser anterior a la fecha de incidencia.');

        if Incident."Resolution Date" <> 0D then begin
            if Incident.StateCode = Incident.StateCode::Active then
                Incident.StateCode := Incident.StateCode::Resolved;

            if Incident.StatusCode in
               [Incident.StatusCode::" ",
                Incident.StatusCode::InProgress,
                Incident.StatusCode::OnHold,
                Incident.StatusCode::WaitingforDetails,
                Incident.StatusCode::Researching,
                Incident.StatusCode::Merged]
            then
                Incident.StatusCode := Incident.StatusCode::ProblemSolved;
        end;

        CheckStatusConsistency(Incident);
    end;

    procedure OnInsertIncident(var Incident: Record "Incident Assets Real Estate")
    begin
        if IsNullGuid(Incident."Incident Id.") then
            Incident."Incident Id." := CreateGuid();
            
        if Incident."Incident Date" = 0D then
            Incident."Incident Date" := Today;

        Incident.CreatedOn := CurrentDateTime;
        Incident.ModifiedOn := CurrentDateTime;

        CheckStatusConsistency(Incident);
    end;

    procedure OnModifyIncident(var Incident: Record "Incident Assets Real Estate")
    begin
        Incident.ModifiedOn := CurrentDateTime;
        CheckStatusConsistency(Incident);
    end;

    local procedure CheckDateConsistency(var Incident: Record "Incident Assets Real Estate")
    begin
        if (Incident."Incident Date" <> 0D) and (Incident."Expected Resolution Date" <> 0D) then
            if Incident."Expected Resolution Date" < Incident."Incident Date" then
                Error('La fecha prevista de resolución no puede ser anterior a la fecha de incidencia.');

        if (Incident."Incident Date" <> 0D) and (Incident."Resolution Date" <> 0D) then
            if Incident."Resolution Date" < Incident."Incident Date" then
                Error('La fecha de resolución no puede ser anterior a la fecha de incidencia.');

        if (Incident."Incident Date" <> 0D) and (Incident.FollowupBy <> 0D) then
            if Incident.FollowupBy < Incident."Incident Date" then
                Error('La fecha de seguimiento no puede ser anterior a la fecha de incidencia.');
    end;

    local procedure CheckActiveStatus(var Incident: Record "Incident Assets Real Estate")
    begin
        if Incident."Resolution Date" <> 0D then
            Error('Una incidencia activa no puede tener fecha de resolución.');

        if Incident.StatusCode in
           [Incident.StatusCode::ProblemSolved,
            Incident.StatusCode::InformationProvided,
            Incident.StatusCode::Canceled]
        then
            Error('El motivo de estado no es válido para una incidencia activa.');
    end;

    local procedure CheckResolvedStatus(var Incident: Record "Incident Assets Real Estate")
    begin
        if Incident."Resolution Date" = 0D then
            Error('Debe informar la fecha de resolución cuando la incidencia esté resuelta.');


    end;

    local procedure CheckCanceledStatus(var Incident: Record "Incident Assets Real Estate")
    begin
        if Incident.StatusCode <> Incident.StatusCode::Canceled then
            Error('El motivo de estado debe ser Cancelado cuando la incidencia esté cancelada.');

        if Incident."Resolution Date" = 0D then
            Error('Debe informar la fecha de cierre cuando la incidencia esté cancelada.');
    end;
}