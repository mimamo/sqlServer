USE [SHOPPER_DEV_APP]
GO
/****** Object:  StoredProcedure [dbo].[SOPlan_DisplaySeq]    Script Date: 12/16/2015 15:55:35 ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO
CREATE PROCEDURE [dbo].[SOPlan_DisplaySeq]
	@parm1 varchar( 36 )
AS
	SELECT *
	FROM SOPlan
	WHERE DisplaySeq LIKE @parm1
	ORDER BY DisplaySeq

-- Copyright 1998, 1999, 2000, 2001 by Solomon Software, Inc. All rights reserved.
GO
