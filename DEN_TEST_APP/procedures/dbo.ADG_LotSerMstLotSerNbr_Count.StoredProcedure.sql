USE [DEN_TEST_APP]
GO
/****** Object:  StoredProcedure [dbo].[ADG_LotSerMstLotSerNbr_Count]    Script Date: 12/21/2015 15:36:45 ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO
CREATE PROCEDURE [dbo].[ADG_LotSerMstLotSerNbr_Count]
	@LotSerNbr 	varchar (25)
AS
	SELECT	Count(*)
	FROM 	LotSerMst
        WHERE 	LotSerNbr like @LotSerNbr

-- Copyright 1998 by Advanced Distribution Group, Ltd. All rights reserved.
GO
