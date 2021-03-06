USE [DALLASAPP]
GO
/****** Object:  StoredProcedure [dbo].[SOTax_all]    Script Date: 12/21/2015 13:45:09 ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO
CREATE PROCEDURE [dbo].[SOTax_all]
	@parm1 varchar( 10 ),
	@parm2 varchar( 15 ),
	@parm3 varchar( 10 ),
	@parm4 varchar( 10 )
AS
	SELECT *
	FROM SOTax
	WHERE CpnyID = @parm1
	   AND OrdNbr LIKE @parm2
	   AND TaxID LIKE @parm3
	   AND TaxCat LIKE @parm4
	ORDER BY CpnyID,
	   OrdNbr,
	   TaxID,
	   TaxCat

-- Copyright 1998 by Advanced Distribution Group, Ltd. All rights reserved.
GO
