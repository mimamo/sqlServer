USE [DEN_DEV_APP]
GO
/****** Object:  StoredProcedure [dbo].[DMG_SOHeader_TotMerch]    Script Date: 12/21/2015 14:06:01 ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO
CREATE PROCEDURE [dbo].[DMG_SOHeader_TotMerch]
	@CpnyID varchar(10),
	@OrdNbr varchar(15)
AS
	select	TotMerch
	from	SOHeader
	where	CpnyID = @CpnyID
	and	OrdNbr = @OrdNbr

-- Copyright 1998 by Advanced Distribution Group, Ltd. All rights reserved.
GO
