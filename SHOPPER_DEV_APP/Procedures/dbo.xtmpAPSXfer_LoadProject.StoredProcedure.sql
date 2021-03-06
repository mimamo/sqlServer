USE [SHOPPER_DEV_APP]
GO
/****** Object:  StoredProcedure [dbo].[xtmpAPSXfer_LoadProject]    Script Date: 12/21/2015 14:34:46 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[xtmpAPSXfer_LoadProject] 

			@project char(16),
			@prog char(8),
			@user char(10)
AS
set nocount on

declare @tmpUser	char(10),
		@APSBTD		char(16),
		@APSREV		char(16),
		@APSAGYCOS	char(16),
		@APSCOS		char(16),
		@APSWIP		char(16),
		@APSRECOVER	char(16),
		@APSWIPGL	char(16),
		@PRODWIPGL	char(16),
		@APSREVGL	char(16),
		@APSCOSGL	char(16),
		@APSFncSalesTax	char(30),
		@APSFncValueAdd	char(30),
		@APSFncDiscount	char(30),
		@agencyCust		char(15),
		@taxRate float,
		@taxDate as smalldatetime

	select top 1
		@tmpUser = crtd_user
	from
		xtmpAPSXfer
	where 
		studio_project = @project

	if @tmpUser != @user
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

	select 	@APSBTD = control_data 
						from PJContrl with (nolock, fastfirstrow) where control_type = 'IG' and control_code = 'APSBTD'

	select 	@APSREV = control_data 
						from PJContrl with (nolock, fastfirstrow) where control_type = 'IG' and control_code = 'APSREV'

	select 	@APSAGYCOS = control_data 
						from PJContrl with (nolock, fastfirstrow) where control_type = 'IG' and control_code = 'APSAGYCOS'

	select 	@APSCOS = control_data 
						from PJContrl with (nolock, fastfirstrow) where control_type = 'IG' and control_code = 'APSCOS'

	select 	@APSWIP = control_data 
						from PJContrl with (nolock, fastfirstrow) where control_type = 'IG' and control_code = 'APSWIP'

	select 	@APSRECOVER = control_data 
						from PJContrl with (nolock, fastfirstrow) where control_type = 'IG' and control_code = 'APSRECOVER'

	select 	@APSWIPGL = control_data 
						from PJContrl with (nolock, fastfirstrow) where control_type = 'IG' and control_code = 'APSWIPGL'

	select 	@PRODWIPGL = control_data 
						from PJContrl with (nolock, fastfirstrow) where control_type = 'IG' and control_code = 'PRODWIPGL'

	select 	@APSREVGL = control_data 
						from PJContrl with (nolock, fastfirstrow) where control_type = 'IG' and control_code = 'APSREVGL'

	select 	@APSCOSGL = control_data 
						from PJContrl with (nolock, fastfirstrow) where control_type = 'IG' and control_code = 'APSCOSGL'

	select 	@APSFncSalesTax = control_data	-- 99999
						from PJContrl with (nolock, fastfirstrow) where control_type = 'IG' and control_code = 'APSSLSTXFUN'

	select 	@APSFncValueAdd = control_data	-- 99990 
						from PJContrl with (nolock, fastfirstrow) where control_type = 'IG' and control_code = 'APSVALADDFUN'

	select 	@APSFncDiscount = control_data 
						from PJContrl with (nolock, fastfirstrow) where control_type = 'IG' and control_code = 'APSDISCFUN'

BEGIN TRANSACTION

BEGIN TRY --added TRY...CATCH logic to conform to new coding standard 02/25/2009 -mbrady

	delete from xtmpAPSXfer
		where studio_project = @project

	delete from xtmpAPSXferAgency
		where studio_project = @project

	insert xtmpAPSXfer(
		act_amount,
		crtd_datetime,
		crtd_prog,
		crtd_user,
		est_amount, 
		studio_pjt_entity,
		studio_entityDesc,
		studio_project)
	select 
		sum(s.act_amount),
		getdate(),
		@prog,
		@user,
		sum(s.eac_amount),
		s.pjt_entity,
		t.pjt_entity_desc,
		s.project
	from
		PJPTDSum as s 
			join PJAcct as a on s.acct = a.acct
			join PJPent as t on s.project = t.project and s.pjt_entity = t.pjt_entity
	where
		s.project = @project and
		(s.act_amount != 0 or
			s.eac_amount != 0 or
			left(s.pjt_entity,4) = '9999') and
		(a.ca_id05 = 'Y'	or
			a.acct in ('ESTIMATE','ESTIMATE TAX'))
	group by 
		s.project,
		s.pjt_entity,
		t.pjt_entity_desc


	if (@agencyCust in (select code_value from pjcode where code_type = '9int'))
	begin
		delete from xtmpAPSXfer where studio_project = @project and studio_pjt_entity = @APSFncSalesTax
		set @taxRate = 0.0
		set @APSFncSalesTax = ' '
	end


	-- udpate btd amount  (DON'T SUM BTD FOR TESTING PURPOSES ONLY)
	update xtmpAPSXfer
		set btd_amount = (select isnull(sum(PTD.act_amount),0.0)
					from PJPTDSum PTD
					where	PTD.project = xtmpAPSXfer.studio_project and
						PTD.pjt_entity = xtmpAPSXfer.studio_pjt_entity and
						PTD.acct = @APSBTD)
	where 
		studio_project = @project



-- When an estimate is removed or is zeroed out, there is no line item to update.
-- The 2 queries above excludes the 0 because of the full load of function codes.
-- must insert a record to show up appropriately.
-- apatten on 9/19/2008

-- validated 02/25/2009 -mbrady 

INSERT INTO xtmpAPSXfer
              (act_amount
			, crtd_datetime
			, crtd_prog
			, crtd_user
			, est_amount
			, Studio_pjt_entity
			, Studio_entityDesc
			, Studio_project
			, btd_amount)
SELECT     '0.00' 
			, GETDATE()
			, @prog
			, @user
			, '0.00' 
			, PTD.pjt_entity
			, a.descr
			, PTD.project
			, SUM(PTD.act_amount)
FROM         PJPTDSUM AS PTD INNER JOIN xIGFunctionCode AS a ON PTD.pjt_entity = a.code_ID 
			LEFT OUTER JOIN  xtmpAPSXfer ON PTD.pjt_entity = xtmpAPSXfer.Studio_pjt_entity AND PTD.project = xtmpAPSXfer.Studio_project
WHERE     (xtmpAPSXfer.Studio_pjt_entity IS NULL) 
		AND (PTD.Project = @project)
		AND (PTD.act_amount <> '0')
		AND (acct = 'APS BTD')
GROUP BY PTD.pjt_entity, a.descr, PTD.project




	-- udpate recovery amount
	update xtmpAPSXfer
		set recover_amount = (select isnull(sum(PTD.act_amount),0.0)
					from PJPTDSum PTD
					where	PTD.project = xtmpAPSXfer.studio_project and
						PTD.pjt_entity = xtmpAPSXfer.studio_pjt_entity and
						PTD.acct = @APSRECOVER)
	where 
		studio_project = @project

	-- udpate cos amount
	update xtmpAPSXfer
		set cos_amount = (select isnull(sum(PTD.act_amount),0.0)
					from PJPTDSum PTD
					where	PTD.project = xtmpAPSXfer.studio_project and
						PTD.pjt_entity = xtmpAPSXfer.studio_pjt_entity and
						PTD.acct = @APSCOS)
	where 
		studio_project = @project
	
	-- Update Line Item Totals
	update xtmpAPSXfer
		set var_amount = est_amount - act_amount,
			rem_amount = est_amount - btd_amount,
			bill_amount = est_amount - btd_amount
	where 
		studio_project = @project
	
	-- Update Sales Tax Line Item
	update xtmpAPSXfer
		set bill_amount = (select
							sum(bill_amount * @taxRate ) 
							from 
								xtmpAPSXfer
							where 
								studio_project = @project and 
								studio_pjt_entity != @APSFncSalesTax)
	where 
		studio_project = @project and 
		studio_pjt_entity = @APSFncSalesTax and
		@taxRate > 0


	-- DONT POPULATE AGENCY TABLE AT THIS TIME
END TRY

BEGIN CATCH
IF @@TRANCOUNT > 0
ROLLBACK TRANSACTION

END CATCH

IF @@TRANCOUNT > 0
COMMIT TRANSACTION
GO
