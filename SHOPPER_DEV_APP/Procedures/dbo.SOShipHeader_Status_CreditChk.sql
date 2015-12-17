USE [SHOPPER_DEV_APP]
GO
/****** Object:  StoredProcedure [dbo].[SOShipHeader_Status_CreditChk]    Script Date: 12/16/2015 15:55:35 ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO
CREATE PROCEDURE [dbo].[SOShipHeader_Status_CreditChk]
	@parm1 varchar( 1 ),
	@parm2min smallint, @parm2max smallint
AS
	SELECT *
	FROM SOShipHeader
	WHERE Status LIKE @parm1
	   AND CreditChk BETWEEN @parm2min AND @parm2max
	ORDER BY Status,
	   CreditChk

-- Copyright 1998 by Advanced Distribution Group, Ltd. All rights reserved.
GO
