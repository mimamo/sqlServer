USE [DEN_DEV_APP]
GO
/****** Object:  StoredProcedure [dbo].[EDOutbound_all]    Script Date: 12/21/2015 14:06:04 ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO
CREATE PROCEDURE [dbo].[EDOutbound_all]
	@parm1 varchar( 3 )
AS
	SELECT *
	FROM EDOutbound
	WHERE ReleaseNbr LIKE @parm1
	ORDER BY ReleaseNbr
GO
