USE [SHOPPER_DEV_APP]
GO
/****** Object:  StoredProcedure [dbo].[DMG_ShipToIDValid]    Script Date: 12/16/2015 15:55:18 ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO
create procedure [dbo].[DMG_ShipToIDValid]
	@CustID		varchar(15),
	@ShipToID	varchar(10)
as
	if (
	select	count(*)
	from	SOAddress (NOLOCK)
	where	CustID = @CustID
	and	ShipToID = @ShipToID
	) = 0
		--select 0
		return 0	--Failure
	else
		--select 1
		return 1	--Success
GO
