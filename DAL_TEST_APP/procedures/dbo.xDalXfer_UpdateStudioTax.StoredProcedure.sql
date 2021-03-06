USE [DAL_TEST_APP]
GO
/****** Object:  StoredProcedure [dbo].[xDalXfer_UpdateStudioTax]    Script Date: 12/21/2015 13:57:19 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[xDalXfer_UpdateStudioTax] 

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
		xDalXfer
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
	update xDalXfer
		set bill_amount = round((select
							sum(round(bill_amount * @taxRate,2) ) 
							from 
								xDalXfer
							where 
								studio_project = @project and 
								studio_pjt_entity != @APSFncSalesTax),2)
	where 
		studio_project = @project and 
		studio_pjt_entity = @APSFncSalesTax and
		isnull(@taxRate,0) > 0
GO
