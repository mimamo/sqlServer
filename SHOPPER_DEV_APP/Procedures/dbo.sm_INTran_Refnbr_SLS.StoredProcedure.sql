USE [SHOPPER_DEV_APP]
GO
/****** Object:  StoredProcedure [dbo].[sm_INTran_Refnbr_SLS]    Script Date: 12/21/2015 14:34:38 ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO
CREATE PROCEDURE
	[dbo].[sm_INTran_Refnbr_SLS]
		@parm1 	varchar(10)
AS
	SELECT
		*
	FROM
		INTran
	WHERE
		RefNbr = @parm1
	-- Copyright 1998, 1999 by Solomon Software, Inc. All rights reserved.
GO
