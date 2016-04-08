USE [StageDM]
GO

SET QUOTED_IDENTIFIER OFF
GO
SET ANSI_NULLS ON
GO

IF EXISTS (
            SELECT 1
            FROM sys.procedures with (nolock)
            WHERE NAME = 'wrkxIGProdCode'
                AND type = 'P'
           )
    DROP PROCEDURE [dbo].[wrkxIGProdCode]
GO

CREATE PROCEDURE [dbo].[wrkxIGProdCode] 

	
AS 

/*******************************************************************************************************
*   StageDM.dbo.wrkxIGProdCode
*
*   Creator:	Michelle Morales    
*   Date:		03/21/2016          
*   
*          
*   Notes:  set statistics io on

*
*   Usage:	

			execute StageDM.dbo.wrkxIGProdCode

			select top 100 *
			from StageDM.dbo.xIGProdCode
			
			
			select column_name + ','
			from stageDM.information_schema.columns
			where table_name = 'xIGProdCode'

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

	truncate table StageDM.dbo.xIGProdCode
	
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
			@developerMessage = 'Error truncating StageDM.dbo.xIGProdCode'
		
		execute StageDM.dbo.ErrorInfoPopulate @ErrorDatetime, @ErrorNumber, @ErrorSeverity, @ErrorState, @ErrorProcedure, @ErrorLine, @ErrorMessage, @UserName, @developerMessage
		
		rollback tran
		
	end
	
	insert StageDM.dbo.xIGProdCode
	(
		activate_by,
		activate_date,
		code_group,
		code_ID,
		CpnyID,
		crtd_datetime,
		crtd_prog,
		crtd_user,
		deactivate_by,
		deactivate_date,
		descr,
		lupd_datetime,
		lupd_prog,
		lupd_user,
		noteid,
		[status],
		[Type],
		user01,
		user02,
		user03,
		user04,
		user05,
		user06,
		user07,
		user08,
		user09,
		user10,
		user11,
		user12,
		Company
	)
	select activate_by,
		activate_date,
		code_group,
		code_ID,
		CpnyID,
		crtd_datetime,
		crtd_prog,
		crtd_user,
		deactivate_by,
		deactivate_date,
		descr,
		lupd_datetime,
		lupd_prog,
		lupd_user,
		noteid,
		[status],
		[Type],
		user01 = '', -- Business Unit (for MC FTE Hours)
		user02 = '', -- Brand (for MC FTE Hours)
		user03,
		user04,
		user05 = '', -- Sub Unit (for MC FTE Hours)
		user06 = '', -- Product Status (RET, OOS or OTH)
		user07,
		user08,
		user09,
		user10,
		user11,
		user12,
		Company = 'DENVER'
	from SQL1.denverapp.dbo.xIGProdCode with (nolock)

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
			@developerMessage = 'Error inserting into StageDM.dbo.xIGProdCode (Denver)'
		
		execute StageDM.dbo.ErrorInfoPopulate @ErrorDatetime, @ErrorNumber, @ErrorSeverity, @ErrorState, @ErrorProcedure, @ErrorLine, @ErrorMessage, @UserName, @developerMessage
		
		rollback tran
	
	end

	insert StageDM.dbo.xIGProdCode
	(
		activate_by,
		activate_date,
		code_group,
		code_ID,
		CpnyID,
		crtd_datetime,
		crtd_prog,
		crtd_user,
		deactivate_by,
		deactivate_date,
		descr,
		lupd_datetime,
		lupd_prog,
		lupd_user,
		noteid,
		[status],
		[Type],
		user01,
		user02,
		user03,
		user04,
		user05,
		user06,
		user07,
		user08,
		user09,
		user10,
		user11,
		user12,
		Company
	)
	select sa.activate_by,
		sa.activate_date,
		sa.code_group,
		sa.code_ID,
		sa.CpnyID,
		sa.crtd_datetime,
		sa.crtd_prog,
		sa.crtd_user,
		sa.deactivate_by,
		sa.deactivate_date,
		sa.descr,
		sa.lupd_datetime,
		sa.lupd_prog,
		sa.lupd_user,
		sa.noteid,
		sa.[status],
		sa.[Type],
		user01 = '', -- Business Unit (for MC FTE Hours)
		user02 = '', -- Brand (for MC FTE Hours)
		sa.user03,
		sa.user04,
		user05 = '', -- Sub Unit (for MC FTE Hours)
		user06 = '', -- Product Status (RET, OOS or OTH)
		sa.user07,
		sa.user08,
		sa.user09,
		sa.user10,
		sa.user11,
		sa.user12,
		Company = 'SHOPPERNY'
	from SQL1.shopperapp.dbo.xIGProdCode sa with (nolock)
--	left join stageDm.dbo.xIGProdCode sdm
--		on sa.code_group = sdm.code_group
--		and sa.code_id = sdm.code_id
--	where sdm.code_group is null

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
			@developerMessage = 'Error inserting into StageDM.dbo.xIGProdCode (Shopper NY)'
		
		execute StageDM.dbo.ErrorInfoPopulate @ErrorDatetime, @ErrorNumber, @ErrorSeverity, @ErrorState, @ErrorProcedure, @ErrorLine, @ErrorMessage, @UserName, @developerMessage
		
		rollback tran
	
	end
	
	-- will get rid of this once user06 (product status) has been updated in prod.
	update pc
		set User06 = act.[RET OR OOS OR OTH]
	from stageDm.dbo.xigProdCode pc
	inner join financeDm.dbo.ActiverProdCodeDenver act
		--on pc.code_group = act.code_group
		on pc.code_id = act.code_id
	--where coalesce(pc.User06,'') = ''
	
	-- will get rid of this once user01 (Business Unit) has been updated in prod.
	update pc
		set User01 = ltrim(rtrim(x.BusinessUnit))
	from stageDm.dbo.xigProdCode pc
	inner join stageDm.dbo.pjproj p
		on pc.code_ID  = p.pm_id02
	inner join sql1.denverapp.dbo.xwrk_Client_Groupings x with (nolock)
		on p.pm_id01 = x.clientID 
		and p.pm_id02 = x.prodID 
	where x.BusinessUnit is not null
	
	-- will get rid of this once user02 (Brand) has been updated in prod.
	update pc
		set User02 = ltrim(rtrim(x.Brand))
	from stageDm.dbo.xigProdCode pc
	inner join stageDm.dbo.pjproj p
		on pc.code_ID  = p.pm_id02
	inner join sql1.denverapp.dbo.xwrk_Client_Groupings x with (nolock)
		on p.pm_id01 = x.clientID 
		and p.pm_id02 = x.prodID 
	where x.Brand  is not null
	
	
	-- will get rid of this once user05 (Sub Unit) has been updated in prod.
	update pc
		set User05 = case when x.SubUnit = 'Customer Marketing' then 'Cust Mktg'
						when x.SubUnit = 'Great Lakes' then 'Grt Lakes'
						when x.SubUnit = 'Integration' then 'Integratio'
						when x.SubUnit = 'Large Format' then 'Lg Format'
						when x.SubUnit = 'Non Region Specific' then 'Non Spec'
						when x.SubUnit = 'Small Format' then 'Sm Format'
						else x.SubUnit
					end
	from stageDm.dbo.xigProdCode pc
	inner join stageDm.dbo.pjproj p
		on pc.code_ID  = p.pm_id02
	inner join sql1.denverapp.dbo.xwrk_Client_Groupings x with (nolock)
		on p.pm_id01 = x.clientID 
		and p.pm_id02 = x.prodID 
	where x.SubUnit is not null

commit tran

---------------------------------------------
-- permissions
---------------------------------------------
grant execute on wrkxIGProdCode to BFGROUP
go
