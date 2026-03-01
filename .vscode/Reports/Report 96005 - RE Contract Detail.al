report 96005 "RE Contract-Detail"
{
    DefaultLayout = RDLC;
    RDLCLayout = '.vscode/Reports/Report 96005 - RE Contract Detail.rdl';
    Caption = 'Service Contract-Detail';

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
                column(AnnualAmt_ServeContrHdr; "Lease Contract"."Amount per Period")
                {
                    IncludeCaption = true;
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
                                        WHERE ("Table Name"=CONST("Service Contract"));
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
                // Tomas FormatAddr.REContractSellto(CustAddr, "Lease Contract");
                IF NOT LeaseBankAccount.GET("Lease Contract"."Contract No.", "Lease Contract"."Preferred Bank Account Code") THEN LeaseBankAccount.INIT;
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
                        ToolTip = 'Specifies if you want the printed report to show any service comments.';
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
        ServiceContractCaptionLbl: Label 'Service Contract';
        ServeContrHdrStartDtCptnLbl: Label 'Starting Date';
        ServContrHdrNxtInvDtCptnLbl: Label 'Next Invoice Date';
        ServiceDiscountsCaptionLbl: Label 'Service Discounts';
        ServeCmntLineDateCaptionLbl: Label 'Date';
        ShiptoAddressCaptionLbl: Label 'Ship-to Address';
        CommentsCaptionLbl: Label 'Comments';
        StatusCaptionLbl: Label 'Status';
        InvoicePeriodCaptionLbl: Label 'Invoice Period';
        PrintLogo: Boolean;
}

