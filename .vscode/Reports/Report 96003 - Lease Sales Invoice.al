report 96003 "Lease Sales - Invoice"
{
    DefaultLayout = RDLC;
    RDLCLayout = '.vscode/Reports/Report 96003 - Lease Sales Invoice.rdl';
    Caption = 'Lease Sales - Invoice';
    EnableHyperlinks = true;
    PreviewMode = PrintLayout;
    ApplicationArea = All;

    dataset
    {
        dataitem("Lease Invoice Header"; "Lease Invoice Header")
        {
            DataItemTableView = SORTING("No.");
            RequestFilterFields = "No.";
            RequestFilterHeading = 'Posted Sales Invoice';
            column(No_SalesInvHdr; "No.")
            {
            }
            column(PaymentTermsDescription; PaymentTerms.Description)
            {
            }
            column(FixedRealEstateDescription; FixedRealEstateDescription)
            {
            }
            column(PaymentMethodDescription; PaymentMethod.Description)
            {
            }
            column(PmtTermsDescCaption; PmtTermsDescCaptionLbl)
            {
            }
            column(FixedRealEstateDescriptionCaptionLbl; FixedRealEstateDescriptionCaptionLbl)
            {
            }
            column(PmtMethodDescCaption; PmtMethodDescCaptionLbl)
            {
            }
            column(DocDateCaption; DocDateCaptionLbl)
            {
            }
            column(HomePageCaption; HomePageCaptionLbl)
            {
            }
            column(EmailCaption; EmailCaptionLbl)
            {
            }
            column(DisplayAdditionalFeeNote; DisplayAdditionalFeeNote)
            {
            }
            column(infoIVAEnableCaption; infoIVA)
            {
            }
            column(shipCodeCaption; shipNameValue)
            {
            }
            column(OwnerTextCaption; OwnerText)
            {
            }
            column(IRPFAmountCaptionHeader; IRPFAmountCaptionLbl)
            {
            }
            column(TotalAmountIRPFHeader; TotalAmountIRPF)
            {
                AutoFormatExpression = "Lease Invoice Header"."Currency Code";
                AutoFormatType = 1;
            }

            column(ContractNo_LeaseInvHdr; "Contract No.")
            {
            }
            column(ContractNoCaption; ContractNoCaptionLbl)
            {
            }
            column(InvoiceTitleCaption; InvoiceTitleCaptionLbl)
            {
            }
            column(CustomerBlockCaption; CustomerBlockCaptionLbl)
            {
            }
            column(PropertyBlockCaption; PropertyBlockCaptionLbl)
            {
            }
            column(PaymentBlockCaption; PaymentBlockCaptionLbl)
            {
            }
            column(TotalsBlockCaption; TotalsBlockCaptionLbl)
            {
            }
            column(OwnerNameCaption; OwnerNameCaptionLbl)
            {
            }
            column(OwnerVatCaption; OwnerVatCaptionLbl)
            {
            }
            column(VATAmountCaptionHeader; VATAmountCaptionLbl)
            {
            }
            column(PropertySummaryText; PropertySummaryText)
            {
            }
            column(PaymentSummaryText; PaymentSummaryText)
            {
            }
            column(FooterNoteText; FooterNoteText)
            {
            }
            column(YourReference_SalesInvHdr; "Your Reference")
            {
            }
            column(BilltoCustNo_SalesInvHdr; "Customer No.")
            {
            }
            column(Currency_SalesInvHdr; "Currency Code")
            {
            }
            column(PostingDate_SalesInvHdr; FORMAT("Posting Date", 0, 4))
            {
            }
            column(VATRegNo_SalesInvHeader; "VAT Registration No.")
            {
            }
            column(DueDate_SalesInvHeader; FORMAT("Due Date", 0, 4))
            {
            }
            column(No_SalesInvoiceHeader1; "No.")
            {
            }
            column(DocDate_SalesInvoiceHdr; FORMAT("Document Date", 0, 4))
            {
            }
            column(PricesInclVAT_SalesInvHdr; "Prices Including VAT")
            {
            }
            column(BilltoCustNo_SalesInvHdrCaption; FIELDCAPTION("Customer No."))
            {
            }
            column(PricesInclVAT_SalesInvHdrCaption; FIELDCAPTION("Prices Including VAT"))
            {
            }
            column(VATBaseDisc_SalesInvHdr; "VAT Base Discount %")
            {
                AutoFormatType = 1;
            }
            dataitem(CopyLoop; Integer)
            {
                DataItemTableView = SORTING(Number);
                dataitem(PageLoop; Integer)
                {
                    DataItemTableView = SORTING(Number)
                                        WHERE(Number = CONST(1));
                    column(CompanyInfo2Picture; CompanyInfo2.Picture)
                    {
                    }
                    column(CompanyInfo1Picture; CompanyInfo1.Picture)
                    {
                    }
                    column(CompanyInfo3Picture; CompanyInfo3.Picture)
                    {
                    }
                    column(DocumentCaption; STRSUBSTNO(DocumentCaption, CopyText))
                    {
                    }
                    column(CustAddr1; CustAddr[1])
                    {
                    }
                    column(CompanyAddr1; CompanyAddr[1])
                    {
                    }
                    column(CustAddr2; CustAddr[2])
                    {
                    }
                    column(CompanyAddr2; CompanyAddr[2])
                    {
                    }
                    column(CustAddr3; CustAddr[3])
                    {
                    }
                    column(CompanyAddr3; CompanyAddr[3])
                    {
                    }
                    column(CustAddr4; CustAddr[4])
                    {
                    }
                    column(CompanyAddr4; CompanyAddr[4])
                    {
                    }
                    column(CustAddr5; CustAddr[5])
                    {
                    }
                    column(CompanyInfoPhoneNo; CompanyInfo."Phone No.")
                    {
                    }
                    column(CustAddr6; CustAddr[6])
                    {
                    }
                    column(CompanyInfoVATRegistrationNo; CompanyInfo."VAT Registration No.")
                    {
                    }
                    column(CompanyInfoHomePage; CompanyInfo."Home Page")
                    {
                    }
                    column(CompanyInfoEmail; CompanyInfo."E-Mail")
                    {
                    }
                    column(CompanyInfoGiroNo; CompanyInfo."Giro No.")
                    {
                    }
                    column(CompanyInfoBankName; CompanyInfo."Bank Name")
                    {
                    }
                    column(CompanyInfoBankAccountNo; CompanyInfo."Bank Account No.")
                    {
                    }
                    column(currencyTextCaption; currencyText)
                    {
                    }
                    column(VATNoText; VATNoText)
                    {
                    }
                    column(SalesPersonText; SalesPersonText)
                    {
                    }
                    column(SalesPurchPersonName; SalesPurchPerson.Name)
                    {
                    }
                    column(ReferenceText; ReferenceText)
                    {
                    }
                    column(OwnerName; OwnerName)
                    {
                    }
                    column(OwnerCIF_NIF; "OwnerCIF/NIF")
                    {
                    }
                    column(CustAddr7; CustAddr[7])
                    {
                    }
                    column(CustAddr8; CustAddr[8])
                    {
                    }
                    column(CompanyAddr5; CompanyAddr[5])
                    {
                    }
                    column(CompanyAddr6; CompanyAddr[6])
                    {
                    }
                    column(OutputNo; OutputNo)
                    {
                    }
                    column(PageCaption; PageCaptionCap)
                    {
                    }
                    column(PhoneNoCaption; PhoneNoCaptionLbl)
                    {
                    }
                    column(VATRegNoCaption; VATRegNoCaptionLbl)
                    {
                    }
                    column(GiroNoCaption; GiroNoCaptionLbl)
                    {
                    }
                    column(BankNameCaption; BankNameCaptionLbl)
                    {
                    }
                    column(BankAccNoCaption; BankAccNoCaptionLbl)
                    {
                    }
                    column(DueDateCaption; DueDateCaptionLbl)
                    {
                    }
                    column(InvoiceNoCaption; InvoiceNoCaptionLbl)
                    {
                    }
                    column(PostingDateCaption; PostingDateCaptionLbl)
                    {
                    }
                    column(CACCaption; CACCaptionLbl)
                    {
                    }
                    dataitem("Lease Invoice Line"; "Lease Invoice Line")
                    {
                        DataItemLink = "Document No." = FIELD("No.");
                        DataItemLinkReference = "Lease Invoice Header";
                        DataItemTableView = SORTING("Document No.", "Line No.");
                        // column(GetCarteraInvoice; GetCarteraInvoice)
                        // {
                        // }
                        column(LineAmt_SalesInvoiceLine; "Line Amount")
                        {
                            AutoFormatExpression = GetCurrencyCode;
                            AutoFormatType = 1;
                        }
                        column(Description_SalesInvLine; itemDescription)
                        {
                        }
                        column(No_SalesInvoiceLine; "No.")
                        {
                        }
                        column(Quantity_SalesInvoiceLine; Quantity)
                        {
                            AutoFormatType = 2;
                        }
                        column(UOM_SalesInvoiceLine; "Unit of Measure")
                        {
                        }
                        column(UnitPrice_SalesInvLine; "Unit Price")
                        {
                            AutoFormatExpression = GetCurrencyCode;
                            AutoFormatType = 2;
                        }
                        column(LineDisc_SalesInvoiceLine; "Line Discount %")
                        {
                        }
                        column(VATIdent_SalesInvLine; "VAT Identifier")
                        {
                        }
                        column(Type_SalesInvoiceLine; FORMAT(Type))
                        {
                        }
                        column(TotalSubTotal; TotalSubTotal)
                        {
                            AutoFormatExpression = "Lease Invoice Header"."Currency Code";
                            AutoFormatType = 1;
                        }
                        column(TotalInvoiceDiscountAmount; TotalInvoiceDiscountAmount)
                        {
                            AutoFormatExpression = "Lease Invoice Header"."Currency Code";
                            AutoFormatType = 1;
                        }
                        column(TotalAmount; TotalAmount - TotalAmountIRPF)
                        {
                            AutoFormatExpression = "Lease Invoice Header"."Currency Code";
                            AutoFormatType = 1;
                        }
                        column(TotalGivenAmount; TotalGivenAmount)
                        {
                        }
                        column(packagingCaption; "Item Format")
                        {
                        }
                        column(packaging; "Item Format")
                        {
                        }
                        column(SalesInvoiceLineAmount; Amount)
                        {
                            AutoFormatExpression = "Lease Invoice Line".GetCurrencyCode;
                            AutoFormatType = 1;
                        }
                        column(AmountIncludingVATAmount; "Amount Including VAT" - Amount)
                        {
                            AutoFormatExpression = GetCurrencyCode;
                            AutoFormatType = 1;
                        }
                        column(Amount_SalesInvoiceLineIncludingVAT; "Amount Including VAT")
                        {
                            AutoFormatExpression = GetCurrencyCode;
                            AutoFormatType = 1;
                        }
                        column(VATAmtLineVATAmtText; VATAmountLine.VATAmountText)
                        {
                        }
                        column(TotalExclVATText; TotalExclVATText)
                        {
                        }
                        column(TotalInclVATText; TotalInclVATText)
                        {
                        }
                        column(TotalAmountInclVAT; TotalAmountInclVAT)
                        {
                            AutoFormatExpression = "Lease Invoice Header"."Currency Code";
                            AutoFormatType = 1;
                        }
                        column(TotalAmountVAT; TotalAmountVAT)
                        {
                            AutoFormatExpression = "Lease Invoice Header"."Currency Code";
                            AutoFormatType = 1;
                        }
                        column(TotalAmountIRPF; TotalAmountIRPF)
                        {
                            AutoFormatExpression = "Lease Invoice Header"."Currency Code";
                            AutoFormatType = 1;
                        }
                        column(TotalPaymentDiscountOnVAT; TotalPaymentDiscountOnVAT)
                        {
                            AutoFormatType = 1;
                        }
                        column(VATAmtLineVATCalcType; VATAmountLine."VAT Calculation Type")
                        {
                        }
                        column(LineNo_SalesInvoiceLine; "Line No.")
                        {
                        }
                        column(PmtinvfromdebtpaidtoFactCompCaption; PmtinvfromdebtpaidtoFactCompCaptionLbl)
                        {
                        }
                        column(UnitPriceCaption; UnitPriceCaptionLbl)
                        {
                        }
                        column(DiscountCaption; DiscountCaptionLbl)
                        {
                        }
                        column(AmtCaption; AmtCaptionLbl)
                        {
                        }
                        column(PostedShpDateCaption; PostedShpDateCaptionLbl)
                        {
                        }
                        column(InvDiscAmtCaption; InvDiscAmtCaptionLbl)
                        {
                        }
                        column(SubtotalCaption; SubtotalCaptionLbl)
                        {
                        }
                        column(PmtDiscGivenAmtCaption; PmtDiscGivenAmtCaptionLbl)
                        {
                        }
                        column(PmtDiscVATCaption; PmtDiscVATCaptionLbl)
                        {
                        }
                        column(Description_SalesInvLineCaption; FIELDCAPTION(Description))
                        {
                        }
                        column(No_SalesInvoiceLineCaption; FIELDCAPTION("No."))
                        {
                        }
                        column(Quantity_SalesInvoiceLineCaption; skippedQtyCaption)
                        {
                        }
                        column(VATIdent_SalesInvLineCaption; FIELDCAPTION("VAT Identifier"))
                        {
                        }
                        column(IsLineWithTotals; LineNoWithTotal = "Line No.")
                        {
                        }
                        column(Description2_SalesInvoiceLineValue; "Lease Invoice Line"."Description 2")
                        {
                        }
                        column(code_SalesInvoiceLineCaption; codeCaption)
                        {
                        }
                        column(itemUOM_SalesInvoiceLineCaption; uomCaption)
                        {
                        }
                        column(qtyShipped_SalesInvoiceLineCaption; qtyShippedCaption)
                        {
                        }

                        trigger OnAfterGetRecord()
                        var
                            custRec: Record Customer;
                            order: Record "Sales Header";
                            orderL: Record "Sales Line";
                        begin
                            IF VATPostingSetup.GET("Lease Invoice Line"."VAT Bus. Posting Group", "Lease Invoice Line"."VAT Prod. Posting Group") THEN BEGIN
                                IF VATPostingSetup."VAT Calculation Type" <> VATPostingSetup."VAT Calculation Type"::"No Taxable VAT" THEN BEGIN
                                    VATAmountLine.INIT;
                                    VATAmountLine."VAT Identifier" := "VAT Identifier";
#pragma warning disable AL0603
                                    VATAmountLine."VAT Calculation Type" := "VAT Calculation Type";
#pragma warning restore AL0603
                                    VATAmountLine."VAT %" := VATPostingSetup."VAT %";
                                    VATAmountLine."EC %" := VATPostingSetup."EC %";
                                    VATAmountLine."VAT Base" := "Lease Invoice Line".Amount;
                                    VATAmountLine."Amount Including VAT" := "Lease Invoice Line"."Amount Including VAT";
                                    VATAmountLine."Line Amount" := "Line Amount";
                                    IF "Allow Invoice Disc." THEN
                                        VATAmountLine."Inv. Disc. Base Amount" := "Line Amount";
                                    VATAmountLine.SetCurrencyCode("Lease Invoice Header"."Currency Code");
                                    VATAmountLine."VAT Difference" := "VAT Difference";
                                    IF "Lease Invoice Header"."Prices Including VAT" THEN
                                        VATAmountLine."Prices Including VAT" := TRUE;
                                    VATAmountLine.InsertLine;
                                    CalcVATAmountLineLCY(
                                      "Lease Invoice Header", VATAmountLine, TempVATAmountLineLCY,
                                      VATBaseRemainderAfterRoundingLCY, AmtInclVATRemainderAfterRoundingLCY);
                                END;
                                TotalSubTotal += "Line Amount";
                                TotalAmount += Amount;
                                TotalAmountVAT += "Amount Including VAT" - Amount;
                                TotalAmountInclVAT += "Amount Including VAT";
                                TotalPaymentDiscountOnVAT += -("Line Amount" - "Amount Including VAT");

                            END;
                            IF (Type = Type::"G/L Account") AND (NOT ShowInternalInfo) THEN
                                "No." := '';

                            
                            itemDescription := "Lease Invoice Line".Description;
                        end;

                        trigger OnPreDataItem()
                        begin
                            VATAmountLine.DELETEALL;
                            TempVATAmountLineLCY.DELETEALL;
                            VATBaseRemainderAfterRoundingLCY := 0;
                            AmtInclVATRemainderAfterRoundingLCY := 0;
                            FirstValueEntryNo := 0;
                            MoreLines := FIND('+');
                            WHILE MoreLines AND (Description = '') AND ("No." = '') AND (Quantity = 0) AND (Amount = 0) DO
                                MoreLines := NEXT(-1) <> 0;
                            IF NOT MoreLines THEN
                                CurrReport.BREAK;
                            LineNoWithTotal := "Line No.";
                            SETRANGE("Line No.", 0, "Line No.");
                            // CurrReport.CREATETOTALS("Line Amount", Amount, "Amount Including VAT");
                        end;
                    }
                    dataitem(VATCounter; Integer)
                    {
                        DataItemTableView = SORTING(Number);
                        column(VATAmountLineVATBase; VATAmountLine."VAT Base")
                        {
                            AutoFormatExpression = "Lease Invoice Line".GetCurrencyCode;
                            AutoFormatType = 1;
                        }
                        column(VATAmountLineVATAmount; VATAmountLine."VAT Amount")
                        {
                            AutoFormatExpression = "Lease Invoice Header"."Currency Code";
                            AutoFormatType = 1;
                        }
                        column(VATAmountLineLineAmount; VATAmountLine."Line Amount")
                        {
                            AutoFormatExpression = "Lease Invoice Header"."Currency Code";
                            AutoFormatType = 1;
                        }
                        column(VATAmtLineInvDiscBaseAmt; VATAmountLine."Inv. Disc. Base Amount")
                        {
                            AutoFormatExpression = "Lease Invoice Header"."Currency Code";
                            AutoFormatType = 1;
                        }
                        column(VATAmtLineInvDiscountAmt; VATAmountLine."Invoice Discount Amount")
                        {
                            AutoFormatExpression = "Lease Invoice Header"."Currency Code";
                            AutoFormatType = 1;
                        }
                        column(VATAmtLineECAmount; VATAmountLine."EC Amount")
                        {
                            AutoFormatExpression = "Lease Invoice Header"."Currency Code";
                            AutoFormatType = 1;
                        }
                        column(VATAmountLineVAT; VATAmountLine."VAT %")
                        {
                            DecimalPlaces = 0 : 5;
                        }
                        column(VATAmtLineVATIdentifier; VATAmountLine."VAT Identifier")
                        {
                        }
                        column(VATAmountLineEC; VATAmountLine."EC %")
                        {
                            AutoFormatExpression = "Lease Invoice Header"."Currency Code";
                            AutoFormatType = 1;
                        }
                        column(VATAmtLineVATCaption; VATAmtLineVATCaptionLbl)
                        {
                        }
                        column(VATECBaseCaption; VATECBaseCaptionLbl)
                        {
                        }
                        column(VATAmountCaption; VATAmountCaptionLbl)
                        {
                        }
                        column(VATAmtSpecCaption; VATAmtSpecCaptionLbl)
                        {
                        }
                        column(VATIdentCaption; VATIdentCaptionLbl)
                        {
                        }
                        column(IRPFAmountCaption; IRPFAmountCaptionLbl)
                        {
                        }
                        column(InvDiscBaseAmtCaption; InvDiscBaseAmtCaptionLbl)
                        {
                        }
                        column(LineAmtCaption1; LineAmtCaption1Lbl)
                        {
                        }
                        column(InvPmtDiscCaption; InvPmtDiscCaptionLbl)
                        {
                        }
                        column(ECAmtCaption; ECAmtCaptionLbl)
                        {
                        }
                        column(ECCaption; ECCaptionLbl)
                        {
                        }
                        column(TotalCaption; TotalCaptionLbl)
                        {
                        }

                        trigger OnAfterGetRecord()
                        begin
                            VATAmountLine.GetLine(Number);
                            IF VATAmountLine."VAT Amount" = 0 THEN
                                VATAmountLine."VAT %" := 0;
                            IF VATAmountLine."EC Amount" = 0 THEN
                                VATAmountLine."EC %" := 0;
                        end;

                        trigger OnPreDataItem()
                        begin
                            SETRANGE(Number, 1, VATAmountLine.COUNT);
                            // CurrReport.CREATETOTALS(
                            //   VATAmountLine."Line Amount", VATAmountLine."Inv. Disc. Base Amount",
                            //   VATAmountLine."Invoice Discount Amount", VATAmountLine."VAT Base", VATAmountLine."VAT Amount",
                            //   VATAmountLine."EC Amount");
                        end;
                    }
                    dataitem(VATClauseEntryCounter; Integer)
                    {
                        DataItemTableView = SORTING(Number);
                        column(VATClauseVATIdentifier; VATAmountLine."VAT Identifier")
                        {
                        }
                        column(VATClauseCode; VATAmountLine."VAT Clause Code")
                        {
                        }
                        column(VATClauseDescription; VATClause.Description)
                        {
                        }
                        column(VATClauseDescription2; VATClause."Description 2")
                        {
                        }
                        column(VATClauseAmount; VATAmountLine."VAT Amount")
                        {
                            AutoFormatExpression = "Lease Invoice Header"."Currency Code";
                            AutoFormatType = 1;
                        }
                        column(VATClausesCaption; VATClausesCap)
                        {
                        }
                        column(VATClauseVATIdentifierCaption; VATIdentifierCaptionLbl)
                        {
                        }
                        column(VATClauseVATAmtCaption; VATAmtCaptionLbl)
                        {
                        }

                        trigger OnAfterGetRecord()
                        begin
                            VATAmountLine.GetLine(Number);
                            IF NOT VATClause.GET(VATAmountLine."VAT Clause Code") THEN
                                CurrReport.SKIP;
                            VATClause.TranslateDescription("Lease Invoice Header"."Language Code");
                        end;

                        trigger OnPreDataItem()
                        begin
                            CLEAR(VATClause);
                            SETRANGE(Number, 1, VATAmountLine.COUNT);
                            // CurrReport.CREATETOTALS(VATAmountLine."VAT Amount");
                        end;
                    }
                    dataitem(VatCounterLCY; Integer)
                    {
                        DataItemTableView = SORTING(Number);
                        column(VALSpecLCYHeader; VALSpecLCYHeader)
                        {
                        }
                        column(VALExchRate; VALExchRate)
                        {
                        }
                        column(VALVATBaseLCY; VALVATBaseLCY)
                        {
                            AutoFormatType = 1;
                        }
                        column(VALVATAmountLCY; VALVATAmountLCY)
                        {
                            AutoFormatType = 1;
                        }
                        column(VATAmountLineVAT1; TempVATAmountLineLCY."VAT %")
                        {
                            DecimalPlaces = 0 : 5;
                        }
                        column(VATAmtLineVATIdentifier1; TempVATAmountLineLCY."VAT Identifier")
                        {
                        }
                        column(VALVATBaseLCYCaption1; VALVATBaseLCYCaption1Lbl)
                        {
                        }

                        trigger OnAfterGetRecord()
                        begin
                            TempVATAmountLineLCY.GetLine(Number);
                            VALVATBaseLCY := TempVATAmountLineLCY."VAT Base";
                            VALVATAmountLCY := TempVATAmountLineLCY."Amount Including VAT" - TempVATAmountLineLCY."VAT Base";
                        end;

                        trigger OnPreDataItem()
                        begin
                            IF (NOT GLSetup."Print VAT specification in LCY") OR
                               ("Lease Invoice Header"."Currency Code" = '')
                            THEN
                                CurrReport.BREAK;

                            SETRANGE(Number, 1, VATAmountLine.COUNT);
                            // CurrReport.CREATETOTALS(VALVATBaseLCY, VALVATAmountLCY);

                            IF GLSetup."LCY Code" = '' THEN
                                VALSpecLCYHeader := Text007 + Text008
                            ELSE
                                VALSpecLCYHeader := Text007 + FORMAT(GLSetup."LCY Code");

                            CurrExchRate.FindCurrency("Lease Invoice Header"."Posting Date", "Lease Invoice Header"."Currency Code", 1);
                            CalculatedExchRate := ROUND(1 / "Lease Invoice Header"."Currency Factor" * CurrExchRate."Exchange Rate Amount", 0.00001);
                            VALExchRate := STRSUBSTNO(Text009, CalculatedExchRate, CurrExchRate."Exchange Rate Amount");
                        end;
                    }
                    dataitem(PaymentReportingArgument; "Payment Reporting Argument")
                    {
                        DataItemTableView = SORTING(Key);
                        UseTemporary = true;
                        column(PaymentServiceLogo; Logo)
                        {
                        }
                        column(PaymentServiceURLText; "URL Caption")
                        {
                        }
                        column(PaymentServiceURL; GetTargetURL)
                        {
                        }

                        trigger OnPreDataItem()
                        var
                            PaymentServiceSetup: Record "Payment Service Setup";
                        begin
                            /*
                            PaymentServiceSetup.CreateReportingArgs(PaymentReportingArgument,"Lease Invoice Header");
                            IF ISEMPTY THEN
                              CurrReport.BREAK;
                            */

                        end;
                    }
                    dataitem(Total; Integer)
                    {
                        DataItemTableView = SORTING(Number)
                                            WHERE(Number = CONST(1));
                    }
                }

                trigger OnAfterGetRecord()
                begin
                    IF Number > 1 THEN BEGIN
                        CopyText := FormatDocument.GetCOPYText;
                        OutputNo += 1;
                    END;
                    // CurrReport.PAGENO := 1;
                end;

                trigger OnPostDataItem()
                begin
                    /*
                    IF NOT CurrReport.PREVIEW THEN
                      CODEUNIT.RUN(CODEUNIT::"Sales Inv.-Printed","Sales Invoice Header");
                    */

                end;

                trigger OnPreDataItem()
                begin
                    NoOfLoops := 1;
                    IF NoOfLoops <= 0 THEN
                        NoOfLoops := 1;
                    CopyText := '';
                    SETRANGE(Number, 1, NoOfLoops);
                    OutputNo := 1;

                    TotalSubTotal := 0;
                    TotalInvoiceDiscountAmount := 0;
                    TotalAmount := 0;
                    TotalAmountVAT := 0;
                    TotalAmountIRPF := 0;
                    TotalAmountInclVAT := 0;
                    TotalGivenAmount := 0;
                    TotalPaymentDiscountOnVAT := 0;
                    CalcTotalIRPFLCY("Lease Invoice Header");
                end;
            }

            trigger OnAfterGetRecord()
            begin

                IF NOT Cust.GET("Customer No.") THEN
                    CLEAR(Cust);



                IF NOT CurrReport.PREVIEW THEN BEGIN
                    SegManagement.LogDocument(
                        0, "No.", 0, 0, DATABASE::Customer, "Customer No.", "Salesperson Code",
                        '', "Posting Description", '');
                END;

                LeaseContract.GET("Lease Invoice Header"."Contract No.");
                FixedRealEstateDescription := '';
                IF FixedRealEstate.GET(LeaseContract."Fixed Real Estate No.") THEN BEGIN
                    FixedRealEstateDescription := FixedRealEstate.Description;
                END;
                // Propiedad
                OwnerName := '';
                ContactOwnerCode := '';
                REFRelatedContactos.SETRANGE("Entity Type", REFRelatedContactos."Entity Type"::Contract);
                REFRelatedContactos.SETRANGE("Source No.", "Lease Invoice Header"."Contract No.");
                REFRelatedContactos.SETRANGE(Type, REFRelatedContactos.Type::Owner);
                IF REFRelatedContactos.FINDFIRST THEN BEGIN
                    REFRelatedContactos.CALCFIELDS(Name, "VAT Registration No.");
                    OwnerName := REFRelatedContactos.Name;
                    ContactOwnerCode := REFRelatedContactos."Contact No.";
                    "OwnerCIF/NIF" := REFRelatedContactos."VAT Registration No."
                END;
                FormatAddressFields("Lease Invoice Header");
                FormatDocumentFields("Lease Invoice Header");
                PropertySummaryText := BuildPropertySummary("Lease Invoice Header");
                PaymentSummaryText := BuildPaymentSummary("Lease Invoice Header");
                FooterNoteText := BuildFooterNote();


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
                    field(NoOfCopies; NoOfCopies)
                    {
                        ApplicationArea = Basic, Suite;
                        Caption = 'No. of Copies';
                        ToolTip = 'Specifies how many copies of the document to print.';
                    }
                    field(DisplayAdditionalFeeNote; DisplayAdditionalFeeNote)
                    {
                        ApplicationArea = Basic, Suite;
                        Caption = 'Show Additional Fee Note';
                        ToolTip = 'Specifies that any notes about additional fees are included on the document.';
                    }
                    field(ShowInfoIVA; infoIVA)
                    {
                        ApplicationArea = All;
                        Caption = 'Mostrar información IVA';
                    }
                    field(Idioma; gcodeLanguageSuffix)
                    {
                        ApplicationArea = All;
                        TableRelation = Language;

                        trigger OnLookup(var Text: Text): Boolean
                        var
                            lfrmLanguage: Page "Languages";
                        begin

                            lfrmLanguage.SETTABLEVIEW(grecLanguage);
                            lfrmLanguage.SETRECORD(grecLanguage);
                            lfrmLanguage.LOOKUPMODE(TRUE);
                            lfrmLanguage.EDITABLE(FALSE);
                            IF lfrmLanguage.RUNMODAL = ACTION::LookupOK THEN BEGIN
                                lfrmLanguage.GETRECORD(grecLanguage);
                                gcodeLanguageSuffix := grecLanguage.Code;
                                //CurrReport.LANGUAGE := Language.GetLanguageID(gcodeLanguageSuffix);
                                CurrReport.Language := _Language.GetLanguageIdOrDefault("Lease Invoice Header"."Language Code");
                            END;
                            //20121107GLF.end
                            // <A26
                        end;

                        trigger OnValidate()
                        begin
                            // >A26
                            //20121107GLF.begin
                            grecLanguage.GET(gcodeLanguageSuffix);
                            // CurrReport.LANGUAGE := Language.GetLanguageID(gcodeLanguageSuffix);
                            CurrReport.Language := _Language.GetLanguageIdOrDefault("Lease Invoice Header"."Language Code");
                            //20121107GLF.end
                            // <A26
                        end;
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

    trigger OnInitReport()
    begin
        GLSetup.GET;
        SalesSetup.GET;
        CompanyInfo.GET;
        CompanyInfo.CALCFIELDS(Picture);
        FormatDocument.SetLogoPosition(SalesSetup."Logo Position on Documents", CompanyInfo1, CompanyInfo2, CompanyInfo3);
        CompanyInfo1.GET;
        CompanyInfo1.CALCFIELDS(Picture);
        CompanyInfo3.GET;
        CompanyInfo3.CALCFIELDS(Picture);
    end;

    trigger OnPreReport()
    begin

    end;

    var
        Text004: Label 'Lease - Sales Invoice %1', Comment = '%1 = Document No.';
        PageCaptionCap: Label 'Page %1 of %2';
        gcodeLanguageSuffix: Code[10];
        grecLanguage: Record Language;
        _Language: Codeunit Language;
        gLanguageCode: Code[10];
        GLSetup: Record "General Ledger Setup";
        PaymentTerms: Record "Payment Terms";
        SalesPurchPerson: Record "Salesperson/Purchaser";
        CompanyInfo: Record "Company Information";
        CompanyInfo1: Record "Company Information";
        CompanyInfo2: Record "Company Information";
        CompanyInfo3: Record "Company Information";
        SalesSetup: Record "Sales & Receivables Setup";
        Cust: Record Customer;
#pragma warning disable AL0432
        VATAmountLine: Record "VAT Amount Line" temporary;
#pragma warning restore AL0432
#pragma warning disable AL0432
        TempVATAmountLineLCY: Record "VAT Amount Line" temporary;
#pragma warning restore AL0432
        RespCenter: Record "Responsibility Center";
        RecLanguage: Record "Language";
        CurrExchRate: Record "Currency Exchange Rate";
        VATClause: Record "VAT Clause";
        FixedRealEstate: Record "Fixed Real Estate";
        LeaseContract: Record "Lease Contract";
        REFRelatedContactos: Record "REF Related Contactos";
        FormatAddr: Codeunit "Format Address";
        FormatDocument: Codeunit "Format Document";
        SegManagement: Codeunit "SegManagement";
        CustAddr: array[8] of Text[50];
        CompanyAddr: array[8] of Text[50];
        SalesPersonText: Text[30];
        VATNoText: Text[80];
        ReferenceText: Text[80];
        TotalText: Text[50];
        TotalExclVATText: Text[50];
        TotalInclVATText: Text[50];
        "Item Format": Text[30];
        MoreLines: Boolean;
        NoOfCopies: Integer;
        NoOfLoops: Integer;
        CopyText: Text[30];
        ShowShippingAddr: Boolean;
        NextEntryNo: Integer;
        FirstValueEntryNo: Integer;
        DimText: Text[120];
        OldDimText: Text[75];
        ShowInternalInfo: Boolean;
        Continue: Boolean;
        LogInteraction: Boolean;
        VALVATBaseLCY: Decimal;
        VALVATAmountLCY: Decimal;
        VALSpecLCYHeader: Text[80];
        Text007: Label 'VAT Amount Specification in ';
        Text008: Label 'Local Currency';
        VALExchRate: Text[50];
        Text009: Label 'Exchange rate: %1/%2';
        CalculatedExchRate: Decimal;
        Text010: Label 'Sales - Prepayment Custom Invoice %1';
        OutputNo: Integer;
        TotalSubTotal: Decimal;
        TotalAmount: Decimal;
        TotalAmountInclVAT: Decimal;
        TotalAmountVAT: Decimal;
        TotalAmountIRPF: Decimal;
        TotalInvoiceDiscountAmount: Decimal;
        TotalPaymentDiscountOnVAT: Decimal;
        VATPostingSetup: Record "VAT Posting Setup";
        PaymentMethod: Record "Payment Method";
        TotalGivenAmount: Decimal;

        DisplayAssemblyInformation: Boolean;
        PhoneNoCaptionLbl: Label 'Phone No.';
        VATRegNoCaptionLbl: Label 'VAT Registration No.';
        GiroNoCaptionLbl: Label 'Giro No.';
        BankNameCaptionLbl: Label 'Bank';
        BankAccNoCaptionLbl: Label 'Account No.';
        DueDateCaptionLbl: Label 'Due Date';
        InvoiceNoCaptionLbl: Label 'Invoice No.';
        PostingDateCaptionLbl: Label 'Invoice Date';
        HdrDimsCaptionLbl: Label 'Header Dimensions';
        PmtinvfromdebtpaidtoFactCompCaptionLbl: Label 'The payment of this invoice, in order to be released from the debt, has to be paid to the Factoring Company.';
        UnitPriceCaptionLbl: Label 'Unit Price';
        DiscountCaptionLbl: Label 'Discount %';
        AmtCaptionLbl: Label 'Amount';
        VATClausesCap: Label 'VAT Clause';
        PostedShpDateCaptionLbl: Label 'Posted Shipment Date';
        InvDiscAmtCaptionLbl: Label 'Invoice Discount Amount';
        SubtotalCaptionLbl: Label 'Subtotal';
        PmtDiscGivenAmtCaptionLbl: Label 'Payment Disc Given Amount';
        PmtDiscVATCaptionLbl: Label 'Payment Discount on VAT';
        ShpCaptionLbl: Label 'Shipment';
        LineDimsCaptionLbl: Label 'Line Dimensions';
        VATAmtLineVATCaptionLbl: Label 'VAT %';
        VATECBaseCaptionLbl: Label 'VAT+EC Base';
        VATAmountCaptionLbl: Label 'VAT Amount';
        VATAmtSpecCaptionLbl: Label 'VAT Amount Specification';
        VATIdentCaptionLbl: Label 'VAT Identifier';
        IRPFAmountCaptionLbl: Label 'IRPF';
        InvDiscBaseAmtCaptionLbl: Label 'Invoice Discount Base Amount';
        LineAmtCaption1Lbl: Label 'Line Amount';
        InvPmtDiscCaptionLbl: Label 'Invoice and Payment Discounts';
        ECAmtCaptionLbl: Label 'EC Amount';
        ECCaptionLbl: Label 'EC %';
        TotalCaptionLbl: Label 'Total';
        VALVATBaseLCYCaption1Lbl: Label 'VAT Base';
        VATAmtCaptionLbl: Label 'VAT Amount';
        VATIdentifierCaptionLbl: Label 'VAT Identifier';
        ShiptoAddressCaptionLbl: Label 'Ship-to Address';
        FixedRealEstateDescriptionCaptionLbl: Label 'Inmueble alquilado';
        PmtTermsDescCaptionLbl: Label 'Payment Terms';
        ShpMethodDescCaptionLbl: Label 'Shipment Method';
        PmtMethodDescCaptionLbl: Label 'Payment Method';
        DocDateCaptionLbl: Label 'Document Date';
        HomePageCaptionLbl: Label 'Home Page';
        EmailCaptionLbl: Label 'Email';
        CACCaptionLbl: Text;
        CACTxt: Label 'Régimen especial del criterio de caja';
        DisplayAdditionalFeeNote: Boolean;
        LineNoWithTotal: Integer;
        VATBaseRemainderAfterRoundingLCY: Decimal;
        AmtInclVATRemainderAfterRoundingLCY: Decimal;
        infoIVAEnable: Boolean;
        infoIVA: Boolean;
        flagText: Text[30];
        custPO: Text[30];
        currencyText: Text[30];
        item: Record "Item";
        itemFormat: Text[30];
        captionPack: Label 'Packaging';
        dockText: Text[30];
        dockShip: Text[50];
        tariffNoCaption: Label 'Harmonized CODE';
        tariffNoValue: Code[20];
        itemCrossReferenceCaption: Label 'New Code';
        orderQtyValue: Decimal;
        codeCaption: Label 'Code';
        hcCaption: Label 'HC';
        shipNameCaption: Text[30];
        shipNameValue: Text[50];
        countryShipNameCaption: Text[30];
        countryShipNameValue: Text[50];
        orderQtyCaption: Label 'Order qty.';
        skippedQtyCaption: Label 'Shipped Qty.';
        deliveryPortCaption: Label 'Delivery port';
        nLoteAduanaCaption: Text[30];
        nLoteAduanaValue: Text[20];
        nPartidaCaption: Text[30];
        nPartidaValue: Text[20];
        totalBultosCaption: Label 'Total of packages';
        totalPesoNeto: Label 'Total net weight';
        totalPesoBruto: Label 'Total gross weight';
        uomCaption: Label 'UOM';
        qtyShippedCaption: Label 'Qty.';
        itemDescription: Text[50];
        "No. Bulto": Text[50];
        OwnerName: Text[50];
        ContactOwnerCode: Code[20];
        "OwnerCIF/NIF": Text[50];
        FixedRealEstateDescription: Text[50];
        OwnerText: Label 'Propietario';
        ContractNoCaptionLbl: Label 'Contrato';
        InvoiceTitleCaptionLbl: Label 'FACTURA DE ALQUILER';
        CustomerBlockCaptionLbl: Label 'Datos del inquilino';
        PropertyBlockCaptionLbl: Label 'Datos del inmueble';
        PaymentBlockCaptionLbl: Label 'Condiciones de pago';
        TotalsBlockCaptionLbl: Label 'Resumen económico';
        OwnerNameCaptionLbl: Label 'Propietario';
        OwnerVatCaptionLbl: Label 'CIF/NIF';
        PropertySummaryText: Text[250];
        PaymentSummaryText: Text[250];
        FooterNoteText: Text[250];


    local procedure BuildPropertySummary(LeaseInvoiceHeader: Record "Lease Invoice Header"): Text[250]
    var
        ResultText: Text[250];
    begin
        ResultText := FixedRealEstateDescription;
        if LeaseInvoiceHeader."Contract No." <> '' then
            ResultText += ' | ' + ContractNoCaptionLbl + ': ' + LeaseInvoiceHeader."Contract No.";
        if OwnerName <> '' then
            ResultText += ' | ' + OwnerNameCaptionLbl + ': ' + OwnerName;
        exit(ResultText);
    end;

    local procedure BuildPaymentSummary(LeaseInvoiceHeader: Record "Lease Invoice Header"): Text[250]
    var
        ResultText: Text[250];
    begin
        ResultText := '';
        if PaymentTerms.Description <> '' then
            ResultText := PmtTermsDescCaptionLbl + ': ' + PaymentTerms.Description;
        if PaymentMethod.Description <> '' then begin
            if ResultText <> '' then
                ResultText += ' | ';
            ResultText += PmtMethodDescCaptionLbl + ': ' + PaymentMethod.Description;
        end;
        if LeaseInvoiceHeader."Due Date" <> 0D then begin
            if ResultText <> '' then
                ResultText += ' | ';
            ResultText += DueDateCaptionLbl + ': ' + Format(LeaseInvoiceHeader."Due Date", 0, 4);
        end;
        exit(ResultText);
    end;

    local procedure BuildFooterNote(): Text[250]
    begin
        if (CompanyInfo."Bank Name" <> '') or (CompanyInfo."Bank Account No." <> '') then
            exit(StrSubstNo('Pago por transferencia: %1 %2', CompanyInfo."Bank Name", CompanyInfo."Bank Account No."));
        exit('Gracias por su confianza.');
    end;


    local procedure CorrectShipment(var SalesShipmentLine: Record "Sales Shipment Line")
    var
        SalesInvoiceLine: Record "Sales Invoice Line";
    begin
        SalesInvoiceLine.SETCURRENTKEY("Shipment No.", "Shipment Line No.");
        SalesInvoiceLine.SETRANGE("Shipment No.", SalesShipmentLine."Document No.");
        SalesInvoiceLine.SETRANGE("Shipment Line No.", SalesShipmentLine."Line No.");
        IF SalesInvoiceLine.FIND('-') THEN
            REPEAT
                SalesShipmentLine.Quantity := SalesShipmentLine.Quantity - SalesInvoiceLine.Quantity;
            UNTIL SalesInvoiceLine.NEXT = 0;
    end;

    local procedure DocumentCaption(): Text[250]
    begin
        EXIT(Text004);
    end;

    procedure ShowCashAccountingCriteria(SalesInvoiceHeader: Record "Sales Invoice Header"): Text
    var
        VATEntry: Record "Value Entry";
    begin
        GLSetup.GET;
        IF NOT GLSetup."Unrealized VAT" THEN
            EXIT;
        CACCaptionLbl := '';
        VATEntry.SETRANGE("Document No.", SalesInvoiceHeader."No.");
        VATEntry.SETRANGE("Document Type", VATEntry."Document Type"::"Sales Invoice");
        IF VATEntry.FINDSET THEN
            REPEAT
            // IF VATEntry."VAT Cash Regime" THEN
            //    CACCaptionLbl := CACTxt;
            UNTIL (VATEntry.NEXT = 0) OR (CACCaptionLbl <> '');
        EXIT(CACCaptionLbl);
    end;

    procedure InitializeRequest(NewNoOfCopies: Integer; NewShowInternalInfo: Boolean; NewLogInteraction: Boolean; DisplayAsmInfo: Boolean; InfoIVAFrom: Boolean)
    begin
        NoOfCopies := NewNoOfCopies;
        ShowInternalInfo := NewShowInternalInfo;
        LogInteraction := NewLogInteraction;
        DisplayAssemblyInformation := DisplayAsmInfo;
        infoIVAEnable := InfoIVAFrom;
    end;

    local procedure FormatDocumentFields(LeaseInvoiceHeader: Record "Lease Invoice Header")
    begin
        FormatDocument.SetTotalLabels(LeaseInvoiceHeader."Currency Code", TotalText, TotalInclVATText, TotalExclVATText);
        FormatDocument.SetSalesPerson(SalesPurchPerson, LeaseInvoiceHeader."Salesperson Code", SalesPersonText);
        FormatDocument.SetPaymentTerms(PaymentTerms, LeaseInvoiceHeader."Payment Terms Code", LeaseInvoiceHeader."Language Code");
        IF LeaseInvoiceHeader."Payment Method Code" = '' THEN
            PaymentMethod.INIT
        ELSE
            PaymentMethod.GET(LeaseInvoiceHeader."Payment Method Code");

        ReferenceText := FormatDocument.SetText(LeaseInvoiceHeader."Your Reference" <> '', LeaseInvoiceHeader.FIELDCAPTION("Your Reference"));
        VATNoText := FormatDocument.SetText(LeaseInvoiceHeader."VAT Registration No." <> '', LeaseInvoiceHeader.FIELDCAPTION("VAT Registration No."));
    end;

    local procedure FormatAddressFields(LeaseInvoiceHeader: Record "Lease Invoice Header")
    var
        ContactOwner: Record Contact;

    begin
        // FormatAddr.GetCompanyAddr(LeaseInvoiceHeader."Responsibility Center", RespCenter, CompanyInfo, CompanyAddr);
        if not ContactOwner.GET(ContactOwnerCode) then
            ContactOwner.init;
        FormatAddr.FormatAddr(CompanyAddr, ContactOwner.Name, ContactOwner."Name 2", '',
            ContactOwner.Address, ContactOwner."Address 2", ContactOwner.City, ContactOwner."Post Code",
            ContactOwner.County, ContactOwner."Country/Region Code");
        FormatAddr.FormatAddr(CustAddr, LeaseInvoiceHeader.Name, LeaseInvoiceHeader."Name 2", LeaseInvoiceHeader."Contact Name",
            LeaseInvoiceHeader.Address, LeaseInvoiceHeader."Address 2", LeaseInvoiceHeader.City, LeaseInvoiceHeader."Post Code",
            LeaseInvoiceHeader.County, LeaseInvoiceHeader."Country/Region Code");
    end;

    local procedure GetUOMText(UOMCode: Code[10]): Text[10]
    var
        UnitOfMeasure: Record "Unit of Measure";
    begin
        IF NOT UnitOfMeasure.GET(UOMCode) THEN
            EXIT(UOMCode);
        EXIT(UnitOfMeasure.Description);
    end;

    procedure BlanksForIndent(): Text[10]
    begin
        EXIT(PADSTR('', 2, ' '));
    end;

#pragma warning disable AL0432
    local procedure CalcVATAmountLineLCY(LeaseInvoiceHeader: Record "Lease Invoice Header"; TempVATAmountLine2: Record "VAT Amount Line" temporary; var TempVATAmountLineLCY2: Record "VAT Amount Line" temporary; var VATBaseRemainderAfterRoundingLCY2: Decimal; var AmtInclVATRemainderAfterRoundingLCY2: Decimal)
#pragma warning restore AL0432
    var
        VATBaseLCY: Decimal;
        AmtInclVATLCY: Decimal;
    begin
        IF (NOT GLSetup."Print VAT specification in LCY") OR
           (LeaseInvoiceHeader."Currency Code" = '')
        THEN
            EXIT;

        TempVATAmountLineLCY2.INIT;
        TempVATAmountLineLCY2 := TempVATAmountLine2;
        VATBaseLCY :=
            CurrExchRate.ExchangeAmtFCYToLCY(
            LeaseInvoiceHeader."Posting Date", LeaseInvoiceHeader."Currency Code", TempVATAmountLine2."VAT Base", LeaseInvoiceHeader."Currency Factor") +
            VATBaseRemainderAfterRoundingLCY2;
        AmtInclVATLCY :=
            CurrExchRate.ExchangeAmtFCYToLCY(
            LeaseInvoiceHeader."Posting Date", LeaseInvoiceHeader."Currency Code", TempVATAmountLine2."Amount Including VAT", LeaseInvoiceHeader."Currency Factor") +
            AmtInclVATRemainderAfterRoundingLCY2;
        TempVATAmountLineLCY2."VAT Base" := ROUND(VATBaseLCY);
        TempVATAmountLineLCY2."Amount Including VAT" := ROUND(AmtInclVATLCY);
        TempVATAmountLineLCY2.InsertLine;

        VATBaseRemainderAfterRoundingLCY2 := VATBaseLCY - TempVATAmountLineLCY2."VAT Base";
        AmtInclVATRemainderAfterRoundingLCY2 := AmtInclVATLCY - TempVATAmountLineLCY2."Amount Including VAT";
    end;

    local procedure CalcTotalIRPFLCY(LeaseInvoiceHeader: Record "Lease Invoice Header")
    var
        TaxAmountLine: Record "Tax Amount Line";
    begin
        TotalAmountIRPF := 0;
        TaxAmountLine.Reset();
        TaxAmountLine.SetRange("Document Type", TaxAmountLine."Document Type"::"Lease Invoice");
        TaxAmountLine.SetRange("Document No.", LeaseInvoiceHeader."No.");
        TaxAmountLine.SetRange("Tax Group Code", 'IRPF');
        IF TaxAmountLine.FindFirst() THEN
            REPEAT
                TotalAmountIRPF += TaxAmountLine."Tax Amount";
            UNTIL TaxAmountLine.Next() = 0;
        TotalAmountIRPF := - TotalAmountIRPF;
        TotalAmountInclVAT := TotalAmountInclVAT + TotalAmountIRPF;
    end;

}
