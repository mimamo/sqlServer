USE [NEWYORKAPP]
GO
/****** Object:  StoredProcedure [dbo].[FMG_TerritoryValid]    Script Date: 12/21/2015 16:01:02 ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO
create procedure [dbo].[FMG_TerritoryValid]
	@Territory	varchar(10)
as
	if (
	select	count(*)
	from	Territory (NOLOCK)
	where	Territory = @Territory
	) = 0
		--select 0
		return 0	--Failure
	else
		--select 1
		return 1	--Success
GO
