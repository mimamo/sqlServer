USE [DAL_TEST_APP]
GO
/****** Object:  StoredProcedure [dbo].[xIDAL_CreateInterJob]    Script Date: 12/21/2015 13:57:20 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[xIDAL_CreateInterJob] 
			@Project varchar(16), @user varchar(30)
		AS
		BEGIN
			SET NOCOUNT ON;

			DECLARE @ReturnValue as Integer

			IF NOT EXISTS (SELECT * FROM PJPROJ, (SELECT * FROM	PJCONTRL WHERE Control_Code = 'INTERACTIVEJOBSETUP') PC WHERE Project = LEFT(@Project, 8) + RTRIM(LEFT(PC.Control_data, 10)))
				BEGIN
					INSERT INTO [PJPROJ]
						   ([alloc_method_cd]
						   ,[BaseCuryId]
						   ,[bf_values_switch]
						   ,[billcuryfixedrate]
						   ,[billcuryid]
						   ,[billratetypeid]
						   ,[budget_version]
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
						   ,P.billratetypeid
						   ,P.budget_version
						   ,P.contract
						   ,RTRIM(LEFT(PC.Control_data, 10))
						   ,P.CpnyId
						   ,GETDATE()
						   ,'ALTAUTO'
						   ,@user
						   ,P.CuryId
						   ,P.CuryRateType
						   ,RTRIM(RIGHT(LEFT(PC.Control_data, 20), 10))
						   ,P.end_date
						   ,SUBSTRING(PC.Control_data,36,24) --RTRIM(RIGHT(PC.Control_data, 24))
						   ,JD.labor_gl_acct
						   ,GETDATE()
						   ,'ALTAUTO'
						   ,@user
						   ,RTRIM(RIGHT(LEFT(PC.Control_data, 35), 15))
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
						   ,''
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
						   ,LEFT(@Project, 11) + RTRIM(LEFT(PC.Control_data, 10))
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
						   ,P.user2
						   ,P.user3
						   ,P.user4
					FROM
							(SELECT
								*
							 FROM
								PJCONTRL
							 WHERE
								Control_Code = 'INTERACTIVEJOBSETUP') PC
							INNER JOIN xJobTypeDefault JD ON
								RTRIM(LEFT(PC.Control_data, 10)) = RTRIM(JD.JobType),
							PJPROJ P
					WHERE
							P.Project = @Project



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
							   ,'ALTAUTO'
							   ,@user
							   ,P.entered_pc
							   ,GETDATE()
							   ,'ALTAUTO'
							   ,@user
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
							   ,LEFT(@Project,11) + RTRIM(LEFT(PC.Control_data, 10))
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
								Control_Code = 'INTERACTIVEJOBSETUP') PC
							INNER JOIN xJobTypeDefault JD ON
								RTRIM(LEFT(PC.Control_data, 10)) = RTRIM(JD.JobType),
							PJPROJEX P
					WHERE
							P.Project = @Project

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
						   ,'ALTAUTO'
						   ,@user
						   ,P.employee
						   ,P.labor_class_cd
						   ,GETDATE()
						   ,'ALTAUTO'
						   ,@user
						   ,P.noteid
						   ,LEFT(@Project, 11) + RTRIM(LEFT(PC.Control_data, 10))
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
								Control_Code = 'INTERACTIVEJOBSETUP') PC
							INNER JOIN xJobTypeDefault JD ON
								RTRIM(LEFT(PC.Control_data, 10)) = RTRIM(JD.JobType),
							PJPROJEM P
					WHERE
							P.Project = @Project AND
							P.Employee = '*'


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
					SELECT [contract_type]
						   ,GETDATE()
						   ,'PAPRJ'
						   ,@User
						  ,[end_date]
						  ,[fips_num]
						  ,[labor_class_cd]
						   ,GETDATE()
						   ,'PAPRJ'
						   ,@User
						  ,[manager1]
						  ,[MSPData]
						  ,[MSPInterface]
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
						  ,LEFT(@Project, 11) + RTRIM(LEFT(PC.Control_data, 10))
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
						  ,[user4]
					  FROM 
							(SELECT
								*
							 FROM
								PJCONTRL
							 WHERE
								Control_Code = 'INTERACTIVEJOBSETUP') PC
							INNER JOIN dbo.xAlt_ProjectDefaultTask JD ON
								RTRIM(LEFT(PC.Control_data, 10)) = RTRIM(JD.DefaultType)

				INSERT INTO [DallasApp].[dbo].[PJPENTEX]
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
							[COMPUTED_DATE]
						   ,[COMPUTED_PC]
						   ,GETDATE()
						   ,'PAPRJ'
						   ,@User
						   ,[ENTERED_PC]
						   ,GETDATE()
						   ,'PAPRJ'
						   ,@User
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
						   ,LEFT(@Project, 11) + RTRIM(LEFT(PC.Control_data, 10))
						   ,[REVISION_DATE]
						FROM
							(SELECT
								*
							 FROM
								PJCONTRL
							 WHERE
								Control_Code = 'INTERACTIVEJOBSETUP') PC
							INNER JOIN dbo.xAlt_ProjectDefaultTaskEX JD ON
								RTRIM(LEFT(PC.Control_data, 10)) = RTRIM(JD.DefaultType)


					SET @ReturnValue = 0
								
				END
			ELSE
				BEGIN

					SET @ReturnValue = 1
				END

			SELECT
				@ReturnValue as ReturnValue


		END
GO
