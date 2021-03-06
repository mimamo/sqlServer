USE [MIDWESTAPP]
GO
/****** Object:  StoredProcedure [dbo].[FCWORouting_NextStep]    Script Date: 12/21/2015 15:55:31 ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO
CREATE PROCEDURE [dbo].[FCWORouting_NextStep]
	@WONbr		varchar( 16 ),
	@Task		varchar( 32 ),
	@LastStepNbr	smallint
AS

	Select		Top 1
			left(ltrim(rtrim(str(R.StepNbr))) + ': ' +
			rtrim(R.WorkCenterID) + ': ' + rtrim(W.Descr) + ', ' +
			rtrim(R.OperationID) + ': ' + rtrim(O.Descr) + Space(100),100)
	From		WORouting R Left Outer Join  Operation O
			On R.OperationID = O.OperationID
			Left Outer Join WorkCenter W
			On R.WorkCenterID = W.WorkCenterID
	Where		R.WONbr = @WONbr
			and R.Task = @Task
			and R.StepNbr > @LastStepNbr
	Order By	R.WONbr, R.Task, R.StepNbr
GO
