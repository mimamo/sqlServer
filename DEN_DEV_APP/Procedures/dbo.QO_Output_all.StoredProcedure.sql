USE [DEN_DEV_APP]
GO
/****** Object:  StoredProcedure [dbo].[QO_Output_all]    Script Date: 12/21/2015 14:06:17 ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO
CREATE PROCEDURE [dbo].[QO_Output_all]
	@parm1 varchar( 7 ),
	@parm2 varchar( 30 )
AS
	SELECT *
	FROM QO_Output
	WHERE ScreenId LIKE @parm1
	   AND OutputId LIKE @parm2
	ORDER BY ScreenId,
	   OutputId
GO
