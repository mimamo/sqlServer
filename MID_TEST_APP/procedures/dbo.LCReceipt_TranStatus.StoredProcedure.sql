USE [MID_TEST_APP]
GO
/****** Object:  StoredProcedure [dbo].[LCReceipt_TranStatus]    Script Date: 12/21/2015 15:49:24 ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO
CREATE PROCEDURE [dbo].[LCReceipt_TranStatus]
	@parm1 varchar( 1 )
AS
	SELECT *
	FROM LCReceipt
	WHERE TranStatus LIKE @parm1
	ORDER BY TranStatus

-- Copyright 1998, 1999, 2000, 2001 by Solomon Software, Inc. All rights reserved.
GO
