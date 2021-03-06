USE [SHOPPER_DEV_APP]
GO
/****** Object:  StoredProcedure [dbo].[smConDiscount_all]    Script Date: 12/21/2015 14:34:38 ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO
CREATE PROCEDURE [dbo].[smConDiscount_all]
	@parm1 varchar( 10 ),
	@parm2min smalldatetime, @parm2max smalldatetime
AS
	SELECT *
	FROM smConDiscount
	WHERE ContractID LIKE @parm1
	   AND AccrueDate BETWEEN @parm2min AND @parm2max
	ORDER BY ContractID,
	   AccrueDate

-- Copyright 1998, 1999 by Solomon Software, Inc. All rights reserved.
GO
