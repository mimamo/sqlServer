USE [NEWYORKAPP]
GO
/****** Object:  StoredProcedure [dbo].[DMG_PO_SOLine_BoundToWO]    Script Date: 12/21/2015 16:00:55 ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO
create procedure [dbo].[DMG_PO_SOLine_BoundToWO]
	@CpnyID		varchar(10),
	@OrdNbr		varchar(15),
	@LineRef	varchar(5),
	@BoundToWO	smallint OUTPUT
as
	select	@BoundToWO = BoundToWO
	from	SOLine (NOLOCK)
	where	CpnyID = @CpnyID
	and	OrdNbr = @OrdNbr
	and	LineRef = @LineRef

	if @@ROWCOUNT = 0 begin
		set @BoundToWO = 0
		return 0	--Failure
	end
	else
		return 1	--Success
GO
