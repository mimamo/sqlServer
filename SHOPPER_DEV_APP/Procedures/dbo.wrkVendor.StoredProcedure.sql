USE [shopper_dev_app]
GO

SET QUOTED_IDENTIFIER OFF
GO
SET ANSI_NULLS ON
GO

IF EXISTS (
            SELECT 1
            FROM sys.procedures with (nolock)
            WHERE NAME = 'wrkVendor'
                AND type = 'P'
           )
    DROP PROCEDURE [dbo].[wrkVendor]
GO

CREATE PROCEDURE [dbo].[wrkVendor] 

	
AS 

/*******************************************************************************************************
*   shopper_dev_app.dbo.wrkVendor
*
*   Creator: Michelle Morales    
*   Date: 03/08/2016          
*   
*          
*   Notes: 

*
*
*   Usage:	set statistics io on

	execute shopper_dev_app.dbo.wrkVendor 


*   Modifications:   
*   Developer Name      Date        Brief description
*   ------------------- ----------- ------------------------------------------------------------
*   
********************************************************************************************************/
---------------------------------------------
-- declare variables
---------------------------------------------

---------------------------------------------
-- create temp tables
---------------------------------------------

if object_id('tempdb.dbo.##HoursDataStage') > 0 drop table ##HoursDataStage

---------------------------------------------
-- set session variables
---------------------------------------------
SET NOCOUNT ON
--set xact_abort on    --only uncomment if you're usiSng a transaction, otherwise delete this line.

---------------------------------------------
-- body of stored procedure
---------------------------------------------
update s
	set Addr1 = d.Addr1,
		Addr2 = d.Addr2,
		APAcct = d.APAcct,
		APSub = d.APSub,
		Attn = d.Attn,
		BkupWthld = d.BkupWthld,
		City = d.City,
		ClassID = d.ClassID,
		ContTwc1099 = d.ContTwc1099,
		Country = d.Country,
		Crtd_DateTime = d.Crtd_DateTime,
		Crtd_Prog = d.Crtd_Prog,
		Crtd_User = d.Crtd_User,
		Curr1099Yr = d.Curr1099Yr,
		CuryId = d.CuryId,
		CuryRateType = d.CuryRateType,
		DfltBox = d.DfltBox,
		DfltOrdFromId = d.DfltOrdFromId,
		DfltPurchaseType = d.DfltPurchaseType,
		DirectDeposit = d.DirectDeposit,
		DocPublishingFlag = d.DocPublishingFlag,
		EMailAddr = d.EMailAddr,
		ExpAcct = d.ExpAcct,
		ExpSub = d.ExpSub,
		Fax = d.Fax,
		LCCode = d.LCCode,
		LUpd_DateTime = d.LUpd_DateTime,
		LUpd_Prog = d.LUpd_Prog,
		LUpd_User = d.LUpd_User,
		MultiChk = d.MultiChk,
		Name = d.Name,
		Next1099Yr = d.Next1099Yr,
		NoteID = d.NoteID,
		PayDateDflt = d.PayDateDflt,
		PerNbr = d.PerNbr,
		Phone = d.Phone,
		PmtMethod = d.PmtMethod,
		PPayAcct = d.PPayAcct,
		PPaySub = d.PPaySub,
		RcptPctAct = d.RcptPctAct,
		RcptPctMax = d.RcptPctMax,
		RcptPctMin = d.RcptPctMin,
		RemitAddr1 = d.RemitAddr1,
		RemitAddr2 = d.RemitAddr2,
		RemitAttn = d.RemitAttn,
		RemitCity = d.RemitCity,
		RemitCountry = d.RemitCountry,
		RemitFax = d.RemitFax,
		RemitName = d.RemitName,
		RemitPhone = d.RemitPhone,
		RemitSalut = d.RemitSalut,
		RemitState = d.RemitState,
		RemitZip = d.RemitZip,
		S4Future01 = d.S4Future01,
		S4Future02 = d.S4Future02,
		S4Future03 = d.S4Future03,
		S4Future04 = d.S4Future04,
		S4Future05 = d.S4Future05,
		S4Future06 = d.S4Future06,
		S4Future07 = d.S4Future07,
		S4Future08 = d.S4Future08,
		S4Future09 = d.S4Future09,
		S4Future10 = d.S4Future10,
		S4Future11 = d.S4Future11,
		S4Future12 = d.S4Future12,
		Salut = d.Salut,
		[State] = d.[State],
		[Status] = d.[Status],
		TaxDflt = d.TaxDflt,
		TaxId00 = d.TaxId00,
		TaxId01 = d.TaxId01,
		TaxId02 = d.TaxId02,
		TaxId03 = d.TaxId03,
		TaxLocId = d.TaxLocId,
		TaxPost = d.TaxPost,
		TaxRegNbr = d.TaxRegNbr,
		Terms = d.Terms,
		TIN = d.TIN,
		User1 = d.User1,
		User2 = d.User2,
		User3 = d.User3,
		User4 = d.User4,
		User5 = d.User5,
		User6 = d.User6,
		User7 = d.User7,
		User8 = d.User8,
		Vend1099 = d.Vend1099,
		Vend1099AddrType = d.Vend1099AddrType,
		Zip = d.Zip
from shopper_dev_app.dbo.Vendor s 
inner join den_dev_app.dbo.Vendor d
	on s.vendId = d.vendId

insert shopper_dev_app.dbo.Vendor
(
	Addr1,
	Addr2,
	APAcct,
	APSub,
	Attn,
	BkupWthld,
	City,
	ClassID,
	ContTwc1099,
	Country,
	Crtd_DateTime,
	Crtd_Prog,
	Crtd_User,
	Curr1099Yr,
	CuryId,
	CuryRateType,
	DfltBox,
	DfltOrdFromId,
	DfltPurchaseType,
	DirectDeposit,
	DocPublishingFlag,
	EMailAddr,
	ExpAcct,
	ExpSub,
	Fax,
	LCCode,
	LUpd_DateTime,
	LUpd_Prog,
	LUpd_User,
	MultiChk,
	Name,
	Next1099Yr,
	NoteID,
	PayDateDflt,
	PerNbr,
	Phone,
	PmtMethod,
	PPayAcct,
	PPaySub,
	RcptPctAct,
	RcptPctMax,
	RcptPctMin,
	RemitAddr1,
	RemitAddr2,
	RemitAttn,
	RemitCity,
	RemitCountry,
	RemitFax,
	RemitName,
	RemitPhone,
	RemitSalut,
	RemitState,
	RemitZip,
	S4Future01,
	S4Future02,
	S4Future03,
	S4Future04,
	S4Future05,
	S4Future06,
	S4Future07,
	S4Future08,
	S4Future09,
	S4Future10,
	S4Future11,
	S4Future12,
	Salut,
	[State],
	[Status],
	TaxDflt,
	TaxId00,
	TaxId01,
	TaxId02,
	TaxId03,
	TaxLocId,
	TaxPost,
	TaxRegNbr,
	Terms,
	TIN,
	User1,
	User2,
	User3,
	User4,
	User5,
	User6,
	User7,
	User8,
	Vend1099,
	Vend1099AddrType,
	VendId,
	Zip
)
select d.Addr1,
	d.Addr2,
	d.APAcct,
	d.APSub,
	d.Attn,
	d.BkupWthld,
	d.City,
	d.ClassID,
	d.ContTwc1099,
	d.Country,
	d.Crtd_DateTime,
	d.Crtd_Prog,
	d.Crtd_User,
	d.Curr1099Yr,
	d.CuryId,
	d.CuryRateType,
	d.DfltBox,
	d.DfltOrdFromId,
	d.DfltPurchaseType,
	d.DirectDeposit,
	d.DocPublishingFlag,
	d.EMailAddr,
	d.ExpAcct,
	d.ExpSub,
	d.Fax,
	d.LCCode,
	d.LUpd_DateTime,
	d.LUpd_Prog,
	d.LUpd_User,
	d.MultiChk,
	d.Name,
	d.Next1099Yr,
	d.NoteID,
	d.PayDateDflt,
	d.PerNbr,
	d.Phone,
	d.PmtMethod,
	d.PPayAcct,
	d.PPaySub,
	d.RcptPctAct,
	d.RcptPctMax,
	d.RcptPctMin,
	d.RemitAddr1,
	d.RemitAddr2,
	d.RemitAttn,
	d.RemitCity,
	d.RemitCountry,
	d.RemitFax,
	d.RemitName,
	d.RemitPhone,
	d.RemitSalut,
	d.RemitState,
	d.RemitZip,
	d.S4Future01,
	d.S4Future02,
	d.S4Future03,
	d.S4Future04,
	d.S4Future05,
	d.S4Future06,
	d.S4Future07,
	d.S4Future08,
	d.S4Future09,
	d.S4Future10,
	d.S4Future11,
	d.S4Future12,
	d.Salut,
	d.[State],
	d.[Status],
	d.TaxDflt,
	d.TaxId00,
	d.TaxId01,
	d.TaxId02,
	d.TaxId03,
	d.TaxLocId,
	d.TaxPost,
	d.TaxRegNbr,
	d.Terms,
	d.TIN,
	d.User1,
	d.User2,
	d.User3,
	d.User4,
	d.User5,
	d.User6,
	d.User7,
	d.User8,
	d.Vend1099,
	d.Vend1099AddrType,
	d.VendId,
	d.Zip
from den_dev_app.dbo.Vendor d
left join shopper_dev_app.dbo.Vendor s
	on d.vendId = s.vendId
where s.vendId is null

---------------------------------------------
-- permissions
---------------------------------------------
grant execute on wrkVendor to BFGROUP
go

grant execute on wrkVendor to MSDSL
go

grant control on wrkVendor to MSDSL
go

grant execute on wrkVendor to MSDynamicsSL
go