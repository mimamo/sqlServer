USE [DALLASAPP]
GO
/****** Object:  StoredProcedure [dbo].[EDWrkLabelPrint_all]    Script Date: 12/21/2015 13:44:54 ******/
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
