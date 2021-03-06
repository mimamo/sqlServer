USE [SHOPPER_DEV_APP]
GO
/****** Object:  StoredProcedure [dbo].[xtmpAPSXfer_UpdateStudioTax]    Script Date: 12/16/2015 15:55:39 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[xtmpAPSXfer_UpdateStudioTax] 

			@project char(16),
			@prog char(8),
			@user char(10)
AS

set nocount on

declare @tmpUser	char(10),
		@APSFncSalesTax	char(30),
		@agencyCust		char(15),
		@taxRate float,
		@taxDate as smalldatetime

	select top 1
		@tmpUser = crtd_user
	from
		xtmpAPSXfer
	where 
		studio_project = @project

	if rtrim(@tmpUser) != rtrim(@user)
		return 0

	select 
		@agencyCust = ap.customer
	from
		pjProj as sp
			join pjProj as ap on sp.pm_id34 = ap.project
	where
		sp.project = @project
 
	set @taxDate = getdate()

	select @taxRate = 	 sum(taxRate) from dbo.xFncTaxPosting(@agencyCust, @taxDate)
	
	select @taxRate = @taxRate * .01

	select 	@APSFncSalesTax = control_data	-- 99999
						from PJContrl with (nolock, fastfirstrow) where control_type = 'IG' and control_code = 'APSSLSTXFUN'


	if (@agencyCust in (select code_value from pjcode where code_type = '9int'))
	begin
		set @taxRate = 0.0
		set @APSFncSalesTax = ' '
	end
	

-- Update Sales Tax Line Item
	update xtmpAPSXfer
		set bill_amount = isnull(round((select
							sum(bill_amount * @taxRate ) 
							from 
								xtmpAPSXfer
							where exists (
								select code_id from xIGFunctionCode 
								where 
									xtmpAPSXfer.studio_pjt_entity = xIGFunctionCode.code_id and 
									xIGFunctionCode.code_group like 'aps' and 
									xIGFunctionCode.user02 like 'TAXABLE' and
									xtmpAPSXfer.studio_project = @project and 
									xtmpAPSXfer.studio_pjt_entity != @APSFncSalesTax)),2), 0)
	where 
		studio_project = @project and 
		studio_pjt_entity = @APSFncSalesTax and
		isnull(@taxRate,0) > 0
GO
