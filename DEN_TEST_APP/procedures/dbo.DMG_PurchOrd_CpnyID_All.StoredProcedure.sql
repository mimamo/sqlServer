USE [DEN_TEST_APP]
GO
/****** Object:  StoredProcedure [dbo].[DMG_PurchOrd_CpnyID_All]    Script Date: 12/21/2015 15:36:52 ******/
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
