USE [SHOPPER_DEV_APP]
GO
/****** Object:  StoredProcedure [dbo].[INProdClDfltSites_all]    Script Date: 12/16/2015 15:55:23 ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO
CREATE PROCEDURE [dbo].[INProdClDfltSites_all]
	@parm1 varchar( 6 ),
	@parm2 varchar( 10 )
AS
	SELECT *
	FROM INProdClDfltSites
	WHERE ClassID LIKE @parm1
	   AND CpnyID LIKE @parm2
	ORDER BY ClassID,
	   CpnyID

-- Copyright 1998, 1999, 2000, 2001 by Solomon Software, Inc. All rights reserved.
GO
