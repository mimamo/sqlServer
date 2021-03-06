USE [MID_DEV_APP]
GO
/****** Object:  StoredProcedure [dbo].[smSOPricing_all]    Script Date: 12/21/2015 14:17:58 ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO
CREATE PROCEDURE [dbo].[smSOPricing_all]
	@parm1 varchar( 15 ),
	@parm2 varchar( 10 ),
	@parm3 varchar( 30 )
AS
	SELECT *
	FROM smSOPricing,Inventory
	WHERE CustID LIKE @parm1
	   AND ShipToID LIKE @parm2
	   AND smSoPricing.Invtid LIKE @parm3
	   AND smSOPricing.Invtid = Inventory.Invtid
	ORDER BY
	   smSoPricing.CustID,
	   smSoPricing.ShipToID,
	   smSoPricing.Invtid

-- Copyright 1998, 1999 by Solomon Software, Inc. All rights reserved.
GO
