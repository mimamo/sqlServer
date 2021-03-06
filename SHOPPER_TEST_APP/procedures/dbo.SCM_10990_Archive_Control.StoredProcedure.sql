USE [SHOPPER_TEST_APP]
GO
/****** Object:  StoredProcedure [dbo].[SCM_10990_Archive_Control]    Script Date: 12/21/2015 16:07:18 ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO
Create	Procedure [dbo].[SCM_10990_Archive_Control]
	@Schedule	DateTime
As
	Set	NoCount On
	Declare	@INTranJobID		UniqueIdentifier,
		@LotSerTJobID		UniqueIdentifier,
		@StartDate		Integer,
		@StartTime		Integer,
		@CharTime		VarChar(8)

	Exec	SCM_10990_Archive_Job 'LotSerT', 'LotSerTArch', @INTranJobID, @LotSerTJobID Output

	Exec	SCM_10990_Archive_Job 'INTran', 'INArchTran', @LotSerTJobID, @INTranJobID Output

	If	@Schedule <> '01/01/1900'
	Begin
		Select	@StartDate = Convert(Integer, Convert(VarChar(8), @Schedule, 112)),
			@CharTime = Convert(VarChar(8), @Schedule, 14)

		Set	@StartTime = Cast(SubString(@Chartime, 1, 2)
					+ SubString(@Chartime, 4, 2)
					+ SubString(@Chartime, 7, 2) As Integer)

		Exec	msdb..sp_Add_JobSchedule @Job_ID = @INTranJobID, @Enabled = 1,
			@Freq_Type = 1, @Active_Start_Date = @StartDate,
			@Active_Start_Time = @StartTime, @Name = 'Archive INTran'
	End
	Else
	Begin
		Exec	msdb..sp_Start_Job @Job_ID = @INTranJobID
	End
GO
