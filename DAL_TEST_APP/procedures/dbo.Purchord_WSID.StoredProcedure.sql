USE [DAL_TEST_APP]
GO
/****** Object:  StoredProcedure [dbo].[Purchord_WSID]    Script Date: 12/21/2015 13:57:12 ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO
CREATE PROCEDURE [dbo].[Purchord_WSID] @parm1 int
AS
	SELECT *
	FROM Purchord
	WHERE WSID = @parm1
	ORDER BY WSID
GO
