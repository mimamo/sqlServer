USE [SHOPPER_DEV_APP]
GO
/****** Object:  StoredProcedure [dbo].[smConPricing_ContractID]    Script Date: 12/21/2015 14:34:38 ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO
CREATE PROCEDURE [dbo].[smConPricing_ContractID]
	@parm1 varchar( 10 ),
	@parm2 varchar( 30 )
AS
	SELECT *
	FROM smConPricing
	WHERE ContractID = @parm1
	   AND Invtid LIKE @parm2
	ORDER BY  Invtid

-- Copyright 1998, 1999 by Solomon Software, Inc. All rights reserved.
GO
