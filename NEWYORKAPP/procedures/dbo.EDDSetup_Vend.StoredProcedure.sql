USE [NEWYORKAPP]
GO
/****** Object:  StoredProcedure [dbo].[EDDSetup_Vend]    Script Date: 12/21/2015 16:01:00 ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO
CREATE PROCEDURE [dbo].[EDDSetup_Vend]
AS
	SELECT *
	FROM EDDSetup
	WHERE DocType = 'U1'
 	ORDER BY DocType
GO
