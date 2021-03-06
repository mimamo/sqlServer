USE [DAL_DEV_APP]
GO
/****** Object:  StoredProcedure [dbo].[SOHeader_CustID_Status_CpnyID_]    Script Date: 12/21/2015 13:35:57 ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO
CREATE PROCEDURE [dbo].[SOHeader_CustID_Status_CpnyID_]
	@parm1 varchar( 15 ),
	@parm2 varchar( 1 ),
	@parm3 varchar( 10 ),
	@parm4 varchar( 15 )
AS
	SELECT *
	FROM SOHeader
	WHERE CustID LIKE @parm1
	   AND Status LIKE @parm2
	   AND CpnyID LIKE @parm3
	   AND OrdNbr LIKE @parm4
	ORDER BY CustID,
	   Status,
	   CpnyID,
	   OrdNbr

-- Copyright 1998, 1999, 2000, 2001 by Solomon Software, Inc. All rights reserved.
GO
