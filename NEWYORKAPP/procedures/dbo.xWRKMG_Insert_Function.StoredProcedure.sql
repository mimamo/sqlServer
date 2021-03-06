USE [NEWYORKAPP]
GO
/****** Object:  StoredProcedure [dbo].[xWRKMG_Insert_Function]    Script Date: 12/21/2015 16:01:27 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[xWRKMG_Insert_Function] 

	@PROJECT varchar(100),
	@TASK varchar(100),
	@TRANDESC varchar(100),
	@ERRORNBR int OUTPUT,
    @ERRORMSG varchar(100) OUTPUT
	
AS

SET NOCOUNT ON

BEGIN TRY 
 BEGIN TRANSACTION 

INSERT INTO [DENVERAPP].[dbo].[PJPENT]
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
           ,[MSPSync]
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
(     
            SPACE(4)--<contract_type, char(4),>
           ,Cast(GETDATE() as smalldatetime)--<crtd_datetime, smalldatetime,>
           ,'PAPRG'--<crtd_prog, char(8),>
           ,'SYSADMIN'--<crtd_user, char(10),>
           ,'1/1/1900'--<end_date, smalldatetime,>
           ,SPACE(10)--<fips_num, char(10),>
           ,SPACE(4)--<labor_class_cd, char(4),>
           ,Cast(GETDATE() as smalldatetime)--<lupd_datetime, smalldatetime,>
           ,'PAPRG'--<lupd_prog, char(8),>
           ,'SYSADMIN'--<lupd_user, char(10),>
           ,SPACE(10)--<manager1, char(10),>
           ,SPACE(50)--<MSPData, char(50),>
           ,SPACE(1)--<MSPInterface, char(1),>
           ,SPACE(1)--<MSPSync, char(1),>
           ,0--<MSPTask_UID, int,>
           ,0--<noteid, int,>
           ,SPACE(36)--<opportunityProduct, char(36),>
           ,SPACE(30)--<pe_id01, char(30),>
           ,SPACE(30)--<pe_id02, char(30),>
           ,SPACE(16)--<pe_id03, char(16),>
           ,SPACE(16)--<pe_id04, char(16),>
           ,SPACE(4)--<pe_id05, char(4),>
           ,0--<pe_id06, float,>
           ,0--<pe_id07, float,>
           ,'1/1/1900'--<pe_id08, smalldatetime,>
           ,'1/1/1900'--<pe_id09, smalldatetime,>
           ,0--<pe_id10, int,>
           ,SPACE(30)--<pe_id31, char(30),>
           ,SPACE(30)--<pe_id32, char(30),>
           ,SPACE(20)--<pe_id33, char(20),>
           ,SPACE(20)--<pe_id34, char(20),>
           ,SPACE(10)--<pe_id35, char(10),>
           ,SPACE(10)--<pe_id36, char(10),>
           ,SPACE(4)--<pe_id37, char(4),>
           ,0--<pe_id38, float,>
           ,'1/1/1900'--<pe_id39, smalldatetime,>
           ,0--<pe_id40, int,>
           ,@TASK--<pjt_entity, char(32),>
           ,@TRANDESC--<pjt_entity_desc, char(60),>
           ,@PROJECT--<project, char(16),>
           ,'1/1/1900'--<start_date, smalldatetime,>
           ,SPACE(1)--<status_08, char(1),>
           ,SPACE(1)--<status_09, char(1),>
           ,SPACE(1)--<status_10, char(1),>
           ,SPACE(1)--<status_11, char(1),>
           ,SPACE(1)--<status_12, char(1),>
           ,SPACE(1)--<status_13, char(1),>
           ,SPACE(1)--<status_14, char(1),>
           ,SPACE(1)--<status_15, char(1),>
           ,SPACE(1)--<status_16, char(1),>
           ,SPACE(1)--<status_17, char(1),>
           ,SPACE(1)--<status_18, char(1),>
           ,SPACE(1)--<status_19, char(1),>
           ,SPACE(1)--<status_20, char(1),>
           ,'I'--<status_ap, char(1),>
           ,'I'--<status_ar, char(1),>
           ,'A'--<status_gl, char(1),>
           ,'I'--<status_in, char(1),>
           ,'A'--<status_lb, char(1),>
           ,'A'--<status_pa, char(1),>
           ,'I'--<status_po, char(1),>
           ,SPACE(30)--<user1, char(30),>
           ,SPACE(30)--<user2, char(30),>
           ,0--<user3, float,>
           ,0--<user4, float,>
)

INSERT INTO [DENVERAPP].[dbo].[PJPENTEX]
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
(			'1/1/1900'--<COMPUTED_DATE, smalldatetime,>
           ,0--<COMPUTED_PC, float,>
           ,CAST(GETDATE()as smalldatetime)--<crtd_datetime, smalldatetime,>
           ,'PAPRJ'--<crtd_prog, char(8),>
           ,'SYSADMIN'--<crtd_user, char(10),>
           ,0--<ENTERED_PC, float,>
           ,CAST(GETDATE()as smalldatetime)--<lupd_datetime, smalldatetime,>
           ,'PAPRJ'--<lupd_prog, char(8),>
           ,'SYSADMIN'--<lupd_user, char(10),>
           ,0--<NOTEID, int,>
           ,SPACE(30)--<PE_ID11, char(30),>
           ,SPACE(30)--<PE_ID12, char(30),>
           ,SPACE(16)--<PE_ID13, char(16),>
           ,SPACE(16)--<PE_ID14, char(16),>
           ,SPACE(4)--<PE_ID15, char(4),>
           ,0--<PE_ID16, float,>
           ,0--<PE_ID17, float,>
           ,'1/1/1900'--<PE_ID18, smalldatetime,>
           ,'1/1/1900'--<PE_ID19, smalldatetime,>
           ,0--<PE_ID20, int,>
           ,SPACE(30)--<PE_ID21, char(30),>
           ,SPACE(30)--<PE_ID22, char(30),>
           ,SPACE(16)--<PE_ID23, char(16),>
           ,SPACE(16)--<PE_ID24, char(16),>
           ,SPACE(4)--<PE_ID25, char(4),>
           ,0--<PE_ID26, float,>
           ,0--<PE_ID27, float,>
           ,'1/1/1900'--<PE_ID28, smalldatetime,>
           ,'1/1/1900'--<PE_ID29, smalldatetime,>
           ,0--<PE_ID30, int,>
           ,@TASK--<PJT_ENTITY, char(32),>
           ,@PROJECT--<PROJECT, char(16),>
           ,'1/1/1900'--<REVISION_DATE, smalldatetime,>
)
           
           
COMMIT TRANSACTION 
	
SET @ERRORNBR = 0
SET @ERRORMSG = 'No Error'

END TRY 

BEGIN CATCH 
  IF (XACT_STATE())=-1 ROLLBACK TRANSACTION 
  SET @ERRORNBR = -1
  SET @ERRORMSG = 'ROLLBACK'
END CATCH
GO
