USE [DALLASAPP]
GO
/****** Object:  StoredProcedure [dbo].[smContract_SD200]    Script Date: 12/21/2015 13:45:07 ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO
CREATE PROCEDURE
	[dbo].[smContract_SD200]
		@parm1 	varchar(10)
AS
	SELECT
		PrimaryTech, SecondTech
	FROM
		smContract (NOLOCK)
	WHERE
		ContractID = @parm1
GO
