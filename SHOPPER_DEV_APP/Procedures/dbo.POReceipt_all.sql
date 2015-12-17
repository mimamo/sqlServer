USE [SHOPPER_DEV_APP]
GO
/****** Object:  StoredProcedure [dbo].[POReceipt_all]    Script Date: 12/16/2015 15:55:29 ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO
CREATE PROCEDURE [dbo].[POReceipt_all]
	@parm1 varchar( 10 )
AS
	SELECT *
	FROM POReceipt
	WHERE RcptNbr LIKE @parm1
	ORDER BY RcptNbr

-- Copyright 1998, 1999, 2000, 2001 by Solomon Software, Inc. All rights reserved.
GO
