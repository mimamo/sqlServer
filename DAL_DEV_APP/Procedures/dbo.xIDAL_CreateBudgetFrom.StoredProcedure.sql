USE [DAL_DEV_APP]
GO
/****** Object:  StoredProcedure [dbo].[xIDAL_CreateBudgetFrom]    Script Date: 12/21/2015 13:36:00 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[xIDAL_CreateBudgetFrom] @Project varchar(16), @RevID varchar(4) 
AS

IF NOT EXISTS (SELECT * FROM PJREVTSK WHERE Project = @Project AND RevID = @RevID)
	BEGIN
		INSERT INTO [dbo].[PJREVTSK]
			   ([contract_type]
			   ,[crtd_datetime]
			   ,[crtd_prog]
			   ,[crtd_user]
			   ,[end_date]
			   ,[fips_num]
			   ,[lupd_datetime]
			   ,[lupd_prog]
			   ,[lupd_user]
			   ,[manager1]
			   ,[NoteId]
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
			   ,[pjt_entity]
			   ,[pjt_entity_desc]
			   ,[project]
			   ,[revid]
			   ,[rt_id01]
			   ,[rt_id02]
			   ,[rt_id03]
			   ,[rt_id04]
			   ,[rt_id05]
			   ,[rt_id06]
			   ,[rt_id07]
			   ,[rt_id08]
			   ,[rt_id09]
			   ,[rt_id10]
			   ,[start_date]
			   ,[user1]
			   ,[user2]
			   ,[user3]
			   ,[user4]
			   ,[User5]
			   ,[User6]
			   ,[User7]
			   ,[User8])
		SELECT
				PR.[contract_type]
			   ,GETDATE()
			   ,PR.[crtd_prog]
			   ,PR.[crtd_user]
			   ,PR.[end_date]
			   ,PR.[fips_num]
			   ,GETDATE()
			   ,PR.[lupd_prog]
			   ,PR.[lupd_user]
			   ,PR.[manager1]
			   ,0
			   ,PR.[pe_id01]
			   ,PR.[pe_id02]
			   ,PR.[pe_id03]
			   ,PR.[pe_id04]
			   ,PR.[pe_id05]
			   ,PR.[pe_id06]
			   ,PR.[pe_id07]
			   ,PR.[pe_id08]
			   ,PR.[pe_id09]
			   ,PR.[pe_id10]
			   ,PR.[pjt_entity]
			   ,PR.[pjt_entity_desc]
			   ,PR.[project]
			   ,@RevID
			   ,PR.[rt_id01]
			   ,PR.[rt_id02]
			   ,PR.[rt_id03]
			   ,PR.[rt_id04]
			   ,PR.[rt_id05]
			   ,PR.[rt_id06]
			   ,PR.[rt_id07]
			   ,PR.[rt_id08]
			   ,PR.[rt_id09]
			   ,PR.[rt_id10]
			   ,PR.[start_date]
			   ,PR.[user1]
			   ,PR.[user2]
			   ,PR.[user3]
			   ,PR.[user4]
			   ,PR.[User5]
			   ,PR.[User6]
			   ,PR.[User7]
			   ,PR.[User8]
		FROM
			PJREVTSK PR
			INNER JOIN PJPROJEX PP
				ON PR.Project = PP.Project AND
				   PR.RevID = PP.pm_id25
		WHERE
			PP.Project = @Project

		INSERT INTO [dbo].[PJREVCAT]
			   ([Acct]
			   ,[Amount]
			   ,[crtd_datetime]
			   ,[crtd_prog]
			   ,[crtd_user]
			   ,[lupd_datetime]
			   ,[lupd_prog]
			   ,[lupd_user]
			   ,[NoteId]
			   ,[pjt_entity]
			   ,[project]
			   ,[Rate]
			   ,[rc_id01]
			   ,[rc_id02]
			   ,[rc_id03]
			   ,[rc_id04]
			   ,[rc_id05]
			   ,[rc_id06]
			   ,[rc_id07]
			   ,[rc_id08]
			   ,[rc_id09]
			   ,[rc_id10]
			   ,[RevId]
			   ,[Units]
			   ,[user1]
			   ,[user2]
			   ,[user3]
			   ,[user4]
			   ,[User5]
			   ,[User6]
			   ,[User7]
			   ,[User8])
			SELECT
				PC.[Acct]
			   ,PC.[Amount]/PC.[user3]
			   ,GETDATE()
			   ,PC.[crtd_prog]
			   ,PC.[crtd_user]
			   ,GETDATE()
			   ,PC.[lupd_prog]
			   ,PC.[lupd_user]
			   ,0
			   ,PC.[pjt_entity]
			   ,PC.[project]
			   ,PC.[Rate]
			   ,PC.[rc_id01]
			   ,PC.[rc_id02]
			   ,PC.[rc_id03]
			   ,PC.[rc_id04]
			   ,PC.[rc_id05]
			   ,PC.[rc_id06]
			   ,PC.[rc_id07]
			   ,PC.[rc_id08]
			   ,PC.[rc_id09]
			   ,PC.[rc_id10]
			   ,@RevID
			   ,PC.[Units]
			   ,PC.[user1]
			   ,PC.[user2]
			   ,0
			   ,PC.[user4]
			   ,PC.[User5]
			   ,PC.[User6]
			   ,PC.[User7]
			   ,PC.[User8]
		FROM
			PJREVCAT PC
			INNER JOIN PJPROJEX PP
				ON PC.Project = PP.Project AND
				   PC.RevID = PP.pm_id25
		WHERE
			PP.Project = @Project AND
			PC.acct = 'ESTIMATE'

	END
GO
