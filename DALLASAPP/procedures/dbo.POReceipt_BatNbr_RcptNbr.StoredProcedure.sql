USE [DALLASAPP]
GO
/****** Object:  StoredProcedure [dbo].[POReceipt_BatNbr_RcptNbr]    Script Date: 12/21/2015 13:45:02 ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO
CREATE PROCEDURE [dbo].[POReceipt_BatNbr_RcptNbr]
	@parm1 varchar( 10 ),
	@parm2 varchar( 10 )
AS
	SELECT *
	FROM POReceipt
	WHERE BatNbr LIKE @parm1
	   AND RcptNbr LIKE @parm2
	ORDER BY BatNbr,
	   RcptNbr

-- Copyright 1998, 1999, 2000, 2001 by Solomon Software, Inc. All rights reserved.
GO
