USE [SHOPPERAPP]
GO
/****** Object:  StoredProcedure [dbo].[smConPricing_Misc]    Script Date: 12/21/2015 16:13:25 ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO
CREATE PROCEDURE [dbo].[smConPricing_Misc]
	@parm1 varchar( 10 ),
	@parm2 varchar( 30 )
AS
	SELECT *
	FROM smConPricing
	WHERE ContractID LIKE @parm1
	   AND Invtid LIKE @parm2
	ORDER BY ContractID,
	   Invtid

-- Copyright 1998, 1999 by Solomon Software, Inc. All rights reserved.
GO
