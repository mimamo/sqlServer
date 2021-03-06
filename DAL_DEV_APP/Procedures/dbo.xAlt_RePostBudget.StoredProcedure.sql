USE [DAL_DEV_APP]
GO
/****** Object:  StoredProcedure [dbo].[xAlt_RePostBudget]    Script Date: 12/21/2015 13:35:59 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[xAlt_RePostBudget] @Project varchar(15), @RevID varchar(10)
AS
DECLARE
	@Acct varchar(16),
	@Task varchar(16),
	@Amount float,
	@Rate float,
	@Units float

IF EXISTS (SELECT * FROM PJREVHDR WHERE Project = @Project AND RevID = @RevID AND Status = 'P')
	BEGIN

		DECLARE csr_Budget CURSOR FOR
			SELECT
				acct,
				pjt_entity,
				Amount,
				Rate,
				Units
			FROM
				PJREVCAT
			WHERE
				Project = @Project AND
				RevID = @RevID

		OPEN csr_Budget
		FETCH NEXT FROM csr_Budget INTO
			@Acct,
			@Task,
			@Amount,
			@Rate,
			@Units

		WHILE @@FETCH_STATUS = 0
			BEGIN
				IF NOT EXISTS (SELECT * FROM PJPTDSUM WHERE PROJECT = @Project AND pjt_entity = @Task and acct = @Acct)
					BEGIN
						INSERT INTO [dbo].[PJPTDSUM]
								   ([acct]
								   ,[act_amount]
								   ,[act_units]
								   ,[com_amount]
								   ,[com_units]
								   ,[crtd_datetime]
								   ,[crtd_prog]
								   ,[crtd_user]
								   ,[data1]
								   ,[data2]
								   ,[data3]
								   ,[data4]
								   ,[data5]
								   ,[eac_amount]
								   ,[eac_units]
								   ,[fac_amount]
								   ,[fac_units]
								   ,[lupd_datetime]
								   ,[lupd_prog]
								   ,[lupd_user]
								   ,[noteid]
								   ,[pjt_entity]
								   ,[project]
								   ,[rate]
								   ,[total_budget_amount]
								   ,[total_budget_units]
								   ,[user1]
								   ,[user2]
								   ,[user3]
								   ,[user4])
							 VALUES
								   (@Acct
								   ,0
								   ,0
								   ,0
								   ,0
								   ,GETDATE()
								   ,'PJABR'
								   ,'IMPORT'
								   ,''
								   ,0
								   ,0
								   ,0
								   ,0
								   ,@Amount
								   ,@Units
								   ,@Amount
								   ,@Units
								   ,GETDATE()
								   ,'PJABR'
								   ,'IMPORT'
								   ,0
								   ,@Task
								   ,@Project
								   ,@Rate
								   ,@Amount
								   ,@Units
								   ,''
								   ,''
								   ,0
								   ,0)
					END
				ELSE
					BEGIN
						UPDATE PJPTDSUM
						SET EAC_Amount = @Amount, FAC_Amount = @Amount, total_budget_amount = @Amount, EAC_Units = @Units, FAC_Units = @Units, total_budget_units = @Units, lupd_datetime = GETDATE(), lupd_prog = 'PJABR', lupd_user = 'IMPORT'
						WHERE Project = @Project AND pjt_entity = @Task AND Acct = @Acct
					END 

				FETCH NEXT FROM csr_Budget INTO
					@Acct,
					@Task,
					@Amount,
					@Rate,
					@Units

			END
		CLOSE csr_Budget
		DEALLOCATE csr_Budget


		DECLARE csr_Budget CURSOR FOR 
			SELECT
				acct,
				SUM(Amount) as Amount,
				SUM(Units) as Units,
				MAX(Rate) as Rate
			FROM
				PJREVCAT
			WHERE
				Project = @Project AND
				RevID = @RevID
			GROUP BY
				Project,
				RevID,
				Acct

		OPEN csr_Budget
		FETCH NEXT FROM csr_Budget INTO
			@Acct,
			@Amount,
			@Units,
			@Rate

		WHILE @@FETCH_STATUS = 0
			BEGIN
				IF NOT EXISTS (SELECT * FROM PJPTDROL WHERE PROJECT = @Project AND acct = @Acct)
					BEGIN
						INSERT INTO  [dbo].[PJPTDROL]
								   ([acct]
								   ,[act_amount]
								   ,[act_units]
								   ,[com_amount]
								   ,[com_units]
								   ,[crtd_datetime]
								   ,[crtd_prog]
								   ,[crtd_user]
								   ,[data1]
								   ,[data2]
								   ,[data3]
								   ,[data4]
								   ,[data5]
								   ,[eac_amount]
								   ,[eac_units]
								   ,[fac_amount]
								   ,[fac_units]
								   ,[lupd_datetime]
								   ,[lupd_prog]
								   ,[lupd_user]
								   ,[project]
								   ,[rate]
								   ,[total_budget_amount]
								   ,[total_budget_units]
								   ,[user1]
								   ,[user2]
								   ,[user3]
								   ,[user4])
							 VALUES
								   (@Acct
								   ,@Amount
								   ,@units
								   ,0
								   ,0
								   ,GETDATE()
								   ,'PJABR'
								   ,'IMPORT'
								   ,''
								   ,0
								   ,0
								   ,0
								   ,0
								   ,@Amount
								   ,@Units
								   ,@Amount
								   ,@Units
								   ,GETDATE()
								   ,'PJABR'
								   ,'IMPORT'
								   ,@Project
								   ,@Rate
								   ,@Amount
								   ,@Units
								   ,''
								   ,''
								   ,0
								   ,0)
					END
				ELSE
					BEGIN
						UPDATE PJPTDROL
						SET EAC_Amount = @Amount, FAC_Amount = @Amount, total_budget_amount = @Amount, EAC_Units = @Units, FAC_Units = @Units, total_budget_units = @Units, lupd_datetime = GETDATE(), lupd_prog = 'PJABR', lupd_user = 'IMPORT'
						WHERE Project = @Project AND Acct = @Acct
					END
				FETCH NEXT FROM csr_Budget INTO
					@Acct,
					@Amount,
					@Units,
					@Rate

			END

		CLOSE csr_Budget
		DEALLOCATE csr_Budget


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
			 SELECT
				   ''
				   ,GETDATE()
				   ,'ALTBAP'
				   ,'IMPORT'
				   ,' '
				   ,''
				   ,''
				   ,GETDATE()
				   ,'ALTBAP'
				   ,'IMPORT'
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
				   ,PT.pjt_entity
				   ,ISNULL(PC.code_value_desc, '')
				   ,PT.Project
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
			PJREVTSK PT
			INNER JOIN PJCODE PC
				ON PT.pjt_entity = PC.code_value AND
				   PC.code_type = '0FUN'
		WHERE
			Project = @Project AND
			RevID = @RevID AND
			RTRIM(PT.Project) + '-' + RTRIM(PT.pjt_entity) NOT IN (SELECT RTRIM(Project) + '-' + RTRIM(pjt_entity) FROM PJPENT WHERE Project = @Project)



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
				   ,'ALTBAP'
				   ,'IMPORT'
				   ,0
				   ,GETDATE()
				   ,'ALTBAP'
				   ,'IMPORT'
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
				   ,PT.PJT_ENTITY
				   ,PT.PROJECT
				   ,' '
		FROM
			PJREVTSK PT
			INNER JOIN PJCODE PC
				ON PT.pjt_entity = PC.code_value AND
				   PC.code_type = '0FUN'
		WHERE
			Project = @Project AND
			RevID = @RevID AND
			RTRIM(PT.Project) + '-' + RTRIM(PT.pjt_entity) NOT IN (SELECT RTRIM(Project) + '-' + RTRIM(pjt_entity) FROM PJPENTex WHERE Project = @Project)

		UPDATE PJREVHDR
		SET status = 'P', Post_date = GETDATE(), lupd_prog = 'ALTBPR', lupd_datetime = GETDATE()
		WHERE Project = @Project AND RevID = @RevID

	END
GO
