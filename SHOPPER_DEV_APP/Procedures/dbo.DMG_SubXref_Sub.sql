USE [SHOPPER_DEV_APP]
GO
/****** Object:  StoredProcedure [dbo].[DMG_SubXref_Sub]    Script Date: 12/16/2015 15:55:18 ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO
Create Procedure [dbo].[DMG_SubXref_Sub]

	@CpnyID varchar(10),
	@Sub varchar(24)

WITH EXECUTE AS '07718158D19D4f5f9D23B55DBF5DF1'
as

	select	*
	from	vs_SubXRef
	where	CpnyID = @CpnyID
	and	Active = 1
	and	Sub Like @Sub
	order by Sub
	-- Copyright 1998 by Advanced Distribution Group, Ltd. All rights reserved.
GO
