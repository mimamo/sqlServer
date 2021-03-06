USE [DENVERAPP]
GO
/****** Object:  StoredProcedure [dbo].[SOShipTax_all]    Script Date: 12/21/2015 15:43:11 ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO
CREATE PROCEDURE [dbo].[SOShipTax_all]
	@parm1 varchar( 10 ),
	@parm2 varchar( 15 ),
	@parm3 varchar( 10 ),
	@parm4 varchar( 10 )
AS
	SELECT *
	FROM SOShipTax
	WHERE CpnyID = @parm1
	   AND ShipperID LIKE @parm2
	   AND TaxID LIKE @parm3
	   AND TaxCat LIKE @parm4
	ORDER BY CpnyID,
	   ShipperID,
	   TaxID,
	   TaxCat

-- Copyright 1998 by Advanced Distribution Group, Ltd. All rights reserved.
GO
