USE [StageDM]
GO

SET QUOTED_IDENTIFIER OFF
GO
SET ANSI_NULLS ON
GO

IF EXISTS (
            SELECT 1
            FROM sys.procedures with (nolock)
            WHERE NAME = 'wrkPJPROJEX'
                AND type = 'P'
           )
    DROP PROCEDURE [dbo].[wrkPJPROJEX]
GO

CREATE PROCEDURE [dbo].[wrkPJPROJEX] 

	
AS 

/*******************************************************************************************************
*   StageDM.dbo.wrkPJPROJEXEX
*
*   Creator: Michelle Morales    
*   Date: 03/21/2016          
*   
*          
*   Notes:  set statistics io on

*
*   Usage:	
			execute StageDM.dbo.wrkPJPROJEX

			select top 100 *
			from StageDM.dbo.PJPROJEX
			
			
			select column_name + ','
			from stageDM.information_schema.columns
			where table_name = 'PJPROJEX'

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

	truncate table StageDM.dbo.PJPROJEX
	
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
			@developerMessage = 'Error truncating StageDM.dbo.PJPROJEX'
		
		execute StageDM.dbo.ErrorInfoPopulate @ErrorDatetime, @ErrorNumber, @ErrorSeverity, @ErrorState, @ErrorProcedure, @ErrorLine, @ErrorMessage, @UserName, @developerMessage
		
		rollback tran
		
	end
	
	insert StageDM.dbo.PJPROJEX
	(
		computed_date,
		computed_pc,
		crtd_datetime,
		crtd_prog,
		crtd_user,
		entered_pc,
		lupd_datetime,
		lupd_prog,
		lupd_user,
		noteid,
		PM_ID11,
		PM_ID12,
		PM_ID13,
		PM_ID14,
		PM_ID15,
		PM_ID16,
		PM_ID17,
		PM_ID18,
		PM_ID19,
		PM_ID20,
		PM_ID21,
		PM_ID22,
		PM_ID23,
		PM_ID24,
		PM_ID25,
		PM_ID26,
		PM_ID27,
		PM_ID28,
		PM_ID29,
		PM_ID30,
		proj_date1,
		proj_date2,
		proj_date3,
		proj_date4,
		project,
		rate_table_labor,
		revision_date,
		rev_flag,
		rev_type,
		work_comp_cd,
		work_location,
		Company
	)
	select computed_date,
		computed_pc,
		crtd_datetime,
		crtd_prog,
		crtd_user,
		entered_pc,
		lupd_datetime,
		lupd_prog,
		lupd_user,
		noteid,
		PM_ID11,
		PM_ID12,
		PM_ID13,
		PM_ID14,
		PM_ID15,
		PM_ID16,
		PM_ID17,
		PM_ID18,
		PM_ID19,
		PM_ID20,
		PM_ID21,
		PM_ID22,
		PM_ID23,
		PM_ID24,
		PM_ID25,
		PM_ID26,
		PM_ID27,
		PM_ID28,
		PM_ID29,
		PM_ID30,
		proj_date1,
		proj_date2,
		proj_date3,
		proj_date4,
		project,
		rate_table_labor,
		revision_date,
		rev_flag,
		rev_type,
		work_comp_cd,
		work_location,
		Company = 'DENVER'
	from SQL1.denverapp.dbo.PJPROJEX with (nolock)

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
			@developerMessage = 'Error inserting into StageDM.dbo.PJPROJEX (Denver)'
		
		execute StageDM.dbo.ErrorInfoPopulate @ErrorDatetime, @ErrorNumber, @ErrorSeverity, @ErrorState, @ErrorProcedure, @ErrorLine, @ErrorMessage, @UserName, @developerMessage
		
		rollback tran
	
	end

	insert StageDM.dbo.PJPROJEX
	(
		computed_date,
		computed_pc,
		crtd_datetime,
		crtd_prog,
		crtd_user,
		entered_pc,
		lupd_datetime,
		lupd_prog,
		lupd_user,
		noteid,
		PM_ID11,
		PM_ID12,
		PM_ID13,
		PM_ID14,
		PM_ID15,
		PM_ID16,
		PM_ID17,
		PM_ID18,
		PM_ID19,
		PM_ID20,
		PM_ID21,
		PM_ID22,
		PM_ID23,
		PM_ID24,
		PM_ID25,
		PM_ID26,
		PM_ID27,
		PM_ID28,
		PM_ID29,
		PM_ID30,
		proj_date1,
		proj_date2,
		proj_date3,
		proj_date4,
		project,
		rate_table_labor,
		revision_date,
		rev_flag,
		rev_type,
		work_comp_cd,
		work_location,
		Company
	)
	select sa.computed_date,
		sa.computed_pc,
		sa.crtd_datetime,
		sa.crtd_prog,
		sa.crtd_user,
		sa.entered_pc,
		sa.lupd_datetime,
		sa.lupd_prog,
		sa.lupd_user,
		sa.noteid,
		sa.PM_ID11,
		sa.PM_ID12,
		sa.PM_ID13,
		sa.PM_ID14,
		sa.PM_ID15,
		sa.PM_ID16,
		sa.PM_ID17,
		sa.PM_ID18,
		sa.PM_ID19,
		sa.PM_ID20,
		sa.PM_ID21,
		sa.PM_ID22,
		sa.PM_ID23,
		sa.PM_ID24,
		sa.PM_ID25,
		sa.PM_ID26,
		sa.PM_ID27,
		sa.PM_ID28,
		sa.PM_ID29,
		sa.PM_ID30,
		sa.proj_date1,
		sa.proj_date2,
		sa.proj_date3,
		sa.proj_date4,
		sa.project,
		sa.rate_table_labor,
		sa.revision_date,
		sa.rev_flag,
		sa.rev_type,
		sa.work_comp_cd,
		sa.work_location,
		Company = 'SHOPPERNY'
	from SQL1.shopperapp.dbo.PJPROJEX sa with (nolock)
--	left join stageDm.dbo.PJPROJEX sdm
--		on sa.project = sdm.project
--	where sdm.project is null

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
			@developerMessage = 'Error inserting into StageDM.dbo.PJPROJEX (Shopper NY)'
		
		execute StageDM.dbo.ErrorInfoPopulate @ErrorDatetime, @ErrorNumber, @ErrorSeverity, @ErrorState, @ErrorProcedure, @ErrorLine, @ErrorMessage, @UserName, @developerMessage
		
		rollback tran
	
	end

commit tran

---------------------------------------------
-- permissions
---------------------------------------------
grant execute on wrkPJPROJEX to BFGROUP
go
