USE [StageDM]
GO

SET QUOTED_IDENTIFIER OFF
GO
SET ANSI_NULLS ON
GO

IF EXISTS (
            SELECT 1
            FROM sys.procedures with (nolock)
            WHERE NAME = 'wrkPJLABHDR'
                AND type = 'P'
           )
    DROP PROCEDURE [dbo].[wrkPJLABHDR]
GO

CREATE PROCEDURE [dbo].[wrkPJLABHDR] 

	
AS 

/*******************************************************************************************************
*   StageDM.dbo.wrkPJLABHDR
*
*   Creator:	Michelle Morales    
*   Date:		03/21/2016          
*   
*          
*   Notes:  set statistics io on
*
*   Usage:	

			execute StageDM.dbo.wrkPJLABHDR

			select top 100 *
			from StageDM.dbo.PJLABHDR
			
			
			select column_name + ','
			from stageDM.information_schema.columns
			where table_name = 'PJLABHDR'

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

	truncate table StageDM.dbo.PJLABHDR
	
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
			@developerMessage = 'Error truncating StageDM.dbo.PJLABHDR'
		
		execute StageDM.dbo.ErrorInfoPopulate @ErrorDatetime, @ErrorNumber, @ErrorSeverity, @ErrorState, @ErrorProcedure, @ErrorLine, @ErrorMessage, @UserName, @developerMessage
		
		rollback tran
		
	end
	
	insert StageDM.dbo.PJLABHDR
	(
		Approver,
		BaseCuryId,
		CpnyId_home,
		crtd_datetime,
		crtd_prog,
		crtd_user,
		CuryEffDate,
		CuryId,
		CuryMultDiv,
		CuryRate,
		CuryRateType,
		docnbr,
		employee,
		fiscalno,
		le_id01,
		le_id02,
		le_id03,
		le_id04,
		le_id05,
		le_id06,
		le_id07,
		le_id08,
		le_id09,
		le_id10,
		le_key,
		le_status,
		le_type,
		lupd_datetime,
		lupd_prog,
		lupd_user,
		noteid,
		period_num,
		pe_date,
		user1,
		user2,
		user3,
		user4,
		week_num,
		Company
	)
	select Approver,
		BaseCuryId,
		CpnyId_home,
		crtd_datetime,
		crtd_prog,
		crtd_user,
		CuryEffDate,
		CuryId,
		CuryMultDiv,
		CuryRate,
		CuryRateType,
		docnbr,
		employee,
		fiscalno,
		le_id01,
		le_id02,
		le_id03,
		le_id04,
		le_id05,
		le_id06,
		le_id07,
		le_id08,
		le_id09,
		le_id10,
		le_key,
		le_status,
		le_type,
		lupd_datetime,
		lupd_prog,
		lupd_user,
		noteid,
		period_num,
		pe_date,
		user1,
		user2,
		user3,
		user4,
		week_num,
		Company = 'DENVER'
	from SQL1.denverapp.dbo.PJLABHDR with (nolock)

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
			@developerMessage = 'Error inserting into StageDM.dbo.PJLABHDR (Denver)'
		
		execute StageDM.dbo.ErrorInfoPopulate @ErrorDatetime, @ErrorNumber, @ErrorSeverity, @ErrorState, @ErrorProcedure, @ErrorLine, @ErrorMessage, @UserName, @developerMessage
		
		rollback tran
	
	end

	insert StageDM.dbo.PJLABHDR
	(
		Approver,
		BaseCuryId,
		CpnyId_home,
		crtd_datetime,
		crtd_prog,
		crtd_user,
		CuryEffDate,
		CuryId,
		CuryMultDiv,
		CuryRate,
		CuryRateType,
		docnbr,
		employee,
		fiscalno,
		le_id01,
		le_id02,
		le_id03,
		le_id04,
		le_id05,
		le_id06,
		le_id07,
		le_id08,
		le_id09,
		le_id10,
		le_key,
		le_status,
		le_type,
		lupd_datetime,
		lupd_prog,
		lupd_user,
		noteid,
		period_num,
		pe_date,
		user1,
		user2,
		user3,
		user4,
		week_num,
		Company
	)
	select sa.Approver,
		sa.BaseCuryId,
		sa.CpnyId_home,
		sa.crtd_datetime,
		sa.crtd_prog,
		sa.crtd_user,
		sa.CuryEffDate,
		sa.CuryId,
		sa.CuryMultDiv,
		sa.CuryRate,
		sa.CuryRateType,
		sa.docnbr,
		sa.employee,
		sa.fiscalno,
		sa.le_id01,
		sa.le_id02,
		sa.le_id03,
		sa.le_id04,
		sa.le_id05,
		sa.le_id06,
		sa.le_id07,
		sa.le_id08,
		sa.le_id09,
		sa.le_id10,
		sa.le_key,
		sa.le_status,
		sa.le_type,
		sa.lupd_datetime,
		sa.lupd_prog,
		sa.lupd_user,
		sa.noteid,
		sa.period_num,
		sa.pe_date,
		sa.user1,
		sa.user2,
		sa.user3,
		sa.user4,
		sa.week_num,
		Company = 'SHOPPERNY'
	from SQL1.shopperapp.dbo.PJLABHDR sa with (nolock)
--	left join stagedm.dbo.PJLABHDR sdm
--		on sa.docNbr = sdm.docNbr
--	where sdm.docNbr is null

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
			@developerMessage = 'Error inserting into StageDM.dbo.PJLABHDR (Shopper NY)'
		
		execute StageDM.dbo.ErrorInfoPopulate @ErrorDatetime, @ErrorNumber, @ErrorSeverity, @ErrorState, @ErrorProcedure, @ErrorLine, @ErrorMessage, @UserName, @developerMessage
		
		rollback tran
	
	end

commit tran

---------------------------------------------
-- permissions
---------------------------------------------
grant execute on wrkPJLABHDR to BFGROUP
go
