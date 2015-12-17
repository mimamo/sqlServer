USE [SHOPPER_DEV_APP]
GO
/****** Object:  StoredProcedure [dbo].[SODiscCode_all]    Script Date: 12/16/2015 15:55:35 ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO
CREATE PROCEDURE [dbo].[SODiscCode_all]
	@parm1 varchar( 10 ),
	@parm2 varchar( 1 )
AS
	SELECT *
	FROM SODiscCode
	WHERE CpnyID LIKE @parm1
	   AND DiscountID LIKE @parm2
	ORDER BY CpnyID,
	   DiscountID

-- Copyright 1998 by Advanced Distribution Group, Ltd. All rights reserved.
GO
