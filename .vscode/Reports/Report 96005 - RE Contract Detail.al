report 96005 "RE Contract-Detail"
{
    DefaultLayout = RDLC;
    RDLCLayout = 'assets/Reports/Report 96005 - RE Contract Detail.rdl';
    Caption = 'Lease Contract-Detail';
    ApplicationArea = All;

    dataset
    {
        dataitem("Lease Contract"; "Lease Contract")
        {
            CalcFields = "Important Comments";
            DataItemTableView = SORTING ("Contract No.");
            PrintOnlyIfDetail = true;
            RequestFilterFields = "Contract No.", "Customer No.";
            column(ContrNo_ServeContrHdr; "Contract No.")
            {
                IncludeCaption = true;
            }
            dataitem(PageLoop; Integer)
            {
                DataItemTableView = SORTING (Number)
                                    ORDER(Descending)
                                    WHERE (Number = CONST (1));
                column(CompanyPicture; CompanyInfo.Picture)
                {
                }
                column(CustAddr6; CustAddr[6])
                {
                }
                column(CustAddr5; CustAddr[5])
                {
                }
                column(CustAddr4; CustAddr[4])
                {
                }
                column(CustAddr2; CustAddr[2])
                {
                }
                column(CustAddr3; CustAddr[3])
                {
                }
                column(CustAddr1; CustAddr[1])
                {
                }
                column(BilltoName_ServeContrHdr; "Lease Contract"."Second Name")
                {
                }
                column(CompanyAddr6; CompanyAddr[6])
                {
                }
                column(CompanyAddr5; CompanyAddr[5])
                {
                }
                column(CompanyAddr4; CompanyAddr[4])
                {
                }
                column(CompanyAddr3; CompanyAddr[3])
                {
                }
                column(CompanyAddr2; CompanyAddr[2])
                {
                }
                column(CompanyAddr1; CompanyAddr[1])
                {
                }
                column(ContrNo2_ServeContrHdr; "Lease Contract"."Contract No.")
                {
                }
                column(StartDate_ServeContrHdr; FORMAT("Lease Contract"."Starting Date"))
                {
                }
                column(InvPeriod_ServeContrHdr; FORMAT("Lease Contract"."Invoice Period"))
                {
                }
                column(InvoicePeriodCaption; InvoicePeriodCaptionLbl)
                {
                }
                column(NextInvDate_ServeContrHdr; FORMAT("Lease Contract"."Next Invoice Date"))
                {
                }
                column(ContractDateTxt; Format("Lease Contract"."Contract Date"))
                {
                }
                column(ExpirationDateTxt; Format("Lease Contract"."Expiration Date"))
                {
                }
                column(AnnualAmt_ServeContrHdr; "Lease Contract"."Amount per Period")
                {
                    IncludeCaption = true;
                }
                column(PaymentSummary; BuildPaymentSummary("Lease Contract"))
                {
                }
                column(IBANSummary; BuildIBANSummary())
                {
                }
                column(ContractHeaderSummary; BuildContractHeaderSummary("Lease Contract"))
                {
                }
                column(ContractPeriodSummary; BuildContractPeriodSummary("Lease Contract"))
                {
                }
                column(EconomicSummary; BuildEconomicSummary("Lease Contract"))
                {
                }
                column(AmountPerPeriodTxt; Format("Lease Contract"."Amount per Period"))
                {
                }
                column(AnnualAmountTxt; Format("Lease Contract"."Annual Amount"))
                {
                }
                column(PropertySummary; BuildPropertySummary("Lease Contract"))
                {
                }
                column(StatusSummary; BuildStatusSummary("Lease Contract"))
                {
                }
                column(Status_ServeContrHdr; FORMAT("Lease Contract".Status))
                {
                }
                column(CompanyInfoPhNo; CompanyInfo."Phone No.")
                {
                    IncludeCaption = false;
                }
                column(CompanyInfoFaxNo; CompanyInfo."Fax No.")
                {
                    IncludeCaption = false;
                }
                column(Email_ServeContrHdr; "Lease Contract"."E-Mail")
                {
                    IncludeCaption = true;
                }
                column(PhNo_ServeContrHdr; "Lease Contract"."Phone No.")
                {
                    IncludeCaption = true;
                }
                column(ShowComments; ShowComments)
                {
                }
                column(StatusCaption; StatusCaptionLbl)
                {
                }
                column(InvoicetoCaption; InvoicetoCaptionLbl)
                {
                }
                column(ServiceContractCaption; ServiceContractCaptionLbl)
                {
                }
                column(ServeContrHdrStartDtCptn; ServeContrHdrStartDtCptnLbl)
                {
                }
                column(ServContrHdrNxtInvDtCptn; ServContrHdrNxtInvDtCptnLbl)
                {
                }
                column(Description; "Lease Contract".Description)
                {
                }
                column(Status; "Lease Contract".Status)
                {
                }
                column(BailDescription; "Lease Contract"."Important Comments")
                {
                }
                column(PrintLogo; PrintLogo)
                {
                }
                column(FormadePago; "Lease Contract"."Payment Method Code")
                {
                }
                column(IBAN; LeaseBankAccount.IBAN)
                {
                }
                dataitem("Lease Contract Line"; "Lease Contract Line")
                {
                    DataItemLink = "Contract No."=FIELD("Contract No.");
                    DataItemLinkReference = "Lease Contract";
                    DataItemTableView = SORTING ("Contract No.", "Line No.");
                    column(Desc_ServeContrLine; Description)
                    {
                        IncludeCaption = true;
                    }
                    column(ServPeriod_ServeContrLine; "Service Period")
                    {
                        IncludeCaption = true;
                    }
                    column(RspTimeHrs_ServeContrLine; "Response Time (Hours)")
                    {
                        IncludeCaption = true;
                    }
                    column(UOMCode_ServeContrLine; "Unit of Measure Code")
                    {
                        IncludeCaption = true;
                    }
                    column(ContrNo_ServeContrLine; "Contract No.")
                    {
                    }
                    column(LineNo_ServeContrLine; "Line No.")
                    {
                    }
                    column(LCL_Description; Description)
                    {
                    }
                    column(LCL_HideAmounts; "Lease Contract Line".Type = "Lease Contract Line".Type::" ")
                    {
                    }
                    column(LCL_Amount; "Lease Contract Line".Amount)
                    {
                    }
                    column(LCL_VAT_Per; "Lease Contract Line"."VAT %")
                    {
                    }
                    column(LCL_VAT_Amount; "Lease Contract Line"."VAT Amount")
                    {
                    }
                }
                dataitem("Lease Comment Line"; "Lease Comment Line")
                {
                    DataItemLink = "No."=FIELD("Contract No.");
                    DataItemLinkReference = "Lease Contract";
                    DataItemTableView = SORTING ("Table Name", "Table Subtype", "No.", Type, "Table Line No.", "Line No.")
                                        WHERE ("Table Name"=CONST("Lease Contract"));
                    column(LCL_Date; "Lease Comment Line".Date)
                    {
                    }
                    column(LCL_Commet; "Lease Comment Line".Comment)
                    {
                    }
                }
            }

            trigger OnAfterGetRecord()
            begin
                CompanyInfo.SETAUTOCALCFIELDS(Picture);
                CompanyInfo.GET;

                FormatAddr.GetCompanyAddr("Responsibility Center", RespCenter, CompanyInfo, CompanyAddr);
                IF NOT LeaseBankAccount.GET("Lease Contract"."Contract No.", "Lease Contract"."Preferred Bank Account Code") THEN LeaseBankAccount.INIT;
                LoadTenantAddress("Lease Contract");
            end;
        }
    }

    requestpage
    {

        layout
        {
            area(content)
            {
                group(Options)
                {
                    Caption = 'Options';
                    field(ShowComments; ShowComments)
                    {
                        ApplicationArea = All;
                        Caption = 'Show Comments';
                        ToolTip = 'Specifies if you want the printed report to show any lease comments.';
                    }
                    field(PrintLogo; PrintLogo)
                    {
                        ApplicationArea = All;
                        Caption = 'Imprimir Logo';
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
        CompanyInfoPhNoCaption = 'Phone No.';
        CompanyInfoFaxNoCaption = 'Fax No.';
        ServcmntLine2DateCaption = 'Date';
        PageCaption = 'Page';
    }

    trigger OnInitReport()
    begin
        CompanyInfo.GET;
    end;

    var
        CompanyInfo: Record "Company Information";
        RespCenter: Record "Responsibility Center";
        LeaseBankAccount: Record "Lease Bank Account";
        FormatAddr: Codeunit "Format Address";
        CustAddr: array[8] of Text[50];
        CompanyAddr: array[8] of Text[50];
        ShipToAddr: array[8] of Text[50];
        ShowShippingAddr: Boolean;
        ShowComments: Boolean;
        InvoicetoCaptionLbl: Label 'Invoice to';
        ServiceContractCaptionLbl: Label 'Lease Contract';
        ServeContrHdrStartDtCptnLbl: Label 'Starting Date';
        ServContrHdrNxtInvDtCptnLbl: Label 'Next Invoice Date';
        ServiceDiscountsCaptionLbl: Label 'Lease Discounts';
        ServeCmntLineDateCaptionLbl: Label 'Date';
        ShiptoAddressCaptionLbl: Label 'Ship-to Address';
        CommentsCaptionLbl: Label 'Comments';
        StatusCaptionLbl: Label 'Status';
        InvoicePeriodCaptionLbl: Label 'Invoice Period';
        PrintLogo: Boolean;

    local procedure LoadTenantAddress(LeaseContract: Record "Lease Contract")
    begin
        Clear(CustAddr);
        CustAddr[1] := CopyStr(GetFirstNonEmpty(LeaseContract."Second Name", LeaseContract.Name), 1, MaxStrLen(CustAddr[1]));
        CustAddr[2] := CopyStr(JoinText(LeaseContract."Second Address", LeaseContract."Second Address 2", ' '), 1, MaxStrLen(CustAddr[2]));
        CustAddr[3] := CopyStr(JoinText(LeaseContract."Second Post Code", LeaseContract."Second City", ' '), 1, MaxStrLen(CustAddr[3]));
        CustAddr[4] := CopyStr(GetFirstNonEmpty(LeaseContract."Second Country/Region Code", LeaseContract."Country/Region Code"), 1, MaxStrLen(CustAddr[4]));
        CustAddr[5] := CopyStr(
            GetFirstNonEmpty(
                JoinText(LeaseContract."Phone No. 2", LeaseContract."E-Mail 2", ' | '),
                JoinText(LeaseContract."Phone No.", LeaseContract."E-Mail", ' | ')),
            1,
            MaxStrLen(CustAddr[5]));
        CustAddr[6] := CopyStr(BuildTenantReferenceLine(LeaseContract), 1, MaxStrLen(CustAddr[6]));
    end;

    local procedure BuildPaymentSummary(LeaseContract: Record "Lease Contract"): Text
    begin
        exit(JoinText(LeaseContract."Payment Method Code", LeaseContract."Payment Terms Code", ' | '));
    end;

    local procedure BuildIBANSummary(): Text
    begin
        if LeaseBankAccount.IBAN <> '' then
            exit(LeaseBankAccount.IBAN);

        exit('No informado');
    end;

    local procedure BuildContractHeaderSummary(LeaseContract: Record "Lease Contract"): Text
    var
        Summary: Text;
    begin
        Summary := LeaseContract."Contract No.";
        if LeaseContract."Your Reference" <> '' then
            Summary += StrSubstNo(' | Ref. %1', LeaseContract."Your Reference");
        exit(Summary);
    end;

    local procedure BuildContractPeriodSummary(LeaseContract: Record "Lease Contract"): Text
    begin
        exit(StrSubstNo('Desde %1 hasta %2', Format(LeaseContract."Starting Date"), Format(LeaseContract."Expiration Date")));
    end;

    local procedure BuildEconomicSummary(LeaseContract: Record "Lease Contract"): Text
    begin
        exit(
            StrSubstNo(
                '%1 por %2',
                Format(LeaseContract."Amount per Period"),
                Format(LeaseContract."Invoice Period"),
                Format(LeaseContract."Annual Amount")));
    end;

    local procedure BuildPropertySummary(LeaseContract: Record "Lease Contract"): Text
    var
        PropertyTitle: Text;
        PropertyAddress: Text;
    begin
        PropertyTitle := JoinText(LeaseContract."Fixed Real Estate No.", LeaseContract."Description Fixed Real Estate", ' - ');
        PropertyAddress := LeaseContract."FRE Address";

        if PropertyTitle = '' then
            exit(PropertyAddress);
        if PropertyAddress = '' then
            exit(PropertyTitle);

        exit(StrSubstNo('%1 | %2', PropertyTitle, PropertyAddress));
    end;

    local procedure BuildStatusSummary(LeaseContract: Record "Lease Contract"): Text
    begin
        exit(StrSubstNo('Estado: %1', Format(LeaseContract.Status)));
    end;

    local procedure BuildTenantReferenceLine(LeaseContract: Record "Lease Contract"): Text
    var
        TenantRef: Text;
    begin
        TenantRef := '';
        if LeaseContract."Second Customer No." <> '' then
            TenantRef := StrSubstNo('Cliente %1', LeaseContract."Second Customer No.");
        if LeaseContract."Your Reference" <> '' then
            TenantRef := JoinText(TenantRef, StrSubstNo('Ref. %1', LeaseContract."Your Reference"), ' | ');
        exit(TenantRef);
    end;

    local procedure GetFirstNonEmpty(PrimaryValue: Text; SecondaryValue: Text): Text
    begin
        if PrimaryValue <> '' then
            exit(PrimaryValue);
        exit(SecondaryValue);
    end;

    local procedure JoinText(LeftValue: Text; RightValue: Text; Separator: Text): Text
    begin
        if LeftValue = '' then
            exit(RightValue);
        if RightValue = '' then
            exit(LeftValue);
        exit(LeftValue + Separator + RightValue);
    end;
}

