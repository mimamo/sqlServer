USE [MID_DEV_APP]
GO
/****** Object:  StoredProcedure [dbo].[DMG_SlsPerIDValid]    Script Date: 12/21/2015 14:17:37 ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO
create procedure [dbo].[DMG_SlsPerIDValid]
	@SlsPerID	varchar(10)
as
	if (
	select	count(*)
	from	Salesperson (NOLOCK)
	where	SlsPerID = @SlsPerID
	) = 0
		--select 0
		return 0	--Failure
	else
		--select 1
		return 1	--Success
GO
