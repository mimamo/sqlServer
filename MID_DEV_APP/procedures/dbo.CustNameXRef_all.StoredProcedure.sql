USE [MID_DEV_APP]
GO
/****** Object:  StoredProcedure [dbo].[CustNameXRef_all]    Script Date: 12/21/2015 14:17:35 ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO
CREATE PROCEDURE [dbo].[CustNameXRef_all]
	@parm1 varchar( 15 ),
	@parm2 varchar( 20 )
AS
	SELECT *
	FROM CustNameXRef
	WHERE CustID LIKE @parm1
	   AND NameSeg LIKE @parm2
	ORDER BY CustID,
	   NameSeg

-- Copyright 1998 by Advanced Distribution Group, Ltd. All rights reserved.
GO
