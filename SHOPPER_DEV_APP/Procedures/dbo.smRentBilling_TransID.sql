USE [SHOPPER_DEV_APP]
GO
/****** Object:  StoredProcedure [dbo].[smRentBilling_TransID]    Script Date: 12/16/2015 15:55:34 ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO
CREATE PROCEDURE
	[dbo].[smRentBilling_TransID]
		@parm1	varchar(10)
		,@parm2	varchar(10)
AS
	SELECT
		*
	FROM
		smRentBilling
	WHERE
		TransID = @parm1
			AND
		OrdNbr LIKE @parm2
	ORDER BY
		TransID,
		OrdNbr DESC

-- Copyright 1998, 1999 by Solomon Software, Inc. All rights reserved.
GO
