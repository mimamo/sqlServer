USE [SHOPPER_DEV_APP]
GO
/****** Object:  StoredProcedure [dbo].[SCM_Truncate_Log]    Script Date: 12/16/2015 15:55:33 ******/
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
