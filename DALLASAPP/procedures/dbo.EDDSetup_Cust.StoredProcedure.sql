USE [DALLASAPP]
GO
/****** Object:  StoredProcedure [dbo].[EDDSetup_Cust]    Script Date: 12/21/2015 13:44:53 ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO
CREATE PROCEDURE [dbo].[EDDSetup_Cust]
AS
	SELECT *
	FROM EDDSetup
	WHERE DocType <> 'U1'
 	ORDER BY DocType
GO
