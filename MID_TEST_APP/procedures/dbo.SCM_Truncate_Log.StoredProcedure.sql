USE [MID_TEST_APP]
GO
/****** Object:  StoredProcedure [dbo].[SCM_Truncate_Log]    Script Date: 12/21/2015 15:49:32 ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO
Create	Procedure [dbo].[SCM_Truncate_Log]
As
	Set	NoCount On
	Declare	@DBName	VarChar(256)

	Select	@DBName = DB_Name()

	Exec ('Use ' + @DBName)

	Begin Transaction
		Update	Batch
			Set	Status = Status
	Rollback Transaction

	Checkpoint

	Exec ('Dump Transaction ' + @DBName + ' With Truncate_Only')
	Exec ('Dump Transaction ' + @DBName + ' With No_Log')
GO
