USE [DALLASAPP]
GO
/****** Object:  StoredProcedure [dbo].[Purchord_ASID]    Script Date: 12/21/2015 13:45:04 ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO
CREATE PROCEDURE [dbo].[Purchord_ASID] @parm1 int
AS
	SELECT *
	FROM Purchord
	WHERE ASID = @parm1
	ORDER BY ASID
GO
