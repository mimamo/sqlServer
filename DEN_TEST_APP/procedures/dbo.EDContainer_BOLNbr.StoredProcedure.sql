USE [DEN_TEST_APP]
GO
/****** Object:  StoredProcedure [dbo].[EDContainer_BOLNbr]    Script Date: 12/21/2015 15:36:54 ******/
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
