USE [DALLASAPP]
GO
/****** Object:  StoredProcedure [dbo].[xIDEN_APSProjectCreate]    Script Date: 12/21/2015 13:45:13 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author:		<Author,,Michael Petersen>
-- Create date: <Create Date,,7/11/2006>
-- Description:	<Description,,Create APS Project from Main Project screen>
-- Modified:    <Author,,Delmer Johnson>
-- Modify Date: <Modify Date,,6/9/2010>
-- Description  <Description,,Add new columns for SL 70FP1 and only put first 10 char of @user into Crtd_User, etc.>
-- Modified:     Dan Bertram
-- Modify Date:  4/26/2012
-- Description:  Description,,Added the pm_id05 field to the PJPROJ insert so that this field is populated on the APS job.
-- =============================================
CREATE PROCEDURE [dbo].[xIDEN_APSProjectCreate] 
	@Project varchar(16), @user varchar(30)
AS
BEGIN
	DECLARE @Result int

	IF NOT EXISTS (SELECT * FROM PJPROJ, (SELECT * FROM	PJCONTRL WHERE Control_Code = 'APSJOBSETUP') PC WHERE Project = LEFT(@Project, 8) + RTRIM(LEFT(PC.Control_data, 10)))
		BEGIN
			SET @Result = 0
			INSERT INTO [PJPROJ]
				   ([alloc_method_cd]
				   ,[BaseCuryId]
				   ,[bf_values_switch]
				   ,[billcuryfixedrate]
				   ,[billcuryid]
				   ,[billing_setup] -- Added for SL 7.0 FP1 IronWare
				   ,[billratetypeid]
				   ,[budget_version]
				   ,[budget_type] -- Added for SL 7.0 FP1 IronWare
				   ,[contract]
				   ,[contract_type]
				   ,[CpnyId]
				   ,[crtd_datetime]
				   ,[crtd_prog]
				   ,[crtd_user]
				   ,[CuryId]
				   ,[CuryRateType]
				   ,[customer]
				   ,[end_date]
				   ,[gl_subacct]
				   ,[labor_gl_acct]
				   ,[lupd_datetime]
				   ,[lupd_prog]
				   ,[lupd_user]
				   ,[manager1]
				   ,[manager2]
				   ,[MSPData]
				   ,[MSPInterface]
				   ,[MSPProj_ID]
				   ,[noteid]
				   ,[opportunityID]
				   ,[pm_id01]
				   ,[pm_id02]
				   ,[pm_id03]
				   ,[pm_id04]
				   ,[pm_id05]
				   ,[pm_id06]
				   ,[pm_id07]
				   ,[pm_id08]
				   ,[pm_id09]
				   ,[pm_id10]
				   ,[pm_id31]
				   ,[pm_id32]
				   ,[pm_id33]
				   ,[pm_id34]
				   ,[pm_id35]
				   ,[pm_id36]
				   ,[pm_id37]
				   ,[pm_id38]
				   ,[pm_id39]
				   ,[pm_id40]
				   ,[probability]
				   ,[project]
				   ,[project_desc]
				   ,[purchase_order_num]
				   ,[rate_table_id]
				   ,[shiptoid]
				   ,[slsperid]
				   ,[start_date]
				   ,[status_08]
				   ,[status_09]
				   ,[status_10]
				   ,[status_11]
				   ,[status_12]
				   ,[status_13]
				   ,[status_14]
				   ,[status_15]
				   ,[status_16]
				   ,[status_17]
				   ,[status_18]
				   ,[status_19]
				   ,[status_20]
				   ,[status_ap]
				   ,[status_ar]
				   ,[status_gl]
				   ,[status_in]
				   ,[status_lb]
				   ,[status_pa]
				   ,[status_po]
				   ,[user1]
				   ,[user2]
				   ,[user3]
				   ,[user4])
			 SELECT
				   JD.alloc_method_cd
				   ,P.BaseCuryId
				   ,P.bf_values_switch
				   ,P.billcuryfixedrate
				   ,P.billcuryid
				   ,' ' -- Added for SL 7.0 FP1 IronWare [billing_setup]
				   ,P.billratetypeid
				   ,P.budget_version
				   ,'R' -- Added for SL 7.0 FP1 IronWare [budget_type]
				   ,P.contract
				   ,RTRIM(LEFT(PC.Control_data, 10))
				   ,P.CpnyId
				   ,GETDATE()
				   ,'APSAUTO'
				   ,SUBSTRING(@user, 0, 10) -- 'TestIronWare' it 12 char., column is 10
				   ,P.CuryId
				   ,P.CuryRateType
				   ,SUBSTRING(PC.Control_data, 21, 15)
				   ,P.end_date
				   ,SUBSTRING(PC.Control_data,36,24) --RTRIM(RIGHT(PC.Control_data, 24))
				   ,JD.labor_gl_acct
				   ,GETDATE()
				   ,'APSAUTO'
				   ,SUBSTRING(@user, 0, 10) -- 'TestIronWare' it 12 char., column is 10
				   ,SUBSTRING(PC.Control_data, 11, 10)
				   ,P.manager2
				   ,''
				   ,''
				   ,''
				   ,P.noteid
				   ,P.opportunityID
				   ,P.pm_id01
				   ,P.pm_id02
				   ,''
				   ,''
				   ,P.pm_id05 -- DAB Added 4/24/2012 so that this field is populated on the APS Job
				   ,P.pm_id06
				   ,P.pm_id07
				   ,P.pm_id08
				   ,P.pm_id09
				   ,P.pm_id10
				   ,P.pm_id31
				   ,P.pm_id32
				   ,P.pm_id33
				   ,@Project
				   ,P.pm_id35
				   ,P.pm_id36
				   ,P.pm_id37
				   ,P.pm_id38
				   ,P.pm_id39
				   ,P.pm_id40
				   ,P.probability
				   ,LEFT(@Project, 8) + RTRIM(LEFT(PC.Control_data, 10))
				   ,P.project_desc
				   ,P.purchase_order_num
				   ,JD.rate_table_id
				   ,P.shiptoid
				   ,P.slsperid
				   ,P.start_date
				   ,P.status_08
				   ,P.status_09
				   ,P.status_10
				   ,P.status_11
				   ,P.status_12
				   ,P.status_13
				   ,P.status_14
				   ,P.status_15
				   ,P.status_16
				   ,P.status_17
				   ,P.status_18
				   ,P.status_19
				   ,P.status_20
				   ,JD.status_ap
				   ,JD.status_ar
				   ,JD.status_gl
				   ,JD.status_in
				   ,JD.status_lb
				   ,JD.status_pa
				   ,JD.status_po
				   ,P.user1
				   , '0000000199' --P.user2 Changed to reflect the new Client Contact model
				   ,P.user3
				   ,P.user4
			FROM
					(SELECT
						*
					 FROM
						PJCONTRL
					 WHERE
						Control_Code = 'APSJOBSETUP') PC
					INNER JOIN xJobTypeDefault JD ON
						RTRIM(LEFT(PC.Control_data, 10)) = RTRIM(JD.JobType),
					PJPROJ P
			WHERE
					P.Project = @Project


			IF @@ERROR <> 0
				BEGIN
					SET @Result = 2
					GOTO ReturnData
				END
			INSERT INTO [PJPROJEX]
					   ([computed_date]
					   ,[computed_pc]
					   ,[crtd_datetime]
					   ,[crtd_prog]
					   ,[crtd_user]
					   ,[entered_pc]
					   ,[lupd_datetime]
					   ,[lupd_prog]
					   ,[lupd_user]
					   ,[noteid]
					   ,[PM_ID11]
					   ,[PM_ID12]
					   ,[PM_ID13]
					   ,[PM_ID14]
					   ,[PM_ID15]
					   ,[PM_ID16]
					   ,[PM_ID17]
					   ,[PM_ID18]
					   ,[PM_ID19]
					   ,[PM_ID20]
					   ,[PM_ID21]
					   ,[PM_ID22]
					   ,[PM_ID23]
					   ,[PM_ID24]
					   ,[PM_ID25]
					   ,[PM_ID26]
					   ,[PM_ID27]
					   ,[PM_ID28]
					   ,[PM_ID29]
					   ,[PM_ID30]
					   ,[proj_date1]
					   ,[proj_date2]
					   ,[proj_date3]
					   ,[proj_date4]
					   ,[project]
					   ,[rate_table_labor]
					   ,[revision_date]
					   ,[rev_flag]
					   ,[rev_type]
					   ,[work_comp_cd]
					   ,[work_location])
				 SELECT
					   P.computed_date
					   ,P.computed_pc
					   ,GETDATE()
					   ,'APSAUTO'
					   ,SUBSTRING(@user, 0, 10) -- 'TestIronWare' it 12 char., column is 10
					   ,P.entered_pc
					   ,GETDATE()
					   ,'APSAUTO'
					   ,SUBSTRING(@user, 0, 10) -- 'TestIronWare' it 12 char., column is 10
					   ,P.noteid
					   ,''
					   ,''
					   ,''
					   ,''
					   ,''
					   ,0
					   ,0
					   ,' '
					   ,' '
					   ,0
					   ,''
					   ,''
					   ,''
					   ,''
					   ,''
					   ,P.PM_ID26
					   ,P.PM_ID27
					   ,P.PM_ID28
					   ,P.PM_ID29
					   ,P.PM_ID30
					   ,P.proj_date1
					   ,P.proj_date2
					   ,P.proj_date3
					   ,P.proj_date4
					   ,LEFT(@Project, 8) + RTRIM(LEFT(PC.Control_data, 10))
					   ,JD.rate_table_labor
					   ,' '
					   ,''
					   ,''
					   ,''
					   ,''
			FROM
					(SELECT
						*
					 FROM
						PJCONTRL
					 WHERE
						Control_Code = 'APSJOBSETUP') PC
					INNER JOIN xJobTypeDefault JD ON
						RTRIM(LEFT(PC.Control_data, 10)) = RTRIM(JD.JobType),
					PJPROJEX P
			WHERE
					P.Project = @Project

			IF @@ERROR <> 0
				BEGIN
					SET @Result = 2
					GOTO ReturnData
				END

			INSERT INTO [PJPROJEM]
				   ([access_data1]
				   ,[access_data2]
				   ,[access_insert]
				   ,[access_update]
				   ,[access_view]
				   ,[crtd_datetime]
				   ,[crtd_prog]
				   ,[crtd_user]
				   ,[employee]
				   ,[labor_class_cd]
				   ,[lupd_datetime]
				   ,[lupd_prog]
				   ,[lupd_user]
				   ,[noteid]
				   ,[project]
				   ,[pv_id01]
				   ,[pv_id02]
				   ,[pv_id03]
				   ,[pv_id04]
				   ,[pv_id05]
				   ,[pv_id06]
				   ,[pv_id07]
				   ,[pv_id08]
				   ,[pv_id09]
				   ,[pv_id10]
				   ,[user1]
				   ,[user2]
				   ,[user3]
				   ,[user4])
			SELECT
				   P.access_data1
				   ,P.access_data2
				   ,P.access_insert
				   ,P.access_update
				   ,P.access_view
				   ,GETDATE()
				   ,'APSAUTO'
				   ,SUBSTRING(@user, 0, 10) -- 'TestIronWare' it 12 char., column is 10
				   ,P.employee
				   ,P.labor_class_cd
				   ,GETDATE()
				   ,'APSAUTO'
				   ,SUBSTRING(@user, 0, 10) -- 'TestIronWare' it 12 char., column is 10
				   ,P.noteid
				   ,LEFT(@Project, 8) + RTRIM(LEFT(PC.Control_data, 10))
				   ,P.pv_id01
				   ,P.pv_id02
				   ,P.pv_id03
				   ,P.pv_id04
				   ,P.pv_id05
				   ,P.pv_id06
				   ,P.pv_id07
				   ,P.pv_id08
				   ,P.pv_id09
				   ,P.pv_id10
				  ,P.user1
				   ,P.user2
				   ,P.user3
				   ,P.user4
			FROM
				(SELECT
						*
					 FROM
						PJCONTRL
					 WHERE
						Control_Code = 'APSJOBSETUP') PC
					INNER JOIN xJobTypeDefault JD ON
						RTRIM(LEFT(PC.Control_data, 10)) = RTRIM(JD.JobType),
					PJPROJEM P
			WHERE
					P.Project = @Project AND
					P.Employee = '*'

			IF @@ERROR <> 0
				BEGIN
					SET @Result = 2
					GOTO ReturnData
				END

--Create TRAPS Export entry
--			SET IDENTITY_INSERT [xTRAPS_JOBHDR] ON
			INSERT INTO [xTRAPS_JOBHDR]
					   ([job_number]
					   ,[job_title]
					   ,[parent_job]
					   ,[child_job]
					   ,[status]
					   ,[progress]
					   ,[noteid]
					   ,[sub_prod_code]
					   ,[date_created]
					   ,[billable]
					   ,[trigger_status])
				 SELECT
					   LEFT(@Project, 8) + RTRIM(LEFT(PC.Control_data, 10))
					   ,P.project_desc
					   ,@Project
					   ,LEFT(@Project, 8) + RTRIM(LEFT(PC.Control_data, 10))
					   ,'A'
					   ,'W'
					   ,0
					   ,P.pm_id02
					   ,GETDATE()
					   ,'Y'
					   ,'RI'
				FROM
					(SELECT
							*
						 FROM
							PJCONTRL
						 WHERE
							Control_Code = 'APSJOBSETUP') PC
						INNER JOIN xJobTypeDefault JD ON
							RTRIM(LEFT(PC.Control_data, 10)) = RTRIM(JD.JobType),
						PJPROJ P
				WHERE
						P.Project = @Project

			IF @@ERROR <> 0
				BEGIN
					SET @Result = 3
				END


			INSERT INTO [dbo].[PJPENT]
					   ([contract_type]
					   ,[crtd_datetime]
					   ,[crtd_prog]
					   ,[crtd_user]
					   ,[end_date]
					   ,[fips_num]
					   ,[labor_class_cd]
					   ,[lupd_datetime]
					   ,[lupd_prog]
					   ,[lupd_user]
					   ,[manager1]
					   ,[MSPData]
					   ,[MSPInterface]
					   ,[MSPSync] -- Added for SL 7.0 FP1 IronWare
					   ,[MSPTask_UID]
					   ,[noteid]
					   ,[opportunityProduct]
					   ,[pe_id01]
					   ,[pe_id02]
					   ,[pe_id03]
					   ,[pe_id04]
					   ,[pe_id05]
					   ,[pe_id06]
					   ,[pe_id07]
					   ,[pe_id08]
					   ,[pe_id09]
					   ,[pe_id10]
					   ,[pe_id31]
					   ,[pe_id32]
					   ,[pe_id33]
					   ,[pe_id34]
					   ,[pe_id35]
					   ,[pe_id36]
					   ,[pe_id37]
					   ,[pe_id38]
					   ,[pe_id39]
					   ,[pe_id40]
					   ,[pjt_entity]
					   ,[pjt_entity_desc]
					   ,[project]
					   ,[start_date]
					   ,[status_08]
					   ,[status_09]
					   ,[status_10]
					   ,[status_11]
					   ,[status_12]
					   ,[status_13]
					   ,[status_14]
					   ,[status_15]
					   ,[status_16]
					   ,[status_17]
					   ,[status_18]
					   ,[status_19]
					   ,[status_20]
					   ,[status_ap]
					   ,[status_ar]
					   ,[status_gl]
					   ,[status_in]
					   ,[status_lb]
					   ,[status_pa]
					   ,[status_po]
					   ,[user1]
					   ,[user2]
					   ,[user3]
					   ,[user4])
				 SELECT
					   ''
					   ,GETDATE()
					   ,'APSAUTO'
					   ,SUBSTRING(@user, 0, 10) -- 'TestIronWare' it 12 char., column is 10
					   ,' '
					   ,''
					   ,''
					   ,GETDATE()
					   ,'APSAUTO'
					   ,SUBSTRING(@user, 0, 10) -- 'TestIronWare' it 12 char., column is 10
					   ,''
					   ,''
					   ,''
					   ,' ' -- Added for SL 7.0 FP1 IronWare [MSPSync]
					   ,0
					   ,0
					   ,''
					   ,''
					   ,''
					   ,''
					   ,''
					   ,''
					   ,0
					   ,0
					   ,' '
					   ,' '
					   ,0
					   ,''
					   ,''
					   ,''
					   ,''
					   ,''
					   ,''
					   ,''
					   ,0
					   ,' '
					   ,0
					   ,IFC.code_id
					   ,IFC.descr
					   ,LEFT(@Project, 8) + RTRIM(LEFT(PC.Control_data, 10))
					   ,' '
					   ,''
					   ,''
					   ,''
					   ,''
					   ,''
					   ,''
					   ,''
					   ,''
					   ,''
					   ,''
					   ,''
					   ,''
					   ,''
					   ,'A'
					   ,'A'
					   ,'A'
					   ,'A'
					   ,'A'
					   ,'A'
					   ,'A'
					   ,''
					   ,''
					   ,0
					   ,0
				FROM
					(SELECT
						*
					 FROM
						PJCONTRL
					 WHERE
						Control_Code = 'APSJOBSETUP') PC
					INNER JOIN xJobTypeDefault JD ON
						RTRIM(LEFT(PC.Control_data, 10)) = RTRIM(JD.JobType),
					dbo.xIGFunctionCode IFC
				WHERE
					Status = 'A' AND
					[Type] = 'S'


			IF @@ERROR <> 0
				BEGIN
					SET @Result = 4
				END

			INSERT INTO [dbo].[PJPENTEX]
					   ([COMPUTED_DATE]
					   ,[COMPUTED_PC]
					   ,[crtd_datetime]
					   ,[crtd_prog]
					   ,[crtd_user]
					   ,[ENTERED_PC]
					   ,[lupd_datetime]
					   ,[lupd_prog]
					   ,[lupd_user]
					   ,[NOTEID]
					   ,[PE_ID11]
					   ,[PE_ID12]
					   ,[PE_ID13]
					   ,[PE_ID14]
					   ,[PE_ID15]
					   ,[PE_ID16]
					   ,[PE_ID17]
					   ,[PE_ID18]
					   ,[PE_ID19]
					   ,[PE_ID20]
					   ,[PE_ID21]
					   ,[PE_ID22]
					   ,[PE_ID23]
					   ,[PE_ID24]
					   ,[PE_ID25]
					   ,[PE_ID26]
					   ,[PE_ID27]
					   ,[PE_ID28]
					   ,[PE_ID29]
					   ,[PE_ID30]
					   ,[PJT_ENTITY]
					   ,[PROJECT]
					   ,[REVISION_DATE])
				 SELECT
					   ' '
					   ,0
					   ,GETDATE()
					   ,'APSAUTO'
					   ,SUBSTRING(@user, 0, 10) -- 'TestIronWare' it 12 char., column is 10
					   ,0
					   ,GETDATE()
					   ,'APSAUTO'
					   ,SUBSTRING(@user, 0, 10) -- 'TestIronWare' it 12 char., column is 10
					   ,0
					   ,''
					   ,''
					   ,''
					   ,''
					   ,''
					   ,0
					   ,0
					   ,' '
					   ,' '
					   ,0
					   ,''
					   ,''
					   ,''
					   ,''
					   ,''
					   ,0
					   ,0
					   ,' '
					   ,' '
					   ,0
					   ,IFC.code_id
					   ,LEFT(@Project, 8) + RTRIM(LEFT(PC.Control_data, 10))
					   ,' '
				FROM
					(SELECT
						*
					 FROM
						PJCONTRL
					 WHERE
						Control_Code = 'APSJOBSETUP') PC
					INNER JOIN xJobTypeDefault JD ON
						RTRIM(LEFT(PC.Control_data, 10)) = RTRIM(JD.JobType),
					dbo.xIGFunctionCode IFC
				WHERE
					Status = 'A' AND
					[Type] = 'S'

			IF @@ERROR <> 0
				BEGIN
					SET @Result = 4
				END

--			SET IDENTITY_INSERT [xTRAPS_JOBHDR] OFF
		END
	ELSE
		BEGIN
			SET @Result = 1
			GOTO ReturnData
		END

	-- EXEC msdb.dbo.sp_start_job N'Traps Project Export'
	--EXEC xiwDSL_StartJob N'Traps Project Export' -- Executes as job owner

	GOTO ReturnData
ReturnData:
	SELECT @Result as Result
END
GO
