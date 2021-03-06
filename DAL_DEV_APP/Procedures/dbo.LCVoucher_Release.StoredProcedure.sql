USE [DAL_DEV_APP]
GO
/****** Object:  StoredProcedure [dbo].[LCVoucher_Release]    Script Date: 12/21/2015 13:35:46 ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO
CREATE PROCEDURE [dbo].[LCVoucher_Release]
	@parm1 varchar( 10 ),
	@parm2 varchar( 10 ),
	@parm3 varchar( 5 ),
	@parm4 varchar( 10 ),
	@parm5min smallint, @parm5max smallint
AS
	SELECT *
	FROM LCVoucher
	WHERE APBatNbr LIKE @parm1
	   AND APRefNbr LIKE @parm2
	   AND APLineRef LIKE @parm3
	   AND RcptNbr LIKE @parm4
	   AND LineNbr BETWEEN @parm5min AND @parm5max
	   AND TranStatus = 'U'
	ORDER BY APBatNbr,
	   APRefNbr,
	   APLineRef,
	   RcptNbr,
	   LineNbr

-- Copyright 1998, 1999, 2000, 2001 by Solomon Software, Inc. All rights reserved.
GO
