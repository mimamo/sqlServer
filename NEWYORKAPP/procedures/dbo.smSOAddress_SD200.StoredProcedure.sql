USE [NEWYORKAPP]
GO
/****** Object:  StoredProcedure [dbo].[smSOAddress_SD200]    Script Date: 12/21/2015 16:01:20 ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO
CREATE PROCEDURE
	[dbo].[smSOAddress_SD200]
		@parm1 	varchar(15),
		@parm2 	varchar(10)
AS
	SELECT
		DefaultTechnician
	FROM
		smSOAddress (NOLOCK)
	WHERE
		CustID = @parm1 	AND
		ShiptoID = @parm2
GO
