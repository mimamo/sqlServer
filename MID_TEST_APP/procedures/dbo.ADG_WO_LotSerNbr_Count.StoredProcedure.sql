USE [MID_TEST_APP]
GO
/****** Object:  StoredProcedure [dbo].[ADG_WO_LotSerNbr_Count]    Script Date: 12/21/2015 15:49:09 ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO
CREATE PROCEDURE [dbo].[ADG_WO_LotSerNbr_Count]
	@InvtID		varchar (30),
	@SiteID 	varchar (10),
	@LotSerNbr	varchar (25)

AS
	SELECT	Count(*)
	FROM 	LotSerMst
	WHERE	InvtID like @InvtID
	  AND 	SiteID like @SiteID
	  AND 	LotSerNbr like @LotSerNbr

-- Copyright 1998 by Advanced Distribution Group, Ltd. All rights reserved.
GO
