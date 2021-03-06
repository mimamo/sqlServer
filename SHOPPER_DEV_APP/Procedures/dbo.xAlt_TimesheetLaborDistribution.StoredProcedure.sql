USE [SHOPPER_DEV_APP]
GO
/****** Object:  StoredProcedure [dbo].[xAlt_TimesheetLaborDistribution]    Script Date: 12/21/2015 14:34:41 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[xAlt_TimesheetLaborDistribution] @DocNbr varchar(15), @LineNbr int, @Hours float, @Amount float, @HoursType varchar(3), @PostPeriod varchar(10)
AS

INSERT INTO [PJLABDIS]
           ([acct]
           ,[amount]
           ,[BaseCuryId]
           ,[CpnyId_chrg]
           ,[CpnyId_home]
           ,[crtd_datetime]
           ,[crtd_prog]
           ,[crtd_user]
           ,[CuryEffDate]
           ,[CuryId]
           ,[CuryMultDiv]
           ,[CuryRate]
           ,[CuryRateType]
           ,[CuryTranamt]
           ,[Curystdcost]
           ,[dl_id01]
           ,[dl_id02]
           ,[dl_id03]
           ,[dl_id04]
           ,[dl_id05]
           ,[dl_id06]
           ,[dl_id07]
           ,[dl_id08]
           ,[dl_id09]
           ,[dl_id10]
           ,[dl_id11]
           ,[dl_id12]
           ,[dl_id13]
           ,[dl_id14]
           ,[dl_id15]
           ,[dl_id16]
           ,[dl_id17]
           ,[dl_id18]
           ,[dl_id19]
           ,[dl_id20]
           ,[docnbr]
           ,[earn_type_id]
           ,[employee]
           ,[fiscalno]
           ,[gl_acct]
           ,[gl_subacct]
           ,[home_subacct]
           ,[hrs_type]
           ,[labor_class_cd]
           ,[labor_stdcost]
           ,[linenbr]
           ,[lupd_datetime]
           ,[lupd_prog]
           ,[lupd_user]
           ,[pe_date]
           ,[pjt_entity]
           ,[premium_hrs]
           ,[project]
           ,[rate_source]
           ,[shift]
           ,[status_1]
           ,[status_2]
           ,[status_gl]
           ,[union_cd]
           ,[work_comp_cd]
           ,[work_type]
           ,[worked_hrs])
SELECT
           A.acct_cat
           ,@amount
           ,'USD'
           ,PD.[CpnyId_chrg]
           ,PD.[CpnyId_home]
           ,PD.[crtd_datetime]
           ,PD.[crtd_prog]
           ,PD.[crtd_user]
           ,' '
           ,'USD'
           ,'M'
           ,1
           ,''
           ,@Amount
           ,0
           ,''
           ,''
           ,PT.[pe_id03]
           ,''
           ,''
           ,0
           ,0
           ,PD.tl_date
           ,' '
           ,0
           ,''
           ,PD.[tl_id12]
           ,''
           ,PP.[pm_id14]
           ,''
           ,''
           ,''
           ,0
           ,0
           ,' '
           ,PH.[docnbr]
           ,''
           ,PD.[employee]
           ,@PostPeriod
           ,PD.[gl_acct]
           ,PD.[gl_subacct]
           ,PD.tl_id11
           ,@HoursType
           ,PD.[labor_class_cd]
           ,0
           ,PD.[linenbr]
           ,PD.[lupd_datetime]
           ,PD.[lupd_prog]
           ,PD.[lupd_user]
           ,PH.th_date
           ,PD.[pjt_entity]
           ,0
           ,PD.[project]
           ,'E'
           ,PD.[shift]
           ,''
           ,'W'
           ,'U'
           ,''
           ,PD.[work_comp_cd]
           ,''
           ,@Hours
FROM
	PJTIMHDR PH
	INNER JOIN PJTIMDET PD
		ON PH.DocNbr = PD.DocNbr
	INNER JOIN Account A
		ON A.acct = PD.gl_acct
	INNER JOIN PJPROJEX PP
		ON PP.Project = PD.Project
	INNER JOIN PJPENT PT
		ON PT.Project = PD.Project AND
		   PT.pjt_entity = PD.pjt_entity
WHERE 
	PH.DocNbr = @DocNbr AND
	PD.LineNbr = @LineNbr
GO
