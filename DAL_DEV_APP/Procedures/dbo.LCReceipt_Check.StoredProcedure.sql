USE [DAL_DEV_APP]
GO
/****** Object:  StoredProcedure [dbo].[LCReceipt_Check]    Script Date: 12/21/2015 13:35:46 ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO
CREATE PROCEDURE [dbo].[LCReceipt_Check]
	@parm1 varchar( 10 )
	AS
	SELECT *
	FROM LCReceipt
	WHERE RcptNbr LIKE @parm1

	ORDER BY RcptNbr,
	   LineNbr

-- Copyright 1998, 1999, 2000, 2001 by Solomon Software, Inc. All rights reserved.
GO
