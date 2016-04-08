USE [StageDM]
GO

SET QUOTED_IDENTIFIER OFF
GO
SET ANSI_NULLS ON
GO

IF EXISTS (
            SELECT 1
            FROM sys.procedures with (nolock)
            WHERE NAME = 'wrkCustomer'
                AND type = 'P'
           )
    DROP PROCEDURE [dbo].[wrkCustomer]
GO

CREATE PROCEDURE [dbo].[wrkCustomer] 

	
AS 

/*******************************************************************************************************
*   StageDM.dbo.wrkCustomer
*
*   Creator:	Michelle Morales    
*   Date:		03/21/2016          
*   
*          
*   Notes:  set statistics io on

*
*   Usage:	

			execute StageDM.dbo.wrkCustomer

			select top 100 *
			from StageDM.dbo.Customer
			
			
			select column_name + ','
			from stageDM.information_schema.columns
			where table_name = 'Customer'

*   Modifications:   
*   Developer Name      Date        Brief description
*   ------------------- ----------- ------------------------------------------------------------
*   
********************************************************************************************************/
---------------------------------------------
-- declare variables
---------------------------------------------
declare @ErrorDatetime datetime,
	@ErrorNumber int,
	@ErrorSeverity int,
	@ErrorState int,
	@ErrorProcedure varchar(100),
	@ErrorLine int,
	@ErrorMessage varchar(254),
	@UserName varchar(100),
	@developerMessage varchar(254)

---------------------------------------------
-- create temp tables
---------------------------------------------

---------------------------------------------
-- set session variables
---------------------------------------------
SET NOCOUNT ON
set xact_abort on    --only uncomment if you're using a transaction, otherwise delete this line.

---------------------------------------------
-- body of stored procedure
---------------------------------------------
begin tran

	truncate table StageDM.dbo.Customer
	
	if @@error <> 0
	begin

		select @ErrorDatetime = getdate(),
			@ErrorNumber = ERROR_NUMBER(),
			@ErrorSeverity = ERROR_SEVERITY(),
			@ErrorState = ERROR_STATE(),
			@ErrorProcedure = ERROR_PROCEDURE(),
			@ErrorLine = ERROR_LINE(),
			@ErrorMessage = ERROR_MESSAGE(),
			@UserName = suser_sname(),
			@developerMessage = 'Error truncating StageDM.dbo.Customer'
		
		execute StageDM.dbo.ErrorInfoPopulate @ErrorDatetime, @ErrorNumber, @ErrorSeverity, @ErrorState, @ErrorProcedure, @ErrorLine, @ErrorMessage, @UserName, @developerMessage
		
		rollback tran
		
	end
	
	insert StageDM.dbo.Customer
	(
		AccrRevAcct,
		AccrRevSub,
		AcctNbr,
		Addr1,
		Addr2,
		AgentID,
		ApplFinChrg,
		ArAcct,
		ArSub,
		Attn,
		AutoApply,
		BankID,
		BillAddr1,
		BillAddr2,
		BillAttn,
		BillCity,
		BillCountry,
		BillFax,
		BillName,
		BillPhone,
		BillSalut,
		BillState,
		BillThruProject,
		BillZip,
		CardExpDate,
		CardHldrName,
		CardNbr,
		CardType,
		City,
		ClassId,
		ConsolInv,
		Country,
		CrLmt,
		Crtd_DateTime,
		Crtd_Prog,
		Crtd_User,
		CuryId,
		CuryPrcLvlRtTp,
		CuryRateType,
		CustFillPriority,
		CustId,
		DfltShipToId,
		DocPublishingFlag,
		DunMsg,
		EMailAddr,
		Fax,
		InvtSubst,
		LanguageID,
		LUpd_DateTime,
		LUpd_Prog,
		LUpd_User,
		Name,
		NoteId,
		OneDraft,
		PerNbr,
		Phone,
		PmtMethod,
		PrcLvlId,
		PrePayAcct,
		PrePaySub,
		PriceClassID,
		PrtMCStmt,
		PrtStmt,
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
		SetupDate,
		ShipCmplt,
		ShipPctAct,
		ShipPctMax,
		SICCode1,
		SICCode2,
		SingleInvoice,
		SlsAcct,
		SlsperId,
		SlsSub,
		[State],
		[Status],
		StmtCycleId,
		StmtType,
		TaxDflt,
		TaxExemptNbr,
		TaxID00,
		TaxID01,
		TaxID02,
		TaxID03,
		TaxLocId,
		TaxRegNbr,
		Terms,
		Territory,
		TradeDisc,
		User1,
		User2,
		User3,
		User4,
		User5,
		User6,
		User7,
		User8,
		Zip,
		Company
	)
	select AccrRevAcct,
		AccrRevSub,
		AcctNbr,
		Addr1,
		Addr2,
		AgentID,
		ApplFinChrg,
		ArAcct,
		ArSub,
		Attn,
		AutoApply,
		BankID,
		BillAddr1,
		BillAddr2,
		BillAttn,
		BillCity,
		BillCountry,
		BillFax,
		BillName,
		BillPhone,
		BillSalut,
		BillState,
		BillThruProject,
		BillZip,
		CardExpDate,
		CardHldrName,
		CardNbr,
		CardType,
		City,
		ClassId,
		ConsolInv,
		Country,
		CrLmt,
		Crtd_DateTime,
		Crtd_Prog,
		Crtd_User,
		CuryId,
		CuryPrcLvlRtTp,
		CuryRateType,
		CustFillPriority,
		CustId,
		DfltShipToId,
		DocPublishingFlag,
		DunMsg,
		EMailAddr,
		Fax,
		InvtSubst,
		LanguageID,
		LUpd_DateTime,
		LUpd_Prog,
		LUpd_User,
		Name,
		NoteId,
		OneDraft,
		PerNbr,
		Phone,
		PmtMethod,
		PrcLvlId,
		PrePayAcct,
		PrePaySub,
		PriceClassID,
		PrtMCStmt,
		PrtStmt,
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
		SetupDate,
		ShipCmplt,
		ShipPctAct,
		ShipPctMax,
		SICCode1,
		SICCode2,
		SingleInvoice,
		SlsAcct,
		SlsperId,
		SlsSub,
		[State],
		[Status],
		StmtCycleId,
		StmtType,
		TaxDflt,
		TaxExemptNbr,
		TaxID00,
		TaxID01,
		TaxID02,
		TaxID03,
		TaxLocId,
		TaxRegNbr,
		Terms,
		Territory,
		TradeDisc,
		User1,
		User2,
		User3,
		User4,
		User5,
		User6,
		User7,
		User8,
		Zip,
		Company = 'DENVER'
	from SQL1.denverapp.dbo.Customer with (nolock)

	if @@error <> 0
	begin

		select @ErrorDatetime = getdate(),
			@ErrorNumber = ERROR_NUMBER(),
			@ErrorSeverity = ERROR_SEVERITY(),
			@ErrorState = ERROR_STATE(),
			@ErrorProcedure = ERROR_PROCEDURE(),
			@ErrorLine = ERROR_LINE(),
			@ErrorMessage = ERROR_MESSAGE(),
			@UserName = suser_sname(),
			@developerMessage = 'Error inserting into StageDM.dbo.Customer (Denver)'
		
		execute StageDM.dbo.ErrorInfoPopulate @ErrorDatetime, @ErrorNumber, @ErrorSeverity, @ErrorState, @ErrorProcedure, @ErrorLine, @ErrorMessage, @UserName, @developerMessage
		
		rollback tran
	
	end

	insert StageDM.dbo.Customer
	(
		AccrRevAcct,
		AccrRevSub,
		AcctNbr,
		Addr1,
		Addr2,
		AgentID,
		ApplFinChrg,
		ArAcct,
		ArSub,
		Attn,
		AutoApply,
		BankID,
		BillAddr1,
		BillAddr2,
		BillAttn,
		BillCity,
		BillCountry,
		BillFax,
		BillName,
		BillPhone,
		BillSalut,
		BillState,
		BillThruProject,
		BillZip,
		CardExpDate,
		CardHldrName,
		CardNbr,
		CardType,
		City,
		ClassId,
		ConsolInv,
		Country,
		CrLmt,
		Crtd_DateTime,
		Crtd_Prog,
		Crtd_User,
		CuryId,
		CuryPrcLvlRtTp,
		CuryRateType,
		CustFillPriority,
		CustId,
		DfltShipToId,
		DocPublishingFlag,
		DunMsg,
		EMailAddr,
		Fax,
		InvtSubst,
		LanguageID,
		LUpd_DateTime,
		LUpd_Prog,
		LUpd_User,
		Name,
		NoteId,
		OneDraft,
		PerNbr,
		Phone,
		PmtMethod,
		PrcLvlId,
		PrePayAcct,
		PrePaySub,
		PriceClassID,
		PrtMCStmt,
		PrtStmt,
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
		SetupDate,
		ShipCmplt,
		ShipPctAct,
		ShipPctMax,
		SICCode1,
		SICCode2,
		SingleInvoice,
		SlsAcct,
		SlsperId,
		SlsSub,
		[State],
		[Status],
		StmtCycleId,
		StmtType,
		TaxDflt,
		TaxExemptNbr,
		TaxID00,
		TaxID01,
		TaxID02,
		TaxID03,
		TaxLocId,
		TaxRegNbr,
		Terms,
		Territory,
		TradeDisc,
		User1,
		User2,
		User3,
		User4,
		User5,
		User6,
		User7,
		User8,
		Zip,
		Company
	)
	select sa.AccrRevAcct,
		sa.AccrRevSub,
		sa.AcctNbr,
		sa.Addr1,
		sa.Addr2,
		sa.AgentID,
		sa.ApplFinChrg,
		sa.ArAcct,
		sa.ArSub,
		sa.Attn,
		sa.AutoApply,
		sa.BankID,
		sa.BillAddr1,
		sa.BillAddr2,
		sa.BillAttn,
		sa.BillCity,
		sa.BillCountry,
		sa.BillFax,
		sa.BillName,
		sa.BillPhone,
		sa.BillSalut,
		sa.BillState,
		sa.BillThruProject,
		sa.BillZip,
		sa.CardExpDate,
		sa.CardHldrName,
		sa.CardNbr,
		sa.CardType,
		sa.City,
		sa.ClassId,
		sa.ConsolInv,
		sa.Country,
		sa.CrLmt,
		sa.Crtd_DateTime,
		sa.Crtd_Prog,
		sa.Crtd_User,
		sa.CuryId,
		sa.CuryPrcLvlRtTp,
		sa.CuryRateType,
		sa.CustFillPriority,
		sa.CustId,
		sa.DfltShipToId,
		sa.DocPublishingFlag,
		sa.DunMsg,
		sa.EMailAddr,
		sa.Fax,
		sa.InvtSubst,
		sa.LanguageID,
		sa.LUpd_DateTime,
		sa.LUpd_Prog,
		sa.LUpd_User,
		sa.Name,
		sa.NoteId,
		sa.OneDraft,
		sa.PerNbr,
		sa.Phone,
		sa.PmtMethod,
		sa.PrcLvlId,
		sa.PrePayAcct,
		sa.PrePaySub,
		sa.PriceClassID,
		sa.PrtMCStmt,
		sa.PrtStmt,
		sa.S4Future01,
		sa.S4Future02,
		sa.S4Future03,
		sa.S4Future04,
		sa.S4Future05,
		sa.S4Future06,
		sa.S4Future07,
		sa.S4Future08,
		sa.S4Future09,
		sa.S4Future10,
		sa.S4Future11,
		sa.S4Future12,
		sa.Salut,
		sa.SetupDate,
		sa.ShipCmplt,
		sa.ShipPctAct,
		sa.ShipPctMax,
		sa.SICCode1,
		sa.SICCode2,
		sa.SingleInvoice,
		sa.SlsAcct,
		sa.SlsperId,
		sa.SlsSub,
		sa.[State],
		sa.[Status],
		sa.StmtCycleId,
		sa.StmtType,
		sa.TaxDflt,
		sa.TaxExemptNbr,
		sa.TaxID00,
		sa.TaxID01,
		sa.TaxID02,
		sa.TaxID03,
		sa.TaxLocId,
		sa.TaxRegNbr,
		sa.Terms,
		sa.Territory,
		sa.TradeDisc,
		sa.User1,
		sa.User2,
		sa.User3,
		sa.User4,
		sa.User5,
		sa.User6,
		sa.User7,
		sa.User8,
		sa.Zip,
		Company = 'SHOPPERNY'
	from SQL1.shopperapp.dbo.Customer sa with (nolock)
--	left join StageDM.dbo.Customer sdm 
--		on sa.CustId = sdm.CustId
--	where sdm.CustId is null
	

	if @@error <> 0
	begin

		select @ErrorDatetime = getdate(),
			@ErrorNumber = ERROR_NUMBER(),
			@ErrorSeverity = ERROR_SEVERITY(),
			@ErrorState = ERROR_STATE(),
			@ErrorProcedure = ERROR_PROCEDURE(),
			@ErrorLine = ERROR_LINE(),
			@ErrorMessage = ERROR_MESSAGE(),
			@UserName = suser_sname(),
			@developerMessage = 'Error inserting into StageDM.dbo.Customer (Shopper NY)'
		
		execute StageDM.dbo.ErrorInfoPopulate @ErrorDatetime, @ErrorNumber, @ErrorSeverity, @ErrorState, @ErrorProcedure, @ErrorLine, @ErrorMessage, @UserName, @developerMessage
		
		rollback tran
	
	end

commit tran

---------------------------------------------
-- permissions
---------------------------------------------
grant execute on wrkCustomer to BFGROUP
go
