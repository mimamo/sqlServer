USE [DALLASAPP]
GO
/****** Object:  StoredProcedure [dbo].[EDDSetup_all]    Script Date: 12/21/2015 13:44:53 ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO
CREATE PROCEDURE [dbo].[EDDSetup_all] @parm1 varchar(10)
AS
	SELECT *
	FROM EDDSetup
	WHERE DocType LIKE @parm1
	ORDER BY DocType
GO
