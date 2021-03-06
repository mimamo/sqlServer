USE [DAL_TEST_APP]
GO
/****** Object:  View [dbo].[xmvad03]    Script Date: 12/21/2015 13:56:39 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
------------------------------------------------------------------------------------------------------------------------
-- MAG 8/3/11                                                                                              --
-- Created view from SQL originally written by David Martin to extract vendor updates                      --
--                                                                                                         --
------------------------------------------------------------------------------------------------------------------------

CREATE view [dbo].[xmvad03]
as
SELECT		Vendor_ID           = VendID,
            Vendor_Name         = RTRIM(Name),
			Event               =
              Case AProcess
		        When 'I' Then 'New'
				When 'D' Then 'Delete'
              End,
			Change_Date         = ADate,
			Change_Time         = SUBSTRING(CONVERT(VARCHAR,ADate, 120), 12,5),
            DSL_User            = ASolomonUserID,
            Salutation          = Salut,
            Attention           = Attn,
            Address_1           = Addr1,
            Address_2           = Addr2,
            City                = City,
            State               = State,
            Country             = Country,
            Zip                 = Zip,
            Phone               = Phone,
            Fax                 = Fax,
            Remit_Name          = RemitName,
            Remit_Salutation    = RemitSalut,
            Remit_Attention     = RemitAttn,
            Remit_Address_1     = RemitAddr1,
            Remit_Address_2     = RemitAddr2,
            Remit_City          = RemitCity,
            Remit_State         = RemitState,
            Remit_Country       = RemitCountry,
            Remit_Zip           = RemitZip,
            Remit_Phone         = RemitPhone,
            Remit_Fax           = RemitFax,
            AP_Account          = APAcct,
            AP_Subaccount       = APSub,
            Vendor_Class        = ClassID,
            TIN_Value           = TIN,
            Vend_1099           =
              Case
                When Vend1099 > 0 then 'Yes'
                Else 'No'
              End,
            Terms               = Terms,
            Note                =
              Case
                When NoteID > 0 then 'Yes'
                Else 'No'
              End,
            Default_Exp_Acct    = ExpAcct,
            Default_Exp_SubAcct = ExpSub,
            Tax_Registration_No = TaxRegNbr,
            Tax_Post            = TaxPost,
            Tax_Location_ID     = TaxLocId,
            Tax_ID_0            = TaxId00,
            Tax_ID_1            = TaxId01,
            Tax_ID_2            = TaxId02,
            Tax_ID_3            = TaxId03,
            Tax_Default         = TaxDflt,
            Status              = Status,
            Payment_Method      = PmtMethod,
            Pre_Pay_Account     = PPayAcct,
            Pre_Pay_SubAccount  = PPaySub,
            Pay_Date_Default    = PayDateDflt,
            Backup_Withheld_ID  = BkupWthld,
            Cont_Twc_1099       = ContTwc1099,
            Current_1099_Year   = Curr1099Yr,
            Currency_ID         = CuryId,
            Currency_Rate       = CuryRateType,
            Default_Box         = DfltBox,
            Default_Order_Form  = DfltOrdFromId,
            Default_Purch_Type  = DfltPurchaseType,
            Direct_Deposit      = DirectDeposit,
            EMail               = EMailAddr,
            LC_Code             = LCCode,
            Multiple_Check      =
              Case
                When MultiChk > 0 then 'Yes'
                Else 'No'
              End,
            Next_1099_Year      = Next1099Yr,
            Period_Nmber        = PerNbr,
            Rcpt_Percent_Acct   = RcptPctAct,
            Rcpt_Percent_Max    = RcptPctMax,
            Rcpt_Percent_Min    = RcptPctMin,
            Future_Field_1      = S4Future01,
            Future_Field_2      = S4Future02,
            Future_Field_3      = S4Future03,
            Future_Field_4      = S4Future04,
            Future_Field_5      = S4Future05,
            Future_Field_6      = S4Future06,
            Future_Field_7      = S4Future07,
            Future_Field_8      = S4Future08,
            Future_Field_9      = S4Future09,
            Future_Field_10     = S4Future10,
            Future_Field_11     = S4Future11,
            Future_Field_12     = S4Future12,
            User_Field_1        = User1,
            User_Field_2        = User2,
            User_Field_3        = User3,
            User_Field_4        = User4,
            User_Field_5        = User5,
            User_Field_6        = User6,
            User_Field_7        = User7,
            User_Field_8        = User8


FROM        xAVendor A
WHERE		AProcess <> 'U'
GO
