USE [DAL_DEV_APP]
GO
/****** Object:  StoredProcedure [dbo].[SlsperQuota_all]    Script Date: 12/21/2015 13:35:55 ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO
CREATE PROCEDURE [dbo].[SlsperQuota_all]
	@parm1 varchar( 10 ),
	@parm2 varchar( 6 )
AS
	SELECT *
	FROM SlsperQuota
	WHERE SlsperID LIKE @parm1
	   AND PerNbr LIKE @parm2
	ORDER BY SlsperID,
	   PerNbr

-- Copyright 1998 by Advanced Distribution Group, Ltd. All rights reserved.
GO
