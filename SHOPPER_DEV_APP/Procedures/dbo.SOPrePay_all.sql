USE [SHOPPER_DEV_APP]
GO
/****** Object:  StoredProcedure [dbo].[SOPrePay_all]    Script Date: 12/16/2015 15:55:35 ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO
CREATE PROCEDURE [dbo].[SOPrePay_all]
	@parm1 varchar( 10 ),
	@parm2 varchar( 15 ),
	@parm3 varchar( 5 )
AS
	SELECT *
	FROM SOPrePay
	WHERE CpnyID = @parm1
	   AND OrdNbr LIKE @parm2
	   AND PmtRef LIKE @parm3
	ORDER BY CpnyID,
	   OrdNbr,
	   PmtRef

-- Copyright 1998 by Advanced Distribution Group, Ltd. All rights reserved.
GO
