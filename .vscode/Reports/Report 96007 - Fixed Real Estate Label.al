report 96007 "Fixed Real Estate - Label"
{
    DefaultLayout = RDLC;
    RDLCLayout = '.vscode/Reports/Report 96007 - Fixed Estate Label.rdl';
    ApplicationArea = FixedAssets;
    Caption = 'Fixed Real Estate List';
    PreviewMode = Normal;
    UsageCategory = ReportsAndAnalysis;

    dataset
    {
        dataitem("Fixed Real Estate"; "Fixed Real Estate")
        {
            DataItemTableView = SORTING ("No.")
                                WHERE (Type = CONST (Activo));
            RequestFilterFields = "No.";
            column(CompanyName; COMPANYPROPERTY.DISPLAYNAME)
            {
            }
            column(FATableCaptionFAFilter; TABLECAPTION + ': ' + FAFilter)
            {
            }
            column(FAFilter; FAFilter)
            {
            }
            column(FANo; "No.")
            {
                IncludeCaption = true;
            }
            column(FADesc; Description)
            {
            }
            column(City; "Fixed Real Estate".City)
            {
            }
            column(FASerialNo; "Cadastral reference")
            {
            }
            column(GlobalDim1CodeCaption; GlobalDim1CodeCaption)
            {
            }
            column(FAGlobalDim1Code; "Global Dimension 1 Code")
            {
            }
            column(GlobalDim2CodeCaption; GlobalDim2CodeCaption)
            {
            }
            column(FAGlobalDim2Code; "Global Dimension 2 Code")
            {
            }
            column(FAClassCode; "FRE Class Code")
            {
                IncludeCaption = true;
            }
            column(FASubclassCode; "FRE Subclass Code")
            {
                IncludeCaption = true;
            }
            column(FAEImage; "Fixed Real Estate".Image)
            {
            }
            column(PageGroupNo; PageGroupNo)
            {
            }
            column(FAListCaption; FAListCaptionLbl)
            {
            }
            column(CurrReportPageNoCaption; CurrReportPageNoCaptionLbl)
            {
            }
            column(CompanyInfoPicture; AvatarFixedRealEstate."Avatar Picture")
            {
            }
            column(ReferenciaCatastral; "Cadastral reference")
            {
            }

            trigger OnAfterGetRecord()
            begin
                AvatarFixedRealEstate.GET("No.");
                CALCFIELDS(Picture);
                IF "Fixed Real Estate".Type = "Fixed Real Estate".Type::Propiedad THEN
                    AvatarFixedRealEstate.GET("No.");
                IF ("Fixed Real Estate".Type = "Fixed Real Estate".Type::Activo) AND ("Fixed Real Estate"."Property No." <> '') THEN
                    AvatarFixedRealEstate.GET("Property No.");

                AvatarFixedRealEstate.CALCFIELDS("Avatar Picture");


                IF PrintOnlyOnePerPage THEN
                    PageGroupNo := PageGroupNo + 1;

            end;

            trigger OnPreDataItem()
            begin
                PageGroupNo := 1;
            end;
        }
    }

    requestpage
    {
        SaveValues = true;

        layout
        {
            area(content)
            {
                group(Options)
                {
                    Caption = 'Options';
                    field(PrintOnlyOnePerPage; PrintOnlyOnePerPage)
                    {
                        ApplicationArea = FixedAssets;
                        Caption = 'New Page per Asset';
                        ToolTip = 'Specifies if you want each fixed asset printed on a new page.';
                    }
                }
            }
        }

        actions
        {
        }
    }

    labels
    {
    }

    trigger OnPreReport()
    var
        GeneralLedgerSetup: Record "General Ledger Setup";
        // Dimension: Record Dimemn;
    begin
        FAFilter := "Fixed Real Estate".GETFILTERS;
        GeneralLedgerSetup.GET;
        CompanyInfo.GET;
        CompanyInfo.CALCFIELDS(Picture);
    end;

    var
        CompanyInfo: Record "Company Information";
        REFASetup: Record "REF Setup";
        AvatarFixedRealEstate: Record "Fixed Real Estate";
        PrintOnlyOnePerPage: Boolean;
        FAFilter: Text;
        PageGroupNo: Integer;
        FAListCaptionLbl: Label 'Fixed Asset - List';
        CurrReportPageNoCaptionLbl: Label 'Page';
        FADeprBookDeprStartDateCaptionLbl: Label 'Depreciation Starting Date';
        FADeprBookDeprEndDateCaptionLbl: Label 'Depreciation Ending Date';
        FADeprBookUsrDfndDeprDtCaptionLbl: Label 'First User-Defined Depr. Date';
        FADeprBookProjDisplDateCaptionLbl: Label 'Projected Disposal Date';
        FADeprBookStartDateCustomCaptionLbl: Label 'Depr. Starting Date (Custom 1)';
        FADeprBookEndDateCustomCptnLbl: Label 'Depr. Ending Date (Custom 1)';
        GlobalDim1CodeCaption: Text[80];
        GlobalDim2CodeCaption: Text[80];
}

