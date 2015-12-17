USE [SHOPPER_DEV_APP]
GO
/****** Object:  StoredProcedure [dbo].[FMG_ARStmtValid]    Script Date: 12/16/2015 15:55:22 ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO
create procedure [dbo].[FMG_ARStmtValid]
	@StmtCycleId	varchar(2)
as
	if (
	select	count(*)
	from	ARStmt (NOLOCK)
	where	StmtCycleId = @StmtCycleId
	) = 0
		--select 0
		return 0	--Failure
	else
		--select 1
		return 1	--Success
GO
