USE [DENVERAPP]
GO
/****** Object:  StoredProcedure [dbo].[EDDSetup_Cust]    Script Date: 12/21/2015 15:42:52 ******/
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
