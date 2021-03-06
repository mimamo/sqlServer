USE [DAL_TEST_APP]
GO
/****** Object:  StoredProcedure [dbo].[SOHeader_OrdNbr_CpnyID]    Script Date: 12/21/2015 13:57:16 ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO
CREATE PROCEDURE [dbo].[SOHeader_OrdNbr_CpnyID]
	@parm1 varchar( 15 ),
	@parm2 varchar( 10 )
AS
	SELECT *
	FROM SOHeader
	WHERE OrdNbr LIKE @parm1
	   AND CpnyID LIKE @parm2
	ORDER BY OrdNbr,
	   CpnyID

-- Copyright 1998, 1999, 2000, 2001 by Solomon Software, Inc. All rights reserved.
GO
