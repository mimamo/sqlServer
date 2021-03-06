USE [MID_DEV_APP]
GO
/****** Object:  StoredProcedure [dbo].[INTran_BatNbr_Acct_Sub]    Script Date: 12/21/2015 14:17:45 ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO
CREATE PROCEDURE [dbo].[INTran_BatNbr_Acct_Sub]
	@parm1 varchar( 10 ),
	@parm2 varchar( 10 ),
	@parm3 varchar( 24 )
AS
	SELECT *
	FROM INTran
	WHERE BatNbr LIKE @parm1
	   AND Acct LIKE @parm2
	   AND Sub LIKE @parm3
	ORDER BY BatNbr,
	   Acct,
	   Sub

-- Copyright 1998, 1999, 2000, 2001 by Solomon Software, Inc. All rights reserved.
GO
