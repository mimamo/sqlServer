USE [SHOPPER_DEV_APP]
GO
/****** Object:  StoredProcedure [dbo].[WORouting_StepNbr]    Script Date: 12/16/2015 15:55:37 ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO
create proc [dbo].[WORouting_StepNbr]
	@WONbr			varchar( 16 ),
	@Task			varchar( 32 ),
	@StepNbr		smallint
AS
		SELECT 			*
	FROM 			WORouting (NoLock)
	WHERE 			WONbr = @WONbr
				and Task = @Task
				and StepNbr LIKE @StepNbr
	ORDER BY 		WONbr, Task, StepNbr
GO
