USE [DAL_TEST_APP]
GO
/****** Object:  StoredProcedure [dbo].[LCReceipt_RcptNbr_INBatNbr]    Script Date: 12/21/2015 13:57:04 ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO
CREATE PROCEDURE [dbo].[LCReceipt_RcptNbr_INBatNbr]
	@parm1 varchar( 10 )
AS
	SELECT *
	FROM LCReceipt
	WHERE RcptNbr LIKE @parm1
		and Inbatnbr > ''
	-- Copyright 1998, 1999, 2000, 2001 by Solomon Software, Inc. All rights reserved.
GO
