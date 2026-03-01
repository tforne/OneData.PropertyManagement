codeunit 96005 "Publish Web Site Management"
{
    TableNo = "Fixed Real Estate Web Site";

    trigger OnRun()
    begin
        IF CONFIRM(STRSUBSTNO(Text015, Rec.Description), TRUE) THEN BEGIN
            FREPublicacionsRegister.CreateNew(Rec.Code, rec.Code);
            RunFilePublicCodeunit(rec.GetExportCodeunitID, rec.GetPublicExportXMLPortID, FixedRealEstate, rec.Code);
        END;
    end;

    var
        Text015: Label 'Quieres publicar el activo inmobiliario %1, en los webs configurados ?';
        FixedReadEstateWebSite: Record "Fixed Real Estate Web Site";
        FREPublicacionsRegister: Record "FRE Publicacions Register";
        FixedRealEstate: Record "Fixed Real Estate";

    procedure RunFilePublicCodeunit(CodeunitID: Integer; XMLPortId: Integer; FixedRealEstate: Record "Fixed Real Estate"; FixedReadEstateWebSiteCode: Code[10])
    var
        LastError: Text;
    begin
        FixedRealEstate."Codeunit Id." := CodeunitID;
        FixedRealEstate."XmlPort Id." := XMLPortId;
        FixedRealEstate."Web Site Id." := FixedReadEstateWebSiteCode;
        COMMIT;

        IF NOT CODEUNIT.RUN(CodeunitID, FixedRealEstate) THEN BEGIN
            LastError := GETLASTERRORTEXT;
            COMMIT;
            ERROR(LastError);
        END;
    end;
}

