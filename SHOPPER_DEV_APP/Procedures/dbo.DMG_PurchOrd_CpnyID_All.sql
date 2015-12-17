USE [SHOPPER_DEV_APP]
GO
/****** Object:  StoredProcedure [dbo].[DMG_PurchOrd_CpnyID_All]    Script Date: 12/16/2015 15:55:17 ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO
create procedure [dbo].[DMG_PurchOrd_CpnyID_All]
	@CpnyID varchar(10),
	@PONbr varchar(10)
AS
	select	*
	from	PurchOrd
	where	CpnyID = @CpnyID
	and	PONbr LIKE @PONbr
	order by PONbr

-- Copyright 1998 by Advanced Distribution Group, Ltd. All rights reserved.
GO
