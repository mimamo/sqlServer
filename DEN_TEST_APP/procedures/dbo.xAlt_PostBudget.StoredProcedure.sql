USE [DEN_TEST_APP]
GO
/****** Object:  StoredProcedure [dbo].[xAlt_PostBudget]    Script Date: 12/21/2015 15:37:12 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[xAlt_PostBudget] @Project varchar(15), @RevID varchar(10)
AS


DECLARE
	@Acct varchar(16),
	@Task varchar(16),
	@Amount float,
	@Rate float,
	@Units float

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
						   (@ACCT
						   ,0
						   ,0
						   ,0
						   ,0
						   ,GETDATE()
						   ,'TRAPS'
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
						   ,'TRAPS'
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
				SET EAC_Amount = @Amount, FAC_Amount = @Amount, EAC_Units = @Units, FAC_Units = @Units, lupd_datetime = GETDATE(), lupd_prog = 'TRAPS', lupd_user = 'IMPORT'
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
				INSERT INTO [dbo].[PJPTDROL]
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
						   ,'TRAPS'
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
						   ,'TRAPS'
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
				SET EAC_Amount = @Amount, FAC_Amount = @Amount, EAC_Units = @Units, FAC_Units = @Units, lupd_datetime = GETDATE(), lupd_prog = 'TRAPS', lupd_user = 'IMPORT'
				WHERE Project = @Project AND Acct = @Acct
			END


		UPDATE PJREVHDR SET Status = 'P' WHERE Project = @Project AND RevID = @RevID

		FETCH NEXT FROM csr_Budget INTO
			@Acct,
			@Amount,
			@Units,
			@Rate

	END

CLOSE csr_Budget
DEALLOCATE csr_Budget
GO
