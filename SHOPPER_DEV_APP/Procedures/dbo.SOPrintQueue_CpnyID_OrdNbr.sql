USE [SHOPPER_DEV_APP]
GO
/****** Object:  StoredProcedure [dbo].[SOPrintQueue_CpnyID_OrdNbr]    Script Date: 12/16/2015 15:55:35 ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO
CREATE PROCEDURE [dbo].[SOPrintQueue_CpnyID_OrdNbr]
	@parm1 varchar( 10 ),
	@parm2 varchar( 15 )
AS
	SELECT *
	FROM SOPrintQueue
	WHERE CpnyID LIKE @parm1
	   AND OrdNbr LIKE @parm2
	ORDER BY CpnyID,
	   OrdNbr

-- Copyright 1998 by Advanced Distribution Group, Ltd. All rights reserved.
GO
