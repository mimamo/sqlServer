USE [StageDM]
GO

SET QUOTED_IDENTIFIER OFF
GO
SET ANSI_NULLS ON
GO

IF EXISTS (
            SELECT 1
            FROM sys.procedures with (nolock)
            WHERE NAME = 'wrkPJTRAN'
                AND type = 'P'
           )
    DROP PROCEDURE [dbo].[wrkPJTRAN]
GO

CREATE PROCEDURE [dbo].[wrkPJTRAN] 

	
AS 

/*******************************************************************************************************
*   StageDM.dbo.wrkPJTRAN
*
*   Creator: Michelle Morales    
*   Date: 03/21/2016          
*   
*          
*   Notes:  set statistics io on

*
*   Usage:	

			execute StageDM.dbo.wrkPJTRAN

			select top 100 *
			from StageDM.dbo.pjtran
			
			
			select column_name + ','
			from stageDM.information_schema.columns
			where table_name = 'pjtran'

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
	@developerMessage varchar(254),
	@minFiscalNo varchar(10)

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
select @minFiscalNo = null

select @minFiscalNo = min(fiscalno)
from sql1.denverapp.dbo.pjtran with (nolock)

begin tran

	truncate table StageDM.dbo.pjtran
	
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
			@developerMessage = 'Error truncating StageDM.dbo.pjtran'
		
		execute StageDM.dbo.ErrorInfoPopulate @ErrorDatetime, @ErrorNumber, @ErrorSeverity, @ErrorState, @ErrorProcedure, @ErrorLine, @ErrorMessage, @UserName, @developerMessage
		
		rollback tran
		
	end
	
	while @minFiscalNo is not null
	begin
	
		insert StageDM.dbo.pjtran
		(
			acct,
			alloc_flag,
			amount,
			BaseCuryId,
			batch_id,
			batch_type,
			bill_batch_id,
			CpnyId,
			crtd_datetime,
			crtd_prog,
			crtd_user,
			CuryEffDate,
			CuryId,
			CuryMultDiv,
			CuryRate,
			CuryRateType,
			CuryTranamt,
			data1,
			detail_num,
			employee,
			fiscalno,
			gl_acct,
			gl_subacct,
			lupd_datetime,
			lupd_prog,
			lupd_user,
			noteid,
			pjt_entity,
			post_date,
			project,
			Subcontract,
			system_cd,
			trans_date,
			tr_comment,
			tr_id01,
			tr_id02,
			tr_id03,
			tr_id04,
			tr_id05,
			tr_id06,
			tr_id07,
			tr_id08,
			tr_id09,
			tr_id10,
			tr_id23,
			tr_id24,
			tr_id25,
			tr_id26,
			tr_id27,
			tr_id28,
			tr_id29,
			tr_id30,
			tr_id31,
			tr_id32,
			tr_status,
			unit_of_measure,
			units,
			user1,
			user2,
			user3,
			user4,
			vendor_num,
			voucher_line,
			voucher_num,
			Company
		)
		select acct,
			alloc_flag,
			amount,
			BaseCuryId,
			batch_id,
			batch_type,
			bill_batch_id,
			CpnyId,
			crtd_datetime,
			crtd_prog,
			crtd_user,
			CuryEffDate,
			CuryId,
			CuryMultDiv,
			CuryRate,
			CuryRateType,
			CuryTranamt,
			data1,
			detail_num,
			employee,
			fiscalno,
			gl_acct,
			gl_subacct,
			lupd_datetime,
			lupd_prog,
			lupd_user,
			noteid,
			pjt_entity,
			post_date,
			project,
			Subcontract,
			system_cd,
			trans_date,
			tr_comment,
			tr_id01,
			tr_id02,
			tr_id03,
			tr_id04,
			tr_id05,
			tr_id06,
			tr_id07,
			tr_id08,
			tr_id09,
			tr_id10,
			tr_id23,
			tr_id24,
			tr_id25,
			tr_id26,
			tr_id27,
			tr_id28,
			tr_id29,
			tr_id30,
			tr_id31,
			tr_id32,
			tr_status,
			unit_of_measure,
			units,
			user1,
			user2,
			user3,
			user4,
			vendor_num,
			voucher_line,
			voucher_num,
			Company = 'DENVER'
		from SQL1.denverapp.dbo.pjtran with (nolock)
		where fiscalNo = @minFiscalNo

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
				@developerMessage = 'Error inserting into StageDM.dbo.pjtran (Denver)'
			
			execute StageDM.dbo.ErrorInfoPopulate @ErrorDatetime, @ErrorNumber, @ErrorSeverity, @ErrorState, @ErrorProcedure, @ErrorLine, @ErrorMessage, @UserName, @developerMessage
			
			rollback tran
		
		end

		insert StageDM.dbo.pjtran
		(
			acct,
			alloc_flag,
			amount,
			BaseCuryId,
			batch_id,
			batch_type,
			bill_batch_id,
			CpnyId,
			crtd_datetime,
			crtd_prog,
			crtd_user,
			CuryEffDate,
			CuryId,
			CuryMultDiv,
			CuryRate,
			CuryRateType,
			CuryTranamt,
			data1,
			detail_num,
			employee,
			fiscalno,
			gl_acct,
			gl_subacct,
			lupd_datetime,
			lupd_prog,
			lupd_user,
			noteid,
			pjt_entity,
			post_date,
			project,
			Subcontract,
			system_cd,
			trans_date,
			tr_comment,
			tr_id01,
			tr_id02,
			tr_id03,
			tr_id04,
			tr_id05,
			tr_id06,
			tr_id07,
			tr_id08,
			tr_id09,
			tr_id10,
			tr_id23,
			tr_id24,
			tr_id25,
			tr_id26,
			tr_id27,
			tr_id28,
			tr_id29,
			tr_id30,
			tr_id31,
			tr_id32,
			tr_status,
			unit_of_measure,
			units,
			user1,
			user2,
			user3,
			user4,
			vendor_num,
			voucher_line,
			voucher_num,
			Company
		)
		select sa.acct,
			sa.alloc_flag,
			sa.amount,
			sa.BaseCuryId,
			sa.batch_id,
			sa.batch_type,
			sa.bill_batch_id,
			sa.CpnyId,
			sa.crtd_datetime,
			sa.crtd_prog,
			sa.crtd_user,
			sa.CuryEffDate,
			sa.CuryId,
			sa.CuryMultDiv,
			sa.CuryRate,
			sa.CuryRateType,
			sa.CuryTranamt,
			sa.data1,
			sa.detail_num,
			sa.employee,
			sa.fiscalno,
			sa.gl_acct,
			sa.gl_subacct,
			sa.lupd_datetime,
			sa.lupd_prog,
			sa.lupd_user,
			sa.noteid,
			sa.pjt_entity,
			sa.post_date,
			sa.project,
			sa.Subcontract,
			sa.system_cd,
			sa.trans_date,
			sa.tr_comment,
			sa.tr_id01,
			sa.tr_id02,
			sa.tr_id03,
			sa.tr_id04,
			sa.tr_id05,
			sa.tr_id06,
			sa.tr_id07,
			sa.tr_id08,
			sa.tr_id09,
			sa.tr_id10,
			sa.tr_id23,
			sa.tr_id24,
			sa.tr_id25,
			sa.tr_id26,
			sa.tr_id27,
			sa.tr_id28,
			sa.tr_id29,
			sa.tr_id30,
			sa.tr_id31,
			sa.tr_id32,
			sa.tr_status,
			sa.unit_of_measure,
			sa.units,
			sa.user1,
			sa.user2,
			sa.user3,
			sa.user4,
			sa.vendor_num,
			sa.voucher_line,
			sa.voucher_num,
			Company = 'SHOPPERNY'
		from SQL1.shopperapp.dbo.pjtran sa with (nolock)
	--	left join stageDm.dbo.pjtran sdm
	--		on sa.fiscalno = sdm.fiscalno
	--		and sa.project = sdm.project
	--		and sa.system_cd = sdm.system_cd
	--		and sa.batch_id = sdm.batch_id
	--		and sa.detail_num = sdm.detail_num
			--and sa.employee = sdm.employee
		where sa.fiscalNo = @minFiscalNo
	--		and sdm.fiscalNo is null

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
				@developerMessage = 'Error inserting into StageDM.dbo.pjtran (Shopper NY)'
			
			execute StageDM.dbo.ErrorInfoPopulate @ErrorDatetime, @ErrorNumber, @ErrorSeverity, @ErrorState, @ErrorProcedure, @ErrorLine, @ErrorMessage, @UserName, @developerMessage
			
			rollback tran
		
		end
		
		select @minFiscalNo = min(fiscalno)
		from sql1.denverapp.dbo.pjtran with (nolock)
		where fiscalNo > @minFiscalNo
		
	end

commit tran

---------------------------------------------
-- permissions
---------------------------------------------
grant execute on wrkPJTRAN to BFGROUP
go
