USE [SHOPPERAPP]
GO
/****** Object:  StoredProcedure [dbo].[EDWrkLabelPrint_all]    Script Date: 12/21/2015 16:13:13 ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO
CREATE PROCEDURE [dbo].[EDWrkLabelPrint_all]
	@parm1 varchar( 10 )
AS
	SELECT *
	FROM EDWrkLabelPrint
	WHERE ContainerID LIKE @parm1
	ORDER BY ContainerID

-- Copyright 1998 by Advanced Distribution Group, Ltd. All rights reserved.
GO
