USE [SHOPPER_TEST_APP]
GO
/****** Object:  StoredProcedure [dbo].[sm_SalesTax_All]    Script Date: 12/21/2015 16:07:19 ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO
CREATE PROCEDURE
	[dbo].[sm_SalesTax_All]
		@parm1	varchar(10)
AS
	SELECT
		*
	FROM
		SalesTax
	WHERE
		TaxId LIKE @parm1
	ORDER BY
		TaxId

-- Copyright 1998, 1999 by Solomon Software, Inc. All rights reserved.
GO
