USE [MID_DEV_APP]
GO
/****** Object:  StoredProcedure [dbo].[smAgrPricing_all]    Script Date: 12/21/2015 14:17:56 ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO
CREATE PROCEDURE [dbo].[smAgrPricing_all]
	@parm1 varchar( 10 ),
	@parm2 varchar( 30 )
AS
	SELECT *
	FROM smAgrPricing, Inventory
	WHERE AgreementID LIKE @parm1
	   AND smAgrPricing.Invtid LIKE @parm2
	   AND smAgrPricing.Invtid = Inventory.Invtid
	ORDER BY
	   smAgrPricing.AgreementID,
	   smAgrPricing.Invtid

-- Copyright 1998, 1999 by Solomon Software, Inc. All rights reserved.
GO
