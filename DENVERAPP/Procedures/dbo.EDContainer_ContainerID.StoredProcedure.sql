USE [DENVERAPP]
GO
/****** Object:  StoredProcedure [dbo].[EDContainer_ContainerID]    Script Date: 12/21/2015 15:42:52 ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO
CREATE PROCEDURE [dbo].[EDContainer_ContainerID]
	@parm1 varchar( 10 )
AS
	SELECT *
	FROM EDContainer
	WHERE ContainerID LIKE @parm1
	ORDER BY ContainerID
GO
