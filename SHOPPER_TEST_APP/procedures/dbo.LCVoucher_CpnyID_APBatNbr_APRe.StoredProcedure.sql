USE [SHOPPER_TEST_APP]
GO
/****** Object:  StoredProcedure [dbo].[LCVoucher_CpnyID_APBatNbr_APRe]    Script Date: 12/21/2015 16:07:10 ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO
CREATE PROCEDURE [dbo].[LCVoucher_CpnyID_APBatNbr_APRe]
	@parm1 varchar( 10 ),
	@parm2 varchar( 10 ),
	@parm3 varchar( 10 )
AS
	SELECT *
	FROM LCVoucher
	WHERE CpnyID LIKE @parm1
	   AND APBatNbr LIKE @parm2
	   AND APRefNbr LIKE @parm3
	ORDER BY CpnyID,
	   APBatNbr,
	   APRefNbr

-- Copyright 1998, 1999, 2000, 2001 by Solomon Software, Inc. All rights reserved.
GO
