USE [MIDWESTAPP]
GO
/****** Object:  StoredProcedure [dbo].[LCVoucher_VendID]    Script Date: 12/21/2015 15:55:34 ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO
CREATE PROCEDURE [dbo].[LCVoucher_VendID]
	@parm1 varchar( 15 )
AS
	SELECT *
	FROM LCVoucher
	WHERE VendID LIKE @parm1
	ORDER BY VendID

-- Copyright 1998, 1999, 2000, 2001 by Solomon Software, Inc. All rights reserved.
GO
