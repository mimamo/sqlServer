USE [SHOPPER_DEV_APP]
GO
/****** Object:  StoredProcedure [dbo].[DMG_OrdNbrValid]    Script Date: 12/16/2015 15:55:17 ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO
create procedure [dbo].[DMG_OrdNbrValid]
	@CpnyID	varchar(10),
	@OrdNbr	varchar(15)
as
	if (
	select	count(*)
	from	SOHeader (NOLOCK)
	where	CpnyID = @CpnyID
	and	OrdNbr = @OrdNbr
	) = 0
		--select 0
		return 0	--Failure
	else
		--select 1
		return 1	--Success
GO
