USE [DAL_DEV_APP]
GO
/****** Object:  StoredProcedure [dbo].[EDDSetup_Vend]    Script Date: 12/21/2015 13:35:43 ******/
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
