USE [DAL_DEV_APP]
GO
/****** Object:  StoredProcedure [dbo].[POPurpose_all]    Script Date: 12/21/2015 13:35:51 ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO
CREATE PROCEDURE [dbo].[POPurpose_all]
	@parm1 varchar( 10 )
AS
	SELECT *
	FROM POPurpose
	WHERE ReqNbr LIKE @parm1
	ORDER BY ReqNbr

-- Copyright 1998 by Advanced Distribution Group, Ltd. All rights reserved.
GO
