USE [MOJo_prod]
GO
/****** Object:  StoredProcedure [dbo].[sptCashTestApplyToLines]    Script Date: 12/10/2015 12:30:23 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[sptCashTestApplyToLines]
AS

CREATE TABLE #tApply (
		LineKey int null
		,LineAmount money null
		,AlreadyApplied money null
		,ToApply money null
		,DoNotApply int null
		)
	
	
	insert #tApply (LineKey, LineAmount, AlreadyApplied)
	values (1, 4012.50, 0)
	insert #tApply (LineKey, LineAmount, AlreadyApplied)
	values (2, 30.95, 0)
	insert #tApply (LineKey, LineAmount, AlreadyApplied)
	values (3, 469.67, 0)
	
	EXEC sptCashApplyToLines 4513.12, 4543.16, 4543.16
	
	
	/*
	insert #tApply (LineKey, LineAmount, AlreadyApplied)
	values (1, 1000, 0)
	insert #tApply (LineKey, LineAmount, AlreadyApplied)
	values (2, 1000, 0)
	insert #tApply (LineKey, LineAmount, AlreadyApplied)
	values (3, 1000, 0)
	
	EXEC sptCashApplyToLines 3000, -1000, -1000
	*/
	
	select * from #tApply
	
	
	select SUm(ToApply) From #tApply
	
	
	RETURN
GO
