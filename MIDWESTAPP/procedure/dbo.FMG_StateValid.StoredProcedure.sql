USE [MIDWESTAPP]
GO
/****** Object:  StoredProcedure [dbo].[FMG_StateValid]    Script Date: 12/21/2015 15:55:32 ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO
create procedure [dbo].[FMG_StateValid]
	@StateProvID	varchar(3)
as
	if (
	select	count(*)
	from	State (NOLOCK)
	where	StateProvID = @StateProvID
	) = 0
		--select 0
		return 0	--Failure
	else
		--select 1
		return 1	--Success
GO
