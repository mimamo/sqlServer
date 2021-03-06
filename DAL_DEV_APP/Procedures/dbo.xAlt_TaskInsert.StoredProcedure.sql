USE [DAL_DEV_APP]
GO
/****** Object:  StoredProcedure [dbo].[xAlt_TaskInsert]    Script Date: 12/21/2015 13:35:59 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[xAlt_TaskInsert] @Project varchar(30), @Task varchar(30) , @TaskCode varchar(20) AS

IF NOT EXISTS (SELECT * FROM PJPENT WHERE Project = @Project and pjt_entity = @Task) 
BEGIN

DECLARE @Description varchar(30)
SELECT @Description = Code_value_desc
FROM PJCODE
WHERE Code_Value = @Task AND code_type = @TaskCode

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
     VALUES
           (''
           ,GETDATE()
           ,'ALTAUTO'
           ,'ALTAUTO'
           ,' '
           ,''
           ,''
           ,GETDATE()
           ,'ALTAUTO'
           ,'ALTAUTO'
           ,''
           ,''
           ,''
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
           ,@Task
           ,@Description
           ,@Project
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
           ,0)



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
     VALUES
           (' '
           ,0
           ,GETDATE()
           ,'ALTAUTO'
           ,'ALTAUTO'
           ,0
           ,GETDATE()
           ,'ALTAUTO'
           ,'ALTAUTO'
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
           ,@Task
           ,@PROJECT
           ,' ')

END
GO
