USE [SHOPPER_DEV_APP]
GO
/****** Object:  StoredProcedure [dbo].[xRollupProject_Actuals]    Script Date: 12/16/2015 15:55:39 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
--UPDATED to T-SQL Standard 10/13/2009 JWG & MSB

-- =============================================
-- Author:		Todd
-- Create date: 
-- Description:	Update Project Rollup Tables - Actuals
-- =============================================
CREATE PROCEDURE [dbo].[xRollupProject_Actuals] 
	-- Add the parameters for the stored procedure here
	@batch_id	char(10), 
	@detail_num int,
	@fiscalno	char(6),
	@system_cd	char(2),
	@prog		char(8)		= ' ',
	@user		char(10)	= ' '

AS

BEGIN
-- SET NOCOUNT ON added to prevent extra result sets from
-- interfering with SELECT statements.
SET NOCOUNT ON;
           
BEGIN TRANSACTION

BEGIN TRY

	declare 
		@project	char(16),
		@pjt_entity	char(32),
		@acct		char(16),
		@units		float,
		@amount		float

	select						-- Select the PJTran Record
		@project	= t.project,
		@pjt_entity	= t.pjt_entity,
		@acct		= t.acct,
		@fiscalNo	= @fiscalno,
		@units		= t.units,
		@amount		= t.amount
	from
		dbo.PJTran as t
	where 
		t.batch_id		= @batch_id and
		t.detail_num	= @detail_num and
		@fiscalno		= @fiscalno and
		t.system_cd		= @system_cd

	if (@@ROWCOUNT != 0)		-- A PJTran Record was found. Process the rollups.
	begin

		-- BEGIN: Create/Update PTD Summary & Rollup Records from PJTran Record

		insert PJPTDSum (
			acct,
			act_amount,
			act_units,
			com_amount,
			com_units,
			crtd_datetime,
			crtd_prog,
			crtd_user,
			data1,
			data2,
			data3,
			data4,
			data5,
			eac_amount,
			eac_units,
			fac_amount,
			fac_units,
			lupd_datetime,
			lupd_prog,
			lupd_user,
			noteid,
			pjt_entity,
			project,
			rate,
			total_budget_amount,
			total_budget_units,
			user1,
			user2,
			user3,
			user4)
		select 
			t.acct,							--acct
			cast(0.0 as float) 		as act_amount,		--act_amount
			cast(0.0 as float) 		as act_units,		--act_units
			cast(0.0 as float) 		as com_amount,		--com_amount
			cast(0.0 as float) 		as com_units,		--com_units
			cast(getdate() as smalldatetime) as crtd_datetime,	--crtd_datetime
			@prog 				as crtd_prog,		--crtd_prog
			@user 				as crtd_user,		--crtd_user
			cast(space(16) as char(16)) 	as data1,		--data1
			cast(0.0 as float) 		as data2,		--data2
			cast(0.0 as float) 		as data3,		--data3
			cast(0.0 as float) 		as data4,		--data4
			cast(0.0 as float) 		as data5,		--data5
			cast(0.0 as float) 		as eac_amount,		--eac_amount
			cast(0.0 as float) 		as eac_units,		--eac_units
			cast(0.0 as float) 		as fac_amount,		--fac_amount
			cast(0.0 as float) 		as fac_units,		--fac_units
			cast(getdate() as smalldatetime) as lupd_datetime,	--lupd_datetime
			@prog 				as  lupd_prog,		--lupd_prog
			@user 				as lupd_user,		--lupd_user
			cast(0 as int) 			as noteid,		--noteid
			t.pjt_entity,						--pjt_entity
			t.project,						--project
			cast(0.0 as float) 		as rate,		--rate
			cast(0.0 as float) 		as total_budget_amount,	--total_budget_amount
			cast(0.0 as float) 		as total_budget_units,	--total_budget_units
			cast(space(30) as char(30)) 	as user1,		--user1
			cast(space(30) as char(30)) 	as user2,		--user2
			cast(0.0 as float) 		as user3,		--user3
			cast(0.0 as float) 		as user4		--user4
		from 
			(select @project as project, @pjt_entity as pjt_entity, @acct as acct) as t
				left outer join PJPTDSum as s on 
												t.project		= s.project and 
												t.pjt_entity	= s.pjt_entity and 
												t.acct			= s.acct
		where
			s.project is null


		update s set 
			s.act_amount = s.act_amount + @amount,
			s.act_units = s.act_units + @units,
			lupd_datetime = cast(getdate() as smalldatetime),
			lupd_prog = @prog,
			lupd_user = @user
		from 
			(select @project as project, @pjt_entity as pjt_entity, @acct as acct) as t
				join PJPTDSum as s on t.project = s.project and 
					t.pjt_entity = s.pjt_entity and 
					t.acct = s.acct


		insert PJPTDRol (
			acct,
			act_amount,
			act_units,
			com_amount,
			com_units,
			crtd_datetime,
			crtd_prog,
			crtd_user,
			data1,
			data2,
			data3,
			data4,
			data5,
			eac_amount,
			eac_units,
			fac_amount,
			fac_units,
			lupd_datetime,
			lupd_prog,
			lupd_user,
			project,
			rate,
			total_budget_amount,
			total_budget_units,
			user1,
			user2,
			user3,
			user4)
		select 
			t.acct,							--acct
			cast(0.0 as float) 		as act_amount,		--act_amount
			cast(0.0 as float) 		as act_units,		--act_units
			cast(0.0 as float) 		as com_amount,		--com_amount
			cast(0.0 as float) 		as com_units,		--com_units
			cast(getdate() as smalldatetime) as crtd_datetime,	--crtd_datetime
			@prog 				as crtd_prog,		--crtd_prog
			@user 				as crtd_user,		--crtd_user
			cast(space(16) as char(16)) 	as data1,		--data1
			cast(0.0 as float) 		as data2,		--data2
			cast(0.0 as float) 		as data3,		--data3
			cast(0.0 as float) 		as data4,		--data4
			cast(0.0 as float) 		as data5,		--data5
			cast(0.0 as float) 		as eac_amount,		--eac_amount
			cast(0.0 as float) 		as eac_units,		--eac_units
			cast(0.0 as float) 		as fac_amount,		--fac_amount
			cast(0.0 as float) 		as fac_units,		--fac_units
			cast(getdate() as smalldatetime) as lupd_datetime,	--lupd_datetime
			@prog 				as  lupd_prog,		--lupd_prog
			@user 				as lupd_user,		--lupd_user
			t.project,						--project
			cast(0.0 as float) 		as rate,		--rate
			cast(0.0 as float) 		as total_budget_amount,	--total_budget_amount
			cast(0.0 as float) 		as total_budget_units,	--total_budget_units
			cast(space(30) as char(30)) 	as user1,		--user1
			cast(space(30) as char(30)) 	as user2,		--user2
			cast(0.0 as float) 		as user3,		--user3
			cast(0.0 as float) 		as user4		--user4
		from 
			(select @project as project, @acct as acct) as t
				left outer join PJPTDRol as s on t.project = s.project and 
					t.acct = s.acct
		where
			s.project is null

		update s set 
			s.act_amount = s.act_amount + @amount,
			s.act_units = s.act_units + @units,
			lupd_datetime = cast(getdate() as smalldatetime),
			lupd_prog = @prog,
			lupd_user = @user
		from 
			(select @project as project, @acct as acct) as t
				join PJPTDRol as s on t.project = s.project and 
					t.acct = s.acct

		-- END: Create/Update PTD Summary & Rollup Records from PJTran Record


		-- BEGIN: Create/Update Actual (ACT) Summary & Rollup Records from PJTran Record

		insert PJActSum (
			acct,
			amount_01,
			amount_02,
			amount_03,
			amount_04,
			amount_05,
			amount_06,
			amount_07,
			amount_08,
			amount_09,
			amount_10,
			amount_11,
			amount_12,
			amount_13,
			amount_14,
			amount_15,
			amount_bf,
			crtd_datetime,
			crtd_prog,
			crtd_user,
			data1,
			fsyear_num,
			lupd_datetime,
			lupd_prog,
			lupd_user,
			pjt_entity,
			project,
			units_01,
			units_02,
			units_03,
			units_04,
			units_05,
			units_06,
			units_07,
			units_08,
			units_09,
			units_10,
			units_11,
			units_12,
			units_13,
			units_14,
			units_15,
			units_bf)
		select
			t.acct,						--acct
			cast(0.0 as float) 	as amount_01,		--amount_01
			cast(0.0 as float) 	as amount_02,		--amount_02
			cast(0.0 as float) 	as amount_03,		--amount_03
			cast(0.0 as float) 	as amount_04,		--amount_04
			cast(0.0 as float) 	as amount_05,		--amount_05
			cast(0.0 as float) 	as amount_06,		--amount_06
			cast(0.0 as float) 	as amount_07,		--amount_07
			cast(0.0 as float) 	as amount_08,		--amount_08
			cast(0.0 as float) 	as amount_09,		--amount_09
			cast(0.0 as float) 	as amount_10,		--amount_10
			cast(0.0 as float) 	as amount_11,		--amount_11
			cast(0.0 as float) 	as amount_12,		--amount_12
			cast(0.0 as float) 	as amount_13,		--amount_13
			cast(0.0 as float) 	as amount_14,		--amount_14
			cast(0.0 as float) 	as amount_15,		--amount_15
			cast(0.0 as float) 	as amount_bf,		--amount_bf
			cast(getdate() as smalldatetime) as crtd_datetime,	--crtd_datetime
			@prog 			as crtd_prog,		--crtd_prog
			@user 			as crtd_user,		--crtd_user
			cast(space(16) as char(16)) as data1,		--data1
			left(@fiscalno,4),				--fsyear_num
			cast(getdate() as smalldatetime) as lupd_datetime,	--lupd_datetime
			@prog 			as  lupd_prog,		--lupd_prog
			@user 			as lupd_user,		--lupd_user
			t.pjt_entity,					--pjt_entity
			t.project,					--project
			cast(0.0 as float) 	as units_01,		--units_01
			cast(0.0 as float) 	as units_02,		--units_02
			cast(0.0 as float) 	as units_03,		--units_03
			cast(0.0 as float) 	as units_04,		--units_04
			cast(0.0 as float) 	as units_05,		--units_05
			cast(0.0 as float) 	as units_06,		--units_06
			cast(0.0 as float) 	as units_07,		--units_07
			cast(0.0 as float) 	as units_08,		--units_08
			cast(0.0 as float) 	as units_09,		--units_09
			cast(0.0 as float) 	as units_10,		--units_10
			cast(0.0 as float) 	as units_11,		--units_11
			cast(0.0 as float) 	as units_12,		--units_12
			cast(0.0 as float) 	as units_13,		--units_13
			cast(0.0 as float) 	as units_14,		--units_14
			cast(0.0 as float) 	as units_15,		--units_15
			cast(0.0 as float) 	as units_bf		--units_bf
		from 
			(select @project as project, @pjt_entity as pjt_entity, @acct as acct) as t
				left outer join PJActSum as s on t.project = s.project and 
					t.pjt_entity = s.pjt_entity and 
					t.acct = s.acct and
					left(@fiscalno,4) = s.fsyear_num
		where
			s.project is null

		update s set 
			amount_01 = case when substring(@fiscalno,5,2) = '01' then (amount_01 + @amount) else amount_01 end,
			amount_02 = case when substring(@fiscalno,5,2) = '02' then (amount_02 + @amount) else amount_02 end,
			amount_03 = case when substring(@fiscalno,5,2) = '03' then (amount_03 + @amount) else amount_03 end,
			amount_04 = case when substring(@fiscalno,5,2) = '04' then (amount_04 + @amount) else amount_04 end,
			amount_05 = case when substring(@fiscalno,5,2) = '05' then (amount_05 + @amount) else amount_05 end,
			amount_06 = case when substring(@fiscalno,5,2) = '06' then (amount_06 + @amount) else amount_06 end,
			amount_07 = case when substring(@fiscalno,5,2) = '07' then (amount_07 + @amount) else amount_07 end,
			amount_08 = case when substring(@fiscalno,5,2) = '08' then (amount_08 + @amount) else amount_08 end,
			amount_09 = case when substring(@fiscalno,5,2) = '09' then (amount_09 + @amount) else amount_09 end,
			amount_10 = case when substring(@fiscalno,5,2) = '10' then (amount_10 + @amount) else amount_10 end,
			amount_11 = case when substring(@fiscalno,5,2) = '11' then (amount_11 + @amount) else amount_11 end,
			amount_12 = case when substring(@fiscalno,5,2) = '12' then (amount_12 + @amount) else amount_12 end,
			amount_13 = case when substring(@fiscalno,5,2) = '13' then (amount_13 + @amount) else amount_13 end,
			amount_14 = case when substring(@fiscalno,5,2) = '14' then (amount_14 + @amount) else amount_14 end,
			amount_15 = case when substring(@fiscalno,5,2) = '15' then (amount_15 + @amount) else amount_15 end,
			units_01 = case when substring(@fiscalno,5,2) = '01' then (units_01 + @units) else units_01 end,
			units_02 = case when substring(@fiscalno,5,2) = '02' then (units_02 + @units) else units_02 end,
			units_03 = case when substring(@fiscalno,5,2) = '03' then (units_03 + @units) else units_03 end,
			units_04 = case when substring(@fiscalno,5,2) = '04' then (units_04 + @units) else units_04 end,
			units_05 = case when substring(@fiscalno,5,2) = '05' then (units_05 + @units) else units_05 end,
			units_06 = case when substring(@fiscalno,5,2) = '06' then (units_06 + @units) else units_06 end,
			units_07 = case when substring(@fiscalno,5,2) = '07' then (units_07 + @units) else units_07 end,
			units_08 = case when substring(@fiscalno,5,2) = '08' then (units_08 + @units) else units_08 end,
			units_09 = case when substring(@fiscalno,5,2) = '09' then (units_09 + @units) else units_09 end,
			units_10 = case when substring(@fiscalno,5,2) = '10' then (units_10 + @units) else units_10 end,
			units_11 = case when substring(@fiscalno,5,2) = '11' then (units_11 + @units) else units_11 end,
			units_12 = case when substring(@fiscalno,5,2) = '12' then (units_12 + @units) else units_12 end,
			units_13 = case when substring(@fiscalno,5,2) = '13' then (units_13 + @units) else units_13 end,
			units_14 = case when substring(@fiscalno,5,2) = '14' then (units_14 + @units) else units_14 end,
			units_15 = case when substring(@fiscalno,5,2) = '15' then (units_15 + @units) else units_15 end,
			lupd_datetime = cast(getdate() as smalldatetime),
			lupd_prog = @prog,
			lupd_user = @user
		from 
			(select @project as project, @pjt_entity as pjt_entity, @acct as acct, @fiscalno as fiscalno) as t
				join PJActSum as s on t.project = s.project and 
					t.pjt_entity = s.pjt_entity and 
					t.acct = s.acct and
					left(@fiscalno,4) = s.fsyear_num

		insert PJActRol (
			acct,
			amount_01,
			amount_02,
			amount_03,
			amount_04,
			amount_05,
			amount_06,
			amount_07,
			amount_08,
			amount_09,
			amount_10,
			amount_11,
			amount_12,
			amount_13,
			amount_14,
			amount_15,
			amount_bf,
			crtd_datetime,
			crtd_prog,
			crtd_user,
			data1,
			fsyear_num,
			lupd_datetime,
			lupd_prog,
			lupd_user,
			project,
			units_01,
			units_02,
			units_03,
			units_04,
			units_05,
			units_06,
			units_07,
			units_08,
			units_09,
			units_10,
			units_11,
			units_12,
			units_13,
			units_14,
			units_15,
			units_bf)
		select 
			t.acct,						--acct
			cast(0.0 as float) 	as amount_01,		--amount_01
			cast(0.0 as float) 	as amount_02,		--amount_02
			cast(0.0 as float) 	as amount_03,		--amount_03
			cast(0.0 as float) 	as amount_04,		--amount_04
			cast(0.0 as float) 	as amount_05,		--amount_05
			cast(0.0 as float) 	as amount_06,		--amount_06
			cast(0.0 as float) 	as amount_07,		--amount_07
			cast(0.0 as float) 	as amount_08,		--amount_08
			cast(0.0 as float) 	as amount_09,		--amount_09
			cast(0.0 as float) 	as amount_10,		--amount_10
			cast(0.0 as float) 	as amount_11,		--amount_11
			cast(0.0 as float) 	as amount_12,		--amount_12
			cast(0.0 as float) 	as amount_13,		--amount_13
			cast(0.0 as float) 	as amount_14,		--amount_14
			cast(0.0 as float) 	as amount_15,		--amount_15
			cast(0.0 as float) 	as amount_bf,		--amount_bf
			cast(getdate() as smalldatetime) as crtd_datetime,	--crtd_datetime
			@prog 			as crtd_prog,		--crtd_prog
			@user 			as crtd_user,		--crtd_user
			cast(space(16) as char(16)) as data1,		--data1
			left(@fiscalno,4),				--fsyear_num
			cast(getdate() as smalldatetime) as lupd_datetime,	--lupd_datetime
			@prog 			as  lupd_prog,		--lupd_prog
			@user 			as lupd_user,		--lupd_user
			t.project,					--project
			cast(0.0 as float) 	as units_01,		--units_01
			cast(0.0 as float) 	as units_02,		--units_02
			cast(0.0 as float) 	as units_03,		--units_03
			cast(0.0 as float) 	as units_04,		--units_04
			cast(0.0 as float) 	as units_05,		--units_05
			cast(0.0 as float) 	as units_06,		--units_06
			cast(0.0 as float) 	as units_07,		--units_07
			cast(0.0 as float) 	as units_08,		--units_08
			cast(0.0 as float) 	as units_09,		--units_09
			cast(0.0 as float) 	as units_10,		--units_10
			cast(0.0 as float) 	as units_11,		--units_11
			cast(0.0 as float) 	as units_12,		--units_12
			cast(0.0 as float) 	as units_13,		--units_13
			cast(0.0 as float) 	as units_14,		--units_14
			cast(0.0 as float) 	as units_15,		--units_15
			cast(0.0 as float) 	as units_bf		--units_bf
		from 
			(select @project as project, @acct as acct, @fiscalno as fiscalno) as t
				left outer join PJActRol as s on t.project = s.project and 
					t.acct = s.acct and
					left(@fiscalno,4) = s.fsyear_num			
		where
			s.project is null


		update s set 
			amount_01 = case when substring(@fiscalno,5,2) = '01' then (amount_01 + @amount) else amount_01 end,
			amount_02 = case when substring(@fiscalno,5,2) = '02' then (amount_02 + @amount) else amount_02 end,
			amount_03 = case when substring(@fiscalno,5,2) = '03' then (amount_03 + @amount) else amount_03 end,
			amount_04 = case when substring(@fiscalno,5,2) = '04' then (amount_04 + @amount) else amount_04 end,
			amount_05 = case when substring(@fiscalno,5,2) = '05' then (amount_05 + @amount) else amount_05 end,
			amount_06 = case when substring(@fiscalno,5,2) = '06' then (amount_06 + @amount) else amount_06 end,
			amount_07 = case when substring(@fiscalno,5,2) = '07' then (amount_07 + @amount) else amount_07 end,
			amount_08 = case when substring(@fiscalno,5,2) = '08' then (amount_08 + @amount) else amount_08 end,
			amount_09 = case when substring(@fiscalno,5,2) = '09' then (amount_09 + @amount) else amount_09 end,
			amount_10 = case when substring(@fiscalno,5,2) = '10' then (amount_10 + @amount) else amount_10 end,
			amount_11 = case when substring(@fiscalno,5,2) = '11' then (amount_11 + @amount) else amount_11 end,
			amount_12 = case when substring(@fiscalno,5,2) = '12' then (amount_12 + @amount) else amount_12 end,
			amount_13 = case when substring(@fiscalno,5,2) = '13' then (amount_13 + @amount) else amount_13 end,
			amount_14 = case when substring(@fiscalno,5,2) = '14' then (amount_14 + @amount) else amount_14 end,
			amount_15 = case when substring(@fiscalno,5,2) = '15' then (amount_15 + @amount) else amount_15 end,
			units_01 = case when substring(@fiscalno,5,2) = '01' then (units_01 + @units) else units_01 end,
			units_02 = case when substring(@fiscalno,5,2) = '02' then (units_02 + @units) else units_02 end,
			units_03 = case when substring(@fiscalno,5,2) = '03' then (units_03 + @units) else units_03 end,
			units_04 = case when substring(@fiscalno,5,2) = '04' then (units_04 + @units) else units_04 end,
			units_05 = case when substring(@fiscalno,5,2) = '05' then (units_05 + @units) else units_05 end,
			units_06 = case when substring(@fiscalno,5,2) = '06' then (units_06 + @units) else units_06 end,
			units_07 = case when substring(@fiscalno,5,2) = '07' then (units_07 + @units) else units_07 end,
			units_08 = case when substring(@fiscalno,5,2) = '08' then (units_08 + @units) else units_08 end,
			units_09 = case when substring(@fiscalno,5,2) = '09' then (units_09 + @units) else units_09 end,
			units_10 = case when substring(@fiscalno,5,2) = '10' then (units_10 + @units) else units_10 end,
			units_11 = case when substring(@fiscalno,5,2) = '11' then (units_11 + @units) else units_11 end,
			units_12 = case when substring(@fiscalno,5,2) = '12' then (units_12 + @units) else units_12 end,
			units_13 = case when substring(@fiscalno,5,2) = '13' then (units_13 + @units) else units_13 end,
			units_14 = case when substring(@fiscalno,5,2) = '14' then (units_14 + @units) else units_14 end,
			units_15 = case when substring(@fiscalno,5,2) = '15' then (units_15 + @units) else units_15 end,
			lupd_datetime = cast(getdate() as smalldatetime),
			lupd_prog = @prog,
			lupd_user = @user
		from 
			(select @project as project, @acct as acct, @fiscalno as fiscalno) as t
				left outer join PJActRol as s on t.project = s.project and 
					t.acct = s.acct and
					left(@fiscalno,4) = s.fsyear_num

		-- END: Create/Update Actual (ACT) Summary & Rollup Records from PJTran Record

	end	-- if(@@ROWCOUNT)

END TRY

BEGIN CATCH

IF @@TRANCOUNT > 0
ROLLBACK

DECLARE @ErrorNumberA int
DECLARE @ErrorSeverityA int
DECLARE @ErrorStateA varchar(255)
DECLARE @ErrorProcedureA varchar(255)
DECLARE @ErrorLineA int
DECLARE @ErrorMessageA varchar(max)
DECLARE @ErrorDateA smalldatetime
DECLARE @UserNameA varchar(50)
DECLARE @ErrorAppA varchar(50)
DECLARE @UserMachineName varchar(50)

SET @ErrorNumberA = Error_number()
SET @ErrorSeverityA = Error_severity()
SET @ErrorStateA = Error_state()
SET @ErrorProcedureA = Error_procedure()
SET @ErrorLineA = Error_line()
SET @ErrorMessageA = Error_message()
SET @ErrorDateA = GetDate()
SET @UserNameA = suser_sname() 
SET @ErrorAppA = app_name()
SET @UserMachineName = host_name()

EXEC dbo.xLogErrorandEmail @ErrorNumberA, @ErrorSeverityA, @ErrorStateA , @ErrorProcedureA, @ErrorLineA, @ErrorMessageA
, @ErrorDateA, @UserNameA, @ErrorAppA, @UserMachineName

END CATCH


IF @@TRANCOUNT > 0
COMMIT TRANSACTION

END
GO
