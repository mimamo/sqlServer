USE [DAL_TEST_APP]
GO
/****** Object:  StoredProcedure [dbo].[LCVoucher_APLineRef]    Script Date: 12/21/2015 13:57:04 ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO
CREATE PROCEDURE [dbo].[LCVoucher_APLineRef]
	@parm1 varchar( 5 )
AS
	SELECT *
	FROM LCVoucher
	WHERE APLineRef LIKE @parm1
	ORDER BY APLineRef

-- Copyright 1998, 1999, 2000, 2001 by Solomon Software, Inc. All rights reserved.
GO
