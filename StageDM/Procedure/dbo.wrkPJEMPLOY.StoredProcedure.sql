USE [StageDM]
GO

SET QUOTED_IDENTIFIER OFF
GO
SET ANSI_NULLS ON
GO

IF EXISTS (
            SELECT 1
            FROM sys.procedures with (nolock)
            WHERE NAME = 'wrkPJEMPLOY'
                AND type = 'P'
           )
    DROP PROCEDURE [dbo].[wrkPJEMPLOY]
GO

CREATE PROCEDURE [dbo].[wrkPJEMPLOY] 

	
AS 

/*******************************************************************************************************
*   StageDM.dbo.wrkPJEMPLOY
*
*   Creator:	Michelle Morales    
*   Date:		03/22/2016          
*   
*          
*   Notes:  set statistics io on

*
*   Usage:	

			execute StageDM.dbo.wrkPJEMPLOY

			select top 100 *
			from StageDM.dbo.PJEMPLOY
			
			
			select column_name + ','
			from stageDM.information_schema.columns
			where table_name = 'PJEMPLOY'

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

	truncate table StageDM.dbo.PJEMPLOY
	
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
			@developerMessage = 'Error truncating StageDM.dbo.PJEMPLOY'
		
		execute StageDM.dbo.ErrorInfoPopulate @ErrorDatetime, @ErrorNumber, @ErrorSeverity, @ErrorState, @ErrorProcedure, @ErrorLine, @ErrorMessage, @UserName, @developerMessage
		
		rollback tran
		
	end
	
	insert StageDM.dbo.PJEMPLOY
	(
		BaseCuryId,
		CpnyId,
		crtd_datetime,
		crtd_prog,
		crtd_user,
		CuryId,
		CuryRateType,
		date_hired,
		date_terminated,
		employee,
		emp_name,
		emp_status,
		emp_type_cd,
		em_id01,
		em_id02,
		em_id03,
		em_id04,
		em_id05,
		em_id06,
		em_id07,
		em_id08,
		em_id09,
		em_id10,
		em_id11,
		em_id12,
		em_id13,
		em_id14,
		em_id15,
		em_id16,
		em_id17,
		em_id18,
		em_id19,
		em_id20,
		em_id21,
		em_id22,
		em_id23,
		em_id24,
		em_id25,
		exp_approval_max,
		gl_subacct,
		lupd_datetime,
		lupd_prog,
		lupd_user,
		manager1,
		manager2,
		MSPData,
		MSPInterface,
		MSPRes_UID,
		MSPType,
		noteid,
		placeholder,
		stdday,
		Stdweek,
		Subcontractor,
		user1,
		user2,
		user3,
		user4,
		[user_id],
		Company
	)
	select BaseCuryId,
		CpnyId,
		crtd_datetime,
		crtd_prog,
		crtd_user,
		CuryId,
		CuryRateType,
		date_hired,
		date_terminated,
		employee,
		emp_name,
		emp_status,
		emp_type_cd,
		em_id01,
		em_id02,
		em_id03,
		em_id04,
		em_id05,
		em_id06,
		em_id07,
		em_id08,
		em_id09,
		em_id10,
		em_id11,
		em_id12,
		em_id13,
		em_id14,
		em_id15,
		em_id16,
		em_id17,
		em_id18,
		em_id19,
		em_id20,
		em_id21,
		em_id22,
		em_id23,
		em_id24,
		em_id25,
		exp_approval_max,
		gl_subacct,
		lupd_datetime,
		lupd_prog,
		lupd_user,
		manager1,
		manager2,
		MSPData,
		MSPInterface,
		MSPRes_UID,
		MSPType,
		noteid,
		placeholder,
		stdday,
		Stdweek,
		Subcontractor,
		user1,
		user2,
		user3,
		user4,
		[user_id],
		Company = 'DENVER'
	from SQL1.denverapp.dbo.PJEMPLOY with (nolock)

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
			@developerMessage = 'Error inserting into StageDM.dbo.PJEMPLOY (Denver)'
		
		execute StageDM.dbo.ErrorInfoPopulate @ErrorDatetime, @ErrorNumber, @ErrorSeverity, @ErrorState, @ErrorProcedure, @ErrorLine, @ErrorMessage, @UserName, @developerMessage
		
		rollback tran
	
	end

	insert StageDM.dbo.PJEMPLOY
	(
		BaseCuryId,
		CpnyId,
		crtd_datetime,
		crtd_prog,
		crtd_user,
		CuryId,
		CuryRateType,
		date_hired,
		date_terminated,
		employee,
		emp_name,
		emp_status,
		emp_type_cd,
		em_id01,
		em_id02,
		em_id03,
		em_id04,
		em_id05,
		em_id06,
		em_id07,
		em_id08,
		em_id09,
		em_id10,
		em_id11,
		em_id12,
		em_id13,
		em_id14,
		em_id15,
		em_id16,
		em_id17,
		em_id18,
		em_id19,
		em_id20,
		em_id21,
		em_id22,
		em_id23,
		em_id24,
		em_id25,
		exp_approval_max,
		gl_subacct,
		lupd_datetime,
		lupd_prog,
		lupd_user,
		manager1,
		manager2,
		MSPData,
		MSPInterface,
		MSPRes_UID,
		MSPType,
		noteid,
		placeholder,
		stdday,
		Stdweek,
		Subcontractor,
		user1,
		user2,
		user3,
		user4,
		[user_id],
		Company
	)
	select sa.BaseCuryId,
		sa.CpnyId,
		sa.crtd_datetime,
		sa.crtd_prog,
		sa.crtd_user,
		sa.CuryId,
		sa.CuryRateType,
		sa.date_hired,
		sa.date_terminated,
		sa.employee,
		sa.emp_name,
		sa.emp_status,
		sa.emp_type_cd,
		sa.em_id01,
		sa.em_id02,
		sa.em_id03,
		sa.em_id04,
		sa.em_id05,
		sa.em_id06,
		sa.em_id07,
		sa.em_id08,
		sa.em_id09,
		sa.em_id10,
		sa.em_id11,
		sa.em_id12,
		sa.em_id13,
		sa.em_id14,
		sa.em_id15,
		sa.em_id16,
		sa.em_id17,
		sa.em_id18,
		sa.em_id19,
		sa.em_id20,
		sa.em_id21,
		sa.em_id22,
		sa.em_id23,
		sa.em_id24,
		sa.em_id25,
		sa.exp_approval_max,
		sa.gl_subacct,
		sa.lupd_datetime,
		sa.lupd_prog,
		sa.lupd_user,
		sa.manager1,
		sa.manager2,
		sa.MSPData,
		sa.MSPInterface,
		sa.MSPRes_UID,
		sa.MSPType,
		sa.noteid,
		sa.placeholder,
		sa.stdday,
		sa.Stdweek,
		sa.Subcontractor,
		sa.user1,
		sa.user2,
		sa.user3,
		sa.user4,
		sa.[user_id],
		Company = 'SHOPPERNY'
	from SQL1.shopperapp.dbo.PJEMPLOY sa with (nolock)
--	left join stageDm.dbo.PJEMPLOY sdm
--		on sa.employee = sdm.employee
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
			@developerMessage = 'Error inserting into StageDM.dbo.PJEMPLOY (Shopper NY)'
		
		execute StageDM.dbo.ErrorInfoPopulate @ErrorDatetime, @ErrorNumber, @ErrorSeverity, @ErrorState, @ErrorProcedure, @ErrorLine, @ErrorMessage, @UserName, @developerMessage
		
		rollback tran
	
	end

commit tran

---------------------------------------------
-- permissions
---------------------------------------------
grant execute on wrkPJEMPLOY to BFGROUP
go
