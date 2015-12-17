USE [SHOPPER_DEV_APP]
GO
/****** Object:  StoredProcedure [dbo].[ADG_SlsPrcDet_ConvertChainDisc]    Script Date: 12/16/2015 15:55:11 ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO
CREATE PROCEDURE [dbo].[ADG_SlsPrcDet_ConvertChainDisc]

AS
	Declare @DfltDiscountID VarChar(1)
		Select @DfltDiscountID = dfltdiscountid from SOSetup

	UPDATE	SlsPrcDet
	Set		S4Future01 = @DfltDiscountID + rtrim(Convert(varchar(29), DiscPct))
	WHERE	S4Future01 = ''
	-- Copyright 1998 by Advanced Distribution Group, Ltd. All rights reserved.
GO
