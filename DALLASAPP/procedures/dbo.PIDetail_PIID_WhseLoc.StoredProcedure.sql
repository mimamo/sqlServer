USE [DALLASAPP]
GO
/****** Object:  StoredProcedure [dbo].[PIDetail_PIID_WhseLoc]    Script Date: 12/21/2015 13:44:58 ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO
CREATE PROCEDURE [dbo].[PIDetail_PIID_WhseLoc]
	@parm1 varchar( 10 ),
	@parm2 varchar( 10 )
AS
	SELECT *
	FROM PIDetail
	WHERE PIID LIKE @parm1
	   AND WhseLoc LIKE @parm2
	ORDER BY PIID,
	   WhseLoc

-- Copyright 1998, 1999, 2000, 2001 by Solomon Software, Inc. All rights reserved.
GO
