USE [SHOPPER_TEST_APP]
GO
/****** Object:  StoredProcedure [dbo].[POProjAppr_Project]    Script Date: 12/21/2015 16:07:15 ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO
CREATE PROCEDURE [dbo].[POProjAppr_Project]
	@parm1 varchar( 16 )
AS
	SELECT *
	FROM POProjAppr
	WHERE Project LIKE @parm1
	ORDER BY Project

-- Copyright 1998 by Advanced Distribution Group, Ltd. All rights reserved.
GO
