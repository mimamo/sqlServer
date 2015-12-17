USE [SHOPPER_DEV_APP]
GO
/****** Object:  StoredProcedure [dbo].[LCVoucher_TranStatus]    Script Date: 12/16/2015 15:55:24 ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO
CREATE PROCEDURE [dbo].[LCVoucher_TranStatus]
	@parm1 varchar( 1 )
AS
	SELECT *
	FROM LCVoucher
	WHERE TranStatus LIKE @parm1
	ORDER BY TranStatus

-- Copyright 1998, 1999, 2000, 2001 by Solomon Software, Inc. All rights reserved.
GO
