USE [SHOPPER_DEV_APP]
GO
/****** Object:  StoredProcedure [dbo].[DMG_PO_PJCODEValid]    Script Date: 12/16/2015 15:55:17 ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO
create procedure [dbo].[DMG_PO_PJCODEValid]
	@code_type	varchar(4),
	@code_value	varchar(30)
as
	if (
	select	count(*)
	from	PJCODE (NOLOCK)
	where	code_type = @code_type
	and	code_value = @code_value
	) = 0
		--select 0
		return 0	--Failure
	else
		--select 1
		return 1	--Success
GO
