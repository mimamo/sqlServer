USE [DAL_DEV_APP]
GO
/****** Object:  StoredProcedure [dbo].[INTran_BatNbr_KitID_InvtID]    Script Date: 12/21/2015 13:35:45 ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO
CREATE PROCEDURE [dbo].[INTran_BatNbr_KitID_InvtID]
	@parm1 varchar( 10 ),
	@parm2 varchar( 30 ),
	@parm3 varchar( 30 )
AS
	SELECT *
	FROM INTran
	WHERE BatNbr LIKE @parm1
	   AND KitID LIKE @parm2
	   AND InvtID LIKE @parm3
	ORDER BY BatNbr,
	   KitID,
	   InvtID

-- Copyright 1998, 1999, 2000, 2001 by Solomon Software, Inc. All rights reserved.
GO
