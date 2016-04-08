USE [StageDM]
GO

SET QUOTED_IDENTIFIER OFF
GO
SET ANSI_NULLS ON
GO

IF EXISTS (
            SELECT 1
            FROM sys.procedures with (nolock)
            WHERE NAME = 'wrkPJCODE'
                AND type = 'P'
           )
    DROP PROCEDURE [dbo].[wrkPJCODE]
GO

CREATE PROCEDURE [dbo].[wrkPJCODE] 

	
AS 

/*******************************************************************************************************
*   StageDM.dbo.wrkPJCODE
*
*   Creator:	Michelle Morales    
*   Date:		03/21/2016          
*   
*          
*   Notes:  set statistics io on

*
*   Usage:	
			execute StageDM.dbo.wrkPJCODE

			select top 100 *
			from StageDM.dbo.PJCODE
			
			
			select column_name + ','
			from stageDM.information_schema.columns
			where table_name = 'PJCODE'

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

	truncate table StageDM.dbo.PJCODE
	
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
			@developerMessage = 'Error truncating StageDM.dbo.PJCODE'
		
		execute StageDM.dbo.ErrorInfoPopulate @ErrorDatetime, @ErrorNumber, @ErrorSeverity, @ErrorState, @ErrorProcedure, @ErrorLine, @ErrorMessage, @UserName, @developerMessage
		
		rollback tran
		
	end
	
	insert StageDM.dbo.PJCODE
	(
		code_type,
		code_value,
		code_value_desc,
		crtd_datetime,
		crtd_prog,
		crtd_user,
		data1,
		data2,
		data3,
		data4,
		lupd_datetime,
		lupd_prog,
		lupd_user,
		noteid,
		Company
	)
	select code_type,
		code_value,
		code_value_desc,
		crtd_datetime,
		crtd_prog,
		crtd_user,
		data1,
		data2,
		data3,
		data4,
		lupd_datetime,
		lupd_prog,
		lupd_user,
		noteid,
		Company = 'DENVER'
	from SQL1.denverapp.dbo.PJCODE with (nolock)

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
			@developerMessage = 'Error inserting into StageDM.dbo.PJCODE (Denver)'
		
		execute StageDM.dbo.ErrorInfoPopulate @ErrorDatetime, @ErrorNumber, @ErrorSeverity, @ErrorState, @ErrorProcedure, @ErrorLine, @ErrorMessage, @UserName, @developerMessage
		
		rollback tran
	
	end

	insert StageDM.dbo.PJCODE
	(
		code_type,
		code_value,
		code_value_desc,
		crtd_datetime,
		crtd_prog,
		crtd_user,
		data1,
		data2,
		data3,
		data4,
		lupd_datetime,
		lupd_prog,
		lupd_user,
		noteid,
		Company
	)
	select code.code_type,
		code.code_value,
		code.code_value_desc,
		code.crtd_datetime,
		code.crtd_prog,
		code.crtd_user,
		code.data1,
		code.data2,
		code.data3,
		code.data4,
		code.lupd_datetime,
		code.lupd_prog,
		code.lupd_user,
		code.noteid,
		Company = 'SHOPPERNY'
	from SQL1.shopperapp.dbo.PJCODE code with (nolock)
--	left join StageDM.dbo.PJCODE sdm 
--		on code.code_type = sdm.code_type
--		and code.code_value = sdm.code_value
--	where sdm.code_type is null	
		
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
			@developerMessage = 'Error inserting into StageDM.dbo.PJCODE (Shopper NY)'
		
		execute StageDM.dbo.ErrorInfoPopulate @ErrorDatetime, @ErrorNumber, @ErrorSeverity, @ErrorState, @ErrorProcedure, @ErrorLine, @ErrorMessage, @UserName, @developerMessage
		
		rollback tran
	
	end

commit tran

---------------------------------------------
-- permissions
---------------------------------------------
grant execute on wrkPJCODE to BFGROUP
go
