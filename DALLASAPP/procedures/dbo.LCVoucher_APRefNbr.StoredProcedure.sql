USE [DALLASAPP]
GO
/****** Object:  StoredProcedure [dbo].[LCVoucher_APRefNbr]    Script Date: 12/21/2015 13:44:57 ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO
CREATE PROCEDURE [dbo].[LCVoucher_APRefNbr]
	@parm1 varchar( 10 )
AS
	SELECT *
	FROM LCVoucher
	WHERE APRefNbr LIKE @parm1
	ORDER BY APRefNbr

-- Copyright 1998, 1999, 2000, 2001 by Solomon Software, Inc. All rights reserved.
GO
