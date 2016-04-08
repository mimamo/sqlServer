USE [StageDM]
GO

SET QUOTED_IDENTIFIER OFF
GO
SET ANSI_NULLS ON
GO

IF EXISTS (
            SELECT 1
            FROM sys.procedures with (nolock)
            WHERE NAME = 'wrkPJPROJ'
                AND type = 'P'
           )
    DROP PROCEDURE [dbo].[wrkPJPROJ]
GO

CREATE PROCEDURE [dbo].[wrkPJPROJ] 

	
AS 

/*******************************************************************************************************
*   StageDM.dbo.wrkPJPROJ
*
*   Creator: Michelle Morales    
*   Date: 03/21/2016          
*   
*          
*   Notes:  set statistics io on

*
*   Usage:	

			execute StageDM.dbo.wrkPJPROJ

			select top 100 *
			from StageDM.dbo.pjproj
			
			
			select column_name + ','
			from stageDM.information_schema.columns
			where table_name = 'pjproj'

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

	truncate table StageDM.dbo.pjproj
	
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
			@developerMessage = 'Error truncating StageDM.dbo.pjproj'
		
		execute StageDM.dbo.ErrorInfoPopulate @ErrorDatetime, @ErrorNumber, @ErrorSeverity, @ErrorState, @ErrorProcedure, @ErrorLine, @ErrorMessage, @UserName, @developerMessage
		
		rollback tran
		
	end
	
	insert StageDM.dbo.pjproj
	(
		alloc_method_cd,
		BaseCuryId,
		bf_values_switch,
		billcuryfixedrate,
		billcuryid,
		billing_setup,
		billratetypeid,
		budget_type,
		budget_version,
		[contract],
		contract_type,
		CpnyId,
		crtd_datetime,
		crtd_prog,
		crtd_user,
		CuryId,
		CuryRateType,
		customer,
		end_date,
		gl_subacct,
		labor_gl_acct,
		lupd_datetime,
		lupd_prog,
		lupd_user,
		manager1,
		manager2,
		MSPData,
		MSPInterface,
		MSPProj_ID,
		noteid,
		opportunityID,
		pm_id01,
		pm_id02,
		pm_id03,
		pm_id04,
		pm_id05,
		pm_id06,
		pm_id07,
		pm_id08,
		pm_id09,
		pm_id10,
		pm_id31,
		pm_id32,
		pm_id33,
		pm_id34,
		pm_id35,
		pm_id36,
		pm_id37,
		pm_id38,
		pm_id39,
		pm_id40,
		probability,
		project,
		project_desc,
		purchase_order_num,
		rate_table_id,
		shiptoid,
		slsperid,
		[start_date],
		status_08,
		status_09,
		status_10,
		status_11,
		status_12,
		status_13,
		status_14,
		status_15,
		status_16,
		status_17,
		status_18,
		status_19,
		status_20,
		status_ap,
		status_ar,
		status_gl,
		status_in,
		status_lb,
		status_pa,
		status_po,
		user1,
		user2,
		user3,
		user4,
		Company
	)
	select alloc_method_cd,
		BaseCuryId,
		bf_values_switch,
		billcuryfixedrate,
		billcuryid,
		billing_setup,
		billratetypeid,
		budget_type,
		budget_version,
		[contract],
		contract_type,
		CpnyId,
		crtd_datetime,
		crtd_prog,
		crtd_user,
		CuryId,
		CuryRateType,
		customer,
		end_date,
		gl_subacct,
		labor_gl_acct,
		lupd_datetime,
		lupd_prog,
		lupd_user,
		manager1,
		manager2,
		MSPData,
		MSPInterface,
		MSPProj_ID,
		noteid,
		opportunityID,
		pm_id01,
		pm_id02,
		pm_id03,
		pm_id04,
		pm_id05,
		pm_id06,
		pm_id07,
		pm_id08,
		pm_id09,
		pm_id10,
		pm_id31,
		pm_id32,
		pm_id33,
		pm_id34,
		pm_id35,
		pm_id36,
		pm_id37,
		pm_id38,
		pm_id39,
		pm_id40,
		probability,
		project,
		project_desc,
		purchase_order_num,
		rate_table_id,
		shiptoid,
		slsperid,
		[start_date],
		status_08,
		status_09,
		status_10,
		status_11,
		status_12,
		status_13,
		status_14,
		status_15,
		status_16,
		status_17,
		status_18,
		status_19,
		status_20,
		status_ap,
		status_ar,
		status_gl,
		status_in,
		status_lb,
		status_pa,
		status_po,
		user1,
		user2,
		user3,
		user4,
		Company = 'DENVER'
	from SQL1.denverapp.dbo.pjproj with (nolock)

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
			@developerMessage = 'Error inserting into StageDM.dbo.pjproj (Denver)'
		
		execute StageDM.dbo.ErrorInfoPopulate @ErrorDatetime, @ErrorNumber, @ErrorSeverity, @ErrorState, @ErrorProcedure, @ErrorLine, @ErrorMessage, @UserName, @developerMessage
		
		rollback tran
	
	end

	insert StageDM.dbo.pjproj
	(
		alloc_method_cd,
		BaseCuryId,
		bf_values_switch,
		billcuryfixedrate,
		billcuryid,
		billing_setup,
		billratetypeid,
		budget_type,
		budget_version,
		[contract],
		contract_type,
		CpnyId,
		crtd_datetime,
		crtd_prog,
		crtd_user,
		CuryId,
		CuryRateType,
		customer,
		end_date,
		gl_subacct,
		labor_gl_acct,
		lupd_datetime,
		lupd_prog,
		lupd_user,
		manager1,
		manager2,
		MSPData,
		MSPInterface,
		MSPProj_ID,
		noteid,
		opportunityID,
		pm_id01,
		pm_id02,
		pm_id03,
		pm_id04,
		pm_id05,
		pm_id06,
		pm_id07,
		pm_id08,
		pm_id09,
		pm_id10,
		pm_id31,
		pm_id32,
		pm_id33,
		pm_id34,
		pm_id35,
		pm_id36,
		pm_id37,
		pm_id38,
		pm_id39,
		pm_id40,
		probability,
		project,
		project_desc,
		purchase_order_num,
		rate_table_id,
		shiptoid,
		slsperid,
		[start_date],
		status_08,
		status_09,
		status_10,
		status_11,
		status_12,
		status_13,
		status_14,
		status_15,
		status_16,
		status_17,
		status_18,
		status_19,
		status_20,
		status_ap,
		status_ar,
		status_gl,
		status_in,
		status_lb,
		status_pa,
		status_po,
		user1,
		user2,
		user3,
		user4,
		Company
	)
	select sa.alloc_method_cd,
		sa.BaseCuryId,
		sa.bf_values_switch,
		sa.billcuryfixedrate,
		sa.billcuryid,
		sa.billing_setup,
		sa.billratetypeid,
		sa.budget_type,
		sa.budget_version,
		sa.[contract],
		sa.contract_type,
		sa.CpnyId,
		sa.crtd_datetime,
		sa.crtd_prog,
		sa.crtd_user,
		sa.CuryId,
		sa.CuryRateType,
		sa.customer,
		sa.end_date,
		sa.gl_subacct,
		sa.labor_gl_acct,
		sa.lupd_datetime,
		sa.lupd_prog,
		sa.lupd_user,
		sa.manager1,
		sa.manager2,
		sa.MSPData,
		sa.MSPInterface,
		sa.MSPProj_ID,
		sa.noteid,
		sa.opportunityID,
		sa.pm_id01,
		sa.pm_id02,
		sa.pm_id03,
		sa.pm_id04,
		sa.pm_id05,
		sa.pm_id06,
		sa.pm_id07,
		sa.pm_id08,
		sa.pm_id09,
		sa.pm_id10,
		sa.pm_id31,
		sa.pm_id32,
		sa.pm_id33,
		sa.pm_id34,
		sa.pm_id35,
		sa.pm_id36,
		sa.pm_id37,
		sa.pm_id38,
		sa.pm_id39,
		sa.pm_id40,
		sa.probability,
		sa.project,
		sa.project_desc,
		sa.purchase_order_num,
		sa.rate_table_id,
		sa.shiptoid,
		sa.slsperid,
		sa.[start_date],
		sa.status_08,
		sa.status_09,
		sa.status_10,
		sa.status_11,
		sa.status_12,
		sa.status_13,
		sa.status_14,
		sa.status_15,
		sa.status_16,
		sa.status_17,
		sa.status_18,
		sa.status_19,
		sa.status_20,
		sa.status_ap,
		sa.status_ar,
		sa.status_gl,
		sa.status_in,
		sa.status_lb,
		sa.status_pa,
		sa.status_po,
		sa.user1,
		sa.user2,
		sa.user3,
		sa.user4,
		Company = 'SHOPPERNY'
	from SQL1.shopperapp.dbo.pjproj sa with (nolock)
--	left join stageDm.dbo.pjproj sdm
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
			@developerMessage = 'Error inserting into StageDM.dbo.pjproj (Shopper NY)'
		
		execute StageDM.dbo.ErrorInfoPopulate @ErrorDatetime, @ErrorNumber, @ErrorSeverity, @ErrorState, @ErrorProcedure, @ErrorLine, @ErrorMessage, @UserName, @developerMessage
		
		rollback tran
	
	end

commit tran

---------------------------------------------
-- permissions
---------------------------------------------
grant execute on wrkPJPROJ to BFGROUP
go
