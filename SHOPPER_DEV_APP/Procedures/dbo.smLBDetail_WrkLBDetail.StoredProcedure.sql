USE [SHOPPER_DEV_APP]
GO
/****** Object:  StoredProcedure [dbo].[smLBDetail_WrkLBDetail]    Script Date: 12/21/2015 14:34:38 ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO
CREATE PROCEDURE [dbo].[smLBDetail_WrkLBDetail]
			@parm1 smalldatetime
			,@parm2 smalldatetime
AS
SELECT * FROM smLBDETAIL
	WHERE
		TranDate >= @parm1 AND
		TranDate <= @parm2
	ORDER BY
		ServiceCallID

-- Copyright 1998, 1999 by Solomon Software, Inc. All rights reserved.
GO
