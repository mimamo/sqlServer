USE [DEN_TEST_APP]
GO
/****** Object:  StoredProcedure [dbo].[EDSetup_all]    Script Date: 12/21/2015 15:36:55 ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO
CREATE PROCEDURE [dbo].[EDSetup_all]
	@parm1 varchar( 2 )
AS
	SELECT *
	FROM EDSetup
	WHERE SetUpID LIKE @parm1
	ORDER BY SetUpID
GO
