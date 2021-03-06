USE [MIDWESTAPP]
GO
/****** Object:  StoredProcedure [dbo].[xtmpAPSXfer_LoadAgency]    Script Date: 12/21/2015 15:55:50 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[xtmpAPSXfer_LoadAgency] 

			@project char(16),
			@prog char(8),
			@user char(10)
AS

set nocount on

declare @tmpUser	char(10),
		@APSFncSalesTax	char(30),
		@APSFncValueAdd	char(30),
		@APSFncDiscount	char(30),
		@totalBill	float,
		@salesTax	float,
		@valueAdd	float,
		@discount	float

	select top 1
		@tmpUser = crtd_user
	from
		xtmpAPSXfer
	where 
		studio_project = @project

	if @tmpUser != @user
		return 0

	select 	@APSFncSalesTax = control_data	-- 99999
						from PJContrl with (nolock, fastfirstrow) where control_type = 'IG' and control_code = 'APSSLSTXFUN'

	select 	@APSFncValueAdd = control_data	-- 99990 
						from PJContrl with (nolock, fastfirstrow) where control_type = 'IG' and control_code = 'APSVALADDFUN'

	select 	@APSFncDiscount = control_data 
						from PJContrl with (nolock, fastfirstrow) where control_type = 'IG' and control_code = 'APSDISCFUN'

	begin transaction

	delete from xtmpAPSXferAgency
		where studio_project = @project


/* load agency info */


	insert xtmpAPSXFerAgency(
		agency_pjt_entity,
		agency_entityDesc,
		agency_project, 
		crtd_datetime,
		crtd_prog,
		crtd_user,
		studio_project,
		xfer_amount)
	select
		at.pjt_entity, 
		at.pjt_entity_desc, 
		at.project,
		cast(getdate() as smalldatetime),
		@prog,
		@user,
		x.studio_project,
		round(sum(x.bill_amount),2) as xfer_amount
	from 
		xtmpAPSXfer as x
			join pjproj as s on x.studio_project = s.project
			join pjproj as a on s.pm_id34 = a.project
			join xigfunctioncode as f on x.studio_pjt_entity = f.code_id
				left outer join pjpent as at on a.project = at.project and f.user05 = at.pjt_entity
	where 
		x.studio_project = @project and
		rtrim(x.studio_pjt_entity) != rtrim(@APSFncSalesTax) and
		rtrim(x.studio_pjt_entity) != rtrim(@APSFncValueAdd) and
		rtrim(x.studio_pjt_entity) != rtrim(@APSFncDiscount)
	group by
		at.pjt_entity, at.pjt_entity_desc, at.project,
		x.studio_project

-- Update Studio Tax before allocating to Agency Functions


	exec xtmpAPSXfer_UpdateStudioTax @project, @prog, @user

	select
		@salesTax = 0.0,
		@valueAdd = 0.0,
		@discount = 0.0

	select
		@salesTax = case when studio_pjt_entity = @APSFncSalesTax then bill_amount else @salesTax end,
		@valueAdd = case when studio_pjt_entity = @APSFncValueAdd then bill_amount else @valueAdd end,
		@discount = case when studio_pjt_entity = @APSFncDiscount then bill_amount else @discount end
	from
		xtmpAPSXFer
	where
		studio_project = @project

	select 
		@totalBill = round(sum(xfer_amount),2) 
	from 
		xtmpAPSXFerAgency
	where 
		studio_project = @project 


	if (@totalBill != 0.0)
	begin
		update xtmpAPSXFerAgency set 
			salesTax_amount = round(((xfer_amount/@totalBill) * @salesTax),2),
			valueAdd_amount = round(((xfer_amount/@totalBill) * @valueAdd),2),
			discount_amount = round(((xfer_amount/@totalBill) * @discount),2)
		from 
			xtmpAPSXFerAgency
		where 
			studio_project = @project 
	end

	update xtmpAPSXFerAgency set 
		totalXFer_amount = round((xfer_amount + salesTax_amount + valueAdd_amount + discount_amount),2)
	from 
		xtmpAPSXFerAgency
	where 
		studio_project = @project 

	commit transaction
GO
