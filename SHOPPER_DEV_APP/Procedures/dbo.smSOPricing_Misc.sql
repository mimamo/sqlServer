USE [SHOPPER_DEV_APP]
GO
/****** Object:  StoredProcedure [dbo].[smSOPricing_Misc]    Script Date: 12/16/2015 15:55:35 ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO
CREATE PROCEDURE [dbo].[smSOPricing_Misc]
	@parm1 varchar( 15 ),
	@parm2 varchar( 10 ),
	@parm3 varchar( 30 )
AS
	SELECT *
	FROM smSOPricing
	WHERE CustID LIKE @parm1
	   AND ShipToID LIKE @parm2
	   AND Invtid LIKE @parm3
	ORDER BY
	   CustID,
	   ShipToID,
	   Invtid

-- Copyright 1998, 1999 by Solomon Software, Inc. All rights reserved.
GO
