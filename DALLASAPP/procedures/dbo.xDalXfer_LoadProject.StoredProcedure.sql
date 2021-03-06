USE [DALLASAPP]
GO
/****** Object:  StoredProcedure [dbo].[xDalXfer_LoadProject]    Script Date: 12/21/2015 13:45:12 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[xDalXfer_LoadProject] 

			@project char(16),
			@prog char(8),
			@user char(10),
			@billType smallint,
			@reversal smallint,
			@procOpt smallint
AS

set nocount on

declare @tmpUser	char(10),
		@STINBTD		char(16),
		@STINREVIA		char(16),	--CGS/PS 02/14/07 Modified from STINREV to STINREVIA
		@STINREVST		char(16),	--CGS/PS 02/14/07 Added STINREVST
		@STINAGYCOS	char(16),
		@STINCOSIA		char(16),	--CGS/PS 02/14/07 Modified from STINCOS to STINCOSIA
		@STINCOSST		char(16),	--CGS/PS 02/14/07 Added STINCOSST
		@STINWIPIA		char(16),	--CGS/PS 02/14/07 Modified from STINWIP to STINWIPIA
		@STINWIPST		char(16),	--CGS/PS 02/14/07 Added STINWIPST
		@STINRECOVER	char(16),
		@STINWIPGL	char(16),
		@PRODWIPGL	char(16),
		@STINREVGL	char(16),
		@STINCOSGL	char(16),
		@STINFncValueAdd	char(30),
		@STINFncDiscount	char(30),
		@agencyCust		char(15)
/*
		@taxRate float,
		@STINFncSalesTax	char(30),
		@taxDate as smalldatetime
*/

	select top 1
		@tmpUser = crtd_user
	from
		xDalXfer
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
 
/*
	set @taxDate = getdate()

	select @taxRate = 	 sum(taxRate) from dbo.xFncTaxPosting(@agencyCust, @taxDate)
	
	select @taxRate = @taxRate * .01
*/

	select 	@STINBTD = control_data 
						from PJContrl with (nolock, fastfirstrow) where control_type = 'IG' and control_code = 'STINBTD'

	select 	@STINREVIA = control_data -- CGS/PS 02/14/07 Modified from STINREV to STINREVIA
						from PJContrl with (nolock, fastfirstrow) where control_type = 'IG' and control_code = 'STINREVIA'	

	select 	@STINREVST = control_data -- CGS/PS 02/14/07 Added STINREVST
						from PJContrl with (nolock, fastfirstrow) where control_type = 'IG' and control_code = 'STINREVST'	

	select 	@STINAGYCOS = control_data 
						from PJContrl with (nolock, fastfirstrow) where control_type = 'IG' and control_code = 'STINAGYCOS'

	select 	@STINCOSIA = control_data -- CGS/PS 02/14/07 Modified from STINCOS to STINCOSIA
						from PJContrl with (nolock, fastfirstrow) where control_type = 'IG' and control_code = 'STINCOSIA'

	select 	@STINCOSST = control_data -- CGS/PS 02/14/07 Added STINCOSST
						from PJContrl with (nolock, fastfirstrow) where control_type = 'IG' and control_code = 'STINCOSST'

	select 	@STINWIPIA = control_data -- CGS/PS 02/14/07 Modified from STINWIP to STINWIPIA
						from PJContrl with (nolock, fastfirstrow) where control_type = 'IG' and control_code = 'STINWIPIA'

	select 	@STINWIPST = control_data -- CGS/PS 02/14/07 Added STINWIPST
						from PJContrl with (nolock, fastfirstrow) where control_type = 'IG' and control_code = 'STINWIPST'

	select 	@STINRECOVER = control_data 
						from PJContrl with (nolock, fastfirstrow) where control_type = 'IG' and control_code = 'STINRECOVER'

	select 	@STINWIPGL = control_data 
						from PJContrl with (nolock, fastfirstrow) where control_type = 'IG' and control_code = 'STINWIPGL'

	select 	@PRODWIPGL = control_data 
						from PJContrl with (nolock, fastfirstrow) where control_type = 'IG' and control_code = 'PRODWIPGL'

	select 	@STINREVGL = control_data 
						from PJContrl with (nolock, fastfirstrow) where control_type = 'IG' and control_code = 'STINREVGL'

	select 	@STINCOSGL = control_data 
						from PJContrl with (nolock, fastfirstrow) where control_type = 'IG' and control_code = 'STINCOSGL'

/*
	select 	@STINFncSalesTax = control_data	-- 99999
						from PJContrl with (nolock, fastfirstrow) where control_type = 'IG' and control_code = 'STINSLSTXFUN'

	select 	@STINFncValueAdd = control_data	-- 99990 
						from PJContrl with (nolock, fastfirstrow) where control_type = 'IG' and control_code = 'STINVALADDFUN'

	select 	@STINFncDiscount = control_data 
						from PJContrl with (nolock, fastfirstrow) where control_type = 'IG' and control_code = 'STINDISCFUN'
*/

	begin transaction

	delete from xDalXfer
		where studio_project = @project

	delete from xDalXferAgency
		where studio_project = @project

	insert xDalXfer(
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
			s.eac_amount != 0 ) and
		(a.ca_id05 = 'AC')
	group by 
		s.project,
		s.pjt_entity,
		t.pjt_entity_desc


/*
	if (@agencyCust in (select code_value from pjcode where code_type = '9int'))
	begin
		delete from xDalXfer where studio_project = @project and studio_pjt_entity = @STINFncSalesTax
		set @taxRate = 0.0
		set @STINFncSalesTax = ' '
	end
*/


	-- udpate btd amount  (DON'T SUM BTD FOR TESTING PURPOSES ONLY)
	update xDalXfer
		set btd_amount = (select isnull(sum(PTD.act_amount),0.0)
					from PJPTDSum PTD
					where	PTD.project = xDalXfer.studio_project and
						PTD.pjt_entity = xDalXfer.studio_pjt_entity and
						PTD.acct = @STINBTD)
	where 
		studio_project = @project

	-- udpate recovery amount
	/*	CGS/PS 02/14/07 Moved recover_amount calculation to update line item totals
	update xDalXfer
		set recover_amount = (select isnull(sum(PTD.act_amount),0.0)
					from PJPTDSum PTD
					where	PTD.project = xDalXfer.studio_project and
						PTD.pjt_entity = xDalXfer.studio_pjt_entity and
						PTD.acct = @STINRECOVER)
	where 
		studio_project = @project
	*/

	-- udpate cos amount	CGS/PS 02/14/07 Updated for IA & ST
	update xDalXfer
		set cos_amount = (select isnull(sum(PTD.act_amount),0.0)
					from PJPTDSum PTD
					where	PTD.project = xDalXfer.studio_project and
						PTD.pjt_entity = xDalXfer.studio_pjt_entity and
						(PTD.acct = @STINCOSIA or PTD.acct = @STINCOSST))
	where 
		studio_project = @project

	-- udpate rev amount	CGS/PS 02/14/07 Updated for IA & ST
	update xDalXfer
		set rev_amount = (select isnull(sum(PTD.act_amount),0.0)
					from PJPTDSum PTD
					where	PTD.project = xDalXfer.studio_project and
						PTD.pjt_entity = xDalXfer.studio_pjt_entity and
						(PTD.acct = @STINREVIA or PTD.acct = @STINREVST))
	where 
		studio_project = @project

	-- udpate wip amount	CGS/PS 02/14/07 Updated for IA & ST
	update xDalXfer
		set wip_amount = (select isnull(sum(PTD.act_amount),0.0)
					from PJPTDSum PTD
					where	PTD.project = xDalXfer.studio_project and
						PTD.pjt_entity = xDalXfer.studio_pjt_entity and
						(PTD.acct = @STINWIPIA or PTD.acct = @STINWIPST))
	where 
		studio_project = @project
	
	-- Update Line Item Totals
	update xDalXfer
		set var_amount = est_amount - act_amount,
			rem_amount =
					case 
						when @billType != 0 and @reversal = 0 and @procOpt !=0 then est_amount - btd_amount
						when @billType = 0 and @reversal = 0 and @procOpt !=0 then act_amount - btd_amount
						when @billType = 0 and @reversal = 0 and @procOpt =0 then 0.0 --CGS/PS 04/05/07 Force billable to 0.00 when closing job --act_amount - btd_amount 
						when @reversal <> 0 then btd_amount * (-1)
					else 0 end,
			bill_amount =
					case 
						when @billType != 0 and @reversal = 0 and @procOpt !=0 then est_amount - btd_amount
						when @billType = 0 and @reversal = 0 and @procOpt !=0 then act_amount - btd_amount
						when @billType = 0 and @reversal = 0 and @procOpt =0 then 0.0 --CGS/PS 04/05/07 Force billable to 0.00 when closing job --act_amount - btd_amount 
						when @reversal <> 0 then btd_amount * (-1)
					else 0 end,
			recover_amount = 
					case
						when @reversal <> 0 then cos_amount * (-1)
					else wip_amount - cos_amount end
	where 
		studio_project = @project
	
/*
	-- Update Sales Tax Line Item

	update xDalXfer
		set bill_amount = (select
							sum(bill_amount * @taxRate ) 
							from 
								xDalXfer
							where 
								studio_project = @project and 
								studio_pjt_entity != @STINFncSalesTax)
	where 
		studio_project = @project and 
		studio_pjt_entity = @STINFncSalesTax and
		@taxRate > 0
*/

	-- DONT POPULATE AGENCY TABLE AT THIS TIME

	commit transaction
GO
