USE [DENVERAPP]
GO
/****** Object:  StoredProcedure [dbo].[DMG_ReasonCdValid]    Script Date: 12/21/2015 15:42:49 ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO
create procedure [dbo].[DMG_ReasonCdValid]
	@ReasonCd	varchar(6)
as
	if (
	select	count(*)
	from	ReasonCode (NOLOCK)
	where	ReasonCd = @ReasonCd
	) = 0
		--select 0
		return 0	--Failure
	else
		--select 1
		return 1	--Success
GO
