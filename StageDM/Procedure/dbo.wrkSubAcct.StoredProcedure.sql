USE [StageDM]
GO

SET QUOTED_IDENTIFIER OFF
GO
SET ANSI_NULLS ON
GO

IF EXISTS (
            SELECT 1
            FROM sys.procedures with (nolock)
            WHERE NAME = 'wrkSubAcct'
                AND type = 'P'
           )
    DROP PROCEDURE [dbo].[wrkSubAcct]
GO

CREATE PROCEDURE [dbo].[wrkSubAcct] 

	
AS 

/*******************************************************************************************************
*   StageDM.dbo.wrkSubAcct
*
*   Creator:	Michelle Morales    
*   Date:		03/21/2016          
*   
*          
*   Notes:  set statistics io on

*
*   Usage:	

			execute StageDM.dbo.wrkSubAcct

			select top 100 *
			from StageDM.dbo.SubAcct
			
			
			select column_name + ','
			from stageDM.information_schema.columns
			where table_name = 'SubAcct'

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

	truncate table StageDM.dbo.SubAcct
	
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
			@developerMessage = 'Error truncating StageDM.dbo.SubAcct'
		
		execute StageDM.dbo.ErrorInfoPopulate @ErrorDatetime, @ErrorNumber, @ErrorSeverity, @ErrorState, @ErrorProcedure, @ErrorLine, @ErrorMessage, @UserName, @developerMessage
		
		rollback tran
		
	end
	
	insert StageDM.dbo.SubAcct
	(
		Active,
		ConsolSub,
		Crtd_DateTime,
		Crtd_Prog,
		Crtd_User,
		Descr,
		LUpd_DateTime,
		LUpd_Prog,
		LUpd_User,
		NoteID,
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
		Sub,
		User1,
		User2,
		User3,
		User4,
		User5,
		User6,
		User7,
		User8,
		Company
	)
	select Active,
		ConsolSub,
		Crtd_DateTime,
		Crtd_Prog,
		Crtd_User,
		Descr,
		LUpd_DateTime,
		LUpd_Prog,
		LUpd_User,
		NoteID,
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
		Sub,
		User1,
		User2,
		User3,
		User4,
		User5,
		User6,
		User7,
		User8,
		Company = 'DENVER'
	from SQL1.denverapp.dbo.SubAcct with (nolock)

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
			@developerMessage = 'Error inserting into StageDM.dbo.SubAcct (Denver)'
		
		execute StageDM.dbo.ErrorInfoPopulate @ErrorDatetime, @ErrorNumber, @ErrorSeverity, @ErrorState, @ErrorProcedure, @ErrorLine, @ErrorMessage, @UserName, @developerMessage
		
		rollback tran
	
	end

	insert StageDM.dbo.SubAcct
	(
		Active,
		ConsolSub,
		Crtd_DateTime,
		Crtd_Prog,
		Crtd_User,
		Descr,
		LUpd_DateTime,
		LUpd_Prog,
		LUpd_User,
		NoteID,
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
		Sub,
		User1,
		User2,
		User3,
		User4,
		User5,
		User6,
		User7,
		User8,
		Company
	)
	select sa.Active,
		sa.ConsolSub,
		sa.Crtd_DateTime,
		sa.Crtd_Prog,
		sa.Crtd_User,
		sa.Descr,
		sa.LUpd_DateTime,
		sa.LUpd_Prog,
		sa.LUpd_User,
		sa.NoteID,
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
		sa.Sub,
		sa.User1,
		sa.User2,
		sa.User3,
		sa.User4,
		sa.User5,
		sa.User6,
		sa.User7,
		sa.User8,
		Company = 'SHOPPERNY'
	from SQL1.shopperapp.dbo.SubAcct sa with (nolock)
--	left join stageDm.dbo.SubAcct sdm
--		on sa.Sub = sdm.Sub
--	where sdm.Sub is null

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
			@developerMessage = 'Error inserting into StageDM.dbo.SubAcct (Shopper NY)'
		
		execute StageDM.dbo.ErrorInfoPopulate @ErrorDatetime, @ErrorNumber, @ErrorSeverity, @ErrorState, @ErrorProcedure, @ErrorLine, @ErrorMessage, @UserName, @developerMessage
		
		rollback tran
	
	end

commit tran

---------------------------------------------
-- permissions
---------------------------------------------
grant execute on wrkSubAcct to BFGROUP
go
