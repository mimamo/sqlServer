USE [SHOPPER_DEV_APP]
GO
/****** Object:  StoredProcedure [dbo].[IN10990_Lot_all]    Script Date: 12/16/2015 15:55:23 ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO
CREATE PROCEDURE [dbo].[IN10990_Lot_all]
	@parm1min int, @parm1max int
AS
	SELECT *
	FROM IN10990_Lot
	WHERE LineID BETWEEN @parm1min AND @parm1max
	ORDER BY LineID

-- Copyright 1998, 1999 by Solomon Software, Inc. All rights reserved.
GO
