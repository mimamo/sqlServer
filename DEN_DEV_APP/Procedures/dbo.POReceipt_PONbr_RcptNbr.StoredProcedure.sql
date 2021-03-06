USE [DEN_DEV_APP]
GO
/****** Object:  StoredProcedure [dbo].[POReceipt_PONbr_RcptNbr]    Script Date: 12/21/2015 14:06:14 ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO
CREATE PROCEDURE [dbo].[POReceipt_PONbr_RcptNbr]
	@parm1 varchar( 10 ),
	@parm2 varchar( 10 )
AS
	SELECT distinct r.*
	FROM POReceipt r
	inner join potran t on t.rcptnbr = r.rcptnbr
	WHERE r.PONbr LIKE @parm1
	   AND t.RcptNbr LIKE @parm2
	ORDER BY r.PONbr,
	   r.RcptNbr

-- Copyright 1998, 1999, 2000, 2001 by Solomon Software, Inc. All rights reserved.
GO
