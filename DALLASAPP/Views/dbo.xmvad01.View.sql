USE [DALLASAPP]
GO
/****** Object:  View [dbo].[xmvad01]    Script Date: 12/21/2015 13:44:22 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
------------------------------------------------------------------------------------------------------------------------
-- MAG 8/3/11                                                                                              --
-- Created view from SQL originally written by David Martin to extract vendor updates                      --
--                                                                                                         --
------------------------------------------------------------------------------------------------------------------------

CREATE view [dbo].[xmvad01]
as

SELECT		RTRIM(LTRIM(AAA.Vendor)) AS 'Vendor_ID',
            RTRIM(BBB.Name) as Vendor_Name,
			BBB.ADate AS 'Change_Date',
			SUBSTRING(CONVERT(VARCHAR,BBB.ADate, 120), 12,5) AS 'Change_Time',
			RTRIM(LTRIM(BBB.ASolomonUserID)) AS 'DSL_User',
				COALESCE(CASE WHEN BBB.Name <> CCC.Name THEN 'Vendor Name: ' + RTRIM(LTRIM(CCC.Name)) + ' ' END,'') +
				COALESCE(CASE WHEN BBB.Salut<> CCC.Salut THEN 'Salutation: ' + RTRIM(LTRIM(CCC.Salut)) + ' ' END,'') +
				COALESCE(CASE WHEN BBB.Attn <> CCC.Attn THEN 'Attention: ' + RTRIM(LTRIM(CCC.Attn)) + ' ' END,'') +
				COALESCE(CASE WHEN BBB.Addr1 <> CCC.Addr1 THEN 'Address 1: ' + RTRIM(LTRIM(CCC.Addr1)) + ' ' END,'') + 
				COALESCE(CASE WHEN BBB.Addr2 <> CCC.Addr2 THEN 'Address 2: ' + RTRIM(LTRIM(CCC.Addr2)) + ' ' END,'') + 
				COALESCE(CASE WHEN BBB.City <> CCC.City THEN 'City: ' + RTRIM(LTRIM(CCC.City)) + ' ' END,'') + 
				COALESCE(CASE WHEN BBB.State <> CCC.State THEN 'State: ' + RTRIM(LTRIM(CCC.State)) + ' ' END,'') + 
				COALESCE(CASE WHEN BBB.Country<> CCC.Country THEN 'Country: ' + RTRIM(LTRIM(CCC.Country)) + ' ' END,'') + 
				COALESCE(CASE WHEN BBB.Zip <> CCC.Zip THEN 'Zip: ' + RTRIM(LTRIM(CCC.Zip)) + ' ' END,'') + 
				COALESCE(CASE WHEN BBB.Phone <> CCC.Phone THEN 'Phone: ' + RTRIM(LTRIM(CCC.Phone)) + ' ' END,'') + 
				COALESCE(CASE WHEN BBB.Fax <> CCC.Fax THEN 'Fax: ' + RTRIM(LTRIM(CCC.Fax)) + ' ' END,'') +
				COALESCE(CASE WHEN BBB.RemitName <> CCC.RemitName THEN 'Remit Name: ' + RTRIM(LTRIM(CCC.RemitName)) + ' ' END,'') +
				COALESCE(CASE WHEN BBB.RemitSalut<> CCC.RemitSalut THEN 'Remit Salutation: ' + RTRIM(LTRIM(CCC.RemitSalut)) + ' ' END,'') +
				COALESCE(CASE WHEN BBB.RemitAttn <> CCC.RemitAttn THEN 'Remit Attention: ' + RTRIM(LTRIM(CCC.RemitAttn)) + ' ' END,'') + 
				COALESCE(CASE WHEN BBB.RemitAddr1 <> CCC.RemitAddr1 THEN 'Remit Address 1: ' + RTRIM(LTRIM(CCC.RemitAddr1)) + ' ' END,'') +
				COALESCE(CASE WHEN BBB.RemitAddr2 <> CCC.RemitAddr2 THEN 'Remit Address 2: ' + RTRIM(LTRIM(CCC.RemitAddr2)) + ' ' END,'') + 
				COALESCE(CASE WHEN BBB.RemitCity <> CCC.RemitCity THEN 'Remit City: ' + RTRIM(LTRIM(CCC.RemitCity)) + ' ' END,'') + 
				COALESCE(CASE WHEN BBB.RemitState <> CCC.RemitState THEN 'Remit State: ' + RTRIM(LTRIM(CCC.RemitState)) + ' ' END,'') + 
				COALESCE(CASE WHEN BBB.RemitCountry<> CCC.RemitCountry THEN 'Remit Country: ' + RTRIM(LTRIM(CCC.RemitCountry)) + ' ' END,'') + 
				COALESCE(CASE WHEN BBB.RemitZip <> CCC.RemitZip THEN 'Remit Zip: ' + RTRIM(LTRIM(CCC.RemitZip)) + ' ' END,'') + 
				COALESCE(CASE WHEN BBB.RemitPhone <> CCC.RemitPhone THEN 'Remit Phone: ' + RTRIM(LTRIM(CCC.RemitPhone)) + ' ' END,'') + 
				COALESCE(CASE WHEN BBB.RemitFax <> CCC.RemitFax THEN 'Remit Fax: ' + RTRIM(LTRIM(CCC.RemitFax)) + ' ' END,'') +
				COALESCE(CASE WHEN BBB.APAcct <> CCC.APAcct THEN 'AP Account: ' + RTRIM(LTRIM(CCC.APAcct)) + ' ' END,'') +
				COALESCE(CASE WHEN BBB.APSub<> CCC.APSub THEN 'AP Sub Account: ' + RTRIM(LTRIM(CCC.APSub)) + ' ' END,'') +
				COALESCE(CASE WHEN BBB.ClassID <> CCC.ClassID THEN 'Vendor Class: ' + RTRIM(LTRIM(CCC.ClassID)) + ' ' END,'') +
				COALESCE(CASE WHEN BBB.TIN <> CCC.TIN THEN 'TIN: ' + RTRIM(LTRIM(CCC.TIN)) + ' ' END,'') +
				COALESCE(CASE WHEN BBB.Vend1099 <> CCC.Vend1099
					THEN
						CASE
							WHEN CCC.Vend1099 > 0
								THEN '1099: Yes'
								ELSE '1099: No'
						END
					+ ' ' END,'') +
				COALESCE(CASE WHEN BBB.Terms <> CCC.Terms THEN 'Terms: ' + RTRIM(LTRIM(CCC.Terms)) + ' ' END,'') +
				COALESCE(CASE WHEN BBB.NoteID <> CCC.NoteID
					THEN
						CASE
							WHEN CCC.NoteID > 0
								THEN 'Note: Yes'
								ELSE 'Note: No'
						END
					+ ' ' END,'') +
				COALESCE(CASE WHEN BBB.ExpAcct <> CCC.ExpAcct THEN 'Default Expense Account: ' + RTRIM(LTRIM(CCC.ExpAcct)) + ' ' END,'') +
				COALESCE(CASE WHEN BBB.ExpSub <> CCC.ExpSub THEN 'Default Expense Sub Account: ' + RTRIM(LTRIM(CCC.ExpSub)) + ' ' END,'') +
				COALESCE(CASE WHEN BBB.TaxRegNbr <> CCC.TaxRegNbr THEN 'Tax Registration Number: ' + RTRIM(LTRIM(CCC.TaxRegNbr)) + ' ' END,'') +
				COALESCE(CASE WHEN BBB.TaxPost <> CCC.TaxPost THEN 'Tax Post: ' + RTRIM(LTRIM(CCC.TaxPost)) + ' ' END,'') +
				COALESCE(CASE WHEN BBB.TaxLocId <> CCC.TaxLocId THEN 'Tax Location ID: ' + RTRIM(LTRIM(CCC.TaxLocId)) + ' ' END,'') +
				COALESCE(CASE WHEN BBB.TaxId00 <> CCC.TaxId00 THEN 'Tax ID 0: ' + RTRIM(LTRIM(CCC.TaxId00)) + ' ' END,'') +				
				COALESCE(CASE WHEN BBB.TaxId01 <> CCC.TaxId01 THEN 'Tax ID 1: ' + RTRIM(LTRIM(CCC.TaxId01)) + ' ' END,'') +
				COALESCE(CASE WHEN BBB.TaxId02 <> CCC.TaxId02 THEN 'Tax ID 2: ' + RTRIM(LTRIM(CCC.TaxId02)) + ' ' END,'') +
				COALESCE(CASE WHEN BBB.TaxId03<> CCC.TaxId03 THEN 'Tax ID 3: ' + RTRIM(LTRIM(CCC.TaxId03)) + ' ' END,'') +
				COALESCE(CASE WHEN BBB.TaxDflt<> CCC.TaxDflt THEN 'Default Tax Form: ' + RTRIM(LTRIM(CCC.TaxDflt)) + ' ' END,'') +
				COALESCE(CASE WHEN BBB.Status<> CCC.Status THEN 'Vendor Status: ' + RTRIM(LTRIM(CCC.Status)) + ' ' END,'') +
				COALESCE(CASE WHEN BBB.PmtMethod<> CCC.PmtMethod THEN 'Payment Method: ' + RTRIM(LTRIM(CCC.PmtMethod)) + ' ' END,'') +
				COALESCE(CASE WHEN BBB.PPayAcct<> CCC.PPayAcct THEN 'Pre-Pay Account: ' + RTRIM(LTRIM(CCC.PPayAcct)) + ' ' END,'') +
				COALESCE(CASE WHEN BBB.PPaySub<> CCC.PPaysub THEN 'Pre-Pay Sub Account: ' + RTRIM(LTRIM(CCC.PPaySub)) + ' ' END,'') +
				COALESCE(CASE WHEN BBB.PayDateDflt<> CCC.PayDateDflt THEN 'Pay Date Default: ' + RTRIM(LTRIM(CCC.PayDateDflt)) + ' ' END,'') + 
				COALESCE(CASE WHEN BBB.BkupWthld <> CCC.BkupWthld THEN 'Backup Withheld ID: ' + RTRIM(LTRIM(CCC.BkupWthld)) + ' ' END,'') +
				COALESCE(CASE WHEN BBB.ContTwc1099 <> CCC.ContTwc1099 THEN 'Cont Twc 1009: ' + RTRIM(LTRIM(CCC.ContTwc1099)) + ' ' END,'') +
				COALESCE(CASE WHEN BBB.Curr1099Yr <> CCC.Curr1099Yr THEN 'Current 1099 Year: ' + RTRIM(LTRIM(CCC.Curr1099Yr)) + ' ' END,'') +
				COALESCE(CASE WHEN BBB.CuryId <> CCC.CuryId THEN 'Currency ID: ' + RTRIM(LTRIM(CCC.CuryId)) + ' ' END,'') +
				COALESCE(CASE WHEN BBB.CuryRateType <> CCC.CuryRateType THEN 'Currency Rate: ' + RTRIM(LTRIM(CCC.CuryRateType)) + ' ' END,'') +
				COALESCE(CASE WHEN BBB.DfltBox <> CCC.DfltBox THEN 'Default Box: ' + RTRIM(LTRIM(CCC.DfltBox)) + ' ' END,'') +
				COALESCE(CASE WHEN BBB.DfltOrdFromId <> CCC.DfltOrdFromId THEN 'Default Order Form: ' + RTRIM(LTRIM(CCC.DfltOrdFromId)) + ' ' END,'') +
				COALESCE(CASE WHEN BBB.DfltPurchaseType <> CCC.DfltPurchaseType THEN 'Default Purchase Type: ' + RTRIM(LTRIM(CCC.DfltPurchaseType)) + ' ' END,'') +
				COALESCE(CASE WHEN BBB.DirectDeposit <> CCC.DirectDeposit THEN 'Direct Deposit: ' + RTRIM(LTRIM(CCC.DirectDeposit)) + ' ' END,'') +
				COALESCE(CASE WHEN BBB.EMailAddr <> CCC.EMailAddr THEN 'Email: ' + RTRIM(LTRIM(CCC.EMailAddr)) + ' ' END,'') +
				COALESCE(CASE WHEN BBB.LCCode <> CCC.LCCode THEN 'LC Code: ' + RTRIM(LTRIM(CCC.LCCode)) + ' ' END,'') +
				COALESCE(CASE WHEN BBB.MultiChk <> CCC.MultiChk
				THEN
						CASE
							WHEN CCC.MultiChk > 0
								THEN 'Multiple Check: Yes'
								ELSE 'Multiple Check: No'
						END				
				+ ' ' END,'') +
				COALESCE(CASE WHEN BBB.Next1099Yr <> CCC.Next1099Yr THEN 'Next 1099 Year: ' + RTRIM(LTRIM(CCC.Next1099Yr)) + ' ' END,'') +
				COALESCE(CASE WHEN BBB.PerNbr <> CCC.PerNbr THEN 'Period Number: ' + RTRIM(LTRIM(CCC.PerNbr)) + ' ' END,'') +
				COALESCE(CASE WHEN BBB.RcptPctAct <> CCC.RcptPctAct THEN 'Rcpt Percent Account: ' + RTRIM(LTRIM(CCC.RcptPctAct)) + ' ' END,'') +
				COALESCE(CASE WHEN BBB.RcptPctMax <> CCC.RcptPctMax THEN 'Rcpt Percent Max: ' + RTRIM(LTRIM(CCC.RcptPctMax)) + ' ' END,'') +
				COALESCE(CASE WHEN BBB.RcptPctMin <> CCC.RcptPctMin THEN 'Rcpt Percent Min: ' + RTRIM(LTRIM(CCC.RcptPctMin)) + ' ' END,'') +
				COALESCE(CASE WHEN BBB.S4Future01 <> CCC.S4Future01 THEN 'Future Field 1: ' + RTRIM(LTRIM(CCC.S4Future01)) + ' ' END,'') +
				COALESCE(CASE WHEN BBB.S4Future02 <> CCC.S4Future02 THEN 'Future Field 2: ' + RTRIM(LTRIM(CCC.S4Future02)) + ' ' END,'') +
				COALESCE(CASE WHEN BBB.S4Future03 <> CCC.S4Future03 THEN 'Future Field 3: ' + RTRIM(LTRIM(CCC.S4Future03)) + ' ' END,'') +
				COALESCE(CASE WHEN BBB.S4Future04 <> CCC.S4Future04 THEN 'Future Field 4: ' + RTRIM(LTRIM(CCC.S4Future04)) + ' ' END,'') +
				COALESCE(CASE WHEN BBB.S4Future05 <> CCC.S4Future05 THEN 'Future Field 5: ' + RTRIM(LTRIM(CCC.S4Future05)) + ' ' END,'') +
				COALESCE(CASE WHEN BBB.S4Future06 <> CCC.S4Future06 THEN 'Future Field 6: ' + RTRIM(LTRIM(CCC.S4Future06)) + ' ' END,'') +
				COALESCE(CASE WHEN BBB.S4Future07 <> CCC.S4Future07 THEN 'Future Field 7: ' + RTRIM(LTRIM(CCC.S4Future07)) + ' ' END,'') +
				COALESCE(CASE WHEN BBB.S4Future08 <> CCC.S4Future08 THEN 'Future Field 8: ' + RTRIM(LTRIM(CCC.S4Future08)) + ' ' END,'') +
				COALESCE(CASE WHEN BBB.S4Future09 <> CCC.S4Future09 THEN 'Future Field 9: ' + RTRIM(LTRIM(CCC.S4Future09)) + ' ' END,'') +
				COALESCE(CASE WHEN BBB.S4Future10 <> CCC.S4Future10 THEN 'Future Field 10: ' + RTRIM(LTRIM(CCC.S4Future10)) + ' ' END,'') +
				COALESCE(CASE WHEN BBB.S4Future11 <> CCC.S4Future11 THEN 'Future Field 11: ' + RTRIM(LTRIM(CCC.S4Future11)) + ' ' END,'') +
				COALESCE(CASE WHEN BBB.S4Future12 <> CCC.S4Future12 THEN 'Future Field 12: ' + RTRIM(LTRIM(CCC.S4Future12)) + ' ' END,'') +
				COALESCE(CASE WHEN BBB.User1 <> CCC.User1 THEN 'User Field 1: ' + RTRIM(LTRIM(CCC.User1)) + ' ' END,'') +
				COALESCE(CASE WHEN BBB.User2 <> CCC.User2 THEN 'User Field 2: ' + RTRIM(LTRIM(CCC.User2)) + ' ' END,'') +
				COALESCE(CASE WHEN BBB.User3 <> CCC.User3 THEN 'User Field 3: ' + RTRIM(LTRIM(CCC.User3)) + ' ' END,'') +
				COALESCE(CASE WHEN BBB.User4 <> CCC.User4 THEN 'User Field 4: ' + RTRIM(LTRIM(CCC.User4)) + ' ' END,'') +
				COALESCE(CASE WHEN BBB.User5 <> CCC.User5 THEN 'User Field 5: ' + RTRIM(LTRIM(CCC.User5)) + ' ' END,'') +
				COALESCE(CASE WHEN BBB.User6 <> CCC.User6 THEN 'User Field 6: ' + RTRIM(LTRIM(CCC.User6)) + ' ' END,'') +
				COALESCE(CASE WHEN BBB.User7 <> CCC.User7 THEN 'User Field 7: ' + RTRIM(LTRIM(CCC.User7)) + ' ' END,'') +
				COALESCE(CASE WHEN BBB.User8 <> CCC.User8 THEN 'User Field 8: ' + RTRIM(LTRIM(CCC.User8)) + ' ' END,'')
			AS 'Old Data',
				COALESCE(CASE WHEN BBB.Name <> CCC.Name THEN 'Vendor Name: ' + RTRIM(LTRIM(BBB.Name)) + ' ' END,'') +
				COALESCE(CASE WHEN BBB.Salut<> CCC.Salut THEN 'Salutation: ' + RTRIM(LTRIM(BBB.Salut)) + ' ' END,'') +
				COALESCE(CASE WHEN BBB.Attn <> CCC.Attn THEN 'Attention: ' + RTRIM(LTRIM(BBB.Attn)) + ' ' END,'') +
				COALESCE(CASE WHEN BBB.Addr1 <> CCC.Addr1 THEN 'Address 1: ' + RTRIM(LTRIM(BBB.Addr1)) + ' ' END,'') + 
				COALESCE(CASE WHEN BBB.Addr2 <> CCC.Addr2 THEN 'Address 2: ' + RTRIM(LTRIM(BBB.Addr2)) + ' ' END,'') + 
				COALESCE(CASE WHEN BBB.City <> CCC.City THEN 'City: ' + RTRIM(LTRIM(BBB.City)) + ' ' END,'') + 
				COALESCE(CASE WHEN BBB.State <> CCC.State THEN 'State: ' + RTRIM(LTRIM(BBB.State)) + ' ' END,'') + 
				COALESCE(CASE WHEN BBB.Country<> CCC.Country THEN 'Country: ' + RTRIM(LTRIM(BBB.Country)) + ' ' END,'') + 
				COALESCE(CASE WHEN BBB.Zip <> CCC.Zip THEN 'Zip: ' + RTRIM(LTRIM(BBB.Zip)) + ' ' END,'') + 
				COALESCE(CASE WHEN BBB.Phone <> CCC.Phone THEN 'Phone: ' + RTRIM(LTRIM(BBB.Phone)) + ' ' END,'') + 
				COALESCE(CASE WHEN BBB.Fax <> CCC.Fax THEN 'Fax: ' + RTRIM(LTRIM(BBB.Fax)) + ' ' END,'') +
				COALESCE(CASE WHEN BBB.RemitName <> CCC.RemitName THEN 'Remit Name: ' + RTRIM(LTRIM(BBB.RemitName)) + ' ' END,'') +
				COALESCE(CASE WHEN BBB.RemitSalut<> CCC.RemitSalut THEN 'Remit Salutation: ' + RTRIM(LTRIM(BBB.RemitSalut)) + ' ' END,'') +
				COALESCE(CASE WHEN BBB.RemitAttn <> CCC.RemitAttn THEN 'Remit Attention: ' + RTRIM(LTRIM(BBB.RemitAttn)) + ' ' END,'') + 
				COALESCE(CASE WHEN BBB.RemitAddr1 <> CCC.RemitAddr1 THEN 'Remit Address 1: ' + RTRIM(LTRIM(BBB.RemitAddr1)) + ' ' END,'') +
				COALESCE(CASE WHEN BBB.RemitAddr2 <> CCC.RemitAddr2 THEN 'Remit Address 2: ' + RTRIM(LTRIM(BBB.RemitAddr2)) + ' ' END,'') + 
				COALESCE(CASE WHEN BBB.RemitCity <> CCC.RemitCity THEN 'Remit City: ' + RTRIM(LTRIM(BBB.RemitCity)) + ' ' END,'') + 
				COALESCE(CASE WHEN BBB.RemitState <> CCC.RemitState THEN 'Remit State: ' + RTRIM(LTRIM(BBB.RemitState)) + ' ' END,'') + 
				COALESCE(CASE WHEN BBB.RemitCountry<> CCC.RemitCountry THEN 'Remit Country: ' + RTRIM(LTRIM(BBB.RemitCountry)) + ' ' END,'') + 
				COALESCE(CASE WHEN BBB.RemitZip <> CCC.RemitZip THEN 'Remit Zip: ' + RTRIM(LTRIM(BBB.RemitZip)) + ' ' END,'') + 
				COALESCE(CASE WHEN BBB.RemitPhone <> CCC.RemitPhone THEN 'Remit Phone: ' + RTRIM(LTRIM(BBB.RemitPhone)) + ' ' END,'') + 
				COALESCE(CASE WHEN BBB.RemitFax <> CCC.RemitFax THEN 'Remit Fax: ' + RTRIM(LTRIM(BBB.RemitFax)) + ' ' END,'') +
				COALESCE(CASE WHEN BBB.APAcct <> CCC.APAcct THEN 'AP Account: ' + RTRIM(LTRIM(BBB.APAcct)) + ' ' END,'') +
				COALESCE(CASE WHEN BBB.APSub<> CCC.APSub THEN 'AP Sub Account: ' + RTRIM(LTRIM(BBB.APSub)) + ' ' END,'') +
				COALESCE(CASE WHEN BBB.ClassID <> CCC.ClassID THEN 'Vendor Class: ' + RTRIM(LTRIM(BBB.ClassID)) + ' ' END,'') +
				COALESCE(CASE WHEN BBB.TIN <> CCC.TIN THEN 'TIN: ' + RTRIM(LTRIM(BBB.TIN)) + ' ' END,'') +
				COALESCE(CASE WHEN BBB.Vend1099 <> CCC.Vend1099
					THEN
						CASE
							WHEN BBB.Vend1099 > 0
								THEN '1099: Yes'
								ELSE '1099: No'
						END
					+ ' ' END,'') +
				COALESCE(CASE WHEN BBB.Terms <> CCC.Terms THEN 'Terms: ' + RTRIM(LTRIM(BBB.Terms)) + ' ' END,'') +
				COALESCE(CASE WHEN BBB.NoteID <> CCC.NoteID
					THEN
						CASE
							WHEN BBB.NoteID > 0
								THEN 'Note: Yes'
								ELSE 'Note: No'
						END
					+ ' ' END,'') +
				COALESCE(CASE WHEN BBB.ExpAcct <> CCC.ExpAcct THEN 'Default Expense Account: ' + RTRIM(LTRIM(BBB.ExpAcct)) + ' ' END,'') +
				COALESCE(CASE WHEN BBB.ExpSub <> CCC.ExpSub THEN 'Default Expense Sub Account: ' + RTRIM(LTRIM(BBB.ExpSub)) + ' ' END,'') +
				COALESCE(CASE WHEN BBB.TaxRegNbr <> CCC.TaxRegNbr THEN 'Tax Registration Number: ' + RTRIM(LTRIM(BBB.TaxRegNbr)) + ' ' END,'') +
				COALESCE(CASE WHEN BBB.TaxPost <> CCC.TaxPost THEN 'Tax Post: ' + RTRIM(LTRIM(BBB.TaxPost)) + ' ' END,'') +
				COALESCE(CASE WHEN BBB.TaxLocId <> CCC.TaxLocId THEN 'Tax Location ID: ' + RTRIM(LTRIM(BBB.TaxLocId)) + ' ' END,'') +
				COALESCE(CASE WHEN BBB.TaxId00 <> CCC.TaxId00 THEN 'Tax ID 0: ' + RTRIM(LTRIM(BBB.TaxId00)) + ' ' END,'') +				
				COALESCE(CASE WHEN BBB.TaxId01 <> CCC.TaxId01 THEN 'Tax ID 1: ' + RTRIM(LTRIM(BBB.TaxId01)) + ' ' END,'') +
				COALESCE(CASE WHEN BBB.TaxId02 <> CCC.TaxId02 THEN 'Tax ID 2: ' + RTRIM(LTRIM(BBB.TaxId02)) + ' ' END,'') +
				COALESCE(CASE WHEN BBB.TaxId03<> CCC.TaxId03 THEN 'Tax ID 3: ' + RTRIM(LTRIM(BBB.TaxId03)) + ' ' END,'') +
				COALESCE(CASE WHEN BBB.TaxDflt<> CCC.TaxDflt THEN 'Default Tax Form: ' + RTRIM(LTRIM(BBB.TaxDflt)) + ' ' END,'') +
				COALESCE(CASE WHEN BBB.Status<> CCC.Status THEN 'Vendor Status: ' + RTRIM(LTRIM(BBB.Status)) + ' ' END,'') +
				COALESCE(CASE WHEN BBB.PmtMethod<> CCC.PmtMethod THEN 'Payment Method: ' + RTRIM(LTRIM(BBB.PmtMethod)) + ' ' END,'') +
				COALESCE(CASE WHEN BBB.PPayAcct<> CCC.PPayAcct THEN 'Pre-Pay Account: ' + RTRIM(LTRIM(BBB.PPayAcct)) + ' ' END,'') +
				COALESCE(CASE WHEN BBB.PPaySub<> CCC.PPaysub THEN 'Pre-Pay Sub Account: ' + RTRIM(LTRIM(BBB.PPaySub)) + ' ' END,'') +
				COALESCE(CASE WHEN BBB.PayDateDflt<> CCC.PayDateDflt THEN 'Pay Date Default: ' + RTRIM(LTRIM(BBB.PayDateDflt)) + ' ' END,'') + 
				COALESCE(CASE WHEN BBB.BkupWthld <> CCC.BkupWthld THEN 'Backup Withheld ID: ' + RTRIM(LTRIM(BBB.BkupWthld)) + ' ' END,'') +
				COALESCE(CASE WHEN BBB.ContTwc1099 <> CCC.ContTwc1099 THEN 'Cont Twc 1009: ' + RTRIM(LTRIM(BBB.ContTwc1099)) + ' ' END,'') +
				COALESCE(CASE WHEN BBB.Curr1099Yr <> CCC.Curr1099Yr THEN 'Current 1099 Year: ' + RTRIM(LTRIM(BBB.Curr1099Yr)) + ' ' END,'') +
				COALESCE(CASE WHEN BBB.CuryId <> CCC.CuryId THEN 'Currency ID: ' + RTRIM(LTRIM(BBB.CuryId)) + ' ' END,'') +
				COALESCE(CASE WHEN BBB.CuryRateType <> CCC.CuryRateType THEN 'Currency Rate: ' + RTRIM(LTRIM(BBB.CuryRateType)) + ' ' END,'') +
				COALESCE(CASE WHEN BBB.DfltBox <> CCC.DfltBox THEN 'Default Box: ' + RTRIM(LTRIM(BBB.DfltBox)) + ' ' END,'') +
				COALESCE(CASE WHEN BBB.DfltOrdFromId <> CCC.DfltOrdFromId THEN 'Default Order Form: ' + RTRIM(LTRIM(BBB.DfltOrdFromId)) + ' ' END,'') +
				COALESCE(CASE WHEN BBB.DfltPurchaseType <> CCC.DfltPurchaseType THEN 'Default Purchase Type: ' + RTRIM(LTRIM(BBB.DfltPurchaseType)) + ' ' END,'') +
				COALESCE(CASE WHEN BBB.DirectDeposit <> CCC.DirectDeposit THEN 'Direct Deposit: ' + RTRIM(LTRIM(BBB.DirectDeposit)) + ' ' END,'') +
				COALESCE(CASE WHEN BBB.EMailAddr <> CCC.EMailAddr THEN 'Email: ' + RTRIM(LTRIM(BBB.EMailAddr)) + ' ' END,'') +
				COALESCE(CASE WHEN BBB.LCCode <> CCC.LCCode THEN 'LC Code: ' + RTRIM(LTRIM(BBB.LCCode)) + ' ' END,'') +
				COALESCE(CASE WHEN BBB.MultiChk <> CCC.MultiChk
				THEN
						CASE
							WHEN BBB.MultiChk > 0
								THEN 'Multiple Check: Yes'
								ELSE 'Multiple Check: No'
						END				
				+ ' ' END,'') +
				COALESCE(CASE WHEN BBB.Next1099Yr <> CCC.Next1099Yr THEN 'Next 1099 Year: ' + RTRIM(LTRIM(BBB.Next1099Yr)) + ' ' END,'') +
				COALESCE(CASE WHEN BBB.PerNbr <> CCC.PerNbr THEN 'Period Number: ' + RTRIM(LTRIM(BBB.PerNbr)) + ' ' END,'') +
				COALESCE(CASE WHEN BBB.RcptPctAct <> CCC.RcptPctAct THEN 'Rcpt Percent Account: ' + RTRIM(LTRIM(BBB.RcptPctAct)) + ' ' END,'') +
				COALESCE(CASE WHEN BBB.RcptPctMax <> CCC.RcptPctMax THEN 'Rcpt Percent Max: ' + RTRIM(LTRIM(BBB.RcptPctMax)) + ' ' END,'') +
				COALESCE(CASE WHEN BBB.RcptPctMin <> CCC.RcptPctMin THEN 'Rcpt Percent Min: ' + RTRIM(LTRIM(BBB.RcptPctMin)) + ' ' END,'') +
				COALESCE(CASE WHEN BBB.S4Future01 <> CCC.S4Future01 THEN 'Future Field 1: ' + RTRIM(LTRIM(BBB.S4Future01)) + ' ' END,'') +
				COALESCE(CASE WHEN BBB.S4Future02 <> CCC.S4Future02 THEN 'Future Field 2: ' + RTRIM(LTRIM(BBB.S4Future02)) + ' ' END,'') +
				COALESCE(CASE WHEN BBB.S4Future03 <> CCC.S4Future03 THEN 'Future Field 3: ' + RTRIM(LTRIM(BBB.S4Future03)) + ' ' END,'') +
				COALESCE(CASE WHEN BBB.S4Future04 <> CCC.S4Future04 THEN 'Future Field 4: ' + RTRIM(LTRIM(BBB.S4Future04)) + ' ' END,'') +
				COALESCE(CASE WHEN BBB.S4Future05 <> CCC.S4Future05 THEN 'Future Field 5: ' + RTRIM(LTRIM(BBB.S4Future05)) + ' ' END,'') +
				COALESCE(CASE WHEN BBB.S4Future06 <> CCC.S4Future06 THEN 'Future Field 6: ' + RTRIM(LTRIM(BBB.S4Future06)) + ' ' END,'') +
				COALESCE(CASE WHEN BBB.S4Future07 <> CCC.S4Future07 THEN 'Future Field 7: ' + RTRIM(LTRIM(BBB.S4Future07)) + ' ' END,'') +
				COALESCE(CASE WHEN BBB.S4Future08 <> CCC.S4Future08 THEN 'Future Field 8: ' + RTRIM(LTRIM(BBB.S4Future08)) + ' ' END,'') +
				COALESCE(CASE WHEN BBB.S4Future09 <> CCC.S4Future09 THEN 'Future Field 9: ' + RTRIM(LTRIM(BBB.S4Future09)) + ' ' END,'') +
				COALESCE(CASE WHEN BBB.S4Future10 <> CCC.S4Future10 THEN 'Future Field 10: ' + RTRIM(LTRIM(BBB.S4Future10)) + ' ' END,'') +
				COALESCE(CASE WHEN BBB.S4Future11 <> CCC.S4Future11 THEN 'Future Field 11: ' + RTRIM(LTRIM(BBB.S4Future11)) + ' ' END,'') +
				COALESCE(CASE WHEN BBB.S4Future12 <> CCC.S4Future12 THEN 'Future Field 12: ' + RTRIM(LTRIM(BBB.S4Future12)) + ' ' END,'') +
				COALESCE(CASE WHEN BBB.User1 <> CCC.User1 THEN 'User Field 1: ' + RTRIM(LTRIM(BBB.User1)) + ' ' END,'') +
				COALESCE(CASE WHEN BBB.User2 <> CCC.User2 THEN 'User Field 2: ' + RTRIM(LTRIM(BBB.User2)) + ' ' END,'') +
				COALESCE(CASE WHEN BBB.User3 <> CCC.User3 THEN 'User Field 3: ' + RTRIM(LTRIM(BBB.User3)) + ' ' END,'') +
				COALESCE(CASE WHEN BBB.User4 <> CCC.User4 THEN 'User Field 4: ' + RTRIM(LTRIM(BBB.User4)) + ' ' END,'') +
				COALESCE(CASE WHEN BBB.User5 <> CCC.User5 THEN 'User Field 5: ' + RTRIM(LTRIM(BBB.User5)) + ' ' END,'') +
				COALESCE(CASE WHEN BBB.User6 <> CCC.User6 THEN 'User Field 6: ' + RTRIM(LTRIM(BBB.User6)) + ' ' END,'') +
				COALESCE(CASE WHEN BBB.User7 <> CCC.User7 THEN 'User Field 7: ' + RTRIM(LTRIM(BBB.User7)) + ' ' END,'') +
				COALESCE(CASE WHEN BBB.User8 <> CCC.User8 THEN 'User Field 8: ' + RTRIM(LTRIM(BBB.User8)) + ' ' END,'')				
			AS 'New Data'
FROM		(SELECT	X.Vendor AS 'Vendor', /*Second Inner Query to Filter Extra Old Data Records*/
					X.A AS 'AID',
					MAX(X.B) AS 'BID'
			FROM	(SELECT A.AID AS 'A', /*First Inner Query to Get Changed Vendor Records*/
							B.AID AS 'B',
							A.VendId AS 'Vendor'
					FROM	xAVendor A,
							xAVendor B
					WHERE	A.AProcess = 'U' /*Updates Only*/
							AND A.AApplication <> 'Solomon IV0156000' /*This application produces too many result because of period changes*/
							AND A.VendID = B.VendID
							AND B.AID < A.AID) X
			GROUP BY	X.Vendor,
						X.A) AAA,
			xAVendor BBB,
			xAVendor CCC
WHERE		AAA.AID = BBB.AID
			AND AAA.BID = CCC.AID
GO
