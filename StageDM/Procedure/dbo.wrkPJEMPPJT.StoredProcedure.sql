USE [StageDM]
GO

SET QUOTED_IDENTIFIER OFF
GO
SET ANSI_NULLS ON
GO

IF EXISTS (
            SELECT 1
            FROM sys.procedures with (nolock)
            WHERE NAME = 'wrkPJEMPPJT'
                AND type = 'P'
           )
    DROP PROCEDURE [dbo].[wrkPJEMPPJT]
GO

CREATE PROCEDURE [dbo].[wrkPJEMPPJT] 

	
AS 

/*******************************************************************************************************
*   StageDM.dbo.wrkPJEMPPJT
*
*   Creator:	Michelle Morales    
*   Date:		03/21/2016          
*   
*          
*   Notes:  set statistics io on

*
*   Usage:	

			execute StageDM.dbo.wrkPJEMPPJT

			select top 100 *
			from StageDM.dbo.PJEMPPJT
			
			
			select column_name + ','
			from stageDM.information_schema.columns
			where table_name = 'PJEMPPJT'

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

	truncate table StageDM.dbo.PJEMPPJT
	
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
			@developerMessage = 'Error truncating StageDM.dbo.PJEMPPJT'
		
		execute StageDM.dbo.ErrorInfoPopulate @ErrorDatetime, @ErrorNumber, @ErrorSeverity, @ErrorState, @ErrorProcedure, @ErrorLine, @ErrorMessage, @UserName, @developerMessage
		
		rollback tran
		
	end
	
	insert StageDM.dbo.PJEMPPJT
	(
		crtd_datetime,
		crtd_prog,
		crtd_user,
		employee,
		ep_id01,
		ep_id02,
		ep_id03,
		ep_id04,
		ep_id05,
		ep_id06,
		ep_id07,
		ep_id08,
		ep_id09,
		ep_id10,
		effect_date,
		labor_class_cd,
		labor_rate,
		lupd_datetime,
		lupd_prog,
		lupd_user,
		noteid,
		project,
		user1,
		user2,
		user3,
		user4,
		Company
	)
	select crtd_datetime,
		crtd_prog,
		crtd_user,
		employee,
		ep_id01,
		ep_id02,
		ep_id03,
		ep_id04,
		ep_id05,
		ep_id06,
		ep_id07,
		ep_id08,
		ep_id09,
		ep_id10,
		effect_date,
		labor_class_cd,
		labor_rate,
		lupd_datetime,
		lupd_prog,
		lupd_user,
		noteid,
		project,
		user1,
		user2,
		user3,
		user4,
		Company = 'DENVER'
	from SQL1.denverapp.dbo.PJEMPPJT with (nolock)

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
			@developerMessage = 'Error inserting into StageDM.dbo.PJEMPPJT (Denver)'
		
		execute StageDM.dbo.ErrorInfoPopulate @ErrorDatetime, @ErrorNumber, @ErrorSeverity, @ErrorState, @ErrorProcedure, @ErrorLine, @ErrorMessage, @UserName, @developerMessage
		
		rollback tran
	
	end

	insert StageDM.dbo.PJEMPPJT
	(
		crtd_datetime,
		crtd_prog,
		crtd_user,
		employee,
		ep_id01,
		ep_id02,
		ep_id03,
		ep_id04,
		ep_id05,
		ep_id06,
		ep_id07,
		ep_id08,
		ep_id09,
		ep_id10,
		effect_date,
		labor_class_cd,
		labor_rate,
		lupd_datetime,
		lupd_prog,
		lupd_user,
		noteid,
		project,
		user1,
		user2,
		user3,
		user4,
		Company
	)
	select sa.crtd_datetime,
		sa.crtd_prog,
		sa.crtd_user,
		sa.employee,
		sa.ep_id01,
		sa.ep_id02,
		sa.ep_id03,
		sa.ep_id04,
		sa.ep_id05,
		sa.ep_id06,
		sa.ep_id07,
		sa.ep_id08,
		sa.ep_id09,
		sa.ep_id10,
		sa.effect_date,
		sa.labor_class_cd,
		sa.labor_rate,
		sa.lupd_datetime,
		sa.lupd_prog,
		sa.lupd_user,
		sa.noteid,
		sa.project,
		sa.user1,
		sa.user2,
		sa.user3,
		sa.user4,
		Company = 'SHOPPERNY'
	from SQL1.shopperapp.dbo.PJEMPPJT sa with (nolock)
--	left join stageDm.dbo.PJEMPPJT sdm 
--		on sa.employee = sdm.employee
--		and sa.project = sdm.project
--		and sa.effect_date = sdm.effect_date
--	where sdm.employee is null

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
			@developerMessage = 'Error inserting into StageDM.dbo.PJEMPPJT (Shopper NY)'
		
		execute StageDM.dbo.ErrorInfoPopulate @ErrorDatetime, @ErrorNumber, @ErrorSeverity, @ErrorState, @ErrorProcedure, @ErrorLine, @ErrorMessage, @UserName, @developerMessage
		
		rollback tran
	
	end

commit tran

---------------------------------------------
-- permissions
---------------------------------------------
grant execute on wrkPJEMPPJT to BFGROUP
go
