USE [DALLASAPP]
GO
/****** Object:  StoredProcedure [dbo].[sm_INTran_ExtRefNbr]    Script Date: 12/21/2015 13:45:07 ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO
CREATE PROCEDURE
	[dbo].[sm_INTran_ExtRefNbr]
		@parm1 varchar(15)
AS
	SELECT
		*
	FROM
		INTran
	WHERE
		ExtRefNbr = @parm1
	-- Copyright 1998, 1999 by Solomon Software, Inc. All rights reserved.
GO
