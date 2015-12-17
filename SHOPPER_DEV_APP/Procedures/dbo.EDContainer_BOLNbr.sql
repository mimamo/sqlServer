USE [SHOPPER_DEV_APP]
GO
/****** Object:  StoredProcedure [dbo].[EDContainer_BOLNbr]    Script Date: 12/16/2015 15:55:20 ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO
CREATE PROCEDURE [dbo].[EDContainer_BOLNbr]
	@parm1 varchar( 20 )
AS
	SELECT *
	FROM EDContainer
	WHERE BOLNbr LIKE @parm1
	ORDER BY BOLNbr

-- Copyright 1998 by Advanced Distribution Group, Ltd. All rights reserved.
GO
